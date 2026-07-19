const jwt = require('jsonwebtoken');
require('dotenv').config();

class JWebToken {
  static getInstanceByAuthorization(authorization) {
    if (!authorization) {
      throw new Error('Authorization header is required');
    }

    const token = authorization.replace('Bearer ', '');
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      return {
        getPayload: () => decoded
      };
    } catch (error) {
      throw new Error('Invalid or expired token');
    }
  }

  static generateToken(payload) {
    return jwt.sign(payload, process.env.JWT_SECRET, {expiresIn: '24h'});
  }

  static verifyToken(token) {
    try {
      return jwt.verify(token, process.env.JWT_SECRET);
    } catch (error) {
      return null;
    }
  }
}

module.exports = JWebToken;