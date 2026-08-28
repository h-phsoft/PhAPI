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
 *   --from=<path>   The .properties file to read (required)
 *   --lang=<code>   Locale to write, inferred from the filename otherwise
 *   --apply         Write the changes; reports only without it
 *   --force         Also replace values that already look translated
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
  if (!locale.labels || typeof locale.labels !== 'object') {
    console.error(`${lang}.json has no labels section. Run extractMenuLabels.js first.`);
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

  const lookup = (label) => {
    const candidates = [
      props[label],
      byLower[label.toLowerCase()],
      byCompact[label.toLowerCase().replace(/[^a-z0-9]/g, '')]
    ];
    return candidates.find((value) => isTranslated(value, lang));
  };

  const labels = Object.keys(locale.labels);
  let translated = 0;
  let kept = 0;
  const missing = [];

  for (const label of labels) {
    const current = locale.labels[label];

    // Never clobber a hand-made translation unless asked.
    if (!force && isTranslated(current, lang) && current !== label) {
      kept++;
      continue;
    }

    const found = lookup(label);
    if (found) {
      locale.labels[label] = found;
      translated++;
    } else {
      missing.push(label);
    }
  }

  console.log(`\n--- ${path.basename(source)} -> locales/${lang}.json ---`);
  console.log(apply ? '  MODE: APPLY\n' : '  MODE: report only (pass --apply to write)\n');
  console.log(`  properties entries : ${Object.keys(props).length}`);
  console.log(`  labels in locale   : ${labels.length}`);
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
