/**
 * The next value for a column the server numbers itself.
 *
 * This lived under `utils`, which it never was: it builds SQL, runs it on a
 * connection and branched on the engine three times over. Two of those branches
 * were a third copy of the MAX + 1 statement the query builder already
 * produces, written slightly differently -- the PostgreSQL one lower-cased its
 * identifiers and the MySQL one did not quote the alias, both of which the
 * builder already handles.
 *
 * So it asks the query layer for the statement and the dialect for the
 * sequence, and no longer knows which engine it is talking to.
 */

const query = require('../core/query');

/**
 * Reads the single `nextVal` column a generator statement returns.
 *
 * Drivers disagree on case: Oracle gives NEXTVAL for an unquoted alias, the
 * others give what the alias said.
 *
 * @param {Array} rows
 * @returns {number|string|null}
 */
function readNextVal(rows) {
  if (!rows || rows.length === 0) {
    return null;
  }
  const row = rows[0];
  const value = row.nextVal !== undefined ? row.nextVal : row.NEXTVAL;
  return value === undefined ? null : value;
}

class AutoNumber {
  /**
   * Generates the next value for an autonumber field.
   *
   * A named sequence is used where the engine has them; otherwise the value is
   * MAX + 1 over the column, optionally scoped by the metadata's period
   * condition.
   *
   * @param {Object} dbConn Active connection, inside the caller's transaction
   * @param {string} dbType The engine this connection speaks
   * @param {Object} fieldMeta Field metadata carrying an `Autonumber` rule
   * @param {Object} context Request context, for the period condition
   * @returns {Promise<number|string|null>} null when the database assigns it
   */
  static async generate(dbConn, dbType, fieldMeta, context = {}) {
    const rule = fieldMeta.Autonumber;
    if (!rule) {
      return null;
    }

    const dialect = query.dialectFor(dbType);

    // A named sequence, where this engine has them and the metadata names one.
    //
    // The metadata is shared by every tenant and names a sequence for 950
    // tables, of which any one copy has only some -- 160 of 421 in the Demo
    // schema. A copy that lacks the sequence falls through to MAX + 1, which is
    // what the same rule already says to do (`Aggr: 'Max'`) and what the Java
    // system did. Only a missing sequence is treated this way: a permission
    // problem or a dead connection still fails the insert, because silently
    // taking MAX + 1 in either case is how two rows end up sharing a key.
    if (rule.Sequence) {
      const sql = dialect.nextSequenceValue(rule.Sequence);
      if (sql) {
        try {
          const value = readNextVal(await dbConn.query(sql));
          if (value === null) {
            throw new Error(`[Autonumber] Failed to fetch next value from sequence ${rule.Sequence}`);
          }
          return value;
        } catch (err) {
          if (!dialect.isMissingSequence || !dialect.isMissingSequence(err)) {
            throw err;
          }
        }
      }
    }

    // Otherwise MAX + 1, which is the statement the query builder already
    // knows how to spell for every engine.
    if ((rule.Aggr && String(rule.Aggr).toLowerCase() === 'max') || rule.Mode === '11') {
      const { sql, params } = query.buildMaxAutonumber(dbType, {
        ...rule,
        Column: rule.Column || fieldMeta.Name,
        Table: rule.Table || fieldMeta.tableName
      }, context);

      return readNextVal(await dbConn.query(sql, params));
    }

    // Nothing to generate: the database assigns this one.
    return null;
  }
}

module.exports = AutoNumber;
