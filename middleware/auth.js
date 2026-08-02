const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'phs_api_secret_key_2026';

function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      status: 401,
      messageKey: 'UNAUTHORIZED',
      message: 'Access token is required'
    });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        status: 403,
        messageKey: 'FORBIDDEN',
        message: 'Invalid or expired token'
      });
    }

    // Attach decoded user info to request context
    req.user = {
      userId: user.userId || user.sub,
      tenantId: user.tenantId || 'default',
      periodId: user.periodId || null,
      ...user
    };

    next();
  });
}

module.exports = authenticateToken;