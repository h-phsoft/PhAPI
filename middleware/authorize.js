const env = require('../config/env');
const logger = require('../utils/logger');
const mainApp = require('../config/mainApp');
const ResultManager = require('../utils/responseManager');
const connectionPool = require('../core/connectionPool');
const authRepository = require('../repository/authRepository');

/**
 * Program-level authorization for the generic data endpoints.
 *
 * Authentication only establishes who the caller is and which tenant they belong
 * to; without this, any authenticated user could reach any /UC/:package/:table
 * route. The permission model already exists in the tenant database -- Cpy_Perm
 * grants a permission group (PGrp_Id) access to programs (MPrg_Id) -- so this
 * middleware reuses it rather than introducing a parallel one.
 *
 * Requests are matched to programs through MPrg_RelTable, the entity a program
 * operates on. An earlier version matched on MPrg_ApiURL instead; that column
 * holds the UI screen route ('acc/mng/CodedTables', 'acc/GeneralLedger'), which
 * shares no namespace with the /UC/:package/:table path an API call uses
 * ('acc/acc_master'). Measured across live tenants, almost nothing matched, so
 * enforcing on it would have denied nearly every program-scoped request.
 *
 * Because most programs carry no MPrg_RelTable, permission is only decided for
 * tables some active program actually binds. A table no program binds is
 * ungoverned and passes through, the same way routes with no package/table pair
 * do -- otherwise enforcement would reject the majority of legitimate traffic.
 *
 * RBAC_MODE governs the rollout:
 *
 *   off     - skip entirely
 *   audit   - resolve permissions and log what would be denied, but allow it
 *   enforce - deny with 403
 *
 * Run in audit until the log shows legitimate traffic resolving cleanly, then
 * switch to enforce.
 */

// key: `${tenantId}:${userId}` -> { expiresAt, unrestricted, tables:Set<string>, programIds:Set<number> }
const permissionCache = new Map();

// key: tenantId -> { expiresAt, tables:Set<string> } -- every table any active program binds
const governedCache = new Map();

function cacheExpiry() {
  return Date.now() + env.rbacCacheTtlSeconds * 1000;
}

/**
 * Reads a column off a driver row. Oracle upper-cases unquoted column names,
 * MySQL and Postgres preserve them, so every spelling is tried.
 *
 * @param {Object} row
 * @param {string[]} names Candidate spellings, most likely first
 * @returns {*} The first value found, or undefined
 */
function readColumn(row, names) {
  if (!row) {
    return undefined;
  }
  for (const name of names) {
    if (row[name] !== undefined) {
      return row[name];
    }
  }
  return undefined;
}

/**
 * The key both sides of the comparison reduce to: the entity a request or a
 * program actually resolves to, as "package/table".
 *
 * Resolution deliberately runs through the same mainApp.getEntity the service
 * layer uses, including its package-ignoring fallbacks. Authorizing the entity
 * that will really be touched is the point -- if a request for Acc/Daily is
 * served from Emp_Daily, that is the row the permission has to cover.
 *
 * @param {Object|null} entity
 * @returns {string|null}
 */
function entityKey(entity) {
  if (!entity || !entity.package || !entity.tableName) {
    return null;
  }
  return `${entity.package}/${entity.tableName}`.toLowerCase();
}

/**
 * Resolves a request's :package/:table pair to a comparable key.
 * @returns {string|null} null when the metadata knows no such entity
 */
function requestTarget(packageName, tableName) {
  return entityKey(mainApp.getEntity(packageName, tableName));
}

/**
 * Resolves an MPrg_RelTable value -- an entity synonym such as 'Acc_Mst' -- to
 * the same key shape a request produces.
 * @returns {string|null}
 */
function relTableTarget(relTable) {
  const name = relTable === undefined || relTable === null ? '' : String(relTable).trim();
  if (!name) {
    return null;
  }
  return entityKey(mainApp.getEntityBySynonym(name) || mainApp.getEntityByTable(name));
}

/**
 * Every table bound to an active program in this tenant, cached per tenant.
 *
 * Membership decides whether a request is subject to permissions at all, so this
 * is deliberately independent of who is asking.
 *
 * @returns {Promise<Set<string>>}
 */
