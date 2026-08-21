const assert = require('assert');
const path = require('path');
const http = require('http');

// Import core modules
const mainApp = require('../config/mainApp');
const sqlBuilder = require('../core/sqlBuilder');
const { UnifiedService, ValidationError } = require('../services/unifiedService');
const autocompleteService = require('../services/autocompleteService');

console.log('===================================================');
console.log('        PhsAPI COMPREHENSIVE TEST SUITE           ');
console.log('===================================================\n');

let passedTests = 0;
let totalTests = 0;

function test(name, fn) {
  totalTests++;
  try {
    fn();
    console.log(`✓ [PASS] ${name}`);
    passedTests++;
  } catch (err) {
    console.error(`✗ [FAIL] ${name}`);
    console.error(`  Error: ${err.message}`);
  }
}

async function testAsync(name, fn) {
  totalTests++;
  try {
    await fn();
    console.log(`✓ [PASS] ${name}`);
    passedTests++;
  } catch (err) {
    console.error(`✗ [FAIL] ${name}`);
    console.error(`  Error: ${err.message}`);
  }
}

async function runAllTests() {
  // -------------------------------------------------------------
  // 1. METADATA ENGINE TESTS
  // -------------------------------------------------------------
  console.log('--- 1. Metadata Engine Tests ---');

  test('Metadata loading from resources and legacy JSONs', () => {
    const modulesDirs = [
      path.join(__dirname, '..', 'resources', 'modules'),
      path.join(__dirname, '..', 'db', 'JSON', 'pkgs')
    ];
    mainApp.loadMetadata(modulesDirs);

    const pkgs = mainApp.getAllPackages();
    assert.strictEqual(pkgs.length >= 24, true, 'Should load at least 24 packages');
    assert.strictEqual(pkgs.includes('Acc'), true, 'Should include Acc package');
  });

  test('Entity metadata retrieval by package and table', () => {
    const accMaster = mainApp.getEntity('Acc', 'Acc_Master') || mainApp.getEntity('Acc', 'Master');
    assert.notStrictEqual(accMaster, null, 'Acc_Master metadata should exist');
    assert.strictEqual(accMaster.package.toLowerCase(), 'acc');
    assert.strictEqual(accMaster.fields.length > 0, true);
  });

  test('Entity metadata retrieval by synonym', () => {
    const entity = mainApp.getEntityBySynonym('Acc_Mst');
    assert.notStrictEqual(entity, null, 'Entity for synonym Acc_Mst should exist');
  });

  // -------------------------------------------------------------
  // 2. MULTI-DIALECT SQL BUILDER TESTS
  // -------------------------------------------------------------
  console.log('\n--- 2. SQL Builder Engine Tests ---');

  const testEntity = {
    tableName: 'Acc_Master',
    synonym: 'Acc_Mst',
    primaryKey: 'id',
    fields: [
      { Name: 'Id', Field: 'id', query: true, insert: false, update: false },
      { Name: 'Doc_No', Field: 'docNo', query: true, insert: true, update: true },
      { Name: 'Notes', Field: 'notes', query: true, insert: true, update: true }
    ]
  };

  test('Oracle SELECT query generation with synonym and 12c pagination', () => {
    const { sql, params } = sqlBuilder.buildSelect('oracle', testEntity, {
      page: 1,
      pageSize: 10,
      filters: { docNo: 'DOC100' }
    });

    assert.strictEqual(sql.includes('FROM Acc_Mst'), true, 'Oracle query should use synonym Acc_Mst');
    assert.strictEqual(sql.includes('OFFSET :p_2 ROWS FETCH NEXT :p_3 ROWS ONLY'), true, 'Oracle query should contain 12c fetch syntax');
    assert.strictEqual(params.p_1, 'DOC100');
  });

  test('MySQL SELECT query generation with backticks and LIMIT OFFSET', () => {
    const { sql, params } = sqlBuilder.buildSelect('mysql', testEntity, {
      page: 2,
      pageSize: 20,
      filters: { docNo: 'DOC200' }
    });

    assert.strictEqual(sql.includes('FROM `Acc_Master`'), true, 'MySQL query should use table name with backticks');
    assert.strictEqual(sql.includes('LIMIT ? OFFSET ?'), true, 'MySQL query should contain LIMIT OFFSET syntax');
    assert.strictEqual(params[0], 'DOC200');
    assert.strictEqual(params[1], 20); // limit
    assert.strictEqual(params[2], 20); // offset
  });

  test('PostgreSQL INSERT query generation with RETURNING', () => {
    const { sql, params } = sqlBuilder.buildInsert('postgres', testEntity, {
      docNo: 'DOC300',
      notes: 'Test notes'
    });

    assert.strictEqual(sql.includes('INSERT INTO "Acc_Master"'), true);
    assert.strictEqual(sql.includes('RETURNING "Id"'), true);
    assert.strictEqual(params.length, 2);
  });

  // -------------------------------------------------------------
  // 3. SERVICE VALIDATION & AUDIT FIELDS TESTS
  // -------------------------------------------------------------
  console.log('\n--- 3. Unified Service Validation & Audit Tests ---');

  test('Reject invalid unknown fields in payload', () => {
    const mockEntity = {
      tableName: 'TestTable',
      primaryKey: 'id',
      fields: [
        { Name: 'Id', Field: 'id', query: true, insert: false, update: false, isNull: false },
        { Name: 'Name', Field: 'name', Type: 'String', query: true, insert: true, update: true, isNull: false }
      ]
    };

    assert.throws(() => {
      UnifiedService.validatePayload(mockEntity, { name: 'Valid', unknownCol: 'Hacker' }, false);
    }, ValidationError);
  });

  test('Inject audit fields (insUser, insDate, updUser, updDate)', () => {
    const mockEntity = {
      auditFields: {
        createdBy: 'insUser',
        createdAt: 'insDate',
        updatedBy: 'updUser',
        updatedAt: 'updDate'
      }
    };

    const data = {};
    const context = { userId: 'admin123' };

    UnifiedService.injectAuditFields(mockEntity, data, context, false);

    assert.strictEqual(data.insUser, 'admin123');
    assert.strictEqual(data.updUser, 'admin123');
    assert.notStrictEqual(data.insDate, undefined);
    assert.notStrictEqual(data.updDate, undefined);
  });

  // -------------------------------------------------------------
  // 4. AUTOCOMPLETE ENGINE TESTS
  // -------------------------------------------------------------
  console.log('\n--- 4. Autocomplete Engine Tests ---');

  test('Load and resolve autocomplete template for Acc/Account', () => {
    const meta = autocompleteService.getMetadata('Acc', 'Account');
    assert.notStrictEqual(meta, null);
    assert.strictEqual(meta.Synonym, 'Acc_Acc');
    assert.notStrictEqual(meta.Select, undefined);
  });

  // Regression cover for the injection fix: 17 shipped templates interpolate a
  // parameter in numeric context (e.g. "stor_id={storId}"), where quote-escaping
  // offers no protection. Caller values must always leave as bind parameters.
  const numericCondMeta = {
    Synonym: 'Stor_Items',
    Select: 'SELECT Id, Name FROM Stor_Items',
    Conds: { storId: 'stor_id={storId}' }
  };
  const termCondMeta = {
    Synonym: 'Acc_Acc',
    Select: "SELECT Id, Num||' - '||Name AS Name FROM Acc_Acc",
    Condition: 'STATUS_ID = 1',
    Conds: { term: "Lower(Num||' - '||Name) LIKE '%{term}%'" }
  };

  test('Autocomplete binds numeric-context params instead of interpolating them', () => {
    const payload = '1 OR 1=1';

    for (const dbType of ['oracle', 'mysql', 'postgres']) {
      const { sql, params } = autocompleteService.buildQuery(numericCondMeta, 'Items', dbType, { storId: payload }, {});
      assert.strictEqual(sql.includes('OR 1=1'), false, `${dbType}: payload must not reach the SQL text`);

      const values = Array.isArray(params) ? params : Object.values(params);
      assert.deepStrictEqual(values, [payload], `${dbType}: payload must be a bind value`);
    }
  });

  test('Autocomplete emits dialect-correct bind placeholders', () => {
    const oracle = autocompleteService.buildQuery(numericCondMeta, 'Items', 'oracle', { storId: 5 }, {});
    assert.strictEqual(oracle.sql.includes('stor_id=:ac_1'), true);
    assert.deepStrictEqual(oracle.params, { ac_1: 5 });

    const mysql = autocompleteService.buildQuery(numericCondMeta, 'Items', 'mysql', { storId: 5 }, {});
    assert.strictEqual(mysql.sql.includes('stor_id=?'), true);
    assert.deepStrictEqual(mysql.params, [5]);

    const pg = autocompleteService.buildQuery(numericCondMeta, 'Items', 'postgres', { storId: 5 }, {});
    assert.strictEqual(pg.sql.includes('stor_id=$1'), true);
    assert.deepStrictEqual(pg.params, [5]);
  });

  test('Autocomplete LIKE template binds the whole literal, wildcards included', () => {
    const { sql, params } = autocompleteService.buildQuery(termCondMeta, 'Account', 'oracle', { term: 'CASH' }, {});

    assert.strictEqual(sql.includes('LIKE :ac_1'), true, 'LIKE argument should be a bind');
    assert.strictEqual(sql.includes('%'), false, 'wildcards belong in the value, not the SQL');
    assert.deepStrictEqual(params, { ac_1: '%cash%' }, 'term stays lower-cased for the Lower() comparison');
    assert.strictEqual(sql.includes('(STATUS_ID = 1)'), true, 'metadata Condition should survive');
  });

  test('Autocomplete quote in a term cannot break out of the literal', () => {
    const { sql, params } = autocompleteService.buildQuery(termCondMeta, 'Account', 'oracle', { term: "x' OR '1'='1" }, {});

    assert.strictEqual(sql.includes("OR '1'='1"), false, 'payload must not reach the SQL text');
    assert.deepStrictEqual(params, { ac_1: "%x' or '1'='1%" });
  });

  test('Autocomplete omits conditions whose parameter was not supplied', () => {
    const absent = autocompleteService.buildQuery(numericCondMeta, 'Items', 'mysql', {}, {});
    assert.strictEqual(absent.sql.includes('stor_id'), false);
    assert.deepStrictEqual(absent.params, []);

    const blank = autocompleteService.buildQuery(numericCondMeta, 'Items', 'mysql', { storId: '   ' }, {});
    assert.strictEqual(blank.sql.includes('stor_id'), false);

    // Values fall back to the request context when absent from the query params.
    const fromContext = autocompleteService.buildQuery(numericCondMeta, 'Items', 'mysql', {}, { storId: 7 });
    assert.deepStrictEqual(fromContext.params, [7]);
  });

  test('Autocomplete row limit rejects non-numeric and caps oversized page sizes', () => {
    const garbage = autocompleteService.buildQuery(numericCondMeta, 'Items', 'mysql', { pageSize: 'DROP TABLE' }, {});
    assert.strictEqual(garbage.sql.includes('DROP'), false);
    assert.strictEqual(/LIMIT \d+$/.test(garbage.sql), true);

    const oversized = autocompleteService.buildQuery(numericCondMeta, 'Items', 'mysql', { pageSize: 999999 }, {});
    assert.strictEqual(oversized.sql.endsWith('LIMIT 500'), true, 'should cap at MAX_AUTOCOMPLETE_ROWS');

    const negative = autocompleteService.buildQuery(numericCondMeta, 'Items', 'mysql', { pageSize: -5 }, {});
    assert.strictEqual(negative.sql.includes('-5'), false);
  });

  // -------------------------------------------------------------
  // 4b. PASSWORD VERIFICATION TESTS
  // -------------------------------------------------------------
  console.log('\n--- 4b. Password Verification Tests ---');

  const passwordUtil = require('../utils/password');

  await testAsync('Password verify accepts a bcrypt digest and rejects a wrong one', async () => {
    const digest = await passwordUtil.hash('correct horse');
    assert.strictEqual(passwordUtil.isHashed(digest), true, 'hash() must produce a recognisable digest');

    const good = await passwordUtil.verify('correct horse', digest);
    assert.deepStrictEqual(good, { valid: true, legacy: false });

    const bad = await passwordUtil.verify('wrong horse', digest);
    assert.deepStrictEqual(bad, { valid: false, legacy: false });
  });

  await testAsync('Password verify still accepts legacy plaintext and flags it', async () => {
    const good = await passwordUtil.verify('PhPass', 'PhPass');
    assert.deepStrictEqual(good, { valid: true, legacy: true }, 'existing tenants must keep working');

    const bad = await passwordUtil.verify('nope', 'PhPass');
    assert.deepStrictEqual(bad, { valid: false, legacy: true });
  });

  await testAsync('Password verify rejects null/undefined stored values', async () => {
    assert.deepStrictEqual(await passwordUtil.verify('x', null), { valid: false, legacy: false });
    assert.deepStrictEqual(await passwordUtil.verify('x', undefined), { valid: false, legacy: false });
    assert.deepStrictEqual(await passwordUtil.verify(null, 'x'), { valid: false, legacy: false });
  });

  await testAsync('Password verify handles length mismatch without throwing', async () => {
    // crypto.timingSafeEqual throws on unequal buffer lengths, so the constant
    // time comparison has to handle that case itself.
    const short = await passwordUtil.verify('a', 'a-much-longer-stored-value');
    assert.deepStrictEqual(short, { valid: false, legacy: true });

    const long = await passwordUtil.verify('a-much-longer-submitted-value', 'a');
    assert.deepStrictEqual(long, { valid: false, legacy: true });
  });

  test('isHashed distinguishes digests from plaintext that looks similar', () => {
    assert.strictEqual(passwordUtil.isHashed('$2b$12$abcdefghijklmnopqrstuv'), true);
    assert.strictEqual(passwordUtil.isHashed('$2a$10$abcdefghijklmnopqrstuv'), true);
    assert.strictEqual(passwordUtil.isHashed('PhPass'), false);
    assert.strictEqual(passwordUtil.isHashed('$2x$99$notreally'), false);
    assert.strictEqual(passwordUtil.isHashed(''), false);
    assert.strictEqual(passwordUtil.isHashed(null), false);
  });

  // -------------------------------------------------------------
  // 4c. AUTHORIZATION TARGET MAPPING TESTS
  // -------------------------------------------------------------
  console.log('\n--- 4c. Authorization Mapping Tests ---');

  const authorize = require('../middleware/authorize');
  const normalizeTarget = authorize.normalizeTarget;

  test('Authorize maps request paths to a package/table target', () => {
    assert.strictEqual(normalizeTarget('/UC/Acc/Account/List'), 'acc/account');
    assert.strictEqual(normalizeTarget('/PhsAPI/UC/Acc/Account/List'), 'acc/account');
    assert.strictEqual(normalizeTarget('/PhsAPI/Acc/Account/Get/12'), 'acc/account');
    assert.strictEqual(normalizeTarget('/UC/Stor/Items/Search/1/20'), 'stor/items');
  });

  test('Authorize normalises stored MPrg_ApiURL values the same way', () => {
    // The column's shape varies by tenant, so every plausible form has to reduce
    // to the same key as the request path it guards.
    assert.strictEqual(normalizeTarget('Acc/Account'), 'acc/account');
    assert.strictEqual(normalizeTarget('/Acc/Account'), 'acc/account');
    assert.strictEqual(normalizeTarget('/PhsAPI/Acc/Account'), 'acc/account');
    assert.strictEqual(normalizeTarget('/UC/Acc/Account/List'), 'acc/account');
    assert.strictEqual(normalizeTarget('https://api.example.com/PhsAPI/Acc/Account'), 'acc/account');
    assert.strictEqual(normalizeTarget('/UC/Acc/Account?x=1'), 'acc/account');
    assert.strictEqual(normalizeTarget('ACC/ACCOUNT'), 'acc/account');
  });

  test('Authorize returns null for paths that are not program-scoped', () => {
    // These carry no package/table pair, so they cannot be permission-checked.
    assert.strictEqual(normalizeTarget('/UC/InitForm'), null);
    assert.strictEqual(normalizeTarget('/CC/getCopies'), null);
    assert.strictEqual(normalizeTarget(''), null);
    assert.strictEqual(normalizeTarget(null), null);
    assert.strictEqual(normalizeTarget('/PhsAPI'), null);
  });

  // -------------------------------------------------------------
  // 5. SERVER INTEGRATION & ROUTE MATCHING TESTS
  // -------------------------------------------------------------
  console.log('\n--- 5. Express Server Health & Route Verification ---');

  const server = http.createServer(require('../server'));
  await new Promise((resolve) => server.listen(3009, resolve));

  await testAsync('Health endpoint GET /health returns 200 OK', async () => {
    const res = await new Promise((resolve, reject) => {
      http.get('http://localhost:3009/health', (response) => {
        let body = '';
        response.on('data', chunk => body += chunk);
        response.on('end', () => resolve({ status: response.statusCode, body: JSON.parse(body) }));
      }).on('error', reject);
    });

    assert.strictEqual(res.status, 200);
    assert.strictEqual(res.body.status, 'OK');
    assert.strictEqual(Array.isArray(res.body.packages), true);
  });

  await testAsync('Protected API endpoint without JWT returns 401 UNAUTHORIZED status', async () => {
    const res = await new Promise((resolve, reject) => {
      http.get('http://localhost:3009/PhsAPI/Acc/Account/List', (response) => {
        let body = '';
        response.on('data', chunk => body += chunk);
        response.on('end', () => resolve({ status: response.statusCode, body: JSON.parse(body) }));
      }).on('error', reject);
    });

    assert.strictEqual(res.body.status, false);
    assert.strictEqual(res.body.code, 401);
  });

  const jwt = require('jsonwebtoken');
  const env = require('../config/env');
  const testToken = jwt.sign({ jui: 1, Copy: '01-Admin' }, env.jwtSecret);

  await testAsync('Authenticated POST /UC/InitForm returns 200 OK', async () => {
    const postData = JSON.stringify({ package: 'Acc', table: 'Acc_Master' });
    const res = await new Promise((resolve, reject) => {
      const req = http.request('http://localhost:3009/UC/InitForm', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${testToken}`,
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(postData)
        }
      }, (response) => {
        let body = '';
        response.on('data', chunk => body += chunk);
        response.on('end', () => resolve({ status: response.statusCode, body: JSON.parse(body) }));
      });
      req.on('error', reject);
      req.write(postData);
      req.end();
    });

    assert.strictEqual(res.body.status, true);
    assert.strictEqual(res.body.code, 200);
  });

  await testAsync('Authenticated POST /CC/getCopies returns 200 OK', async () => {
    const res = await new Promise((resolve, reject) => {
      const req = http.request('http://localhost:3009/CC/getCopies', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${testToken}`
        }
      }, (response) => {
        let body = '';
        response.on('data', chunk => body += chunk);
        response.on('end', () => resolve({ status: response.statusCode, body: JSON.parse(body) }));
      });
      req.on('error', reject);
      req.end();
    });

    assert.strictEqual(res.body.status, true);
    assert.strictEqual(res.body.code, 200);
    assert.strictEqual(Array.isArray(res.body.data), true);
  });


  server.close();

  // -------------------------------------------------------------
  // SUMMARY RESULTS
  // -------------------------------------------------------------
  console.log('\n===================================================');
  console.log(`       TEST RESULTS: ${passedTests} / ${totalTests} PASSED        `);
  console.log('===================================================\n');

  process.exit(passedTests === totalTests ? 0 : 1);
}

runAllTests();

