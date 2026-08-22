const { applyRules, applyRawRules, replaceCall, normalizeLineComments, mapTypes, parseTypeArgs, forceIdIntegers, ensureIdPrimaryKey } = require('./rewrite');

/**
 * MySQL 8 emitter.
 *
 * Two structural gaps drive most of the work here: MySQL has no sequences, and
 * its `||` is logical OR rather than concatenation. Sequences are emulated with
 * a registry table plus a nextval() function (see prelude), and PIPES_AS_CONCAT
 * is set so the many `a||b` expressions in the views keep their meaning.
 */

const NAME = 'mysql';

/** Helpers the translated scripts depend on. */
const PRELUDE = `-- ---------------------------------------------------------------------------
-- MySQL compatibility prelude. Run this once, before any other script.
-- ---------------------------------------------------------------------------

-- Oracle's || is concatenation; MySQL treats it as logical OR unless told
-- otherwise. Every session running these scripts needs this mode.
SET SESSION sql_mode = CONCAT(@@sql_mode, ',PIPES_AS_CONCAT');

-- Oracle sequences are not carried over: key columns are AUTO_INCREMENT
-- instead, and the triggers that existed only to call a sequence are dropped.
-- Seed data inserts explicit ids, which AUTO_INCREMENT accepts and which raise
-- the counter automatically, so no resynchronisation step is needed.

DELIMITER $$

-- Oracle TO_NUMBER(x) takes a single argument; MySQL has no direct equivalent.
DROP FUNCTION IF EXISTS Cast_To_Number $$
CREATE FUNCTION Cast_To_Number(p_val TEXT)
RETURNS DECIMAL(38,10)
DETERMINISTIC
BEGIN
  RETURN CAST(p_val AS DECIMAL(38,10));
END $$

DELIMITER ;
`;

/**
 * Oracle NUMBER carries a single type across every numeric width, so precision
 * decides the narrowest MySQL integer that still fits.
 */
function numberType(precision, scale) {
  if (scale !== null && scale > 0) {
    return `DECIMAL(${precision === null ? 38 : precision},${scale})`;
  }
  if (precision === null) {
    return 'DECIMAL(38,10)';
  }
  if (precision <= 2) return 'TINYINT';
  if (precision <= 4) return 'SMALLINT';
  if (precision <= 7) return 'MEDIUMINT';
  if (precision <= 9) return 'INT';
  // NUMBER(19) and NUMBER(20) exceed BIGINT's range on paper, but in these
  // scripts that width is only ever used for surrogate keys fed by sequences
  // capped far below it. DECIMAL would cost index size and rule out
  // AUTO_INCREMENT, so BIGINT is the better trade. See PORTING-REPORT.md.
  if (precision <= 20) return 'BIGINT';
  return `DECIMAL(${precision},0)`;
}

function mapType({ name, args }) {
  const { precision, scale } = parseTypeArgs(args);

  switch (name) {
    case 'VARCHAR2':
    case 'NVARCHAR2':
    case 'VARCHAR':
      // MySQL rows are capped at 65535 bytes; wide varchars become TEXT.
      if (precision !== null && precision > 4000) return 'TEXT';
      return `VARCHAR(${precision === null ? 255 : precision})`;
    case 'CHAR':
    case 'NCHAR':
      return `CHAR(${precision === null ? 1 : precision})`;
    case 'NUMBER':
    case 'NUMERIC':
    case 'DECIMAL':
      return numberType(precision, scale);
    case 'INTEGER':
    case 'INT':
      return 'INT';
    case 'FLOAT':
    case 'BINARY_FLOAT':
      return 'FLOAT';
    case 'BINARY_DOUBLE':
      return 'DOUBLE';
    // Oracle DATE carries a time component, so DATE would silently truncate.
    case 'DATE':
      return 'DATETIME';
    case 'TIMESTAMP':
      return 'DATETIME';
    case 'CLOB':
    case 'NCLOB':
    case 'LONG':
      return 'LONGTEXT';
    case 'BLOB':
      return 'LONGBLOB';
    case 'RAW':
      return `VARBINARY(${precision === null ? 255 : precision})`;
    case 'ROWID':
      return 'VARCHAR(64)';
    default:
      return null;
  }
}

