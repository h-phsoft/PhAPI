const { AuthService } = require('../services/authService');
const i18nHelper = require('../utils/i18nHelper');

class AuthController {
  /**
   * Pure controller action for handling POST /PhsAPI/Auth/Login requests.
   * Delegates all business and database logic strictly to AuthService.
   */
  async login(req, res, next) {
    try {
      const credentials = req.body;
      const context = req.context || {};
      const lang = context.lang || req.headers['accept-language'] || req.query?.lang || 'en';

      const result = await AuthService.login(credentials, context);

      const msg = i18nHelper.getMessage('SUCCESS', lang);
      return res.status(200).json({
        success: true,
        status: 200,
        messageKey: 'SUCCESS',
        message: msg,
        data: result
      });
    } catch (err) {
      next(err);
    }
  }
}

module.exports = new AuthController();
