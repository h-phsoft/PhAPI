const { applyRules, applyRawRules, replaceCall, mapTypes, parseTypeArgs, forceIdIntegers, ensureIdPrimaryKey } = require('./rewrite');

/**
 * PostgreSQL 14+ emitter.
 *
 * Postgres is much closer to Oracle than MySQL is: sequences, `||`
 * concatenation and TO_DATE all exist natively. The real divergence is triggers,
 * which must be split into a trigger function plus a CREATE TRIGGER binding.
 */

const NAME = 'postgres';

const PRELUDE = `-- ---------------------------------------------------------------------------
-- PostgreSQL compatibility prelude. Run this once, before any other script.
-- ---------------------------------------------------------------------------

-- gen_random_uuid() is built in from PostgreSQL 13; pgcrypto provides it before.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Identifiers in these scripts are unquoted mixed case, which PostgreSQL folds
-- to lower case consistently on both definition and reference, so no quoting is
-- applied during translation.

-- Oracle sequences are kept as native PostgreSQL sequences, so the triggers
-- that populate key columns are carried over rather than replaced. Every
-- sequence is normalised to START WITH 1 / INCREMENT BY 1, so any Oracle
-- stepping (PhsId_Seq stepped by 100) is intentionally not reproduced.
--
-- Seed data inserts explicit ids without advancing the sequences. Run
-- 9998_resync_sequences.sql after loading it, or the first generated id will
-- collide with an existing row.

-- Oracle TO_NUMBER(x) takes one argument; PostgreSQL's requires a format model.
CREATE OR REPLACE FUNCTION To_Number_Compat(p_val TEXT)
RETURNS NUMERIC AS $$
  SELECT p_val::NUMERIC;
$$ LANGUAGE sql IMMUTABLE;
`;

/** Oracle NUMBER precision decides the narrowest exact type that still fits. */
function numberType(precision, scale) {
  if (scale !== null && scale > 0) {
    return `NUMERIC(${precision === null ? 38 : precision},${scale})`;
  }
  if (precision === null) {
    return 'NUMERIC';
  }
  if (precision <= 4) return 'SMALLINT';
  if (precision <= 9) return 'INTEGER';
  // NUMBER(19)/NUMBER(20) exceed BIGINT on paper but only ever hold surrogate
  // keys here, and BIGINT indexes and joins far better than NUMERIC.
  if (precision <= 20) return 'BIGINT';
  return `NUMERIC(${precision},0)`;
}

function mapType({ name, args }) {
  const { precision, scale } = parseTypeArgs(args);

  switch (name) {
    case 'VARCHAR2':
    case 'NVARCHAR2':
    case 'VARCHAR':
      return precision === null ? 'TEXT' : `VARCHAR(${precision})`;
    case 'CHAR':
    case 'NCHAR':
      return `CHAR(${precision === null ? 1 : precision})`;
    case 'NUMBER':
    case 'NUMERIC':
    case 'DECIMAL':
      return numberType(precision, scale);
    case 'INTEGER':
    case 'INT':
      return 'INTEGER';
    case 'FLOAT':
    case 'BINARY_FLOAT':
      return 'REAL';
    case 'BINARY_DOUBLE':
      return 'DOUBLE PRECISION';
    // Oracle DATE carries a time component, so PostgreSQL DATE would truncate.
    case 'DATE':
      return 'TIMESTAMP';
    case 'TIMESTAMP':
      return 'TIMESTAMP';
    case 'CLOB':
    case 'NCLOB':
    case 'LONG':
      return 'TEXT';
    case 'BLOB':
    case 'RAW':
      return 'BYTEA';
    case 'ROWID':
      return 'VARCHAR(64)';
    default:
      return null;
  }
}

/**
 * Rules that must see string literals, so they run over the raw statement
 * rather than through applyRules.
 */
const RAW_RULES = [
  // The source carries a MySQL-style inline column comment that PostgreSQL has
  // no syntax for. Dropped rather than turned into a COMMENT ON, which would
  // have to become a separate statement.
  [/\s+COMMENT\s+'(?:[^']|'')*'/gi, '']
];

