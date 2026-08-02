const connectionPool = require('../core/connectionPool');
const sqlBuilder = require('../core/sqlBuilder');

class UnifiedRepository {
  /**
   * Selects records from DB.
   */
  async find(entity, options = {}, context = {}) {
    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);
    const dbType = poolWrapper.dbType;

    const { sql, params } = sqlBuilder.buildSelect(dbType, entity, options);
    const rows = await poolWrapper.query(sql, params);
    return rows;
  }

  /**
   * Finds single record by Primary Key.
   */
  async findById(entity, id, context = {}) {
    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);
    const dbType = poolWrapper.dbType;

    const filters = {};
    filters[entity.primaryKey] = id;

    const { sql, params } = sqlBuilder.buildSelect(dbType, entity, { filters, page: 1, pageSize: 1 });
    const rows = await poolWrapper.query(sql, params);
    return rows && rows.length > 0 ? rows[0] : null;
  }

  /**
   * Inserts single record (supports existing active transaction connection).
   */
  async insert(entity, data, context = {}, activeConn = null) {
    const tenantId = context.tenantId || 'default';
    const poolWrapper = activeConn ? null : await connectionPool.getPool(tenantId);
    const dbType = activeConn ? context.dbType : poolWrapper.dbType;
    const dbRunner = activeConn || poolWrapper;

    const { sql, params } = sqlBuilder.buildInsert(dbType, entity, data);
    const result = await dbRunner.query(sql, params);

    // Get inserted ID
    let insertedId = data[entity.primaryKey];
    if (!insertedId && result) {
      if (Array.isArray(result) && result.length > 0 && result[0][entity.primaryKey]) {
        insertedId = result[0][entity.primaryKey];
      } else if (result.insertId) {
        insertedId = result.insertId;
      }
    }

    return { insertedId, result };
  }

  /**
   * Updates record by ID (supports active transaction connection).
   */
  async update(entity, id, data, context = {}, activeConn = null) {
    const tenantId = context.tenantId || 'default';
    const poolWrapper = activeConn ? null : await connectionPool.getPool(tenantId);
    const dbType = activeConn ? context.dbType : poolWrapper.dbType;
    const dbRunner = activeConn || poolWrapper;

    const { sql, params } = sqlBuilder.buildUpdate(dbType, entity, id, data);
    const result = await dbRunner.query(sql, params);
    return result;
  }

  /**
   * Deletes record by ID (supports active transaction connection).
   */
  async delete(entity, id, context = {}, activeConn = null) {
    const tenantId = context.tenantId || 'default';
    const poolWrapper = activeConn ? null : await connectionPool.getPool(tenantId);
    const dbType = activeConn ? context.dbType : poolWrapper.dbType;
    const dbRunner = activeConn || poolWrapper;

    const { sql, params } = sqlBuilder.buildDelete(dbType, entity, id);
    const result = await dbRunner.query(sql, params);
    return result;
  }
}

module.exports = new UnifiedRepository();
