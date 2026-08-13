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
  const testToken = jwt.sign({ jui: 1, Copy: '01-Admin' }, process.env.JWT_SECRET || 'phs_api_secret_key_2026');

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

