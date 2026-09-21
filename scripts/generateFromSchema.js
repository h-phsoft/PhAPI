#!/usr/bin/env node
/**
 * Generates entity models in resources/modules by reading a live database.
 *
 * This replaces reading db/JSON/pkgs, which was a snapshot of the old Java
 * front end's metadata and has been deleted. The schema is now the source of
 * truth, so a table added to the database is described by running this, and
 * nothing has to be kept in step by hand.
 *
 * Oracle, MySQL and PostgreSQL are all read into one intermediate shape and
 * typed through the same mapping, so the same schema produces the same JSON
 * whichever engine holds it.
 *
 * Existing files are never touched. Everything hand-tuned in them -- an
 * isLabel flag, a display expression like Num||' - '||Name, a child list, a
 * column deliberately exposed under a different name -- would be lost if this
 * rewrote them, and none of it can be read back off a schema. Pass --force
 * only when that is what you want.
 *
 *   node scripts/generateFromSchema.js --tenant demo
 *   node scripts/generateFromSchema.js --tenant demo --dry-run
 *   node scripts/generateFromSchema.js --tenant demo --package Fund
 *   node scripts/generateFromSchema.js --tenant demo --table Fund_Box --force
 */

const fs = require('fs');
const path = require('path');

const connectionPool = require('../core/connectionPool');
const {
  modelFileName,
  restoreCase,
  toFieldName,
  toDisplayFieldName,
  mapColumnType
} = require('./lib/modelNaming');

// ---------------------------------------------------------------------------
// Command line
// ---------------------------------------------------------------------------

/** @returns {Object} Parsed --flags, with bare flags set to true */
function parseArgs(argv) {
  const args = {};
  for (let i = 0; i < argv.length; i++) {
    if (!argv[i].startsWith('--')) {
      continue;
    }
    const key = argv[i].slice(2);
    const next = argv[i + 1];
    if (next && !next.startsWith('--')) {
      args[key] = next;
      i++;
    } else {
      args[key] = true;
    }
  }
  return args;
}

const args = parseArgs(process.argv.slice(2));
const tenant = args.tenant || process.env.GEN_TENANT || 'default';
const dryRun = args['dry-run'] === true || args.dry === true;
const force = args.force === true;
const onlyPackage = typeof args.package === 'string' ? args.package.toLowerCase() : null;
const onlyTable = typeof args.table === 'string' ? args.table.toLowerCase() : null;

/**
 * Where models are written. Pointing this somewhere else is how the output is
 * checked against the curated files without overwriting them: generate a table
 * that already has a model into a scratch directory and diff the two.
 */
const destModulesDir = typeof args.out === 'string'
  ? path.resolve(args.out)
  : path.join(__dirname, '..', 'resources', 'modules');

/**
 * What counts as already described, which is always the real tree even when
 * writing elsewhere -- otherwise --out would regenerate all 935 tables.
 */
const describedRoot = path.join(__dirname, '..', 'resources', 'modules');

// ---------------------------------------------------------------------------
// Reading the schema
// ---------------------------------------------------------------------------

/**
 * Lower-cases a row's keys.
 *
 * Oracle hands back SCREAMING keys, PostgreSQL lower-cases them and MySQL
 * returns them as the query spelled them, so nothing downstream can assume.
 */
function lower(row) {
  const out = {};
  for (const [k, v] of Object.entries(row || {})) {
    out[k.toLowerCase()] = v;
  }
  return out;
}

/** @returns {Promise<Object[]>} Rows with lower-cased keys */
async function rows(pool, sql, params) {
  const result = await pool.query(sql, params || []);
  return (result || []).map(lower);
}

