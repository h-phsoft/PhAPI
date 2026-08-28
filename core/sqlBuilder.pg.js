/**
 * PostgreSQL SQL Builder
 * Uses positional parameters ($1, $2, etc.)
 */

/**
 * Quotes an identifier for PostgreSQL, folding it to lower case first.
 *
 * The schema is created from DDL that never quotes its identifiers, so
 * PostgreSQL stores `Copy_User_Dashboard_List_Blocks_View` as all lower case.
 * A quoted mixed-case reference is case-sensitive and would not match it, so
 * every object reference has to be lowered before it is quoted.
 *
 * Column aliases are deliberately NOT passed through this: those are quoted
 * with their original camelCase so the API returns `blockUrl` rather than
 * `blockurl`.
 *
 * @param {string} identifier
 * @returns {string}
 */
function ref(identifier) {
  return `"${String(identifier).toLowerCase()}"`;
}

class PgSqlBuilder {
  /**
   * The ported schema names each object after its Oracle synonym, because
   * PostgreSQL has no synonyms and a foreign key cannot reference a view. So
   * Copy_User_Dashboard_List_Blocks_View exists here as cpy_vudboard_list_blks,
   * and the synonym — not the Oracle table name — is what resolves.
   */
  getTableName(entity) {
    return entity.synonym || entity.tableName;
  }

  buildSelect(entity, options = {}) {
    const { fields, filters = {}, joins = [], sortBy, sortOrder = 'ASC', page = 1, pageSize = 20 } = options;
    const tableName = this.getTableName(entity);

    let selectCols = '*';
    if (fields && fields.length > 0) {
      selectCols = fields.map(f => {
        const fieldMeta = entity.fields.find(m => m.Field.toLowerCase() === f.toLowerCase());
        return fieldMeta ? `${ref(fieldMeta.Name)} AS "${fieldMeta.Field}"` : f;
      }).join(', ');
    } else {
      selectCols = entity.fields.map(f => `${ref(f.Name)} AS "${f.Field}"`).join(', ');
    }

    let sql = `SELECT ${selectCols} FROM ${ref(tableName)}`;
    const params = [];
    let paramIndex = 1;

    if (joins && joins.length > 0) {
      for (const join of joins) {
        const joinTable = join.refTable;
        sql += ` LEFT JOIN ${ref(joinTable)} ON ${ref(tableName)}.${ref(join.foreignKeyColumn)} = ${ref(joinTable)}.${ref(join.primaryKeyColumn)}`;
      }
    }

    const whereClauses = [];
    for (const [key, value] of Object.entries(filters)) {
      const fieldMeta = entity.fields.find(f => f.Field.toLowerCase() === key.toLowerCase());
      if (fieldMeta && fieldMeta.query) {
        whereClauses.push(`${ref(fieldMeta.Name)} = $${paramIndex++}`);
        params.push(value);
      }
    }

    if (whereClauses.length > 0) {
      sql += ` WHERE ${whereClauses.join(' AND ')}`;
    }

    if (sortBy) {
      const sortMeta = entity.fields.find(f => f.Field.toLowerCase() === sortBy.toLowerCase());
      const sortCol = sortMeta ? sortMeta.Name : sortBy;
      sql += ` ORDER BY ${ref(sortCol)} ${sortOrder.toUpperCase() === 'DESC' ? 'DESC' : 'ASC'}`;
    } else if (entity.primaryKey) {
      const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === entity.primaryKey.toLowerCase());
      if (pkMeta) {
        sql += ` ORDER BY ${ref(pkMeta.Name)} ASC`;
      }
    }

    if (page && pageSize) {
      const offset = (page - 1) * pageSize;
      sql += ` LIMIT $${paramIndex++} OFFSET $${paramIndex++}`;
      params.push(pageSize, offset);
    }

    return { sql, params };
  }

  buildInsert(entity, data) {
    const tableName = this.getTableName(entity);
    const columns = [];
    const placeholders = [];
    const params = [];
    let paramIndex = 1;

    for (const fieldMeta of entity.fields) {
      const apiField = fieldMeta.Field;
      if (data.hasOwnProperty(apiField)) {
        columns.push(ref(fieldMeta.Name));
        placeholders.push(`$${paramIndex++}`);
        params.push(data[apiField]);
      }
    }

    const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === entity.primaryKey.toLowerCase());
    const pkCol = pkMeta ? pkMeta.Name : entity.primaryKey;

    const sql = `INSERT INTO ${ref(tableName)} (${columns.join(', ')}) VALUES (${placeholders.join(', ')}) RETURNING ${ref(pkCol)}`;
    return { sql, params };
  }

  buildUpdate(entity, id, data) {
    const tableName = this.getTableName(entity);
    const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === entity.primaryKey.toLowerCase());
    const pkCol = pkMeta ? pkMeta.Name : entity.primaryKey;

    const setClauses = [];
    const params = [];
    let paramIndex = 1;

    for (const fieldMeta of entity.fields) {
      const apiField = fieldMeta.Field;
      if (fieldMeta.update && data.hasOwnProperty(apiField)) {
        setClauses.push(`${ref(fieldMeta.Name)} = $${paramIndex++}`);
        params.push(data[apiField]);
      }
    }

    params.push(id);
    const sql = `UPDATE ${ref(tableName)} SET ${setClauses.join(', ')} WHERE ${ref(pkCol)} = $${paramIndex++}`;
    return { sql, params };
  }

  buildDelete(entity, id) {
    const tableName = this.getTableName(entity);
    const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === entity.primaryKey.toLowerCase());
    const pkCol = pkMeta ? pkMeta.Name : entity.primaryKey;

    const sql = `DELETE FROM ${ref(tableName)} WHERE ${ref(pkCol)} = $1`;
    return { sql, params: [id] };
  }

  buildMaxAutonumber(autonumberRule, context = {}) {
    const table = autonumberRule.Table || autonumberRule.Synonym;
    const col = autonumberRule.Column;
    let sql = `SELECT COALESCE(MAX(${ref(col)}), 0) + 1 AS "nextVal" FROM ${ref(table)}`;
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

module.exports = PgSqlBuilder;
