const fs = require('fs');
const path = require('path');
const env = require('../config/env');
const mainApp = require('../config/mainApp');
const connectionPool = require('../core/connectionPool');

// Hard ceiling on rows a caller may request, so a large pageSize cannot be used
// to pull an entire table through the autocomplete endpoint.
const MAX_AUTOCOMPLETE_ROWS = 500;

// Matches either a single-quoted SQL literal or a bare {placeholder}. Scanning
// for both in one pass is what lets us tell "inside a literal" from "not".
const TEMPLATE_TOKEN = /'((?:[^']|'')*)'|\{([A-Za-z_][A-Za-z0-9_]*)\}/g;
const PLACEHOLDER = /\{([A-Za-z_][A-Za-z0-9_]*)\}/g;
const NUMERIC = /^-?\d+(\.\d+)?$/;

/**
 * Collects bind values in the form the driver for `dbType` expects: Oracle binds
 * by name against an object, mysql/postgres positionally against an array.
 * @param {string} dbType
 * @returns {{add: function(*): string, params: function(): (Object|Array)}}
 */
function createBinder(dbType) {
  if (dbType === 'oracle') {
    const values = {};
    let index = 0;
    return {
      add(value) {
        const key = `ac_${++index}`;
        values[key] = value;
        return `:${key}`;
      },
      params: () => values
    };
  }

  const values = [];
  const isPg = dbType === 'postgres' || dbType === 'pg';
  return {
    add(value) {
      values.push(value);
      return isPg ? `$${values.length}` : '?';
    },
    params: () => values
  };
}

/**
 * Rewrites one Conds template into SQL carrying bind placeholders instead of
 * interpolated values.
 *
 * A placeholder sitting inside a quoted literal (`LIKE '%{term}%'`) binds the
 * whole literal, so the wildcards travel with the value rather than the SQL
 * text. A bare placeholder (`stor_id={storId}`) binds on its own.
 *
 * @param {string} template Raw Conds entry, e.g. "Stor_Id={storId}"
 * @param {function(string): *} resolveValue Returns undefined when unsupplied
 * @param {Object} binder From createBinder
 * @returns {string|null} null when a referenced parameter has no value
 */
function compileCondition(template, resolveValue, binder) {
  let missing = false;

  const sql = template.replace(TEMPLATE_TOKEN, (match, literal, bareKey) => {
    if (bareKey !== undefined) {
      const value = resolveValue(bareKey);
      if (value === undefined) {
        missing = true;
        return match;
      }
      return binder.add(value);
    }

    // A quoted literal is only interesting if it actually carries a placeholder.
    PLACEHOLDER.lastIndex = 0;
    if (!PLACEHOLDER.test(literal)) {
      return match;
    }

    let unresolved = false;
    const value = literal
      .replace(PLACEHOLDER, (_, key) => {
        const resolved = resolveValue(key);
        if (resolved === undefined) {
          unresolved = true;
          return '';
        }
        return String(resolved);
      })
      .replace(/''/g, "'"); // doubled quotes are SQL escaping, not part of the value

    if (unresolved) {
      missing = true;
      return match;
    }
    return binder.add(value);
  });

  return missing ? null : sql;
}

class AutocompleteService {
  constructor() {
    this.autocompleteCache = new Map(); // key: "pkg:name"
    this.loadAllAutocompleteMetadata();
  }

  /**
   * Pre-loads all autocomplete JSON files from resources/autocomplete/
   */
  loadAllAutocompleteMetadata() {
    const autocompleteRootDir = path.join(__dirname, '..', 'resources', 'autocomplete');
    if (!fs.existsSync(autocompleteRootDir)) return;

    const packages = fs.readdirSync(autocompleteRootDir);
    for (const pkg of packages) {
      const pkgDir = path.join(autocompleteRootDir, pkg);
      if (fs.statSync(pkgDir).isDirectory()) {
        const files = fs.readdirSync(pkgDir);
        for (const file of files) {
          if (file.endsWith('.json')) {
            const name = path.basename(file, '.json');
            const fullPath = path.join(pkgDir, file);
            try {
              const rawData = fs.readFileSync(fullPath, 'utf8');
              const jsonMeta = JSON.parse(rawData);
              const key = `${pkg.toLowerCase()}:${name.toLowerCase()}`;
              this.autocompleteCache.set(key, jsonMeta);
            } catch (err) {
              console.error(`[AutocompleteService] Error reading ${fullPath}:`, err.message);
            }
          }
        }
      }
    }
    console.log(`[AutocompleteService] Loaded ${this.autocompleteCache.size} autocomplete templates from resources/autocomplete.`);
  }

