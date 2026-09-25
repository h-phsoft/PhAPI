#!/usr/bin/env node
/**
 * Brings the entity models back into line with the live schema, without
 * rewriting them.
 *
 * M1 says `resources/modules` is generated from the database and is
 * authoritative for what a column is. M2 says the generator never rewrites an
 * existing file, because hand-set annotations -- `isLabel`, corrected display
 * fields, curated children -- cannot be recovered from a schema. Both are
 * right, and the gap between them is this: a table that grew a column after its
 * model was written has no way to say so.
 *
 * Measured on the `Demo` copy, the gap is not small. 133 models describe fewer
 * columns than their table has -- 1579 columns in all -- and because every
 * SELECT and INSERT is built from the model's field list, not one of them can
 * be read or written. `Emp_Employee` is described with 15 of its 87. A further
 * 133 columns record the wrong nullability, which decides whether a generated
 * screen marks a field required.
 *
 * So this is a merge, never a regeneration:
 *
 *   a column the model lacks is appended, shaped by the same `buildModel` the
 *   generator uses;
 *   a column whose `isNull` disagrees with the database has that one property
 *   corrected;
 *   a column with no `Default` at all takes the database's, where the database
 *   has one -- but a `Default` already written is never overwritten, because a
 *   model-level default is a decision and a schema cannot tell one from a gap;
 *   every other property of every existing field is left exactly as it was.
 *
 * A column the model has and the table does not is reported and **not
 * removed**. The models are shared by 21 copies and a column absent here may be
 * present there; deleting it would break the copy that has it.
 *
 * V2 -- hash the tree before and after, and report what moved:
 *
 *   node scripts/reconcileSchema.js --tenant Demo
 *   node scripts/reconcileSchema.js --tenant Demo --apply
 *   node scripts/reconcileSchema.js --tenant Demo --only Emp_Employee
 *
 * Listing the columns a model names and its table does not have, checked
 * against a second copy, written to reconcile-missing-<tenant>.csv:
 *
 *   node scripts/reconcileSchema.js --tenant Demo --missing --compare NSCC
 */

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const ROOT = path.join(__dirname, '..');
const MODULES = path.join(ROOT, 'resources', 'modules');

const connectionPool = require('../core/connectionPool');
const { readSchemaContext, buildModel } = require('./generateFromSchema');

// ---------------------------------------------------------------------------
// Command line
// ---------------------------------------------------------------------------

function readArg(name, fallback) {
  const prefix = `--${name}=`;
  const flag = process.argv.indexOf(`--${name}`);
  const joined = process.argv.find((arg) => arg.startsWith(prefix));

  if (joined) {
    return joined.slice(prefix.length);
  }
  if (flag !== -1 && process.argv[flag + 1] && !process.argv[flag + 1].startsWith('--')) {
    return process.argv[flag + 1];
  }
  return fallback;
}

const tenant = readArg('tenant', process.env.TEST_TENANT || 'Demo');
const only = (readArg('only', '') || '').toLowerCase();
const apply = process.argv.includes('--apply');
const missing = process.argv.includes('--missing');
const compare = readArg('compare', '');

// ---------------------------------------------------------------------------
// The files
// ---------------------------------------------------------------------------

/** Every model file, with its parsed contents and its hash. */
function readModels() {
  const out = [];

  for (const pkg of fs.readdirSync(MODULES)) {
    const dir = path.join(MODULES, pkg);
    if (!fs.statSync(dir).isDirectory()) {
      continue;
    }
    for (const file of fs.readdirSync(dir)) {
      if (!file.endsWith('.json')) {
        continue;
      }
      const full = path.join(dir, file);
      const text = fs.readFileSync(full, 'utf8');
      try {
        out.push({
          rel: `${pkg}/${file}`,
          full,
          text,
          hash: crypto.createHash('sha256').update(text).digest('hex'),
          model: JSON.parse(text)
        });
      } catch {
        // Unparseable describes nothing and is left alone.
      }
    }
  }

  return out;
}

/** The two names that count as an API field name across the file formats. */
function fieldNameOf(field) {
  return String(field.Field || field.field || field.Name || '');
}

