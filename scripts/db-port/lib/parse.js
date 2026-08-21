/**
 * Statement splitting for Oracle SQL*Plus scripts.
 *
 * These scripts mix two terminators: a lone `/` on its own line ends any
 * statement, while `;` ends plain SQL. PL/SQL bodies contain `;` internally, so
 * inside those only `/` counts. Splitting therefore has to know which kind of
 * statement it is currently accumulating, and has to ignore terminators that
 * appear inside string literals or comments.
 */

// Statements whose bodies are PL/SQL and may contain semicolons.
const PLSQL_START = /^\s*(CREATE\s+(OR\s+REPLACE\s+)?(TRIGGER|PROCEDURE|FUNCTION|PACKAGE(\s+BODY)?|TYPE)|DECLARE|BEGIN)\b/i;

/**
 * Splits a script into individual statements.
 *
 * @param {string} source Raw file contents
 * @returns {Array<{text: string, line: number}>} Statements in source order
 */
function splitStatements(source) {
  const statements = [];
  const lines = source.split(/\r?\n/);

  let buffer = [];
  let startLine = 1;
  let inBlockComment = false;

  const flush = () => {
    const text = buffer.join('\n').trim();
    if (text) {
      statements.push({ text, line: startLine });
    }
    buffer = [];
  };

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    if (buffer.length === 0) {
      startLine = i + 1;
    }

    // A lone `/` terminates whatever has accumulated, PL/SQL included.
    if (!inBlockComment && /^\s*\/\s*$/.test(line)) {
      flush();
      continue;
    }

    buffer.push(line);

    // Track block comments across lines so terminators inside them are ignored.
    const scan = scanLine(line, inBlockComment);
    inBlockComment = scan.inBlockComment;

    if (inBlockComment) {
      continue;
    }

    const accumulated = buffer.join('\n');
    if (PLSQL_START.test(accumulated)) {
      // Only `/` ends a PL/SQL body; keep accumulating.
      continue;
    }

    if (scan.endsStatement) {
      flush();
    }
  }

  flush();
  return statements;
}

/**
 * Walks one line tracking quotes and comments.
 *
 * @param {string} line
 * @param {boolean} startInBlockComment
 * @returns {{endsStatement: boolean, inBlockComment: boolean}}
 */
function scanLine(line, startInBlockComment) {
  let inBlockComment = startInBlockComment;
  let inString = false;
  let endsStatement = false;

  for (let i = 0; i < line.length; i++) {
    const ch = line[i];
    const next = line[i + 1];

    if (inBlockComment) {
      if (ch === '*' && next === '/') {
        inBlockComment = false;
        i++;
      }
      continue;
    }

    if (inString) {
      if (ch === "'") {
        // '' is an escaped quote, not the end of the literal.
        if (next === "'") {
          i++;
        } else {
          inString = false;
        }
      }
      continue;
    }

    if (ch === "'") {
      inString = true;
      continue;
    }

    if (ch === '-' && next === '-') {
      break; // line comment: nothing after this matters
    }

    if (ch === '/' && next === '*') {
      inBlockComment = true;
      i++;
      continue;
    }

    if (ch === ';') {
      endsStatement = true;
    }
  }

  return { endsStatement, inBlockComment };
}

/**
 * Classifies a statement so the emitter knows how to handle it.
 * @param {string} text
 * @returns {string}
 */
function classify(text) {
  const head = text.replace(/^\s*(--[^\n]*\n\s*)*/i, '').trim();

  if (/^CREATE\s+(OR\s+REPLACE\s+)?(PUBLIC\s+)?SYNONYM/i.test(head)) return 'synonym';

  // Instance-level administration with no portable equivalent. Checked before
  // the table rule, since CREATE TABLESPACE otherwise matches "CREATE TABLE".
  if (/^(CREATE|ALTER|DROP)\s+(TABLESPACE|USER|PROFILE|ROLE|DIRECTORY|DATABASE\s+LINK)\b/i.test(head)) return 'dba';
  if (/^ALTER\s+SYSTEM\b/i.test(head)) return 'dba';

  // The word boundary keeps TABLESPACE out of this branch.
  if (/^CREATE\s+(GLOBAL\s+TEMPORARY\s+)?TABLE\b/i.test(head)) return 'table';
  if (/^CREATE\s+(OR\s+REPLACE\s+)?(FORCE\s+)?VIEW/i.test(head)) return 'view';
  if (/^CREATE\s+SEQUENCE/i.test(head)) return 'sequence';
  if (/^CREATE\s+(OR\s+REPLACE\s+)?TRIGGER/i.test(head)) return 'trigger';
  if (/^CREATE\s+(OR\s+REPLACE\s+)?PACKAGE/i.test(head)) return 'package';
  if (/^CREATE\s+(OR\s+REPLACE\s+)?PROCEDURE/i.test(head)) return 'procedure';
  if (/^CREATE\s+(OR\s+REPLACE\s+)?FUNCTION/i.test(head)) return 'function';
  if (/^CREATE\s+(UNIQUE\s+)?(BITMAP\s+)?INDEX/i.test(head)) return 'index';
  if (/^ALTER\s+TABLE/i.test(head)) return 'alter';
  if (/^(INSERT|UPDATE|DELETE)\b/i.test(head)) return 'dml';
  if (/^COMMENT\s+ON/i.test(head)) return 'comment';
  if (/^(DROP|CREATE)\s+CONTEXT/i.test(head)) return 'context';
  if (/^GRANT|^REVOKE/i.test(head)) return 'grant';
  if (/^COMMIT|^SET\s+DEFINE|^SPOOL|^EXIT|^ALTER\s+SESSION/i.test(head)) return 'session';

  return 'other';
}

/**
 * Extracts the object name a CREATE statement defines.
 * @param {string} text
 * @param {string} kind From classify()
 * @returns {string|null}
 */
function objectName(text, kind) {
  const patterns = {
    table: /CREATE\s+(?:GLOBAL\s+TEMPORARY\s+)?TABLE\s+([A-Za-z0-9_$#."]+)/i,
    view: /CREATE\s+(?:OR\s+REPLACE\s+)?(?:FORCE\s+)?VIEW\s+([A-Za-z0-9_$#."]+)/i,
    sequence: /CREATE\s+SEQUENCE\s+([A-Za-z0-9_$#."]+)/i,
    trigger: /CREATE\s+(?:OR\s+REPLACE\s+)?TRIGGER\s+([A-Za-z0-9_$#."]+)/i,
    index: /CREATE\s+(?:UNIQUE\s+)?(?:BITMAP\s+)?INDEX\s+([A-Za-z0-9_$#."]+)/i
  };

  const pattern = patterns[kind];
  if (!pattern) {
    return null;
  }
  const match = text.match(pattern);
  return match ? stripSchema(match[1]) : null;
}

/** Removes any schema qualifier and quoting from an identifier. */
function stripSchema(identifier) {
  const bare = String(identifier).replace(/"/g, '');
  const parts = bare.split('.');
  return parts[parts.length - 1];
}

/**
 * Parses `CREATE SYNONYM x FOR y`.
 * @returns {{name: string, target: string}|null}
 */
function parseSynonym(text) {
  const match = text.match(
    /CREATE\s+(?:OR\s+REPLACE\s+)?(?:PUBLIC\s+)?SYNONYM\s+([A-Za-z0-9_$#."]+)\s+FOR\s+([A-Za-z0-9_$#."]+)/i
  );
  if (!match) {
    return null;
  }
  return { name: stripSchema(match[1]), target: stripSchema(match[2]) };
}

module.exports = { splitStatements, classify, objectName, parseSynonym, stripSchema };
