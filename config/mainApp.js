const fs = require('fs');
const path = require('path');

class MainApp {
  constructor() {
    if (MainApp.instance) {
      return MainApp.instance;
    }

    this.metadataByPackageAndTable = new Map(); // key: "package:tableName"
    this.metadataBySynonym = new Map();         // key: synonym
    this.metadataByTable = new Map();           // key: tableName
    this.packages = new Map();                  // key: packageName -> Set of tableNames
    this.isLoaded = false;

    MainApp.instance = this;
  }

  /**
   * Normalizes entity schema to ensure uniform property keys across legacy Java JSONs, autocomplete JSONs, and new schema specs.
   * @param {Object} raw Metadata object loaded from JSON
   * @param {string} defaultPkg Inferred package name from directory
   * @param {string} filename File name without extension
   * @returns {Object} Normalized metadata
   */
  normalizeMetadata(raw, defaultPkg, filename = '') {
    const pkg = raw.package || raw.Pkg || defaultPkg || 'Default';
    const tableName = raw.tableName || raw.Name || raw.Table || raw.Synonym || filename;
    const synonym = raw.synonym || raw.Synonym || tableName;
    const primaryKey = (raw.primaryKey || raw.PrimaryKey || 'id').toLowerCase();

    /**
     * Whether the server assigns this entity's primary key.
     *
     * `AutoIncrement` declares that intent and `Sequence` names where the value
     * comes from, but nothing read either flag: `isAutonumber` was only ever
     * true if a column declared it, and no column does. `unifiedService.create`
     * skips a field that is not marked, so the key went in as whatever the
     * client happened to send -- 0 from a create form. Tables seeded with a
     * placeholder row at id 0 (Fund_Item, Fund_Dept) then failed the very first
     * save with a primary-key violation, and every other table failed on the
     * second.
     *
     * Marking the key field is all it takes: AutoNumberHelper already reads an
     * Oracle or Postgres sequence when one is named, and falls back to MAX + 1
     * where the dialect has none.
     */
    const assignsOwnKey = raw.AutoIncrement === true || raw.autoIncrement === true;

    // Standardize fields/Columns array
    const rawFields = raw.fields || raw.Columns || [];
    const fields = rawFields.map(f => {
      const fieldName = f.Field || f.field || f.Name;
      const colName = f.Name || f.Column || fieldName;
      const dbType = f.DBType || f.dbType || 'VARCHAR2';
      const type = f.Type || f.type || 'String';

      const isAutonumber = f.isAutonumber !== undefined
        ? f.isAutonumber
        : (assignsOwnKey && String(fieldName).toLowerCase() === primaryKey);

      return {
        Name: colName,
        Field: fieldName,
        DBType: dbType,
        Type: type,
        Short: f.Short || type,
        Scale: f.Scale || '0',
        Precision: f.Precision || '0',
        Default: f.Default !== undefined ? f.Default : '',
        query: f.query !== undefined ? f.query : true,
        insert: f.insert !== undefined ? f.insert : true,
        update: f.update !== undefined ? f.update : true,
        hasRelation: f.hasRelation !== undefined ? f.hasRelation : false,
        isAutonumber,
        Autonumber: f.Autonumber || (raw.Sequence ? {
          Mode: isAutonumber ? (raw.PeriodCondition ? '11' : '1') : '1',
          Aggr: 'Max',
          Column: colName,
          Synonym: synonym,
          Sequence: raw.Sequence,
          Condition: raw.Condition || '',
          PeriodCondition: raw.PeriodCondition || ''
        } : null),
        isFile: f.isFile || false,
        isNull: f.isNull !== undefined ? f.isNull : true,
        relation: f.relation || f.Relation || null
      };
    });

    // Standardize children/Children array
    const rawChildren = raw.children || raw.Children || [];
    const children = rawChildren.map(c => ({
      childKey: c.childKey || c.ChildKey || 'children',
      pkg: c.pkg || c.Pkg || pkg,
      table: c.table || c.Table || c.Key,
      synonym: c.synonym || c.Synonym,
      foreignKey: c.foreignKey || c.ColKey || c.Column || 'mstId',
      cascadeDelete: c.cascadeDelete !== undefined ? c.cascadeDelete : true
    }));

    return {
      package: pkg,
      module: raw.module || raw.Module || pkg,
      tableName,
      synonym,
      primaryKey,
      hasChilds: raw.hasChilds !== undefined ? raw.hasChilds : (children.length > 0),
      children,
      auditFields: raw.auditFields || {
        createdBy: 'insUser',
        createdAt: 'insDate',
        updatedBy: 'updUser',
        updatedAt: 'updDate'
      },
      fields
    };
  }

  /**
   * Recursively loads all JSON metadata files from given directory or directories.
   * @param {string|string[]} modulesDirs Directory path(s)
   */
  loadMetadata(modulesDirs) {
    const dirs = Array.isArray(modulesDirs) ? modulesDirs : [modulesDirs];

    this.metadataByPackageAndTable.clear();
    this.metadataBySynonym.clear();
    this.metadataByTable.clear();
    this.packages.clear();

    for (const modulesDir of dirs) {
      if (!fs.existsSync(modulesDir)) {
        console.warn(`[MainApp] Modules directory does not exist: ${modulesDir}`);
        continue;
      }

      const readDirRecursive = (dir, currentPkg = '') => {
        const entries = fs.readdirSync(dir, { withFileTypes: true });

        for (const entry of entries) {
          const fullPath = path.join(dir, entry.name);
          if (entry.isDirectory()) {
            const nextPkg = (dir === modulesDir || !currentPkg) ? entry.name : currentPkg;
            readDirRecursive(fullPath, nextPkg);
          } else if (entry.isFile() && entry.name.endsWith('.json')) {
            try {
              const rawData = fs.readFileSync(fullPath, 'utf8');
              const rawMetadata = JSON.parse(rawData);
              const filename = path.basename(entry.name, '.json');
              const normalized = this.normalizeMetadata(rawMetadata, currentPkg, filename);
              this.registerEntity(normalized, fullPath);
            } catch (err) {
              console.error(`[MainApp] Error loading metadata from ${fullPath}:`, err.message);
            }
          }
        }
      };

      readDirRecursive(modulesDir);
    }

    this.isLoaded = true;
    console.log(`[MainApp] Metadata loaded successfully. Registered ${this.metadataByPackageAndTable.size} entities across ${this.packages.size} packages.`);
  }

