/**
 * Program screens, and what a client is handed when it asks for one.
 *
 * Two things are checked, and they fail for different reasons:
 *
 *   The files    -- every screen names an entity that resolves, every field a
 *                   column that exists, every operator one the column's type
 *                   permits, and nothing restates what the schema declares.
 *                   A screen that has drifted fails the build rather than
 *                   failing a request.
 *
 *   The composition -- what `presentation/screens.js` makes of a screen file
 *                   plus its entity. This is the part a renderer depends on: a
 *                   field with no label or no input kind is one the client
 *                   cannot draw.
 *
 * The last test is Step 3's exit condition from MIGRATION-PLAN.md -- one
 * existing screen rendered from metadata matching its hand-written version
 * field for field -- and it is measured against the hand-written file itself,
 * not against a transcription of it.
 */

const assert = require('assert');
const fs = require('fs');
const path = require('path');

const mainApp = require('../metadata/registry');
const screens = require('../metadata/screens');
const screenView = require('../presentation/screens');
const { operatorsFor, OPERATORS, FREE_SQL } = require('../core/query/conditions');

const ROOT = path.join(__dirname, '..');
const PROGRAMS = path.join(ROOT, 'resources', 'programs');

mainApp.loadMetadata([path.join(ROOT, 'resources', 'modules')]);
screens.load({
  programs: PROGRAMS,
  reports: path.join(ROOT, 'resources', 'screens')
});

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

/** Every program screen, with the path it is addressed by. */
function allScreens() {
  const out = [];
  if (!fs.existsSync(PROGRAMS)) {
    return out;
  }

  const walk = (dir) => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(full);
        continue;
      }
      if (!entry.name.endsWith('.json')) {
        continue;
      }
      const rel = path.relative(PROGRAMS, full).split(path.sep).join('/').replace(/\.json$/, '');
      out.push({ rel, screen: JSON.parse(fs.readFileSync(full, 'utf8')) });
    }
  };

  walk(PROGRAMS);
  return out;
}

const ALL = allScreens();

/** Both field lists a screen may carry, flattened, with which half they came from. */
function fieldsOf(screen) {
  const out = [];
  for (const part of ['form', 'search']) {
    for (const field of ((screen[part] && screen[part].fields) || [])) {
      out.push({ part, field });
    }
  }
  return out;
}

/** A column on an entity by the name a screen used, exact match first. */
function columnOf(entity, name) {
  return entity.fields.find(f => f.Field === name)
    || entity.fields.find(f => String(f.Field).toLowerCase() === String(name).toLowerCase())
    || null;
}

console.log(`\n--- Program screens (${ALL.length} screens) ---`);

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

test('every screen is addressed by the program it declares', () => {
  // The registry indexes on the path on disk; the file states the same path.
  // A file that has been moved without its declaration being updated is
  // reachable under one name and not the other.
  const broken = [];
  for (const { rel, screen } of ALL) {
    if (String(screen.program || '').toLowerCase() !== rel.toLowerCase()) {
      broken.push(`${rel} declares ${screen.program}`);
    }
  }
  assert.strictEqual(broken.length, 0, `mismatched: ${broken.slice(0, 5).join(', ')}`);
});

test('every field names a column on that entity', () => {
  const broken = [];
  for (const { rel, screen } of ALL) {
    const [pkg, name] = String(screen.entity || '').split('/');
    const entity = mainApp.getEntity(pkg, name);
    if (!entity) {
      continue;
    }
    for (const { part, field } of fieldsOf(screen)) {
      if (!columnOf(entity, field.name)) {
        broken.push(`${rel}.${part}.${field.name}`);
      }
    }
  }
  assert.strictEqual(broken.length, 0, `unknown columns: ${broken.slice(0, 5).join(', ')}`);
});

test('every operator offered is a real operator its column allows', () => {
  const broken = [];
  for (const { rel, screen } of ALL) {
    const [pkg, name] = String(screen.entity || '').split('/');
    const entity = mainApp.getEntity(pkg, name);
    if (!entity) {
      continue;
    }
    for (const { field } of fieldsOf(screen)) {
      const meta = columnOf(entity, field.name);
      if (!meta) {
        continue;
      }
      const allowed = operatorsFor(meta);
      for (const op of (field.operators || [])) {
        if (!OPERATORS[op]) {
          broken.push(`${rel}.${field.name}: ${op} is not an operator`);
        } else if (!allowed.includes(op)) {
          broken.push(`${rel}.${field.name}: ${op} not allowed on ${meta.DBType}`);
        }
      }
    }
  }
  assert.strictEqual(broken.length, 0, `${broken.slice(0, 5).join(', ')}`);
});

