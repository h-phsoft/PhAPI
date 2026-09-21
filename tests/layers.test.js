/**
 * The layer rules, enforced.
 *
 * Separation decays quietly: someone needs a translation inside a repository,
 * imports it, and the boundary is gone in one line. Nobody notices, because
 * nothing fails. This makes it fail.
 *
 * Four rules, from MIGRATION-PLAN.md:
 *
 *   L1  A layer may require only layers beneath it. `utils` and `models` are
 *       leaves everyone may use and may require nothing of the project.
 *   L2  Only `http/` knows HTTP. No req, res or status code below it.
 *   L3  Only `data/dialects` knows an engine. No oracle/mysql/postgres above.
 *   L4  Presentation never runs in the domain.
 *
 * Run as part of `npm test`. A violation fails the build, which is what makes
 * the separation a condition rather than an agreement.
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');

/**
 * Every directory, and how deep it sits. Higher may require lower; lower may
 * never require higher, and nothing may require its own level except within a
 * folder.
 *
 * The numbers are ordinals, not distances -- what matters is the ordering.
 */
const LAYERS = {
  'http/routes': 95,
  'http/middleware': 90,
  'http/controllers': 85,
  'http': 80,
  'presentation': 70,
  'services': 60,
  'repository': 50,
  'core/query': 40,
  'core': 35,
  'core/dialects': 30,
  'core/types': 25,
  'metadata': 20,
  'config': 20,
  'models': 0,
  'utils': 0
};

/** Leaves: usable by anyone, may require nothing of the project. */
const LEAVES = new Set(['utils', 'models']);

/** Folders whose files may mention HTTP. */
const HTTP_LAYERS = new Set(['http', 'http/routes', 'http/middleware', 'http/controllers']);

/** Folders whose files may name a database engine. */
const ENGINE_LAYERS = new Set(['core/dialects', 'core', 'config']);

/**
 * An engine named as a value, not as a word.
 *
 * `dbType === 'oracle'` and `require('oracledb')` are the real signal. A bare
 * identifier is not: a local `oracle` variable inside the dialect that owns it
 * is fine, and prose is stripped before these run.
 */
const ENGINE_WORDS = /require\(['"](oracledb|mysql2?|pg)['"]\)|['"](oracle|mysql|postgres|postgresql)['"]/i;

/**
 * HTTP as an object, not as a name.
 *
 * `const res = await conn.query(...)` is a result, and `res.rows` after it is
 * not a response. What gives HTTP away is the handler signature and the
 * members only a request or response has.
 */
const HTTP_WORDS = /\(\s*req\s*,\s*res\b|\bres\.(status|json|send|setHeader|sendFile|redirect|end)\s*\(|\breq\.(headers|body|params|query|user|method|originalUrl|socket|hostname)\b|\bstatusCode\b/;

/**
 * Which layer a file belongs to: its deepest matching folder, so `core/query`
 * wins over `core`.
 *
 * @param {string} relative Path relative to the project root, with / separators
 * @returns {string|null}
 */
function layerOf(relative) {
  let best = null;
  for (const folder of Object.keys(LAYERS)) {
    if (relative === folder || relative.startsWith(`${folder}/`)) {
      if (!best || folder.length > best.length) {
        best = folder;
      }
    }
  }
  return best;
}

/** Every .js file inside a layered folder. */
function sourceFiles() {
  const out = [];

  const walk = (dir) => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      if (entry.name === 'node_modules' || entry.name.startsWith('.')) {
        continue;
      }
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(full);
      } else if (entry.name.endsWith('.js')) {
        const rel = path.relative(ROOT, full).split(path.sep).join('/');
        const layer = layerOf(rel);
        if (layer) {
          out.push({ file: full, rel, layer });
        }
      }
    }
  };

  for (const folder of new Set(Object.keys(LAYERS).map((f) => f.split('/')[0]))) {
    const dir = path.join(ROOT, folder);
    if (fs.existsSync(dir)) {
      walk(dir);
    }
  }

  return out;
}

const violations = [];

function report(rule, file, detail) {
  violations.push(`${rule}  ${file}\n        ${detail}`);
}

for (const { file, rel, layer } of sourceFiles()) {
  const source = fs.readFileSync(file, 'utf8');

  // Comments are blanked rather than removed, so prose cannot break a rule and
  // the line a violation is reported at is still the line in the real file.
  let inBlock = false;
  const lines = source.split('\n').map((line) => {
    let out = line;
    if (inBlock) {
      const close = out.indexOf('*/');
      if (close === -1) {
        return '';
      }
      out = out.slice(close + 2);
      inBlock = false;
    }
    out = out.replace(/\/\*.*?\*\//g, '');
    const open = out.indexOf('/*');
    if (open !== -1) {
      inBlock = true;
      out = out.slice(0, open);
    }
    return out.replace(/\/\/.*$/, '');
  });

  const code = lines.join('\n');

  /** @returns {number} The 1-based line in the real file, or 0 */
  const lineOf = (pattern) => lines.findIndex((l) => pattern.test(l)) + 1;

  // --- L1: dependency direction -------------------------------------------
  for (const m of code.matchAll(/require\(['"](\.[^'"]+)['"]\)/g)) {
    const target = path.normalize(path.join(path.dirname(file), m[1]));
    const trel = path.relative(ROOT, target).split(path.sep).join('/');
    const targetLayer = layerOf(trel);

    if (!targetLayer || targetLayer === layer) {
      continue;
    }

    if (LEAVES.has(layer)) {
      report('L1', rel, `a leaf requires ${trel}; leaves may require nothing of the project`);
      continue;
    }

    if (LEAVES.has(targetLayer)) {
      continue;
    }

    if (LAYERS[targetLayer] >= LAYERS[layer]) {
      report('L1', rel, `${layer} requires ${targetLayer} (${trel}), which is not beneath it`);
    }
  }

  // --- L2: only http knows HTTP -------------------------------------------
  if (!HTTP_LAYERS.has(layer) && HTTP_WORDS.test(code)) {
    const line = code.split('\n').findIndex((l) => HTTP_WORDS.test(l)) + 1;
    report('L2', rel, `names HTTP at line ${line}; only routes, middleware and controllers may`);
  }

  // --- L3: only the dialects know an engine -------------------------------
  if (!ENGINE_LAYERS.has(layer) && ENGINE_WORDS.test(code)) {
    const line = code.split('\n').findIndex((l) => ENGINE_WORDS.test(l)) + 1;
    report('L3', rel, `names a database engine at line ${line}; only the dialect layer may`);
  }

  // --- L4: presentation does not run in the domain ------------------------
  if (layer === 'services' && /translateLabel/.test(code)) {
    report('L4', rel, `translates labels at line ${lineOf(/translateLabel/)}; that belongs in presentation`);
  }
}

if (violations.length) {
  console.error(`\n✗ [FAIL] Layer rules: ${violations.length} violation(s)\n`);
  for (const v of violations) {
    console.error(`    ${v}`);
  }
  console.error('');
  process.exitCode = 1;
} else {
  console.log('✓ [PASS] Layer rules: no violations');
}

module.exports = { violations };
