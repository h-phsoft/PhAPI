/* global process, __dirname */

/**
 * Collects every menu, type and program name from a tenant and writes them into
 * the locale files as translation keys.
 *
 *   node scripts/extractMenuLabels.js --tenant=Demo
 *   node scripts/extractMenuLabels.js --tenant=Demo --apply
 *
 * These labels live in a single Name column with no second-language column, so
 * the stored English text is used as the key. English maps to itself; other
 * locales get the English text as a placeholder, which reads correctly until
 * someone translates it.
 *
 * Reports only until given --apply. Existing translations are never
 * overwritten, so re-running after new menus are added only appends.
 */

const fs = require('fs');
const path = require('path');
const connectionPool = require('../core/connectionPool');
const authRepository = require('../repository/authRepository');

const LOCALES_DIR = path.join(__dirname, '..', 'locales');

function readArg(name, fallback) {
  const prefix = `--${name}=`;
  const match = process.argv.slice(2).find((arg) => arg.startsWith(prefix));
  return match ? match.slice(prefix.length) : fallback;
}

const tenant = readArg('tenant', 'default');
const apply = process.argv.slice(2).includes('--apply');

/** Reads a column across the spellings the three drivers return. */
function col(row, name) {
  if (row[name.toUpperCase()] !== undefined) return row[name.toUpperCase()];
  if (row[name] !== undefined) return row[name];
  const lower = name.toLowerCase();
  if (row[lower] !== undefined) return row[lower];
  const key = Object.keys(row).find((k) => k.toLowerCase() === lower);
  return key ? row[key] : undefined;
}

async function main() {
  console.log(`\n--- Menu labels for copy '${tenant}' ---`);
  console.log(apply ? '  MODE: APPLY (will write locale files)\n' : '  MODE: report only (pass --apply to write)\n');

  const poolWrapper = await connectionPool.getPool(tenant);
  const conn = await poolWrapper.getConnection();

  let labels;
  try {
    // pgrpId 0 means no permission filter, so this collects every label.
    const rows = await authRepository.getMenuRows(conn, 0);
    labels = new Set();

    for (const row of rows || []) {
      for (const field of ['Menu_Name', 'Type_Name', 'MPrg_Name']) {
        const value = col(row, field);
        if (value !== undefined && value !== null && String(value).trim() !== '') {
          labels.add(String(value).trim());
        }
      }
    }
  } finally {
    await conn.release();
    await connectionPool.closeAll();
  }

  const sorted = [...labels].sort((a, b) => a.localeCompare(b));
  console.log(`  distinct labels found: ${sorted.length}`);

  const localeFiles = fs.existsSync(LOCALES_DIR)
    ? fs.readdirSync(LOCALES_DIR).filter((f) => f.endsWith('.json'))
    : [];

  if (localeFiles.length === 0) {
    console.error(`  No locale files in ${LOCALES_DIR}`);
    process.exitCode = 1;
    return;
  }

  for (const file of localeFiles) {
    const lang = path.basename(file, '.json');
    const full = path.join(LOCALES_DIR, file);
    const locale = JSON.parse(fs.readFileSync(full, 'utf8'));

    if (!locale.labels || typeof locale.labels !== 'object') {
      locale.labels = {};
    }

    const added = sorted.filter((label) => locale.labels[label] === undefined);

    console.log(`  ${lang}: ${Object.keys(locale.labels).length} existing, ${added.length} new`);

    if (!apply || added.length === 0) {
      continue;
    }

    // English is its own translation; other locales start from the English text
    // so nothing renders blank before a translator gets to it.
    added.forEach((label) => {
      locale.labels[label] = label;
    });

    // Keep the file readable: labels sorted, everything else untouched.
    const orderedLabels = {};
    Object.keys(locale.labels).sort((a, b) => a.localeCompare(b))
      .forEach((key) => { orderedLabels[key] = locale.labels[key]; });
    locale.labels = orderedLabels;

    fs.writeFileSync(full, `${JSON.stringify(locale, null, 2)}\n`, 'utf8');
    console.log(`    wrote ${added.length} key(s) to locales/${file}`);
  }

  if (!apply) {
    console.log('\n  Re-run with --apply to write these keys.\n');
  } else {
    console.log('\n  Done. Translate the values in locales/ar.json; untranslated keys fall back to English.\n');
  }
}

main().catch((err) => {
  console.error(`\n  Failed: ${err.message}\n`);
  process.exit(1);
});
