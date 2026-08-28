const { getTenantDbConfig } = require('../config/db.config');

/**
 * Rewrites Oracle-style SQL so MySQL and PostgreSQL can run it.
 *
 * The repository layer is written against Oracle: named binds (`:logon`) and
 * `FROM DUAL`. Neither target understands either, so rather than forking every
 * repository method the statement is translated here, where the dialect is
 * already known.
 *
 * Named binds are collected in first-appearance order. Values come from an
 * object by name, or from an array positionally, which is how the existing
 * callers pass them.
 *
 * @param {string} sql
 * @param {Object|Array|undefined} params
 * @param {'mysql'|'postgres'} dialect
 * @returns {{text: string, values: Array}}
 */
function adaptOracleSql(sql, params, dialect) {
  const names = [];
  let text = '';
  let i = 0;

  while (i < sql.length) {
    const ch = sql[i];

    // Copy string literals verbatim: a colon inside one is data, not a bind.
    if (ch === "'") {
      const end = sql.indexOf("'", i + 1);
      const stop = end === -1 ? sql.length : end + 1;
      text += sql.slice(i, stop);
      i = stop;
      continue;
    }

    // PostgreSQL's :: cast must survive untouched.
    if (ch === ':' && sql[i + 1] === ':') {
      text += '::';
      i += 2;
      continue;
    }

    const bind = ch === ':' ? /^:([A-Za-z_][A-Za-z0-9_]*)/.exec(sql.slice(i)) : null;
    if (bind) {
      const name = bind[1];
      let index = names.indexOf(name);
      if (index === -1) {
        names.push(name);
        index = names.length - 1;
      }
      text += dialect === 'mysql' ? '?' : `$${index + 1}`;
      i += bind[0].length;
      continue;
    }

    text += ch;
    i++;
  }

  // Oracle's dummy table has no equivalent; a bare SELECT is the same thing.
  text = text.replace(/\s+FROM\s+DUAL\b/gi, '');

  let values = [];
  if (names.length > 0) {
    values = names.map((name, index) =>
      Array.isArray(params) ? params[index] : (params ? params[name] : undefined));
  } else if (Array.isArray(params)) {
    values = params;
  }

  return { text, values };
}

let mysql = null;
let pg = null;
let oracledb = null;

class ConnectionPoolManager {
  constructor() {
    if (ConnectionPoolManager.instance) {
      return ConnectionPoolManager.instance;
    }

    this.pools = new Map();
    ConnectionPoolManager.instance = this;
  }

  async getPool(tenantId) {
    const key = String(tenantId || 'default').toLowerCase();

    if (this.pools.has(key)) {
      return this.pools.get(key);
    }

    const config = await getTenantDbConfig(key);
    const poolWrapper = await this.createPool(key, config);
    this.pools.set(key, poolWrapper);
    return poolWrapper;
  }

