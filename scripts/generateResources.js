/* global __dirname */

/**
 * Superseded, and inert: its source no longer exists.
 *
 * This converted db/JSON/pkgs -- a snapshot of the old Java front end's
 * metadata -- into resources/modules. That tree has been deleted now that
 * every table it described has been carried across, so every run of this ends
 * at "Source directory not found".
 *
 * `generateFromSchema.js` does the same job from a live database, which is a
 * source that cannot drift. Kept only so the conversion is recoverable if
 * db/JSON/pkgs is ever restored from history; it can be deleted otherwise.
 */

const fs = require('fs');
const path = require('path');

const { modelFileName } = require('./lib/modelNaming');

const srcPkgsDir = path.join(__dirname, '..', 'db', 'JSON', 'pkgs');
const destModulesDir = path.join(__dirname, '..', 'resources', 'modules');
const destAutocompleteDir = path.join(__dirname, '..', 'resources', 'autocomplete');

/**
 * Whether to rewrite files that already exist.
 *
 * Off by default, and that is the whole point. These files are edited by hand
 * after they are generated -- translation flags, relation corrections -- and a
 * generator that rewrote them would silently undo that work with no diff to
 * notice. Generation is for what the database has gained, not for what is
 * already described.
 *
 * --force covers the one case the default cannot: a column added to a table
 * that already has a file. It discards hand edits, so it has to be asked for.
 */
const force = process.argv.includes('--force');

/**
 * The tables already described under a package directory, keyed by tableName.
 *
 * Indexed by table rather than by filename because the two disagree: the files
 * already there are named after the source model (CodeStatus.json) while this
 * script names what it writes after the table (Phs_Code_Status.json).
 * Comparing paths therefore matches nothing and rewrites every table under a
 * second name, which is how 985 duplicates appear beside 781 originals.
 *
 * @param {string} dir A package directory under resources/modules
 * @returns {Set<string>} Lower-cased table names
 */
function describedTables(dir) {
  const seen = new Set();

  if (!fs.existsSync(dir)) {
    return seen;
  }

  for (const file of fs.readdirSync(dir)) {
    if (!file.endsWith('.json')) {
      continue;
    }
    try {
      const meta = JSON.parse(fs.readFileSync(path.join(dir, file), 'utf8'));
      // `Name` in the files still in the older format; reading only
      // `tableName` leaves those looking undescribed.
      const described = meta.tableName || meta.Name || meta.Table || meta.Synonym;
      if (described) {
        seen.add(String(described).toLowerCase());
      }
    } catch {
      // A file that cannot be parsed describes nothing; treat the table as new.
    }
  }

  return seen;
}

function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, {recursive: true});
  }
}

/**
 * Normalizes legacy JSON into standardized PhsAPI entity model JSON format.
 */
