/**
 * A screen's full cycle, driven from its metadata alone.
 *
 * Step 4's exit condition is that a screen renders, searches, saves and deletes
 * against the real database. The first two are provable without touching
 * anything. The last two are not, so this creates a row, reads it back, changes
 * it, reads it again and removes it -- through `UnifiedService`, which is the
 * path the screen itself uses, so validation, autonumbering and the audit
 * stamps are exercised rather than bypassed.
 *
 * Nothing about the payload is written here. Every value is chosen from what
 * the composed screen says the field is, which is the whole point: if the
 * metadata is not enough to save a row, this fails, and that is the finding.
 * It is how the autonumber defect was found -- 45 of the 93 Table screens could
 * not assign a primary key, so every create went in with a NULL.
 *
 * **This writes to a real tenant**, so it is behind its own switch rather than
 * RUN_INTEGRATION_TESTS, which everything else uses and which only reads:
 *
 *   RUN_WRITE_TESTS=1 TEST_TENANT=Demo node tests/crud.test.js
 *
 * Three things keep it safe to run:
 *   - only tables nothing else references and that have no children, so a row
 *     cannot be left depended on or leave orphans;
 *   - every text value is prefixed ZZTEST, so anything left behind is
 *     identifiable;
 *   - the row is deleted at the end, and a delete that does not happen is
 *     reported with the id rather than swallowed.
 *
 * An outcome this harness cannot reach -- a table absent from the copy, a
 * unique key that collides with real data, an empty table to reference -- is
 * reported as skipped. Only a screen that got far enough to be wrong fails.
 */

const assert = require('assert');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const RUN = process.env.RUN_WRITE_TESTS === '1';
const TENANT = process.env.TEST_TENANT || 'Demo';

const mainApp = require('../metadata/registry');
const screens = require('../metadata/screens');
const screenView = require('../presentation/screens');

const MARK = 'ZZTEST';

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

mainApp.loadMetadata([path.join(ROOT, 'resources', 'modules')]);
screens.load({
  programs: path.join(ROOT, 'resources', 'programs'),
  reports: path.join(ROOT, 'resources', 'screens')
});

console.log('\n--- A screen can be saved from its own metadata ---');

/**
 * Every program screen whose key the server can assign.
 *
 * Checked without touching the database, because it is a fact about the
 * metadata: a key that is neither generated nor asked for goes in as whatever
 * the client had, which is 0 from an entry form.
 */
function keyless() {
  const broken = [];

  for (const programUrl of screens.programs()) {
    const screen = screens.getProgram(programUrl);
    if (!screen || !screen.form) {
      continue;
    }

    const composed = screenView.forProgram(programUrl, { lang: 'en' });
    const [pkg, name] = String(screen.entity).split('/');
    const entity = mainApp.getEntity(pkg, name);
    if (!entity) {
      continue;
    }

    const key = entity.fields.find(
      f => String(f.Field).toLowerCase() === String(entity.primaryKey).toLowerCase()
    );
    if (!key || key.isAutonumber) {
      continue;
    }

    const asked = composed.form.fields.find(
      f => String(f.name).toLowerCase() === String(entity.primaryKey).toLowerCase() && !f.hidden
    );
    if (!asked) {
      broken.push(`${programUrl} (${entity.tableName}.${entity.primaryKey})`);
    }
  }

  return broken;
}

void test('every screen either is given its key or asks for it', async () => {
  const broken = keyless();
  assert.strictEqual(broken.length, 0,
    `${broken.length} screens cannot assign a key: ${broken.slice(0, 5).join(', ')}`);
});

