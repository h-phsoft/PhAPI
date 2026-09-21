#!/usr/bin/env node
/**
 * Converts the Java client's page scripts into program screen metadata.
 *
 * MIGRATION-PLAN.md, P1: recover before inventing. Step 2 recovered the first of
 * the two declarative sources the Java system carries -- the 595 query
 * definitions, which describe what may be searched and reported on one entity.
 * This recovers the second, which the plan names in the same rule: the
 * per-screen `aFields` and `aQFields`.
 *
 * They answer a different question, and the difference is why one cannot stand
 * in for the other. A query definition says "Clnc_Doctors has twenty searchable
 * columns, audit stamps included". A page script says "the Doctors screen is
 * these sixteen fields, in this order, with Speciality as a select and User as
 * an autocomplete" -- which is the screen, and is nowhere in the schema.
 *
 * What is emitted is an overlay, the same as Step 2's and for the same reason:
 * a field's type, precision, nullability, default and lookup relation come from
 * the generated entity model and are not restated here. What the schema cannot
 * know is the field list, its order, the label key, and whether a reference is
 * picked from a list or searched for.
 *
 * One file per program, at the program's own path, because a program is what a
 * client asks for: `resources/programs/clnc/mng/Doctors.json` serves the
 * program `clnc/mng/Doctors`. Adding a screen is adding a file (M5).
 *
 *   node scripts/convertPrograms.js --from <PhsApp/web/assets>
 *   node scripts/convertPrograms.js --from <PhsApp/web/assets> --apply
 *   node scripts/convertPrograms.js --from <...> --only clnc/mng/Doctors
 */

const fs = require('fs');
const path = require('path');
const vm = require('vm');

const ROOT = path.join(__dirname, '..');
const PROGRAMS = path.join(ROOT, 'resources', 'programs');

const mainApp = require('../metadata/registry');
const { operatorsFor } = require('../core/query/conditions');
// The same derivation the renderer uses, so "the entity already implies this"
// means the same thing at conversion time as it does at render time. Two copies
// of it would let a screen record an input that was never needed, or omit one
// that was.
const { inputFor: derivedInput } = require('../presentation/screens');
const { readScreen } = require('./lib/javaScreen');

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
// The operator tokens, read from the source rather than transcribed
// ---------------------------------------------------------------------------

/**
 * `PhFOper_CT` is 10 and the tenth entry of `PhFOperations` carries `sign: '%'`.
 * The page scripts declare their operators as those numbers, so the numbers
 * have to become tokens somewhere -- and reading the table out of PhConst.js is
 * the one way to do it that cannot drift from the file it came from.
 *
 * @param {string} constantsPath PhConst.js
 * @returns {string[]} Token by ordinal
 */
function operatorTokens(constantsPath) {
  const sandbox = { getLabel: (k) => String(k) };
  const context = vm.createContext(sandbox);

  // PhConst.js declares with `let`, which in a vm context lands in the global
  // lexical environment rather than on the context object -- so the table is
  // read as the script's completion value, not off `context`.
  const source = `${fs.readFileSync(constantsPath, 'utf8')}\n;PhFOperations;`;
  const table = vm.runInContext(source, context, { timeout: 5000 });
  if (!Array.isArray(table) || table.length === 0) {
    throw new Error('PhFOperations not found in PhConst.js');
  }
  return table.map((entry) => entry && entry.sign);
}

// ---------------------------------------------------------------------------
// Conversion
// ---------------------------------------------------------------------------

/** The entity a page's `/UC/Pkg/Name` endpoint names, as this project has it. */
function resolveEntity(api) {
  const parts = String(api || '').split('/').filter(Boolean);
  const at = parts.findIndex((p) => p === 'UC' || p === 'CC');
  if (at === -1 || parts.length < at + 3) {
    return null;
  }

  const entity = mainApp.getEntity(parts[at + 1], parts[at + 2]);
  if (!entity) {
    return null;
  }

  return { key: `${entity.package}/${path.basename(entity.sourcePath || '', '.json')}`, entity };
}

