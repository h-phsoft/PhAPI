/**
 * Collects bind values and hands back the placeholder that reads each one.
 *
 * Callers add a value, splice the returned placeholder into the SQL, and give
 * `params` to the driver. Placeholders must be spliced in the order they were
 * added, so the positional dialects line up.
 *
 * How a placeholder is written -- `:p_1`, `?`, `$1` -- and whether the values
 * travel as an object or an array is the dialect's business, declared by its
 * `newParams` and `bind`. This file used to decide that by comparing the
 * engine's name, which put a list of engines in a layer that has no business
 * knowing one exists.
 */
class ParamBinder {
  /**
   * @param {Object} dialect The dialect the statement is being built for
   */
  constructor(dialect) {
    this.dialect = dialect;
    this.values = dialect.newParams();
    this.count = 0;
  }

  /**
   * Registers a value and returns the placeholder text for it.
   *
   * @param {*} value Value to bind
   * @returns {string} Placeholder to splice into the SQL
   */
  add(value) {
    this.count++;
    return this.dialect.bind(this.values, this.count, value);
  }

  /**
   * Params in the shape this dialect's driver expects.
   *
   * @returns {Object|Array}
   */
  get params() {
    return this.values;
  }
}

module.exports = ParamBinder;
