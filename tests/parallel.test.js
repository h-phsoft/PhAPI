/**
 * Independent reads run side by side (Step 5.3).
 *
 * Runs against a stand-in connection pool whose every statement takes a
 * moment, so no database is needed. What is pinned down is how many reads are
 * in flight at once -- more than one where the reads do not need each other,
 * never more than PARALLEL_READS -- and that the answer is the one the reads
 * one after another gave: same keys, same order, same rows.
 */

const assert = require('assert');
const fs = require('fs');
const os = require('os');
const path = require('path');

const env = require('../config/env');
const mainApp = require('../metadata/registry');
const connectionPool = require('../core/connectionPool');
const { UnifiedService: unifiedService } = require('../services/unifiedService');
const { AuthService } = require('../services/authService');
const { mapLimit } = require('../utils/parallel');

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

const TENANT = 'parallel-test';
const STATEMENT_MS = 40;
const pause = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

/**
 * A pool that answers every statement after STATEMENT_MS with one row naming
 * the table it read, and records the most statements and connections that
 * were ever in use at once.
 */
function fakePool(options = {}) {
  const seen = { statements: 0, inFlight: 0, peak: 0, connections: 0, peakConnections: 0, sql: [] };
  const run = async (sql) => {
    seen.statements++;
    seen.sql.push(sql);
    seen.inFlight++;
    seen.peak = Math.max(seen.peak, seen.inFlight);
    try {
      await pause(STATEMENT_MS);
      if (options.failOn && options.failOn.test(sql)) {
        throw new Error(`ORA-00942: table or view does not exist (${options.failOn.source})`);
      }
      const table = (/FROM\s+("?)(\w+)\1/i.exec(sql) || [])[2] || 'unknown';
      return (options.rows && options.rows(table)) || [{ ID: 1, NAME: table }];
    } finally {
      seen.inFlight--;
    }
  };
  const wrapper = {
    tenantId: TENANT,
    dbType: 'oracle',
    seen,
    query: run,
    async getConnection() {
      seen.connections++;
      seen.peakConnections = Math.max(seen.peakConnections, seen.connections);
      let released = false;
      return {
        query: run,
        async release() {
          if (!released) {
            released = true;
            seen.connections--;
          }
        }
      };
    }
  };
  connectionPool.pools.set(TENANT, wrapper);
  return wrapper;
}

// Models of their own, in a temporary directory: a master with three child
// grids, and a package of four code tables.
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'phapi-parallel-'));
function model(pkg, tableName, extra = {}) {
  return {
    package: pkg,
    tableName,
    primaryKey: 'id',
    fields: [
      { Name: 'Id', Field: 'id', DBType: 'NUMBER', Type: 'Long' },
      { Name: 'Name', Field: 'name', DBType: 'VARCHAR2', Type: 'String' },
      { Name: 'Mst_Id', Field: 'mstId', DBType: 'NUMBER', Type: 'Long' }
    ],
    ...extra
  };
}
function write(pkg, name, value) {
  fs.mkdirSync(path.join(root, pkg), { recursive: true });
  fs.writeFileSync(path.join(root, pkg, `${name}.json`), JSON.stringify(value));
}
const children = ['Lines', 'Notes', 'Files'].map((name) => ({
  childKey: name.toLowerCase(),
  table: `Tpl_${name}`,
  synonym: `Tpl_${name}`,
  foreignKey: 'mstId'
}));
write('Tpl', 'Master', model('Tpl', 'Tpl_Master', { hasChilds: true, children }));
for (const name of ['Lines', 'Notes', 'Files']) {
  write('Tpl', name, model('Tpl', `Tpl_${name}`));
}
for (const name of ['CodeA', 'CodeB', 'CodeC', 'CodeD']) {
  write('Tpc', name, model('Tpc', `Tpc_${name}`));
}
write('Tpc', 'Other', model('Tpc', 'Tpc_Other'));

const quiet = { log: console.log };
console.log = () => {};
try {
  mainApp.loadMetadata([root]);
} finally {
  Object.assign(console, quiet);
}

const context = { tenantId: TENANT };