  /**
   * Retrieves autocomplete metadata by package and name/table
   */
  getMetadata(packageName, name) {
    if (!packageName || !name) return null;

    // 1. Direct cache lookup by package and name (e.g. Acc:Account)
    const key = `${packageName.toLowerCase()}:${name.toLowerCase()}`;
    if (this.autocompleteCache.has(key)) {
      return this.autocompleteCache.get(key);
    }

    // 2. Fallback lookup from mainApp entity metadata
    const entity = mainApp.getEntity(packageName, name) ||
                  mainApp.getEntityBySynonym(name) ||
                  mainApp.getEntityByTable(name);

    if (entity) {
      const table = entity.synonym || entity.tableName;
      return {
        Synonym: table,
        Select: `SELECT Id, Name FROM ${table}`,
        Condition: '',
        Conds: {
          term: `Lower(Name) LIKE '%{term}%'`
        },
        OrderBy: 'Name'
      };
    }

    return null;
  }

  /**
   * Builds the autocomplete statement and its bind values for a dialect.
   *
   * Separated from getAutocomplete so the generated SQL can be asserted against
   * every dialect without a live database.
   *
   * @param {Object} meta Autocomplete template from getMetadata
   * @param {string} name Entity name, used only for the fallback SELECT
   * @param {string} dbType oracle | mysql | postgres
   * @param {Object} queryParams Caller-supplied values
   * @param {Object} context Request context (tenantId, userId, ...)
   * @returns {{sql: string, params: (Object|Array)}}
   */
  buildQuery(meta, name, dbType, queryParams = {}, context = {}) {
    const { Synonym, Select, Condition, Conds, OrderBy } = meta;
    const table = Synonym || name;
    const binder = createBinder(dbType);

    let baseSql = Select || `SELECT Id, Name FROM ${table}`;
    const whereClauses = [];

    // Base condition. Comes from the metadata template, never from the request.
    if (Condition && Condition.trim()) {
      whereClauses.push(`(${Condition.trim()})`);
    }

    // Dynamic conditions from the Conds mapping. Values here are caller-supplied,
    // so every one of them is bound rather than pasted into the statement.
    if (Conds && typeof Conds === 'object') {
      const resolveValue = (key) => {
        const raw = queryParams[key] !== undefined ? queryParams[key] : context[key];
        if (raw === undefined || raw === null || String(raw).trim() === '') {
          return undefined;
        }
        const value = String(raw).trim();
        if (key === 'term') {
          return value.toLowerCase();
        }
        // Bind numbers as numbers so strict dialects accept them for numeric columns.
        return NUMERIC.test(value) ? Number(value) : value;
      };

      for (const template of Object.values(Conds)) {
        const condSql = compileCondition(template, resolveValue, binder);
        if (condSql !== null) {
          whereClauses.push(`(${condSql})`);
        }
      }
    }

    // Assemble SQL
    let finalSql = baseSql;
    if (whereClauses.length > 0) {
      if (/WHERE/i.test(finalSql)) {
        finalSql += ` AND ${whereClauses.join(' AND ')}`;
      } else {
        finalSql += ` WHERE ${whereClauses.join(' AND ')}`;
      }
    }

    // Order By
    if (OrderBy && OrderBy.trim()) {
      finalSql += ` ORDER BY ${OrderBy.trim()}`;
    }

    // Limit (AUTOCOMPLETE_SIZE, unless the request asks for a specific page size).
    // Anything non-numeric or out of range falls back to the configured default.
    const requested = parseInt(queryParams.pageSize || queryParams.limit, 10);
    const limit = Number.isInteger(requested) && requested > 0
      ? Math.min(requested, MAX_AUTOCOMPLETE_ROWS)
      : env.autocompleteSize;

    if (dbType === 'oracle') {
      finalSql += ` FETCH NEXT ${limit} ROWS ONLY`;
    } else {
      finalSql += ` LIMIT ${limit}`;
    }

    return { sql: finalSql, params: binder.params() };
  }

  /**
   * Executes autocomplete query for a package entity with runtime params and tenant context.
   */
  async getAutocomplete(packageName, name, queryParams = {}, context = {}) {
    const meta = this.getMetadata(packageName, name);
    if (!meta) {
      throw new Error(`Autocomplete metadata not found for ${packageName}/${name}`);
    }

    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);

    const { sql, params } = this.buildQuery(meta, name, poolWrapper.dbType, queryParams, context);

    // Execute query
    const rows = await poolWrapper.query(sql, params);

    // Map to camelCase
    const mapToCamelCase = (data) => {
      if (!data) return data;
      if (Array.isArray(data)) return data.map(item => mapToCamelCase(item));
      if (typeof data === 'object') {
        const result = {};
        for (const key in data) {
          if (Object.prototype.hasOwnProperty.call(data, key)) {
            const newKey = key.toLowerCase().replace(/_([a-z0-9])/g, (g) => g[1].toUpperCase());
            result[newKey] = data[key];
          }
        }
        return result;
      }
      return data;
    };

    return mapToCamelCase(rows);
  }
}

module.exports = new AutocompleteService();