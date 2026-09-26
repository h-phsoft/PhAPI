#!/usr/bin/env node
/* global process */
/**
 * Measures a PDF export laid out on the request's thread against on a worker
 * thread (Step 5.4).
 *
 * What a worker is for is the other requests: while an export is drawn on the
 * request's thread, nothing else is answered. So besides the export's own
 * time, this reports how long the thread was held at a stretch -- the longest,
 * and the 99th percentile -- which is how much longer any other request would
 * have waited. Each side runs in its own process.
 *
 *   node scripts/measureExport.js --copy=NSCC --report=Acc/VoucherView
 *   node scripts/measureExport.js --copy=NSCC --report=Acc/VoucherView --rows=20000 --exports=2
 *
 * --rows     the export ceiling (default 50000)
 * --exports  how many run at the same time (default 1)
 * --workers  the worker side's EXPORT_WORKERS (default 2)
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
const atOnce = parseInt(args.exports || '1', 10);
const workers = parseInt(args.workers || '2', 10);

/** One measurement, in this process, with EXPORT_WORKERS as it was started. */
async function measure() {
  // Quiet: the pool logs every statement, which would swamp the numbers.
  console.log = () => {};
  require('../utils/logger').silent = true;
  const { Writable } = require('stream');
  const { monitorEventLoopDelay } = require('perf_hooks');
  const env = require('../config/env');
  const mainApp = require('../metadata/registry');
  const repository = require('../repository/unifiedRepository');
  const reportService = require('../services/reportService');
  const connectionPool = require('../core/connectionPool');
  mainApp.loadMetadata([path.join(__dirname, '..', 'resources', 'modules')]);
  env.exportMaxRows = rows;

  const [pkg, name] = report.split('/');
  const { entity } = reportService.resolve(pkg, name);
  const context = { tenantId: copy };

  // The pool and its first connection are not what is being measured.
  await repository.find(entity, { page: 1, pageSize: 1 }, context);

  let bytes = 0;
  const delay = monitorEventLoopDelay({ resolution: 1 });
  delay.enable();
  const started = process.hrtime.bigint();
  const results = await Promise.all(Array.from({ length: atOnce }, () => {
    const out = new Writable({
      write(chunk, encoding, callback) {
        bytes += chunk.length;
        callback();
      }
    });
    return reportService.renderPDF(pkg, name, {}, context, out);
  }));
  const ms = Number(process.hrtime.bigint() - started) / 1e6;
  delay.disable();
  await connectionPool.closeAll();

  process.stdout.write(JSON.stringify({
    workers: env.exportWorkers,
    rows: results.reduce((sum, r) => sum + r.rowCount, 0),
    totalMs: Math.round(ms),
    mb: +(bytes / 1048576).toFixed(1),
    heldMaxMs: Math.round(delay.max / 1e6),
    heldP99Ms: Math.round(delay.percentile(99) / 1e6)
  }) + '\n');
}

if (args.child) {
  measure().catch((err) => {
    process.stderr.write(`${err.stack || err}\n`);
    process.exit(1);
  });
} else {
  const run = (count) => JSON.parse(execFileSync(process.execPath,
    [__filename, '--child', `--copy=${copy}`, `--report=${report}`, `--rows=${rows}`, `--exports=${atOnce}`],
    {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'inherit'],
      env: { ...process.env, EXPORT_WORKERS: String(count) }
    }).trim().split('\n').pop());

  const inThread = run(0);
  const inWorker = run(workers);

  const label = (r) => (r.workers === 0 ? 'this thread' : `${r.workers} workers`);
  process.stdout.write(`\n  ${report} on ${copy}, ${atOnce} export(s) at once, up to ${rows} rows each\n\n`);
  process.stdout.write('                    rows     total      PDF   thread held: longest    99%\n');
  for (const r of [inThread, inWorker]) {
    process.stdout.write(`  ${label(r).padEnd(12)} ${String(r.rows).padStart(8)} ${String(r.totalMs).padStart(7)} ms `
      + `${String(r.mb).padStart(5)} MB ${String(r.heldMaxMs).padStart(15)} ms ${String(r.heldP99Ms).padStart(5)} ms\n`);
  }
  process.stdout.write('\n');
}
