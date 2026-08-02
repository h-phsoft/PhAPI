/**
 * MySQL SQL Builder
 * Uses standard parameterized placeholders (?) or positional params array.
 */

class MysqlSqlBuilder {
  getTableName(entity) {
    return entity.tableName;
  }

  buildSelect(entity, options = {}) {
    const { fields, filters = {}, joins = [], sortBy, sortOrder = 'ASC', page = 1, pageSize = 20 } = options;
    const tableName = this.getTableName(entity);

    let selectCols = '*';
    if (fields && fields.length > 0) {
      selectCols = fields.map(f => {
        const fieldMeta = entity.fields.find(m => m.Field.toLowerCase() === f.toLowerCase());
        return fieldMeta ? `\`${fieldMeta.Name}\` AS \`${fieldMeta.Field}\`` : f;
      }).join(', ');
    } else {
      selectCols = entity.fields.map(f => `\`${f.Name}\` AS \`${f.Field}\``).join(', ');
    }

    let sql = `SELECT ${selectCols} FROM \`${tableName}\``;
    const params = [];

    if (joins && joins.length > 0) {
      for (const join of joins) {
        const joinTable = join.refTable;
        sql += ` LEFT JOIN \`${joinTable}\` ON \`${tableName}\`.\`${join.foreignKeyColumn}\` = \`${joinTable}\`.\`${join.primaryKeyColumn}\``;
      }
    }

    const whereClauses = [];
    for (const [key, value] of Object.entries(filters)) {
      const fieldMeta = entity.fields.find(f => f.Field.toLowerCase() === key.toLowerCase());
      if (fieldMeta && fieldMeta.query) {
        whereClauses.push(`\`${fieldMeta.Name}\` = ?`);
        params.push(value);
      }
    }

    if (whereClauses.length > 0) {
      sql += ` WHERE ${whereClauses.join(' AND ')}`;
    }

    if (sortBy) {
      const sortMeta = entity.fields.find(f => f.Field.toLowerCase() === sortBy.toLowerCase());
      const sortCol = sortMeta ? sortMeta.Name : sortBy;
      sql += ` ORDER BY \`${sortCol}\` ${sortOrder.toUpperCase() === 'DESC' ? 'DESC' : 'ASC'}`;
    } else if (entity.primaryKey) {
      const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === entity.primaryKey.toLowerCase());
      if (pkMeta) {
        sql += ` ORDER BY \`${pkMeta.Name}\` ASC`;
      }
    }

    if (page && pageSize) {
      const offset = (page - 1) * pageSize;
      sql += ` LIMIT ? OFFSET ?`;
      params.push(pageSize, offset);
    }

    return { sql, params };
  }

  buildInsert(entity, data) {
    const tableName = this.getTableName(entity);
    const columns = [];
    const placeholders = [];
    const params = [];

    for (const fieldMeta of entity.fields) {
      const apiField = fieldMeta.Field;
      if (data.hasOwnProperty(apiField)) {
        columns.push(`\`${fieldMeta.Name}\``);
        placeholders.push('?');
        params.push(data[apiField]);
      }
    }

    const sql = `INSERT INTO \`${tableName}\` (${columns.join(', ')}) VALUES (${placeholders.join(', ')})`;
    return { sql, params };
  }

  buildUpdate(entity, id, data) {
    const tableName = this.getTableName(entity);
    const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === entity.primaryKey.toLowerCase());
    const pkCol = pkMeta ? pkMeta.Name : entity.primaryKey;

    const setClauses = [];
    const params = [];

    for (const fieldMeta of entity.fields) {
      const apiField = fieldMeta.Field;
      if (fieldMeta.update && data.hasOwnProperty(apiField)) {
        setClauses.push(`\`${fieldMeta.Name}\` = ?`);
        params.push(data[apiField]);
      }
    }

    params.push(id);
    const sql = `UPDATE \`${tableName}\` SET ${setClauses.join(', ')} WHERE \`${pkCol}\` = ?`;
    return { sql, params };
  }

  buildDelete(entity, id) {
    const tableName = this.getTableName(entity);
    const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === entity.primaryKey.toLowerCase());
    const pkCol = pkMeta ? pkMeta.Name : entity.primaryKey;

    const sql = `DELETE FROM \`${tableName}\` WHERE \`${pkCol}\` = ?`;
    return { sql, params: [id] };
  }

  buildMaxAutonumber(autonumberRule, context = {}) {
    const table = autonumberRule.Table || autonumberRule.Synonym;
    const col = autonumberRule.Column;
    let sql = `SELECT COALESCE(MAX(\`${col}\`), 0) + 1 AS nextVal FROM \`${table}\``;
    const params = [];

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

module.exports = MysqlSqlBuilder;
