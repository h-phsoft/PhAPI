/* global process, __dirname */

/**
 * Fills in a locale's label translations from the Java application's
 * .properties resource bundle.
 *
 *   node scripts/importJavaLabels.js --from="<path>/ar.properties"
 *   node scripts/importJavaLabels.js --from="<path>/ar.properties" --apply
 *
 * The Java app already carries translations for most of the same screens, keyed
 * by the English label, so it is the natural source. Its keys are not written
 * consistently -- 'Fixed Assets' appears as FixedAssets, fixed_assets and
 * Fixed Assets across the file -- so matching falls back through progressively
 * looser comparisons rather than requiring an exact hit.
 *
 * Options:
 *   --from=<path>      The .properties file to read (required)
 *   --lang=<code>      Locale to write, inferred from the filename otherwise
 *   --section=<name>   `labels` (default) or `fields`
 *   --apply            Write the changes; reports only without it
 *   --force            Also replace values that already look translated
 */

const fs = require('fs');
const path = require('path');

const LOCALES_DIR = path.join(__dirname, '..', 'locales');

function readArg(name, fallback) {
  const prefix = `--${name}=`;
  const match = process.argv.slice(2).find((arg) => arg.startsWith(prefix));
  return match ? match.slice(prefix.length) : fallback;
}

const source = readArg('from', null);
const apply = process.argv.slice(2).includes('--apply');
const force = process.argv.slice(2).includes('--force');

if (!source) {
  console.error('Missing --from=<path to .properties>');
  process.exit(1);
}
if (!fs.existsSync(source)) {
  console.error(`Not found: ${source}`);
  process.exit(1);
}

const lang = readArg('lang', path.basename(source, '.properties'));

/**
 * Which section of the locale file to fill.
 *
 * `labels` is the vocabulary the menu and the screen label keys resolve
 * through -- names as the Java bundle spells them, like `Date.of.birth`.
 *
 * `fields` is one entry per column name, seeded from the column itself:
 * `clinicName` with a readable English default of "Clinic Name". 841 of those
 * 2386 keys have an Arabic translation in the same bundle, which is the
 * difference between an Arabic query screen reading Arabic and reading English.
 * They need looser matching, because a column name is not how the bundle spells
 * a word -- see `spellings`.
 */
const section = readArg('section', 'labels');
if (section !== 'labels' && section !== 'fields') {
  console.error(`--section must be 'labels' or 'fields', not '${section}'`);
  process.exit(1);
}

/**
 * Parses a Java .properties file.
 *
 * These are ISO-8859-1 with \uXXXX escapes -- the standard encoding for the
 * format -- so the file is read as latin1 and the escapes decoded, rather than
 * read as UTF-8 which would mangle every non-ASCII value.
 *
 * @param {string} file
 * @returns {Object<string,string>}
 */
function parseProperties(file) {
  const raw = fs.readFileSync(file, 'latin1');
  const out = {};

  for (const line of raw.split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#') || trimmed.startsWith('!')) {
      continue;
    }
    const split = trimmed.indexOf('=');
    if (split < 1) {
      continue;
    }

    const key = trimmed.slice(0, split).trim();
    const value = trimmed.slice(split + 1)
      .replace(/\\u([0-9a-fA-F]{4})/g, (m, hex) => String.fromCharCode(parseInt(hex, 16)))
      .replace(/\\(.)/g, '$1')
      .trim();

    if (key && value) {
      out[key] = value;
    }
  }
  return out;
}

/**
 * The ways the Java bundle might spell a column name.
 *
 * A column is `borrowerFname`; the bundle has `Borrower.Fname`, `BorrowerFname`
 * or `Borrower Fname` depending on who added it. The English default already in
 * the locale file -- "Borrower Fname" -- is tried too, because that is the
 * spelling the seeding derived and often the one a person typed.
 *
 * @param {string} key The column name
 * @param {string} english Its current value in the locale file
 * @returns {string[]}
 */