function normalizeModel(raw, pkgName, filename) {
  const pkg = raw.package || raw.Pkg || pkgName;
  const tableName = raw.tableName || raw.Name || raw.Table || raw.Synonym || filename;
  const synonym = raw.synonym || raw.Synonym || tableName;

  // Infer primaryKey
  let primaryKey = 'id';
  if (raw.primaryKey)
    primaryKey = raw.primaryKey;
  else if (raw.PrimaryKey)
    primaryKey = raw.PrimaryKey;

  const rawFields = raw.fields || raw.Columns || [];
  const fields = rawFields.map(f => {
    const fieldName = f.Field || f.field || f.Name;
    const colName = f.Name || f.Column || fieldName;
    const dbType = f.DBType || f.dbType || 'VARCHAR2';
    const type = f.Type || f.type || 'String';

    let relation = null;
    if (f.relation || f.Relation) {
      const rel = f.relation || f.Relation;
      relation = {
        refTable: rel.refTable || rel.TableName,
        refSynonym: rel.refSynonym || rel.SynonymName,
        primaryKey: rel.primaryKey || rel.RelId || 'id',
        foreignKey: rel.foreignKey || rel.CurId || colName,
        displayField: rel.displayField || rel.RelName,
        apiDisplayField: rel.apiDisplayField || rel.RelField
      };
    }

    let autonumber = null;
    if (f.Autonumber || f.autonumber) {
      const auto = f.Autonumber || f.autonumber;
      autonumber = {
        Mode: auto.Mode || (raw.PeriodCondition ? '11' : '1'),
        Aggr: auto.Aggr || 'Max',
        Column: auto.Column || colName,
        Synonym: auto.Synonym || synonym,
        Sequence: auto.Sequence || raw.Sequence || '',
        Condition: auto.Condition || raw.Condition || '',
        PeriodCondition: auto.PeriodCondition || raw.PeriodCondition || ''
      };
    } else if (f.isAutonumber || raw.Sequence) {
      autonumber = {
        Mode: raw.PeriodCondition ? '11' : '1',
        Aggr: 'Max',
        Column: colName,
        Synonym: synonym,
        Sequence: raw.Sequence || '',
        Condition: raw.Condition || '',
        PeriodCondition: raw.PeriodCondition || ''
      };
    }

    return {
      Name: colName,
      Field: fieldName,
      DBType: dbType,
      Type: type,
      Short: f.Short || type,
      Scale: f.Scale !== undefined ? String(f.Scale) : '0',
      Precision: f.Precision !== undefined ? String(f.Precision) : '0',
      Default: f.Default !== undefined ? String(f.Default) : '',
      query: f.query !== undefined ? f.query : true,
      insert: f.insert !== undefined ? f.insert : true,
      update: f.update !== undefined ? f.update : true,
      hasRelation: f.hasRelation !== undefined ? f.hasRelation : (relation !== null),
      isAutonumber: f.isAutonumber !== undefined ? f.isAutonumber : (autonumber !== null && (colName.toLowerCase() === 'id' || f.isAutonumber === true)),
      Autonumber: autonumber,
      isFile: f.isFile || false,
      isNull: f.isNull !== undefined ? f.isNull : true,

      // Whether this column holds system vocabulary that should be translated
      // on the way out -- Active/Inactive, Yes/No -- rather than text a tenant
      // typed.
      //
      // Emitted only for a VARCHAR2. Going by Type would be wrong: a DATE is
      // typed String here too, so that would mark 1995 date columns as labels.
      //
      // Off for everything generated, because it cannot be read off the schema
      // -- a code table's Name and a person's Name are the same column -- and
      // is turned on by hand.
      ...(dbType === 'VARCHAR2'
        ? { isLabel: f.isLabel !== undefined ? f.isLabel : false }
        : {}),
      relation
    };
  });

  // Infer primaryKey from fields if possible
  const idField = fields.find(f => f.Field.toLowerCase() === 'id' || f.Name.toLowerCase() === 'id');
  if (idField) {
    primaryKey = idField.Field;
  }

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
    hasChilds: raw.hasChilds !== undefined ? raw.hasChilds : (children.length > 0),    children,
    auditFields: raw.auditFields || {
      createdBy: 'insUser',
      createdAt: 'insDate',
      updatedBy: 'updUser',
      updatedAt: 'updDate'
    },
    fields
  };
}

