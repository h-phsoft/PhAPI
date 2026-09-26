const { getTenantDbConfig } = require('../config/db.config');
const adaptSql = require('./dialects/adaptSql');
const dialects = require('./dialects');

let mysql = null;
let pg = null;
let oracledb = null;

/**
 * Rows fetched per round trip when a result is streamed (D5). Big enough that
 * the round trips do not dominate, small enough that a batch is never the
 * memory problem streaming exists to avoid.
 */
const STREAM_BATCH = 500;

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
              const q = adaptSql(sql, params, dialects.mysql);
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
          const q = adaptSql(sql, params, dialects.mysql);
          const [rows] = await pool.query(q.text, q.values);
          return rows;
        },
        /**
         * The rows of a statement, STREAM_BATCH at a time, never all at once.
         *
         * A consumer that stops early leaves the connection mid-result, which
         * cannot be handed back to the pool, so it is destroyed instead.
         */
        async *stream(sql, params) {
          const q = adaptSql(sql, params, dialects.mysql);
          const connection = await pool.getConnection();
          const rows = connection.connection.query(q.text, q.values).stream();
          let finished = false;
          try {
            let batch = [];
            for await (const row of rows) {
              batch.push(row);
              if (batch.length >= STREAM_BATCH) {
                yield batch;
                batch = [];
              }
            }
            if (batch.length > 0) {
              yield batch;
            }
            finished = true;
          } finally {
            if (finished) {
              connection.release();
            } else {
              rows.destroy();
              connection.destroy();
            }
          }
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
              const q = adaptSql(sql, params, dialects.postgres);
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
          const q = adaptSql(sql, params, dialects.postgres);
          const res = await pool.query(q.text, q.values);
          return res.rows;
        },
        /**
         * Not streamed: `pg` reads a whole result unless pg-cursor is added,
         * and no tenant runs on PostgreSQL today. The result arrives as one
         * batch, so a caller written against stream() still works here.
         */
        async *stream(sql, params) {
          const q = adaptSql(sql, params, dialects.postgres);
          const res = await pool.query(q.text, q.values);
          if (res.rows.length > 0) {
            yield res.rows;
          }
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
        },

        /**
         * The rows of a statement, STREAM_BATCH at a time, read through a
         * result set so the driver never holds more than one batch.
         *
         * The result set and the connection are closed however the consumer
         * leaves -- to the end, on an error, or by stopping early.
         */
        async *stream(sql, params) {
          const connection = await pool.getConnection();
          let resultSet = null;
          try {
            console.log(`[SQL Stream] [copy: '${tenantId}', user: '${config.user}'] SQL: ${sql} | Params: ${JSON.stringify(params || {})}`);
            logger.info(`[SQL Stream] [copy: '${tenantId}', user: '${config.user}'] SQL: ${sql} | Params: ${JSON.stringify(params || {})}`);
            const res = await connection.execute(sql, params || {}, { resultSet: true, fetchArraySize: STREAM_BATCH });
            resultSet = res.resultSet;
            let rows = await resultSet.getRows(STREAM_BATCH);
            while (rows.length > 0) {
              yield rows;
              rows = await resultSet.getRows(STREAM_BATCH);
            }
          } finally {
            if (resultSet) {
              await resultSet.close();
            }
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
