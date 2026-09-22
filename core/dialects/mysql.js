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
  },

  /**
   * An aggregate applied to a column.
   *
   * The seven that every engine spells the same way need no special case. MySQL has no median in any form -- neither a function nor an
   * ordered-set aggregate -- so it is refused by name rather than approximated.
   * A screen that offers it on MySQL is a screen whose metadata was written for
   * another engine, and saying so is more use than a plausible wrong number.
   *
   * @param {string} name A canonical name from core/query/aggregates
   * @param {string} col The column, already quoted
   * @returns {string}
   * @throws {Error} When this engine has no way to spell it
   */
  aggregate(name, col) {
    if (name === 'MEDIAN') {
      throw new Error('MySQL cannot compute a median; the screen must not offer one');
    }
    // MySQL spells the sample standard deviation and variance differently from
    // the population forms its bare STDDEV and VARIANCE return.
    if (name === 'STDDEV') {
      return `STDDEV_SAMP(${col})`;
    }
    if (name === 'VARIANCE') {
      return `VAR_SAMP(${col})`;
    }
    return `${name}(${col})`;
  }
};
