const fs = require('fs');
const path = require('path');
const mainApp = require('../config/mainApp');
const connectionPool = require('../core/connectionPool');
const ParamBinder = require('../core/paramBinder');

// Matches either a single-quoted literal containing at least one {placeholder}
// (group 1 = its contents), or a bare {placeholder} (group 2 = its name).
// Quoted literals without a placeholder are left alone.
const QUOTED_OR_BARE = /'([^']*\{[A-Za-z0-9_]+\}[^']*)'|\{([A-Za-z0-9_]+)\}/g;
const PLACEHOLDER = /\{([A-Za-z0-9_]+)\}/g;
const NUMERIC = /^-?\d+(\.\d+)?$/;

// Marks where a bind placeholder goes during the two-pass rewrite. Cannot occur
// in a JSON-sourced template.
const SLOT = '\u0000';

const DEFAULT_LIMIT = 50;
const MAX_LIMIT = 500;

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
   * Reads a placeholder's value from the merged request/context lookup.
   * Terms are lowercased to match the Lower(...) wrapping the templates use.
   * @returns {string|null} Trimmed value, or null when not supplied
   */
  resolveValue(name, lookup) {
    const raw = lookup[name];
    if (raw === undefined || raw === null) return null;

    const val = String(raw).trim();
    if (val === '') return null;

    return name === 'term' ? val.toLowerCase() : val;
  }

  /**
   * Rewrites one Conds template into SQL carrying bind placeholders.
   *
   * Templates embed request values two ways: inside a quoted literal
   * (LIKE '%{term}%') or bare (stor_id={storId}). A quoted literal becomes a
   * single bind holding the whole assembled string; a bare placeholder binds
   * its value directly. Values never reach the SQL text either way.
   *
   * Resolution happens in two passes so a clause that turns out to be
   * unresolvable adds nothing to the binder — an orphan bind would desync the
   * positional dialects and make Oracle reject the statement outright.
   *
   * @param {string} template Condition template from the autocomplete JSON
   * @param {Object} lookup Merged context and request parameters
   * @param {ParamBinder} binder Collector for this query's bind values
   * @returns {string|null} SQL fragment, or null if a placeholder had no value
   */
  resolveCondition(template, lookup, binder) {
    const pending = [];
    let unresolved = false;

    const slotted = template.replace(QUOTED_OR_BARE, (match, quoted, bare) => {
      if (unresolved) return match;

      // Quoted literal: substitute inside it, then bind the whole string.
      if (quoted !== undefined) {
        let missing = false;
        const literal = quoted.replace(PLACEHOLDER, (_, name) => {
          const val = this.resolveValue(name, lookup);
          if (val === null) {
            missing = true;
            return '';
          }
          return val;
        });

        if (missing) {
          unresolved = true;
          return match;
        }

        pending.push(literal);
        return SLOT;
      }

      // Bare placeholder: bind the value on its own.
      const val = this.resolveValue(bare, lookup);
      if (val === null) {
        unresolved = true;
        return match;
      }

      pending.push(NUMERIC.test(val) ? Number(val) : val);
      return SLOT;
    });

    if (unresolved) return null;

    const parts = slotted.split(SLOT);
    let sql = parts[0];
    for (let i = 1; i < parts.length; i++) {
      sql += binder.add(pending[i - 1]) + parts[i];
    }

    return sql;
  }

  /**
   * True when the SELECT already carries a WHERE of its own, meaning our
   * clauses have to join onto it with AND.
   *
   * A WHERE nested inside a subquery does not count. Testing the raw text for
   * /WHERE/ mistakes one for the outer query's and appends AND to a statement
   * that has no WHERE at all — a syntax error rather than a wrong result.
   */
  hasTopLevelWhere(sql) {
    let depth = 0;
    let inString = false;

    for (let i = 0; i < sql.length; i++) {
      const ch = sql[i];

      // A doubled '' toggles twice and correctly stays inside the literal.
      if (ch === "'") {
        inString = !inString;
        continue;
      }
      if (inString) continue;

      if (ch === '(') depth++;
      else if (ch === ')') depth--;
      else if (depth === 0 && (ch === 'w' || ch === 'W') && /^where\b/i.test(sql.slice(i))) {
        return true;
      }
    }

    return false;
  }

  /**
   * Clamps the caller-supplied row limit to a sane range.
   */
  resolveLimit(queryParams = {}) {
    const raw = queryParams.pageSize !== undefined ? queryParams.pageSize : queryParams.limit;
    const parsed = parseInt(raw, 10);

    if (!Number.isFinite(parsed) || parsed < 1) return DEFAULT_LIMIT;
    return Math.min(parsed, MAX_LIMIT);
  }

  mapToCamelCase(data) {
    if (!data) return data;
    if (Array.isArray(data)) return data.map(item => this.mapToCamelCase(item));
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
  }

  /**
   * Executes autocomplete query for a package entity with runtime params and tenant context.
   */
  async getAutocomplete(packageName, name, queryParams = {}, context = {}) {
    const meta = this.getMetadata(packageName, name);
    if (!meta) {
      throw new Error(`Autocomplete metadata not found for ${packageName}/${name}`);
    }

    const { Synonym, Select, Condition, Conds, OrderBy } = meta;
    const table = Synonym || name;

    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);
    const dbType = poolWrapper.dbType;
    const binder = new ParamBinder(dbType);

    // Select, Condition and OrderBy come from the template files on disk, not
    // from the request, so they are spliced in as written. Conds is the only
    // part that carries caller input, and every value in it is bound below.
    let finalSql = Select || `SELECT Id, Name FROM ${table}`;
    const whereClauses = [];

    if (Condition && Condition.trim()) {
      whereClauses.push(`(${Condition.trim()})`);
    }

    if (Conds && typeof Conds === 'object') {
      // Request parameters win over context values of the same name.
      const lookup = { ...context, ...queryParams };

      for (const [paramKey, template] of Object.entries(Conds)) {
        // A clause applies only when its own parameter was supplied.
        if (this.resolveValue(paramKey, lookup) === null) continue;

        const resolved = this.resolveCondition(template, lookup, binder);
        if (resolved !== null) {
          whereClauses.push(`(${resolved})`);
        }
      }
    }

    if (whereClauses.length > 0) {
      const joiner = this.hasTopLevelWhere(finalSql) ? 'AND' : 'WHERE';
      finalSql += ` ${joiner} ${whereClauses.join(' AND ')}`;
    }

    if (OrderBy && OrderBy.trim()) {
      finalSql += ` ORDER BY ${OrderBy.trim()}`;
    }

    const limit = this.resolveLimit(queryParams);
    if (dbType === 'oracle') {
      finalSql += ` FETCH NEXT ${binder.add(limit)} ROWS ONLY`;
    } else {
      finalSql += ` LIMIT ${binder.add(limit)}`;
    }

    const rows = await poolWrapper.query(finalSql, binder.params);
    return this.mapToCamelCase(rows);
  }
}

module.exports = new AutocompleteService();