  /**
   * How much authority a metadata file has over an entity name it shares.
   *
   * A package declares the same entity name in several role folders --
   * Fund/Boxes exists under models/, import/, export/, reports/ and
   * autocomplete/ -- and all of them normalise to the same registry key. Only
   * some carry the column list: models/ and import/ use `Columns`, while
   * reports/ and export/ use a `Fields` array of a different shape and
   * autocomplete/ carries only a SELECT. Registration used to be an
   * unconditional overwrite, so whichever file the directory walk reached last
   * won -- alphabetically reports/ -- and the entity ended up registered with
   * no columns at all. `validatePayload` builds its allowed-field map from that
   * list, so every create and update failed with "Field 'x' is not defined in
   * metadata", and `reportService.toReport` produced reports with no fields.
   *
   * A definition that actually carries columns therefore outranks one that does
   * not, and among those that do, models/ is the canonical entity definition --
   * import/ commonly lists only the subset an import file supplies. Files that
   * tie keep last-one-wins, which is the behaviour everything else had.
   */
  static rankOf(metadata, sourcePath) {
    const ROLE_PRIORITY = { models: 3, import: 2 };
    const role = path.basename(path.dirname(sourcePath || '')).toLowerCase();
    const hasFields = Array.isArray(metadata.fields) && metadata.fields.length > 0;

    return (hasFields ? 100 : 0) + (ROLE_PRIORITY[role] || 1);
  }

  registerEntity(metadata, sourcePath) {
    const pkg = metadata.package;
    const table = metadata.tableName;
    const synonym = metadata.synonym;
    const filename = path.basename(sourcePath, '.json');

    if (!pkg || !table) {
      console.warn(`[MainApp] Invalid metadata format in ${sourcePath}: missing package or tableName`);
      return;
    }

    // Recorded on the entity so a later registration can compare against it,
    // and so the source of a surprising definition is visible when debugging.
    metadata.sourcePath = sourcePath;
    metadata.sourceRank = MainApp.rankOf(metadata, sourcePath);

    /** Registers under one key unless a stronger definition already holds it. */
    const claim = (map, mapKey) => {
      const existing = map.get(mapKey);
      if (existing && (existing.sourceRank || 0) > metadata.sourceRank) {
        return;
      }
      map.set(mapKey, metadata);
    };

    const key = `${pkg.toLowerCase()}:${table.toLowerCase()}`;
    const fileKey = `${pkg.toLowerCase()}:${filename.toLowerCase()}`;

    claim(this.metadataByPackageAndTable, key);
    claim(this.metadataByPackageAndTable, fileKey);

    claim(this.metadataByTable, table.toLowerCase());
    claim(this.metadataByTable, filename.toLowerCase());

    if (synonym) {
      claim(this.metadataBySynonym, synonym.toLowerCase());
    }

    if (!this.packages.has(pkg)) {
      this.packages.set(pkg, new Set());
    }
    // Store filename instead of tableName in packages for cleaner API endpoints
    this.packages.get(pkg).add(filename);
  }

  getEntity(packageName, tableName) {
    if (!packageName || !tableName) return null;
    const pkgLower = packageName.toLowerCase();
    const tableLower = tableName.toLowerCase();

    // 1. Direct package:table lookup (e.g. Acc:Acc_Master or Acc:Master)
    let key = `${pkgLower}:${tableLower}`;
    if (this.metadataByPackageAndTable.has(key)) {
      return this.metadataByPackageAndTable.get(key);
    }

    // 2. Prepend package name if omitted (e.g. Acc:Master -> Acc:Acc_Master)
    key = `${pkgLower}:${pkgLower}_${tableLower}`;
    if (this.metadataByPackageAndTable.has(key)) {
      return this.metadataByPackageAndTable.get(key);
    }

    // 3. Lookup by Synonym (e.g. Acc_Mst)
    const bySynonym = this.getEntityBySynonym(tableName);
    if (bySynonym) return bySynonym;

    // 4. Lookup by Table Name or package-prefixed Table Name
    const byTable = this.getEntityByTable(tableName) || this.getEntityByTable(`${pkgLower}_${tableLower}`);
    if (byTable) return byTable;

    return null;
  }

  getEntityBySynonym(synonym) {
    if (!synonym) return null;
    return this.metadataBySynonym.get(synonym.toLowerCase()) || null;
  }

  getEntityByTable(tableName) {
    if (!tableName) return null;
    return this.metadataByTable.get(tableName.toLowerCase()) || null;
  }


  getAllPackages() {
    return Array.from(this.packages.keys());
  }

  getTablesInPackage(packageName) {
    const tableSet = this.packages.get(packageName);
    return tableSet ? Array.from(tableSet) : [];
  }

  getMetadataTree() {
    const tree = {};
    for (const [pkg, tables] of this.packages.entries()) {
      tree[pkg] = {};
      for (const table of tables) {
        tree[pkg][table] = this.getEntity(pkg, table);
      }
    }
    return tree;
  }
}

const mainAppInstance = new MainApp();
module.exports = mainAppInstance;
