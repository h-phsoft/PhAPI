/**
 * Reloading metadata without a restart (Step 5.5).
 *
 * Runs against copies in a temporary directory, never against resources/: an
 * entity, a query definition, a locale and an autocomplete template are
 * written, loaded, changed on disk and reloaded, and each test checks what a
 * running server would then answer with. A file broken mid-save must leave
 * the server as it was.
 */

const assert = require('assert');
const fs = require('fs');
const os = require('os');
const path = require('path');

const mainApp = require('../metadata/registry');
const screens = require('../metadata/screens');
const i18nHelper = require('../utils/i18nHelper');
const autocompleteService = require('../services/autocompleteService');
const metadataReload = require('../services/metadataReload');

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

const root = fs.mkdtempSync(path.join(os.tmpdir(), 'phapi-reload-'));
const dirs = {
  modules: path.join(root, 'modules'),
  programs: path.join(root, 'programs'),
  reports: path.join(root, 'screens'),
  locales: path.join(root, 'locales'),
  autocomplete: path.join(root, 'autocomplete')
};

function write(file, value) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, typeof value === 'string' ? value : JSON.stringify(value, null, 2));
}

const modelFile = path.join(dirs.modules, 'Tst', 'Things.json');
const screenFile = path.join(dirs.reports, 'Tst', 'Things.json');
const localeFile = path.join(dirs.locales, 'en.json');
const templateFile = path.join(dirs.autocomplete, 'Tst', 'Things.json');

function model(fields) {
  return {
    package: 'Tst',
    tableName: 'Tst_Things',
    primaryKey: 'id',
    fields: fields.map((name) => ({ Name: name, Field: name.toLowerCase(), DBType: 'NUMBER', Type: 'Long' }))
  };
}

const quiet = { log: console.log, error: console.error, warn: console.warn };
function silenced(fn) {
  console.log = () => {};
  console.error = () => {};
  console.warn = () => {};
  try {
    return fn();
  } finally {
    Object.assign(console, quiet);
  }
}

(async () => {
  console.log('\n--- Reloading metadata ---');

  write(modelFile, model(['Id', 'Name']));
  write(screenFile, { version: '1.0', kind: 'query', entity: 'Tst/Things', fields: [{ name: 'name' }] });
  write(localeFile, { fields: { name: 'Name' } });
  write(templateFile, { Synonym: 'Tst_Things', Select: 'SELECT Id, Name FROM Tst_Things' });
  fs.mkdirSync(dirs.programs, { recursive: true });

  i18nHelper.localesDir = dirs.locales;
  autocompleteService.rootDir = dirs.autocomplete;
  silenced(() => {
    mainApp.loadMetadata([dirs.modules]);
    screens.load({ programs: dirs.programs, reports: dirs.reports });
    i18nHelper.loadLocales();
    autocompleteService.loadAllAutocompleteMetadata();
  });

  await test('an edited model is what the registry answers with after a reload', () => {
    const before = mainApp.getEntity('Tst', 'Things');
    assert.deepStrictEqual(before.fields.map((f) => f.Field), ['id', 'name']);

    write(modelFile, model(['Id', 'Name', 'Code']));
    const result = silenced(() => metadataReload.reload());

    assert.strictEqual(result.ok, true);
    const after = mainApp.getEntity('Tst', 'Things');
    assert.deepStrictEqual(after.fields.map((f) => f.Field), ['id', 'name', 'code']);
    // A new object, so what was cached against the old one is not reused.
    assert.notStrictEqual(after, before);
  });

  await test('a model saved half-written keeps the registry as it was', () => {
    write(modelFile, '{ "package": "Tst", "tableName": "Tst_Thi');
    const result = silenced(() => metadataReload.reload());

    assert.strictEqual(result.ok, false);
    assert.strictEqual(result.entities.kept, true);
    assert.match(result.entities.errors[0].file, /Things\.json$/);
    // Still the last good definition, not missing.
    assert.deepStrictEqual(mainApp.getEntity('Tst', 'Things').fields.map((f) => f.Field), ['id', 'name', 'code']);

    write(modelFile, model(['Id', 'Name', 'Code']));
    assert.strictEqual(silenced(() => metadataReload.reload()).ok, true);
  });

  await test('a model deleted from disk is gone after a reload', () => {
    const extra = path.join(dirs.modules, 'Tst', 'Others.json');
    write(extra, { ...model(['Id']), tableName: 'Tst_Others' });
    silenced(() => metadataReload.reload());
    assert.ok(mainApp.getEntity('Tst', 'Others'));

    fs.unlinkSync(extra);
    silenced(() => metadataReload.reload());
    assert.strictEqual(mainApp.getEntity('Tst', 'Others'), null);
  });

  await test('an edited query definition, label and template reload too', () => {
    write(screenFile, { version: '1.0', kind: 'query', entity: 'Tst/Things', fields: [{ name: 'name' }, { name: 'code' }] });
    write(localeFile, { fields: { name: 'Thing Name' } });
    write(templateFile, { Synonym: 'Tst_Things', Select: 'SELECT Id, Code FROM Tst_Things' });

    const result = silenced(() => metadataReload.reload());
    assert.strictEqual(result.ok, true);
    assert.strictEqual(screens.getReport('Tst', 'Things').fields.length, 2);
    assert.strictEqual(i18nHelper.locales.en.fields.name, 'Thing Name');
    assert.strictEqual(autocompleteService.getMetadata('Tst', 'Things').Select, 'SELECT Id, Code FROM Tst_Things');
  });

  await test('a broken locale keeps the labels in use, and the rest still reloads', () => {
    write(localeFile, '{ "fields": { "name": ');
    write(modelFile, model(['Id', 'Name', 'Code', 'Rem']));

    const result = silenced(() => metadataReload.reload());
    assert.strictEqual(result.ok, false);
    assert.strictEqual(result.labels.kept, true);
    assert.strictEqual(i18nHelper.locales.en.fields.name, 'Thing Name');
    // Each part stands alone: the model, which read cleanly, is the new one.
    assert.strictEqual(result.entities.kept, false);
    assert.strictEqual(mainApp.getEntity('Tst', 'Things').fields.length, 4);

    write(localeFile, { fields: { name: 'Thing Name' } });
  });

  await test('a change on disk is picked up by the watcher, once', async () => {
    const results = [];
    const watcher = silenced(() => metadataReload.watch({
      quietMs: 150,
      dirs: [dirs.modules],
      onReload: (result) => results.push(result)
    }));
    console.log = () => {};
    try {
      // Several writes in a row, as an editor or a script makes them.
      await new Promise((resolve) => setTimeout(resolve, 100));
      write(modelFile, model(['Id', 'Name', 'Code', 'Rem', 'Qty']));
      write(modelFile, model(['Id', 'Name', 'Code', 'Rem', 'Qty', 'Price']));

      const deadline = Date.now() + 5000;
      while (results.length === 0 && Date.now() < deadline) {
        await new Promise((resolve) => setTimeout(resolve, 50));
      }
      await new Promise((resolve) => setTimeout(resolve, 400));
    } finally {
      watcher.stop();
      Object.assign(console, quiet);
    }
    assert.strictEqual(results.length, 1, `reloaded ${results.length} times`);
    assert.strictEqual(mainApp.getEntity('Tst', 'Things').fields.length, 6);
  });

  fs.rmSync(root, { recursive: true, force: true });

  console.log(`\n  reload: ${passed} passed, ${failed} failed\n`);
  if (failed > 0) {
    process.exitCode = 1;
  }
})();
