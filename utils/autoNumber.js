const sqlBuilder = require('../core/sqlBuilder');

/**
 * Utility helper to generate autonumber values based on metadata rules.
 */
class AutoNumberHelper {
  /**
   * Generates next autonumber value for an autonumber field.
   * @param {Object} dbConn Active DB connection wrapper (within transaction)
   * @param {string} dbType 'oracle' | 'mysql' | 'postgres'
   * @param {Object} fieldMeta Metadata of the field containing Autonumber object
   * @param {Object} context Context object containing req params, body, periodId, tenantId
   * @returns {Promise<number|string|null>} Generated autonumber or null if DB-native auto-increment
   */
  static async generate(dbConn, dbType, fieldMeta, context = {}) {
    const autonumberRule = fieldMeta.Autonumber;
    if (!autonumberRule) return null;

    const { Sequence, Aggr, Column, Synonym, Table, PeriodCondition, Mode } = autonumberRule;

    // 1. Oracle Sequence
    if (Sequence && dbType.toLowerCase() === 'oracle') {
      const sql = `SELECT ${Sequence}.NEXTVAL AS "nextVal" FROM DUAL`;
      const rows = await dbConn.query(sql);
      if (rows && rows.length > 0) {
        return rows[0].nextVal || rows[0].NEXTVAL;
      }
      throw new Error(`[Autonumber] Failed to fetch next value from sequence ${Sequence}`);
    }

    // 2. Postgres Sequence (if defined in Sequence property)
    if (Sequence && (dbType.toLowerCase() === 'postgres' || dbType.toLowerCase() === 'pg')) {
      const sql = `SELECT nextval('${Sequence}') AS "nextVal"`;
      const rows = await dbConn.query(sql);
      if (rows && rows.length > 0) {
        return parseInt(rows[0].nextVal, 10);
      }
    }

    // 3. Max aggregation logic (Aggr = "Max" or Mode = "11")
    if ((Aggr && Aggr.toLowerCase() === 'max') || Mode === '11') {
      const targetTable = Synonym || Table || fieldMeta.tableName;
      const targetCol = Column || fieldMeta.Name;

      let sql = '';
      const params = [];

      if (dbType.toLowerCase() === 'oracle') {
        sql = `SELECT NVL(MAX(${targetCol}), 0) + 1 AS "nextVal" FROM ${targetTable}`;
      } else if (dbType.toLowerCase() === 'postgres' || dbType.toLowerCase() === 'pg') {
        sql = `SELECT COALESCE(MAX("${targetCol}"), 0) + 1 AS "nextVal" FROM "${targetTable}"`;
      } else {
        sql = `SELECT COALESCE(MAX(\`${targetCol}\`), 0) + 1 AS nextVal FROM \`${targetTable}\``;
      }

      if (PeriodCondition) {
        let cond = PeriodCondition;
        // Resolve {periodId} or any other context variables
        for (const [key, val] of Object.entries(context)) {
          cond = cond.replace(new RegExp(`\\{${key}\\}`, 'g'), val);
        }
        sql += ` WHERE ${cond}`;
      }

      const rows = await dbConn.query(sql, params);
      if (rows && rows.length > 0) {
        const val = rows[0].nextVal !== undefined ? rows[0].nextVal : rows[0].NEXTVAL;
        return parseInt(val, 10);
      }
      return 1;
    }

    // 4. Native DB auto-increment fallback
    return null;
  }
}

module.exports = AutoNumberHelper;
