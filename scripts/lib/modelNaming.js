/**
 * The naming and typing conventions the entity models follow.
 *
 * Every rule here was derived from the 1004 files already in resources/modules
 * and is annotated with how many of them it reproduces. They are the
 * specification: the files were named and typed by hand long before anything
 * generated them, and a generator that disagrees with them writes a model the
 * rest of the system does not recognise.
 *
 * Shared by generateResources.js (legacy JSON in) and generateFromSchema.js
 * (a live database in) so both produce the same thing.
 */

/**
 * Packages whose tables spell the prefix differently from the directory.
 *
 * Cpy is the only one: its tables are Copy_Branches, Copy_User and so on, and
 * neither spelling is a prefix of the other.
 */
const PREFIX_ALIASES = { cpy: 'copy' };

/**
 * What to call the file describing a table: the package prefix goes, the rest
 * runs together.
 *
 *   Clnc_Code_Vat     in Clnc  -> CodeVat.json
 *   Acc_Code_Document in Acc   -> CodeDocument.json
 *   Copy_Branches     in Cpy   -> Branches.json
 *
 * The prefix and the directory are not always the same word, so a segment is
 * dropped when either name starts with the other -- Sal_Sales_View sits in
 * Sales/ and becomes SalesView.json -- or when it is the package's known
 * alias. A segment that is neither is part of the name and stays, so
 * Number_Of_OverLimit under Stor/ is not beheaded into OfOverLimit.
 *
 * Reproduces all 1004 existing filenames.
 *
 * @param {string} tableName e.g. Clnc_Code_Vat
 * @param {string} pkg The package directory, e.g. Clnc
 * @returns {string} The base name, without .json
 */
function modelFileName(tableName, pkg) {
  const parts = String(tableName).split('_').filter(Boolean);

  if (parts.length > 1) {
    const head = parts[0].toLowerCase();
    const dir = String(pkg).toLowerCase();
    if (head.startsWith(dir) || dir.startsWith(head) || head === PREFIX_ALIASES[dir]) {
      parts.shift();
    }
  }

  return parts.join('');
}

/**
 * Restores the models' casing to an identifier the database returned.
 *
 * Oracle folds every unquoted identifier to upper case, so ACC_BANK_TRN_VIEW
 * and STATUS_ID come back carrying no casing at all; written out as they
 * arrive they would produce BANKTRNVIEW.json. An all-caps name is therefore
 * title-cased per segment, back to Acc_Bank_Trn_View and Status_Id.
 *
 * A name with any lower case in it is how the database really spells it --
 * MySQL and PostgreSQL both preserve what the DDL wrote -- and is left alone.
 *
 * What this cannot recover is an inner capital: CAmt and MWItem_Id come back
 * as CAMT and MWITEM_ID and become Camt and Mwitem_Id. That is cosmetic only.
 * Unquoted identifiers are case-insensitive in every dialect here, so the SQL
 * is unaffected, and `toFieldName` lower-cases exactly those characters, so
 * camt and mwitemId come out the same either way -- the API contract does not
 * move.
 *
 * @param {string} identifier A table or column name as the database gave it
 * @returns {string}
 */
function restoreCase(identifier) {
  const name = String(identifier || '');

  if (name !== name.toUpperCase()) {
    return name;
  }

  return name
    .split('_')
    .map((p) => (p ? p.charAt(0).toUpperCase() + p.slice(1).toLowerCase() : p))
    .join('_');
}

/**
 * The audit stamps' API names, keyed by the column name with its underscores
 * and case taken out.
 */
const AUDIT_FIELD_NAMES = {
  insuser: 'insUser',
  insdate: 'insDate',
  upduser: 'updUser',
  upddate: 'updDate'
};

/**
 * A column name with its underscores and case taken out: Ins_Date and
 * Insdate are both `insdate`.
 *
 * @param {string} columnName
 * @returns {string}
 */
function auditKeyOf(columnName) {
  return String(columnName).replace(/_/g, '').toLowerCase();
}

/**
 * True when the column is one of the four audit stamps, however it is spelt.
 *
 * @param {string} columnName
 * @returns {boolean}
 */
function isAuditColumn(columnName) {
  return Object.prototype.hasOwnProperty.call(AUDIT_FIELD_NAMES, auditKeyOf(columnName));
}

/**
 * The API name of a column: Status_Id -> statusId, Ins_User -> insUser.
 *
 * Reproduces 19064 of the 19204 existing columns. The 140 that differ are
 * deliberate hand edits -- Job_Id exposed as `id`, Cont_Id as `contactId`,
 * LName left capitalised -- and they survive because nothing regenerates a
 * file that already exists.
 *
 * The four audit stamps are the exception: however a table spells them --
 * Ins_Date, Insdate, INSDATE -- they are exposed as insUser, insDate, updUser
 * and updDate, because that is what `auditFields` names.
 *
 * @param {string} columnName As the database spells it
 * @returns {string}
 */
function toFieldName(columnName) {
  const audit = AUDIT_FIELD_NAMES[auditKeyOf(columnName)];
  if (audit) {
    return audit;
  }

  const parts = String(columnName).split('_').filter(Boolean);
  if (!parts.length) {
    return '';
  }

  return parts
    .map((p, i) => (i === 0
      ? p.toLowerCase()
      : p.charAt(0).toUpperCase() + p.slice(1).toLowerCase()))
    .join('');
}

/**
 * The display property a joined relation is exposed under: statusId ->
 * statusName. Reproduces 2249 of 2409 existing relations.
 *
 * @param {string} fieldName The API name of the foreign key column
 * @returns {string}
 */
