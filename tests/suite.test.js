const assert = require('assert');
const path = require('path');
const http = require('http');

// Import core modules
const mainApp = require('../metadata/registry');
const sqlBuilder = require('../core/query');
const { UnifiedService, ValidationError } = require('../services/unifiedService');
const autocompleteService = require('../services/autocompleteService');

console.log('===================================================');
console.log('        PhsAPI COMPREHENSIVE TEST SUITE           ');
console.log('===================================================\n');

let passedTests = 0;
let totalTests = 0;
let skippedTests = 0;

// Some tests need a fully provisioned tenant (Cpy_User, Phs_Cpy and friends),
// which a plain checkout and CI do not have. They are skipped unless asked for:
//   RUN_INTEGRATION_TESTS=1 npm test
const RUN_INTEGRATION = process.env.RUN_INTEGRATION_TESTS === '1';

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

/** Runs only when RUN_INTEGRATION_TESTS=1; otherwise reported as skipped. */
async function testIntegration(name, fn) {
  if (!RUN_INTEGRATION) {
    skippedTests++;
    console.log(`- [SKIP] ${name} (needs a provisioned tenant; set RUN_INTEGRATION_TESTS=1)`);
    return;
  }
  await testAsync(name, fn);
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

    // The ported schema names every object after its Oracle synonym, since
    // neither MySQL nor PostgreSQL has synonyms and a foreign key cannot
    // reference a view. All three builders therefore resolve the synonym.
    assert.strictEqual(sql.includes('FROM `Acc_Mst`'), true, 'MySQL query should use the synonym with backticks');
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

    // Synonym, and lower-cased: the schema is created from unquoted DDL, so
    // PostgreSQL stores every identifier in lower case and a quoted mixed-case
    // reference would not match it. Column aliases keep their camelCase.
    assert.strictEqual(sql.includes('INSERT INTO "acc_mst"'), true);
    assert.strictEqual(sql.includes('RETURNING "id"'), true);
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

  // Injection regression cover for autocomplete lives in
  // tests/autocomplete.security.test.js, which targets the ParamBinder API.

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
    const good = await passwordUtil.verify('legacy-sample-pw', 'legacy-sample-pw');
    assert.deepStrictEqual(good, { valid: true, legacy: true }, 'existing tenants must keep working');

    const bad = await passwordUtil.verify('nope', 'legacy-sample-pw');
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
    assert.strictEqual(passwordUtil.isHashed('legacy-sample-pw'), false);
    assert.strictEqual(passwordUtil.isHashed('$2x$99$notreally'), false);
    assert.strictEqual(passwordUtil.isHashed(''), false);
    assert.strictEqual(passwordUtil.isHashed(null), false);
  });

  // -------------------------------------------------------------
  // 4f. AUDIT TRAIL TESTS
  // -------------------------------------------------------------
  console.log('\n--- 4f. Audit Trail Tests ---');

  const auditService = require('../services/auditService');

  await testAsync('Audit failures never propagate to the caller', async () => {
    auditService.resetBreakers();

    // 'no-such-copy' cannot be resolved, so the write fails. record() must
    // still resolve false rather than reject, or a successful mutation would be
    // reported to the client as an error.
    const written = await auditService.record({
      type: 'CREATE',
      text: 'test',
      context: { tenantId: 'no-such-copy', userId: '1' }
    });

    assert.strictEqual(written, false);
    auditService.resetBreakers();
  });

  await testAsync('Audit breaker stops retrying a tenant that keeps failing', async () => {
    auditService.resetBreakers();
    const tenant = 'another-missing-copy';

    for (let i = 0; i < auditService.FAILURE_THRESHOLD; i++) {
      await auditService.record({ type: 'CREATE', text: 'test', context: { tenantId: tenant, userId: '1' } });
    }

    assert.strictEqual(
      auditService.failureCount(tenant) >= auditService.FAILURE_THRESHOLD,
      true,
      'consecutive failures should reach the threshold'
    );

    // Past the threshold the tenant is skipped outright.
    const skipped = await auditService.record({ type: 'CREATE', text: 'test', context: { tenantId: tenant, userId: '1' } });
    assert.strictEqual(skipped, false);

    auditService.resetBreakers();
    assert.strictEqual(auditService.failureCount(tenant), 0, 'resetBreakers should clear the count');
  });

  // -------------------------------------------------------------
  // 4e. REPORT / DASHBOARD TESTS
  // -------------------------------------------------------------
  console.log('\n--- 4e. Report & Dashboard Tests ---');

  const reportService = require('../services/reportService');

  test('Report metadata is projected from registered entity metadata', () => {
    // Reports are registered as ordinary entities, so init must resolve real
    // metadata rather than the empty placeholder the endpoint used to return.
    const meta = reportService.resolve('Acc', 'Acc_Master') || reportService.resolve('Acc', 'Master');
    assert.notStrictEqual(meta.report, null);
    assert.strictEqual(meta.report.getFields().length > 0, true, 'fields must not be empty');
    assert.strictEqual(typeof meta.report.getTitle(), 'string');
    assert.strictEqual(meta.report.getParameters().length > 0, true, 'queryable fields become parameters');
  });

  test('Unknown report name raises rather than returning empty data', () => {
    assert.throws(() => reportService.resolve('Nope', 'DoesNotExist'), /Report metadata not found/);
  });

  test('Report aggregations summarise numeric columns only', () => {
    const rows = [
      { region: 'North', amount: 10, qty: 2 },
      { region: 'South', amount: 30, qty: 4 },
      { region: 'East', amount: 20, qty: null }
    ];
    const agg = reportService.calculateAggregations(rows);

    assert.strictEqual(agg.amount_sum, 60);
    assert.strictEqual(agg.amount_avg, 20);
    assert.strictEqual(agg.amount_min, 10);
    assert.strictEqual(agg.amount_max, 30);
    assert.strictEqual(agg.amount_count, 3);

    // Nulls are excluded rather than counted as zero.
    assert.strictEqual(agg.qty_count, 2);
    assert.strictEqual(agg.qty_sum, 6);

    // A text column produces no aggregates at all.
    assert.strictEqual(agg.region_sum, undefined);
  });

  test('Report aggregations handle an empty result set', () => {
    assert.deepStrictEqual(reportService.calculateAggregations([]), {});
    assert.deepStrictEqual(reportService.calculateAggregations(null), {});
  });

  test('Chart field detection picks a label and a numeric value column', () => {
    const rows = [{ month: 'Jan', label2: 'x', total: 100 }];

    // Auto: first column labels, first numeric non-label column supplies values.
    const auto = reportService.resolveChartFields(rows, {});
    assert.strictEqual(auto.labelField, 'month');
    assert.strictEqual(auto.valueField, 'total', 'must skip the non-numeric column');

    // Explicit choices win when they name real columns.
    const explicit = reportService.resolveChartFields(rows, { labelField: 'label2', valueField: 'total' });
    assert.strictEqual(explicit.labelField, 'label2');

    // A field that is not in the result set falls back to detection.
    const bogus = reportService.resolveChartFields(rows, { labelField: 'nope' });
    assert.strictEqual(bogus.labelField, 'month');
  });

  test('Chart field detection copes with no numeric columns and no rows', () => {
    const textOnly = reportService.resolveChartFields([{ a: 'x', b: 'y' }], {});
    assert.strictEqual(textOnly.labelField, 'a');
    assert.strictEqual(textOnly.valueField, null);

    const empty = reportService.resolveChartFields([], {});
    assert.strictEqual(empty.labelField, null);
    assert.strictEqual(empty.valueField, null);
  });

  test('Report parameter parsing accepts strings, objects and junk', () => {
    const { parseParams } = require('../services/reportService');
    assert.deepStrictEqual(parseParams('{"page":2}'), { page: 2 });
    assert.deepStrictEqual(parseParams({ page: 3 }), { page: 3 });
    assert.deepStrictEqual(parseParams('not json'), { data: 'not json' });
    assert.deepStrictEqual(parseParams(null), {});
    assert.deepStrictEqual(parseParams(''), {});
  });

  // -------------------------------------------------------------
  // 4d. PAGINATION COERCION TESTS
  // -------------------------------------------------------------
  console.log('\n--- 4d. Pagination Coercion Tests ---');

  const { coercePage, coercePageSize, MAX_PAGE_SIZE } = require('../utils/pagination');

  test('Pagination coerces unusable page values to the first page', () => {
    assert.strictEqual(coercePage('3'), 3);
    assert.strictEqual(coercePage(3), 3);
    // parseInt alone would yield NaN here and reach the query builder.
    assert.strictEqual(coercePage('abc'), 1);
    assert.strictEqual(coercePage(undefined), 1);
    assert.strictEqual(coercePage(null), 1);
    assert.strictEqual(coercePage(0), 1);
    assert.strictEqual(coercePage(-4), 1);
  });

  test('Pagination caps page size so one request cannot pull a whole table', () => {
    assert.strictEqual(coercePageSize('50'), 50);
    assert.strictEqual(coercePageSize(999999), MAX_PAGE_SIZE);
    assert.strictEqual(coercePageSize('abc'), 20, 'falls back to the default');
    assert.strictEqual(coercePageSize(undefined), 20);
    assert.strictEqual(coercePageSize(0), 20);
    assert.strictEqual(coercePageSize(-10), 20);
  });

  test('Pagination honours a caller-supplied fallback but still caps it', () => {
    assert.strictEqual(coercePageSize(undefined, 500), 500);
    assert.strictEqual(coercePageSize(undefined, 99999), MAX_PAGE_SIZE);
  });

  // -------------------------------------------------------------
  // 4c. AUTHORIZATION TARGET MAPPING TESTS
  // -------------------------------------------------------------
  console.log('\n--- 4c. Authorization Mapping Tests ---');

  const authorize = require('../services/accessPolicy');

  // Resolution runs through mainApp, so pin it to what the server loads.
  mainApp.loadMetadata(path.join(__dirname, '..', 'resources', 'modules'));

  test('Authorize resolves a request package/table to its entity key', () => {
    // Callers reach the same entity by full name or short name, and both have to
    // reduce to one key or a grant would cover only half the ways in.
    assert.strictEqual(authorize.requestTarget('Acc', 'Acc_Master'), 'acc/acc_master');
    assert.strictEqual(authorize.requestTarget('Acc', 'Master'), 'acc/acc_master');
    assert.strictEqual(authorize.requestTarget('acc', 'ACC_MASTER'), 'acc/acc_master');
  });

  test('Authorize resolves MPrg_RelTable to the key a request produces', () => {
    // This is what makes the permission check work at all: the grant side stores
    // an entity synonym ('Acc_Mst') and the request side names a package and
    // table, and the two have to meet.
    const pairs = [
      ['Acc_Mst', ['Acc', 'Acc_Master']],
      ['Acc_Acc', ['Acc', 'Account']],
      ['Acc_Cost', ['Acc', 'Acc_Cost_Centers']],
      ['Acc_BudMst', ['Acc', 'Budget_Master']]
    ];

    for (const [relTable, [pkg, table]] of pairs) {
      const fromGrant = authorize.relTableTarget(relTable);
      const fromRequest = authorize.requestTarget(pkg, table);
      assert.ok(fromGrant, `${relTable} should resolve`);
      assert.strictEqual(fromGrant, fromRequest, `${relTable} vs ${pkg}/${table}`);
    }
  });

  await testAsync('Authorize decides on the program id when the caller sends one', async () => {
    const TENANT = 'test-copy';
    const USER = { userId: '77' };
    authorize.clearCache();

    // Group holds programs 10 and 11, whose tables are Acc_Master and Account.
    authorize.primeCache(TENANT, USER.userId, {
      unrestricted: false,
      tables: ['acc/acc_master', 'acc/acc_account'],
      programIds: [10, 11]
    });
    authorize.primeGoverned(TENANT, ['acc/acc_master', 'acc/acc_account', 'stor/stor_items']);

    // A claimed program the caller holds, on a table the caller may reach.
    let d = await authorize.decide(TENANT, USER, 'Acc', 'Acc_Master', 10);
    assert.strictEqual(d.allowed, true, d.reason);

    // A claimed program the caller does not hold is refused outright.
    d = await authorize.decide(TENANT, USER, 'Acc', 'Acc_Master', 99);
    assert.strictEqual(d.allowed, false, d.reason);

    // Routes with no package/table pair are still decided, which the table-based
    // check could never do -- this is what covers attachments and InitForm.
    d = await authorize.decide(TENANT, USER, undefined, undefined, 11);
    assert.strictEqual(d.allowed, true, d.reason);

    d = await authorize.decide(TENANT, USER, undefined, undefined, 99);
    assert.strictEqual(d.allowed, false, d.reason);

    authorize.clearCache();
  });

  await testAsync('Holding a program does not waive the check on the table', async () => {
    const TENANT = 'test-copy';
    const USER = { userId: '77' };
    authorize.clearCache();

    // The caller holds program 10 only, which binds Acc_Master. Account is bound
    // by a program they do not hold.
    authorize.primeCache(TENANT, USER.userId, {
      unrestricted: false,
      tables: ['acc/acc_master'],
      programIds: [10]
    });
    authorize.primeGoverned(TENANT, ['acc/acc_master', 'acc/acc_account']);

    // Claiming a program they do hold must not carry them into a governed table
    // they do not. The two checks constrain different things.
    let d = await authorize.decide(TENANT, USER, 'Acc', 'Account', 10);
    assert.strictEqual(d.allowed, false, d.reason);

    // The same request without the header is refused the same way, so sending
    // one can never be a way to get more than not sending one.
    d = await authorize.decide(TENANT, USER, 'Acc', 'Account', null);
    assert.strictEqual(d.allowed, false, d.reason);

    // A table no program binds -- a lookup or child a screen reads alongside its
    // master -- stays reachable, which is what keeps multi-table screens working.
    d = await authorize.decide(TENANT, USER, 'Acc', 'Acc_Code_Table', 10);
    assert.strictEqual(d.allowed, true, d.reason);

    authorize.clearCache();
  });

  await testAsync('Authorize falls back to the table when no program id is sent', async () => {
    const TENANT = 'test-copy';
    const USER = { userId: '77' };
    authorize.clearCache();

    authorize.primeCache(TENANT, USER.userId, {
      unrestricted: false,
      tables: ['acc/acc_master'],
      programIds: [10]
    });
    authorize.primeGoverned(TENANT, ['acc/acc_master', 'acc/acc_account']);

    // Granted table.
    let d = await authorize.decide(TENANT, USER, 'Acc', 'Acc_Master', null);
    assert.strictEqual(d.allowed, true, d.reason);

    // Governed by some program, but not one this caller holds.
    d = await authorize.decide(TENANT, USER, 'Acc', 'Account', null);
    assert.strictEqual(d.allowed, false, d.reason);

    // No program binds it, so there is no permission to withhold.
    d = await authorize.decide(TENANT, USER, 'Stor', 'Items', null);
    assert.strictEqual(d.allowed, true, d.reason);

    // Neither a program nor a table: nothing to check.
    d = await authorize.decide(TENANT, USER, undefined, undefined, null);
    assert.strictEqual(d.allowed, true, d.reason);

    authorize.clearCache();
  });

  await testAsync('Authorize lets an unrestricted caller through either way', async () => {
    const TENANT = 'test-copy';
    const USER = { userId: '78' };
    authorize.clearCache();
    authorize.primeCache(TENANT, USER.userId, { unrestricted: true });

    for (const mprg of [null, 99]) {
      const d = await authorize.decide(TENANT, USER, 'Acc', 'Acc_Master', mprg);
      assert.strictEqual(d.allowed, true, `mprgId=${mprg}: ${d.reason}`);
    }

    authorize.clearCache();
  });

  test('Authorize returns null for targets it cannot resolve', () => {
    // A null means "nothing to check against", which the middleware lets through
    // rather than denying -- the service layer rejects the unknown entity anyway.
    assert.strictEqual(authorize.requestTarget('NoSuchPkg', 'NoSuchTable'), null);
    assert.strictEqual(authorize.requestTarget('', ''), null);
    assert.strictEqual(authorize.relTableTarget('No_Such_Synonym'), null);
    assert.strictEqual(authorize.relTableTarget(''), null);
    assert.strictEqual(authorize.relTableTarget(null), null);
    assert.strictEqual(authorize.relTableTarget(undefined), null);
  });

  // -------------------------------------------------------------
  // 4g. ATTACHMENT AUTHORIZATION TESTS
  // -------------------------------------------------------------
  console.log('\n--- 4g. Attachment Authorization Tests ---');

  const env = require('../config/env');

  // checkProgram reads env.rbacMode on every call, so the rollout stage can be
  // driven from here. Restored after each test.
  async function withRbacMode(mode, fn) {
    const previous = env.rbacMode;
    env.rbacMode = mode;
    try {
      return await fn();
    } finally {
      env.rbacMode = previous;
    }
  }

  test('Attachment entity resolves, and carries the program id the check needs', () => {
    // Load what the server loads. Test 1 above also pulls in db/JSON/pkgs, where
    // Cpy/reports/AttachedFiles.json declares the same Cpy_Attach synonym with
    // zero columns and, registering last, overwrites the real definition. The
    // server only ever reads resources/modules, so that is the shape these
    // handlers actually see.
    mainApp.loadMetadata(path.join(__dirname, '..', 'resources', 'modules'));

    // The /CC/attached handlers used to look this up as 'Phs_Attached' or
    // 'Cpy_Attached'. Neither is a registered name, so every lookup returned null
    // and the handlers silently fabricated success. Guard the real name.
    const entity = mainApp.getEntity('Cpy', 'Cpy_Attach');
    assert.ok(entity, 'Cpy/Cpy_Attach should resolve');
    assert.strictEqual(entity.tableName, 'Copy_Attached_Files');

    assert.strictEqual(mainApp.getEntity('Phs', 'Phs_Attached'), null, 'the old name should still not resolve');
    assert.strictEqual(mainApp.getEntity('Cpy', 'Cpy_Attached'), null, 'the old name should still not resolve');

    // Authorization is keyed on this column; without it there is nothing to check.
    const fields = entity.fields.map((f) => f.Field.toLowerCase());
    assert.ok(fields.includes('mprgid'), 'attachment rows must carry mprgId');
  });

  await testAsync('Attachment check allows everything while RBAC_MODE is off', async () => {
    // 'no-such-copy' would fail any real lookup, so a true here can only come
    // from the mode short-circuit.
    const allowed = await withRbacMode('off', () =>
      authorize.checkProgram('no-such-copy', { userId: '1' }, 999999, 'attachment 1'));
    assert.strictEqual(allowed, true);
  });

  await testAsync('Attachment check allows a row that carries no program id', async () => {
    // Matches how the route middleware skips paths with no package/table pair:
    // nothing to check against, so nothing is denied.
    for (const mode of ['audit', 'enforce']) {
      for (const missing of [null, undefined, 0, '', 'not-a-number']) {
        const allowed = await withRbacMode(mode, () =>
          authorize.checkProgram('no-such-copy', { userId: '1' }, missing, 'attachment 1'));
        assert.strictEqual(allowed, true, `mode=${mode} mprgId=${JSON.stringify(missing)}`);
      }
    }
  });

  await testAsync('Attachment check fails open in audit and closed in enforce', async () => {
    authorize.clearCache();

    // The tenant cannot be resolved, so the permission lookup throws. Audit must
    // never break a working deployment; enforce must not fall back to allowing.
    const inAudit = await withRbacMode('audit', () =>
      authorize.checkProgram('no-such-copy', { userId: '1', pgrpId: 5 }, 42, 'attachment 42'));
    assert.strictEqual(inAudit, true, 'audit should allow through a failed lookup');

    authorize.clearCache();

    const inEnforce = await withRbacMode('enforce', () =>
      authorize.checkProgram('no-such-copy', { userId: '1', pgrpId: 5 }, 42, 'attachment 42'));
    assert.strictEqual(inEnforce, false, 'enforce should deny when permissions cannot be read');

    authorize.clearCache();
  });

  // -------------------------------------------------------------
  // 5. SERVER INTEGRATION & ROUTE MATCHING TESTS
  // -------------------------------------------------------------
  console.log('\n--- 5. Express Server Health & Route Verification ---');

  const expressApp = require('../server');
  const server = http.createServer(expressApp);
  await new Promise((resolve) => server.listen(3009, resolve));

  /** Every path Express has a handler registered for. */
  function registeredPaths() {
    const paths = [];
    (function walk(stack) {
      for (const layer of stack) {
        if (layer.route) {
          paths.push(layer.route.path);
        } else if (layer.name === 'router' && layer.handle && layer.handle.stack) {
          walk(layer.handle.stack);
        }
      }
    })(expressApp._router.stack);
    return paths;
  }

  test('Envelope code becomes the HTTP status once legacy mode is off', () => {
    const { httpStatusFor } = require('../http/sendResult');
    const ResultManager = require('../http/responseManager');
    const previous = env.legacyJavaClient;

    try {
      // The Java client reads the outcome from the body and treats any non-2xx
      // as a transport failure, so while it is supported everything stays 200.
      env.legacyJavaClient = true;
      assert.strictEqual(httpStatusFor(ResultManager.error(403, 'nope')), 200);
      assert.strictEqual(httpStatusFor(ResultManager.invalid('gone')), 200);
      assert.strictEqual(httpStatusFor(ResultManager.ok({})), 200);

      env.legacyJavaClient = false;
      assert.strictEqual(httpStatusFor(ResultManager.error(403, 'nope')), 403);
      assert.strictEqual(httpStatusFor(ResultManager.error(401, 'nope')), 401);
      assert.strictEqual(httpStatusFor(ResultManager.invalid('gone')), 404);
      assert.strictEqual(httpStatusFor(ResultManager.ok({})), 200);

      // A code outside the HTTP range would make Express throw; 200 is safer
      // than taking the process down over a malformed envelope.
      assert.strictEqual(httpStatusFor({ code: 0 }), 200);
      assert.strictEqual(httpStatusFor({ code: 999 }), 200);
      assert.strictEqual(httpStatusFor({}), 200);
      assert.strictEqual(httpStatusFor(null), 200);
    } finally {
      env.legacyJavaClient = previous;
    }
  });

  test('Legacy Java URL shapes reduce to the canonical path', () => {
    const { canonicalize } = require('../http/middleware/legacyRoutes');

    // The servlet context prefix, on every shape the Java client sends.
    assert.strictEqual(canonicalize('/PhsAPI/Auth/Login'), '/Auth/Login');
    assert.strictEqual(canonicalize('/PhsAPI/UC/Acc/Master/List'), '/UC/Acc/Master/List');
    assert.strictEqual(canonicalize('/PhsAPI/CC/attached/7'), '/CC/attached/7');

    // Older endpoint names for operations that still exist.
    assert.strictEqual(canonicalize('/UserAccount/Authentication'), '/Auth/Login');
    assert.strictEqual(canonicalize('/UserAccount/getAccessToken'), '/Auth/Login');
    assert.strictEqual(canonicalize('/PhsAPI/UserAccount/Logout'), '/Auth/Logout');
    assert.strictEqual(canonicalize('/PHSAPI/useraccount/authentication'.replace('/PHSAPI', '/PhsAPI')), '/Auth/Login');

    // Query strings survive, since Search and Find carry them.
    assert.strictEqual(canonicalize('/PhsAPI/UC/Acc/Master/Search/1/20?q=x'), '/UC/Acc/Master/Search/1/20?q=x');

    // Canonical and unrelated paths are untouched.
    assert.strictEqual(canonicalize('/UC/Acc/Master/List'), '/UC/Acc/Master/List');
    assert.strictEqual(canonicalize('/Auth/Login'), '/Auth/Login');
    assert.strictEqual(canonicalize('/health'), '/health');
    assert.strictEqual(canonicalize('/UserAccount/getUserProfile'), '/UserAccount/getUserProfile');

    // A bare prefix is the root, not an empty string Express cannot match.
    assert.strictEqual(canonicalize('/PhsAPI'), '/');
  });

  test('Each operation is registered exactly once', () => {
    // The prefix and the auth aliases used to be duplicate registrations; they
    // are rewrites now, so a repeated method+path means a real duplicate.
    const seen = new Map();
    (function walk(stack) {
      for (const layer of stack) {
        if (layer.route) {
          for (const method of Object.keys(layer.route.methods)) {
            const key = `${method.toUpperCase()} ${layer.route.path}`;
            seen.set(key, (seen.get(key) || 0) + 1);
          }
        } else if (layer.name === 'router' && layer.handle && layer.handle.stack) {
          walk(layer.handle.stack);
        }
      }
    })(expressApp._router.stack);

    const duplicates = [...seen.entries()].filter(([, n]) => n > 1).map(([k]) => k);
    assert.deepStrictEqual(duplicates, [], `registered more than once: ${duplicates.join(', ')}`);
  });

  test('Only the unified routes carry :package/:table', () => {
    // authorize derives its permission target from these params, so a route that
    // carries them outside /UC is a data endpoint the middleware cannot see the
    // shape of. Keeping them in one place keeps that reasoning true.
    const stray = registeredPaths().filter(
      (p) => /:package|:table|:pkgName|:reportName/.test(p) && !p.includes('/UC/')
    );
    assert.deepStrictEqual(stray, [], `found :package/:table outside /UC: ${stray.join(', ')}`);
  });

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

  /** GETs a path and parses the envelope. */
  function getJson(pathStr) {
    return new Promise((resolve, reject) => {
      http.get(`http://localhost:3009${pathStr}`, (response) => {
        let body = '';
        response.on('data', (chunk) => { body += chunk; });
        response.on('end', () => resolve({ status: response.statusCode, body: JSON.parse(body) }));
      }).on('error', reject);
    });
  }

  await testAsync('Protected API endpoint without JWT returns 401 UNAUTHORIZED status', async () => {
    const res = await getJson('/UC/Acc/Account/List');
    assert.strictEqual(res.body.status, false);
    assert.strictEqual(res.body.code, 401);
  });

  await testAsync('Legacy /PhsAPI prefix still reaches the same route', async () => {
    // Reaching authentication rather than the 404 handler is the proof that the
    // rewrite ran and the route matched.
    const canonical = await getJson('/UC/Acc/Account/List');
    const prefixed = await getJson('/PhsAPI/UC/Acc/Account/List');
    assert.deepStrictEqual(prefixed.body, canonical.body);
    assert.strictEqual(prefixed.body.code, 401);
  });

  const jwt = require('jsonwebtoken');

  /**
   * The tenant these tests run against.
   *
   * It used to be '01-Admin', which is not a copy in Phs_Cpy on any machine --
   * so every integration test below failed with "Tenant copy not found" the
   * moment anyone set RUN_INTEGRATION_TESTS=1, and the skip was hiding it
   * rather than the tests being environment-specific. Overridable because the
   * copy that exists differs per developer.
   */
  const testTenant = process.env.TEST_TENANT || 'Demo';
  const testToken = jwt.sign({ jui: 1, Copy: testTenant }, env.jwtSecret);

  await testIntegration('Authenticated POST /UC/InitForm returns 200 OK', async () => {
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

  await testIntegration('Authenticated POST /CC/getCopies returns 200 OK', async () => {
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

  test('The screen routes sit ahead of the generic ones', () => {
    // `/UC/Screen/Program/clnc/mng/Doctors` matches `/UC/:package/:table/:id`
    // as readily as it matches its own route, and Express takes the first that
    // fits. Registered after, every screen request would have been answered by
    // getRecord with package 'Screen' and table 'Program'.
    const paths = registeredPaths();
    const screen = paths.indexOf('/UC/Screen/Program/*');
    const generic = paths.indexOf('/UC/:package/:table/:id');

    assert.notStrictEqual(screen, -1, 'the program screen route is not registered');
    assert.notStrictEqual(generic, -1, 'the generic record route is not registered');
    assert.ok(screen < generic, `screen route is registered at ${screen}, after the generic one at ${generic}`);
  });

  await testAsync('A screen cannot be read without a token', async () => {
    // The description of a screen names its table and every column on it, so it
    // is behind the same authentication as the data.
    const res = await getJson('/UC/Screen/Program/clnc/mng/Doctors');
    assert.strictEqual(res.body.status, false);
    assert.strictEqual(res.body.code, 401);
  });

  /** GETs a path with the test token and parses the envelope. */
  function getAuthed(pathStr) {
    return new Promise((resolve, reject) => {
      http.get(`http://localhost:3009${pathStr}`, {
        headers: { Authorization: `Bearer ${testToken}` }
      }, (response) => {
        let body = '';
        response.on('data', chunk => body += chunk);
        response.on('end', () => resolve({ status: response.statusCode, body: JSON.parse(body) }));
      }).on('error', reject);
    });
  }

  await testIntegration('A program screen is served composed, over HTTP', async () => {
    const res = await getAuthed('/UC/Screen/Program/clnc/mng/Doctors');

    assert.strictEqual(res.body.status, true, `expected a screen, got: ${res.body.message}`);
    const screen = res.body.data;

    assert.strictEqual(screen.endpoint, '/UC/Clnc/Doctors');
    assert.strictEqual(screen.primaryKey, 'id');
    assert.deepStrictEqual(screen.dropped, [], 'the screen names columns its entity does not have');

    // Every field arrives ready to draw: translated, typed, and with somewhere
    // to read its options from.
    const fields = screen.form.fields;
    assert.ok(fields.length > 0, 'no form fields');
    for (const field of fields) {
      assert.ok(field.label, `${field.name} has no label`);
      assert.ok(field.input, `${field.name} has no input kind`);
    }

    const special = fields.find(f => f.name === 'specialId');
    assert.strictEqual(special.input, 'select');
    assert.strictEqual(special.lookup, '/UC/Clnc/Specials');
    assert.strictEqual(special.displayField, 'specialName');

    // A reference too large to list is searched instead, which is the one thing
    // the schema cannot imply and the screen file does say.
    const user = fields.find(f => f.name === 'userId');
    assert.strictEqual(user.input, 'autocomplete');
    assert.strictEqual(user.endpoint, '/UC/Cpy/Users/Autocomplete');
  });

  await testIntegration('A program nothing describes is answered with 404, not an empty screen', async () => {
    const res = await getAuthed('/UC/Screen/Program/no/such/program');
    assert.strictEqual(res.body.status, false);
    assert.strictEqual(res.body.code, 404);
  });

  /** POSTs a path with the test token and parses the envelope. */
  function postAuthed(pathStr, body) {
    const payload = JSON.stringify(body);
    return new Promise((resolve, reject) => {
      const req = http.request(`http://localhost:3009${pathStr}`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${testToken}`,
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(payload)
        }
      }, (response) => {
        let body2 = '';
        response.on('data', chunk => { body2 += chunk; });
        response.on('end', () => resolve({ status: response.statusCode, body: JSON.parse(body2) }));
      });
      req.on('error', reject);
      req.write(payload);
      req.end();
    });
  }

  await testIntegration('A search narrows the result, and both spellings narrow it the same way', async () => {
    // Against a real table, over HTTP, with the operator engine in the path.
    // The point is not that rows come back -- it is that FEWER come back than
    // the unfiltered list, which is what every search this API served was
    // failing to do.
    const all = await postAuthed('/UC/Phs/CodeStatus/Search/1/200', []);
    assert.strictEqual(all.body.status, true, `unfiltered search failed: ${all.body.message}`);
    const total = (all.body.data.data || []).length;
    assert.ok(total > 1, `expected several statuses, got ${total}`);

    const canonical = await postAuthed('/UC/Phs/CodeStatus/Search/1/200',
      [{ field: 'id', operator: '=', value: 1 }]);
    const java = await postAuthed('/UC/Phs/CodeStatus/Search/1/200',
      [{ fieldName: 'id', dataType: 2, operation: '=', value1: 1, value2: '' }]);

    const canonicalRows = canonical.body.data.data || [];
    const javaRows = java.body.data.data || [];

    assert.strictEqual(canonicalRows.length, 1, `expected one row, got ${canonicalRows.length} of ${total}`);
    assert.strictEqual(javaRows.length, 1,
      `the Java spelling did not narrow: ${javaRows.length} of ${total}`);
    assert.deepStrictEqual(javaRows, canonicalRows, 'the two spellings returned different rows');
  });

  await testIntegration('A range operator is a range, against the database', async () => {
    // `<>` is BETWEEN. If it were read as "not equal" this would return
    // everything except one row rather than the rows inside the bounds.
    const between = await postAuthed('/UC/Phs/CodeStatus/Search/1/200',
      [{ field: 'id', operator: '<>', value: 1, value2: 2 }]);

    assert.strictEqual(between.body.status, true, `search failed: ${between.body.message}`);
    const ids = (between.body.data.data || []).map(row => Number(row.id));

    assert.ok(ids.length > 0, 'a BETWEEN over the first two ids returned nothing');
    assert.deepStrictEqual(ids.filter(id => id < 1 || id > 2), [],
      `BETWEEN 1 AND 2 returned ids outside it: ${ids.join(', ')}`);
  });

  await testIntegration('An operator a column forbids is refused, not ignored', async () => {
    const res = await postAuthed('/UC/Phs/CodeStatus/Search/1/200',
      [{ field: 'id', operator: '[%', value: '1' }]);

    assert.strictEqual(res.body.status, false, 'starts-with on a number should be refused');
  });

  await testIntegration('A report filters, rather than returning the whole view', async () => {
    // reportService read `params.filters` and nothing else, so a query screen's
    // conditions were discarded and every /Query call answered with the first
    // page of the view whatever the user asked for.
    const all = await postAuthed('/UC/Phs/CodeStatus/Query', {});
    assert.strictEqual(all.body.status, true, `unfiltered report failed: ${all.body.message}`);

    const total = all.body.data.report.rows.length;
    assert.ok(total > 1, `expected several statuses, got ${total}`);

    const filtered = await postAuthed('/UC/Phs/CodeStatus/Query', {
      conditions: [{ field: 'id', operator: '=', value: 1 }]
    });

    assert.strictEqual(filtered.body.data.report.rows.length, 1,
      `expected one row, got ${filtered.body.data.report.rows.length} of ${total}`);
  });

  await testIntegration('A report answers where the Java client reads', async () => {
    // PhsQuery reads response.data.report.rows. Without it every result looked
    // empty to that client however many rows came back.
    const res = await postAuthed('/UC/Phs/CodeStatus/Query', {});

    assert.ok(res.body.data.report, 'no report object');
    assert.ok(Array.isArray(res.body.data.report.rows), 'report.rows is not a list');
    assert.deepStrictEqual(res.body.data.report.rows, res.body.data.data,
      'the two shapes should carry the same rows');
    assert.ok(res.body.data.report.columns.length > 0, 'no columns reported');
  });

  await testIntegration('A report orders by what it was asked to order by', async () => {
    const descending = await postAuthed('/UC/Phs/CodeStatus/Query', {
      order: [{ id: '-1' }]
    });
    const ids = descending.body.data.report.rows.map(row => Number(row.id));

    assert.ok(ids.length > 1, 'not enough rows to prove an order');
    const sorted = [...ids].sort((a, b) => b - a);
    assert.deepStrictEqual(ids, sorted, `not in descending order: ${ids.join(', ')}`);
  });

  await testIntegration('A grouped report groups, in the database', async () => {
    // One row per distinct value, with the count beside it -- not one row per
    // underlying row. The aggregate is keyed `<field>_<FN>`.
    const res = await postAuthed('/UC/Phs/CodeStatus/Query', {
      group: ['statusId'],
      aggregate: [{ Count: 'id' }]
    });

    assert.strictEqual(res.body.status, true, `grouped report failed: ${res.body.message}`);
    const rows = res.body.data.report.rows;

    assert.ok(rows.length > 0, 'a grouped report returned nothing');
    assert.ok('idCount' in rows[0], `expected idCount, got ${Object.keys(rows[0]).join(', ')}`);

    const distinct = new Set(rows.map(row => String(row.statusId)));
    assert.strictEqual(distinct.size, rows.length, 'a grouped report repeated a group');
  });

  await testIntegration('An aggregate a column forbids is refused, not ignored', async () => {
    const res = await postAuthed('/UC/Phs/CodeStatus/Query', {
      group: ['id'],
      aggregate: [{ Sum: 'name' }]
    });

    assert.strictEqual(res.body.status, false, 'SUM over a text column should be refused');
  });

  await testIntegration('An aggregate that is not an aggregate is refused', async () => {
    const res = await postAuthed('/UC/Phs/CodeStatus/Query', {
      group: ['id'],
      aggregate: [{ 'COUNT(*) FROM Cpy_User--': 'id' }]
    });

    assert.strictEqual(res.body.status, false, 'a function name from a request must be refused');
  });

  await testIntegration('A converted query screen runs, driven by its own metadata', async () => {
    // Not a hand-picked report: the first converted query screen whose entity
    // this copy actually has, with a condition built from what the screen
    // itself says its columns are. If the metadata cannot drive a report, this
    // fails.
    const screens = require('../metadata/screens');
    const screenView = require('../presentation/screens');

    let ran = 0;
    let narrowed = 0;
    const failures = [];

    for (const programUrl of screens.programs()) {
      if (ran >= 5) {
        break;
      }

      const screen = screenView.forProgram(programUrl, {});
      if (!screen || screen.kind !== 'query' || !screen.reportEndpoint) {
        continue;
      }

      // A column that can be compared for equality, and a value to compare it
      // against -- taken from a row the report itself returns.
      const all = await postAuthed(`${screen.reportEndpoint}/Query`, { size: 20 });
      if (all.body.status !== true) {
        continue;
      }
      const rows = all.body.data.report.rows;
      if (rows.length < 2) {
        continue;
      }

      const filterable = (screen.search ? screen.search.fields : [])
        .filter(f => (f.operators || []).includes('='))
        .find(f => {
          const value = rows[0][f.name];
          // A value that is not repeated across every row, so filtering on it
          // can be seen to have done something.
          return value !== null && value !== undefined && value !== ''
            && rows.some(row => String(row[f.name]) !== String(value));
        });

      if (!filterable) {
        continue;
      }

      ran++;
      const value = rows[0][filterable.name];

      const filtered = await postAuthed(`${screen.reportEndpoint}/Query`, {
        conditions: [{ field: filterable.name, operator: '=', value }],
        size: 200
      });

      if (filtered.body.status !== true) {
        failures.push(`${programUrl}: ${filtered.body.message}`);
        continue;
      }

      const kept = filtered.body.data.report.rows;
      const wrong = kept.filter(row => String(row[filterable.name]) !== String(value));

      if (wrong.length > 0) {
        failures.push(`${programUrl}: ${wrong.length} row(s) do not match ${filterable.name}=${value}`);
        continue;
      }
      if (kept.length === 0) {
        failures.push(`${programUrl}: filtering on a value taken from a row returned nothing`);
        continue;
      }
      narrowed++;
    }

    assert.ok(ran > 0, 'no converted query screen could be driven; nothing was proven');
    assert.deepStrictEqual(failures, [], failures.join(' | '));
    assert.strictEqual(narrowed, ran, `${ran} ran, ${narrowed} narrowed correctly`);
  });

  await testIntegration('A query screen orders by a column it says is sortable', async () => {
    const screens = require('../metadata/screens');
    const screenView = require('../presentation/screens');

    for (const programUrl of screens.programs()) {
      const screen = screenView.forProgram(programUrl, {});
      if (!screen || screen.kind !== 'query' || !screen.reportEndpoint) {
        continue;
      }

      const numeric = (screen.columns || []).find(
        c => c.input === 'number' && (screen.sortable || []).includes(c.name)
      );
      if (!numeric) {
        continue;
      }

      const res = await postAuthed(`${screen.reportEndpoint}/Query`, {
        order: [{ [numeric.name]: '-1' }],
        size: 50
      });
      if (res.body.status !== true) {
        continue;
      }

      const values = res.body.data.report.rows
        .map(row => row[numeric.name])
        .filter(v => v !== null && v !== undefined)
        .map(Number);

      if (values.length < 2) {
        continue;
      }

      const sorted = [...values].sort((a, b) => b - a);
      assert.deepStrictEqual(values, sorted,
        `${programUrl} not descending by ${numeric.name}: ${values.slice(0, 8).join(', ')}`);
      return;
    }

    assert.fail('no query screen offered a sortable numeric column to prove an order with');
  });

  await testIntegration('A query screen groups and aggregates as its metadata offers', async () => {
    // A statistics screen is a query screen with a grouping, so this drives one
    // from what the screen says may be grouped and what may be aggregated over
    // -- the same lists the renderer builds its two cards from. The aggregate
    // alias is checked too, because the client reads the answer by it.
    const screens = require('../metadata/screens');
    const screenView = require('../presentation/screens');

    let proven = 0;
    const failures = [];

    for (const programUrl of screens.programs()) {
      if (proven >= 3) {
        break;
      }

      const screen = screenView.forProgram(programUrl, {});
      if (!screen || screen.kind !== 'query' || !screen.reportEndpoint) {
        continue;
      }
      if (!(screen.groupable || []).length || !(screen.aggregable || []).length) {
        continue;
      }

      // A column worth grouping by: one the report returns more than one
      // distinct value of, so grouping visibly collapses rows.
      const sample = await postAuthed(`${screen.reportEndpoint}/Query`, { size: 50 });
      if (sample.body.status !== true) {
        continue;
      }
      const rows = sample.body.data.report.rows;
      if (rows.length < 3) {
        continue;
      }

      const groupOn = (screen.groupable || []).find((name) => {
        const values = new Set(rows.map((row) => String(row[name])));
        return values.size > 1 && values.size < rows.length;
      });
      const over = (screen.aggregable || []).find((entry) => entry.name !== groupOn);
      if (!groupOn || !over) {
        continue;
      }

      const grouped = await postAuthed(`${screen.reportEndpoint}/Query`, {
        group: [groupOn],
        aggregate: [{ Count: over.name }],
        size: 500
      });

      if (grouped.body.status !== true) {
        failures.push(`${programUrl}: ${grouped.body.message}`);
        continue;
      }

      const out = grouped.body.data.report.rows;
      const alias = `${over.name}Count`;

      if (out.length === 0) {
        failures.push(`${programUrl}: grouping returned nothing`);
        continue;
      }
      if (!(alias in out[0])) {
        failures.push(`${programUrl}: no ${alias} in ${Object.keys(out[0]).join(', ')}`);
        continue;
      }

      const distinct = new Set(out.map((row) => String(row[groupOn])));
      if (distinct.size !== out.length) {
        failures.push(`${programUrl}: ${out.length} rows for ${distinct.size} distinct ${groupOn}`);
        continue;
      }

      // Only the grouped column and the aggregate come back, which is what the
      // renderer rebuilds its table from.
      const extra = Object.keys(out[0]).filter((key) => key !== groupOn && key !== alias);
      if (extra.length > 0) {
        failures.push(`${programUrl}: a grouped answer also carried ${extra.join(', ')}`);
        continue;
      }

      proven++;
    }

    assert.ok(proven > 0, 'no query screen offered both a grouping and an aggregate');
    assert.deepStrictEqual(failures, [], failures.join(' | '));
  });

  await testIntegration('The profile carries the copy\'s fiscal periods', async () => {
    // A period scopes every request the session goes on to make, so it arrives
    // with the profile rather than being fetched separately.
    const res = await getAuthed('/UserAccount/getUserProfile');

    assert.strictEqual(res.body.status, true, `profile failed: ${res.body.message}`);
    const periods = res.body.data.periods;

    assert.ok(Array.isArray(periods), 'no periods on the profile');
    assert.ok(periods.length > 0, 'the copy reported no periods at all');

    for (const period of periods) {
      assert.ok(period.id !== undefined && period.id !== null, 'a period with no id');
      // The bounds a query screen opens on, as plain days rather than as a
      // timestamp carrying a zone the column never had (D4).
      if (period.from) {
        assert.ok(/^\d{4}-\d{2}-\d{2}$/.test(period.from), `from is ${period.from}`);
        assert.ok(/^\d{4}-\d{2}-\d{2}$/.test(period.to), `to is ${period.to}`);
      }
    }

    // Newest first, which is what a person signing in wants to see at the top.
    const ids = periods.map(p => Number(p.id)).filter(n => Number.isFinite(n));
    assert.deepStrictEqual(ids, [...ids].sort((a, b) => b - a), `not newest first: ${ids.join(', ')}`);
  });

  await testIntegration('A default period is the copy\'s own, not a literal', async () => {
    // It used to be a hard-coded 2026 whenever a caller named none, which is
    // not a period every copy has -- Demo's one period is id 0.
    const { AuthService } = require('../services/authService');
    const profile = await getAuthed('/UserAccount/getUserProfile');
    const periods = profile.body.data.periods || [];

    const chosen = await AuthService.defaultPeriod(testTenant);

    assert.ok(
      periods.some(period => String(period.id) === String(chosen)),
      `default period ${chosen} is not one of ${periods.map(p => p.id).join(', ')}`
    );
  });

  await testIntegration('No query screen names a column its view does not have', async () => {
    // A report is selected from every column its model names, so one stale
    // column fails the whole screen with ORA-00904. The test above skips a
    // report that errors, which is how Fre/LfrDbcrDocumentsView failed on
    // Job_Date for every caller while the suite stayed green.
    //
    // These models name columns this copy lacks and were kept by decision,
    // because another copy may have them. A missing table (ORA-00942) is a
    // copy that does not have the module at all, and is not this test's
    // business.
    const KEPT = new Set([
      'Cpy/SpeciallistsView', 'Phs/SpecialPrivileges',
      'Ped/TestKeyView', 'Ped/LecturerProgram', 'Proj/FollowupView',
      'Prd/OrderExecutionStage'
    ]);
    const screens = require('../metadata/screens');
    const screenView = require('../presentation/screens');

    const seen = new Set();
    const broken = [];

    for (const programUrl of screens.programs()) {
      const screen = screenView.forProgram(programUrl, {});
      if (!screen || screen.kind !== 'query' || !screen.reportEndpoint) {
        continue;
      }
      if (seen.has(screen.reportEndpoint) || KEPT.has(screen.entity)) {
        continue;
      }
      seen.add(screen.reportEndpoint);

      const res = await postAuthed(`${screen.reportEndpoint}/Query`, { size: 1 });
      if (res.body.status !== true && /ORA-00904/.test(String(res.body.message))) {
        broken.push(`${screen.entity}: ${res.body.message.split('\n')[0]}`);
      }
    }

    assert.ok(seen.size > 0, 'no query screen was reached');
    assert.deepStrictEqual(broken, [], broken.join(' | '));
  });

  await testIntegration('The periodid header reaches the request context', async () => {
    // tenantResolver reads it off the request and every service reads it off
    // the context. Proven through a live endpoint rather than by unit-testing
    // the middleware, because the point is that it survives the whole path.
    const { AuthService } = require('../services/authService');
    const periods = (await getAuthed('/UserAccount/getUserProfile')).body.data.periods || [];
    assert.ok(periods.length > 0, 'no period to send');

    const wanted = String(periods[0].id);

    const res = await new Promise((resolve, reject) => {
      http.get(`http://localhost:3009/UC/Phs/CodeStatus/List`, {
        headers: { Authorization: `Bearer ${testToken}`, periodid: wanted }
      }, (response) => {
        let body = '';
        response.on('data', chunk => { body += chunk; });
        response.on('end', () => resolve({ status: response.statusCode, body: JSON.parse(body) }));
      }).on('error', reject);
    });

    // The request has to succeed with the header present: a period the copy
    // has must never make a request fail.
    assert.strictEqual(res.body.status, true,
      `a request carrying periodid=${wanted} failed: ${res.body.message}`);
  });

  server.close();

  // -------------------------------------------------------------
  // SUMMARY RESULTS
  // -------------------------------------------------------------
  console.log('\n===================================================');
  console.log(`       TEST RESULTS: ${passedTests} / ${totalTests} PASSED        `);
  if (skippedTests > 0) {
    console.log(`       ${skippedTests} skipped (RUN_INTEGRATION_TESTS=1 to include)`);
  }
  console.log('===================================================\n');

  process.exit(passedTests === totalTests ? 0 : 1);
}

runAllTests();

