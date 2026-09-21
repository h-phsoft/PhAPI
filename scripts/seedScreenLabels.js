#!/usr/bin/env node
/**
 * Seeds a translation key for every label a screen asks for.
 *
 * A screen names its labels by key rather than carrying the text, so the text
 * has to exist somewhere. Every key is seeded with a readable English default
 * derived from the column name -- `borrowerFname` becomes "Borrower Fname" --
 * which reads correctly until someone writes something better, and Arabic
 * starts as the same English so an untranslated screen is legible rather than
 * blank.
 *
 * Existing entries are never overwritten. A key already translated keeps its
 * translation, which is what makes this safe to re-run after every conversion.
 *
 *   node scripts/seedScreenLabels.js
 *   node scripts/seedScreenLabels.js --apply
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const SCREENS = path.join(ROOT, 'resources', 'screens');
const LOCALES = path.join(ROOT, 'locales');

const apply = process.argv.includes('--apply');

/**
 * A readable default for a key that has none.
 *
 * `borrowerFname` -> `Borrower Fname`. Not a translation, but a legible
 * placeholder: a screen showing "Borrower Fname" is usable, one showing
 * `lrg.requestview.borrowerFname` is not.
 *
 * @param {string} fieldName The API field name
 * @returns {string}
 */
function readable(fieldName) {
  return String(fieldName)
    .replace(/([a-z0-9])([A-Z])/g, '$1 $2')
    .replace(/[_.]+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .replace(/^./, c => c.toUpperCase());
}

/** Every labelKey any screen asks for, with the field it came from. */
function wantedKeys() {
  const wanted = new Map();

  if (!fs.existsSync(SCREENS)) {
    return wanted;
  }

  for (const pkg of fs.readdirSync(SCREENS)) {
    const dir = path.join(SCREENS, pkg);
    if (!fs.statSync(dir).isDirectory()) {
      continue;
    }
    for (const file of fs.readdirSync(dir)) {
      if (!file.endsWith('.json')) {
        continue;
      }
      let screen;
      try {
        screen = JSON.parse(fs.readFileSync(path.join(dir, file), 'utf8'));
      } catch {
        continue;
      }
      for (const field of (screen.fields || [])) {
        if (field.labelKey && !wanted.has(field.labelKey)) {
          wanted.set(field.labelKey, readable(field.name));
        }
      }
    }
  }

  return wanted;
}

function seed(lang, wanted) {
  const file = path.join(LOCALES, `${lang}.json`);
  const raw = fs.readFileSync(file, 'utf8');
  const data = JSON.parse(raw);

  if (!data.fields) {
    data.fields = {};
  }

  let added = 0;
  for (const [key, fallback] of wanted) {
    if (data.fields[key] === undefined) {
      data.fields[key] = fallback;
      added++;
    }
  }

  // Sorted, so a diff shows what was added rather than where it landed.
  const ordered = {};
  for (const key of Object.keys(data.fields).sort((a, b) => a.localeCompare(b))) {
    ordered[key] = data.fields[key];
  }
  data.fields = ordered;

  const text = JSON.stringify(data, null, 2) + (/\n$/.test(raw) ? '\n' : '');

  if (apply) {
    fs.writeFileSync(file, text, 'utf8');
  }

  console.log(`  ${lang}.json: +${added} key(s), ${Object.keys(data.fields).length} total`);
  return added;
}

const wanted = wantedKeys();
console.log(`  label keys screens ask for: ${wanted.size}\n`);

seed('en', wanted);
seed('ar', wanted);

if (!apply) {
  console.log('\n  Dry run. Re-run with --apply to write.');
}