function spellings(key, english) {
  const words = String(key).replace(/([a-z0-9])([A-Z])/g, '$1 $2');

  return [
    key,
    words,
    words.replace(/\s+/g, ''),
    words.replace(/\s+/g, '.'),
    words.replace(/\s+/g, '_'),
    english
  ].filter(Boolean).map(String);
}

/** True when the text actually contains the target script rather than English. */
function isTranslated(text, code) {
  if (!text) return false;
  if (code === 'ar') return /[؀-ۿ]/.test(text);
  // For other locales, anything differing from the key counts.
  return true;
}

function main() {
  const props = parseProperties(source);
  const localeFile = path.join(LOCALES_DIR, `${lang}.json`);

  if (!fs.existsSync(localeFile)) {
    console.error(`No locale file at ${localeFile}`);
    process.exit(1);
  }

  const locale = JSON.parse(fs.readFileSync(localeFile, 'utf8'));
  const target = locale[section];
  if (!target || typeof target !== 'object') {
    console.error(
      section === 'labels'
        ? `${lang}.json has no labels section. Run extractMenuLabels.js first.`
        : `${lang}.json has no fields section. Run seedScreenLabels.js --apply first.`
    );
    process.exit(1);
  }

  // Progressively looser indexes: exact, case-insensitive, then alphanumerics
  // only, which is what bridges 'Fixed Assets' to 'FixedAssets'.
  const byLower = {};
  const byCompact = {};
  for (const [key, value] of Object.entries(props)) {
    const lower = key.toLowerCase();
    if (byLower[lower] === undefined) byLower[lower] = value;
    const compact = lower.replace(/[^a-z0-9]/g, '');
    if (compact && byCompact[compact] === undefined) byCompact[compact] = value;
  }

  /**
   * The bundle's translation for one key, through progressively looser
   * matching: exact, case-insensitive, then alphanumerics only -- which is what
   * bridges 'Fixed Assets' to 'FixedAssets'.
   *
   * A field key is tried under each of its plausible spellings as well, since
   * `clinicName` is not how anyone writes a word.
   */
  const lookup = (label, english) => {
    const forms = section === 'fields' ? spellings(label, english) : [label];

    for (const form of forms) {
      const compact = form.toLowerCase().replace(/[^a-z0-9]/g, '');
      const candidates = [props[form], byLower[form.toLowerCase()], byCompact[compact]];
      const found = candidates.find((value) => isTranslated(value, lang));
      if (found) {
        return found;
      }
    }

    return undefined;
  };

  const labels = Object.keys(target);
  let translated = 0;
  let kept = 0;
  const missing = [];

  for (const label of labels) {
    const current = target[label];

    // Never clobber a hand-made translation unless asked.
    if (!force && isTranslated(current, lang) && current !== label) {
      kept++;
      continue;
    }

    const found = lookup(label, current);
    if (found) {
      target[label] = found;
      translated++;
    } else {
      missing.push(label);
    }
  }

  console.log(`\n--- ${path.basename(source)} -> locales/${lang}.json [${section}] ---`);
  console.log(apply ? '  MODE: APPLY\n' : '  MODE: report only (pass --apply to write)\n');
  console.log(`  properties entries : ${Object.keys(props).length}`);
  console.log(`  keys in ${section.padEnd(10)}: ${labels.length}`);
  console.log(`  translated         : ${translated}`);
  console.log(`  kept (already done): ${kept}`);
  console.log(`  no match           : ${missing.length}`);
  console.log(`  coverage           : ${(((labels.length - missing.length) / labels.length) * 100).toFixed(1)}%`);

  if (missing.length > 0) {
    console.log('\n  Untranslated (left as English):');
    missing.slice(0, 30).forEach((label) => console.log(`    ${label}`));
    if (missing.length > 30) {
      console.log(`    ... and ${missing.length - 30} more`);
    }
  }

  if (apply) {
    fs.writeFileSync(localeFile, `${JSON.stringify(locale, null, 2)}\n`, 'utf8');
    console.log(`\n  Wrote locales/${lang}.json\n`);
  } else {
    console.log('\n  Re-run with --apply to write.\n');
  }
}

main();
