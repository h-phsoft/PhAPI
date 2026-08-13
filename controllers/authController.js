const { AuthService } = require('../services/authService');
const ResultManager = require('../utils/responseManager');
const i18nHelper = require('../utils/i18nHelper');

class AuthController {
  async login(req, res, next) {
    try {
      let credentials = req.body;
      const context = req.context || {};
      const lang = context.lang || req.headers['vlang'] || req.headers['vLang'] || 'en';

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

      const result = await AuthService.login(credentials, context);
      const msg = i18nHelper.getMessage('SUCCESS', lang);

      const { token, ...userData } = result;
      return res.status(200).json(ResultManager.welcome(msg, token, userData));
    } catch (err) {
      if (err.name === 'AuthError' || err.statusCode === 401) {
        return res.status(200).json(ResultManager.invalidLogin(err.message));
      }
      next(err);
    }
  }
}

module.exports = new AuthController();