/** The database column a field maps to. */
function columnNameOf(field) {
  return String(field.Name || field.Column || field.Field || '');
}

/**
 * Whether two field entries are the same in every respect but the two this
 * merge is allowed to touch.
 *
 * The comparison a reconciliation has to survive: it is what proves the merge
 * changed nothing it did not mean to (V2). `Default` is allowed through only in
 * one direction, which is checked separately below.
 */
function sameExceptSchemaFacts(before, after) {
  const strip = (field) => {
    const copy = { ...field };
    delete copy.isNull;
    delete copy.Default;
    return JSON.stringify(copy);
  };
  return strip(before) === strip(after);
}

/** True when a `Default` was filled in rather than overwritten. */
function defaultOnlyFilled(before, after) {
  const was = before.Default === undefined || before.Default === null ? '' : String(before.Default);
  const is = after.Default === undefined || after.Default === null ? '' : String(after.Default);
  return was === is || was === '';
}

// ---------------------------------------------------------------------------
// The merge
// ---------------------------------------------------------------------------

/**
 * One model, reconciled against its table.
 *
 * @returns {{model: Object, added: string[], corrected: string[], orphaned: string[]}|null}
 *   null when the table is not in this copy, or nothing needs doing
 */
function reconcile(entry, ctx) {
  const model = entry.model;
  const tableName = model.tableName || model.Name || model.Table || model.Synonym;
  if (!tableName) {
    return null;
  }

  const table = ctx.tableByName.get(String(tableName).toLowerCase());
  if (!table) {
    // A table this copy does not have. Another might; nothing to say.
    return null;
  }

  const fields = model.fields || model.Columns || [];
  const key = model.fields ? 'fields' : 'Columns';

  // Indexed by column name, because that is what a schema and a model agree
  // on. The API field name is derived from it and two models spell it
  // differently.
  const byColumn = new Map(fields.map((f) => [columnNameOf(f).toLowerCase(), f]));

  const fresh = buildModel(table, ctx);
  const freshByColumn = new Map(fresh.fields.map((f) => [columnNameOf(f).toLowerCase(), f]));

  const added = [];
  const corrected = [];
  const defaulted = [];
  const orphaned = [];
  const shadowed = [];

  // The existing order is kept exactly and new columns are appended.
  //
  // Reordering into the table's own column order was the first attempt and made
  // every diff unreadable: a single insertion near the top shifts everything
  // after it, so correcting one nullability flag showed as 41 insertions and 41
  // deletions. The order decides nothing -- a SELECT aliases every column, so
  // nothing downstream reads by position -- and an unreviewable diff across 196
  // files is a real cost. Appending makes each diff exactly what was done.
  const merged = [];

  for (const field of fields) {
    const freshField = freshByColumn.get(columnNameOf(field).toLowerCase());

    if (!freshField) {
      // The model has it and the table does not. Kept: another copy may have
      // it, and deleting it would break that copy.
      merged.push(field);
      orphaned.push(fieldNameOf(field));
      continue;
    }

    // Nullability is the database's to state, always. A default is the
    // database's only where the model has none: 130 fields carry a default the
    // database does not have and 29 carry a different one, and both are
    // decisions someone made -- a schema cannot tell a deliberate default from
    // a gap, so it only fills the gaps. 367 of them.
    //
    // It matters because `validatePayload` reads `Default` to decide whether a
    // NOT NULL column still has to be supplied by the client. A blank there
    // makes the screen demand a value the database was going to provide.
    const patch = {};

    if (field.isNull !== freshField.isNull) {
      patch.isNull = freshField.isNull;
      corrected.push(`${fieldNameOf(field)} isNull ${field.isNull} -> ${freshField.isNull}`);
    }

    const mine = field.Default === undefined || field.Default === null ? '' : String(field.Default);
    const theirs = String(freshField.Default || '');
    if (mine === '' && theirs !== '') {
      patch.Default = theirs;
      defaulted.push(`${fieldNameOf(field)} = ${theirs}`);
    }

    merged.push(Object.keys(patch).length > 0 ? { ...field, ...patch } : field);
  }

  // A row is keyed by the API name, so two fields whose names differ only in
  // case are one field as far as a client is concerned and the second silently
  // shadows the first. Twenty-eight entities already do this and adding to it
  // would be trading a working column for a new one.
  //
  // `Fre_Lfr_Dbcr_Documents_View` is the case: it has JF_Cont_Rid and
  // JF_Contr_Id, which both become `jfContrId`. The view's other 207 columns
  // are still added; these two are declined and reported, because which of the
  // pair should keep the name is a decision about naming, not about schemas.
  const taken = new Set(fields.map((f) => fieldNameOf(f).toLowerCase()).filter(Boolean));

  for (const freshField of fresh.fields) {
    if (byColumn.has(columnNameOf(freshField).toLowerCase())) {
      continue;
    }

    const name = fieldNameOf(freshField).toLowerCase();
    if (taken.has(name)) {
      shadowed.push(`${fieldNameOf(freshField)} (${columnNameOf(freshField)})`);
      continue;
    }

    taken.add(name);
    merged.push(freshField);
    added.push(fieldNameOf(freshField));
  }

  if (added.length === 0 && corrected.length === 0
    && defaulted.length === 0 && shadowed.length === 0) {
    return null;
  }

  return {
    model: { ...model, [key]: merged },
    added,
    corrected,
    defaulted,
    orphaned,
    shadowed
  };
}

