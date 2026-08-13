const { getTenantDbConfig } = require('../config/db.config');

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
              const [rows] = await connection.execute(sql, params || []);
              return rows;
            },
            async beginTransaction() { await connection.beginTransaction(); },
            async commit() { await connection.commit(); },
            async rollback() { await connection.rollback(); },
            release() { connection.release(); }
          };
        },
        async query(sql, params) {
          const [rows] = await pool.execute(sql, params || []);
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
              const res = await client.query(sql, params || []);
              return res.rows;
            },
            async beginTransaction() { await client.query('BEGIN'); },
            async commit() { await client.query('COMMIT'); },
            async rollback() { await client.query('ROLLBACK'); },
            release() { client.release(); }
          };
        },
        async query(sql, params) {
          const res = await pool.query(sql, params || []);
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
