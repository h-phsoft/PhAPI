#!/usr/bin/env node
/* global process */
/**
 * Measures reading a large report whole against streaming it (D5).
 *
 * Step 5's exit is "measured before and after". Before is how a report was
 * read -- one statement, every row in memory at once, which is what find()
 * does. After is repository.stream(): the same statement read a batch at a
 * time. Each runs in its own process so one's heap cannot flatter the other,
 * and each reports its peak memory and its time.
 *
 *   node scripts/measureStreaming.js --copy=Demo --report=Fre/CodeAirports
 *   node scripts/measureStreaming.js --copy=Demo --report=Fre/CodeAirports --rows=50000
 *
 * Needs the database, so it runs where the tenant's schema is reachable.
 */

const path = require('path');
const { execFileSync } = require('child_process');

const args = Object.fromEntries(process.argv.slice(2).map((arg) => {
  const [key, ...rest] = arg.replace(/^--/, '').split('=');
  return [key, rest.join('=') || true];
}));

const copy = args.copy || 'Demo';
const report = args.report || 'Fre/CodeAirports';
const rows = parseInt(args.rows || '50000', 10);

/** Samples the process's memory until stopped; keeps the peaks. */
function sampler() {
  const peak = { rss: 0, heapUsed: 0 };
  const take = () => {
    const now = process.memoryUsage();
    peak.rss = Math.max(peak.rss, now.rss);
    peak.heapUsed = Math.max(peak.heapUsed, now.heapUsed);
  };
  take();
  const timer = setInterval(take, 5);
  return { peak, stop() { clearInterval(timer); take(); } };
}

/** One measurement, in this process: `mode` is "whole" or "streamed". */
async function measure(mode) {
  // Quiet: the pool logs every statement, which would swamp the numbers.
  console.log = () => {};
  const mainApp = require('../metadata/registry');
  const repository = require('../repository/unifiedRepository');
  const reportService = require('../services/reportService');
  const connectionPool = require('../core/connectionPool');
  mainApp.loadMetadata([path.join(__dirname, '..', 'resources', 'modules')]);

  const [pkg, name] = report.split('/');
  const { entity } = reportService.resolve(pkg, name);
  const context = { tenantId: copy };

  // The pool and its first connection are not what is being measured.
  await repository.find(entity, { page: 1, pageSize: 1 }, context);
  global.gc && global.gc();

  const memory = sampler();
  const started = process.hrtime.bigint();
  let firstRow = null;
  let count = 0;

  if (mode === 'whole') {
    const all = await repository.find(entity, { page: 1, pageSize: rows }, context);
    firstRow = process.hrtime.bigint();
    count = all.length;
  } else {
    for await (const batch of repository.stream(entity, {}, context, rows)) {
      if (firstRow === null) {
        firstRow = process.hrtime.bigint();
      }
      count += batch.length;
    }
  }

  const ended = process.hrtime.bigint();
  memory.stop();
  await connectionPool.closeAll();

  const ms = (from, to) => Number(to - from) / 1e6;
  process.stdout.write(JSON.stringify({
    mode,
    rows: count,
    firstRowMs: firstRow ? Math.round(ms(started, firstRow)) : null,
    totalMs: Math.round(ms(started, ended)),
    peakRssMb: Math.round(memory.peak.rss / 1048576),
    peakHeapMb: Math.round(memory.peak.heapUsed / 1048576)
  }) + '\n');
}

if (args.mode) {
  measure(args.mode).catch((err) => {
    process.stderr.write(`${err.stack || err}\n`);
    process.exit(1);
  });
} else {
  const run = (mode) => JSON.parse(execFileSync(process.execPath,
    ['--expose-gc', __filename, `--mode=${mode}`, `--copy=${copy}`, `--report=${report}`, `--rows=${rows}`],
    { encoding: 'utf8', stdio: ['ignore', 'pipe', 'inherit'] }).trim().split('\n').pop());

  const whole = run('whole');
  const streamed = run('streamed');

  process.stdout.write(`\n  ${report} on ${copy}, up to ${rows} rows\n\n`);
  process.stdout.write('                 rows   first row    total   peak RSS   peak heap\n');
  for (const r of [whole, streamed]) {
    process.stdout.write(`  ${r.mode.padEnd(9)} ${String(r.rows).padStart(9)} ${String(r.firstRowMs).padStart(8)} ms `
      + `${String(r.totalMs).padStart(6)} ms ${String(r.peakRssMb).padStart(7)} MB ${String(r.peakHeapMb).padStart(8)} MB\n`);
  }
  process.stdout.write('\n');
}