// ---------------------------------------------------------------------------
// The case collisions, before and after
// ---------------------------------------------------------------------------

/**
 * Models declaring two fields for one database column.
 *
 * Distinct from a case collision: these are the same column twice, which means
 * one of the two entries is dead -- a row is keyed by the API name, so whichever
 * the mapper writes last wins and the other never appears. Reported rather than
 * repaired: which of the two is the right one is not something a schema says.
 */
function duplicateColumns(models) {
  const out = [];

  for (const entry of models) {
    const fields = entry.model.fields || entry.model.Columns || [];
    const seen = new Map();

    for (const field of fields) {
      const column = columnNameOf(field).toLowerCase();
      if (!column) {
        continue;
      }
      seen.set(column, (seen.get(column) || 0) + 1);
    }

    for (const [column, n] of seen) {
      if (n > 1) {
        out.push(`${entry.rel}: ${column} declared ${n} times`);
      }
    }
  }

  return out;
}

/**
 * Entities exposing two columns whose API names differ only in case.
 *
 * A row is keyed by the API name, so one of each pair is silently lost on every
 * read. Twenty-seven entities already do this; adding columns can only make
 * more, so the count is reported before and after rather than discovered later.
 */
function caseCollisions(models) {
  const out = [];

  for (const entry of models) {
    const fields = entry.model.fields || entry.model.Columns || [];
    const byLower = new Map();

    for (const field of fields) {
      const name = fieldNameOf(field);
      if (!name) {
        continue;
      }
      const lower = name.toLowerCase();
      if (!byLower.has(lower)) {
        byLower.set(lower, new Set());
      }
      byLower.get(lower).add(name);
    }

    for (const [, spellings] of byLower) {
      if (spellings.size > 1) {
        out.push(`${entry.rel}: ${[...spellings].join(' / ')}`);
      }
    }
  }

  return out;
}

// ---------------------------------------------------------------------------
// The columns a model names and its table does not have
// ---------------------------------------------------------------------------

/**
 * Every column a model names that its table in this copy lacks. Counted apart
 * from `reconcile`, which reports a model only when it has something to write,
 * and so leaves out a model whose only fault is a column too many.
 *
 * @returns {{model: string, table: string, column: string, field: string}[]}
 */
function missingColumns(entries, ctx) {
  const out = [];

  for (const entry of entries) {
    const tableName = entry.model.tableName || entry.model.Name || entry.model.Table || entry.model.Synonym;
    const table = ctx.tableByName.get(String(tableName || '').toLowerCase());
    if (!table) {
      continue;
    }

    const has = new Set(table.columns.map((c) => String(c.name).toLowerCase()));
    for (const field of (entry.model.fields || entry.model.Columns || [])) {
      if (!has.has(columnNameOf(field).toLowerCase())) {
        out.push({ model: entry.rel, table: tableName, column: columnNameOf(field), field: fieldNameOf(field) });
      }
    }
  }

  return out;
}

