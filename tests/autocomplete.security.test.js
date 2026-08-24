/**
 * Regression tests for SEC-1: autocomplete condition templates must bind every
 * caller-supplied value rather than splicing it into the SQL text.
 *
 * Runs without a database — resolveCondition and resolveLimit are pure.
 */

const assert = require('assert');
const fs = require('fs');
const path = require('path');

const autocompleteService = require('../services/autocompleteService');
const ParamBinder = require('../core/paramBinder');

let passed = 0;
let total = 0;

function test(name, fn) {
  total++;
  try {
    fn();
    console.log(`✓ [PASS] ${name}`);
    passed++;
  } catch (err) {
    console.error(`✗ [FAIL] ${name}`);
    console.error(`  ${err.message}`);
  }
}

/** Counts bind placeholders in generated SQL for a given dialect. */
function countPlaceholders(sql, dbType) {
  if (dbType === 'oracle') return (sql.match(/:p_\d+/g) || []).length;
  if (dbType === 'postgres') return (sql.match(/\$\d+/g) || []).length;
  return (sql.match(/\?/g) || []).length;
}

/** Number of values a binder collected, for either params shape. */
function countParams(binder) {
  return Array.isArray(binder.params) ? binder.params.length : Object.keys(binder.params).length;
}

const DIALECTS = ['oracle', 'mysql', 'postgres'];

console.log('===================================================');
console.log('   SEC-1 · Autocomplete SQL Injection Regression   ');
console.log('===================================================\n');

// -------------------------------------------------------------
console.log('--- 1. Placeholder binding by shape ---');

test('Quoted literal placeholder binds the assembled string, not the SQL', () => {
  const binder = new ParamBinder('oracle');
  const sql = autocompleteService.resolveCondition(
    "Lower(Num||' - '||Name) LIKE '%{term}%'",
    { term: 'chair' },
    binder
  );

  assert.strictEqual(sql, "Lower(Num||' - '||Name) LIKE :p_1");
  assert.strictEqual(binder.params.p_1, '%chair%');
  assert.ok(!sql.includes('chair'), 'value must not appear in SQL text');
});

test('Bare placeholder binds a number', () => {
  const binder = new ParamBinder('oracle');
  const sql = autocompleteService.resolveCondition('stor_id={storId}', { storId: '42' }, binder);

  assert.strictEqual(sql, 'stor_id=:p_1');
  assert.strictEqual(binder.params.p_1, 42);
});

test('Quoted id placeholder binds as a string (Stor/Items.json shape)', () => {
  const binder = new ParamBinder('oracle');
  const sql = autocompleteService.resolveCondition("id!='{itemId}'", { itemId: '7' }, binder);

  assert.strictEqual(sql, 'id!=:p_1');
  assert.strictEqual(binder.params.p_1, '7');
});

test('Quoted literals without placeholders are left untouched', () => {
  const binder = new ParamBinder('oracle');
  const sql = autocompleteService.resolveCondition(
    "Lower(' '||Name) LIKE Lower('%{term}%')",
    { term: 'x' },
    binder
  );

  assert.ok(sql.includes("' '||Name"), "the ' ' literal must survive");
  assert.strictEqual(countPlaceholders(sql, 'oracle'), 1);
});

test('Subquery template binds correctly (Str/ItemsNotInStore.json shape)', () => {
  const binder = new ParamBinder('oracle');
  const sql = autocompleteService.resolveCondition(
    'id NOT IN (SELECT item_Id From STR_Stores_Materiales Where stor_Id={storId})',
    { storId: '3' },
    binder
  );

  assert.strictEqual(sql, 'id NOT IN (SELECT item_Id From STR_Stores_Materiales Where stor_Id=:p_1)');
  assert.strictEqual(binder.params.p_1, 3);
});

// -------------------------------------------------------------
console.log('\n--- 2. Injection payloads are neutralised ---');

test("Quote-breaking payload in {term} stays inside the bind", () => {
  const binder = new ParamBinder('oracle');
  const payload = "' OR 1=1 --";
  const sql = autocompleteService.resolveCondition(
    "Lower(Name) LIKE '%{term}%'",
    { term: payload },
    binder
  );

  assert.strictEqual(sql, 'Lower(Name) LIKE :p_1');
  assert.ok(!sql.includes('OR 1=1'), 'payload must not reach the SQL text');
  assert.strictEqual(binder.params.p_1, "%' or 1=1 --%");
});

test('Numeric-context payload is bound, not inlined (the escaping blind spot)', () => {
  // The old `'` -> `''` escaping did nothing here: no quotes are needed to
  // break out of `stor_id={storId}`.
  const binder = new ParamBinder('oracle');
  const payload = '1 OR 1=1';
  const sql = autocompleteService.resolveCondition('stor_id={storId}', { storId: payload }, binder);

  assert.strictEqual(sql, 'stor_id=:p_1');
  assert.ok(!sql.includes('OR 1=1'), 'payload must not reach the SQL text');
  assert.strictEqual(binder.params.p_1, '1 OR 1=1');
});

test('Statement-terminating payload is bound, not inlined', () => {
  const binder = new ParamBinder('oracle');
  const payload = '1); DROP TABLE Stor_Item; --';
  const sql = autocompleteService.resolveCondition('Stor_Id={storFId}', { storFId: payload }, binder);

  assert.ok(!sql.includes('DROP TABLE'), 'payload must not reach the SQL text');
  assert.strictEqual(binder.params.p_1, payload);
});

// -------------------------------------------------------------
console.log('\n--- 3. Unresolvable clauses leave no orphan binds ---');

