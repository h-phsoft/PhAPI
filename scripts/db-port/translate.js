/* global process, __dirname */

/**
 * Ports the Oracle scripts under db/01-Admin and db/01-Copy to MySQL and
 * PostgreSQL.
 *
 *   node scripts/db-port/translate.js
 *   node scripts/db-port/translate.js --only=mysql
 *
 * Synonyms become the table names. Oracle defines a table under one name and a
 * synonym over it, and the application, the foreign keys and the seed data all
 * reference the synonym. Neither MySQL nor PostgreSQL has synonyms, and a
 * foreign key cannot reference a view, so emitting the synonym as a view would
 * break every constraint. Renaming the object to its synonym keeps all existing
 * references valid and matches how the metadata layer already addresses tables.
 *
 * Output goes to db/mysql/ and db/postgres/, mirroring the source layout, plus
 * PORTING-REPORT.md listing everything that needs a human.
 */

const fs = require('fs');
const path = require('path');

const { splitStatements, classify, objectName, parseSynonym } = require('./lib/parse');
const {
  renameIdentifiers,
  isSequenceOnlyTrigger,
  extractSequenceBinding,
  extractForeignKeys,
  forceIdIntegers
} = require('./lib/rewrite');
const mysql = require('./lib/mysql');
const postgres = require('./lib/postgres');

const DB_DIR = path.join(__dirname, '..', '..', 'db');

/**
 * Each source folder becomes its own database: 01-Admin holds the tenant
 * registry (Phs_Cpy and friends) that the API reads to resolve a copy, and
 * 01-Copy is the per-tenant schema, materialised here as a demo tenant.
 */
const DATABASES = {
  '01-Admin': 'phsoftme_erp_admin',
  '01-Copy': 'phsoftme_erp_demo'
};

const SOURCE_DIRS = Object.keys(DATABASES);

const only = (process.argv.find((a) => a.startsWith('--only=')) || '').split('=')[1];
const targets = [mysql, postgres].filter((d) => !only || d.NAME === only);

/** @returns {string[]} .SQL files in a source directory, in load order. */
function sqlFiles(dir) {
  const full = path.join(DB_DIR, dir);
  if (!fs.existsSync(full)) {
    return [];
  }
  return fs.readdirSync(full).filter((f) => /\.sql$/i.test(f)).sort();
}

/**
 * Collects the synonyms declared in one source folder.
 *
 * The map is built per folder, never across folders. Each folder becomes its
 * own database, and the same base table can carry a different synonym in each:
 * Phs_Code_Status is Phs_Status in the admin schema but Phs_Cod_Status in the
 * tenant schema. A shared map would rename the tenant's table to the admin's
 * name and leave every reference to it dangling.
 *
 * @param {string} dir Source folder name
 * @returns {{renameMap: Map<string,string>, extraViews: Array, conflicts: Array}}
 */
function buildSynonymMap(dir) {
  const targetToSynonyms = new Map(); // lowercased base -> [synonym names]
  const seenSynonyms = new Map();     // lowercased synonym -> base

  for (const file of sqlFiles(dir)) {
    const source = fs.readFileSync(path.join(DB_DIR, dir, file), 'utf8');

    for (const statement of splitStatements(source)) {
      if (classify(statement.text) !== 'synonym') {
        continue;
      }
      const parsed = parseSynonym(statement.text);
      if (!parsed) {
        continue;
      }

      const baseKey = parsed.target.toLowerCase();
      if (!targetToSynonyms.has(baseKey)) {
        targetToSynonyms.set(baseKey, []);
      }
      if (!targetToSynonyms.get(baseKey).includes(parsed.name)) {
        targetToSynonyms.get(baseKey).push(parsed.name);
      }
      seenSynonyms.set(parsed.name.toLowerCase(), parsed.target);
    }
  }

  const renameMap = new Map();
  const extraViews = [];
  const conflicts = [];

  for (const [baseKey, synonyms] of targetToSynonyms.entries()) {
    // A synonym pointing at another synonym is not a table rename.
    if (seenSynonyms.has(baseKey)) {
      continue;
    }

    const [canonical, ...aliases] = synonyms;
    renameMap.set(baseKey, canonical);

    if (aliases.length > 0) {
      // Extra synonyms over the same table stay as views: nothing can
      // foreign-key them, so a view is safe and preserves the alias.
      conflicts.push({ base: baseKey, canonical, aliases });
      aliases.forEach((alias) => extraViews.push({ alias, table: canonical }));
    }
  }

  return { renameMap, extraViews, conflicts };
}

