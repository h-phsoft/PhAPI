/**
 * Shared rewriting helpers used by both dialect emitters.
 */

/**
 * Walks SQL text and applies `fn` only to the parts that are real code, leaving
 * string literals untouched. Data in an INSERT may legitimately contain a word
 * that matches a table name, and rewriting it would corrupt the seed data.
 *
 * @param {string} sql
 * @param {function(string): string} fn Applied to each code segment
 * @returns {string}
 */
function mapCodeSegments(sql, fn) {
  let out = '';
  let segment = '';
  let i = 0;

  const flush = () => {
    if (segment) {
      out += fn(segment);
      segment = '';
    }
  };

  while (i < sql.length) {
    const ch = sql[i];
    const next = sql[i + 1];

    // Line comment: copy verbatim.
    if (ch === '-' && next === '-') {
      flush();
      const end = sql.indexOf('\n', i);
      const stop = end === -1 ? sql.length : end;
      out += sql.slice(i, stop);
      i = stop;
      continue;
    }

    // Block comment: copy verbatim.
    if (ch === '/' && next === '*') {
      flush();
      const end = sql.indexOf('*/', i + 2);
      const stop = end === -1 ? sql.length : end + 2;
      out += sql.slice(i, stop);
      i = stop;
      continue;
    }

    // String literal: copy verbatim, honouring '' escapes.
    if (ch === "'") {
      flush();
      let j = i + 1;
      while (j < sql.length) {
        if (sql[j] === "'") {
          if (sql[j + 1] === "'") {
            j += 2;
            continue;
          }
          break;
        }
        j++;
      }
      out += sql.slice(i, Math.min(j + 1, sql.length));
      i = j + 1;
      continue;
    }

    segment += ch;
    i++;
  }

  flush();
  return out;
}

/**
 * Replaces whole-word identifiers using a case-insensitive map, skipping string
 * literals and comments.
 *
 * @param {string} sql
 * @param {Map<string, string>} renameMap lowercased original -> replacement
 * @returns {string}
 */
function renameIdentifiers(sql, renameMap) {
  if (renameMap.size === 0) {
    return sql;
  }

  return mapCodeSegments(sql, (code) =>
    code.replace(/[A-Za-z_][A-Za-z0-9_$#]*/g, (word) => {
      const replacement = renameMap.get(word.toLowerCase());
      return replacement === undefined ? word : replacement;
    })
  );
}

/**
 * Ensures every line-comment marker is followed by whitespace.
 *
 * Oracle and PostgreSQL start a comment at `--` regardless of what follows, so
 * the source is full of `-----------` separator rules. MySQL only treats `--`
 * as a comment when the next character is whitespace or a control character;
 * otherwise it is a syntax error that aborts the rest of the file.
 *
 * Markers inside string literals are left alone.
 *
 * @param {string} sql
 * @returns {string}
 */
function normalizeLineComments(sql) {
  let out = '';
  let inString = false;

  for (let i = 0; i < sql.length; i++) {
    const ch = sql[i];

    if (inString) {
      out += ch;
      if (ch === "'") {
        if (sql[i + 1] === "'") {
          out += sql[i + 1];
          i++;
        } else {
          inString = false;
        }
      }
      continue;
    }

    if (ch === "'") {
      inString = true;
      out += ch;
      continue;
    }

    if (ch === '-' && sql[i + 1] === '-') {
      const after = sql[i + 2];
      // Already a valid comment, or at end of input.
      if (after === undefined || /\s/.test(after)) {
        out += '--';
      } else {
        out += '-- ';
      }
      i++;

      // Copy the remainder of the comment verbatim.
      while (i + 1 < sql.length && sql[i + 1] !== '\n') {
        out += sql[++i];
      }
      continue;
    }

    out += ch;
  }

  return out;
}

/**
 * Applies rules to the whole statement, string literals included.
 *
 * Needed for anything whose pattern spans a quoted literal — a date format
 * model, an inline COMMENT 'text' clause — because applyRules deliberately
 * hides literals from its rules and such a pattern could never match there.
 *
 * @param {string} sql
 * @param {Array<[RegExp, string|function]>} rules
 * @returns {string}
 */
function applyRawRules(sql, rules) {
  let out = sql;
  for (const [pattern, replacement] of rules) {
    out = out.replace(pattern, replacement);
  }
  return out;
}

