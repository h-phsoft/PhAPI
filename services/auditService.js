const env = require('../config/env');
const logger = require('../utils/logger');
const connectionPool = require('../core/connectionPool');

/**
 * Writes an audit trail of mutations into each tenant's Phs_Logs table.
 *
 * Recording is fire-and-forget: an audit failure must never turn a successful
 * write into a failed request. Because the table is not guaranteed to exist in
 * every tenant, repeated failures trip a per-tenant breaker so a missing table
 * costs one warning rather than one per request forever.
 */

const TABLE = 'Phs_Logs';
const MAX_TEXT_LENGTH = 2000;
const FAILURE_THRESHOLD = 3;

// tenantId -> consecutive failure count. At the threshold the tenant is skipped.
const failureCounts = new Map();

/** @returns {string} Caller IP, preferring the proxy header Express resolves. */
function clientIp(req) {
  return (req && (req.ip || (req.connection && req.connection.remoteAddress))) || '';
}

function truncate(value) {
  const text = value === undefined || value === null ? '' : String(value);
  return text.length > MAX_TEXT_LENGTH ? `${text.slice(0, MAX_TEXT_LENGTH - 3)}...` : text;
}

class AuditService {
  /**
   * Records one audit entry. Never throws and never rejects.
   *
   * @param {Object} options
   * @param {string} options.type Short event type, e.g. 'CREATE' or 'DELETE'
   * @param {string} options.text Human-readable description
   * @param {Object} options.context Request context (tenantId, userId)
   * @param {Object} [options.req] Express request, for IP and host
   * @returns {Promise<boolean>} True when the entry was written
   */
  async record({ type, text, context = {}, req = null }) {
    if (!env.auditLogEnabled) {
      return false;
    }

    const tenantId = context.tenantId || 'default';

    if ((failureCounts.get(tenantId) || 0) >= FAILURE_THRESHOLD) {
      return false;
    }

    let conn = null;
    try {
      const poolWrapper = await connectionPool.getPool(tenantId);
      conn = await poolWrapper.getConnection();

      const params = {
        vtype: truncate(type),
        vtext: truncate(text),
        vuser: String(context.userId || ''),
        vip: clientIp(req),
        vhost: (req && req.hostname) || '',
        vport: String((req && req.socket && req.socket.localPort) || ''),
        vrem: ''
      };

      const sql = poolWrapper.dbType === 'oracle'
        ? `INSERT INTO ${TABLE} (Vtype, Vtext, Vuser, Vip, Vhost, Vport, Vrem, Ddate)
           VALUES (:vtype, :vtext, :vuser, :vip, :vhost, :vport, :vrem, SYSDATE)`
        : `INSERT INTO ${TABLE} (Vtype, Vtext, Vuser, Vip, Vhost, Vport, Vrem, Ddate)
           VALUES (?, ?, ?, ?, ?, ?, ?, NOW())`;

      const values = poolWrapper.dbType === 'oracle' ? params : Object.values(params);

      await conn.query(sql, values);
      await conn.commit();

      failureCounts.delete(tenantId);
      return true;
    } catch (err) {
      const count = (failureCounts.get(tenantId) || 0) + 1;
      failureCounts.set(tenantId, count);

      if (count >= FAILURE_THRESHOLD) {
        logger.warn(
          `[Audit] Disabling audit writes for copy '${tenantId}' after ${count} consecutive failures. ` +
          `Last error: ${err.message}`
        );
      } else {
        logger.warn(`[Audit] Failed to record '${type}' for copy '${tenantId}': ${err.message}`);
      }
      return false;
    } finally {
      if (conn) {
        try {
          await conn.release();
        } catch (releaseErr) {
          // Nothing useful to do; the pool will reclaim it.
        }
      }
    }
  }

  /**
   * Schedules a record without making the caller wait, so request latency is
   * unaffected. Rejections are already swallowed by record().
   */
  recordAsync(options) {
    setImmediate(() => {
      this.record(options);
    });
  }

  /** Clears the failure breakers. Exposed for tests and for retrying after a fix. */
  resetBreakers() {
    failureCounts.clear();
  }

  /** @returns {number} Current consecutive failure count for a tenant. */
  failureCount(tenantId) {
    return failureCounts.get(tenantId) || 0;
  }
}

module.exports = new AuditService();
module.exports.FAILURE_THRESHOLD = FAILURE_THRESHOLD;
