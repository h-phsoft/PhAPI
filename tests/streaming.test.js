/**
 * Streaming a large result (D5).
 *
 * An export reads its rows through repository.stream(), a batch at a time,
 * rather than through find(), which reads one page whole. These run against a
 * stand-in connection pool, so they need no database: what they pin down is the
 * contract above the driver -- that batches are shaped as find() shapes a page,
 * that the ceiling is applied in the statement and reported when reached, that
 * a consumer stopping early releases the cursor, and that the PDF carries the
 * whole result rather than its first page.
 */

const assert = require('assert');
const path = require('path');
const { Writable } = require('stream');

const mainApp = require('../metadata/registry');
const connectionPool = require('../core/connectionPool');
const repository = require('../repository/unifiedRepository');
const reportService = require('../services/reportService');

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

const TENANT = 'stream-test';

/**
 * A pool whose stream() hands out `total` rows in batches of `batch`, the way
 * the Oracle driver hands out a result set, and records what it was asked and
 * whether its cursor was closed.
 */
function fakePool(total, batch = 500) {
  const seen = { sql: null, params: null, batches: 0, closed: false };
  const wrapper = {
    tenantId: TENANT,
    dbType: 'oracle',
    seen,
    async query() {
      throw new Error('an export must not read through query()');
    },
    async *stream(sql, params) {
      seen.sql = sql;
      seen.params = params;
      try {
        // The statement's own row limit, as the database would apply it.
        const limit = Object.values(params).pop();
        const rows = Math.min(total, limit);
        for (let start = 0; start < rows; start += batch) {
          // A round trip, as the driver's is: the event loop turns between
          // batches, which is when a client's disconnect can be noticed.
          await new Promise((resolve) => setImmediate(resolve));
          seen.batches++;
          const size = Math.min(batch, rows - start);
          yield Array.from({ length: size }, (_, i) => ({ AIRPORTID: start + i + 1, airportName: `Airport ${start + i + 1}` }));
        }
      } finally {
        seen.closed = true;
      }
    }
  };
  connectionPool.pools.set(TENANT, wrapper);
  return wrapper;
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

const entity = {
  tableName: 'Fre_Code_Airports',
  primaryKey: 'airportId',
  fields: [
    { Name: 'Id', Field: 'airportId', Type: 'Long', query: true },
    { Name: 'Name', Field: 'airportName', Type: 'String', query: true }
  ]
};

(async () => {
  console.log('\n--- Streaming (D5) ---');

  await test('a batch is shaped as find() shapes a page', async () => {
    fakePool(3);
    const batches = [];
    for await (const rows of repository.stream(entity, {}, { tenantId: TENANT }, 10)) {
      batches.push(rows);
    }
    assert.strictEqual(batches.length, 1);
    // AIRPORTID is the declared field in another casing, so it takes the
    // entity's own spelling, as find() does.
    assert.deepStrictEqual(Object.keys(batches[0][0]), ['airportId', 'airportName']);
  });

  await test('the ceiling is in the statement, not applied after reading', async () => {
    const pool = fakePool(5);
    for await (const rows of repository.stream(entity, { page: 7, pageSize: 3 }, { tenantId: TENANT }, 42)) {
      void rows;
    }
    // A screen's page and size are not what an export reads; its limit is.
    assert.match(pool.seen.sql, /OFFSET :p_\d+ ROWS FETCH NEXT :p_\d+ ROWS ONLY$/);
    assert.deepStrictEqual(Object.values(pool.seen.params), [0, 42]);
  });

  await test('a stream with no ceiling is refused, not cut to a default page', async () => {
    fakePool(3);
    await assert.rejects(async () => {
      for await (const rows of repository.stream(entity, {}, { tenantId: TENANT })) {
        void rows;
      }
    }, /positive row limit/);
  });

  await test('a result under the ceiling arrives whole, in batches', async () => {
    const pool = fakePool(1234);
    const { entity: report } = reportService.resolve('Fre', 'CodeAirports');
    let rows = 0;
    let truncated = false;
    for await (const batch of reportService.streamRows(report, {}, { tenantId: TENANT }, 5000)) {
      rows += batch.rows.length;
      truncated = truncated || batch.truncated;
    }
    assert.strictEqual(rows, 1234);
    assert.strictEqual(truncated, false);
    assert.strictEqual(pool.seen.batches, 3);
  });

  await test('reaching the ceiling stops at it and says so', async () => {
    const pool = fakePool(10000);
    const { entity: report } = reportService.resolve('Fre', 'CodeAirports');
    let rows = 0;
    let truncated = false;
    for await (const batch of reportService.streamRows(report, {}, { tenantId: TENANT }, 1200)) {
      rows += batch.rows.length;
      truncated = truncated || batch.truncated;
    }
    assert.strictEqual(rows, 1200);
    assert.strictEqual(truncated, true);
    // One row past the ceiling is asked for -- that is how "cut" is told
    // apart from "exactly this long" -- and no more is read.
    assert.strictEqual(Object.values(pool.seen.params).pop(), 1201);
    assert.strictEqual(pool.seen.closed, true);
  });

  await test('a result exactly at the ceiling is not reported as cut', async () => {
    fakePool(1200);
    const { entity: report } = reportService.resolve('Fre', 'CodeAirports');
    let truncated = false;
    for await (const batch of reportService.streamRows(report, {}, { tenantId: TENANT }, 1200)) {
      truncated = truncated || batch.truncated;
    }
    assert.strictEqual(truncated, false);
  });

  await test('a consumer that stops early closes the cursor', async () => {
    const pool = fakePool(5000);
    for await (const rows of repository.stream(entity, {}, { tenantId: TENANT }, 5000)) {
      void rows;
      break;
    }
    assert.strictEqual(pool.seen.batches, 1);
    assert.strictEqual(pool.seen.closed, true);
  });

  await test('the PDF carries the whole result, not its first page', async () => {
    // It printed the first 500 rows, whatever the query matched.
    const pool = fakePool(1234);
    const out = sink();
    const result = await reportService.renderPDF('Fre', 'CodeAirports', { size: 20 }, { tenantId: TENANT }, out);
    assert.strictEqual(result.rowCount, 1234);
    assert.strictEqual(result.truncated, false);
    assert.strictEqual(pool.seen.closed, true);
    assert.strictEqual(out.bytes().subarray(0, 5).toString(), '%PDF-');
  });

  await test('a query that fails, fails before the document starts', async () => {
    const pool = fakePool(10);
    // Fails on the first read, as the driver does when it executes.
    pool.stream = () => ({
      [Symbol.asyncIterator]() {
        return this;
      },
      next() {
        return Promise.reject(new Error('ORA-00904: "JOB_DATE": invalid identifier'));
      },
      return() {
        return Promise.resolve({ done: true });
      }
    });
    const out = sink();
    await assert.rejects(
      reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, out),
      /ORA-00904/
    );
    // Nothing was written, so the controller can still answer with an error.
    assert.strictEqual(out.bytes().length, 0);
  });

  await test('a slow reader holds the query back rather than filling memory', async () => {
    const pool = fakePool(20000);
    // A client that takes what it is sent and never acknowledges it, like a
    // stalled socket: its buffer fills, and the export must wait on it. Without
    // the wait all 40 batches are read inside this window and the document
    // piles up in pdfkit's own buffer instead.
    const out = new Writable({ highWaterMark: 16 * 1024, write() {} });
    reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, out);
    await new Promise((resolve) => setTimeout(resolve, 3000));
    assert.ok(out.writableNeedDrain, 'the reader should be full');
    assert.ok(pool.seen.batches <= 3, `read ${pool.seen.batches} of 40 batches for a reader that took none`);
    out.destroy();
    await new Promise((resolve) => setTimeout(resolve, 50));
    assert.strictEqual(pool.seen.closed, true);
  });

  await test('a reader that goes away stops the query', async () => {
    const pool = fakePool(20000);
    const out = new Writable({ highWaterMark: 16 * 1024, write() {} });
    setTimeout(() => out.destroy(), 50);
    const result = await reportService.renderPDF('Fre', 'CodeAirports', {}, { tenantId: TENANT }, out);
    assert.strictEqual(result.aborted, true);
    assert.ok(result.rowCount < 20000, `read ${result.rowCount} rows for a reader that left`);
    assert.strictEqual(pool.seen.closed, true);
  });

  connectionPool.pools.delete(TENANT);

  console.log(`\n  streaming: ${passed} passed, ${failed} failed\n`);
  if (failed > 0) {
    process.exitCode = 1;
  }
})();
