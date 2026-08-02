/**
 * Oracle SQL Builder
 * Uses Oracle binding format (:1, :2, or named bindings :paramName)
 * Uses Oracle synonym in FROM clause if available.
 */

class OracleSqlBuilder {
  /**
   * Returns table or synonym name for Oracle queries.
   */
  getTableName(entity) {
    return entity.synonym || entity.tableName;
  }

  /**
   * Generates SELECT query
   */
  buildSelect(entity, options = {}) {
    const { fields, filters = {}, joins = [], sortBy, sortOrder = 'ASC', page = 1, pageSize = 20 } = options;
    const tableName = this.getTableName(entity);

    // Map fields
    let selectCols = '*';
    if (fields && fields.length > 0) {
      selectCols = fields.map(f => {
        const fieldMeta = entity.fields.find(m => m.Field.toLowerCase() === f.toLowerCase());
        return fieldMeta ? `${fieldMeta.Name} AS "${fieldMeta.Field}"` : f;
      }).join(', ');
    } else {
      selectCols = entity.fields.map(f => `${f.Name} AS "${f.Field}"`).join(', ');
    }

    let sql = `SELECT ${selectCols} FROM ${tableName}`;
    const params = {};
    let paramIndex = 1;

    // Joins
    if (joins && joins.length > 0) {
      for (const join of joins) {
        const joinTable = join.refSynonym || join.refTable;
        sql += ` LEFT JOIN ${joinTable} ON ${tableName}.${join.foreignKeyColumn} = ${joinTable}.${join.primaryKeyColumn}`;
      }
    }

    // Where clause
    const whereClauses = [];
    for (const [key, value] of Object.entries(filters)) {
      const fieldMeta = entity.fields.find(f => f.Field.toLowerCase() === key.toLowerCase());
      if (fieldMeta && fieldMeta.query) {
        const paramName = `p_${paramIndex++}`;
        whereClauses.push(`${fieldMeta.Name} = :${paramName}`);
        params[paramName] = value;
      }
    }

    if (whereClauses.length > 0) {
      sql += ` WHERE ${whereClauses.join(' AND ')}`;
    }

    // Sorting
    if (sortBy) {
      const sortMeta = entity.fields.find(f => f.Field.toLowerCase() === sortBy.toLowerCase());
      const sortCol = sortMeta ? sortMeta.Name : sortBy;
      sql += ` ORDER BY ${sortCol} ${sortOrder.toUpperCase() === 'DESC' ? 'DESC' : 'ASC'}`;
    } else if (entity.primaryKey) {
      const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === entity.primaryKey.toLowerCase());
      if (pkMeta) {
        sql += ` ORDER BY ${pkMeta.Name} ASC`;
      }
    }

    // Pagination (Oracle 12c+)
    if (page && pageSize) {
      const offset = (page - 1) * pageSize;
      const offsetParam = `p_${paramIndex++}`;
      const limitParam = `p_${paramIndex++}`;
      sql += ` OFFSET :${offsetParam} ROWS FETCH NEXT :${limitParam} ROWS ONLY`;
      params[offsetParam] = offset;
      params[limitParam] = pageSize;
    }

    return { sql, params };
  }

  /**
   * Generates INSERT query
   */
  buildInsert(entity, data) {
    const tableName = this.getTableName(entity);
    const columns = [];
    const valuePlaceholders = [];
    const params = {};
    let paramIndex = 1;

    for (const fieldMeta of entity.fields) {
      const apiField = fieldMeta.Field;
      if (data.hasOwnProperty(apiField)) {
        const paramName = `p_${paramIndex++}`;
        columns.push(fieldMeta.Name);
        valuePlaceholders.push(`:${paramName}`);
        params[paramName] = data[apiField];
      }
    }

    const sql = `INSERT INTO ${tableName} (${columns.join(', ')}) VALUES (${valuePlaceholders.join(', ')})`;
    return { sql, params };
  }

  /**
   * Generates UPDATE query
   */
  buildUpdate(entity, id, data) {
    const tableName = this.getTableName(entity);
    const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === entity.primaryKey.toLowerCase());
    const pkCol = pkMeta ? pkMeta.Name : entity.primaryKey;

    const setClauses = [];
    const params = {};
    let paramIndex = 1;

    for (const fieldMeta of entity.fields) {
      const apiField = fieldMeta.Field;
      if (fieldMeta.update && data.hasOwnProperty(apiField)) {
        const paramName = `p_${paramIndex++}`;
        setClauses.push(`${fieldMeta.Name} = :${paramName}`);
        params[paramName] = data[apiField];
      }
    }

    const pkParamName = `p_${paramIndex++}`;
    params[pkParamName] = id;

    const sql = `UPDATE ${tableName} SET ${setClauses.join(', ')} WHERE ${pkCol} = :${pkParamName}`;
    return { sql, params };
  }

  /**
   * Generates DELETE query
   */
  buildDelete(entity, id) {
    const tableName = this.getTableName(entity);
    const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === entity.primaryKey.toLowerCase());
    const pkCol = pkMeta ? pkMeta.Name : entity.primaryKey;

    const params = { p_1: id };
    const sql = `DELETE FROM ${tableName} WHERE ${pkCol} = :p_1`;
    return { sql, params };
  }

  /**
   * Generates Max Autonumber Query
   */
  buildMaxAutonumber(autonumberRule, context = {}) {
    const table = autonumberRule.Synonym || autonumberRule.Table;
    const col = autonumberRule.Column;
    let sql = `SELECT NVL(MAX(${col}), 0) + 1 AS "nextVal" FROM ${table}`;
    const params = {};

    if (autonumberRule.PeriodCondition) {
      let cond = autonumberRule.PeriodCondition;
      for (const [k, v] of Object.entries(context)) {
        cond = cond.replace(new RegExp(`\\{${k}\\}`, 'g'), v);
      }
      sql += ` WHERE ${cond}`;
    }

    return { sql, params };
  }
}

module.exports = OracleSqlBuilder;
