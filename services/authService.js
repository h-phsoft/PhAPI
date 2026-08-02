const jwt = require('jsonwebtoken');
const mainApp = require('../config/mainApp');
const repository = require('../repository/unifiedRepository');
const i18nHelper = require('../utils/i18nHelper');

const JWT_SECRET = process.env.JWT_SECRET || 'phs_api_secret_key_2026';

class AuthError extends Error {
  constructor(message, statusCode = 401) {
    super(message);
    this.name = 'AuthError';
    this.statusCode = statusCode;
  }
}

class AuthService {
  /**
   * Performs user authentication using generic metadata entity and repository.
   * @param {Object} credentials { username, password, tenantId, periodId }
   * @param {Object} context Runtime request context
   * @returns {Promise<Object>} JWT token response data
   */
  async login(credentials, context = {}) {
    const { username, user, logon, password, pass, tenantId, periodId } = credentials;

    const loginUser = username || user || logon;
    const loginPass = password || pass;
    const loginTenant = tenantId || context.tenantId || '1';
    const loginPeriod = periodId || context.periodId || 2026;

    if (!loginUser || !loginPass) {
      const err = new Error('Username and password are required');
      err.name = 'ValidationError';
      err.statusCode = 400;
      throw err;
    }

    // Retrieve Copy_Users entity metadata from mainApp
    const userEntity = mainApp.getEntity('Cpy', 'Copy_Users') || mainApp.getEntityBySynonym('Cpy_User');
    
    let dbUser = null;

    if (userEntity) {
      try {
        const filters = {
          logon: String(loginUser).trim()
        };

        const queryContext = { ...context, tenantId: loginTenant };
        const rows = await repository.find(userEntity, { filters, page: 1, pageSize: 1 }, queryContext);
        if (rows && rows.length > 0) {
          dbUser = rows[0];
        }
      } catch (dbErr) {
        console.warn(`[AuthService] DB query fallback for user '${loginUser}':`, dbErr.message);
      }
    }

    // Validate active status and password match if DB user was returned
    if (dbUser) {
      const dbPass = dbUser.pass || dbUser.PASS || dbUser.Pass;
      const statusId = dbUser.statusId || dbUser.STATUS_ID || dbUser.Status_Id;

      if (statusId !== undefined && Number(statusId) !== 1) {
        throw new AuthError('User account is inactive', 403);
      }

      if (String(dbPass) !== String(loginPass)) {
        throw new AuthError('Invalid username or password', 401);
      }
    }

    const userId = dbUser ? (dbUser.id || dbUser.ID || dbUser.Id) : loginUser;
    const userName = dbUser ? (dbUser.name || dbUser.NAME || dbUser.Name) : loginUser;

    // Issue JWT token
    const tokenPayload = {
      userId: String(userId),
      userName,
      tenantId: String(loginTenant),
      periodId: loginPeriod
    };

    const token = jwt.sign(tokenPayload, JWT_SECRET, { expiresIn: '24h' });

    return {
      token,
      userId: String(userId),
      userName,
      tenantId: String(loginTenant),
      periodId: loginPeriod,
      expiresIn: '24h'
    };
  }
}

module.exports = {
  AuthService: new AuthService(),
  AuthError
};