function toDisplayFieldName(fieldName) {
  return /Id$/.test(fieldName)
    ? fieldName.replace(/Id$/, 'Name')
    : `${fieldName}Name`;
}

/**
 * Column types as each dialect spells them, mapped onto the three the models
 * use. Normalising here rather than at each reader is what lets the same
 * schema produce the same JSON whether it is read from Oracle, MySQL or
 * PostgreSQL.
 */
const TYPE_FAMILIES = [
  ['VARCHAR2', [
    'varchar', 'varchar2', 'char', 'character', 'character varying', 'nchar', 'nvarchar',
    'nvarchar2', 'text', 'tinytext', 'mediumtext', 'longtext', 'clob', 'nclob', 'citext',
    'json', 'jsonb', 'uuid', 'enum', 'set', 'xml'
  ]],
  // Three date families, not one, because the format a column is written and
  // read in follows what the metadata declares it to be. Oracle spells only
  // DATE and TIMESTAMP, so a DATE that needs its hour kept is promoted to
  // DATETIME by the generator; MySQL and PostgreSQL say which they mean.
  ['DATE', ['date']],
  ['DATETIME', [
    'datetime', 'timestamp', 'timestamptz', 'year', 'interval',
    'timestamp without time zone', 'timestamp with time zone'
  ]],
  ['TIME', [
    'time', 'timetz', 'time without time zone', 'time with time zone'
  ]],
  ['BLOB', [
    'blob', 'tinyblob', 'mediumblob', 'longblob', 'bytea', 'binary', 'varbinary',
    'raw', 'long raw', 'bfile', 'image'
  ]],
  ['NUMBER', [
    'number', 'numeric', 'decimal', 'dec', 'int', 'integer', 'int2', 'int4', 'int8',
    'smallint', 'tinyint', 'mediumint', 'bigint', 'float', 'float4', 'float8', 'real',
    'double', 'double precision', 'money', 'bit', 'boolean', 'bool', 'serial', 'bigserial',
    'smallserial', 'binary_float', 'binary_double'
  ]]
];

/**
 * Digits an integer type holds, where the dialect reports no precision of its
 * own. MySQL and PostgreSQL name the width in the type instead.
 */
const INTEGER_WIDTHS = {
  bit: 1, boolean: 1, bool: 1,
  tinyint: 3,
  smallint: 5, int2: 5, smallserial: 5,
  mediumint: 7,
  int: 10, integer: 10, int4: 10, serial: 10,
  bigint: 19, int8: 19, bigserial: 19
};

/** Approximate floats the way the models do: Double at 17,3. */
const FLOAT_SHAPE = { precision: 17, scale: 3 };
const FLOAT_TYPES = new Set(['float', 'float4', 'float8', 'real', 'double', 'double precision', 'binary_float', 'binary_double', 'money']);

/**
 * Maps one column onto the DBType / Type / Short / Precision / Scale the
 * models carry.
 *
 * The numeric split was read off the existing files: scale above zero is
 * always Double; at scale zero, precision up to 5 is Short (6600 columns),
 * 6 to 9 is Integer (1258) and 10 or more is Long (956).
 *
 * @param {string} rawType The dialect's type name
 * @param {number|null} precision
 * @param {number|null} scale
 * @returns {{DBType: string, Type: string, Short: string, Precision: string, Scale: string}}
 */
function mapColumnType(rawType, precision, scale) {
  const raw = String(rawType || '').trim().toLowerCase();

  // Oracle reports TIMESTAMP(6) as "TIMESTAMP(6) WITH TIME ZONE" and similar.
  const bare = raw.replace(/\(.*?\)/g, '').trim();

  let dbType = 'VARCHAR2';
  for (const [family, names] of TYPE_FAMILIES) {
    if (names.includes(bare)) {
      dbType = family;
      break;
    }
  }
  // Anything unrecognised that merely contains a family word, e.g. "timestamp(6)".
  if (dbType === 'VARCHAR2' && !TYPE_FAMILIES[0][1].includes(bare)) {
    for (const [family, names] of TYPE_FAMILIES) {
      if (names.some((n) => bare.startsWith(n))) {
        dbType = family;
        break;
      }
    }
  }

  if (dbType !== 'NUMBER') {
    // Length is not carried for these: every existing String column reports 0.
    return { DBType: dbType, Type: 'String', Short: 'String', Precision: '0', Scale: '0' };
  }

  let p = Number.isFinite(Number(precision)) && precision !== null ? Number(precision) : null;
  let s = Number.isFinite(Number(scale)) && scale !== null ? Number(scale) : 0;

  if (p === null) {
    if (FLOAT_TYPES.has(bare)) {
      p = FLOAT_SHAPE.precision;
      s = FLOAT_SHAPE.scale;
    } else {
      p = INTEGER_WIDTHS[bare] !== undefined ? INTEGER_WIDTHS[bare] : 0;
    }
  }

  if (s > 0) {
    return { DBType: 'NUMBER', Type: 'Double', Short: 'Double', Precision: String(p), Scale: String(s) };
  }
  if (p <= 5) {
    return { DBType: 'NUMBER', Type: 'Short', Short: 'Short', Precision: String(p), Scale: '0' };
  }
  if (p <= 9) {
    return { DBType: 'NUMBER', Type: 'Integer', Short: 'Int', Precision: String(p), Scale: '0' };
  }
  return { DBType: 'NUMBER', Type: 'Long', Short: 'Long', Precision: String(p), Scale: '0' };
}

module.exports = {
  PREFIX_ALIASES,
  modelFileName,
  restoreCase,
  toFieldName,
  isAuditColumn,
  toDisplayFieldName,
  mapColumnType
};
