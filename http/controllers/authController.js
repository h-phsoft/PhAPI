/* global Buffer */

const {AuthService} = require('../../services/authService');
const ResultManager = require('../responseManager');
const sendResult = require('../sendResult');
const i18nHelper = require('../../utils/i18nHelper');
const auditService = require('../../services/auditService');
const requestOrigin = require('../requestOrigin');
const { localizeMenu } = require('../../presentation/labels');
const { describeMenu } = require('../../presentation/screens');

class AuthController {
  async login(req, res, next) {
    const logger = require('../../utils/logger');
    let credentials = req.body;
    const context = req.context || {};
    const lang = context.lang || req.headers['vlang'] || req.headers['vLang'] || 'en';

    try {
      const authHeader = req.headers['authorization'] || req.headers['Authorization'];
      if (authHeader && authHeader.toLowerCase().startsWith('basic ')) {
        const base64Str = authHeader.substring(6);
        const decoded = Buffer.from(base64Str, 'base64').toString('utf8');
        if (!credentials || Object.keys(credentials).length === 0 || (typeof credentials === 'string' && credentials.trim() === '')) {
          credentials = decoded;
        } else {
          credentials.vParameters = decoded; // let authService pick it up
        }
      }

      logger.info(`[AuthController] Login attempt initiated from IP: ${req.ip}`);
      const result = await AuthService.login(credentials, context);
      const msg = i18nHelper.getMessage('SUCCESS', lang);

      const {token, ...userData} = result;
      logger.info(`[AuthController] Login successful for user: ${userData.username || 'unknown'} in tenant: ${userData.tenantId || 'unknown'}`);
      return res.status(200).json(ResultManager.welcome(msg, token, userData));
    } catch (err) {
      if (err.name === 'AuthError' || err.statusCode === 401) {
        logger.warn(`[AuthController] Login failed from IP: ${req.ip} - Reason: ${err.message}`);
        // Failures are reported as HTTP 200 for the legacy client, so the rate
        // limiter cannot read the status code. Flag it explicitly instead.
        res.locals.loginFailed = true;
        return sendResult(res, ResultManager.invalidLogin(err.message));
      }
      logger.error(`[AuthController] Unexpected error during login: ${err.message}`);
      next(err);
    }
  }

  async logout(req, res, next) {
    try {
      const logger = require('../../utils/logger');
      const user = req.user || {};
      logger.info(`[AuthController] Logout requested for user: ${user.userId || 'unknown'} in tenant: ${user.tenantId || 'unknown'}`);
      
      return res.status(200).json(ResultManager.success('Logged out successfully'));
    } catch (err) {
      next(err);
    }
  }
  async changePassword(req, res, next) {
    const logger = require('../../utils/logger');
    try {
      const context = req.context || {};
      const lang = context.lang || req.headers['vlang'] || req.headers['vLang'] || 'en';

      await AuthService.changePassword(req.body || {}, context);

      auditService.recordAsync({
        type: 'PASSWORD',
        text: `Password changed for user id=${context.userId}`,
        context,
        origin: requestOrigin(req)
      });

      logger.info(`[AuthController] Password changed for user: ${context.userId} in tenant: ${context.tenantId}`);
      return res.status(200).json(ResultManager.success(i18nHelper.getMessage('PASSWORD_CHANGED', lang)));
    } catch (err) {
      if (err.name === 'AuthError') {
        // A mistyped current password is the ordinary outcome here, so these
        // are reported to the caller rather than escalated to the error handler.
        logger.warn(
          `[AuthController] Password change rejected for user ${(req.context || {}).userId}: ${err.message}`
        );
        return sendResult(res, ResultManager.error(err.statusCode || 400, err.message));
      }
      next(err);
    }
  }

  async getUserProfile(req, res, next) {
    try {
      const context = req.context || {};
      const lang = context.lang || req.headers['vlang'] || req.headers['vLang'] || 'en';

      // Translated, then marked: a program the client holds no component for
      // may still have a screen described, and this is what tells it so.
      const result = describeMenu(localizeMenu(await AuthService.getUserProfile(context), lang));
      const msg = i18nHelper.getMessage('SUCCESS', lang);

      return res.status(200).json(ResultManager.ok(msg, result));
    } catch (err) {
      next(err);
    }
  }

  async getProgramOptions(req, res, next) {
    try {
      const context = req.context || {};
      const lang = context.lang || req.headers['vlang'] || req.headers['vLang'] || 'en';
      const menuId = req.params.menuId;

      const connectionPoolManager = require('../../core/connectionPool');
      const tenantId = context.tenantId || context.copy || context.vCopy || (context.user && (context.user.tenantId || context.user.Copy));
      const pool = await connectionPoolManager.getPool(tenantId);
      const conn = await pool.getConnection();

      try {
        const pgrpId = Number(req.user?.pgrpId || 0);
        const result = describeMenu(localizeMenu(await AuthService.getProgramOptions(conn, pgrpId, menuId, lang), lang));
        return res.status(200).json(ResultManager.ok('Success', result));
      } finally {
        await conn.release();
      }
    } catch (err) {
      next(err);
    }
  }
}

module.exports = new AuthController();