void test('a field the server refuses says so, rather than collecting a value', async () => {
  // 19 fields across 15 screens sit on a column marked un-insertable or
  // un-updatable. A renderer that is not told shows an input whose every value
  // is thrown away, and the save is rejected with no way to see why.
  const silent = [];

  for (const programUrl of screens.programs()) {
    const screen = screens.getProgram(programUrl);
    if (!screen || !screen.form) {
      continue;
    }
    const [pkg, name] = String(screen.entity).split('/');
    const entity = mainApp.getEntity(pkg, name);
    if (!entity) {
      continue;
    }
    const byName = new Map(entity.fields.map(f => [String(f.Field).toLowerCase(), f]));
    const composed = screenView.forProgram(programUrl, { lang: 'en' });

    for (const field of composed.form.fields) {
      const meta = byName.get(String(field.name).toLowerCase());
      if (!meta) {
        continue;
      }
      if (meta.insert === false && !field.noInsert) {
        silent.push(`${programUrl}.${field.name} (no insert)`);
      }
      if (meta.update === false && !field.noUpdate) {
        silent.push(`${programUrl}.${field.name} (no update)`);
      }
    }
  }

  assert.strictEqual(silent.length, 0, `not reported: ${silent.slice(0, 5).join(', ')}`);
});

// ---------------------------------------------------------------------------
// The live cycle
// ---------------------------------------------------------------------------