async function loadGovernedTables(tenantId) {
  const cached = governedCache.get(tenantId);
  if (cached && cached.expiresAt > Date.now()) {
    return cached.tables;
  }

  const poolWrapper = await connectionPool.getPool(tenantId);
  const conn = await poolWrapper.getConnection();

  try {
    const rows = await authRepository.getProgramTables(conn);
    const tables = new Set();

    (rows || []).forEach((row) => {
      const target = relTableTarget(readColumn(row, ['MPRG_RELTABLE', 'MPrg_RelTable', 'mprg_reltable']));
      if (target) {
        tables.add(target);
      }
    });

    governedCache.set(tenantId, { tables, expiresAt: cacheExpiry() });
    return tables;
  } finally {
    await conn.release();
  }
}

/**
 * Resolves the caller's permission group, preferring the JWT claim so the common
 * path costs no extra query. Older tokens predate the claim and fall back to the
 * user record.
 * @returns {Promise<number>}
 */
async function resolvePgrpId(conn, user) {
  const claim = user.pgrpId !== undefined ? user.pgrpId : user.PGrp_Id;
  if (claim !== undefined && claim !== null && String(claim).trim() !== '') {
    return Number(claim) || 0;
  }

  const rows = await authRepository.getFullUserById(conn, user.userId);
  if (rows && rows.length > 0) {
    const row = rows[0];
    return Number(row.PGRP_ID || row.PGrp_Id || row.pgrp_id || 0) || 0;
  }
  return 0;
}

/**
 * Loads and caches what the caller may reach: the tables their granted programs
 * bind, and the ids of those programs.
 * @returns {Promise<{unrestricted: boolean, tables: Set<string>, programIds: Set<number>}>}
 */
async function loadPermissions(tenantId, user) {
  const cacheKey = `${tenantId}:${user.userId}`;
  const cached = permissionCache.get(cacheKey);
  if (cached && cached.expiresAt > Date.now()) {
    return cached;
  }

  const poolWrapper = await connectionPool.getPool(tenantId);
  const conn = await poolWrapper.getConnection();

  try {
    const pgrpId = await resolvePgrpId(conn, user);

    // Matches getMenuByPid: no group means no restriction.
    if (pgrpId <= 0) {
      const entry = {
        unrestricted: true,
        tables: new Set(),
        programIds: new Set(),
        expiresAt: cacheExpiry()
      };
      permissionCache.set(cacheKey, entry);
      return entry;
    }

    const rows = await authRepository.getPermittedPrograms(conn, pgrpId);
    const tables = new Set();
    const programIds = new Set();

    (rows || []).forEach((row) => {
      const target = relTableTarget(readColumn(row, ['MPRG_RELTABLE', 'MPrg_RelTable', 'mprg_reltable']));
      if (target) {
        tables.add(target);
      }

      // Resources that carry a program id of their own -- attachments -- are
      // checked against these rather than against a table.
      const id = Number(readColumn(row, ['MPRG_ID', 'MPrg_Id', 'mprg_id']));
      if (Number.isInteger(id) && id > 0) {
        programIds.add(id);
      }
    });

    const entry = { unrestricted: false, tables, programIds, expiresAt: cacheExpiry() };
    permissionCache.set(cacheKey, entry);
    return entry;
  } finally {
    await conn.release();
  }
}

/**
 * Decides one request.
 *
 * @returns {Promise<{allowed: boolean, target: string, reason: string}>}
 */
async function decide(tenantId, user, packageName, tableName) {
  const fallbackTarget = `${packageName}/${tableName}`.toLowerCase();

  // Checked first because in most tenants every user lands here, and it costs a
  // per-user cache hit instead of the tenant-wide governed-table lookup below.
  const { unrestricted, tables } = await loadPermissions(tenantId, user);
  if (unrestricted) {
    return { allowed: true, target: fallbackTarget, reason: 'caller has no permission group' };
  }

  // The metadata knows no such entity. The service layer will fail on it anyway,
  // and there is no program binding to check it against.
  const target = requestTarget(packageName, tableName);
  if (!target) {
    return { allowed: true, target: fallbackTarget, reason: 'unknown entity' };
  }

  if (tables.has(target)) {
    return { allowed: true, target, reason: 'granted' };
  }

  // Not granted, but only a table some active program binds can be denied.
  const governed = await loadGovernedTables(tenantId);
  if (!governed.has(target)) {
    return { allowed: true, target, reason: 'no program binds this table' };
  }

  return { allowed: false, target, reason: 'no grant covers this table' };
}

