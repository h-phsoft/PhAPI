/* global __dirname */

const fs = require('fs');
const path = require('path');

const srcPkgsDir = path.join(__dirname, '..', 'db', 'JSON', 'pkgs');
const destModulesDir = path.join(__dirname, '..', 'resources', 'modules');
const destAutocompleteDir = path.join(__dirname, '..', 'resources', 'autocomplete');

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

function processAll() {
  console.log('--- Regenerating JSON metadata into resources/ ---');

  if (!fs.existsSync(srcPkgsDir)) {
    console.error(`Source directory not found: ${srcPkgsDir}`);
    return;
  }

  ensureDir(destModulesDir);
  ensureDir(destAutocompleteDir);

  let modelCount = 0;
  let autocompleteCount = 0;

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

      const files = fs.readdirSync(modelsDir);
      for (const file of files) {
        if (file.endsWith('.json')) {
          const filePath = path.join(modelsDir, file);
          const filename = path.basename(file, '.json');
          try {
            const rawData = fs.readFileSync(filePath, 'utf8');
            const rawJson = JSON.parse(rawData);
            const normalized = normalizeModel(rawJson, pkg, filename);

            const destPath = path.join(targetPkgModuleDir, `${normalized.tableName || filename}.json`);
            fs.writeFileSync(destPath, JSON.stringify(normalized, null, 2), 'utf8');
            modelCount++;
          } catch (err) {
            console.error(`Error processing model ${filePath}:`, err.message);
          }
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
            fs.writeFileSync(destPath, rawData, 'utf8');
            autocompleteCount++;
          } catch (err) {
            console.error(`Error copying autocomplete ${filePath}:`, err.message);
          }
        }
      }
    }
  }

  console.log(`Successfully generated ${modelCount} standardized entity models in ${destModulesDir}`);
  console.log(`Successfully copied ${autocompleteCount} autocomplete definitions to ${destAutocompleteDir}`);
}

processAll();