async function runLive() {
  const repository = require('../repository/unifiedRepository');
  const { UnifiedService } = require('../services/unifiedService');
  const pool = require('../core/connectionPool');

  const context = { tenantId: TENANT, userId: '1', lang: 'en' };
  const wrapper = await pool.getPool(TENANT);

  /** Tables nothing references and that have no children of their own. */
  async function safeTargets() {
    const prgs = await wrapper.query(
      'SELECT ApiUrl, Url FROM Phs_MPrg WHERE Status_Id = 1 AND Type_Id = 5', {});
    const refs = await wrapper.query(
      'SELECT pc.table_name AS parent FROM user_constraints rc '
      + 'JOIN user_constraints pc ON rc.r_constraint_name = pc.constraint_name '
      + "WHERE rc.constraint_type = 'R'", {});

    const referenced = new Set(refs.map(r => String(r.PARENT).toUpperCase()));
    const out = [];

    for (const row of prgs) {
      const url = String(row.APIURL || row.URL || '');
      const screen = screens.getProgram(url);
      if (!screen || !screen.form) {
        continue;
      }
      const [pkg, name] = String(screen.entity).split('/');
      const entity = mainApp.getEntity(pkg, name);
      if (!entity || referenced.has(String(entity.tableName).toUpperCase())) {
        continue;
      }
      if ((entity.children || []).length > 0) {
        continue;
      }
      out.push(url);
    }

    return out;
  }

  /** One existing id from a lookup table, or null when it has no rows. */
  async function anExistingId(lookupPath) {
    const parts = String(lookupPath).split('/').filter(Boolean);
    const entity = mainApp.getEntity(parts[1], parts[2]);
    if (!entity) {
      return null;
    }
    const rows = await repository.find(entity, { page: 1, pageSize: 1 }, context);
    return rows && rows.length > 0 ? (rows[0][entity.primaryKey] ?? null) : null;
  }

  /** A payload the screen's own metadata says is valid. */
  async function payloadFor(screen, pass) {
    const body = {};

    for (const field of screen.form.fields) {
      if (field.name === screen.primaryKey) {
        continue;
      }
      if ((pass === 1 && field.noInsert) || (pass === 2 && field.noUpdate)) {
        continue;
      }

      if (field.lookup || field.input === 'autocomplete') {
        const id = await anExistingId(field.lookup || '');
        if (id !== null) {
          body[field.name] = id;
        } else if (field.required) {
          throw new Error(`NOPARENT ${field.name}`);
        } else {
          body[field.name] = field.defaultValue !== undefined ? field.defaultValue : 0;
        }
        continue;
      }

      switch (field.input) {
        case 'number': body[field.name] = pass; break;
        case 'date': body[field.name] = pass === 1 ? '2026-01-01' : '2026-02-02'; break;
        case 'datetime': body[field.name] = pass === 1 ? '2026-01-01 08:30:00' : '2026-02-02 09:45:00'; break;
        case 'time': body[field.name] = pass === 1 ? '08:30:00' : '09:45:00'; break;
        default: body[field.name] = `${MARK}${pass}`;
      }
    }

    return body;
  }

  /** The text fields, which are the ones whose value can be compared exactly. */
  function textFields(screen) {
    return screen.form.fields.filter(
      f => f.input === 'text' && f.name !== screen.primaryKey && !f.lookup
    );
  }

  async function drive(programUrl) {
    const screen = screenView.forProgram(programUrl, context);
    const [pkg, name] = String(screen.entity).split('/');
    let id = null;

    try {
      const created = await UnifiedService.create(pkg, name, await payloadFor(screen, 1), context);
      id = created[screen.primaryKey] ?? created.id;
      assert.ok(id !== undefined && id !== null, 'create returned no key');

      const read = await UnifiedService.get(pkg, name, id, context);
      assert.ok(read, `created ${id} but could not read it back`);

      for (const field of textFields(screen)) {
        if (field.noInsert) {
          continue;
        }
        assert.strictEqual(String(read[field.name] ?? ''), `${MARK}1`,
          `${field.name} read back as ${JSON.stringify(read[field.name])}`);
      }

      await UnifiedService.update(pkg, name, id, await payloadFor(screen, 2), context);

      const again = await UnifiedService.get(pkg, name, id, context);
      for (const field of textFields(screen)) {
        if (field.noInsert || field.noUpdate) {
          continue;
        }
        assert.strictEqual(String(again[field.name] ?? ''), `${MARK}2`,
          `${field.name} did not take the update: ${JSON.stringify(again[field.name])}`);
      }

      await UnifiedService.delete(pkg, name, id, context);
      const gone = await UnifiedService.get(pkg, name, id, context);
      assert.ok(!gone, `delete left row ${id} behind`);

      return { outcome: 'ok', id };
    } catch (err) {
      const message = String(err.message).split('\n')[0];

      if (message.startsWith('NOPARENT')) {
        return { outcome: 'skipped', why: 'nothing to reference', id };
      }
      if (/ORA-00942|does not exist|doesn't exist/i.test(message)) {
        return { outcome: 'skipped', why: 'the table is not in this copy', id };
      }
      if (/ORA-02291|foreign key/i.test(message)) {
        return { outcome: 'skipped', why: 'a guessed reference does not exist', id };
      }
      if (/ORA-00001|unique constraint|duplicate/i.test(message)) {
        return { outcome: 'skipped', why: 'collides with a row already there', id };
      }

      const detail = Array.isArray(err.details) && err.details.length > 0
        ? `${message} -- ${err.details.join('; ')}`
        : message;
      return { outcome: 'failed', why: detail, id };
    }
  }

  const targets = await safeTargets();
  console.log(`\n--- The live cycle, on ${targets.length} screen(s) against '${TENANT}' ---`);

  const results = [];
  for (const target of targets) {
    const result = await drive(target);
    results.push({ target, ...result });
    const tick = result.outcome === 'ok' ? 'ok  ' : result.outcome === 'skipped' ? 'skip' : 'FAIL';
    console.log(`  ${tick} ${target.padEnd(34)} ${result.outcome === 'ok' ? `created ${result.id}, read, updated, deleted` : result.why}`);
  }

  const done = results.filter(r => r.outcome === 'ok');
  const failures = results.filter(r => r.outcome === 'failed');

  await test(`at least one screen completes the whole cycle (${done.length} did)`, async () => {
    assert.ok(done.length > 0,
      'not one screen could be driven end to end; the harness is proving nothing');
  });

  await test('no screen failed part way through', async () => {
    assert.strictEqual(failures.length, 0,
      failures.map(f => `${f.target}: ${f.why}`).join(' | '));
  });

  const leftover = results.filter(r => r.outcome !== 'ok' && r.id);
  await test('nothing was left behind', async () => {
    assert.strictEqual(leftover.length, 0,
      `remove by hand: ${leftover.map(r => `${r.target} id=${r.id}`).join(', ')}`);
  });
}

(async () => {
  if (RUN) {
    await runLive();
  } else {
    console.log('\n- [SKIP] the live create/read/update/delete cycle');
    console.log('         it writes to a real tenant; RUN_WRITE_TESTS=1 to include it');
  }

  console.log(`\n  crud: ${passed} passed, ${failed} failed\n`);
  if (failed > 0) {
    process.exitCode = 1;
  }
  // The pool holds the process open once the live cycle has opened it.
  if (RUN) {
    process.exit(failed > 0 ? 1 : 0);
  }
})();