/**
 * A page's field name as the entity spells it, or null when it has no such
 * column.
 *
 * Exact first. Twenty-seven entities expose two columns whose API names differ
 * only in case -- Insdate beside Ins_Date -- and a case-insensitive lookup
 * picks between them at random.
 */
function resolveField(entity, raw) {
  const name = String(raw || '');
  if (!name) {
    return null;
  }

  // Some pages qualify a field with its package -- `Cash.ordId`.
  const bare = name.includes('.') ? name.split('.').pop() : name;

  const exact = entity.fields.find((f) => f.Field === bare);
  if (exact) {
    return exact;
  }
  return entity.fields.find((f) => String(f.Field).toLowerCase() === bare.toLowerCase()) || null;
}

/**
 * `PhFC_*`, the component constants a query field declares itself with, as the
 * input names this project uses. Ordinals from PhConst.js.
 *
 * `PhFC_Empty` (7) is a spacer in a two-column card and names no column, so it
 * never reaches here.
 */
const COMPONENT_INPUT = {
  0: 'text',
  1: 'select',
  2: 'number',
  3: 'date',
  4: 'autocomplete',
  5: 'checkbox',
  6: 'radio',
  8: 'datetime'
};

/**
 * How a field is entered, when the entity cannot imply it.
 *
 * Almost always it can: a reference column carries a relation and is picked
 * from a list, a DATE is a date, a NUMBER is a number. So this answers null for
 * most fields, and the derivation in `presentation/screens.js` -- the one
 * definition of it -- decides at render time.
 *
 * Two things are not derivable and are taken from the page:
 *
 *   Which kind of picker a reference gets. `Clnc_Specials` has twelve rows and
 *   is a select; `Copy_Users` has thousands and is searched. PhForm renders the
 *   second when a field declares an element for the chosen row's label.
 *
 *   A component the page states outright. `aQFields` carries `component:
 *   PhFC_Text`, which is a declaration rather than an inference and outranks
 *   what the column type suggests.
 *
 * An `options` array is deliberately not read. It looked like the signal for a
 * select and is not: pages carry `options: []` as boilerplate on free-text
 * columns -- `Fre_Lfr_SalesContracts.descr` and `.rem` both do, while declaring
 * the same columns `PhFC_Text` in their search card -- and a real options array
 * is a runtime lookup that is empty here too. The two are indistinguishable by
 * value, and reading them made 123 text columns into sourceless selects.
 *
 * @param {Object} field The page's declaration
 * @param {Object} meta The entity's column
 * @returns {string|null} The input to force, or null to let the entity decide
 */
function inputFor(field, meta) {
  if (field.rElement || field.autoCompleteApi || field.autoComplete) {
    return 'autocomplete';
  }

  const stated = COMPONENT_INPUT[field.component];
  if (stated && meta && stated !== derivedInput(meta)) {
    return stated;
  }

  return null;
}

/** The autocomplete endpoint a field declares, however it spells it. */
function endpointFor(field) {
  const declared = field.autoCompleteApi
    || (field.autoComplete && (field.autoComplete.acUrl || field.autoComplete.url))
    || null;
  return typeof declared === 'string' && declared ? declared : null;
}

/** True for the several spellings the source uses for "yes". */
function isTrue(value) {
  return value === true || String(value).toLowerCase() === 'true';
}

/**
 * Converts one `aFields` entry -- the entry form.
 *
 * @returns {Object|null}
 */
function formField(raw, entity) {
  const meta = resolveField(entity, raw.field);
  if (!meta) {
    return null;
  }

  const field = { name: meta.Field };

  // No label is how the Java form declares a field it submits but never shows:
  // `{element: 'fldId', field: 'id', defValue: '0'}`.
  const label = typeof raw.label === 'string' ? raw.label.trim() : '';
  if (label) {
    field.labelKey = label;
  } else {
    field.hidden = true;
  }

  const input = inputFor(raw, meta);
  if (input) {
    field.input = input;
  }

  const endpoint = endpointFor(raw);
  if (endpoint) {
    field.endpoint = endpoint;
  }

  // The list column width, which is presentation and not in any schema. A
  // stubbed value is a string only by accident, so the shape is checked.
  if (typeof raw.tableWidth === 'string' && /^\d/.test(raw.tableWidth)) {
    field.width = raw.tableWidth;
  }

  if (isTrue(raw.isReadOnly) || isTrue(raw.readOnly)) {
    field.readOnly = true;
  }

  return field;
}