/** Renders one statement for a dialect, or returns a skip/manual marker. */
function renderStatement(dialect, kind, sql, name) {
  try {
    switch (kind) {
      case 'table': {
        // Key columns are widened first, while the inline FOREIGN KEY clauses
        // are still present: that is what tells forceIdIntegers which columns
        // are key sources. Removing them first would hide Ins_User and friends
        // and leave them too narrow for the key they point at.
        const typed = forceIdIntegers(sql);

        // Foreign keys are then lifted out and applied once every table exists,
        // so a reference to a table created in a later file cannot fail.
        const { sql: withoutFks, foreignKeys } = extractForeignKeys(typed, name);
        return { sql: dialect.translateTable(withoutFks), foreignKeys };
      }
      case 'sequence': {
        const out = dialect.translateSequence(sql, name);
        // MySQL returns null: AUTO_INCREMENT replaces sequences entirely.
        return out ? { sql: out } : { skip: true, note: 'sequence replaced by AUTO_INCREMENT' };
      }
      case 'view': {
        // Oracle's (+) outer join has no equivalent that a find-and-replace can
        // produce: converting it means restructuring the FROM clause into an
        // explicit LEFT JOIN, which depends on the whole predicate list.
        if (/\(\s*\+\s*\)/.test(sql)) {
          return { manual: 'view uses the Oracle (+) outer join operator; rewrite as an explicit LEFT JOIN' };
        }
        return { sql: dialect.translateView(sql) };
      }
      case 'dml': return { sql: dialect.translateDml(sql) };
      case 'index': return { sql: dialect.translateIndex(sql) };
      case 'alter': return { sql: dialect.translateAlter(sql) };
      case 'trigger': {
        if (dialect.dropSequenceOnlyTriggers && isSequenceOnlyTrigger(sql)) {
          return { skip: true, note: 'trigger only assigned Id from a sequence' };
        }
        const out = dialect.translateTrigger(sql, name);
        return out ? { sql: out, review: true } : { manual: 'trigger could not be parsed' };
      }
      case 'synonym': return { skip: true };
      case 'session': return { skip: true };
      case 'comment': return { sql: `-- ${sql.replace(/\n/g, '\n-- ')}` };
      default:
        return { manual: `${kind} has no automatic equivalent` };
    }
  } catch (err) {
    return { manual: `translation error: ${err.message}` };
  }
}

/** Wraps untranslatable original SQL as a commented block with a TODO. */
function manualBlock(reason, sql, line) {
  const commented = sql.split('\n').map((l) => `--   ${l}`).join('\n');
  return `-- TODO(port): ${reason} (source line ${line}).\n-- Original Oracle statement:\n${commented}`;
}

