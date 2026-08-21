/* global process, __dirname */

/**
 * Parses the generated MySQL and PostgreSQL scripts to catch syntax errors the
 * translator may have introduced.
 *
 *   node scripts/db-port/validate.js
 *   node scripts/db-port/validate.js --only=mysql --limit=20
 *
 * This is a syntax check, not a semantic one: it cannot confirm that a foreign
 * key resolves or that a view's columns exist. Statements the parser does not
 * cover (triggers, DELIMITER blocks, stored routines) are reported separately
 * rather than counted as failures.
 */

const fs = require('fs');
const path = require('path');
const { Parser } = require('node-sql-parser');

const DB_DIR = path.join(__dirname, '..', '..', 'db');
const parser = new Parser();

const only = (process.argv.find((a) => a.startsWith('--only=')) || '').split('=')[1];
const limitArg = (process.argv.find((a) => a.startsWith('--limit=')) || '').split('=')[1];
const SAMPLES = limitArg ? parseInt(limitArg, 10) : 10;

const DIALECTS = [
  { dir: 'mysql', database: 'mysql' },
  { dir: 'postgres', database: 'postgresql' }
].filter((d) => !only || d.dir === only);

// Constructs the parser has no grammar for. Not translator faults.
const OUT_OF_SCOPE = /^\s*(DELIMITER|CREATE\s+(OR\s+REPLACE\s+)?(TRIGGER|FUNCTION|PROCEDURE)|DROP\s+(TRIGGER|FUNCTION|PROCEDURE)|CREATE\s+EXTENSION|CREATE\s+SEQUENCE|SET\s+SESSION|SELECT\s+setval)/i;

/**
 * Splits generated SQL on `;` at statement level, ignoring strings and
 * comments. Routine bodies are excluded first: their internal semicolons are
 * not statement boundaries, and the parser has no grammar for them anyway.
 */
function splitGenerated(sql) {
  // Drop MySQL DELIMITER blocks and PostgreSQL $$-quoted bodies wholesale.
  const withoutRoutines = sql
    .replace(/DELIMITER\s+\$\$[\s\S]*?DELIMITER\s*;/gi, '')
    .replace(/\$\$[\s\S]*?\$\$/g, '');

  const statements = [];
  let current = '';
  let inString = false;
  let inLineComment = false;

  for (let i = 0; i < withoutRoutines.length; i++) {
    const ch = withoutRoutines[i];
    const next = withoutRoutines[i + 1];

    if (inLineComment) {
      current += ch;
      if (ch === '\n') inLineComment = false;
      continue;
    }
    if (inString) {
      current += ch;
      if (ch === "'") {
        if (next === "'") { current += next; i++; } else { inString = false; }
      }
      continue;
    }
    if (ch === '-' && next === '-') { inLineComment = true; current += ch; continue; }
    if (ch === "'") { inString = true; current += ch; continue; }

    if (ch === ';') {
      statements.push(current);
      current = '';
      continue;
    }
    current += ch;
  }

  if (current.trim()) statements.push(current);
  return statements;
}

/** Strips comment lines so the parser sees only SQL. */
function stripComments(sql) {
  return sql.replace(/--[^\n]*/g, '').trim();
}

function walk(dir) {
  const out = [];
  if (!fs.existsSync(dir)) return out;

  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) out.push(...walk(full));
    else if (/\.sql$/i.test(entry.name)) out.push(full);
  }
  return out;
}

let exitCode = 0;

for (const { dir, database } of DIALECTS) {
  const root = path.join(DB_DIR, dir);
  const files = walk(root);

  let parsed = 0;
  let skipped = 0;
  let todo = 0;
  const failures = [];

  for (const file of files) {
    const source = fs.readFileSync(file, 'utf8');

    for (const raw of splitGenerated(source)) {
      // A TODO block is entirely commented out; nothing to parse.
      if (/^\s*(--\s*TODO\(port\)|--\s*REVIEW\(port\))/m.test(raw) && !stripComments(raw)) {
        todo++;
        continue;
      }

      const statement = stripComments(raw);
      if (!statement) continue;

      if (OUT_OF_SCOPE.test(statement)) { skipped++; continue; }

      try {
        parser.astify(statement, { database });
        parsed++;
      } catch (err) {
        failures.push({
          file: path.relative(DB_DIR, file),
          message: err.message.split('\n')[0].slice(0, 140),
          snippet: statement.replace(/\s+/g, ' ').slice(0, 160)
        });
      }
    }
  }

  const total = parsed + failures.length;
  const rate = total === 0 ? 0 : ((parsed / total) * 100).toFixed(2);

  console.log(`\n=== ${dir} ===`);
  console.log(`  files              : ${files.length}`);
  console.log(`  parsed OK          : ${parsed}`);
  console.log(`  parse failures     : ${failures.length}`);
  console.log(`  not parser-covered : ${skipped} (triggers, routines, sequences)`);
  console.log(`  TODO blocks        : ${todo}`);
  console.log(`  syntax pass rate   : ${rate}%`);

  if (failures.length > 0) {
    exitCode = 1;

    const byMessage = {};
    failures.forEach((f) => {
      const key = f.message.replace(/"[^"]*"/g, '"X"').replace(/\d+/g, 'N');
      byMessage[key] = (byMessage[key] || 0) + 1;
    });

    console.log('\n  failure kinds:');
    Object.entries(byMessage)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 12)
      .forEach(([msg, count]) => console.log(`    ${String(count).padStart(5)}  ${msg}`));

    console.log(`\n  first ${Math.min(SAMPLES, failures.length)} failing statements:`);
    failures.slice(0, SAMPLES).forEach((f, i) => {
      console.log(`    ${i + 1}. ${f.file}`);
      console.log(`       ${f.snippet}`);
    });
  }
}

process.exit(exitCode);
