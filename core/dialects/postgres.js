/**
 * PostgreSQL, as a set of differences. See core/dialects/oracle.js for the
 * contract.
 */

const { formatFor } = require('../types/dates');

module.exports = {
  name: 'postgres',

  /** Positional binds travel as an array, numbered from one. */
  newParams() {
    return [];
  },

  bind(params, index, value) {
    params.push(value);
    return `$${index}`;
  },

  /**
   * An object reference, lower-cased before it is quoted.
   *
   * The schema is created from DDL that never quotes its identifiers, so
   * PostgreSQL stores `Copy_User_Dashboard_List_Blocks_View` folded to lower
   * case. A quoted mixed-case reference is case-sensitive and would not match
   * it, so every object reference has to be lowered before it is quoted.
   */
  object(name) {
    return `"${String(name).toLowerCase()}"`;
  },

  /**
   * An alias, quoted with its original camelCase deliberately, so the API
   * returns `blockUrl` rather than `blockurl`.
   */
  alias(name) {
    return `"${name}"`;
  },

  /**
   * No synonyms, and a foreign key cannot reference a view, so the ported
   * schema names each object after its Oracle synonym and the table name is
   * already the right one.
   */
  joinTable(join) {
    return join.refTable;
  },

  autonumberTable(rule) {
    return rule.Table || rule.Synonym;
  },

  maxPlusOne(column) {
    return `COALESCE(MAX(${column}), 0) + 1`;
  },

  nextValAlias: '"nextVal"',

  /**
   * How the generated key comes back.
   *
   * Oracle and MySQL report it through their driver -- `result.insertId`, a
   * RETURNING INTO bind -- while PostgreSQL only gives it if the statement
   * asks. `unifiedRepository.insert` reads it off the first returned row.
   *
   * @param {string} keyColumn The primary key, already quoted
   * @returns {string} The clause to append
   */
  insertReturning(keyColumn) {
    return ` RETURNING ${keyColumn}`;
  },

  /** Size before offset, which is the opposite order to Oracle's. */
  paginate(bind, offset, pageSize) {
    const sizePlaceholder = bind.add(pageSize);
    const offsetPlaceholder = bind.add(offset);
    return ` LIMIT ${sizePlaceholder} OFFSET ${offsetPlaceholder}`;
  },

  limit(bind, limit) {
    return ` LIMIT ${bind.add(limit)}`;
  },

  now() {
    return 'NOW()';
  },

  /**
   * The next value of a named sequence.
   *
   * @param {string} sequence
   * @returns {string|null}
   */
  nextSequenceValue(sequence) {
    return `SELECT nextval('${sequence}') AS "nextVal"`;
  },

  /**
   * TO_TIMESTAMP returns `timestamp with time zone`, which would be re-read
   * through the session zone on its way into a `timestamp` column and could
   * land an hour out; the cast pins it.
   */
  toDate(placeholder, kind) {
    return `TO_TIMESTAMP(${placeholder}, '${formatFor(kind, 'pattern')}')::timestamp`;
  },

  /**
   * An aggregate applied to a column.
   *
   * The seven that every engine spells the same way need no special case. PostgreSQL has no MEDIAN function; the same value is an ordered-set
   * aggregate, which is a different shape rather than a different name.
   *
   * @param {string} name A canonical name from core/query/aggregates
   * @param {string} col The column, already quoted
   * @returns {string}
   * @throws {Error} When this engine has no way to spell it
   */
  aggregate(name, col) {
    if (name === 'MEDIAN') {
      return `PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ${col})`;
    }
    // STDDEV and VARIANCE are the sample forms here, as they are in Oracle.
    return `${name}(${col})`;
  }
};
