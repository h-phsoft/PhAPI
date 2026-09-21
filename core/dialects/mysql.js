/**
 * MySQL, as a set of differences. See core/dialects/oracle.js for the contract.
 */

const { formatFor } = require('../types/dates');

module.exports = {
  name: 'mysql',

  /** Positional binds travel as an array, in the order they were added. */
  newParams() {
    return [];
  },

  bind(params, index, value) {
    params.push(value);
    return '?';
  },

  object(name) {
    return `\`${name}\``;
  },

  alias(name) {
    return `\`${name}\``;
  },

  /**
   * No synonyms here: the ported schema names each object after its Oracle
   * synonym instead, so the table name is already the right one.
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

  nextValAlias: 'nextVal',

  /** Size before offset, which is the opposite order to Oracle's. */
  paginate(bind, offset, pageSize) {
    const sizePlaceholder = bind.add(pageSize);
    const offsetPlaceholder = bind.add(offset);
    return ` LIMIT ${sizePlaceholder} OFFSET ${offsetPlaceholder}`;
  },

  /**
   * MySQL has no standalone sequences -- AUTO_INCREMENT plays that part -- so
   * a caller falls back to MAX + 1.
   *
   * @returns {null}
   */
  limit(bind, limit) {
    return ` LIMIT ${bind.add(limit)}`;
  },

  now() {
    return 'NOW()';
  },

  nextSequenceValue() {
    return null;
  },

  toDate(placeholder, kind) {
    return `STR_TO_DATE(${placeholder}, '${formatFor(kind, 'strftime')}')`;
  }
};