function authorize(req, res, next) {
  if (env.rbacMode === 'off') {
    return next();
  }

  const params = req.params || {};
  const pkg = params.package || params.pkgName;
  const table = params.table || params.reportName;

  // Routes without a package/table pair (InitForm, Codes, attachments) are not
  // program-scoped and carry no permission of their own.
  if (!pkg || !table) {
    return next();
  }

  const user = req.user || {};
  const tenantId = (req.context && req.context.tenantId) || user.tenantId || 'default';

  decide(tenantId, user, pkg, table)
    .then(({ allowed, target }) => {
      if (allowed) {
        return next();
      }

      if (env.rbacMode === 'audit') {
        logger.warn(
          `[Authorize] AUDIT would deny user '${user.userId}' in copy '${tenantId}' access to '${target}' ` +
          `(${req.method} ${req.originalUrl})`
        );
        return next();
      }

      logger.warn(`[Authorize] DENIED user '${user.userId}' in copy '${tenantId}' access to '${target}'`);
      return res.status(200).json(ResultManager.error(403, 'You do not have permission to access this program'));
    })
    .catch((err) => {
      // Audit must never break a working deployment; enforce fails closed.
      const target = `${pkg}/${table}`.toLowerCase();
      if (env.rbacMode === 'audit') {
        logger.error(`[Authorize] AUDIT permission lookup failed for '${target}': ${err.message}`);
        return next();
      }
      logger.error(`[Authorize] Permission lookup failed for '${target}': ${err.message}`);
      return res.status(200).json(ResultManager.error(403, 'Unable to verify permissions'));
    });
}

/**
 * Permission check for resources identified by a program id instead of a
 * package/table pair. Attachments are the case this exists for: an attachment
 * row carries the MPrg_Id of the program it belongs to, which is the same key
 * Cpy_Perm grants against, so the check reuses the cache above rather than
 * introducing a second permission model.
 *
 * RBAC_MODE is honoured exactly as the route middleware honours it, so
 * attachments never start denying ahead of the rest of the API.
 *
 * An attachment with no usable program id is treated as not program-scoped and
 * allowed, matching how the middleware skips routes that carry no package/table.
 *
 * @param {string} tenantId
 * @param {Object} user req.user
 * @param {*} mprgId Program id from the resource itself
 * @param {string} [describe] Text for the audit log, e.g. "attachment 41"
 * @returns {Promise<boolean>} false only under RBAC_MODE=enforce with no grant
 */
async function checkProgram(tenantId, user, mprgId, describe = 'resource') {
  if (env.rbacMode === 'off') {
    return true;
  }

  const id = Number(mprgId);
  if (!Number.isInteger(id) || id <= 0) {
    logger.warn(`[Authorize] ${describe} carries no program id; allowing without a permission check`);
    return true;
  }

  let permitted;
  try {
    const { unrestricted, programIds } = await loadPermissions(tenantId, user || {});
    permitted = unrestricted || programIds.has(id);
  } catch (err) {
    // Same posture as the middleware: audit must never break a working
    // deployment, enforce fails closed.
    logger.error(`[Authorize] Permission lookup failed for ${describe}: ${err.message}`);
    return env.rbacMode !== 'enforce';
  }

  if (permitted) {
    return true;
  }

  if (env.rbacMode === 'audit') {
    logger.warn(
      `[Authorize] AUDIT would deny user '${(user || {}).userId}' in copy '${tenantId}' ` +
      `access to ${describe} (program ${id})`
    );
    return true;
  }

  logger.warn(`[Authorize] DENIED user '${(user || {}).userId}' in copy '${tenantId}' access to ${describe} (program ${id})`);
  return false;
}

/** Drops cached permissions. Exposed for tests and for reacting to grant changes. */
authorize.clearCache = () => {
  permissionCache.clear();
  governedCache.clear();
};
authorize.requestTarget = requestTarget;
authorize.relTableTarget = relTableTarget;
authorize.checkProgram = checkProgram;

module.exports = authorize;
