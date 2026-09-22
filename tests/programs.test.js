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

console.log('\n--- Line grids on a document screen ---');

test('every line grid names a child of the screen it sits on', () => {
  // A grid is paired with its child by evidence, not by position: each declared
  // child is scored on how many of the grid's columns are real columns of it.
  // A grid paired with the wrong child would write line items into another
  // table, so the pairing is checked rather than assumed.
  const broken = [];

  for (const { rel, screen } of ALL) {
    for (const line of (screen.lines || [])) {
      const [masterPkg, masterName] = String(screen.entity || '').split('/');
      const master = mainApp.getEntity(masterPkg, masterName);
      if (!master) {
        continue;
      }

      const [linePkg, lineName] = String(line.entity || '').split('/');
      const lineEntity = mainApp.getEntity(linePkg, lineName);
      if (!lineEntity) {
        broken.push(`${rel}: ${line.entity} does not resolve`);
        continue;
      }

      const declared = (master.children || []).some((child) => {
        const candidate = mainApp.getEntity(child.pkg, child.table)
          || mainApp.getEntityBySynonym(child.synonym || '')
          || mainApp.getEntityByTable(child.table || '');
        return candidate === lineEntity;
      });

      if (!declared) {
        broken.push(`${rel}: ${master.tableName} declares no child ${lineEntity.tableName}`);
      }
    }
  }

  assert.strictEqual(broken.length, 0, broken.slice(0, 5).join('; '));
});

test('every line field names a column on its own child entity', () => {
  const broken = [];

  for (const { rel, screen } of ALL) {
    for (const line of (screen.lines || [])) {
      const [pkg, name] = String(line.entity || '').split('/');
      const entity = mainApp.getEntity(pkg, name);
      if (!entity) {
        continue;
      }
      for (const field of line.fields) {
        if (!columnOf(entity, field.name)) {
          broken.push(`${rel}.${field.name}`);
        }
      }
    }
  }

  assert.strictEqual(broken.length, 0, `unknown columns: ${broken.slice(0, 5).join(', ')}`);
});

test('a line grid carries the key that ties it to its master', () => {
  // The service sets the foreign key from the master's key on save. Without it
  // the lines would be written unattached, which is worse than not writing
  // them: a row with no parent is invisible and undeletable from the screen.
  const broken = [];

  for (const { rel, screen } of ALL) {
    for (const line of (screen.lines || [])) {
      if (!line.childKey || !line.foreignKey) {
        broken.push(`${rel}: childKey=${line.childKey} foreignKey=${line.foreignKey}`);
      }
    }
  }

  assert.strictEqual(broken.length, 0, broken.slice(0, 5).join('; '));
});

test('a line grid never asks the user for its own foreign key', () => {
  // The master's key is not known when the line is typed, and a screen that
  // asked would be asking which document its own lines belong to.
  const broken = [];

  for (const { rel } of ALL) {
    const composed = screenView.forProgram(rel, { lang: 'en' });
    for (const line of ((composed && composed.lines) || [])) {
      const asked = line.fields.find(
        f => String(f.name).toLowerCase() === String(line.foreignKey).toLowerCase() && !f.hidden
      );
      if (asked) {
        broken.push(`${rel}.${line.foreignKey}`);
      }
    }
  }

  assert.strictEqual(broken.length, 0, broken.slice(0, 5).join(', '));
});

test('every composed line field can be drawn', () => {
  const broken = [];

  for (const { rel } of ALL) {
    const composed = screenView.forProgram(rel, { lang: 'en' });
    for (const line of ((composed && composed.lines) || [])) {
      if (!line.endpoint || !line.primaryKey) {
        broken.push(`${rel}: endpoint=${line.endpoint} primaryKey=${line.primaryKey}`);
      }
      for (const field of line.fields) {
        if (!field.input || (!field.label && !field.hidden)) {
          broken.push(`${rel}.${field.name}: label=${field.label} input=${field.input}`);
        }
      }
    }
  }

  assert.strictEqual(broken.length, 0, broken.slice(0, 5).join('; '));
});

console.log('\n--- Marking a menu tree with what can be drawn ---');

test('a program with a screen is marked, one without is marked false', () => {
  // The shape authService builds: menus holding progTypes holding programs.
  const described = screens.programs()[0];
  assert.ok(described, 'no program screens are loaded');

  const tree = [{
    id: 1, name: 'Clinics', url: 'Clinics',
    progTypes: [{
      id: 2, name: 'Management',
      programs: [
        { id: 70300315, name: 'Doctors', url: described, apiUrl: described },
        { id: 999, name: 'Nothing', url: 'no/such/program', apiUrl: 'no/such/program' }
      ]
    }]
  }];

  screenView.describeMenu(tree);

  const [hit, miss] = tree[0].progTypes[0].programs;
  assert.strictEqual(hit.described, true, `${described} should be described`);
  assert.strictEqual(miss.described, false, 'an undescribed program should say so');
});

test('marking removes nothing and adds nothing', () => {
  const tree = [{
    id: 1, url: 'Clinics',
    progTypes: [{ id: 2, programs: [{ id: 5, url: 'no/such/program' }] }]
  }];

  screenView.describeMenu(tree);

  assert.strictEqual(tree.length, 1);
  assert.strictEqual(tree[0].progTypes[0].programs.length, 1,
    'a program with no screen must stay in the tree, marked');
});

test('a menu or a type is not mistaken for a program', () => {
  // Menus carry a url too, so only a node with an id and no children of its
  // own is a program. Marking a menu would make the client treat a module as
  // something to open.
  const tree = [{ id: 1, url: 'Clinics', progTypes: [{ id: 2, programs: [] }] }];

  screenView.describeMenu(tree);

  assert.strictEqual(tree[0].described, undefined, 'a menu must not be marked');
  assert.strictEqual(tree[0].progTypes[0].described, undefined, 'a type must not be marked');
});

test('marking a tree with nothing in it does not throw', () => {
  assert.doesNotThrow(() => screenView.describeMenu(null));
  assert.doesNotThrow(() => screenView.describeMenu([]));
  assert.doesNotThrow(() => screenView.describeMenu([{ id: 1 }]));
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
 * Empty, and that is the point. It held `statusId` while
 * resources/modules/Clnc/Doctors.json recorded `isNull: true` for a column the
 * database declares NOT NULL -- one of 133 such disagreements. Reconciling the
 * models against the live schema fixed it, and this test failed with "statusId
 * now agrees" until the entry was removed, which is what the second assertion
 * below exists to make happen.
 *
 * Not a tolerance: the test fails if a name leaves this list still differing OR
 * if a name on it stops differing.
 */
const KNOWN_REQUIRED_DRIFT = {};

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