/**
 * Rewrites calls to `name(...)`, matching parentheses so nested calls in the
 * arguments do not terminate the match early.
 *
 * @param {string} sql
 * @param {string} name Function name to replace
 * @param {function(string): string} build Receives the raw argument text
 * @returns {string}
 */
function replaceCall(sql, name, build) {
  const opener = new RegExp(`\\b${name}\\s*\\(`, 'i');
  let out = sql;
  let guard = 0;

  for (;;) {
    const match = opener.exec(out);
    if (!match || guard++ > 10000) {
      return out;
    }

    // Walk forward to the parenthesis that closes this call.
    let depth = 0;
    let end = -1;
    let inString = false;

    for (let i = match.index + match[0].length - 1; i < out.length; i++) {
      const ch = out[i];

      if (inString) {
        if (ch === "'") {
          if (out[i + 1] === "'") i++;
          else inString = false;
        }
        continue;
      }
      if (ch === "'") { inString = true; continue; }
      if (ch === '(') depth++;
      else if (ch === ')') {
        depth--;
        if (depth === 0) { end = i; break; }
      }
    }

    if (end === -1) {
      return out;
    }

    const args = out.slice(match.index + match[0].length, end);
    out = out.slice(0, match.index) + build(args) + out.slice(end + 1);
  }
}

/**
 * Applies a list of [pattern, replacement] rules to code segments only.
 * @param {string} sql
 * @param {Array<[RegExp, string|function]>} rules
 * @returns {string}
 */
function applyRules(sql, rules) {
  return mapCodeSegments(sql, (code) => {
    let out = code;
    for (const [pattern, replacement] of rules) {
      out = out.replace(pattern, replacement);
    }
    return out;
  });
}

/**
 * Translates an Oracle column type to a target type.
 *
 * @param {string} sql Full statement
 * @param {function(Object): string|null} mapper Receives the parsed type
 * @returns {string}
 */
function mapTypes(sql, mapper) {
  return mapCodeSegments(sql, (code) =>
    code.replace(
      // TINYINT/DATETIME/TEXT are not Oracle types, but a few of these scripts
      // use them anyway, so they are normalised for the target as well.
      /\b(VARCHAR2|NVARCHAR2|VARCHAR|NCHAR|CHAR|NUMBER|NUMERIC|DECIMAL|INTEGER|INT|TINYINT|SMALLINT|MEDIUMINT|BIGINT|FLOAT|DOUBLE|BINARY_FLOAT|BINARY_DOUBLE|DATE|DATETIME|TIMESTAMP|CLOB|NCLOB|BLOB|LONGTEXT|LONG|TEXT|RAW|ROWID)\b(\s*\(\s*([^)]*)\s*\))?/gi,
      (match, name, _parens, args, offset, whole) => {
        const mapped = mapper({ name: name.toUpperCase(), args: args ? args.trim() : null, raw: match });
        if (mapped === null || mapped === undefined) {
          return match;
        }
        // Oracle tolerates "Number(1)Default 1" with no separating space. Once
        // the parenthesised precision is gone the tokens would run together.
        const following = whole[offset + match.length];
        return following && /[A-Za-z0-9_]/.test(following) ? `${mapped} ` : mapped;
      }
    )
  );
}

/**
 * Parses an Oracle type argument list such as "100 Char" or "10,2".
 * @param {string|null} args
 * @returns {{precision: number|null, scale: number|null}}
 */
function parseTypeArgs(args) {
  if (!args) {
    return { precision: null, scale: null };
  }
  const cleaned = args.replace(/\b(CHAR|BYTE)\b/gi, '').trim();
  const parts = cleaned.split(',').map((part) => part.trim()).filter(Boolean);

  const precision = parts.length > 0 && /^\d+$/.test(parts[0]) ? parseInt(parts[0], 10) : null;
  const scale = parts.length > 1 && /^-?\d+$/.test(parts[1]) ? parseInt(parts[1], 10) : null;
  return { precision, scale };
}