/**
 * Converts Oracle's RAISE_APPLICATION_ERROR into a PL/pgSQL RAISE.
 *
 * The message is passed through a '%' placeholder because RAISE takes a format
 * string: `RAISE EXCEPTION 'a'||b` is a syntax error, whereas
 * `RAISE EXCEPTION '%', 'a'||b` is not.
 */
function convertRaise(sql) {
  return replaceCall(sql, 'RAISE_APPLICATION_ERROR', (args) => {
    const comma = args.indexOf(',');
    const message = comma === -1 ? args : args.slice(comma + 1);
    return `RAISE EXCEPTION '%', ${message.trim()}`;
  });
}

const FUNCTION_RULES = [
  // Columns holding GUIDs are varchar here, so the uuid is cast to text.
  [/\bSYS_GUID\s*\(\s*\)/gi, "replace(gen_random_uuid()::text,'-','')"],
  [/\bSYSTIMESTAMP\b/gi, 'CURRENT_TIMESTAMP'],
  [/\bSYSDATE\b/gi, 'LOCALTIMESTAMP'],
  [/\bNVL\s*\(/gi, 'COALESCE('],
  [/\bLISTAGG\s*\(/gi, 'STRING_AGG('],
  [/\s+FROM\s+DUAL\b/gi, ''],
  [/\bTRUNC\s*\(\s*SYSDATE\s*\)/gi, 'date_trunc(\'day\', LOCALTIMESTAMP)'],
  [/\bTO_NUMBER\s*\(/gi, 'To_Number_Compat('],
  [/\bUSER\b(?!\s*\()/gi, 'CURRENT_USER']
];

function translateTable(sql) {
  // RAW_RULES first: they match across string literals, which applyRules hides.
  let out = applyRawRules(sql, RAW_RULES);
  out = forceIdIntegers(out);
  out = ensureIdPrimaryKey(out).sql;

  out = mapTypes(out, mapType);

  out = applyRules(out, [
    ...FUNCTION_RULES,
    [/\b(TABLESPACE|PCTFREE|PCTUSED|INITRANS|MAXTRANS|STORAGE|LOGGING|NOLOGGING|SEGMENT\s+CREATION\s+\w+)\b[^,)]*/gi, ''],
    [/\bENABLE\b/gi, ''],
    [/\bORGANIZATION\s+INDEX\b/gi, '']
  ]);

  return `${out.replace(/;+\s*$/, '')};`;
}

/**
 * Emits a native PostgreSQL sequence.
 *
 * Oracle's original START WITH and INCREMENT BY values are deliberately not
 * carried over: every sequence is normalised to start at 1 and step by 1. The
 * Oracle bounds (MINVALUE/MAXVALUE/CACHE) are dropped with them, since a
 * MINVALUE above the start value would be rejected, and the PostgreSQL defaults
 * already cover the full BIGINT range.
 */
function translateSequence(sql, name) {
  return `CREATE SEQUENCE IF NOT EXISTS ${name}\n  INCREMENT BY 1\n  START WITH 1;`;
}

function translateView(sql) {
  const out = applyRules(sql, [
    ...FUNCTION_RULES,
    [/\bSELECT\s+ALL\b/gi, 'SELECT'],
    [/\bCREATE\s+OR\s+REPLACE\s+FORCE\s+VIEW\b/gi, 'CREATE OR REPLACE VIEW']
  ]);
  return `${out.replace(/;+\s*$/, '')};`;
}

function translateDml(sql) {
  const out = applyRules(sql, FUNCTION_RULES);
  return `${out.replace(/;+\s*$/, '')};`;
}

/**
 * Splits an Oracle row trigger into a PL/pgSQL function plus its binding.
 * Best effort: the body is translated mechanically and flagged for review.
 */
function translateTrigger(sql, name) {
  const header = sql.match(
    /CREATE\s+(?:OR\s+REPLACE\s+)?TRIGGER\s+([A-Za-z0-9_$#."]+)\s+(BEFORE|AFTER|INSTEAD\s+OF)\s+([\s\S]*?)\s+ON\s+([A-Za-z0-9_$#."]+)([\s\S]*?)(DECLARE|BEGIN)/i
  );

  if (!header) {
    return null;
  }

  const triggerName = name || header[1];
  const timing = header[2].toUpperCase();
  const events = header[3].replace(/\s+/g, ' ').trim().toUpperCase();
  const table = header[4];
  const forEachRow = /FOR\s+EACH\s+ROW/i.test(header[5]);

  // Everything from DECLARE/BEGIN onward is the body.
  const bodyStart = sql.indexOf(header[6], header.index);
  let body = sql.slice(bodyStart);

  body = body.replace(/:\s*(NEW|OLD)\s*\./gi, (m, which) => `${which.toUpperCase()}.`);
  body = body.replace(/\b([A-Za-z0-9_$#]+)\s*\.\s*NEXTVAL\b/gi, (m, seq) => `nextval('${seq}')`);
  body = body.replace(/\b([A-Za-z0-9_$#]+)\s*\.\s*CURRVAL\b/gi, (m, seq) => `currval('${seq}')`);
  body = convertRaise(body);
  body = applyRules(body, FUNCTION_RULES);
  body = mapTypes(body, mapType);

  // End <name>; -> END;
  body = body.replace(/\bEND\s+[A-Za-z0-9_$#]+\s*;\s*$/i, 'END;');
  if (!/\bEND\s*;\s*$/i.test(body.trim())) {
    body = `${body.trim()}\nEND;`;
  }

  // A trigger function must return a row; BEFORE row triggers return NEW.
  const returnValue = timing === 'BEFORE' && forEachRow ? 'NEW' : (/DELETE/.test(events) ? 'OLD' : 'NEW');
  body = body.replace(/\bEND\s*;\s*$/i, `  RETURN ${returnValue};\nEND;`);

  const functionName = `${triggerName}_fn`;

  return `CREATE OR REPLACE FUNCTION ${functionName}() RETURNS TRIGGER AS $$
${body.trim()}
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS ${triggerName} ON ${table};
CREATE TRIGGER ${triggerName}
  ${timing} ${events}
  ON ${table}
  ${forEachRow ? 'FOR EACH ROW' : 'FOR EACH STATEMENT'}
  EXECUTE FUNCTION ${functionName}();`;
}

function translateIndex(sql) {
  const out = applyRules(sql, [
    [/\b(TABLESPACE|PCTFREE|INITRANS|MAXTRANS|STORAGE|LOGGING|NOLOGGING)\b[^,;]*/gi, '']
  ]);
  return `${out.replace(/;+\s*$/, '')};`;
}

function translateAlter(sql) {
  const out = applyRules(mapTypes(sql, mapType), [
    ...FUNCTION_RULES,
    [/\bENABLE\b/gi, ''],
    // Oracle wraps an added constraint in parentheses; PostgreSQL rejects them.
    [/\bADD\s*\(\s*(CONSTRAINT\b[\s\S]*?)\s*\)\s*$/gi, 'ADD $1'],
    // Each additional constraint needs its own ADD.
    [/,(\s*)CONSTRAINT\b/gi, ',$1ADD CONSTRAINT'],
    [/\bMODIFY\s*\(/gi, 'ALTER COLUMN ']
  ]);
  return `${out.replace(/;+\s*$/, '')};`;
}

module.exports = {
  NAME,
  PRELUDE,
  // PostgreSQL keeps native sequences, so the triggers driving them are kept.
  dropSequenceOnlyTriggers: false,

  /**
   * PostgreSQL databases are separate connections rather than a namespace, so
   * this is a psql meta-command instead of SQL.
   */
  useDatabase: (name) => `\\connect ${name}\n`,

  createDatabases: (names) =>
    `-- Run this first, as a superuser, against any existing database.\n` +
    `-- CREATE DATABASE cannot run inside a transaction block.\n\n` +
    names
      .map((name) =>
        `SELECT 'CREATE DATABASE ${name} ENCODING ''UTF8'' TEMPLATE template0'\n` +
        `  WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${name}')\\gexec`)
      .join('\n\n') + '\n',

  mapType,
  translateTable,
  translateSequence,
  translateView,
  translateDml,
  translateTrigger,
  translateIndex,
  translateAlter,
  // Packages have no PostgreSQL equivalent; schemas plus functions are the
  // usual replacement, but that is a design decision, not a translation.
  // Instance administration (tablespaces, users, profiles) differs entirely.
  unsupported: ['package', 'context', 'grant', 'dba']
};
