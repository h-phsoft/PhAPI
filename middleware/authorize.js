const env = require('../config/env');
const logger = require('../utils/logger');
const ResultManager = require('../utils/responseManager');
const connectionPool = require('../core/connectionPool');
const authRepository = require('../repository/authRepository');

/**
 * Program-level authorization for the generic data endpoints.
 *
 * Authentication only establishes who the caller is and which tenant they belong
 * to; without this, any authenticated user could reach any /UC/:package/:table
 * route. The permission model already exists in the tenant database -- Cpy_Perm
 * grants a permission group (PGrp_Id) access to programs (MPrg_Id), and each
 * program carries an MPrg_ApiURL -- so this middleware reuses it rather than
 * introducing a parallel one.
 *
 * The request-to-program mapping depends on how each tenant populates
 * MPrg_ApiURL, which cannot be known ahead of time. RBAC_MODE therefore governs
 * the rollout:
 *
 *   off     - skip entirely
 *   audit   - resolve permissions and log what would be denied, but allow it
 *   enforce - deny with 403
 *
 * Run in audit until the log shows legitimate traffic resolving cleanly, then
 * switch to enforce.
 */

// key: `${tenantId}:${userId}` -> { expiresAt, unrestricted, programs:Set<string>, programIds:Set<number> }
const permissionCache = new Map();

/**
 * Reduces a request path or a stored MPrg_ApiURL to a comparable
 * "package/table" key. Routing prefixes are dropped so both sides normalise the
 * same way whether or not they carry /PhsAPI, /UC or an absolute origin.
 *
 * @param {string} value
 * @returns {string|null} null when the value has no package/table pair
 */
function normalizeTarget(value) {
  if (!value) {
    return null;
  }

  const segments = String(value)
    .replace(/^https?:\/\/[^/]+/i, '')
    .split(/[?#]/)[0]
    .split('/')
    .filter(Boolean)
    .filter((segment) => !/^(phsapi|api|uc|cc)$/i.test(segment));

  if (segments.length < 2) {
    return null;
  }
  return `${segments[0]}/${segments[1]}`.toLowerCase();
}

/**
 * Reads MPrg_Id off a driver row. Oracle upper-cases column names, MySQL and
 * Postgres do not, so all three spellings are tried.
 * @param {Object} row
 * @returns {*} The raw value, or undefined
 */
function readProgramId(row) {
  if (!row) {
    return undefined;
  }
  if (row.MPRG_ID !== undefined) {
    return row.MPRG_ID;
  }
  if (row.MPrg_Id !== undefined) {
    return row.MPrg_Id;
  }
  return row.mprg_id;
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
 * Loads and caches the set of program targets the caller may reach.
 * @returns {Promise<{unrestricted: boolean, programs: Set<string>}>}
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
        programs: new Set(),
        programIds: new Set(),
        expiresAt: Date.now() + env.rbacCacheTtlSeconds * 1000
      };
      permissionCache.set(cacheKey, entry);
      return entry;
    }

    const rows = await authRepository.getPermittedPrograms(conn, pgrpId);
    const programs = new Set();
    const programIds = new Set();

    (rows || []).forEach((row) => {
      const apiUrl = row.MPRG_APIURL || row.MPrg_ApiURL || row.mprg_apiurl;
      const target = normalizeTarget(apiUrl);
      if (target) {
        programs.add(target);
      }

      // Resources that carry a program id of their own -- attachments -- are
      // checked against these rather than against a package/table pair.
      const id = Number(readProgramId(row));
      if (Number.isInteger(id) && id > 0) {
        programIds.add(id);
      }
    });

    const entry = {
      unrestricted: false,
      programs,
      programIds,
      expiresAt: Date.now() + env.rbacCacheTtlSeconds * 1000
    };
    permissionCache.set(cacheKey, entry);
    return entry;
  } finally {
    await conn.release();
  }
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
  const target = `${pkg}/${table}`.toLowerCase();

  loadPermissions(tenantId, user)
    .then(({ unrestricted, programs }) => {
      if (unrestricted || programs.has(target)) {
        return next();
      }

      if (env.rbacMode === 'audit') {
        logger.warn(
          `[Authorize] AUDIT would deny user '${user.userId}' in copy '${tenantId}' access to '${target}' ` +
          `(${req.method} ${req.originalUrl}); ${programs.size} program(s) permitted`
        );
        return next();
      }

      logger.warn(`[Authorize] DENIED user '${user.userId}' in copy '${tenantId}' access to '${target}'`);
      return res.status(200).json(ResultManager.error(403, 'You do not have permission to access this program'));
    })
    .catch((err) => {
      // Audit must never break a working deployment; enforce fails closed.
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
authorize.clearCache = () => permissionCache.clear();
authorize.normalizeTarget = normalizeTarget;
authorize.checkProgram = checkProgram;

module.exports = authorize;
