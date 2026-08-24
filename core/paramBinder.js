/**
 * Dialect-aware bind parameter collector.
 *
 * Oracle takes named binds (:p_1) alongside a params object, while MySQL takes
 * positional '?' and Postgres '$n', both alongside a params array. Callers add
 * a value, splice the returned placeholder into the SQL, and hand `params` to
 * the driver. Placeholders must be spliced in the same order they are added so
 * the positional dialects line up.
 */
class ParamBinder {
  constructor(dbType = 'mysql') {
    this.dbType = String(dbType || 'mysql').toLowerCase();
    this.isNamed = this.dbType === 'oracle';
    this.isPositionalNumbered = ['postgres', 'postgresql', 'pg'].includes(this.dbType);
    this.values = this.isNamed ? {} : [];
    this.count = 0;
  }

  /**
   * Registers a value and returns the placeholder text for it.
   * @param {*} value Value to bind
   * @returns {string} Placeholder to splice into the SQL
   */
  add(value) {
    this.count++;

    if (this.isNamed) {
      const name = `p_${this.count}`;
      this.values[name] = value;
      return `:${name}`;
    }

    this.values.push(value);
    return this.isPositionalNumbered ? `$${this.count}` : '?';
  }

  /**
   * Params in the shape the driver for this dialect expects.
   * @returns {Object|Array}
   */
  get params() {
    return this.values;
  }
}

module.exports = ParamBinder;
