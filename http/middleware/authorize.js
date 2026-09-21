/**
 * Turns a request into a question for the access policy, and its answer into
 * a response.
 *
 * That is all this does now. Permission loading, caching and the decision
 * itself moved to services/accessPolicy, which takes plain values -- so a
 * controller that needs to ask about a program asks the policy rather than
 * requiring a piece of middleware.
 */

const env = require('../../config/env');
const logger = require('../../utils/logger');
const ResultManager = require('../responseManager');
const sendResult = require('../sendResult');
const policy = require('../../services/accessPolicy');

function authorize(req, res, next) {
  if (env.rbacMode === 'off') {
    return next();
  }

  const params = req.params || {};
  const pkg = params.package || params.pkgName;
  const table = params.table || params.reportName;
  const mprgId = req.context && req.context.mPrgId;

  // Nothing identifies a permission: no program claimed, and no program-scoped
  // package/table pair either. InitForm, Codes and getCopies land here.
  if (!mprgId && (!pkg || !table)) {
    return next();
  }

  const user = req.user || {};
  const tenantId = (req.context && req.context.tenantId) || user.tenantId || 'default';

  policy.decide(tenantId, user, pkg, table, mprgId)
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
      return sendResult(res, ResultManager.error(403, 'You do not have permission to access this program'));
    })
    .catch((err) => {
      // Audit must never break a working deployment; enforce fails closed.
      const target = pkg && table ? `${pkg}/${table}`.toLowerCase() : `program ${mprgId}`;
      if (env.rbacMode === 'audit') {
        logger.error(`[Authorize] AUDIT permission lookup failed for '${target}': ${err.message}`);
        return next();
      }
      logger.error(`[Authorize] Permission lookup failed for '${target}': ${err.message}`);
      return sendResult(res, ResultManager.error(403, 'Unable to verify permissions'));
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

module.exports = authorize;