function processAll() {
  console.log('--- Regenerating JSON metadata into resources/ ---');

  if (!fs.existsSync(srcPkgsDir)) {
    console.error(`Source directory not found: ${srcPkgsDir}`);
    return;
  }

  ensureDir(destModulesDir);
  ensureDir(destAutocompleteDir);

  let modelCount = 0;


  let modelSkipped = 0;
  let autocompleteCount = 0;

  let autocompleteSkipped = 0;

  const packages = fs.readdirSync(srcPkgsDir);

  for (const pkg of packages) {
    const pkgPath = path.join(srcPkgsDir, pkg);
    if (!fs.statSync(pkgPath).isDirectory()) {
      continue;
    }

    // 1. Process Models
    const modelsDir = path.join(pkgPath, 'models');
    if (fs.existsSync(modelsDir)) {
      const targetPkgModuleDir = path.join(destModulesDir, pkg);
      ensureDir(targetPkgModuleDir);


      const described = describedTables(targetPkgModuleDir);

      // Several source models can name the same table, and only one file is
      // written for it, so the choice has to be made on merit rather than on
      // whichever the directory listing reaches first. Lrg has three files
      // claiming Lrg_Request_View -- DashboardRequestStatus with 11 columns,
      // RequestStudyView with 151 and RequestView with 152 -- and the thin one
      // sorts first. That was survivable while these files lost precedence to
      // db/JSON/pkgs; now that they win it, first-read would make a dashboard
      // query the definition of the view.
      //
      // The richest definition wins: most columns, and on a tie most children,
      // because two files can carry the same 10 columns and disagree about the
      // detail table hanging off them -- Lrg has ReciveInatallPayment.json and
      // ReciveInstallPayment.json, identical but for the child, and the typo
      // sorts first. A full tie keeps the first read, which is the behaviour
      // every non-clashing table already had.
      const chosen = new Map();

      /** @returns {boolean} Whether `b` describes more than `a`. */
      const richer = (a, b) =>
        b.fields.length > a.fields.length
        || (b.fields.length === a.fields.length && b.children.length > a.children.length);

      for (const file of fs.readdirSync(modelsDir)) {
        if (!file.endsWith('.json')) {
          continue;
        }
        const filePath = path.join(modelsDir, file);
        const filename = path.basename(file, '.json');
        try {
          const rawJson = JSON.parse(fs.readFileSync(filePath, 'utf8'));
          const normalized = normalizeModel(rawJson, pkg, filename);
          const tableKey = String(normalized.tableName || filename).toLowerCase();
          const held = chosen.get(tableKey);

          if (!held || richer(held.normalized, normalized)) {
            chosen.set(tableKey, { normalized, filename, filePath });
          }
        } catch (err) {
          console.error(`Error processing model ${filePath}:`, err.message);
        }
      }

      for (const [tableKey, pick] of chosen) {
        // Already described: leave it, hand edits and all. Compared by table,
        // not by path, because a curated file may sit under a name this run
        // would not choose.
        if (!force && described.has(tableKey)) {
          modelSkipped++;
          continue;
        }

        const table = pick.normalized.tableName || pick.filename;
        const destPath = path.join(targetPkgModuleDir, `${modelFileName(table, pkg)}.json`);

        try {
          fs.writeFileSync(destPath, JSON.stringify(pick.normalized, null, 2), 'utf8');
          modelCount++;
          described.add(tableKey);
        } catch (err) {
          console.error(`Error writing model ${destPath}:`, err.message);
        }
      }
    }

    // 2. Process Autocompletes
    const autocompleteDir = path.join(pkgPath, 'autocomplete');
    if (fs.existsSync(autocompleteDir)) {
      const targetPkgAutoDir = path.join(destAutocompleteDir, pkg);
      ensureDir(targetPkgAutoDir);

      const files = fs.readdirSync(autocompleteDir);
      for (const file of files) {
        if (file.endsWith('.json')) {
          const filePath = path.join(autocompleteDir, file);
          try {
            const rawData = fs.readFileSync(filePath, 'utf8');
            const destPath = path.join(targetPkgAutoDir, file);
            if (!force && fs.existsSync(destPath)) {

              autocompleteSkipped++;

              continue;

            }


            fs.writeFileSync(destPath, rawData, 'utf8');
            autocompleteCount++;
          } catch (err) {
            console.error(`Error copying autocomplete ${filePath}:`, err.message);
          }
        }
      }
    }
  }

  console.log(`Generated ${modelCount} new entity model(s) in ${destModulesDir}`);


  console.log(`Left ${modelSkipped} existing model(s) untouched${force ? '' : ' (pass --force to rewrite them)'}`);
  console.log(`Copied ${autocompleteCount} new autocomplete definition(s) to ${destAutocompleteDir}`);

  console.log(`Left ${autocompleteSkipped} existing definition(s) untouched`);
}

processAll();
