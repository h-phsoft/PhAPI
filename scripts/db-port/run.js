/* global process, __dirname */

/**
 * Loads the generated scripts into a live MySQL or PostgreSQL server and
 * reports every error, rather than stopping at the first one.
 *
 *   node scripts/db-port/run.js --dialect=postgres
 *   node scripts/db-port/run.js --dialect=mysql --dir=01-Admin
 *
 * Credentials come from the environment so they never reach the repository:
 *   PGHOST PGPORT PGUSER PGPASSWORD
 *   MYSQL_HOST MYSQL_PORT MYSQL_USER MYSQL_PWD
 *
 * Errors are grouped by message so a single systematic mistake in the
 * translator does not look like hundreds of unrelated failures.
 */

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const DB_DIR = path.join(__dirname, '..', '..', 'db');

function arg(name, fallback) {
  const match = process.argv.find((a) => a.startsWith(`--${name}=`));
  return match ? match.split('=').slice(1).join('=') : fallback;
}

const dialect = arg('dialect', 'postgres');
const onlyDir = arg('dir', null);
const bail = process.argv.includes('--bail');

const CLIENTS = {
  postgres: {
    bin: arg('psql', 'psql'),
    args: (file) => [
      '-X',                       // ignore ~/.psqlrc
      '-v', 'ON_ERROR_STOP=0',    // keep going so all errors surface
      '-q',
      '-h', process.env.PGHOST || 'localhost',
      '-p', process.env.PGPORT || '5432',
      '-U', process.env.PGUSER || 'postgres',
      '-d', arg('database', 'postgres'),
      '-f', file
    ],
    // psql reports "psql:<file>:<line>: ERROR:  message". The file part is an
    // absolute path, so on Windows it contains the drive-letter colon too.
    errorPattern: /^psql:.*?:(\d+):\s*(ERROR|FATAL):\s+(.*)$/gm
  },
  mysql: {
    bin: arg('mysql', 'mysql'),
    args: () => [
      '--force',                  // continue after errors
      '--show-warnings=false',
      `-h${process.env.MYSQL_HOST || '127.0.0.1'}`,
      `-P${process.env.MYSQL_PORT || '3306'}`,
      `-u${process.env.MYSQL_USER || 'root'}`
    ],
    // mysql reports "ERROR 1064 (42000) at line 12: message"
    errorPattern: /^ERROR\s+(\d+)\s*\([^)]*\)\s*at line (\d+)[^:]*:\s*(.*)$/gm
  }
};

const client = CLIENTS[dialect];
if (!client) {
  console.error(`Unknown dialect: ${dialect}`);
  process.exit(1);
}

/** Files in load order: preludes first, then each source folder. */
function scriptsToRun() {
  const root = path.join(DB_DIR, dialect);
  const files = [];

  if (!onlyDir) {
    fs.readdirSync(root)
      .filter((f) => /^\d+_.*\.sql$/i.test(f))
      .sort()
      .forEach((f) => files.push(path.join(root, f)));
  }

  const dirs = onlyDir ? [onlyDir] : ['01-Admin', '01-Copy'];
  for (const dir of dirs) {
    const full = path.join(root, dir);
    if (!fs.existsSync(full)) continue;
    fs.readdirSync(full)
      .filter((f) => /\.sql$/i.test(f))
      .sort()
      .forEach((f) => files.push(path.join(full, f)));
  }

  return files;
}

function runFile(file) {
  const isMysql = dialect === 'mysql';
  const result = spawnSync(client.bin, client.args(file), {
    encoding: 'utf8',
    maxBuffer: 256 * 1024 * 1024,
    // mysql has no -f equivalent that keeps USE working, so pipe the file in.
    input: isMysql ? fs.readFileSync(file, 'utf8') : undefined,
    windowsHide: true
  });

  const output = `${result.stdout || ''}\n${result.stderr || ''}`;
  const errors = [];
  let match;

  client.errorPattern.lastIndex = 0;
  while ((match = client.errorPattern.exec(output)) !== null) {
    errors.push({ line: match[2], message: match[3].trim() });
  }

  return { errors, output };
}

const files = scriptsToRun();
console.log(`Running ${files.length} script(s) against ${dialect}...\n`);

let totalErrors = 0;
const byMessage = new Map();
const perFile = [];

for (const file of files) {
  const rel = path.relative(DB_DIR, file);
  const { errors } = runFile(file);

  totalErrors += errors.length;
  if (errors.length > 0) {
    perFile.push({ file: rel, count: errors.length, sample: errors.slice(0, 3) });
    errors.forEach((e) => {
      // Normalise so the same mistake groups together.
      const key = e.message
        .replace(/"[^"]*"/g, '"X"')
        .replace(/'[^']*'/g, "'X'")
        .replace(/\b\d+\b/g, 'N')
        .slice(0, 130);
      byMessage.set(key, (byMessage.get(key) || 0) + 1);
    });
    process.stdout.write(`  ${errors.length.toString().padStart(4)} err  ${rel}\n`);
    if (bail) break;
  }
}

console.log(`\n=== ${dialect}: ${totalErrors} error(s) across ${perFile.length}/${files.length} file(s) ===`);

if (byMessage.size > 0) {
  console.log('\nGrouped by message:');
  [...byMessage.entries()]
    .sort((a, b) => b[1] - a[1])
    .slice(0, 20)
    .forEach(([msg, count]) => console.log(`  ${String(count).padStart(5)}  ${msg}`));

  console.log('\nFirst failing files:');
  perFile.slice(0, 8).forEach(({ file, sample }) => {
    console.log(`  ${file}`);
    sample.forEach((s) => console.log(`      line ${s.line}: ${s.message.slice(0, 120)}`));
  });
}

process.exit(totalErrors === 0 ? 0 : 1);