/**
 * Converts one searchable field -- `aQFields`, or a query card's field list.
 *
 * @returns {Object|null}
 */
function searchField(raw, entity, tokens) {
  const meta = resolveField(entity, raw.field);
  if (!meta) {
    return null;
  }

  const field = { name: meta.Field };

  const label = typeof raw.label === 'string' ? raw.label.trim() : '';
  if (label) {
    field.labelKey = label;
  }

  const input = inputFor(raw, meta);
  if (input) {
    field.input = input;
  }

  const endpoint = endpointFor(raw);
  if (endpoint) {
    field.endpoint = endpoint;
  }

  // Declared as ordinals, translated through the table they index, then
  // narrowed to what this column's type permits. The two disagree wherever a
  // page offered a text operator on a number.
  const allowed = operatorsFor(meta);
  const declared = Array.isArray(raw.aOpers) ? raw.aOpers : [];
  const operators = declared
    .map((n) => tokens[n])
    .filter((token) => token && allowed.includes(token));

  if (operators.length > 0) {
    field.operators = operators;
  }

  return field;
}

/** Every field of every conditions card a query page declares. */
function conditionCards(options) {
  const cards = [];

  if (options && Array.isArray(options.cards)) {
    // PhsQuery: a list of cards, the conditions one identified by its type.
    // PHS_QRY_CARD_CONDITIONS is 1.
    for (const card of options.cards) {
      if (card && card.cardType === 1 && Array.isArray(card.fields)) {
        cards.push(card.fields);
      }
    }
  }

  // PhQForm: one named card, whose fields sit under `body`.
  const named = options && (options.conditonCard || options.conditionCard);
  if (named) {
    const fields = (named.body && named.body.fields) || named.fields;
    if (Array.isArray(fields)) {
      cards.push(fields);
    }
  }

  return cards.flat();
}

/**
 * Converts one page into a program screen.
 *
 * @returns {{screen: Object, dropped: string[]}|null}
 */
