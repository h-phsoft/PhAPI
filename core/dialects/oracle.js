/**
 * Oracle, as a set of differences.
 *
 * Everything about the *shape* of a statement -- which columns, which filters,
 * what order, where the pagination goes -- is the same on every engine and
 * lives in core/query. What is left here is spelling, and it is the only place
 * in the project allowed to know this engine exists.
 */

const { formatFor } = require('../types/dates');

module.exports = {
  name: 'oracle',

  /** Named binds travel as an object keyed by name. */
  newParams() {
    return {};
  },

  /**
   * @param {Object} params The bag being filled
   * @param {number} index 1-based position
   * @param {*} value
   * @returns {string} The placeholder that reads it
   */
  bind(params, index, value) {
    const name = `p_${index}`;
    params[name] = value;
    return `:${name}`;
  },

  /** A table or column reference. Oracle folds unquoted names itself. */
  object(name) {
    return String(name);
  },

  /**
   * A column alias. Quoted so the driver returns `statusId` rather than
   * STATUSID, which is what the API contract is written in.
   */
  alias(name) {
    return `"${name}"`;
  },

  /**
   * A join reads through the synonym where one exists.
   *
   * Oracle is the only engine here with real synonyms; the ported schemas name
   * their objects after them instead.
   */
  joinTable(join) {
    return join.refSynonym || join.refTable;
  },

  /** Which name an autonumber rule counts against. */
  autonumberTable(rule) {
    return rule.Synonym || rule.Table;
  },

  maxPlusOne(column) {
    return `NVL(MAX(${column}), 0) + 1`;
  },

  nextValAlias: '"nextVal"',

  /**
   * 12c row limiting. Offset is bound before size, which is the opposite of
   * the LIMIT/OFFSET engines -- the reason pagination is a dialect concern
   * rather than a shared string.
   *
   * @param {Object} bind The statement's ParamBinder
   * @param {number} offset
   * @param {number} pageSize
   * @returns {string} The clause to append
   */
  paginate(bind, offset, pageSize) {
    const offsetPlaceholder = bind.add(offset);
    const sizePlaceholder = bind.add(pageSize);
    return ` OFFSET ${offsetPlaceholder} ROWS FETCH NEXT ${sizePlaceholder} ROWS ONLY`;
  },

  /**
   * The clause that caps a result to n rows, bound not inlined.
   *
   * @param {Object} bind The statement's ParamBinder
   * @param {number} limit
   * @returns {string}
   */
  limit(bind, limit) {
    return ` FETCH NEXT ${bind.add(limit)} ROWS ONLY`;
  },

  /** The server's current timestamp, as an expression. */
  now() {
    return 'SYSDATE';
  },

  /**
   * The next value of a named sequence.
   *
   * Oracle is the only engine here whose schema ships sequences; the others
   * return null and the caller falls back to MAX + 1.
   *
   * @param {string} sequence The sequence name from the metadata
   * @returns {string|null} SQL yielding one row with a "nextVal" column
   */
  nextSequenceValue(sequence) {
    return `SELECT ${sequence}.NEXTVAL AS "nextVal" FROM DUAL`;
  },

  /** Wraps a placeholder so a date is read in the format its type declares. */
  toDate(placeholder, kind) {
    return `TO_DATE(${placeholder}, '${formatFor(kind, 'pattern')}')`;
  },

  /**
   * An aggregate applied to a column.
   *
   * The seven that every engine spells the same way need no special case. Oracle has MEDIAN as an ordinary aggregate.
   *
   * @param {string} name A canonical name from core/query/aggregates
   * @param {string} col The column, already quoted
   * @returns {string}
   * @throws {Error} When this engine has no way to spell it
   */
  aggregate(name, col) {
    if (name === 'MEDIAN') {
      return `MEDIAN(${col})`;
    }
    return `${name}(${col})`;
  }
};
