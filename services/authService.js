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
    let copyVal = null;
    let userVal = null;
    let passVal = null;
    let periodVal = null;

    // 1. Support colon-delimited string format "MKM:admin:admin"
    if (typeof credentials === 'string') {
      const parts = credentials.trim().split(':');
      if (parts.length >= 3) {
        copyVal = parts[0];
        userVal = parts[1];
        passVal = parts[2];
        if (parts.length >= 4) periodVal = parts[3];
      }
    } else if (credentials && typeof credentials === 'object') {
      // Support string vParameters property "MKM:admin:admin"
      if (typeof credentials.vParameters === 'string' && credentials.vParameters.includes(':')) {
        const parts = credentials.vParameters.trim().split(':');
        if (parts.length >= 3) {
          copyVal = parts[0];
          userVal = parts[1];
          passVal = parts[2];
          if (parts.length >= 4) periodVal = parts[3];
        }
      } else if (typeof credentials.params === 'string' && credentials.params.includes(':')) {
        const parts = credentials.params.trim().split(':');
        if (parts.length >= 3) {
          copyVal = parts[0];
          userVal = parts[1];
          passVal = parts[2];
          if (parts.length >= 4) periodVal = parts[3];
        }
      }

      userVal = userVal || credentials.username || credentials.user || credentials.logon;
      passVal = passVal || credentials.password || credentials.pass;
      periodVal = periodVal || credentials.periodId || credentials.periodid;
      
      if (typeof userVal === 'string' && userVal.includes(':')) {
        const parts = userVal.trim().split(':');
        if (parts.length >= 3) {
          copyVal = parts[0];
          userVal = parts[1];
          passVal = parts[2];
          if (parts.length >= 4) periodVal = parts[3];
        }
      }
      
      copyVal = copyVal || credentials.copy || credentials.vCopy || credentials.vcopy || credentials.copyname || credentials.tenantId;
    }

    const loginCopy = copyVal || context.copy || context.vCopy;

    if (!loginCopy) {
      throw new AuthError('Copy parameter (copy or vCopy) is required for login', 400);
    }

    const loginUser = userVal;
    const loginPass = passVal;
    const loginPeriod = periodVal || context.periodId || 2026;

    if (!loginUser || !loginPass) {
      throw new AuthError('Username and password are required', 400);
    }



    const connectionPoolManager = require('../core/connectionPool');
    const logger = require('../utils/logger');

    let dbUser = null;
    let passwordValidated = false;
    const errors = [];
    const candidateTables = ['Cpy_User', 'Copy_Users'];

    try {
      const pool = await connectionPoolManager.getPool(loginCopy);

        const conn = await pool.getConnection();

        try {
          // 1. Try Java Check_Login function if available
          try {
            const funcSql = `SELECT Check_Login(:logon, :pass) AS UserId FROM DUAL`;
            const funcRows = await conn.query(funcSql, { logon: String(loginUser).trim(), pass: String(loginPass).trim() });
            if (funcRows && funcRows.length > 0 && funcRows[0].USERID && Number(funcRows[0].USERID) > -99) {
              const p_id = funcRows[0].USERID;
              const userSql = `SELECT Id, UGrp_Id, PGrp_Id, Gender_Id, Status_Id, Logon, Pass, Name, Picture FROM Cpy_User WHERE Id = :p_id`;
              const uRows = await conn.query(userSql, { p_id });
              if (uRows && uRows.length > 0) {
                dbUser = uRows[0];
                passwordValidated = true; // Check_Login already validated the password
              }
            }
          } catch (funcErr) {
            // Function Check_Login may not exist or failed
            logger.debug(`[AuthService] Check_Login function skipped: ${funcErr.message}`);
          }

          // 2. Iterate candidate tables if dbUser not yet resolved
          if (!dbUser) {
            for (const table of candidateTables) {
              try {
                const sql = `SELECT Id, UGrp_Id, PGrp_Id, Gender_Id, Status_Id, Logon, Pass, Name, Picture FROM ${table} WHERE LOWER(Logon) = LOWER(:logon)`;
                const rows = await conn.query(sql, [String(loginUser).trim()]);
                if (rows && rows.length > 0) {
                  dbUser = rows[0];
                  logger.info(`[AuthService] Successfully found user '${loginUser}' in table '${table}'`);
                  break;
                }
              } catch (tblErr) {
                errors.push(`${table}: ${tblErr.message}`);
              }
            }
          }
        } finally {
          await conn.release();
        }
      } catch (poolErr) {
        logger.error(`[AuthService] Database connection pool failure during login`, {
          user: loginUser,
          copy: loginCopy,
          error: poolErr.message,
          stack: poolErr.stack
        });
        throw new AuthError(`Database connection error: ${poolErr.message}`, 500);
      }

    if (!dbUser && errors.length > 0) {
      logger.error(`[AuthService] Failed user query across all candidate tables`, {
        logon: loginUser,
        copy: loginCopy,
        candidateTableErrors: errors
      });
    }

    // STRICT VALIDATION: User MUST exist in database

    if (!dbUser) {
      throw new AuthError('Invalid username or password', 401);
    }

    // STRICT VALIDATION: Check user active status and password match
    const dbPass = dbUser.pass || dbUser.PASS || dbUser.Pass;
    const statusId = dbUser.statusId || dbUser.STATUS_ID || dbUser.Status_Id;

    if (statusId !== undefined && Number(statusId) !== 1) {
      throw new AuthError('User account is inactive', 403);
    }

    if (!passwordValidated) {
      if (String(dbPass) !== String(loginPass)) {
        throw new AuthError('Invalid username or password', 401);
      }
    }

    const userId = dbUser.id || dbUser.ID || dbUser.Id || loginUser;
    const userName = dbUser.name || dbUser.NAME || dbUser.Name || loginUser;

    // Issue JWT token only after successful database verification
    const tokenPayload = {
      jui: String(userId),
      userId: String(userId),
      userName,
      Copy: String(loginCopy),
      copy: String(loginCopy),
      vCopy: String(loginCopy),
      tenantId: String(loginCopy),
      periodId: loginPeriod
    };

    const token = jwt.sign(tokenPayload, JWT_SECRET, { expiresIn: '24h' });

    return {
      token,
      userId: String(userId),
      userName,
      copy: String(loginCopy),
      vCopy: String(loginCopy),
      tenantId: String(loginCopy),
      periodId: loginPeriod,
      expiresIn: '24h'
    };
  }


}

module.exports = {
  AuthService: new AuthService(),
  AuthError
};
