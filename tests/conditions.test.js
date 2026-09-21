/**
 * The search condition engine.
 *
 * Five things have to hold, and each is a way the Java original could be
 * mistranslated without anyone noticing:
 *
 *   1. `<>` means BETWEEN and `><` means NOT BETWEEN. They look like
 *      comparisons. Getting them backwards inverts every range filter.
 *   2. No value reaches the SQL text, whatever it contains.
 *   3. A field that is not a column on the entity is dropped, never passed
 *      through as SQL.
 *   4. `$$` -- the operator that splices raw SQL -- is refused.
 *   5. An operator has to suit the column's type.
 */

const assert = require('assert');
const path = require('path');

const mainApp = require('../metadata/registry');
const query = require('../core/query');
const conditions = require('../core/query/conditions');

mainApp.loadMetadata([path.join(__dirname, '..', 'resources', 'modules')]);

let passed = 0;
let failed = 0;

function test(name, fn) {
  try {
    fn();
    console.log(`✓ [PASS] ${name}`);
    passed++;
  } catch (err) {
    console.error(`✗ [FAIL] ${name}`);
    console.error(`         ${err.message}`);
    failed++;
  }
}

const entity = mainApp.getEntity('Clnc', 'Doctors');

/** The WHERE body of a select built from one condition. */
function whereFor(condition, dbType = 'oracle') {
  const { sql, params } = query.buildSelect(dbType, entity, {
    fields: ['id'],
    conditions: [condition],
    page: 1,
    pageSize: 1
  });
  const at = sql.indexOf('WHERE');
  return { where: at === -1 ? '' : sql.slice(at).split(' ORDER BY')[0], sql, params };
}

console.log('\n--- 1. Range operators are ranges, not comparisons ---');

test('<> is BETWEEN', () => {
  const { where } = whereFor({ field: 'id', operator: '<>', value: 1, value2: 9 });
  assert.ok(where.includes('BETWEEN'), `expected BETWEEN, got: ${where}`);
  assert.ok(!where.includes('NOT BETWEEN'), `<> must not be negated: ${where}`);
});

test('>< is NOT BETWEEN', () => {
  const { where } = whereFor({ field: 'id', operator: '><', value: 1, value2: 9 });
  assert.ok(where.includes('NOT BETWEEN'), `expected NOT BETWEEN, got: ${where}`);
});

test('a range binds both ends', () => {
  const { params } = whereFor({ field: 'id', operator: '<>', value: 4, value2: 8 });
  const bound = Object.values(params);
  assert.ok(bound.includes(4) && bound.includes(8), `both ends expected, got: ${JSON.stringify(params)}`);
});

console.log('\n--- 2. Values never reach the SQL ---');

const HOSTILE = "x' OR '1'='1'; DROP TABLE Clnc_Doctor--";

for (const operator of ['=', '!=', '[%', '![%', '%]', '!%]', '%', '!%']) {
  test(`${operator} keeps a hostile value in the bind`, () => {
    const { where, params } = whereFor({ field: 'name', operator, value: HOSTILE });
    assert.ok(!where.includes('DROP'), `value leaked into SQL: ${where}`);
    assert.ok(
      Object.values(params).some(v => String(v).includes('DROP')),
      'the value should be bound'
    );
  });
}

test('IN binds every member, none of them inline', () => {
  const { where, params } = whereFor({ field: 'name', operator: 'IN', values: [HOSTILE, 'ok'] });
  assert.ok(!where.includes('DROP'), `value leaked into SQL: ${where}`);
  assert.strictEqual(
    Object.values(params).filter(v => v === HOSTILE || v === 'ok').length, 2,
    'both members should be bound'
  );
});

console.log('\n--- 3. Unknown fields are dropped, not trusted ---');

test('a field the entity does not have adds no clause', () => {
  const { where } = whereFor({ field: 'no_such_column', operator: '=', value: 'x' });
  assert.strictEqual(where, '', `expected no WHERE, got: ${where}`);
});

test('a field name that is SQL is not spliced', () => {
  const { sql } = whereFor({ field: "Id FROM Clnc_Doctor--", operator: '=', value: 1 });
  assert.ok(!sql.includes('--'), `field name leaked: ${sql}`);
});

console.log('\n--- 4. The raw-SQL operator is refused ---');

test('$$ is refused by name', () => {
  assert.throws(
    () => whereFor({ field: 'name', operator: '$$', value: '1=1' }),
    /free-SQL/,
    'the free-SQL operator must be refused'
  );
});

test('an unknown operator is refused', () => {
  assert.throws(
    () => whereFor({ field: 'name', operator: 'DROP', value: 'x' }),
    /Unknown search operator/
  );
});

console.log('\n--- 5. Operators suit the column ---');

test('a range is refused on text', () => {
  assert.throws(
    () => whereFor({ field: 'name', operator: '<>', value: 'a', value2: 'b' }),
    /not allowed/
  );
});

test('starts-with is refused on a number', () => {
  assert.throws(
    () => whereFor({ field: 'id', operator: '[%', value: '1' }),
    /not allowed/
  );
});

test('a date column offers ranges but not LIKE', () => {
  const allowed = conditions.operatorsFor(entity.fields.find(f => f.Field === 'dob'));
  assert.ok(allowed.includes('<>'), 'a date should allow a range');
  assert.ok(!allowed.includes('%'), 'a date should not allow contains');
});

console.log('\n--- 6. Dates are converted by their declared type ---');

test('a DATE column binds through its own format', () => {
  const { where } = whereFor({ field: 'dob', operator: '>', value: '1990-01-01' });
  assert.ok(where.includes("'DD-MM-YYYY'"), `expected the date format, got: ${where}`);
  assert.ok(!where.includes('HH24'), `a DATE must not carry a time: ${where}`);
});

test('a DATETIME column keeps its time', () => {
  const { where } = whereFor({ field: 'insDate', operator: '>', value: '2026-01-01' });
  assert.ok(where.includes('HH24:MI:SS'), `expected a time in the format, got: ${where}`);
});

console.log('\n--- 7. Every dialect spells them ---');

for (const dbType of ['oracle', 'mysql', 'postgres']) {
  test(`${dbType} builds a range and a contains`, () => {
    const range = whereFor({ field: 'id', operator: '<>', value: 1, value2: 9 }, dbType);
    assert.ok(range.where.includes('BETWEEN'), `${dbType}: ${range.where}`);

    const like = whereFor({ field: 'name', operator: '%', value: 'x' }, dbType);
    assert.ok(like.where.includes('LIKE'), `${dbType}: ${like.where}`);
  });
}

console.log(`\n  conditions: ${passed} passed, ${failed} failed\n`);

if (failed > 0) {
  process.exitCode = 1;
}
