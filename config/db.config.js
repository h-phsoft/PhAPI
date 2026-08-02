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
const tenantConfigs = {
  default: {
    dbType: process.env.DB_TYPE || 'mysql',
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT ? parseInt(process.env.DB_PORT, 10) : 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'phs_api_db',
    connectString: process.env.DB_CONNECT_STRING || null,
    connectionLimit: parseInt(process.env.DB_POOL_LIMIT || '10', 10)
  }
};

/**
 * Connects to Admin Oracle DB to resolve tenant credentials from Phs_Copy (Phs_Cpy) table.
 * @param {string|number} tenantKey Tenant ID, URL, or Name
 * @returns {Promise<Object>}
 */
async function resolveTenantFromAdminDb(tenantKey) {
  if (!oracledb) {
    return null;
  }

  const adminConnectString = process.env.ADMIN_DB_CONNECT_STRING ||
                             process.env.DB_CONNECT_STRING ||
                             `${process.env.DB_HOST || 'localhost'}:${process.env.DB_PORT || 1521}/${process.env.DB_NAME || 'XE'}`;

  const adminUser = process.env.ADMIN_DB_USER || 'C##phsAdmin';
  const adminPass = process.env.ADMIN_DB_PASS || 'PhPass';

  let connection = null;
  try {
    connection = await oracledb.getConnection({
      user: adminUser,
      password: adminPass,
      connectString: adminConnectString
    });

    const sql = `
      SELECT Id, Name, URL, OUser, OPass
      FROM Phs_Cpy
      WHERE Status_Id = 1
        AND (TO_CHAR(Id) = :key OR LOWER(URL) = LOWER(:key) OR LOWER(Name) = LOWER(:key))
    `;

    const result = await connection.execute(sql, { key: String(tenantKey) });

    if (result.rows && result.rows.length > 0) {
      const row = result.rows[0];
      const config = {
        tenantId: row.ID,
        name: row.NAME,
        url: row.URL,
        dbType: 'oracle',
        user: row.OUSER,
        password: row.OPASS,
        connectString: adminConnectString,
        connectionLimit: 10
      };

      tenantConfigs[String(row.ID)] = config;
      tenantConfigs[row.URL.toLowerCase()] = config;
      tenantConfigs[row.NAME.toLowerCase()] = config;

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

/**
 * Resolves database configuration for a given tenantKey.
 * @param {string|number} tenantKey 
 * @returns {Promise<Object>}
 */
async function getTenantDbConfig(tenantKey) {
  const keyStr = String(tenantKey || 'default').toLowerCase();

  // 1. Check in-memory cache
  if (tenantConfigs[keyStr]) {
    return tenantConfigs[keyStr];
  }

  // 2. Query Admin DB Phs_Cpy table
  const resolvedConfig = await resolveTenantFromAdminDb(tenantKey);
  if (resolvedConfig) {
    return resolvedConfig;
  }

  // 3. Fallback to default tenant
  if (tenantConfigs['default']) {
    return tenantConfigs['default'];
  }

  throw new Error(`[DbConfig] No database configuration found for tenantKey: ${tenantKey}`);
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
