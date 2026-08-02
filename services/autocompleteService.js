const fs = require('fs');
const path = require('path');
const mainApp = require('../config/mainApp');
const connectionPool = require('../core/connectionPool');

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
   * Executes autocomplete query for a package entity with runtime params and tenant context.
   */
  async getAutocomplete(packageName, name, queryParams = {}, context = {}) {
    const meta = this.getMetadata(packageName, name);
    if (!meta) {
      throw new Error(`Autocomplete metadata not found for ${packageName}/${name}`);
    }

    const { Synonym, Select, Condition, Conds, OrderBy } = meta;
    const table = Synonym || name;

    let baseSql = Select || `SELECT Id, Name FROM ${table}`;
    const whereClauses = [];

    // Base condition
    if (Condition && Condition.trim()) {
      whereClauses.push(`(${Condition.trim()})`);
    }

    // Dynamic conditions from Conds mapping
    if (Conds && typeof Conds === 'object') {
      for (const [paramKey, template] of Object.entries(Conds)) {
        let val = queryParams[paramKey] !== undefined ? queryParams[paramKey] : context[paramKey];

        if (val !== undefined && val !== null && String(val).trim() !== '') {
          let condSql = template;
          const cleanVal = String(val).trim().replace(/'/g, "''"); // Basic SQL escape

          if (paramKey === 'term') {
            const termLower = cleanVal.toLowerCase();
            condSql = condSql.replace(/\{term\}/g, termLower);
          } else {
            condSql = condSql.replace(new RegExp(`\\{${paramKey}\\}`, 'g'), cleanVal);
          }

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

    // Limit (e.g. top 50 records)
    const limit = queryParams.pageSize || queryParams.limit || 50;
    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);
    const dbType = poolWrapper.dbType;

    if (dbType === 'oracle') {
      finalSql += ` FETCH NEXT ${parseInt(limit, 10)} ROWS ONLY`;
    } else if (dbType === 'postgres' || dbType === 'pg') {
      finalSql += ` LIMIT ${parseInt(limit, 10)}`;
    } else {
      finalSql += ` LIMIT ${parseInt(limit, 10)}`;
    }

    // Execute query
    const rows = await poolWrapper.query(finalSql);
    return rows;
  }
}

module.exports = new AutocompleteService();