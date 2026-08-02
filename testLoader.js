const path = require('path');
const mainApp = require('./config/mainApp');

console.log('--- Testing Metadata Loading ---');

const modulesDirs = [
  path.join(__dirname, 'resources', 'modules'),
  path.join(__dirname, 'db', 'JSON', 'pkgs')
];

mainApp.loadMetadata(modulesDirs);

const packages = mainApp.getAllPackages();
console.log(`Loaded ${packages.length} packages:`, packages.join(', '));

for (const pkg of packages) {
  const tables = mainApp.getTablesInPackage(pkg);
  console.log(`Package [${pkg}] has ${tables.length} entities/models.`);
}

// Test fetching specific entities
const accMaster = mainApp.getEntity('Acc', 'Acc_Master') || mainApp.getEntity('Acc', 'Master');
if (accMaster) {
  console.log('\nSuccessfully loaded Acc Master Entity:');
  console.log(`- Table: ${accMaster.tableName} (Synonym: ${accMaster.synonym})`);
  console.log(`- Fields count: ${accMaster.fields.length}`);
  console.log(`- Children count: ${accMaster.children.length}`);
} else {
  console.error('Failed to load Acc Master Entity');
}

console.log('\n--- Metadata Test Complete ---');
