const jwt = require('jsonwebtoken');
const env = require('../config/env');

class JWebToken {
  static getInstanceByAuthorization(authorization) {
    if (!authorization) {
      throw new Error('Authorization header is required');
    }

    const token = authorization.replace('Bearer ', '');
    try {
      const decoded = jwt.verify(token, env.jwtSecret);
      return {
        getPayload: () => decoded
      };
    } catch (error) {
      throw new Error('Invalid or expired token');
    }
  }

  static generateToken(payload) {
    return jwt.sign(payload, env.jwtSecret, {expiresIn: env.jwtExpiresIn});
  }

  static verifyToken(token) {
    try {
      return jwt.verify(token, env.jwtSecret);
    } catch (error) {
      return null;
    }
  }
}

module.exports = JWebToken;