test('no screen offers the free-SQL operator', () => {
  const broken = [];
  for (const { rel, screen } of ALL) {
    for (const { field } of fieldsOf(screen)) {
      if ((field.operators || []).includes(FREE_SQL)) {
        broken.push(`${rel}.${field.name}`);
      }
    }
  }
  assert.strictEqual(broken.length, 0, `offers ${FREE_SQL}: ${broken.join(', ')}`);
});

test('no screen restates what the entity already declares', () => {
  // The whole point of an overlay. A type, a default or a lookup here is a
  // second source of truth for something the schema generates -- and the two
  // start disagreeing the moment a column changes.
  const FORBIDDEN = [
    'type', 'dbType', 'DBType', 'required', 'isNull', 'precision', 'scale',
    'relation', 'length', 'defaultValue', 'lookup', 'displayField'
  ];
  const broken = [];
  for (const { rel, screen } of ALL) {
    for (const { field } of fieldsOf(screen)) {
      for (const key of FORBIDDEN) {
        if (key in field) {
          broken.push(`${rel}.${field.name}.${key}`);
        }
      }
    }
  }
  assert.strictEqual(broken.length, 0, `duplicated from the schema: ${broken.slice(0, 5).join(', ')}`);
});

console.log('\n--- What a client is handed ---');

test('every screen composes, and every composed field can be drawn', () => {
  const broken = [];
  for (const { rel } of ALL) {
    const composed = screenView.forProgram(rel, { lang: 'en' });
    if (!composed) {
      broken.push(`${rel}: composes to nothing`);
      continue;
    }
    const fields = [
      ...((composed.form && composed.form.fields) || []),
      ...((composed.search && composed.search.fields) || [])
    ];
    if (fields.length === 0) {
      broken.push(`${rel}: no fields`);
    }
    for (const field of fields) {
      if (!field.label || !field.input) {
        broken.push(`${rel}.${field.name}: label=${field.label} input=${field.input}`);
      }
    }
  }
  assert.strictEqual(broken.length, 0, `${broken.slice(0, 5).join(', ')}`);
});

test('a reference field carries somewhere to read its options from', () => {
  // A select with no lookup is a select with no options. The path is derived
  // from the entity's relation, so this fails when a relation names a table
  // nothing describes rather than when a screen forgot something.
  const broken = [];
  for (const { rel } of ALL) {
    const composed = screenView.forProgram(rel, { lang: 'en' });
    for (const field of ((composed && composed.form && composed.form.fields) || [])) {
      if (field.input === 'select' && !field.lookup && !field.hidden) {
        broken.push(`${rel}.${field.name}`);
      }
    }
  }
  assert.strictEqual(broken.length, 0, `selects with no source: ${broken.slice(0, 5).join(', ')}`);
});

test('an entry form is never handed a search vocabulary', () => {
  const broken = [];
  for (const { rel } of ALL) {
    const composed = screenView.forProgram(rel, { lang: 'en' });
    for (const field of ((composed && composed.form && composed.form.fields) || [])) {
      if (field.operators) {
        broken.push(`${rel}.${field.name}`);
      }
    }
  }
  assert.strictEqual(broken.length, 0, `form fields carrying operators: ${broken.slice(0, 5).join(', ')}`);
});

test('a screen path cannot reach outside the registry', () => {
  // The path is a key in a Map and never touches a file system, so a traversal
  // is not a traversal -- it is a miss. Checked because the endpoint takes the
  // rest of the URL rather than a parameter.
  for (const attempt of ['../../etc/passwd', '..\\..\\server.js', '/etc/passwd', 'clnc/mng/../../../../server']) {
    assert.strictEqual(screenView.forProgram(attempt, {}), null, `resolved something for '${attempt}'`);
  }
});

console.log('\n--- Step 3 exit condition: generated matches hand-written ---');

/**
 * The hand-written screen's field list, read out of the PhApp source.
 *
 * Read rather than transcribed: a copy here would agree with itself forever
 * while the real screen changed underneath it.
 */
const HAND_WRITTEN = path.join(ROOT, '..', 'PhApp', 'src', 'features', 'clnc', 'mng', 'DoctorsView.tsx');

function handWrittenFields() {
  const source = fs.readFileSync(HAND_WRITTEN, 'utf8');
  return [...source.matchAll(/\{\s*field:\s*'([^']+)',([\s\S]*?)\n    \}/g)].map(match => {
    const body = match[2];
    const kind = /kind:\s*'([^']+)'/.exec(body);
    const display = /displayField:\s*'([^']+)'/.exec(body);
    return {
      field: match[1],
      kind: kind ? kind[1] : null,
      required: /required:\s*true/.test(body),
      displayField: display ? display[1] : null
    };
  });
}

/**
 * Columns whose generated `required` is known to differ from the hand-written
 * screen, with why.
 *
 * Not a tolerance: each one is a measured defect in the entity model, and the
 * test fails if a name leaves this list still differing OR if a name on it
 * stops differing -- the second because that means the model was fixed and the
 * exception should go with it.
 */
