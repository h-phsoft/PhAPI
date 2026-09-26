/**
 * An export's PDF is laid out on a worker thread (Step 5.4).
 *
 * Runs against a stand-in connection pool, so no database is needed. What is
 * pinned down is that the request's thread stays free while a large export is
 * drawn, that the document is the one the request's own thread would have
 * drawn, that no more than EXPORT_WORKERS threads run at once, and that a
 * worker is always given back -- after a finished export, a reader that left,
 * or a failure.
 */

const assert = require('assert');
const path = require('path');
const { Writable } = require('stream');
const { monitorEventLoopDelay } = require('perf_hooks');

const env = require('../config/env');
const mainApp = require('../metadata/registry');
const connectionPool = require('../core/connectionPool');
const reportService = require('../services/reportService');
const pdfRenderer = require('../services/pdfRenderer');

mainApp.loadMetadata([path.join(__dirname, '..', 'resources', 'modules')]);

let passed = 0;
let failed = 0;

async function test(name, fn) {
  try {
    await fn();
    console.log(`✓ [PASS] ${name}`);
    passed++;
  } catch (err) {
    console.error(`✗ [FAIL] ${name}`);
    console.error(`         ${err.message}`);
    failed++;
  }
}

const TENANT = 'workers-test';
const COLUMNS = 20;
const pause = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

/** A pool that hands out `total` rows of twenty columns, 500 at a time. */
function fakePool(total, options = {}) {
  const seen = { batches: 0, closed: false };
  connectionPool.pools.set(TENANT, {
    tenantId: TENANT,
    dbType: 'oracle',
    seen,
    async stream(sql, params, onBatch) {
      try {
        for (let start = 0; start < total; start += 500) {
          await pause(2);
          seen.batches++;
          const rows = Array.from({ length: Math.min(500, total - start) }, (_, i) => {
            const row = {};
            for (let c = 0; c < COLUMNS; c++) {
              row[`col${c}`] = c % 3 ? `Value ${start + i} ${c}` : (start + i) * c;
            }
            if (options.poison && start + i === options.poison) {
              // Cannot be sent to another thread.
              row.col1 = () => {};
            }
            return row;
          });
          if ((await onBatch(rows)) === false) {
            break;
          }
        }
      } finally {
        seen.closed = true;
      }
    }
  });
  return seen;
}

/** A writable that keeps what it is sent. */
function sink() {
  const chunks = [];
  const out = new Writable({
    write(chunk, encoding, callback) {
      chunks.push(chunk);
      callback();
    }
  });
  out.bytes = () => Buffer.concat(chunks);
  return out;
}

const pages = (pdf) => (pdf.toString('latin1').match(/\/Type \/Page\b/g) || []).length;

