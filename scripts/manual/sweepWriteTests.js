/**
 * Removes anything the write harness left behind.
 *
 * Every value it writes into a text column is prefixed ZZTEST, which is what
 * makes this possible: the search is bounded to the tables those screens touch
 * and to rows carrying that marker, so nothing real can match.
 *
 *   node scripts/manual/sweepWriteTests.js
 *   node scripts/manual/sweepWriteTests.js --apply
 *
 * Children are removed before their master: a marked master's lines may carry
 * no text of their own -- a grid of amounts and references sets none -- so they
 * are not marked, and the master cannot go while they are there.
 *
 * Nothing here is part of `npm test`. It is the check to run after
 * RUN_WRITE_TESTS=1, and the answer should always be zero.
 */

require('dotenv').config();
const path = require('path');

const ROOT = path.join(__dirname, '..', '..');
const mainApp = require('../../metadata/registry');
const screens = require('../../metadata/screens');
const screenView = require('../../presentation/screens');
const pool = require('../../core/connectionPool');

const MARK = 'ZZTEST';
const TENANT = process.env.TEST_TENANT || 'Demo';
const apply = process.argv.includes('--apply');

mainApp.loadMetadata([path.join(ROOT, 'resources', 'modules')]);
screens.load({
  programs: path.join(ROOT, 'resources', 'programs'),
  reports: path.join(ROOT, 'resources', 'screens')
});

(async () => {
  const w = await pool.getPool(TENANT);

  // Every entity a generated screen writes to: the masters and their lines.
  const entities = new Map();

  for (const programUrl of screens.programs()) {
    const screen = screenView.forProgram(programUrl, {});
    if (!screen || !screen.form) {
      continue;
    }
    const [pkg, name] = String(screen.entity).split('/');
    const master = mainApp.getEntity(pkg, name);
    if (master) {
      entities.set(master.tableName, master);
    }
    for (const line of (screen.lines || [])) {
      const [lpkg, lname] = String(line.entity).split('/');
      const child = mainApp.getEntity(lpkg, lname);
      if (child) {
        entities.set(child.tableName, child);
      }
    }
  }

  console.log(`tables a generated screen writes to: ${entities.size}`);

  let scanned = 0;
  let found = 0;
  let removed = 0;
  const leftovers = [];

  for (const [table, entity] of entities) {
    const text = (entity.fields || []).filter(
      (f) => String(f.DBType).toUpperCase() === 'VARCHAR2' && f.query !== false
    );
    if (text.length === 0) {
      continue;
    }

    const where = text.map((f) => `${f.Name} LIKE '${MARK}%'`).join(' OR ');
    const key = entity.fields.find(
      (f) => String(f.Field).toLowerCase() === String(entity.primaryKey).toLowerCase()
    );
    if (!key) {
      continue;
    }

    let rows;
    try {
      rows = await w.query(`SELECT ${key.Name} AS "id" FROM ${entity.synonym || table} WHERE ${where}`, {});
      scanned++;
    } catch {
      // A table this copy does not have, or a view.
      continue;
    }

    if (!rows || rows.length === 0) {
      continue;
    }

    found += rows.length;
    leftovers.push(`${table}: ${rows.map((r) => r.id).join(', ')}`);

    if (!apply) {
      continue;
    }

    for (const row of rows) {
      // Children first, by foreign key rather than by marker.
      for (const child of (entity.children || [])) {
        const childEntity = mainApp.getEntity(child.pkg, child.table)
          || mainApp.getEntityBySynonym(child.synonym || '')
          || mainApp.getEntityByTable(child.table || '');
        if (!childEntity) {
          continue;
        }
        const fk = childEntity.fields.find(
          (f) => String(f.Field).toLowerCase() === String(child.foreignKey).toLowerCase()
        );
        if (!fk) {
          continue;
        }
        try {
          await w.query(
            `DELETE FROM ${childEntity.synonym || childEntity.tableName} WHERE ${fk.Name} = ${Number(row.id)}`, {}
          );
        } catch {
          // A child this copy does not have.
        }
      }

      try {
        await w.query(`DELETE FROM ${entity.synonym || table} WHERE ${key.Name} = ${Number(row.id)}`, {});
        removed++;
      } catch (err) {
        console.log(`  could not remove ${table} ${row.id}: ${String(err.message).split('\n')[0]}`);
      }
    }
  }

  console.log(`tables scanned : ${scanned}`);
  console.log(`rows marked ${MARK}: ${found}`);
  if (apply) {
    console.log(`removed        : ${removed}`);
  }
  for (const line of leftovers) {
    console.log('   ' + line);
  }
  if (!apply && found > 0) {
    console.log('\n  Re-run with --apply to remove them.');
  }

  process.exit(0);
})();