function convert(page, tokens) {
  const resolved = resolveEntity(page.api);
  if (!resolved) {
    return null;
  }

  const { key, entity } = resolved;
  const dropped = [];

  const take = (list, make) => {
    const out = [];
    for (const raw of list) {
      if (!raw || typeof raw !== 'object' || !raw.field) {
        continue;
      }
      const converted = make(raw);
      if (converted) {
        out.push(converted);
      } else {
        dropped.push(String(raw.field));
      }
    }
    return out;
  };

  const form = take(page.fields || [], (raw) => formField(raw, entity));
  const search = take(
    [...(page.qFields || []), ...conditionCards(page.options)],
    (raw) => searchField(raw, entity, tokens)
  );

  // A form field's autocomplete endpoint is declared in the JSP markup rather
  // than in `aFields`, so it does not survive reading the script. The same
  // page's search card names it for the same column -- `userId` is searched
  // through /UC/Cpy/Users/Autocomplete -- so it is taken from there rather than
  // guessed. Only where the form itself did not carry one.
  const searched = new Map(search.filter(f => f.endpoint).map(f => [f.name, f.endpoint]));
  for (const field of form) {
    if (field.input === 'autocomplete' && !field.endpoint && searched.has(field.name)) {
      field.endpoint = searched.get(field.name);
    }
  }

  if (form.length === 0 && search.length === 0) {
    return null;
  }

  const screen = {
    version: '1.0',
    kind: page.kind === 'form' ? 'form' : 'query',
    program: page.program,
    entity: key
  };

  if (form.length > 0) {
    screen.form = { fields: form };
  }
  if (search.length > 0) {
    screen.search = { fields: search };
  }

  return { screen, dropped };
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

/** Every page script under an assets directory, with its program path. */
function pageScripts(assets) {
  const dir = path.join(assets, 'js', 'pages');
  const out = [];

  const walk = (at) => {
    for (const entry of fs.readdirSync(at, { withFileTypes: true })) {
      const full = path.join(at, entry.name);
      if (entry.isDirectory()) {
        walk(full);
      } else if (entry.name.endsWith('.js')) {
        out.push({
          file: full,
          program: path.relative(dir, full).split(path.sep).join('/').replace(/\.js$/, '')
        });
      }
    }
  };

  walk(dir);
  return out.sort((a, b) => a.program.localeCompare(b.program));
}

function main() {
  const assets = args.from;
  if (!assets || !fs.existsSync(path.join(assets || '', 'js', 'pages'))) {
    console.error('  --from <PhsApp/web/assets> is required and must hold js/pages.');
    process.exitCode = 1;
    return;
  }

  const constantsPath = path.join(assets, 'plugins', 'phsoft', 'PhConst.js');
  if (!fs.existsSync(constantsPath)) {
    console.error(`  PhConst.js not found at ${constantsPath}`);
    process.exitCode = 1;
    return;
  }

  const tokens = operatorTokens(constantsPath);
  mainApp.loadMetadata([path.join(ROOT, 'resources', 'modules')]);

  const only = typeof args.only === 'string' ? args.only.toLowerCase() : null;

  let read = 0;
  let declared = 0;
  let converted = 0;
  let noEntity = 0;
  let nothing = 0;
  let formFields = 0;
  let searchFields = 0;
  let droppedFields = 0;
  const written = [];
  const unresolved = [];

  for (const { file, program } of pageScripts(assets)) {
    if (only && program.toLowerCase() !== only) {
      continue;
    }
    read++;

    const raw = readScreen(file, constantsPath);
    const api = raw.url && raw.url.Api;
    if (!api && raw.fields.length === 0 && raw.qFields.length === 0) {
      nothing++;
      continue;
    }
    declared++;

    const result = convert({ ...raw, api, program }, tokens);
    if (!result) {
      if (!resolveEntity(api)) {
        noEntity++;
        unresolved.push(`${program} -> ${api || '(no endpoint)'}`);
      } else {
        nothing++;
      }
      continue;
    }

    const { screen, dropped } = result;
    formFields += screen.form ? screen.form.fields.length : 0;
    searchFields += screen.search ? screen.search.fields.length : 0;
    droppedFields += dropped.length;

    const dest = path.join(PROGRAMS, `${program}.json`);
    if (apply) {
      fs.mkdirSync(path.dirname(dest), { recursive: true });
      fs.writeFileSync(dest, `${JSON.stringify(screen, null, 2)}\n`, 'utf8');
    }

    converted++;
    written.push(path.relative(ROOT, dest).split(path.sep).join('/'));
  }

  console.log(`  page scripts read    : ${read}`);
  console.log(`  declaring a screen   : ${declared}`);
  console.log(`  ${apply ? 'written' : 'would write'}              : ${converted}`);
  console.log(`  entity not registered: ${noEntity}`);
  console.log(`  no screen to recover : ${nothing}`);
  console.log(`  form fields          : ${formFields}`);
  console.log(`  search fields        : ${searchFields}`);
  console.log(`  fields dropped       : ${droppedFields}   (column not on the entity)`);

  for (const w of written.slice(0, 8)) {
    console.log(`      ${w}`);
  }
  if (written.length > 8) {
    console.log(`      ... and ${written.length - 8} more`);
  }

  if (unresolved.length) {
    console.log('\n  unresolved endpoints (first 8):');
    for (const u of unresolved.slice(0, 8)) {
      console.log(`      ${u}`);
    }
  }

  if (!apply) {
    console.log('\n  Dry run. Re-run with --apply to write.');
  }
}

main();
