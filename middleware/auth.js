const JWebToken = require('../utils/jwtToken');
const ResultManager = require('../utils/responseManager');

const authMiddleware = async (req, res, next) => {
  try {
    const authorization = req.headers.authorization;
    if (!authorization) {
      return res.status(401).json(ResultManager.invalid('Authorization header is required'));
    }

    try {
      const token = JWebToken.getInstanceByAuthorization(authorization);
      const payload = token.getPayload();

      req.userId = payload.jui || payload.userId || payload.id;
      req.vCopy = payload.Copy || payload.vCopy || '';
      req.userData = payload;

      // Extract additional headers
      req.mPrgId = req.headers.mprgid || req.headers.mprgid;
      req.periodId = req.headers.periodid || req.headers.periodid || 1;
      req.vLang = req.headers.vlang || req.headers.vlang || 'en';

      next();
    } catch (error) {
      return res.status(401).json(ResultManager.invalid(error.message || 'Invalid token'));
    }
  } catch (error) {
    return res.status(401).json(ResultManager.invalid('Authentication failed'));
  }
};

module.exports = authMiddleware;