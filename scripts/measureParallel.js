#!/usr/bin/env node
/* global process */
/**
 * Measures independent reads one after another against side by side (Step 5.3).
 *
 * Step 5's exit is "measured before and after". Before is PARALLEL_READS=1,
 * which reads exactly as the code did; after is the configured width. Both
 * run in this one process against the same warm pool, alternating, so a cold
 * cache or a busy moment cannot favour one side, and the median of each is
 * reported.
 *
 *   node scripts/measureParallel.js --copy=NSCC --user=1 --record --codes
 *   node scripts/measureParallel.js --copy=Demo --user=1 --record=Stor/Items:25 --codes=Stor
 *
 * --user     a user id: times the profile the client loads after signing in
 * --record   Package/Entity[:id] of a master with child grids: times opening
 *            it; without an id, its first record; alone, the master with the
 *            most grids this copy has a record of
 * --codes    a package: times its code tables; alone, the package with the
 *            most code tables this copy can read
 * --runs     how many of each (default 15)
 * --width    the side-by-side width (default PARALLEL_READS, else 4)
 *
 * Needs the database, so it runs where the tenant's schema is reachable.
 */

const path = require('path');

const args = Object.fromEntries(process.argv.slice(2).map((arg) => {
  const [key, ...rest] = arg.replace(/^--/, '').split('=');
  return [key, rest.join('=') || true];
}));

const copy = args.copy || 'Demo';
const runs = parseInt(args.runs || '15', 10);

async function main() {
  // Quiet: the pool logs every statement, which would swamp the numbers.
  const log = console.log;
  console.log = () => {};
  const logger = require('../utils/logger');
  logger.silent = true;
  const say = (line) => log(line);

  const env = require('../config/env');
  const mainApp = require('../metadata/registry');
  const connectionPool = require('../core/connectionPool');
  const { UnifiedService } = require('../services/unifiedService');
  const { AuthService } = require('../services/authService');
  const repository = require('../repository/unifiedRepository');
  mainApp.loadMetadata([path.join(__dirname, '..', 'resources', 'modules')]);

  const width = parseInt(args.width || env.parallelReads || '4', 10);
  const context = { tenantId: copy, lang: 'en' };
  const cases = [];
  const short = (err) => String(err.message || err).split('\n')[0];

  /** The first record of an entity, and that it opens with its grids. */
  const openable = async (pkg, table, given) => {
    const meta = mainApp.getEntity(pkg, table);
    if (!meta) {
      throw new Error('no such entity');
    }
    let id = given;
    if (!id) {
      const [first] = await repository.find(meta, { page: 1, pageSize: 1 }, context);
      if (!first) {
        throw new Error('no records');
      }
      id = first[meta.primaryKey];
    }
    await UnifiedService.get(pkg, table, id, context);
    return id;
  };

  if (args.user) {
    try {
      await AuthService.getUserProfile({ ...context, userId: args.user });
      cases.push({
        name: `profile of user ${args.user}`,
        run: () => AuthService.getUserProfile({ ...context, userId: args.user })
      });
    } catch (err) {
      say(`  skipped the profile of user ${args.user}: ${short(err)}`);
    }
  }

  if (args.record) {
    // A name, or none: then the masters with the most grids, most first,
    // until one is there in this copy.
    const candidates = args.record === true
      ? mainApp.getAllPackages()
        .flatMap((pkg) => mainApp.getTablesInPackage(pkg).map((table) => ({ pkg, table, entity: mainApp.getEntity(pkg, table) })))
        .filter(({ entity }) => entity && entity.hasChilds && Array.isArray(entity.children) && entity.children.length >= 3)
        .sort((x, y) => y.entity.children.length - x.entity.children.length)
        .map(({ pkg, table }) => `${pkg}/${table}`)
      : [String(args.record)];
    for (const candidate of candidates) {
      const [name, given] = candidate.split(':');
      const [pkg, table] = name.split('/');
      try {
        const id = await openable(pkg, table, given);
        const grids = mainApp.getEntity(pkg, table).children.length;
        cases.push({
          name: `${name} ${id}, ${grids} grids`,
          run: () => UnifiedService.get(pkg, table, id, context)
        });
        break;
      } catch (err) {
        say(`  skipped ${name}: ${short(err)}`);
      }
    }
  }

  if (args.codes) {
    // A package, or none: then the packages with the most code tables.
    const codeTables = (pkg) => mainApp.getTablesInPackage(pkg).filter((t) => t.toLowerCase().includes('code')).length;
    const candidates = args.codes === true
      ? mainApp.getAllPackages().filter((pkg) => codeTables(pkg) >= 3).sort((x, y) => codeTables(y) - codeTables(x))
      : [String(args.codes)];
    for (const pkg of candidates) {
      try {
        await UnifiedService.getCodes(pkg, context);
        cases.push({
          name: `${pkg}, ${codeTables(pkg)} code tables`,
          run: () => UnifiedService.getCodes(pkg, context)
        });
        break;
      } catch (err) {
        say(`  skipped ${pkg} code tables: ${short(err)}`);
      }
    }
  }

  if (cases.length === 0) {
    say('Nothing to measure: give --user, --record or --codes. See the top of this file.');
    await connectionPool.closeAll();
    return;
  }

  const time = async (fn) => {
    const started = process.hrtime.bigint();
    await fn();
    return Number(process.hrtime.bigint() - started) / 1e6;
  };
  const median = (list) => {
    const sorted = [...list].sort((a, b) => a - b);
    return sorted[Math.floor(sorted.length / 2)];
  };

  const results = [];
  for (const one of cases) {
    // The pool, its connections and the statements' plans are not what is
    // being measured.
    env.parallelReads = width;
    await one.run();
    await one.run();

    const serial = [];
    const parallel = [];
    for (let i = 0; i < runs; i++) {
      env.parallelReads = 1;
      serial.push(await time(one.run));
      env.parallelReads = width;
      parallel.push(await time(one.run));
    }
    results.push({ name: one.name, serial: median(serial), parallel: median(parallel) });
  }
  await connectionPool.closeAll();

  console.log = log;
  const ms = (value) => `${value.toFixed(1).padStart(8)} ms`;
  log(`\n  ${copy}, median of ${runs} each, side by side ${width} at a time\n`);
  log(`  ${'read'.padEnd(40)}  one by one  side by side   saved`);
  for (const r of results) {
    const saved = r.serial > 0 ? Math.round((1 - r.parallel / r.serial) * 100) : 0;
    log(`  ${r.name.padEnd(40)} ${ms(r.serial)}  ${ms(r.parallel)}  ${String(saved).padStart(4)} %`);
  }
  log('');
}

main().catch((err) => {
  process.stderr.write(`${err.stack || err}\n`);
  process.exit(1);
});