test('Missing placeholder value drops the clause and adds no bind', () => {
  const binder = new ParamBinder('oracle');
  const sql = autocompleteService.resolveCondition('stor_id={storId}', {}, binder);

  assert.strictEqual(sql, null, 'clause should be dropped');
  assert.strictEqual(countParams(binder), 0, 'binder must be untouched');
});

test('Empty-string value counts as missing', () => {
  const binder = new ParamBinder('oracle');
  assert.strictEqual(autocompleteService.resolveCondition('a={x}', { x: '   ' }, binder), null);
  assert.strictEqual(countParams(binder), 0);
});

test('Partially-resolvable multi-placeholder clause adds no binds', () => {
  const binder = new ParamBinder('mysql');
  const sql = autocompleteService.resolveCondition('a={x} AND b={y}', { x: '1' }, binder);

  assert.strictEqual(sql, null, 'clause should be dropped when {y} is absent');
  assert.strictEqual(countParams(binder), 0, 'the bind for {x} must be rolled back');
});

// -------------------------------------------------------------
console.log('\n--- 4. Dialect placeholder syntax ---');

for (const dbType of DIALECTS) {
  test(`${dbType}: placeholders and params stay in step`, () => {
    const binder = new ParamBinder(dbType);
    const a = autocompleteService.resolveCondition("Name LIKE '%{term}%'", { term: 'q' }, binder);
    const b = autocompleteService.resolveCondition('stor_id={storId}', { storId: '5' }, binder);
    const sql = `SELECT Id FROM T WHERE (${a}) AND (${b})`;

    assert.strictEqual(countPlaceholders(sql, dbType), 2, 'two placeholders expected');
    assert.strictEqual(countParams(binder), 2, 'two bound values expected');
  });
}

test('Postgres numbers its placeholders in splice order', () => {
  const binder = new ParamBinder('postgres');
  const a = autocompleteService.resolveCondition("Name LIKE '%{term}%'", { term: 'q' }, binder);
  const b = autocompleteService.resolveCondition('stor_id={storId}', { storId: '5' }, binder);

  assert.strictEqual(a, 'Name LIKE $1');
  assert.strictEqual(b, 'stor_id=$2');
  assert.deepStrictEqual(binder.params, ['%q%', 5]);
});

// -------------------------------------------------------------
console.log('\n--- 5. Row limit is clamped ---');

test('Non-numeric limit falls back to the default', () => {
  assert.strictEqual(autocompleteService.resolveLimit({ pageSize: 'abc' }), 50);
  assert.strictEqual(autocompleteService.resolveLimit({}), 50);
});

test('Absurd and negative limits are clamped', () => {
  assert.strictEqual(autocompleteService.resolveLimit({ pageSize: '999999999' }), 500);
  assert.strictEqual(autocompleteService.resolveLimit({ limit: '-5' }), 50);
});

test('Reasonable limit is honoured', () => {
  assert.strictEqual(autocompleteService.resolveLimit({ pageSize: '25' }), 25);
});

// -------------------------------------------------------------
console.log('\n--- 6. WHERE placement ---');

test('A WHERE inside a subquery does not count as the outer query\'s', () => {
  const sel = 'SELECT Id, Name FROM (SELECT I.Id FROM Stor_Items I, Stor_SMat S where I.id = S.Item_id)';
  assert.strictEqual(autocompleteService.hasTopLevelWhere(sel), false);
});

test('A genuine top-level WHERE is detected', () => {
  assert.strictEqual(
    autocompleteService.hasTopLevelWhere('SELECT Id FROM T WHERE Status_Id = 1'),
    true
  );
});

test('The word "where" inside a string literal is ignored', () => {
  assert.strictEqual(
    autocompleteService.hasTopLevelWhere("SELECT Id, 'from where' AS Note FROM T"),
    false
  );
});

test('WHERE-prefixed identifiers do not false-positive', () => {
  assert.strictEqual(autocompleteService.hasTopLevelWhere('SELECT Id FROM Warehouses'), false);
});

// -------------------------------------------------------------
console.log('\n--- 7. Sweep of every shipped template ---');

test('No template leaks a hostile value into SQL text', () => {
  const root = path.join(__dirname, '..', 'resources', 'autocomplete');
  const payload = "x' OR 1=1; DROP TABLE Acc_Acc; --";
  const marker = /OR 1=1|DROP TABLE/i;

  let checked = 0;
  const offenders = [];

  for (const pkg of fs.readdirSync(root)) {
    const pkgDir = path.join(root, pkg);
    if (!fs.statSync(pkgDir).isDirectory()) continue;

    for (const file of fs.readdirSync(pkgDir)) {
      if (!file.endsWith('.json')) continue;

      const meta = JSON.parse(fs.readFileSync(path.join(pkgDir, file), 'utf8'));
      if (!meta.Conds) continue;

      for (const [key, template] of Object.entries(meta.Conds)) {
        // Feed the payload to every placeholder the template references.
        const lookup = {};
        for (const m of String(template).matchAll(/\{([A-Za-z0-9_]+)\}/g)) {
          lookup[m[1]] = payload;
        }

        const binder = new ParamBinder('oracle');
        const sql = autocompleteService.resolveCondition(template, lookup, binder);
        checked++;

        if (sql !== null && marker.test(sql)) {
          offenders.push(`${pkg}/${file} [${key}] -> ${sql}`);
        }
      }
    }
  }

  assert.ok(checked > 300, `expected to check 300+ templates, checked ${checked}`);
  assert.deepStrictEqual(offenders, [], `templates leaked the payload:\n${offenders.join('\n')}`);
  console.log(`  (checked ${checked} condition templates)`);
});

// -------------------------------------------------------------
console.log('\n===================================================');
console.log(`        SEC-1 RESULTS: ${passed} / ${total} PASSED`);
console.log('===================================================\n');

process.exit(passed === total ? 0 : 1);