const KNOWN_REQUIRED_DRIFT = {
  // CLNC_DOCTORS.STATUS_ID is NULLABLE = 'N' with DEFAULT 1 in the live schema;
  // resources/modules/Clnc/Doctors.json records isNull: true. One of 62 columns
  // the models call optional that the database requires.
  statusId: 'model says optional, database says NOT NULL'
};

test('the generated Doctors screen offers exactly the same fields', () => {
  const hand = handWrittenFields();
  const composed = screenView.forProgram('clnc/mng/Doctors', { lang: 'en' });
  assert.ok(composed, 'clnc/mng/Doctors did not compose');

  const visible = composed.form.fields.filter(f => !f.hidden).map(f => f.name);
  const expected = hand.map(f => f.field);

  const missing = expected.filter(name => !visible.includes(name));
  const extra = visible.filter(name => !expected.includes(name));

  assert.deepStrictEqual(missing, [], `not generated: ${missing.join(', ')}`);
  assert.deepStrictEqual(extra, [], `generated but not on the hand-written screen: ${extra.join(', ')}`);
});

/**
 * The field order is the Java original's, not PhApp's.
 *
 * The two differ by one field and the generated one is right: `aFields` in
 * pages/clnc/mng/Doctors.js runs
 *
 *   id, name, specialId, userId, dob, genderId, statusId, martialId, ...
 *
 * while the hand-written port moved `statusId` up beside `specialId`. That was
 * a choice made during the port, not a fact about the screen, so it is recorded
 * here rather than reproduced -- a generated screen that silently adopted it
 * would be reproducing one port's preference as if the original had said so.
 */
const PHAPP_REORDERED = { statusId: 'moved to 3rd; the Java original has it 6th' };

test('the field order is the Java original, bar what PhApp deliberately moved', () => {
  const hand = handWrittenFields().map(f => f.field);
  const composed = screenView.forProgram('clnc/mng/Doctors', { lang: 'en' });
  const visible = composed.form.fields.filter(f => !f.hidden).map(f => f.name);

  const moved = Object.keys(PHAPP_REORDERED);
  const handRest = hand.filter(name => !moved.includes(name));
  const generatedRest = visible.filter(name => !moved.includes(name));

  assert.deepStrictEqual(generatedRest, handRest,
    `order differs beyond the documented move\n         generated: ${visible.join(', ')}\n         hand-written: ${hand.join(', ')}`);

  const stillMoved = moved.filter(name => hand.indexOf(name) !== visible.indexOf(name));
  assert.deepStrictEqual(stillMoved, moved,
    `${moved.filter(n => !stillMoved.includes(n)).join(', ')} now agrees -- remove it from PHAPP_REORDERED`);
});

test('every field is the same input kind, with the same display column', () => {
  const hand = handWrittenFields();
  const composed = screenView.forProgram('clnc/mng/Doctors', { lang: 'en' });
  const generated = new Map(composed.form.fields.map(f => [f.name, f]));

  const broken = [];
  for (const expected of hand) {
    const actual = generated.get(expected.field);
    if (!actual) {
      broken.push(`${expected.field}: missing`);
      continue;
    }
    if (actual.input !== expected.kind) {
      broken.push(`${expected.field}: input ${actual.input}, expected ${expected.kind}`);
    }
    if ((actual.displayField || null) !== expected.displayField) {
      broken.push(`${expected.field}: displayField ${actual.displayField}, expected ${expected.displayField}`);
    }
  }

  assert.strictEqual(broken.length, 0, broken.join('; '));
});

test('required matches, except where the entity model is known to be wrong', () => {
  const hand = handWrittenFields();
  const composed = screenView.forProgram('clnc/mng/Doctors', { lang: 'en' });
  const generated = new Map(composed.form.fields.map(f => [f.name, f]));

  const unexpected = [];
  const nowAgreeing = [];

  for (const expected of hand) {
    const actual = generated.get(expected.field);
    if (!actual) {
      continue;
    }
    const differs = Boolean(actual.required) !== expected.required;
    const known = Object.prototype.hasOwnProperty.call(KNOWN_REQUIRED_DRIFT, expected.field);

    if (differs && !known) {
      unexpected.push(`${expected.field}: generated ${Boolean(actual.required)}, hand-written ${expected.required}`);
    }
    if (!differs && known) {
      nowAgreeing.push(expected.field);
    }
  }

  assert.strictEqual(unexpected.length, 0, `undocumented difference: ${unexpected.join('; ')}`);
  assert.strictEqual(nowAgreeing.length, 0,
    `${nowAgreeing.join(', ')} now agrees -- remove it from KNOWN_REQUIRED_DRIFT`);
});

console.log(`\n  programs: ${passed} passed, ${failed} failed\n`);

if (failed > 0) {
  process.exitCode = 1;
}