function main() {
  console.log('Building synonym maps (one per database)...');

  const maps = {};
  let renamedTotal = 0;
  const allConflicts = [];

  for (const dir of SOURCE_DIRS) {
    maps[dir] = buildSynonymMap(dir);
    renamedTotal += maps[dir].renameMap.size;
    maps[dir].conflicts.forEach((c) => allConflicts.push({ ...c, dir }));
    console.log(`  ${dir} -> ${DATABASES[dir]}: ${maps[dir].renameMap.size} tables renamed`);
  }

  if (allConflicts.length > 0) {
    console.log(`  ${allConflicts.length} table(s) have extra synonyms within one database, emitted as views`);
  }

  const report = {
    renamed: renamedTotal,
    databases: DATABASES,
    conflicts: allConflicts,
    perDialect: {}
  };

  for (const dialect of targets) {
    console.log(`\nTranslating for ${dialect.NAME}...`);

    const outRoot = path.join(DB_DIR, dialect.NAME);
    fs.mkdirSync(outRoot, { recursive: true });
    fs.writeFileSync(
      path.join(outRoot, '0000_create_databases.sql'),
      dialect.createDatabases(Object.values(DATABASES)),
      'utf8'
    );
    fs.writeFileSync(path.join(outRoot, '0001_prelude.sql'), dialect.PRELUDE, 'utf8');

    const stats = { files: 0, statements: 0, translated: 0, manual: 0, review: 0, dropped: 0, manualItems: [] };
    const sequenceBindings = new Map();

    for (const dir of SOURCE_DIRS) {
      const outDir = path.join(outRoot, dir);
      fs.mkdirSync(outDir, { recursive: true });

      // Each database resolves synonyms with its own map.
      const { renameMap, extraViews } = maps[dir];
      const deferredForeignKeys = [];

      for (const file of sqlFiles(dir)) {
        const source = fs.readFileSync(path.join(DB_DIR, dir, file), 'utf8');
        const statements = splitStatements(source);
        const chunks = [];

        chunks.push(`-- Ported from Oracle: db/${dir}/${file}`);
        chunks.push(`-- Generated by scripts/db-port/translate.js for ${dialect.NAME}.`);
        chunks.push('-- Tables carry their Oracle synonym name; see PORTING-REPORT.md.');
        chunks.push(dialect.useDatabase(DATABASES[dir]));

        for (const statement of statements) {
          const kind = classify(statement.text);
          stats.statements++;

          // Rename base tables to their synonym before anything else, so every
          // reference in DDL, views, triggers and seed data lines up.
          const renamed = renameIdentifiers(statement.text, renameMap);
          const name = objectName(renamed, kind);

          if (dialect.unsupported.includes(kind)) {
            chunks.push(manualBlock(`${kind} is not supported on ${dialect.NAME}`, statement.text, statement.line));
            stats.manual++;
            stats.manualItems.push({ file: `${dir}/${file}`, line: statement.line, kind });
            continue;
          }

          // Remember which sequence feeds which table so the sequences can be
          // resynchronised after the seed data inserts explicit ids.
          if (kind === 'trigger') {
            const binding = extractSequenceBinding(renamed);
            if (binding) {
              sequenceBindings.set(binding.sequence.toLowerCase(), binding);
            }
          }

          const result = renderStatement(dialect, kind, renamed, name);

          if (result.skip) {
            if (result.note) {
              stats.dropped++;
            }
            continue;
          }
          if (result.manual) {
            chunks.push(manualBlock(result.manual, statement.text, statement.line));
            stats.manual++;
            stats.manualItems.push({ file: `${dir}/${file}`, line: statement.line, kind });
            continue;
          }

          if (result.review) {
            chunks.push(`-- REVIEW(port): trigger translated mechanically; verify before use.`);
            stats.review++;
          }
          if (result.foreignKeys && result.foreignKeys.length > 0) {
            deferredForeignKeys.push(...result.foreignKeys);
          }
          chunks.push(result.sql);
          stats.translated++;
        }

        let content = `${chunks.join('\n\n')}\n`;
        if (typeof dialect.postProcess === 'function') {
          content = dialect.postProcess(content);
        }

        fs.writeFileSync(path.join(outDir, file.replace(/\.SQL$/i, '.sql')), content, 'utf8');
        stats.files++;
      }

      // Applied once every table in this database exists, and after the seed
      // data, so neither table order nor row order can break a constraint.
      if (deferredForeignKeys.length > 0) {
        fs.writeFileSync(
          path.join(outDir, 'zzy_foreign_keys.sql'),
          `-- Foreign keys for ${DATABASES[dir]}, lifted out of their CREATE TABLE.\n` +
          `-- The Oracle scripts are not in dependency order, so declaring these\n` +
          `-- inline made table creation depend on file order. Run this last.\n` +
          `-- ${deferredForeignKeys.length} constraints.\n\n` +
          `${dialect.useDatabase(DATABASES[dir])}\n${deferredForeignKeys.join('\n')}\n`,
          'utf8'
        );
        stats.deferredFks = deferredForeignKeys.length;
      }

      // Aliases that lost the rename race become views over the canonical
      // table, written into the database that declared them.
      if (extraViews.length > 0) {
        const aliasSql = extraViews
          .map(({ alias, table }) => `CREATE OR REPLACE VIEW ${alias} AS SELECT * FROM ${table};`)
          .join('\n');

        fs.writeFileSync(
          path.join(outDir, 'zzz_synonym_aliases.sql'),
          `-- Additional Oracle synonyms over an already-renamed table in ${DATABASES[dir]}.\n` +
          `-- Emitted as views: nothing foreign-keys them, so a view is safe.\n\n` +
          `${dialect.useDatabase(DATABASES[dir])}\n${aliasSql}\n`,
          'utf8'
        );
      }
    }

    // Sequences start at 1, but the seed data inserts explicit ids without
    // advancing them, so the first generated id would collide.
    if (dialect.NAME === 'postgres' && sequenceBindings.size > 0) {
      const resync = [...sequenceBindings.values()]
        .sort((a, b) => a.sequence.localeCompare(b.sequence))
        .map(({ sequence, table }) =>
          `SELECT setval('${sequence}', COALESCE((SELECT MAX(Id) FROM ${table}), 0) + 1, false);`)
        .join('\n');

      fs.writeFileSync(
        path.join(outRoot, '9998_resync_sequences.sql'),
        '-- Run AFTER loading the seed data.\n' +
        '-- Inserting an explicit id does not advance a PostgreSQL sequence, so each\n' +
        '-- one is moved past the highest id its table already holds.\n' +
        `-- ${sequenceBindings.size} sequence/table pairs, derived from the Oracle triggers.\n\n` +
        `${dialect.useDatabase(DATABASES['01-Copy'])}\n${resync}\n`,
        'utf8'
      );
    }

    report.perDialect[dialect.NAME] = stats;
    console.log(`  ${stats.files} files, ${stats.statements} statements`);
    console.log(`  ${stats.translated} translated, ${stats.review} need review, ${stats.manual} need manual porting`);
  }

  writeReport(report);
  console.log('\nWrote db/PORTING-REPORT.md');
}

