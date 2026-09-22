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

  /**
   * Document screens it is safe to drive.
   *
   * `safeTargets` rules out anything with children, which is every document, so
   * the rule has to be different rather than absent. What matters is the same
   * thing: nothing may be left depending on a row this creates.
   *
   *   the master may be referenced by its own children -- that is what a
   *   document is -- and by nothing else;
   *   the child may be referenced by nothing at all.
   */
  async function safeDocuments() {
    const prgs = await wrapper.query(
      'SELECT ApiUrl, Url FROM Phs_MPrg WHERE Status_Id = 1', {});
    const refs = await wrapper.query(
      'SELECT rc.table_name AS child, pc.table_name AS parent FROM user_constraints rc '
      + 'JOIN user_constraints pc ON rc.r_constraint_name = pc.constraint_name '
      + "WHERE rc.constraint_type = 'R'", {});

    /** parent table -> the tables referencing it */
    const inbound = new Map();
    for (const row of refs) {
      const parent = String(row.PARENT).toUpperCase();
      if (!inbound.has(parent)) {
        inbound.set(parent, new Set());
      }
      inbound.get(parent).add(String(row.CHILD).toUpperCase());
    }

    const out = [];

    for (const row of prgs) {
      const url = String(row.APIURL || row.URL || '');
      const screen = screenView.forProgram(url, context);
      if (!screen || !screen.lines || screen.lines.length === 0 || !screen.form) {
        continue;
      }

      const [pkg, name] = String(screen.entity).split('/');
      const master = mainApp.getEntity(pkg, name);
      if (!master) {
        continue;
      }

      const lineTables = new Set();
      let describedAll = true;
      for (const line of screen.lines) {
        const [linePkg, lineName] = String(line.entity).split('/');
        const lineEntity = mainApp.getEntity(linePkg, lineName);
        if (!lineEntity) {
          describedAll = false;
          break;
        }
        lineTables.add(String(lineEntity.tableName).toUpperCase());
      }
      if (!describedAll) {
        continue;
      }

      // Anything referencing the master that is not one of its own lines.
      const onMaster = inbound.get(String(master.tableName).toUpperCase()) || new Set();
      const strangers = [...onMaster].filter(table => !lineTables.has(table));
      if (strangers.length > 0) {
        continue;
      }

      // Anything referencing a line at all.
      const lineIsReferenced = [...lineTables].some(table => (inbound.get(table) || new Set()).size > 0);
      if (lineIsReferenced) {
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

  /**
   * What an error means: something this harness cannot reach, or a defect.
   *
   * A trigger raising ORA-20xxx is a business rule -- "Undefined Transaction 0"
   * from fix/Disposals is the database refusing a disposal against no
   * transaction -- and a harness filling values from column types cannot
   * satisfy one. That is not the screen being wrong.
   */
  function classify(err) {
    const message = String(err.message).split('\n')[0];

    if (message.startsWith('NOPARENT')) {
      return { outcome: 'skipped', why: 'nothing to reference' };
    }
    if (/ORA-00942|does not exist|doesn't exist/i.test(message)) {
      return { outcome: 'skipped', why: 'the table is not in this copy' };
    }
    if (/ORA-02291|foreign key/i.test(message)) {
      return { outcome: 'skipped', why: 'a guessed reference does not exist' };
    }
    if (/ORA-00001|unique constraint|duplicate/i.test(message)) {
      return { outcome: 'skipped', why: 'collides with a row already there' };
    }
    if (/ORA-2\d{4}/.test(message)) {
      return { outcome: 'skipped', why: `a business rule refused it: ${message}` };
    }

    const detail = Array.isArray(err.details) && err.details.length > 0
      ? `${message} -- ${err.details.join('; ')}`
      : message;
    return { outcome: 'failed', why: detail };
  }

  /**
   * Removes a row this harness created, whatever went wrong after.
   *
   * Every failure path runs it. A create that succeeded and a line that then
   * collided leaves a document behind otherwise, which is data left in someone
   * else's database -- and the cascade takes its lines with it.
   *
   * @returns {Promise<boolean>} Whether the row is gone
   */
  async function cleanUp(pkg, name, id) {
    if (id === undefined || id === null) {
      return true;
    }
    try {
      await UnifiedService.delete(pkg, name, id, context);
      const left = await UnifiedService.get(pkg, name, id, context);
      return !left;
    } catch {
      return false;
    }
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
      const verdict = classify(err);
      const removed = await cleanUp(pkg, name, id);
      return { ...verdict, id: removed ? null : id };
    }
  }

  /**
   * A document screen's lines, through the whole cycle.
   *
   * `update` used to ignore children entirely -- it validated a payload allowed
   * to carry them and handed it to a repository that builds its SET from the
   * entity's own columns, so every line a user changed was discarded while the
   * save reported success. This drives the three cases the diff has to tell
   * apart: a line that stays and is edited, a line that is added, and a line
   * that is removed.
   */
  async function driveDocument(programUrl) {
    const screen = screenView.forProgram(programUrl, context);
    if (!screen || !screen.lines || screen.lines.length === 0) {
      return { outcome: 'skipped', why: 'no lines' };
    }

    const [pkg, name] = String(screen.entity).split('/');
    const line = screen.lines[0];
    let id = null;

    /** One line's worth of values, from what the line's own metadata says. */
    const lineRow = async (pass) => {
      const row = {};
      for (const field of line.fields) {
        if (field.name === line.primaryKey || field.name === line.foreignKey) {
          continue;
        }
        if ((pass === 1 && field.noInsert) || (pass === 2 && field.noUpdate)) {
          continue;
        }

        if (field.lookup || field.input === 'autocomplete') {
          const ref = await anExistingId(field.lookup || '');
          if (ref !== null) {
            row[field.name] = ref;
          } else if (field.required) {
            throw new Error(`NOPARENT ${field.name}`);
          } else {
            row[field.name] = field.defaultValue !== undefined ? field.defaultValue : 0;
          }
          continue;
        }

        switch (field.input) {
          case 'number': row[field.name] = pass; break;
          case 'date': row[field.name] = pass === 1 ? '2026-01-01' : '2026-02-02'; break;
          case 'datetime': row[field.name] = pass === 1 ? '2026-01-01 08:30:00' : '2026-02-02 09:45:00'; break;
          case 'time': row[field.name] = pass === 1 ? '08:30:00' : '09:45:00'; break;
          default: row[field.name] = `${MARK}${pass}`;
        }
      }
      return row;
    };

    try {
      // Two lines to start with, so one can later be kept and one removed.
      const body = await payloadFor(screen, 1);
      body[line.childKey] = [await lineRow(1), await lineRow(1)];

      const created = await UnifiedService.create(pkg, name, body, context);
      id = created[screen.primaryKey] ?? created.id;
      assert.ok(id !== undefined && id !== null, 'create returned no key');

      const read = await UnifiedService.get(pkg, name, id, context);
      const saved = read[line.childKey] || [];
      assert.strictEqual(saved.length, 2,
        `expected two lines back, got ${saved.length}`);
      for (const row of saved) {
        assert.strictEqual(String(row[line.foreignKey]), String(id),
          `a line came back attached to ${row[line.foreignKey]}, not ${id}`);
      }

      // Keep the first and edit it, drop the second, add a third.
      // Only the key is carried over, not the whole row. Echoing a read row
      // back re-sends the columns the server marks un-updatable, which a
      // renderer that honours `noUpdate` does not do either.
      const kept = { [line.primaryKey]: saved[0][line.primaryKey], ...(await lineRow(2)) };
      const added = await lineRow(1);

      const changes = await payloadFor(screen, 2);
      changes[line.childKey] = [kept, added];
      await UnifiedService.update(pkg, name, id, changes, context);

      const again = await UnifiedService.get(pkg, name, id, context);
      const now = again[line.childKey] || [];

      assert.strictEqual(now.length, 2,
        `after keeping one, dropping one and adding one: expected two lines, got ${now.length}`);

      // The kept line kept its identity rather than being deleted and remade.
      const survivor = now.find(row => String(row[line.primaryKey]) === String(saved[0][line.primaryKey]));
      assert.ok(survivor, 'the kept line was renumbered; it should keep its key');

      // And the dropped one is gone.
      const dropped = now.find(row => String(row[line.primaryKey]) === String(saved[1][line.primaryKey]));
      assert.ok(!dropped, 'the removed line is still there');

      await UnifiedService.delete(pkg, name, id, context);
      const gone = await UnifiedService.get(pkg, name, id, context);
      assert.ok(!gone, `delete left row ${id}`);

      // The cascade took the lines with it.
      const orphans = await repository.find(
        mainApp.getEntity(...String(line.entity).split('/')),
        { filters: { [line.foreignKey]: id } },
        context
      );
      assert.strictEqual(orphans.length, 0, `${orphans.length} line(s) outlived their document`);

      return { outcome: 'ok', id };
    } catch (err) {
      const verdict = classify(err);
      const removed = await cleanUp(pkg, name, id);
      return { ...verdict, id: removed ? null : id };
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

  // --- documents, with their lines ---------------------------------------

  const documents = await safeDocuments();

  console.log(`\n--- Documents with lines, on ${documents.length} screen(s) ---`);

  const docResults = [];
  for (const target of documents) {
    const result = await driveDocument(target);
    docResults.push({ target, ...result });
    const tick = result.outcome === 'ok' ? 'ok  ' : result.outcome === 'skipped' ? 'skip' : 'FAIL';
    console.log(`  ${tick} ${target.padEnd(34)} ${result.outcome === 'ok' ? `document ${result.id}, two lines, one edited, one replaced, cascaded` : result.why}`);
  }

  const docFailures = docResults.filter(r => r.outcome === 'failed');

  await test('a document saves, edits and removes its lines', async () => {
    assert.strictEqual(docFailures.length, 0,
      docFailures.map(f => `${f.target}: ${f.why}`).join(' | '));
  });

  const leftover = [...results, ...docResults].filter(r => r.outcome !== 'ok' && r.id);
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