/**
 * `Key` is the only column name in this schema that collides with a MySQL
 * reserved word, so it is back-quoted wherever it appears as an identifier. The
 * compound forms are matched first so PRIMARY KEY and FOREIGN KEY survive intact.
 */
const RESERVED_RULES = [
  [/(\b(?:PRIMARY|FOREIGN|UNIQUE|INDEX)\s+KEY\b)|(\bKEY\b)/gi,
    (match, compound) => (compound ? compound : '`Key`')]
];

/**
 * Converts Oracle's RAISE_APPLICATION_ERROR into MySQL's SIGNAL.
 * Uses balanced-paren matching so a nested call in the message does not
 * terminate the match early and strand a closing parenthesis.
 */
function convertRaise(sql) {
  return replaceCall(sql, 'RAISE_APPLICATION_ERROR', (args) => {
    const comma = args.indexOf(',');
    const message = comma === -1 ? args : args.slice(comma + 1);
    return `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ${message.trim()}`;
  });
}

const FUNCTION_RULES = [
  // Oracle SYS_GUID() yields 32 hex characters with no dashes; UUID() yields 36
  // with them. Stripping them keeps new rows in the same shape as the seed data.
  [/\bSYS_GUID\s*\(\s*\)/gi, "(REPLACE(UUID(),'-',''))"],
  [/\bSYSTIMESTAMP\b/gi, 'CURRENT_TIMESTAMP'],
  // Oracle adds plain numbers to a DATE as days. MySQL would accept NOW() + 1
  // without complaint but coerce both sides to numbers, silently producing a
  // meaningless value rather than tomorrow. Must precede the bare SYSDATE rule.
  [/\bSYSDATE\s*\+\s*([0-9]+(?:\.[0-9]+)?)/gi, 'DATE_ADD(NOW(), INTERVAL $1 DAY)'],
  [/\bSYSDATE\s*-\s*([0-9]+(?:\.[0-9]+)?)/gi, 'DATE_SUB(NOW(), INTERVAL $1 DAY)'],
  [/\bSYSDATE\b/gi, 'NOW()'],
  [/\bNVL\s*\(/gi, 'IFNULL('],
  [/\bNVL2\s*\(/gi, 'IF('],
  [/\bLISTAGG\s*\(/gi, 'GROUP_CONCAT('],
  [/\bSUBSTR\s*\(/gi, 'SUBSTRING('],
  [/\bLTRIM\s*\(/gi, 'LTRIM('],
  // MySQL accepts FROM DUAL, but a bare SELECT is clearer.
  [/\s+FROM\s+DUAL\b/gi, ''],
  [/\bTO_DATE\s*\(/gi, 'STR_TO_DATE('],
  [/\bTO_NUMBER\s*\(/gi, 'Cast_To_Number('],
  [/\bTRUNC\s*\(/gi, 'DATE('],
  [/\bUSER\b(?!\s*\()/gi, 'CURRENT_USER()']
];

/** Oracle date format models differ from MySQL's strftime-style ones. */
const DATE_FORMAT_MAP = [
  [/'DD\/MM\/RR'/gi, "'%d/%m/%y'"],
  [/'DD\/MM\/RRRR'/gi, "'%d/%m/%Y'"],
  [/'DD\/MM\/YYYY'/gi, "'%d/%m/%Y'"],
  [/'YYYY-MM-DD'/gi, "'%Y-%m-%d'"],
  [/'DD-MON-RR'/gi, "'%d-%b-%y'"],
  [/'YYYYMMDD'/gi, "'%Y%m%d'"],
  [/'HH24:MI:SS'/gi, "'%H:%i:%s'"],
  [/'YYYY-MM-DD HH24:MI:SS'/gi, "'%Y-%m-%d %H:%i:%s'"]
];

function translateTable(sql) {
  let out = forceIdIntegers(sql);
  const keyed = ensureIdPrimaryKey(out);
  out = keyed.sql;

  out = mapTypes(out, mapType);

  out = applyRules(out, [
    ...RESERVED_RULES,
    ...FUNCTION_RULES,
    // Oracle allows a trailing storage clause MySQL has no use for.
    [/\b(TABLESPACE|PCTFREE|PCTUSED|INITRANS|MAXTRANS|STORAGE|LOGGING|NOLOGGING|SEGMENT\s+CREATION\s+\w+)\b[^,)]*/gi, ''],
    [/\bENABLE\b/gi, ''],
    [/\bORGANIZATION\s+INDEX\b/gi, '']
  ]);

  // The key column carries the generator, replacing the Oracle sequence. Only
  // applied when Id is genuinely the primary key, since MySQL requires an
  // AUTO_INCREMENT column to be a key.
  if (/PRIMARY\s+KEY\s*\(\s*Id\s*\)/i.test(out)) {
    out = out.replace(
      /(^|\n|,|\()(\s*)(Id)(\s+)(INT|BIGINT)\b([^,\n]*)/i,
      (match, lead, indent, column, gap, type, rest) =>
        /AUTO_INCREMENT/i.test(rest)
          ? match
          : `${lead}${indent}${column}${gap}${type}${rest} AUTO_INCREMENT`
    );
  }

  // The statement already ends in the closing paren of the column list; the
  // table options are appended to it rather than opening a second one.
  const body = out.replace(/;+\s*$/, '').trimEnd();
  return `${body} ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`;
}

/** Sequences are replaced by AUTO_INCREMENT, so nothing is emitted for them. */
function translateSequence() {
  return null;
}

function translateView(sql) {
  // Date format models live inside string literals, so they are rewritten on
  // the raw text before applyRules hides those literals from its rules.
  let out = applyRawRules(sql, DATE_FORMAT_MAP);
  out = applyRules(out, [
    ...RESERVED_RULES,
    ...FUNCTION_RULES,
    // "SELECT ALL" is valid but noisy; MySQL accepts it, keep it simple.
    [/\bSELECT\s+ALL\b/gi, 'SELECT'],
    [/\bCREATE\s+OR\s+REPLACE\s+(FORCE\s+)?VIEW\b/gi, 'CREATE OR REPLACE VIEW']
  ]);

  return `${out.replace(/;+\s*$/, '')};`;
}

function translateDml(sql) {
  let out = applyRawRules(sql, DATE_FORMAT_MAP);
  out = applyRules(out, [...RESERVED_RULES, ...FUNCTION_RULES]);
  return `${out.replace(/;+\s*$/, '')};`;
}

/**
 * Best-effort trigger translation. Row triggers map fairly directly, but
 * sequence access and assignment syntax differ, and MySQL needs a delimiter
 * switch around the body.
 */
function translateTrigger(sql) {
  let out = sql;

  // :NEW.col -> NEW.col
  out = out.replace(/:\s*(NEW|OLD)\s*\./gi, (m, which) => `${which.toUpperCase()}.`);

  // Sequences are gone; a trigger still calling one is left to the reviewer.
  out = out.replace(/\b([A-Za-z0-9_$#]+)\s*\.\s*NEXTVAL\b/gi,
    (m, seq) => `/* TODO(port): ${seq}.NEXTVAL - use AUTO_INCREMENT */ NULL`);
  out = out.replace(/\b([A-Za-z0-9_$#]+)\s*\.\s*CURRVAL\b/gi,
    (m, seq) => `/* TODO(port): ${seq}.CURRVAL */ LAST_INSERT_ID()`);

  // Oracle can scope a trigger to specific columns with UPDATE OF a, b.
  // MySQL has no column-scoped triggers, so the trigger fires on any update.
  out = out.replace(/\bUPDATE\s+OF\s+[A-Za-z0-9_$#\s,]+?\s+ON\b/gi, 'UPDATE ON');

  out = convertRaise(out);
  out = applyRawRules(out, DATE_FORMAT_MAP);
  out = applyRules(out, FUNCTION_RULES);

  // Assignment: NEW.x := expr  ->  SET NEW.x = expr
  out = out.replace(/(^|\n)(\s*)(NEW|OLD)\.([A-Za-z0-9_$#]+)\s*:=\s*/gi,
    (m, lead, indent, which, col) => `${lead}${indent}SET ${which.toUpperCase()}.${col} = `);

  out = mapTypes(out, mapType);

  // Oracle allows an empty DECLARE section; MySQL does not have one at all.
  out = out.replace(/\bDECLARE\s*\n(\s*)BEGIN\b/gi, 'BEGIN');
  out = out.replace(/\bCREATE\s+OR\s+REPLACE\s+TRIGGER\b/gi, 'CREATE TRIGGER');
  // End <name>;  ->  END
  out = out.replace(/\bEND\s+[A-Za-z0-9_$#]+\s*;\s*$/i, 'END');
  out = out.replace(/\bEND\s*;\s*$/i, 'END');

  return `DELIMITER $$\n${out.trim()}$$\nDELIMITER ;`;
}

function translateIndex(sql) {
  const out = applyRules(sql, [
    [/\b(TABLESPACE|PCTFREE|INITRANS|MAXTRANS|STORAGE|LOGGING|NOLOGGING)\b[^,;]*/gi, '']
  ]);
  return `${out.replace(/;+\s*$/, '')};`;
}

function translateAlter(sql) {
  const out = applyRules(mapTypes(sql, mapType), [
    ...RESERVED_RULES,
    ...FUNCTION_RULES,
    [/\bENABLE\b/gi, ''],
    // Oracle wraps an added constraint in parentheses; MySQL rejects them.
    [/\bADD\s*\(\s*(CONSTRAINT\b[\s\S]*?)\s*\)\s*$/gi, 'ADD $1'],
    // Oracle lists further constraints after a comma; MySQL needs ADD on each.
    [/,(\s*)CONSTRAINT\b/gi, ',$1ADD CONSTRAINT'],
    [/\bMODIFY\s*\(/gi, 'MODIFY ']
  ]);
  return `${out.replace(/;+\s*$/, '')};`;
}

module.exports = {
  NAME,
  PRELUDE,
  // AUTO_INCREMENT replaces the sequences, making those triggers redundant.
  dropSequenceOnlyTriggers: true,

  /**
   * Selects the database a script's statements apply to.
   *
   * Foreign key checks are switched off for the session because the scripts are
   * not in dependency order: a table often carries a foreign key to one created
   * in a later file, which MySQL refuses outright rather than resolving later.
   * The setting is per-session, so it has to be repeated in every file.
   */
  useDatabase: (name) => `SET FOREIGN_KEY_CHECKS = 0;\nUSE ${name};\n`,

  /**
   * Applied to the finished file. MySQL only recognises `--` as a comment when
   * whitespace follows, so the source's `------` separator lines have to be
   * normalised or they abort the rest of the file.
   */
  postProcess: (text) => normalizeLineComments(text),

  /** Creates the databases the ported schema is split across. */
  createDatabases: (names) =>
    `-- Run this first, as a user that may create databases.\n\n` +
    names
      .map((name) =>
        `CREATE DATABASE IF NOT EXISTS ${name}\n` +
        `  CHARACTER SET utf8mb4\n` +
        `  COLLATE utf8mb4_unicode_ci;`)
      .join('\n\n') + '\n',

  mapType,
  translateTable,
  translateSequence,
  translateView,
  translateDml,
  translateTrigger,
  translateIndex,
  translateAlter,
  // MySQL has no packages, and instance administration differs entirely.
  unsupported: ['package', 'procedure', 'function', 'context', 'grant', 'dba']
};