/**
 * Forces key columns to a single integer type.
 *
 * Oracle spells every number as NUMBER, so a surrogate key declared NUMBER(20)
 * would otherwise land on DECIMAL in the target. Keys need to be integers: they
 * index far better, join without implicit casts, and can carry AUTO_INCREMENT
 * or IDENTITY.
 *
 * Every key column becomes BIGINT rather than being sized by its declared
 * precision. Oracle happily foreign-keys a NUMBER(20) column to a NUMBER(5) one
 * because both are just NUMBER, but MySQL rejects an INT column referencing a
 * BIGINT key outright, which then cascades into every table that depends on it.
 * One width for all keys removes that entire class of failure.
 *
 * @param {string} sql
 * @returns {string}
 */
function forceIdIntegers(sql) {
  // Columns used as the source of a foreign key must match the width of the key
  // they point at, even when their name gives no hint. The audit columns
  // Ins_User and Upd_User reference Cpy_User(Id) but are not named *_Id.
  const fkColumns = new Set();
  const fkClause = /FOREIGN\s+KEY\s*\(([^)]*)\)/gi;
  let fk;
  while ((fk = fkClause.exec(sql)) !== null) {
    fk[1].split(',').forEach((c) => fkColumns.add(c.trim().toLowerCase()));
  }

  return mapCodeSegments(sql, (code) =>
    // The opening paren of the column list must count as a delimiter too, or
    // the first column is skipped and ends up a different width from the
    // foreign keys that reference it.
    code.replace(
      /(^|\n|,|\()(\s*)([A-Za-z][A-Za-z0-9_$#]*)(\s+)(NUMBER|NUMERIC|DECIMAL)(\s*\(\s*[^)]*\))?/gi,
      (match, lead, indent, column, gap, _type, args, offset, whole) => {
        const isKey = /^id$|_id$/i.test(column) || fkColumns.has(column.toLowerCase());
        if (!isKey) {
          return match;
        }
        const inner = args ? args.replace(/^\s*\(|\)\s*$/g, '') : null;
        const { precision, scale } = parseTypeArgs(inner);

        // A scaled number is a real quantity that happens to be named *_Id.
        if (scale !== null && scale > 0) {
          return match;
        }

        const intType = 'BIGINT';
        // "Number(1)Default 1" appears in the source; keep the tokens apart.
        const following = whole[offset + match.length];
        const pad = following && /[A-Za-z0-9_]/.test(following) ? ' ' : '';
        return `${lead}${indent}${column}${gap}${intType}${pad}`;
      }
    )
  );
}

/**
 * True when a trigger exists only to populate Id from a sequence.
 *
 * Those triggers are redundant once the key column is auto-increment, so they
 * are dropped. Triggers that derive Id some other way, or that touch anything
 * besides Id, are kept and translated.
 *
 * @param {string} sql Full CREATE TRIGGER statement
 * @returns {boolean}
 */
function isSequenceOnlyTrigger(sql) {
  const bodyStart = sql.search(/\b(DECLARE|BEGIN)\b/i);
  if (bodyStart === -1) {
    return false;
  }

  const body = sql.slice(bodyStart).replace(/--[^\n]*/g, '');

  if (!/\bNEXTVAL\b/i.test(body)) {
    return false;
  }

  // Doing anything beyond the assignment means it is not just a key generator.
  if (/\b(SELECT|INSERT|UPDATE|DELETE|MERGE|RAISE|EXECUTE|CURSOR|LOOP)\b/i.test(body)) {
    return false;
  }

  const assignments = body.match(/:?\s*(?:NEW|OLD)\s*\.\s*[A-Za-z0-9_$#]+\s*:=/gi) || [];
  if (assignments.length === 0) {
    return false;
  }

  return assignments.every((assignment) => /\.\s*Id\s*:=/i.test(assignment));
}

/**
 * Extracts which sequence feeds which table from a key-generating trigger.
 *
 * Needed to resynchronise sequences after seed data has inserted explicit ids,
 * which does not advance a PostgreSQL sequence.
 *
 * @param {string} sql Full CREATE TRIGGER statement
 * @returns {{table: string, sequence: string}|null}
 */
function extractSequenceBinding(sql) {
  const onTable = sql.match(/\bON\s+([A-Za-z0-9_$#."]+)/i);
  const sequence = sql.match(/\b([A-Za-z0-9_$#]+)\s*\.\s*NEXTVAL\b/i);

  if (!onTable || !sequence) {
    return null;
  }
  return {
    table: onTable[1].replace(/"/g, '').split('.').pop(),
    sequence: sequence[1]
  };
}

/**
 * Splits a column-list body into top-level items, ignoring commas nested in
 * parentheses, string literals or comments.
 *
 * @param {string} body Text between the outer parentheses of a CREATE TABLE
 * @returns {string[]}
 */
function splitTopLevel(body) {
  const items = [];
  let current = '';
  let depth = 0;
  let inString = false;
  let inComment = false;

  for (let i = 0; i < body.length; i++) {
    const ch = body[i];

    if (inComment) {
      current += ch;
      if (ch === '\n') inComment = false;
      continue;
    }
    if (inString) {
      current += ch;
      if (ch === "'") {
        if (body[i + 1] === "'") { current += body[++i]; } else { inString = false; }
      }
      continue;
    }
    if (ch === '-' && body[i + 1] === '-') { inComment = true; current += ch; continue; }
    if (ch === "'") { inString = true; current += ch; continue; }
    if (ch === '(') depth++;
    if (ch === ')') depth--;

    if (ch === ',' && depth === 0) {
      items.push(current);
      current = '';
      continue;
    }
    current += ch;
  }

  if (current.trim()) items.push(current);
  return items;
}

/**
 * Lifts inline FOREIGN KEY clauses out of a CREATE TABLE.
 *
 * The Oracle scripts are not in dependency order: a table routinely references
 * one that a later file creates. Declared inline, that makes the whole CREATE
 * TABLE fail, and every table depending on it fails in turn — differently on
 * each engine, which is why the two targets drifted apart. Adding the keys
 * afterwards, once every table exists, removes the ordering problem entirely
 * and makes the result identical on both.
 *
 * @param {string} sql CREATE TABLE statement
 * @param {string} tableName
 * @returns {{sql: string, foreignKeys: string[]}}
 */
function extractForeignKeys(sql, tableName) {
  const open = sql.indexOf('(');
  const close = sql.lastIndexOf(')');
  if (open === -1 || close === -1 || close < open) {
    return { sql, foreignKeys: [] };
  }

  const head = sql.slice(0, open + 1);
  const body = sql.slice(open + 1, close);
  const tail = sql.slice(close);

  const keep = [];
  const foreignKeys = [];

  for (const item of splitTopLevel(body)) {
    const bare = item.replace(/--[^\n]*/g, '').trim();

    if (/^(CONSTRAINT\s+[A-Za-z0-9_$#"]+\s+)?FOREIGN\s+KEY\b/i.test(bare)) {
      foreignKeys.push(`ALTER TABLE ${tableName} ADD ${bare.replace(/,\s*$/, '')};`);
    } else {
      keep.push(item);
    }
  }

  if (foreignKeys.length === 0) {
    return { sql, foreignKeys: [] };
  }

  return { sql: `${head}${keep.join(',')}\n${tail}`, foreignKeys };
}

/**
 * Reports whether a CREATE TABLE already declares a primary key.
 * @param {string} sql
 * @returns {boolean}
 */
function hasPrimaryKey(sql) {
  return /\bPRIMARY\s+KEY\b/i.test(sql);
}

/**
 * Adds `PRIMARY KEY (Id)` to a table that has an Id column but no key.
 * @param {string} sql
 * @returns {{sql: string, added: boolean}}
 */
function ensureIdPrimaryKey(sql) {
  if (hasPrimaryKey(sql)) {
    return { sql, added: false };
  }
  if (!/(^|\n|,)\s*Id\s+/i.test(sql)) {
    return { sql, added: false };
  }

  // Insert just before the closing paren of the column list.
  const lastParen = sql.lastIndexOf(')');
  if (lastParen === -1) {
    return { sql, added: false };
  }

  const head = sql.slice(0, lastParen).replace(/\s*$/, '');
  const tail = sql.slice(lastParen);
  return { sql: `${head},\n  PRIMARY KEY (Id)\n${tail}`, added: true };
}

module.exports = {
  mapCodeSegments,
  renameIdentifiers,
  applyRules,
  applyRawRules,
  replaceCall,
  normalizeLineComments,
  mapTypes,
  parseTypeArgs,
  forceIdIntegers,
  hasPrimaryKey,
  ensureIdPrimaryKey,
  isSequenceOnlyTrigger,
  extractSequenceBinding,
  extractForeignKeys,
  splitTopLevel
};