/**
 * What a second copy says about a column the first lacks: present there (a
 * real per-copy difference), absent there too (almost certainly stale), or
 * no table to tell by.
 */
function verdictIn(ctx, row) {
  const table = ctx.tableByName.get(String(row.table).toLowerCase());
  if (!table) {
    return 'no table';
  }
  const present = table.columns.some((c) => String(c.name).toLowerCase() === row.column.toLowerCase());
  return present ? 'present' : 'absent';
}

async function reportMissing(entries, ctx) {
  const rows = missingColumns(entries, ctx);
  const other = compare ? await readSchemaContext(compare) : null;

  for (const row of rows) {
    row.other = other ? verdictIn(other, row) : '';
  }

  const header = ['model', 'table', 'column', 'field', ...(compare ? [`in ${compare}`] : [])];
  const csv = [header, ...rows.map((r) => [r.model, r.table, r.column, r.field, ...(compare ? [r.other] : [])])]
    .map((line) => line.join(','))
    .join('\n');
  const file = path.join(process.cwd(), `reconcile-missing-${tenant}.csv`);
  fs.writeFileSync(file, `${csv}\n`, 'utf8');

  console.log(`\n  columns a model names and the table lacks: ${rows.length}, across ${new Set(rows.map((r) => r.model)).size} models`);
  if (compare) {
    for (const verdict of ['present', 'absent', 'no table']) {
      console.log(`    ${compare} ${verdict.padEnd(9)}: ${rows.filter((r) => r.other === verdict).length}`);
    }
  }
  for (const r of rows) {
    console.log(`    ${r.model.padEnd(42)} ${r.column.padEnd(28)} ${r.other}`);
  }
  console.log(`\n  written to ${file}`);
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  console.log('--- Reconciling the entity models with the live schema ---');
  console.log(`  tenant: ${tenant}${apply ? '' : '   (report only)'}\n`);

  const ctx = await readSchemaContext(tenant);
  const before = readModels();

  console.log(`  model files            : ${before.length}`);
  console.log(`  tables in this copy    : ${ctx.tableByName.size}`);

  if (missing) {
    await reportMissing(before, ctx);
    return;
  }

  const collisionsBefore = caseCollisions(before);
  const duplicatesBefore = duplicateColumns(before);

  const results = [];
  let notInCopy = 0;

  for (const entry of before) {
    const tableName = entry.model.tableName || entry.model.Name || entry.model.Table || entry.model.Synonym;
    if (only && String(tableName).toLowerCase() !== only) {
      continue;
    }
    if (!ctx.tableByName.has(String(tableName || '').toLowerCase())) {
      notInCopy++;
      continue;
    }

    const result = reconcile(entry, ctx);
    if (result) {
      results.push({ entry, ...result });
    }
  }

  const columnsAdded = results.reduce((n, r) => n + r.added.length, 0);
  const nullsCorrected = results.reduce((n, r) => n + r.corrected.length, 0);
  const defaultsFilled = results.reduce((n, r) => n + r.defaulted.length, 0);
  const orphaned = results.reduce((n, r) => n + r.orphaned.length, 0);
  const shadowed = results.flatMap((r) => r.shadowed.map((f) => `${r.entry.rel}: ${f}`));

  console.log(`  described but not here : ${notInCopy}`);
  console.log(`  files needing a change : ${results.length}`);
  console.log(`    columns to add       : ${columnsAdded}`);
  console.log(`    nullability to fix   : ${nullsCorrected}`);
  console.log(`    defaults to fill in  : ${defaultsFilled}   (blank ones only; a written default is never replaced)`);
  console.log(`    model has, table has not : ${orphaned}   (kept -- another copy may have them)`);
  console.log(`    declined, would shadow   : ${shadowed.length}`);
  for (const line of shadowed.slice(0, 10)) {
    console.log(`        ${line}`);
  }

  if (!apply) {
    console.log('\n  the ten largest:');
    for (const r of [...results].sort((a, b) => b.added.length - a.added.length).slice(0, 10)) {
      console.log(`    ${r.entry.rel.padEnd(42)} +${String(r.added.length).padStart(3)} columns, ${r.corrected.length} nullability`);
    }
    console.log('\n  Report only. Re-run with --apply to write.');
    return;
  }

  // --- write -------------------------------------------------------------

  for (const r of results) {
    fs.writeFileSync(r.entry.full, `${JSON.stringify(r.model, null, 2)}\n`, 'utf8');
  }

  // --- prove it only changed what it meant to (V2) ------------------------

  const after = readModels();
  const afterByRel = new Map(after.map((e) => [e.rel, e]));
  const intended = new Set(results.map((r) => r.entry.rel));

  const unexpected = [];
  const damaged = [];

  for (const entry of before) {
    const now = afterByRel.get(entry.rel);
    if (!now) {
      unexpected.push(`${entry.rel} disappeared`);
      continue;
    }

    const changed = now.hash !== entry.hash;
    if (changed && !intended.has(entry.rel)) {
      unexpected.push(`${entry.rel} changed and was not meant to`);
      continue;
    }
    if (!changed) {
      continue;
    }

    // Every field that was there before is still there, and differs in nothing
    // but nullability.
    //
    // Compared position by position rather than through a map. Some models
    // carry two fields on one column -- Stor_Execute_Outbound_Master declares
    // Cont_Id twice, at precision 9 and 4 -- and a map keyed by column name
    // collapses them, so the first was compared against the second and reported
    // as damaged when nothing had touched it. The merge preserves order, so
    // position is the honest comparison.
    const wasFields = entry.model.fields || entry.model.Columns || [];
    const nowFields = now.model.fields || now.model.Columns || [];

    for (const [at, was] of wasFields.entries()) {
      const is = nowFields[at];
      if (!is || columnNameOf(is).toLowerCase() !== columnNameOf(was).toLowerCase()) {
        damaged.push(`${entry.rel}.${fieldNameOf(was)} moved or was removed`);
      } else if (!sameExceptSchemaFacts(was, is)) {
        damaged.push(`${entry.rel}.${fieldNameOf(was)} changed beyond its nullability and default`);
      } else if (!defaultOnlyFilled(was, is)) {
        damaged.push(`${entry.rel}.${fieldNameOf(was)} had its default overwritten`);
      }
    }

    // And everything outside the field list is untouched.
    const shell = (model) => {
      const copy = { ...model };
      delete copy.fields;
      delete copy.Columns;
      return JSON.stringify(copy);
    };
    if (shell(entry.model) !== shell(now.model)) {
      damaged.push(`${entry.rel} changed outside its field list`);
    }
  }

  const collisionsAfter = caseCollisions(after);
  const newCollisions = collisionsAfter.filter((c) => !collisionsBefore.includes(c));
  const duplicatesAfter = duplicateColumns(after);
  const newDuplicates = duplicatesAfter.filter((d) => !duplicatesBefore.includes(d));

  console.log(`\n  files written          : ${results.length}`);
  console.log(`  files changed          : ${before.filter((e) => afterByRel.get(e.rel).hash !== e.hash).length}`);
  console.log(`  changed unexpectedly   : ${unexpected.length}`);
  console.log(`  existing fields damaged: ${damaged.length}`);
  console.log(`  case collisions        : ${collisionsBefore.length} before, ${collisionsAfter.length} after (+${newCollisions.length})`);
  console.log(`  duplicated columns     : ${duplicatesBefore.length} before, ${duplicatesAfter.length} after (+${newDuplicates.length})`);

  for (const line of [...unexpected, ...damaged].slice(0, 10)) {
    console.log(`      ${line}`);
  }
  for (const line of newCollisions.slice(0, 10)) {
    console.log(`      new collision: ${line}`);
  }
  for (const line of newDuplicates.slice(0, 10)) {
    console.log(`      new duplicate: ${line}`);
  }

  if (unexpected.length > 0 || damaged.length > 0) {
    process.exitCode = 1;
  }
}

main()
  .then(() => (connectionPool.closeAll ? connectionPool.closeAll() : null))
  .then(() => process.exit(process.exitCode || 0))
  .catch((err) => {
    console.error(`\n  Failed: ${err.message}`);
    console.error(err.stack);
    process.exit(1);
  });
