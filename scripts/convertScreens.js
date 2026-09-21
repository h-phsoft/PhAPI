#!/usr/bin/env node
/**
 * Converts the legacy query definitions into screen metadata.
 *
 * The Java system's query and statistics screens are "nearly unified" because
 * they are drawn from 595 JSON definitions rather than written one by one.
 * Those definitions were never read by this API -- `reportService.toReport`
 * flattens an entity into "every field is a column and every field is a
 * filter, with no operators" -- so the whole contract has been dead since the
 * port began, and was deleted along with db/JSON/pkgs.
 *
 * This recovers them from git history and converts them, rather than inventing
 * a format. What it emits is an overlay: only what the schema cannot supply.
 * A field's type, precision, nullability and relations come from the generated
 * entity model, which is accurate; the legacy `dataType` is absent on 64% of
 * fields and is not carried across.
 *
 * Two spellings of the aggregate keys appear in the source -- `Aggregate` and
 * `Agregate`, `isAggregate` and `isAgregate` -- and both are read. Taking only
 * the correct one would lose a third of the aggregates.
 *
 *   node scripts/convertScreens.js --from <dir>            # dry run
 *   node scripts/convertScreens.js --from <dir> --apply
 *   node scripts/convertScreens.js --recover <git-ref>     # pull them first
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ROOT = path.join(__dirname, '..');
const SCREENS = path.join(ROOT, 'resources', 'screens');

const mainApp = require('../metadata/registry');
const { operatorsFor } = require('../core/query/conditions');

// ---------------------------------------------------------------------------
// Command line
// ---------------------------------------------------------------------------

function parseArgs(argv) {
  const args = {};
  for (let i = 0; i < argv.length; i++) {
    if (!argv[i].startsWith('--')) {
      continue;
    }
    const key = argv[i].slice(2);
    const next = argv[i + 1];
    if (next && !next.startsWith('--')) {
      args[key] = next;
      i++;
    } else {
      args[key] = true;
    }
  }
  return args;
}

const args = parseArgs(process.argv.slice(2));
const apply = args.apply === true;

// ---------------------------------------------------------------------------
// Recovering the definitions
// ---------------------------------------------------------------------------

/**
 * Pulls every reports/*.json out of a commit into a directory.
 *
 * @param {string} ref A git ref where db/JSON/pkgs still existed
 * @param {string} into
 * @returns {number} How many were recovered
 */
function recover(ref, into) {
  fs.mkdirSync(into, { recursive: true });

  const listed = execSync(`git ls-tree -r ${ref} --name-only`, { cwd: ROOT, encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 })
    .split('\n')
    .map(s => s.trim())
    .filter(f => /\/reports\/.*\.json$/.test(f));

  let n = 0;
  for (const file of listed) {
    const flat = file.replace('db/JSON/pkgs/', '').split('/').join('_');
    try {
      const content = execSync(`git show "${ref}:${file}"`, { cwd: ROOT, encoding: 'utf8', maxBuffer: 16 * 1024 * 1024 });
      fs.writeFileSync(path.join(into, flat), content, 'utf8');
      n++;
    } catch {
      // A file that cannot be read from that ref simply is not there.
    }
  }
  return n;
}

// ---------------------------------------------------------------------------
// Conversion
// ---------------------------------------------------------------------------

/** True for the several spellings the source uses for "yes". */
function isTrue(value) {
  return value === true || String(value).toLowerCase() === 'true';
}

/**
 * The aggregate functions a field offers.
 *
 * Both spellings are read: `Aggregate` appears 12849 times and `Agregate`
 * 3926, and the same for the `is` flag. Reading only the correct spelling
 * loses a third of them.
 *
 * @param {Object} field A legacy field definition
 * @returns {string[]}
 */
function aggregatesOf(field) {
  const enabled = isTrue(field.isAggregate) || isTrue(field.isAgregate);
  if (!enabled) {
    return [];
  }

  const table = field.Aggregate || field.Agregate || {};
  return Object.entries(table)
    .filter(([, on]) => isTrue(on))
    .map(([name]) => name);
}

/**
 * The entity a legacy definition names, as this project registers it.
 *
 * @param {Object} legacy
 * @returns {{key: string, entity: Object}|null}
 */
function resolveEntity(legacy) {
  const table = legacy.Name || legacy.tableName;
  if (!table) {
    return null;
  }

  const entity = mainApp.getEntityByTable(table)
    || mainApp.getEntityBySynonym(legacy.Synonym || '')
    || null;

  if (!entity) {
    return null;
  }

  return { key: `${entity.package}/${path.basename(entity.sourcePath || '', '.json')}`, entity };
}

/**
 * Converts one legacy definition.
 *
 * @param {Object} legacy
 * @param {Object} resolved From resolveEntity
 * @returns {{screen: Object, skippedFields: string[]}}
 */
