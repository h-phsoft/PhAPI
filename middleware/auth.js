/* global process */

const jwt = require('jsonwebtoken');
const ResultManager = require('../utils/responseManager');

const JWT_SECRET = process.env.JWT_SECRET || 'phs_api_secret_key_2026';

function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && (authHeader.startsWith('Bearer ') ? authHeader.split(' ')[1] : authHeader);

  if (!token) {
    return res.status(200).json(ResultManager.error(401, 'Access token is required'));
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(200).json(ResultManager.error(403, 'Invalid or expired token'));
    }

    // Support both Java token payload (jui, Copy) and standard Node payload (userId, tenantId)
    const userId = user.jui || user.userId || user.sub || '1';
    const tenantId = user.Copy || user.tenantId || 'default';
    const periodId = user.periodId || null;

    req.user = {
      userId,
      tenantId,
      periodId,
      authorization: authHeader,
      ...user
    };

    next();
  });
}

module.exports = authenticateToken;