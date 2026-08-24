const autocompleteService = require('../../services/autocompleteService');

console.log('--- Testing Autocomplete Service ---');

const meta = autocompleteService.getMetadata('Acc', 'Account');
console.log('Acc/Account metadata template:', meta);

async function testSqlGen() {
  try {
    // Mock getAutocomplete call (without hitting live DB)
    console.log('\nTesting query build for Acc/Account with term="cash":');
    const metaAcc = autocompleteService.getMetadata('Acc', 'Account');
    if (metaAcc) {
      console.log('Base Select:', metaAcc.Select);
      console.log('Base Condition:', metaAcc.Condition);
      console.log('Conds:', metaAcc.Conds);
    }
  } catch (err) {
    console.error('Error:', err);
  }
}

testSqlGen();
