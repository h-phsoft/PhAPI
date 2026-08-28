/* global process */

require('dotenv').config();
let oracledb = null;
try {
  oracledb = require('oracledb');
  oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
} catch (e) {
  // oracledb driver optional fallback
}

/**
 * In-memory map of tenant database configurations.
 */

// Single source of truth: env.js validates DB_TYPE and normalises the aliases
// (postgresql/pg -> postgres, mariadb -> mysql), so nothing here re-parses it.
const defaultDbType = require('./env').dbType;

const DEFAULT_PORTS = { oracle: 1521, postgres: 5432, mysql: 3306 };
const defaultPort = process.env.DB_PORT
  ? parseInt(process.env.DB_PORT, 10)
  : DEFAULT_PORTS[defaultDbType];

const defaultUser = process.env.DB_USER || (defaultDbType === 'postgres' ? 'postgres' : 'root');

const tenantConfigs = {
  default: {
    dbType: defaultDbType,
    host: process.env.DB_HOST || 'localhost',
    port: defaultPort,
    user: defaultUser,
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'xe',
    connectString: process.env.DB_CONNECT_STRING || null,
    connectionLimit: parseInt(process.env.DB_POOL_LIMIT || '10', 10)
  }
};


/** True for engines where a tenant is a separate database rather than a schema user. */
function isRelational(dbType) {
  return dbType === 'postgres' || dbType === 'mysql';
}

/**
 * Resolves a tenant on PostgreSQL or MySQL.
 *
 * The two models differ fundamentally. On Oracle every copy is a schema user
 * inside one database, so Phs_Cpy.OUser/OPass are login credentials and the
 * lookup below returns them. On PostgreSQL and MySQL each copy is its own
 * database reached with the same credentials, so what has to be derived is a
 * database name, and OUser/OPass are meaningless -- they still hold Oracle
 * usernames such as 'C##erpDemo'.
 *
 * The name is built as DB_TENANT_PREFIX + copy, which is how the ported schema
 * is laid out: copy 'Demo' lives in phsoftme_erp_demo. Phs_Cpy is still
 * consulted so an unknown copy is rejected rather than silently pointed at a
 * database that may not exist.
 *
 * @param {string|number} tenantKey Copy name, URL or id
 * @returns {Promise<Object|null>}
 */
async function resolveTenantFromRelationalAdmin(tenantKey) {
  const prefix = process.env.DB_TENANT_PREFIX || 'phsoftme_erp_';
  const adminDatabase = process.env.ADMIN_DB_NAME || process.env.DB_NAME;
  const key = String(tenantKey).toLowerCase();

  const base = {
    dbType: defaultDbType,
    host: process.env.DB_HOST || 'localhost',
    port: defaultPort,
    user: process.env.ADMIN_DB_USER || defaultUser,
    password: process.env.ADMIN_DB_PASS || process.env.DB_PASSWORD || '',
    connectionLimit: parseInt(process.env.DB_POOL_LIMIT || '10', 10)
  };

  const sql = defaultDbType === 'mysql'
    ? 'SELECT Id, Name, URL FROM Phs_Cpy WHERE LOWER(Name)=? OR LOWER(URL)=? OR CAST(Id AS CHAR)=?'
    : 'SELECT Id, Name, URL FROM Phs_Cpy WHERE LOWER(Name)=$1 OR LOWER(URL)=$2 OR CAST(Id AS TEXT)=$3';

  let rows = [];

  try {
    if (defaultDbType === 'mysql') {
      const mysql = require('mysql2/promise');
      const conn = await mysql.createConnection({ ...base, database: adminDatabase });
      try {
        const [result] = await conn.execute(sql, [key, key, key]);
        rows = result;
      } finally {
        await conn.end();
      }
    } else {
      const { Client } = require('pg');
      const client = new Client({ ...base, database: adminDatabase });
      await client.connect();
      try {
        const result = await client.query(sql, [key, key, key]);
        rows = result.rows;
      } finally {
        await client.end();
      }
    }
  } catch (err) {
    console.error(`[DbConfig] Admin lookup failed for copy '${tenantKey}': ${err.message}`);
    return null;
  }

  if (!rows || rows.length === 0) {
    return null;
  }

  const row = rows[0];
  const name = row.URL || row.url || row.Name || row.name || tenantKey;

  const config = {
    ...base,
    tenantId: String(row.Id ?? row.id ?? tenantKey),
    name: row.Name || row.name,
    url: row.URL || row.url,
    database: `${prefix}${String(name).toLowerCase()}`
  };

  // Cache under every spelling the caller might arrive with.
  [tenantKey, config.tenantId, config.name, config.url].forEach((alias) => {
    if (alias) {
      tenantConfigs[String(alias).toLowerCase()] = config;
    }
  });

  return config;
}

/**
 * Connects to Admin Oracle DB to resolve copy credentials from Phs_Cpy table.
 * @param {string|number} tenantKey Copy Key / ID / URL
 * @returns {Promise<Object>}
 */
