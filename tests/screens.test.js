/**
 * The screen metadata, checked against the entities it overlays.
 *
 * A screen file is only useful if every name in it resolves: the entity it
 * overlays, every field it lists, and every operator it offers. None of that
 * is checkable by reading the file, because the answers live in the generated
 * entity models -- so it is checked here, and a screen that has drifted fails
 * the build rather than failing a request.
 *
 * It also guards the one rule the format exists for: a screen must not restate
 * what the schema already knows. A `type` or a `required` in a screen file is
 * a second source of truth, and two sources of truth is how they start
 * disagreeing.
 */

const assert = require('assert');
const fs = require('fs');
const path = require('path');

const mainApp = require('../metadata/registry');
const { operatorsFor, OPERATORS, FREE_SQL } = require('../core/query/conditions');

const SCREENS = path.join(__dirname, '..', 'resources', 'screens');

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

/** Every screen file, parsed. */
function screens() {
  const out = [];
  if (!fs.existsSync(SCREENS)) {
    return out;
  }
  for (const pkg of fs.readdirSync(SCREENS)) {
    const dir = path.join(SCREENS, pkg);
    if (!fs.statSync(dir).isDirectory()) {
      continue;
    }
    for (const file of fs.readdirSync(dir)) {
      if (!file.endsWith('.json')) {
        continue;
      }
      const rel = `${pkg}/${file}`;
      out.push({ rel, screen: JSON.parse(fs.readFileSync(path.join(dir, file), 'utf8')) });
    }
  }
  return out;
}

const ALL = screens();

console.log(`\n--- Screen metadata (${ALL.length} screens) ---`);

test('every screen names an entity that resolves', () => {
  const broken = [];
  for (const { rel, screen } of ALL) {
    const [pkg, name] = String(screen.entity || '').split('/');
    if (!pkg || !name || !mainApp.getEntity(pkg, name)) {
      broken.push(`${rel} -> ${screen.entity}`);
    }
  }
  assert.strictEqual(broken.length, 0, `unresolvable: ${broken.slice(0, 5).join(', ')}`);
});

test('every field names a column on that entity', () => {
  const broken = [];
  for (const { rel, screen } of ALL) {
    const [pkg, name] = String(screen.entity || '').split('/');
    const entity = mainApp.getEntity(pkg, name);
    if (!entity) {
      continue;
    }
    const have = new Set(entity.fields.map(f => String(f.Field).toLowerCase()));
    for (const field of (screen.fields || [])) {
      if (!have.has(String(field.name).toLowerCase())) {
        broken.push(`${rel}.${field.name}`);
      }
    }
  }
  assert.strictEqual(broken.length, 0, `unknown columns: ${broken.slice(0, 5).join(', ')}`);
});

test('every operator offered is a real operator', () => {
  const broken = [];
  for (const { rel, screen } of ALL) {
    for (const field of (screen.fields || [])) {
      for (const op of (field.operators || [])) {
        if (!OPERATORS[op]) {
          broken.push(`${rel}.${field.name}: ${op}`);
        }
      }
    }
  }
  assert.strictEqual(broken.length, 0, `unknown operators: ${broken.slice(0, 5).join(', ')}`);
});

test('no screen offers an operator its column type forbids', () => {
  const broken = [];
  for (const { rel, screen } of ALL) {
    const [pkg, name] = String(screen.entity || '').split('/');
    const entity = mainApp.getEntity(pkg, name);
    if (!entity) {
      continue;
    }
    for (const field of (screen.fields || [])) {
      const meta = entity.fields.find(f => f.Field === field.name)
        || entity.fields.find(f => String(f.Field).toLowerCase() === String(field.name).toLowerCase());
      if (!meta) {
        continue;
      }
      const allowed = operatorsFor(meta);
      for (const op of (field.operators || [])) {
        if (!allowed.includes(op)) {
          broken.push(`${rel}.${field.name}: ${op}`);
        }
      }
    }
  }
  assert.strictEqual(broken.length, 0, `not allowed on type: ${broken.slice(0, 5).join(', ')}`);
});

test('no screen offers the free-SQL operator', () => {
  const broken = [];
  for (const { rel, screen } of ALL) {
    for (const field of (screen.fields || [])) {
      if ((field.operators || []).includes(FREE_SQL)) {
        broken.push(`${rel}.${field.name}`);
      }
    }
  }
  assert.strictEqual(broken.length, 0, `offers $$: ${broken.join(', ')}`);
});

test('no screen restates what the entity already declares', () => {
  // The whole point of an overlay. A type or a length here is a second source
  // of truth for something the schema generates.
  const FORBIDDEN = ['type', 'dbType', 'DBType', 'required', 'isNull', 'precision', 'scale', 'relation', 'length'];
  const broken = [];
  for (const { rel, screen } of ALL) {
    for (const field of (screen.fields || [])) {
      for (const key of FORBIDDEN) {
        if (key in field) {
          broken.push(`${rel}.${field.name}.${key}`);
        }
      }
    }
  }
  assert.strictEqual(broken.length, 0, `duplicated from the schema: ${broken.slice(0, 5).join(', ')}`);
});

test('every screen declares its version and kind', () => {
  const broken = [];
  for (const { rel, screen } of ALL) {
    if (screen.version !== '1.0' || !['query', 'form'].includes(screen.kind)) {
      broken.push(rel);
    }
  }
  assert.strictEqual(broken.length, 0, `malformed: ${broken.slice(0, 5).join(', ')}`);
});

test('a searchable field offers at least one operator', () => {
  const broken = [];
  for (const { rel, screen } of ALL) {
    for (const field of (screen.fields || [])) {
      if (field.filter && (!field.operators || field.operators.length === 0)) {
        broken.push(`${rel}.${field.name}`);
      }
    }
  }
  assert.strictEqual(broken.length, 0, `filterable with no operators: ${broken.slice(0, 5).join(', ')}`);
});

console.log(`\n  screens: ${passed} passed, ${failed} failed\n`);

if (failed > 0) {
  process.exitCode = 1;
}
