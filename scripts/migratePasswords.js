/* global process */

/**
 * Migrates plaintext passwords in a tenant's user table to bcrypt digests.
 *
 * Reports only by default. Nothing is written without --apply, and the run
 * aborts before writing if the Pass column cannot hold a 60-character digest.
 *
 *   node scripts/migratePasswords.js --tenant=MKM
 *   node scripts/migratePasswords.js --tenant=MKM --apply
 *
 * Options:
 *   --tenant=<copy>   Tenant/copy key to migrate  (default: default)
 *   --table=<name>    User table                  (default: Cpy_User)
 *   --apply           Actually write the digests  (default: report only)
 */

const connectionPool = require('../core/connectionPool');
const passwordUtil = require('../utils/password');

const DIGEST_LENGTH = 60;

function readArg(name, fallback) {
  const prefix = `--${name}=`;
  const match = process.argv.slice(2).find((arg) => arg.startsWith(prefix));
  return match ? match.slice(prefix.length) : fallback;
}

const tenant = readArg('tenant', 'default');
const table = readArg('table', 'Cpy_User');
const apply = process.argv.slice(2).includes('--apply');

// Guard against a --table value reaching SQL as anything but a bare identifier.
if (!/^[A-Za-z][A-Za-z0-9_$#]*$/.test(table)) {
  console.error(`Invalid --table value: '${table}'`);
  process.exit(1);
}

/**
 * Oracle stores column widths in ALL_TAB_COLUMNS. A Pass column narrower than
 * 60 characters would silently truncate every digest, locking users out.
 * @returns {Promise<number|null>} null when the width cannot be determined
 */
async function checkColumnWidth(conn, dbType) {
  if (dbType !== 'oracle') {
    return null;
  }
  try {
    const rows = await conn.query(
      `SELECT DATA_LENGTH FROM ALL_TAB_COLUMNS
       WHERE UPPER(TABLE_NAME) = UPPER(:t) AND UPPER(COLUMN_NAME) = 'PASS'`,
      { t: table }
    );
    if (!rows || rows.length === 0) {
      return null;
    }
    const row = rows[0];
    return Number(row.DATA_LENGTH || row.data_length);
  } catch (err) {
    console.warn(`  ! Could not read column width: ${err.message}`);
    return null;
  }
}

async function main() {
  console.log(`\n--- Password migration for copy '${tenant}', table '${table}' ---`);
  console.log(apply ? '  MODE: APPLY (will write)\n' : '  MODE: report only (pass --apply to write)\n');

  const poolWrapper = await connectionPool.getPool(tenant);
  const conn = await poolWrapper.getConnection();

  try {
    const width = await checkColumnWidth(conn, poolWrapper.dbType);
    if (width !== null) {
      console.log(`  Pass column width: ${width} characters (need >= ${DIGEST_LENGTH})`);
      if (width < DIGEST_LENGTH && apply) {
        console.error(`\n  ABORTED: Pass is ${width} chars; a bcrypt digest needs ${DIGEST_LENGTH}.`);
        console.error(`  Widen it first, e.g.  ALTER TABLE ${table} MODIFY (Pass VARCHAR2(100));\n`);
        process.exitCode = 1;
        return;
      }
    }

    const rows = await conn.query(`SELECT Id, Logon, Pass FROM ${table}`, {});
    const users = (rows || []).map((row) => ({
      id: row.ID !== undefined ? row.ID : row.Id,
      logon: row.LOGON !== undefined ? row.LOGON : row.Logon,
      pass: row.PASS !== undefined ? row.PASS : row.Pass
    }));

    const hashed = users.filter((u) => passwordUtil.isHashed(u.pass));
    const empty = users.filter((u) => !passwordUtil.isHashed(u.pass) && (u.pass === null || String(u.pass).trim() === ''));
    const plaintext = users.filter((u) => !passwordUtil.isHashed(u.pass) && u.pass !== null && String(u.pass).trim() !== '');

    console.log(`\n  Total users:        ${users.length}`);
    console.log(`  Already hashed:     ${hashed.length}`);
    console.log(`  Empty / no password: ${empty.length} (skipped)`);
    console.log(`  Plaintext to migrate: ${plaintext.length}`);

    if (plaintext.length === 0) {
      console.log('\n  Nothing to do.\n');
      return;
    }

    if (!apply) {
      console.log('\n  Would migrate:');
      plaintext.slice(0, 20).forEach((u) => console.log(`    - id=${u.id} logon=${u.logon}`));
      if (plaintext.length > 20) {
        console.log(`    ... and ${plaintext.length - 20} more`);
      }
      console.log('\n  Re-run with --apply to write these digests.\n');
      return;
    }

    let migrated = 0;
    for (const user of plaintext) {
      const digest = await passwordUtil.hash(user.pass);
      await conn.query(`UPDATE ${table} SET Pass = :pass WHERE Id = :id`, { pass: digest, id: user.id });
      migrated++;
      if (migrated % 25 === 0) {
        console.log(`    ... ${migrated}/${plaintext.length}`);
      }
    }

    await conn.commit();
    console.log(`\n  ✓ Migrated ${migrated} password(s). Users log in with the same passwords as before.\n`);
  } catch (err) {
    try {
      await conn.rollback();
      console.error('\n  Rolled back; no changes were written.');
    } catch (rollbackErr) {
      console.error(`\n  Rollback failed: ${rollbackErr.message}`);
    }
    throw err;
  } finally {
    await conn.release();
    await connectionPool.closeAll();
  }
}

main().catch((err) => {
  console.error(`\n  Migration failed: ${err.message}\n`);
  process.exit(1);
});
