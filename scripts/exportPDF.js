#!/usr/bin/env node
/* global process */
/**
 * Saves a report's PDF export to a file, the document the export endpoint
 * (POST /PhsAPI/UC/:pkg/:report/PDF) sends, without signing in.
 *
 *   node scripts/exportPDF.js --copy=NSCC --report=Acc/VoucherView
 *   node scripts/exportPDF.js --copy=Demo --report=Fre/CodeAirports --out=airports.pdf
 *
 * --out   the file (default <Report>.pdf in the current directory)
 *
 * Needs the database, so it runs where the tenant's schema is reachable.
 */

const fs = require('fs');
const path = require('path');

const args = Object.fromEntries(process.argv.slice(2).map((arg) => {
  const [key, ...rest] = arg.replace(/^--/, '').split('=');
  return [key, rest.join('=') || true];
}));

const copy = args.copy || 'Demo';
const report = args.report || 'Fre/CodeAirports';

async function main() {
  // Quiet: the pool logs every statement.
  const log = console.log;
  console.log = () => {};
  require('../utils/logger').silent = true;

  const mainApp = require('../metadata/registry');
  const reportService = require('../services/reportService');
  const connectionPool = require('../core/connectionPool');
  mainApp.loadMetadata([path.join(__dirname, '..', 'resources', 'modules')]);

  const [pkg, name] = report.split('/');
  const file = path.resolve(args.out && args.out !== true ? args.out : `${name}.pdf`);
  const started = Date.now();
  const result = await reportService.renderPDF(pkg, name, {}, { tenantId: copy }, fs.createWriteStream(file));
  await connectionPool.closeAll();

  console.log = log;
  const size = (fs.statSync(file).size / 1048576).toFixed(1);
  log(`\n  ${result.rowCount} row(s)${result.truncated ? ' (cut at the export limit)' : ''}, `
    + `${size} MB, ${Date.now() - started} ms\n  ${file}\n`);
}

main().catch((err) => {
  process.stderr.write(`${err.stack || err}\n`);
  process.exit(1);
});
