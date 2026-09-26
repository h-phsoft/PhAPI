const connectionPool = require('../core/connectionPool');
const sqlBuilder = require('../core/query');
const { shapeDates } = require('../core/types/dates');

/**
 * The name a column is known by, worked out once per entity and cached against
 * it. The entity is a singleton built at startup.
 *
 * key: entity -> Map of lower-cased spelling -> the name the entity declares
 */
const canonicalNames = new WeakMap();

function canonicalFor(entity) {
  if (!entity) {
    return null;
  }

  const cached = canonicalNames.get(entity);
  if (cached) {
    return cached;
  }

  const names = new Map();
  for (const field of (entity.fields || [])) {
    if (field.Field) {
      names.set(String(field.Field).toLowerCase(), field.Field);
    }
  }

  canonicalNames.set(entity, names);
  return names;
}

class UnifiedRepository {
  /**
   * Turns whatever the driver returned into the names the entity declares.
   *
   * The drivers disagree about a column alias. Oracle preserves a quoted one
   * and folds an unquoted one to upper case; MySQL and PostgreSQL preserve
   * theirs. So the same statement yields `specialId`, `SPECIALID` or
   * `special_id` depending on the tenant's database, and none of those is what
   * the rest of the system reads rows by.
   *
   * The entity settles it. A key that matches a declared field in any casing
   * becomes that field's own spelling (M1 -- the metadata is authoritative for
   * what a column is), which is exact rather than a guess and is the same on
   * every engine.
   *
   * It used to lower-case every key and then camel-case back across the
   * underscores, which is right for `SPECIAL_ID` and destructive for
   * `specialId`: with no underscore left to camel-case across, 18157 of 24553
   * fields -- 74% -- arrived under a flattened name. Two things above here read
   * a row by the name the entity declares and so found nothing:
   *
   *   `shapeDates` never shaped 2508 of the 3168 date and time columns, which
   *   is how a DATE reached a client as `1995-08-31T21:00:00.000Z` with a
   *   timezone the column never had (D4);
   *   `presentation/labels` never translated 9 of the 125 columns marked
   *   isLabel, among them every name in Phs_Miprograms_View.
   *
   * A key the entity does not declare -- an aggregate, a computed column, a
   * raw query's own alias -- keeps the old treatment, which is the best that
   * can be done without something to check it against.
   *
   * @param {Object|Array} data Rows as the driver returned them
   * @param {Object} [entity] Entity metadata; without it, the old heuristic
   * @returns {Object|Array}
   */
  mapToCamelCase(data, entity = null) {
    const canonical = canonicalFor(entity);
    return this.renameKeys(data, canonical);
  }

  /** @param {Map|null} canonical Lower-cased spelling to declared name */
  renameKeys(data, canonical) {
    if (!data) {
      return data;
    }
    if (Array.isArray(data)) {
      return data.map(item => this.renameKeys(item, canonical));
    }
    if (typeof data === 'object') {
      const result = {};
      for (const key in data) {
        if (!Object.prototype.hasOwnProperty.call(data, key)) {
          continue;
        }
        const declared = canonical && canonical.get(String(key).toLowerCase());
        result[declared || UnifiedRepository.apiName(key)] = data[key];
      }
      return result;
    }
    return data;
  }

  /**
   * The API name for a key the entity does not declare.
   *
   * An aggregate's alias, a computed column, a raw query's own naming. Three
   * cases, and telling them apart is what the old single rule could not do:
   *
   *   `SPECIAL_ID`  a database name -- lower-cased and camel-cased across the
   *                 underscores, which is what it was always for;
   *   `BLOCKURL`    an alias Oracle folded to upper case with no underscore
   *                 left to read -- lower-cased, which is the best available
   *                 and what happened before;
   *   `idCount`     an alias a driver preserved. Left exactly as it is: it
   *                 already carries its casing, and there is nothing to
   *                 recover. Lower-casing it is what flattened `specialId` to
   *                 `specialid` on 74% of fields.
   *
   * Oracle folds an unquoted identifier to upper case, so a mixed-case key can
   * only have come from a quoted alias -- which makes it deliberate.
   *
   * @param {string} key
   * @returns {string}
   */
  static apiName(key) {
    const text = String(key);

    if (text.includes('_')) {
      return text.toLowerCase().replace(/_([a-z0-9])/g, (g) => g[1].toUpperCase());
    }
    if (text === text.toUpperCase()) {
      return text.toLowerCase();
    }
    return text;
  }

  /**
   * Selects records from DB.
   */
  async find(entity, options = {}, context = {}) {
    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);
    const dbType = poolWrapper.dbType;

    const { sql, params } = sqlBuilder.buildSelect(dbType, entity, options);
    const rows = await poolWrapper.query(sql, params);
    return shapeDates(entity, this.mapToCamelCase(rows, entity));
  }

  /**
   * Selects records a batch at a time (D5).
   *
   * The same statement find() runs, minus its page: the whole result, up to
   * `limit` rows, is read through the driver in batches and each batch is
   * shaped as find() shapes a page. Memory holds one batch, whatever the
   * result's size. The caller decides the ceiling, because only it knows what
   * the rows are for.
   *
   * @param {Object} entity
   * @param {Object} options As find(); page and pageSize are ignored
   * @param {Object} context
   * @param {number} limit The most rows the statement may return
   * @returns {AsyncGenerator<Array<Object>>} Batches of rows
   */
  async *stream(entity, options = {}, context = {}, limit) {
    // Without one the builder falls back to its default page of 20 rows, which
    // would be an export silently cut to 20.
    if (!Number.isInteger(limit) || limit <= 0) {
      throw new Error(`stream() needs a positive row limit, not ${limit}`);
    }
    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);
    const dbType = poolWrapper.dbType;

    const { sql, params } = sqlBuilder.buildSelect(dbType, entity, { ...options, page: 1, pageSize: limit });
    for await (const rows of poolWrapper.stream(sql, params)) {
      yield shapeDates(entity, this.mapToCamelCase(rows, entity));
    }
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
    return rows && rows.length > 0 ? shapeDates(entity, this.mapToCamelCase(rows[0], entity)) : null;
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