const READERS = {
  /**
   * Oracle, read through the USER_ views: this connects as the schema owner,
   * so USER_ is both the right scope and far faster than ALL_.
   *
   * USER_TAB_COLUMNS covers views as well as tables, which is wanted -- a good
   * third of the models describe a _View.
   */
  async oracle(pool) {
    const columns = await rows(pool, `
      SELECT table_name, column_name, data_type, data_precision, data_scale,
             nullable, column_id
        FROM user_tab_columns
       ORDER BY table_name, column_id`);

    const primaryKeys = await rows(pool, `
      SELECT c.table_name, cc.column_name, cc.position
        FROM user_constraints c
        JOIN user_cons_columns cc ON cc.constraint_name = c.constraint_name
       WHERE c.constraint_type = 'P'`);

    const foreignKeys = await rows(pool, `
      SELECT c.table_name, cc.column_name,
             rc.table_name AS ref_table, rcc.column_name AS ref_column
        FROM user_constraints c
        JOIN user_cons_columns cc  ON cc.constraint_name = c.constraint_name
        JOIN user_constraints rc   ON rc.constraint_name = c.r_constraint_name
        JOIN user_cons_columns rcc ON rcc.constraint_name = rc.constraint_name
                                  AND rcc.position = cc.position
       WHERE c.constraint_type = 'R'`);

    const synonyms = await rows(pool, `
      SELECT synonym_name, table_name FROM user_synonyms`);

    const sequences = await rows(pool, `
      SELECT sequence_name FROM user_sequences`);

    return { columns, primaryKeys, foreignKeys, synonyms, sequences, identity: [] };
  },

  async mysql(pool) {
    const columns = await rows(pool, `
      SELECT TABLE_NAME AS table_name, COLUMN_NAME AS column_name,
             DATA_TYPE AS data_type, NUMERIC_PRECISION AS data_precision,
             NUMERIC_SCALE AS data_scale,
             CASE WHEN IS_NULLABLE = 'YES' THEN 'Y' ELSE 'N' END AS nullable,
             ORDINAL_POSITION AS column_id, EXTRA AS extra
        FROM information_schema.COLUMNS
       WHERE TABLE_SCHEMA = DATABASE()
       ORDER BY TABLE_NAME, ORDINAL_POSITION`);

    const primaryKeys = await rows(pool, `
      SELECT TABLE_NAME AS table_name, COLUMN_NAME AS column_name,
             ORDINAL_POSITION AS position
        FROM information_schema.KEY_COLUMN_USAGE
       WHERE TABLE_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'PRIMARY'`);

    const foreignKeys = await rows(pool, `
      SELECT TABLE_NAME AS table_name, COLUMN_NAME AS column_name,
             REFERENCED_TABLE_NAME AS ref_table, REFERENCED_COLUMN_NAME AS ref_column
        FROM information_schema.KEY_COLUMN_USAGE
       WHERE TABLE_SCHEMA = DATABASE() AND REFERENCED_TABLE_NAME IS NOT NULL`);

    // No synonyms and no standalone sequences; AUTO_INCREMENT plays that part.
    const identity = columns
      .filter((c) => String(c.extra || '').toLowerCase().includes('auto_increment'))
      .map((c) => ({ table_name: c.table_name, column_name: c.column_name }));

    return { columns, primaryKeys, foreignKeys, synonyms: [], sequences: [], identity };
  },

  async postgres(pool) {
    const columns = await rows(pool, `
      SELECT table_name, column_name, data_type,
             numeric_precision AS data_precision, numeric_scale AS data_scale,
             CASE WHEN is_nullable = 'YES' THEN 'Y' ELSE 'N' END AS nullable,
             ordinal_position AS column_id,
             is_identity, column_default
        FROM information_schema.columns
       WHERE table_schema = current_schema()
       ORDER BY table_name, ordinal_position`);

    const primaryKeys = await rows(pool, `
      SELECT tc.table_name, kcu.column_name, kcu.ordinal_position AS position
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON kcu.constraint_name = tc.constraint_name
         AND kcu.table_schema = tc.table_schema
       WHERE tc.constraint_type = 'PRIMARY KEY'
         AND tc.table_schema = current_schema()`);

    const foreignKeys = await rows(pool, `
      SELECT tc.table_name, kcu.column_name,
             ccu.table_name AS ref_table, ccu.column_name AS ref_column
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON kcu.constraint_name = tc.constraint_name
         AND kcu.table_schema = tc.table_schema
        JOIN information_schema.constraint_column_usage ccu
          ON ccu.constraint_name = tc.constraint_name
         AND ccu.table_schema = tc.table_schema
       WHERE tc.constraint_type = 'FOREIGN KEY'
         AND tc.table_schema = current_schema()`);

    const sequences = await rows(pool, `
      SELECT sequence_name FROM information_schema.sequences
       WHERE sequence_schema = current_schema()`);

    const identity = columns
      .filter((c) => String(c.is_identity || '').toUpperCase() === 'YES'
        || /nextval\(/i.test(String(c.column_default || '')))
      .map((c) => ({ table_name: c.table_name, column_name: c.column_name }));

    return { columns, primaryKeys, foreignKeys, synonyms: [], sequences, identity };
  }
};

// ---------------------------------------------------------------------------
// Turning a schema into models
// ---------------------------------------------------------------------------

/**
 * Which package directory a table belongs in.
 *
 * Read from the files already on disk rather than guessed, because the prefix
 * and the directory disagree for two of the 26 packages: Sal_ lives in Sales/
 * and Copy_ in Cpy/. A prefix nothing has claimed becomes its own package,
 * which is what should happen for a module that did not exist before.
 *
 * @returns {{ byPrefix: Map<string,string>, byTable: Map<string,string> }}
 */
function learnPackages() {
  const byPrefix = new Map();
  const byTable = new Map();

  if (!fs.existsSync(describedRoot)) {
    return { byPrefix, byTable };
  }

  for (const pkg of fs.readdirSync(describedRoot)) {
    const dir = path.join(describedRoot, pkg);
    if (!fs.statSync(dir).isDirectory()) {
      continue;
    }
    for (const file of fs.readdirSync(dir)) {
      if (!file.endsWith('.json')) {
        continue;
      }
      try {
        const meta = JSON.parse(fs.readFileSync(path.join(dir, file), 'utf8'));
        const table = meta.tableName || meta.Name;
        if (!table) {
          continue;
        }
        byTable.set(String(table).toLowerCase(), pkg);
        const prefix = String(table).split('_')[0].toLowerCase();
        if (!byPrefix.has(prefix)) {
          byPrefix.set(prefix, pkg);
        }
      } catch {
        // A file that cannot be parsed teaches nothing.
      }
    }
  }

  return { byPrefix, byTable };
}

/** Title-cases a prefix for a package directory nobody has created yet. */
function packageFor(tableName, learned) {
  const known = learned.byTable.get(tableName.toLowerCase());
  if (known) {
    return known;
  }

  const prefix = tableName.split('_')[0];
  const byPrefix = learned.byPrefix.get(prefix.toLowerCase());
  if (byPrefix) {
    return byPrefix;
  }

  return prefix.charAt(0).toUpperCase() + prefix.slice(1).toLowerCase();
}

/**
 * Columns that carry a foreign key in the database but are not modelled as a
 * relation.
 *
 * Almost every table constrains Ins_User and Upd_User against Copy_Users, so
 * reading constraints alone would add a relation to 1595 columns and expose an
 * insUserName on every entity. The convention says otherwise: of those 1595,
 * exactly 3 declare one. Who touched a row is audit, not a lookup a screen
 * displays.
 */
const AUDIT_COLUMNS = new Set(['ins_user', 'upd_user', 'ins_date', 'upd_date']);

/**
 * The audit stamps, as `auditFields` names them, which are kept to the second.
 */
const AUDIT_TIMESTAMPS = new Set(['insdate', 'upddate']);

/**
 * Assembles the model JSON for one table.
 *
 * @param {Object} table The gathered schema for this table
 * @param {Object} ctx Cross-table lookups: synonyms, sequences, other tables
 * @returns {Object} The model, in the shape resources/modules holds
 */
function buildModel(table, ctx) {
  const pkg = packageFor(table.name, ctx.learned);
  const synonym = ctx.synonymOf.get(table.name.toLowerCase()) || table.name;

  // A sequence is looked up rather than assumed: the naming is <synonym>_Seq
  // for 976 of the 983 models that have one, and the other seven are only
  // findable by asking the database.
  const sequence = ctx.sequenceFor(synonym, table.name);

  const pkColumns = (ctx.primaryKeyOf.get(table.name.toLowerCase()) || []);
  const pkColumn = pkColumns.length === 1 ? pkColumns[0] : (pkColumns[0] || null);
  const primaryKey = pkColumn ? toFieldName(pkColumn) : 'id';

  const fkByColumn = new Map();
  for (const fk of (ctx.foreignKeysOf.get(table.name.toLowerCase()) || [])) {
    fkByColumn.set(String(fk.column).toLowerCase(), fk);
  }

  const identity = ctx.identityOf.get(table.name.toLowerCase()) || new Set();

  const fields = table.columns.map((col) => {
    const shape = mapColumnType(col.dataType, col.precision, col.scale);
    const fieldName = toFieldName(col.name);

    // An audit stamp records when a row was touched, so it keeps its hour.
    // Oracle spells the column DATE either way -- it has no DATETIME -- and
    // the declaration here is what decides the format, so it is made
    // explicitly rather than inferred again at every use.
    if (shape.DBType === 'DATE' && AUDIT_TIMESTAMPS.has(fieldName.toLowerCase())) {
      shape.DBType = 'DATETIME';
    }
    const fk = fkByColumn.get(String(col.name).toLowerCase());

    let relation = null;
    if (fk && !AUDIT_COLUMNS.has(String(col.name).toLowerCase())) {
      const refTable = ctx.tableByName.get(String(fk.refTable).toLowerCase());
      relation = {
        refTable: refTable ? refTable.name : fk.refTable,
        refSynonym: ctx.synonymOf.get(String(fk.refTable).toLowerCase()) || fk.refTable,
        primaryKey: fk.refColumn,
        foreignKey: col.name,
        // A schema cannot say which column a user should see, so the
        // convention is applied: Name where the referenced table has one,
        // otherwise its first text column. Expressions such as
        // Num||' - '||Name exist in 100 hand-tuned models and are not
        // inferable; they are added afterwards.
        displayField: refTable ? ctx.displayColumnOf(refTable) : 'Name',
        apiDisplayField: toDisplayFieldName(fieldName)
      };
    }

    // Marked on the key when the database will supply the value, which is what
    // AutoNumberHelper looks for before falling back to MAX + 1.
    const isAutonumber = (pkColumn !== null
      && String(col.name).toLowerCase() === String(pkColumn).toLowerCase()
      && (identity.has(String(col.name).toLowerCase()) || Boolean(sequence)));

    return {
      Name: col.name,
      Field: fieldName,
      DBType: shape.DBType,
      Type: shape.Type,
      Short: shape.Short,
      Scale: shape.Scale,
      Precision: shape.Precision,
      Default: '',
      query: true,
      insert: true,
      update: true,
      hasRelation: relation !== null,
      isAutonumber,
      Autonumber: {
        Mode: '1',
        Aggr: 'Max',
        Column: col.name,
        Synonym: synonym,
        Sequence: sequence || '',
        Condition: '',
        PeriodCondition: ''
      },
      isFile: shape.DBType === 'BLOB',
      isNull: col.nullable,
      // Only a text column can hold system vocabulary, and whether it does
      // cannot be read off a schema -- a code table's Name and a person's Name
      // are the same column. Off by default; turned on by hand.
      ...(shape.DBType === 'VARCHAR2' ? { isLabel: false } : {}),
      relation
    };
  });

  const children = ctx.childrenOf(table);

  return {
    package: pkg,
    module: pkg,
    tableName: table.name,
    synonym,
    primaryKey,
    hasChilds: children.length > 0,
    children,
    auditFields: {
      createdBy: 'insUser',
      createdAt: 'insDate',
      updatedBy: 'updUser',
      updatedAt: 'updDate'
    },
    fields
  };
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  console.log('--- Generating entity models from the database schema ---');
  console.log(`  tenant: ${tenant}${dryRun ? '   (dry run)' : ''}`);

  const poolWrapper = await connectionPool.getPool(tenant);
  const dbType = String(poolWrapper.dbType || '').toLowerCase();
  const read = READERS[dbType] || (dbType === 'postgresql' || dbType === 'pg' ? READERS.postgres : null);

  if (!read) {
    throw new Error(`No schema reader for dbType '${poolWrapper.dbType}'`);
  }

  console.log(`  engine: ${dbType}`);

  const schema = await read(poolWrapper);

  if (!schema.columns.length) {
    console.error('\n  The schema came back empty. Is --tenant pointing at the copy that holds the tables?');
    return;
  }

  // Gather columns per table.
  const tableByName = new Map();
  for (const c of schema.columns) {
    const name = c.table_name;
    const key = String(name).toLowerCase();
    if (!tableByName.has(key)) {
      tableByName.set(key, { name: restoreCase(name), columns: [] });
    }
    tableByName.get(key).columns.push({
      name: restoreCase(c.column_name),
      dataType: c.data_type,
      precision: c.data_precision === null || c.data_precision === undefined ? null : Number(c.data_precision),
      scale: c.data_scale === null || c.data_scale === undefined ? null : Number(c.data_scale),
      nullable: String(c.nullable).toUpperCase() !== 'N'
    });
  }

  const primaryKeyOf = new Map();
  for (const pk of schema.primaryKeys) {
    const key = String(pk.table_name).toLowerCase();
    if (!primaryKeyOf.has(key)) {
      primaryKeyOf.set(key, []);
    }
    primaryKeyOf.get(key)[Number(pk.position || 1) - 1] = restoreCase(pk.column_name);
  }

  const foreignKeysOf = new Map();
  for (const fk of schema.foreignKeys) {
    const key = String(fk.table_name).toLowerCase();
    if (!foreignKeysOf.has(key)) {
      foreignKeysOf.set(key, []);
    }
    foreignKeysOf.get(key).push({
      column: restoreCase(fk.column_name),
      refTable: restoreCase(fk.ref_table),
      refColumn: restoreCase(fk.ref_column)
    });
  }

  const synonymOf = new Map();
  for (const s of schema.synonyms) {
    // A table can carry several synonyms; the first is as good as any, and the
    // models only ever record one.
    const key = String(s.table_name).toLowerCase();
    if (!synonymOf.has(key)) {
      synonymOf.set(key, restoreCase(s.synonym_name));
    }
  }

  const sequenceNames = new Map();
  for (const s of schema.sequences) {
    sequenceNames.set(String(s.sequence_name).toLowerCase(), restoreCase(s.sequence_name));
  }

  const identityOf = new Map();
  for (const i of schema.identity) {
    const key = String(i.table_name).toLowerCase();
    if (!identityOf.has(key)) {
      identityOf.set(key, new Set());
    }
    identityOf.get(key).add(String(i.column_name).toLowerCase());
  }

  const learned = learnPackages();

  const ctx = {
    learned,
    tableByName,
    primaryKeyOf,
    foreignKeysOf,
    synonymOf,
    identityOf,

    sequenceFor(synonym, tableName) {
      for (const candidate of [`${synonym}_Seq`, `${tableName}_Seq`]) {
        const hit = sequenceNames.get(candidate.toLowerCase());
        if (hit) {
          return hit;
        }
      }
      return null;
    },

    /** Name where there is one, else the first text column, else Id. */
    displayColumnOf(table) {
      const named = table.columns.find((c) => String(c.name).toLowerCase() === 'name');
      if (named) {
        return named.name;
      }
      const text = table.columns.find((c) => mapColumnType(c.dataType, c.precision, c.scale).DBType === 'VARCHAR2');
      return text ? text.name : 'Id';
    },

    /**
     * The one child relationship a schema states plainly: a table whose
     * Mst_Id points here is that master's detail.
     *
     * The 135 models that carry children use 15 different childKeys and 70
     * different foreign keys, so the rest is a modelling decision made by
     * hand, not something to guess at.
     */
    childrenOf(table) {
      const out = [];
      for (const [, other] of tableByName) {
        if (other === table) {
          continue;
        }
        const fks = foreignKeysOf.get(other.name.toLowerCase()) || [];
        const mst = fks.find((f) =>
          String(f.refTable).toLowerCase() === table.name.toLowerCase()
          && String(f.column).toLowerCase() === 'mst_id');

        if (mst) {
          out.push({
            childKey: 'child',
            pkg: packageFor(other.name, learned),
            table: other.name,
            synonym: synonymOf.get(other.name.toLowerCase()) || other.name,
            foreignKey: toFieldName(mst.column),
            cascadeDelete: true
          });
        }
      }
      return out;
    }
  };

  let written = 0;
  let skipped = 0;
  let filtered = 0;
  const created = [];
  const blocked = [];

  // What each package directory already describes, so nothing is written twice
  // under a second name.
  const describedByPkg = new Map();
  const described = (pkg) => {
    if (!describedByPkg.has(pkg)) {
      const dir = path.join(describedRoot, pkg);
      const seen = new Set();
      if (fs.existsSync(dir)) {
        for (const file of fs.readdirSync(dir)) {
          if (!file.endsWith('.json')) {
            continue;
          }
          try {
            const meta = JSON.parse(fs.readFileSync(path.join(dir, file), 'utf8'));
            // Spelled `Name` in the seventeen files still in the older
            // format. Reading only `tableName` made those invisible here, so
            // the table looked undescribed and was generated straight over a
            // file that already described it.
            const described = meta.tableName || meta.Name || meta.Table || meta.Synonym;
            if (described) {
              seen.add(String(described).toLowerCase());
            }
          } catch {
            // Unparseable describes nothing.
          }
        }
      }
      describedByPkg.set(pkg, seen);
    }
    return describedByPkg.get(pkg);
  };

  for (const [key, table] of [...tableByName].sort()) {
    if (onlyTable && key !== onlyTable) {
      filtered++;
      continue;
    }

    const pkg = packageFor(table.name, learned);
    if (onlyPackage && pkg.toLowerCase() !== onlyPackage) {
      filtered++;
      continue;
    }

    const seen = described(pkg);
    if (!force && seen.has(key)) {
      skipped++;
      continue;
    }

    const model = buildModel(table, ctx);
    const dir = path.join(destModulesDir, pkg);
    const dest = path.join(dir, `${modelFileName(table.name, pkg)}.json`);

    // A second guard on the path itself, because matching by table name is
    // only as good as the names agreeing. Stor/NumberOfOverLimit.json declares
    // tableName "Number_Of_OverLimit" while the table is STOR_NUMBER_OF_-
    // OVERLIMIT, so the two never met and the file was written straight over.
    // Names can disagree; a path that already exists cannot be argued with.
    //
    // This also covers a filesystem that ignores case, where writing
    // NumberOfOverlimit.json replaces NumberOfOverLimit.json without either
    // name matching the other.
    if (!force && fs.existsSync(dest)) {
      blocked.push(`${path.relative(path.join(__dirname, '..'), dest)} already exists; ${table.name} not written`);
      skipped++;
      continue;
    }

    if (!dryRun) {
      fs.mkdirSync(dir, { recursive: true });
      fs.writeFileSync(dest, JSON.stringify(model, null, 2), 'utf8');
    }

    seen.add(key);
    written++;
    created.push(path.relative(path.join(__dirname, '..'), dest));
  }

  console.log('');
  console.log(`  tables and views read : ${tableByName.size}`);
  console.log(`  ${dryRun ? 'would write' : 'written'}            : ${written}`);
  console.log(`  already described     : ${skipped}`);
  if (onlyPackage || onlyTable) {
    console.log(`  filtered out          : ${filtered}`);
  }

  if (blocked.length) {
    console.log('');
    console.log(`  held back -- the file exists but its tableName does not match: ${blocked.length}`);
    for (const b of blocked) {
      console.log(`      ${b}`);
    }
  }

  for (const f of created.slice(0, 20)) {
    console.log(`      ${f}`);
  }
  if (created.length > 20) {
    console.log(`      ... and ${created.length - 20} more`);
  }

  if (dryRun) {
    console.log('\n  Dry run. Re-run without --dry-run to write.');
  }
}

main()
  .then(() => connectionPool.closeAll ? connectionPool.closeAll() : null)
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(`\n  Failed: ${err.message}`);
    console.error(err.stack);
    process.exit(1);
  });