function convert(legacy, resolved) {
  const { key, entity } = resolved;
  const byField = new Map(entity.fields.map(f => [String(f.Field).toLowerCase(), f]));
  const byExactField = new Map(entity.fields.map(f => [f.Field, f]));

  const fields = [];
  const skippedFields = [];

  for (const legacyField of (legacy.Fields || [])) {
    const raw = legacyField.Field || legacyField.Name;
    if (!raw) {
      continue;
    }

    // Some definitions qualify the field with its package -- `Cash.ordId`,
    // `Bank.id` -- which the entity does not. Reading the bare name lost every
    // field on 62 screens, which looked like drift and was a lookup bug.
    const name = String(raw).includes('.') ? String(raw).split('.').pop() : raw;

    // Exact first. Twenty-seven entities expose two columns whose API names
    // differ only in case -- Insdate beside Ins_Date, Cont_Rid beside
    // Contr_Id -- and a case-insensitive lookup picks between them at random.
    const fieldMeta = byExactField.get(name) || byField.get(String(name).toLowerCase());
    if (!fieldMeta) {
      // A column the entity does not have: the view was widened or narrowed
      // since. Reported rather than carried, because a screen naming a column
      // that is not there is a screen that cannot run.
      skippedFields.push(raw);
      continue;
    }

    const allowedHere = operatorsFor(fieldMeta);
    const declared = Array.isArray(legacyField.Operations) ? legacyField.Operations : [];

    // The declared list narrowed to what this column's type actually permits.
    // The two disagree where the legacy dataType was absent and everything
    // defaulted to text.
    const operators = declared.filter(op => allowedHere.includes(op));

    const field = { name: fieldMeta.Field };

    // One key per column name, shared across every screen that shows it.
    // The legacy screens did the same -- getLabel('Name') -- and it is the
    // difference between translating "Remarks" once and translating it 358
    // times. A screen needing a different word for the same column overrides
    // it with its own label; nothing here stops that.
    field.labelKey = fieldMeta.Field;

    if (isTrue(legacyField.isFilter)) {
      field.filter = true;
    }
    if (isTrue(legacyField.isVisible) || isTrue(legacyField.isDisplay)) {
      field.display = true;
    }
    if (isTrue(legacyField.isGroup)) {
      field.group = true;
    }
    if (isTrue(legacyField.isOrder)) {
      field.sort = true;
    }
    if (operators.length > 0) {
      field.operators = operators;
    }

    const aggregate = aggregatesOf(legacyField);
    if (aggregate.length > 0) {
      field.aggregate = aggregate;
    }
    if (legacyField.Expression) {
      field.expression = legacyField.Expression;
    }

    const autocomplete = legacyField.Autocomplete;
    if (autocomplete && Object.keys(autocomplete).length > 0) {
      field.autocomplete = autocomplete.Name || autocomplete.Table || autocomplete;
    }

    const width = legacyField.Style && legacyField.Style.Width;
    if (width && width !== 'max-content') {
      field.width = width;
    }

    fields.push(field);
  }

  const screen = {
    version: '1.0',
    kind: 'query',
    entity: key,
    order: legacy.Order || entity.primaryKey,
    fields
  };

  if (legacy.Condition) {
    screen.condition = legacy.Condition;
  }
  if (legacy.PeriodCondition) {
    screen.periodCondition = legacy.PeriodCondition;
  }

  return { screen, skippedFields };
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

function main() {
  if (typeof args.recover === 'string') {
    const into = args.from || path.join(ROOT, '.recovered-reports');
    const n = recover(args.recover, into);
    console.log(`  recovered ${n} definition(s) from ${args.recover} into ${into}`);
    if (!args.from) {
      return;
    }
  }

  const from = args.from;
  if (!from || !fs.existsSync(from)) {
    console.error('  --from <dir> is required and must exist.');
    console.error('  Use --recover <ref> to pull the definitions out of history first.');
    process.exitCode = 1;
    return;
  }

  mainApp.loadMetadata([path.join(ROOT, 'resources', 'modules')]);

  let converted = 0;
  let unresolved = 0;
  let fieldsKept = 0;
  let fieldsSkipped = 0;
  const written = [];
  const missing = [];

  for (const file of fs.readdirSync(from).sort()) {
    if (!file.endsWith('.json')) {
      continue;
    }

    let legacy;
    try {
      legacy = JSON.parse(fs.readFileSync(path.join(from, file), 'utf8'));
    } catch {
      continue;
    }

    const resolved = resolveEntity(legacy);
    if (!resolved) {
      unresolved++;
      missing.push(legacy.Name || file);
      continue;
    }

    const { screen, skippedFields } = convert(legacy, resolved);
    fieldsKept += screen.fields.length;
    fieldsSkipped += skippedFields.length;

    // Named after the screen, not the entity. Several screens read the same
    // view -- Fix/Inbound and Fix/InboundStatistics are two screens over
    // Fix_Inbound_View -- so naming files after the entity made eighteen of
    // them overwrite each other.
    const [pkg, , name] = file.replace(/\.json$/, '').split('_');
    screen.screen = `${pkg}/${name}`;

    const dir = path.join(SCREENS, pkg);
    const dest = path.join(dir, `${name}.json`);

    if (apply) {
      fs.mkdirSync(dir, { recursive: true });
      fs.writeFileSync(dest, `${JSON.stringify(screen, null, 2)}\n`, 'utf8');
    }

    converted++;
    written.push(path.relative(ROOT, dest).split(path.sep).join('/'));
  }

  console.log(`  definitions read     : ${converted + unresolved}`);
  console.log(`  ${apply ? 'written' : 'would write'}              : ${converted}`);
  console.log(`  entity not registered: ${unresolved}`);
  console.log(`  fields carried       : ${fieldsKept}`);
  console.log(`  fields dropped       : ${fieldsSkipped}   (column not on the entity)`);

  for (const w of written.slice(0, 8)) {
    console.log(`      ${w}`);
  }
  if (written.length > 8) {
    console.log(`      ... and ${written.length - 8} more`);
  }

  if (missing.length) {
    console.log(`\n  unresolved tables (first 8):`);
    for (const m of missing.slice(0, 8)) {
      console.log(`      ${m}`);
    }
  }

  if (!apply) {
    console.log('\n  Dry run. Re-run with --apply to write.');
  }
}

main();