function writeReport(report) {
  const lines = [];
  lines.push('# Oracle port: MySQL and PostgreSQL');
  lines.push('');
  lines.push('Generated by `scripts/db-port/translate.js`. Re-run it after changing the');
  lines.push('Oracle scripts under `db/01-Admin` or `db/01-Copy`; the output directories are');
  lines.push('overwritten, so do not hand-edit them without moving the file out first.');
  lines.push('');
  lines.push('## Synonyms as table names');
  lines.push('');
  lines.push(`${report.renamed} tables are emitted under their Oracle synonym name.`);
  lines.push('');
  lines.push('Oracle defines a table under one name and a synonym over it, and the foreign');
  lines.push('keys, views and seed data all reference the synonym. Neither target has');
  lines.push('synonyms, and neither allows a foreign key to reference a view, so emitting');
  lines.push('synonyms as views would break every constraint that uses one. Renaming the');
  lines.push('table to its synonym keeps all existing references valid.');
  lines.push('');

  if (report.conflicts.length > 0) {
    lines.push(`### Tables with more than one synonym (${report.conflicts.length})`);
    lines.push('');
    lines.push('The first synonym becomes the table name; the rest become views.');
    lines.push('');
    lines.push('| Oracle table | Table name used | Also aliased as |');
    lines.push('| --- | --- | --- |');
    report.conflicts.forEach(({ base, canonical, aliases }) => {
      lines.push(`| ${base} | ${canonical} | ${aliases.join(', ')} |`);
    });
    lines.push('');
  }

  for (const [name, stats] of Object.entries(report.perDialect)) {
    lines.push(`## ${name}`);
    lines.push('');
    lines.push(`- Files written: ${stats.files}`);
    lines.push(`- Statements: ${stats.statements}`);
    lines.push(`- Translated: ${stats.translated}`);
    lines.push(`- Translated but needing review: ${stats.review}`);
    lines.push(`- Needing manual porting: ${stats.manual}`);
    lines.push('');

    if (stats.manualItems.length > 0) {
      const byKind = {};
      stats.manualItems.forEach((item) => {
        byKind[item.kind] = (byKind[item.kind] || 0) + 1;
      });

      lines.push('### Needs manual porting, by kind');
      lines.push('');
      lines.push('| Kind | Count |');
      lines.push('| --- | --- |');
      Object.entries(byKind)
        .sort((a, b) => b[1] - a[1])
        .forEach(([kind, count]) => lines.push(`| ${kind} | ${count} |`));
      lines.push('');
      lines.push('Each one is left in place in the output as a commented `TODO(port)` block');
      lines.push('containing the original Oracle statement.');
      lines.push('');
    }
  }

  fs.writeFileSync(path.join(DB_DIR, 'PORTING-REPORT.md'), `${lines.join('\n')}\n`, 'utf8');
}

main();