async function resolveTenantFromAdminDb(tenantKey) {
  if (!oracledb) {
    return null;
  }

  const adminConnectString = process.env.ADMIN_DB_CONNECT_STRING ||
    process.env.DB_CONNECT_STRING ||
    `${process.env.DB_HOST || 'localhost'}:${process.env.DB_PORT || 1521}/${process.env.DB_NAME || 'xe'}`;

  const candidateAdminUsers = Array.from(new Set([
    process.env.ADMIN_DB_USER,
    process.env.DB_USER,
    'c##erpAdmin',
    'c##phsAdmin'
  ].filter(Boolean)));

  const adminPass = process.env.ADMIN_DB_PASS || process.env.DB_PASSWORD;

  let connection = null;
  const logger = require('../utils/logger');

  for (const user of candidateAdminUsers) {
    try {
      console.log(`[Database] 🔌 Connecting to Admin Oracle DB (user: '${user}') to lookup copy '${tenantKey}'...`);
      logger.info(`[Database] 🔌 Connecting to Admin Oracle DB (user: '${user}') to lookup copy '${tenantKey}'...`);

      connection = await oracledb.getConnection({
        user,
        password: adminPass,
        connectString: adminConnectString
      });
      if (connection) {
        break;
      }
    } catch (connErr) {
      console.warn(`[DbConfig] Admin DB logon failed for user '${user}': ${connErr.message}`);
    }
  }

  if (!connection) {
    console.error(`[DbConfig] Unable to connect to Admin Oracle DB with any candidate admin user for key '${tenantKey}'.`);
    return null;
  }


  try {
    const sql = `
      SELECT Id, OUser, OPass
      FROM Phs_Cpy
      WHERE lower(Name)=:p_1 OR lower(URL)=:p_2
    `;

    console.log(`[SQL Execution] [Admin DB Lookup] SQL: ${sql.trim()} | Params: ${JSON.stringify({p_1: String(tenantKey).toLowerCase(), p_2: String(tenantKey).toLowerCase()})}`);
    logger.info(`[SQL Execution] [Admin DB Lookup] SQL: ${sql.trim()} | Params: ${JSON.stringify({p_1: String(tenantKey).toLowerCase(), p_2: String(tenantKey).toLowerCase()})}`);

    const result = await connection.execute(sql, {p_1: String(tenantKey).toLowerCase(), p_2: String(tenantKey).toLowerCase()});


    if (result.rows && result.rows.length > 0) {
      const row = result.rows[0];
      const config = {
        tenantId: String(row.ID || row.Id || tenantKey),
        name: row.NAME || row.Name,
        url: row.URL || row.Url,
        dbType: 'oracle',
        host: process.env.DB_HOST || 'localhost',
        port: process.env.DB_PORT ? parseInt(process.env.DB_PORT, 10) : 1521,
        database: process.env.DB_NAME || 'xe',
        user: row.OUSER || row.OUser || row.ouser,
        password: row.OPASS || row.OPass || row.opass,
        connectString: adminConnectString,
        connectionLimit: 10
      };

      tenantConfigs[String(tenantKey).toLowerCase()] = config;
      if (row.ID)
        tenantConfigs[String(row.ID).toLowerCase()] = config;
      if (row.URL)
        tenantConfigs[String(row.URL).toLowerCase()] = config;
      if (row.NAME)
        tenantConfigs[String(row.NAME).toLowerCase()] = config;

      return config;
    }
  } catch (err) {
    console.warn(`[DbConfig] Admin DB tenant lookup failed for key '${tenantKey}':`, err.message);
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (e) {
        // Ignore close error
      }
    }
  }

  return null;
}



function deriveCopyUser(copyKey) {
  if (!copyKey)
    return process.env.DB_USER || 'c##erpAdmin';
  const strKey = String(copyKey).trim();
  if (strKey.toLowerCase().startsWith('c##')) {
    return strKey;
  }
  // Strip optional '01-' prefix (e.g. 01-Admin -> Admin, 01-MKM -> MKM)
  const cleanKey = strKey.replace(/^01-?/i, '');
  const prefix = process.env.DB_USER_PREFIX || 'c##erp';
  return `${prefix}${cleanKey}`;
}

/**
 * Resolves database configuration for a tenant copy key.
 * Queries Admin DB Phs_Cpy table for OUser and OPass credentials, or derives c##erp{copy}.
 * @param {string|number} tenantKey
 * @returns {Promise<Object>}
 */
async function getTenantDbConfig(tenantKey) {
  if (!tenantKey || String(tenantKey).toLowerCase() === 'default') {
    return tenantConfigs['default'];
  }

  const keyStr = String(tenantKey).toLowerCase();

  // 1. Check in-memory cache
  if (tenantConfigs[keyStr]) {
    return tenantConfigs[keyStr];
  }

  // 2. Resolve through the admin database. Which lookup applies depends on how
  //    the engine models a tenant: an Oracle schema user, or its own database.
  const resolvedConfig = isRelational(defaultDbType)
    ? await resolveTenantFromRelationalAdmin(tenantKey)
    : await resolveTenantFromAdminDb(tenantKey);

  if (resolvedConfig) {
    return resolvedConfig;
  }

  // If not found in Phs_Cpy, throw an error instead of blindly constructing it
  throw new Error(`Tenant copy '${tenantKey}' not found in Admin database or is invalid.`);
}



function registerTenantDbConfig(tenantId, config) {
  if (!tenantId || !config || !config.dbType) {
    throw new Error('[DbConfig] Invalid tenant configuration parameter');
  }
  tenantConfigs[String(tenantId).toLowerCase()] = config;
}

module.exports = {
  getTenantDbConfig,
  registerTenantDbConfig,
  tenantConfigs
};