(async () => {
  console.log('\n--- Parallel reads (Step 5.3) ---');
  const configured = env.parallelReads;

  await test('mapLimit keeps the order of its items, not of their finishing', async () => {
    const out = await mapLimit([30, 5, 20, 1], 4, async (ms, index) => {
      await pause(ms);
      return index;
    });
    assert.deepStrictEqual(out, [0, 1, 2, 3]);
  });

  await test('mapLimit never has more than its limit in flight', async () => {
    let inFlight = 0;
    let peak = 0;
    await mapLimit(Array.from({ length: 12 }), 3, async () => {
      inFlight++;
      peak = Math.max(peak, inFlight);
      await pause(5);
      inFlight--;
    });
    assert.strictEqual(peak, 3);
  });

  await test('mapLimit rejects on the first failure and starts nothing after it', async () => {
    let started = 0;
    await assert.rejects(mapLimit(Array.from({ length: 10 }), 2, async (item, index) => {
      started++;
      await pause(5);
      if (index === 1) {
        throw new Error('boom');
      }
    }), /boom/);
    await pause(30);
    // The two lanes had started items 0-2 by the time item 1 failed.
    assert.ok(started <= 3, `started ${started} of 10`);
  });

  await test('mapLimit with nothing to do returns nothing', async () => {
    assert.deepStrictEqual(await mapLimit([], 4, async () => 1), []);
  });

  await test('a record\'s child grids are read side by side', async () => {
    const pool = fakePool();
    const record = await unifiedService.get('Tpl', 'Master', 7, context);
    // The master, then its three grids at once.
    assert.strictEqual(pool.seen.statements, 4);
    assert.strictEqual(pool.seen.peak, 3);
    assert.deepStrictEqual(Object.keys(record), ['id', 'name', 'lines', 'notes', 'files']);
    assert.strictEqual(record.lines[0].name, 'Tpl_Lines');
    assert.strictEqual(record.notes[0].name, 'Tpl_Notes');
    assert.strictEqual(record.files[0].name, 'Tpl_Files');
  });

  await test('PARALLEL_READS=1 reads them one after another, with the same result', async () => {
    const parallel = await unifiedService.get('Tpl', 'Master', 7, context);
    env.parallelReads = 1;
    try {
      const pool = fakePool();
      const serial = await unifiedService.get('Tpl', 'Master', 7, context);
      assert.strictEqual(pool.seen.peak, 1);
      assert.deepStrictEqual(serial, parallel);
    } finally {
      env.parallelReads = configured;
    }
  });

  await test('a record that is not there reads no grids', async () => {
    const pool = fakePool({ rows: () => [] });
    assert.strictEqual(await unifiedService.get('Tpl', 'Master', 404, context), null);
    assert.strictEqual(pool.seen.statements, 1);
  });

  await test('a grid that fails, fails the record', async () => {
    fakePool({ failOn: /Tpl_Notes/i });
    await assert.rejects(unifiedService.get('Tpl', 'Master', 7, context), /ORA-00942/);
  });

  await test('a package\'s code tables are read side by side, no more than PARALLEL_READS at once', async () => {
    env.parallelReads = 2;
    try {
      const pool = fakePool();
      const codes = await unifiedService.getCodes('Tpc', context);
      assert.strictEqual(pool.seen.statements, 4);
      assert.strictEqual(pool.seen.peak, 2);
      assert.deepStrictEqual(Object.keys(codes), ['TpcCodeA', 'TpcCodeB', 'TpcCodeC', 'TpcCodeD']);
      assert.strictEqual(codes.TpcCodeC[0].name, 'Tpc_CodeC');
    } finally {
      env.parallelReads = configured;
    }
  });

  await test('the user profile reads its menus and periods beside the user row', async () => {
    const pool = fakePool({
      rows: (table) => {
        if (/^Cpy_User$/i.test(table)) {
          return [{ ID: 5, NAME: 'Tester', PASS: 'secret', PGRP_ID: 3 }];
        }
        if (/^Cpy_PGrp$/i.test(table)) {
          return [{ ID: 3, NAME: 'Clerks' }];
        }
        return [];
      }
    });
    const started = Date.now();
    const profile = await AuthService.getUserProfile({ tenantId: TENANT, userId: 5, lang: 'en' });
    const took = Date.now() - started;

    // The user, menus and periods together; then the group and its programs.
    assert.strictEqual(pool.seen.statements, 5);
    assert.strictEqual(pool.seen.peak, 3);
    assert.ok(took < STATEMENT_MS * 4, `took ${took} ms, five statements one after another take ${STATEMENT_MS * 5}`);
    // Every connection went back.
    assert.strictEqual(pool.seen.connections, 0);
    assert.strictEqual(profile.profile.name, 'Tester');
    assert.strictEqual(profile.profile.pass, undefined);
    assert.strictEqual(profile.permissions.name, 'Clerks');
    assert.deepStrictEqual(Object.keys(profile), ['profile', 'permissions', 'programs', 'menus', 'periods']);
  });

  await test('a user with no group reads no group', async () => {
    const pool = fakePool({
      rows: (table) => (/^Cpy_User$/i.test(table) ? [{ ID: 5, NAME: 'Admin', PGRP_ID: 0 }] : [])
    });
    const profile = await AuthService.getUserProfile({ tenantId: TENANT, userId: 5 });
    assert.ok(!pool.seen.sql.some((sql) => /Cpy_PGrp/i.test(sql)), 'read Cpy_PGrp for a user with no group');
    assert.deepStrictEqual(profile.permissions, {});
    assert.strictEqual(pool.seen.connections, 0);
  });

  await test('a failed profile read still gives every connection back', async () => {
    const pool = fakePool({ failOn: /Cpy_User/i });
    await assert.rejects(AuthService.getUserProfile({ tenantId: TENANT, userId: 5 }), /ORA-00942/);
    await pause(STATEMENT_MS * 2);
    assert.strictEqual(pool.seen.connections, 0);
  });

  connectionPool.pools.delete(TENANT);
  fs.rmSync(root, { recursive: true, force: true });

  console.log(`\n  parallel: ${passed} passed, ${failed} failed\n`);
  if (failed > 0) {
    process.exitCode = 1;
  }
})();