  async createPool(tenantId, config) {
    const dbType = (config.dbType || 'mysql').toLowerCase();
    const logger = require('../utils/logger');

    console.log(`[Database] 🔌 Creating connection pool for copy '${tenantId}': dbType='${dbType}', host='${config.host}:${config.port || 'default'}', user='${config.user}', database='${config.database}'`);
    logger.info(`[Database] 🔌 Creating connection pool for copy '${tenantId}': dbType='${dbType}', host='${config.host}:${config.port || 'default'}', user='${config.user}', database='${config.database}'`);


    if (dbType === 'mysql') {
      if (!mysql) mysql = require('mysql2/promise');
      const pool = mysql.createPool({
        host: config.host,
        port: config.port || 3306,
        user: config.user,
        password: config.password,
        database: config.database,
        waitForConnections: true,
        connectionLimit: config.connectionLimit || 10,
        queueLimit: 0
      });

      return {
        tenantId,
        dbType: 'mysql',
        pool,
        async getConnection() {
          const connection = await pool.getConnection();
          return {
            driverConn: connection,
            async query(sql, params) {
              const q = adaptOracleSql(sql, params, 'mysql');
              const [rows] = await connection.query(q.text, q.values);
              return rows;
            },
            async beginTransaction() { await connection.beginTransaction(); },
            async commit() { await connection.commit(); },
            async rollback() { await connection.rollback(); },
            release() { connection.release(); }
          };
        },
        async query(sql, params) {
          const q = adaptOracleSql(sql, params, 'mysql');
          const [rows] = await pool.query(q.text, q.values);
          return rows;
        }
      };
    } else if (dbType === 'postgres' || dbType === 'postgresql' || dbType === 'pg') {
      if (!pg) pg = require('pg');
      const { Pool } = pg;
      const pool = new Pool({
        host: config.host,
        port: config.port || 5432,
        user: config.user,
        password: config.password,
        database: config.database,
        max: config.connectionLimit || 10
      });

      return {
        tenantId,
        dbType: 'postgres',
        pool,
        async getConnection() {
          const client = await pool.connect();
          return {
            driverConn: client,
            async query(sql, params) {
              const q = adaptOracleSql(sql, params, 'postgres');
              const res = await client.query(q.text, q.values);
              return res.rows;
            },
            async beginTransaction() { await client.query('BEGIN'); },
            async commit() { await client.query('COMMIT'); },
            async rollback() { await client.query('ROLLBACK'); },
            release() { client.release(); }
          };
        },
        async query(sql, params) {
          const q = adaptOracleSql(sql, params, 'postgres');
          const res = await pool.query(q.text, q.values);
          return res.rows;
        }
      };
    } else if (dbType === 'oracle') {
      if (!oracledb) {
        try {
          oracledb = require('oracledb');
          oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
          oracledb.autoCommit = true;
        } catch (err) {
          throw new Error(`[ConnectionPoolManager] Oracle DB driver (oracledb) failed to load: ${err.message}`);
        }
      }

      const connectString = config.connectString || `${config.host}:${config.port || 1521}/${config.database}`;
      const pool = await oracledb.createPool({
        user: config.user,
        password: config.password,
        connectString,
        poolMin: 1,
        poolMax: config.connectionLimit || 10
      });

      return {
        tenantId,
        dbType: 'oracle',
        pool,
        async getConnection() {
          const connection = await pool.getConnection();
          return {
            driverConn: connection,
            async query(sql, params) {
              console.log(`[SQL Execution] [copy: '${tenantId}', user: '${config.user}'] SQL: ${sql} | Params: ${JSON.stringify(params || {})}`);
              logger.info(`[SQL Execution] [copy: '${tenantId}', user: '${config.user}'] SQL: ${sql} | Params: ${JSON.stringify(params || {})}`);
              const res = await connection.execute(sql, params || {}, { autoCommit: false });
              return res.rows;
            },
            async beginTransaction() {},
            async commit() { await connection.commit(); },
            async rollback() { await connection.rollback(); },
            async release() { await connection.close(); }
          };
        },
        async query(sql, params) {
          const connection = await pool.getConnection();
          try {
            console.log(`[SQL Execution] [copy: '${tenantId}', user: '${config.user}'] SQL: ${sql} | Params: ${JSON.stringify(params || {})}`);
            logger.info(`[SQL Execution] [copy: '${tenantId}', user: '${config.user}'] SQL: ${sql} | Params: ${JSON.stringify(params || {})}`);
            const res = await connection.execute(sql, params || {});
            return res.rows;
          } finally {
            await connection.close();
          }
        }

      };
    } else {


      throw new Error(`[ConnectionPoolManager] Unsupported dbType: ${dbType}`);
    }
  }

  async closeAll() {
    for (const [tenantId, poolWrapper] of this.pools.entries()) {
      try {
        if (poolWrapper.dbType === 'mysql') await poolWrapper.pool.end();
        else if (poolWrapper.dbType === 'postgres') await poolWrapper.pool.end();
        else if (poolWrapper.dbType === 'oracle') await poolWrapper.pool.close(0);
      } catch (err) {
        console.error(`[ConnectionPoolManager] Error closing pool for tenant ${tenantId}:`, err);
      }
    }
    this.pools.clear();
  }
}

const connectionPoolInstance = new ConnectionPoolManager();
module.exports = connectionPoolInstance;