(async () => {
  console.log('\n--- Export workers (Step 5.4) ---');
  const configured = env.exportWorkers;
  env.exportWorkers = 2;

  await test('a large export leaves the request\'s thread free', async () => {
    fakePool(5000);
    const delay = monitorEventLoopDelay({ resolution: 1 });
    delay.enable();
    const out = sink();
    const result = await reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, out);
    delay.disable();
    assert.strictEqual(result.rowCount, 5000);
    assert.strictEqual(out.bytes().subarray(0, 5).toString(), '%PDF-');
    // On this thread each batch held it for about 55 ms, and up to 190.
    const longest = delay.max / 1e6;
    assert.ok(longest < 80, `the thread was held for ${longest.toFixed(0)} ms at a time`);
  });

  await test('the worker draws the document this thread would have', async () => {
    fakePool(1234);
    const inWorker = sink();
    await reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, inWorker);

    env.exportWorkers = 0;
    try {
      fakePool(1234);
      const inThread = sink();
      await reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, inThread);
      assert.ok(pages(inThread.bytes()) > 1);
      assert.strictEqual(pages(inWorker.bytes()), pages(inThread.bytes()));
      // Only the time stamps and the document id differ.
      assert.ok(Math.abs(inWorker.bytes().length - inThread.bytes().length) < 200,
        `${inWorker.bytes().length} bytes against ${inThread.bytes().length}`);
    } finally {
      env.exportWorkers = 2;
    }
  });

  await test('no more than EXPORT_WORKERS run at once, and the rest wait their turn', async () => {
    env.exportWorkers = 1;
    try {
      fakePool(1500);
      let peak = 0;
      const watch = setInterval(() => {
        peak = Math.max(peak, pdfRenderer.slots.busy);
      }, 1);
      const results = await Promise.all([1, 2, 3].map(() =>
        reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, sink())));
      clearInterval(watch);
      assert.deepStrictEqual(results.map((r) => r.rowCount), [1500, 1500, 1500]);
      assert.strictEqual(peak, 1);
      assert.strictEqual(pdfRenderer.slots.busy, 0);
    } finally {
      env.exportWorkers = 2;
    }
  });

  await test('a reader that goes away gives its worker back', async () => {
    const seen = fakePool(20000);
    const out = new Writable({ highWaterMark: 16 * 1024, write() {} });
    setTimeout(() => out.destroy(), 100);
    const result = await reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, out);
    assert.strictEqual(result.aborted, true);
    assert.strictEqual(seen.closed, true);
    await pause(100);
    assert.strictEqual(pdfRenderer.slots.busy, 0);
  });

  await test('a row that cannot be drawn fails the export and gives its worker back', async () => {
    const seen = fakePool(3000, { poison: 1700 });
    await assert.rejects(
      reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, sink()),
      /could not be cloned/
    );
    assert.strictEqual(seen.closed, true);
    await pause(100);
    assert.strictEqual(pdfRenderer.slots.busy, 0);
  });

  await test('a worker that dies while the reader is full fails the export, not hangs it', async () => {
    const os = require('os');
    const fs = require('fs');
    // Draws the first batch, then fails on the second.
    const script = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'phapi-workers-')), 'dies.js');
    fs.writeFileSync(script, `
      const { parentPort } = require('worker_threads');
      let batches = 0;
      parentPort.on('message', (message) => {
        if (message.type === 'rows' && ++batches === 2) {
          throw new Error('pdfkit fell over');
        }
        if (message.type === 'start') {
          const data = new Uint8Array(64 * 1024);
          parentPort.postMessage({ type: 'chunk', data }, [data.buffer]);
        }
        if (message.type === 'rows') {
          parentPort.postMessage({ type: 'drawn' });
        }
      });
    `);
    const real = pdfRenderer.settings.workerFile;
    pdfRenderer.settings.workerFile = script;
    try {
      const seen = fakePool(20000);
      // Takes nothing: full from the first chunk.
      const out = new Writable({ highWaterMark: 16 * 1024, write() {} });
      const outcome = await Promise.race([
        reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, out).then(
          () => 'finished', (err) => err.message),
        pause(3000).then(() => 'still waiting after 3 s')
      ]);
      assert.strictEqual(outcome, 'pdfkit fell over');
      assert.strictEqual(seen.closed, true);
      await pause(100);
      assert.strictEqual(pdfRenderer.slots.busy, 0);
      out.destroy();
    } finally {
      pdfRenderer.settings.workerFile = real;
      fs.rmSync(path.dirname(script), { recursive: true, force: true });
    }
  });

  await test('an export with no rows still gets a document', async () => {
    fakePool(0);
    const out = sink();
    const result = await reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, out);
    assert.strictEqual(result.rowCount, 0);
    assert.strictEqual(out.bytes().subarray(0, 5).toString(), '%PDF-');
    assert.strictEqual(pdfRenderer.slots.busy, 0);
  });

  env.exportWorkers = configured;
  connectionPool.pools.delete(TENANT);

  console.log(`\n  workers: ${passed} passed, ${failed} failed\n`);
  if (failed > 0) {
    process.exitCode = 1;
  }
})();
