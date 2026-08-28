const jwt = require('jsonwebtoken');
const env = require('../config/env');
const mainApp = require('../config/mainApp');
const repository = require('../repository/unifiedRepository');
const i18nHelper = require('../utils/i18nHelper');
const passwordUtil = require('../utils/password');

/**
 * Tables a copy may keep its account rows in. Older copies name it Copy_Users;
 * both are tried, in this order, wherever a user is looked up.
 */
const USER_TABLES = ['Cpy_User', 'Copy_Users'];

/**
 * Reads one column out of a driver row.
 *
 * Oracle upper-cases unquoted columns, PostgreSQL lower-cases them and MySQL
 * preserves them, so every spelling is tried before falling back to a scan.
 *
 * @param {Object} row
 * @param {string} name Column name as written in the schema, e.g. 'Status_Id'
 */
function readColumn(row, name) {
  if (row[name.toUpperCase()] !== undefined) return row[name.toUpperCase()];
  if (row[name] !== undefined) return row[name];
  const lower = name.toLowerCase();
  if (row[lower] !== undefined) return row[lower];
  const key = Object.keys(row).find((k) => k.toLowerCase() === lower);
  return key ? row[key] : undefined;
}

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
    const authRepository = require('../repository/authRepository');

    let dbUser = null;
    let passwordValidated = false;
    const errors = [];
    const candidateTables = USER_TABLES;

    try {
      const pool = await connectionPoolManager.getPool(loginCopy);
      const conn = await pool.getConnection();

      try {
        // 1. Try Java Check_Login function if available
        try {
          const funcRows = await authRepository.executeCheckLogin(conn, String(loginUser).trim(), String(loginPass).trim());

          // The alias is written `AS UserId`, but Oracle folds an unquoted alias
          // to USERID and PostgreSQL folds it to userid, so the key has to be
          // read case-insensitively. Reading only USERID silently skipped this
          // check on PostgreSQL and fell through to a comparison of the raw
          // password against the encoded stored value, which never matches.
          const firstRow = funcRows && funcRows.length > 0 ? funcRows[0] : null;
          const userIdKey = firstRow
            ? Object.keys(firstRow).find((key) => key.toLowerCase() === 'userid')
            : undefined;
          const checkedId = userIdKey ? firstRow[userIdKey] : undefined;

          if (checkedId !== undefined && checkedId !== null && Number(checkedId) > -99) {
            const p_id = checkedId;
            const uRows = await authRepository.getUserById(conn, p_id);
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
              const rows = await authRepository.getUserByLogon(conn, table, String(loginUser).trim());
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
      const { valid, legacy } = await passwordUtil.verify(loginPass, dbPass);

      if (!valid) {
        throw new AuthError('Invalid username or password', 401);
      }

      if (legacy) {
        // The stored value is still plaintext. Login is allowed so the tenant
        // keeps working, but every hit is recorded so the migration can be
        // tracked. See scripts/migratePasswords.js.
        logger.warn(`[AuthService] User '${loginUser}' in copy '${loginCopy}' authenticated against a plaintext password`);
      }
    }

    const userId = dbUser.id || dbUser.ID || dbUser.Id || loginUser;
    const userName = dbUser.name || dbUser.NAME || dbUser.Name || loginUser;

    // Carried so the authorization middleware can resolve the permission group
    // without an extra user lookup on every request.
    const pgrpId = Number(dbUser.pgrpId || dbUser.PGRP_ID || dbUser.PGrp_Id || 0) || 0;

    // Issue JWT token only after successful database verification
    const tokenPayload = {
      jui: String(userId),
      userId: String(userId),
      userName,
      pgrpId,
      Copy: String(loginCopy),
      copy: String(loginCopy),
      vCopy: String(loginCopy),
      tenantId: String(loginCopy),
      periodId: loginPeriod
    };

    const token = jwt.sign(tokenPayload, env.jwtSecret, { expiresIn: env.jwtExpiresIn });

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

  /**
   * Builds the navigation tree the client renders: menu, then type, then
   * program.
   *
   * Phs_VMIPrg carries all three on every row, so the whole tree comes from one
   * query and is grouped in memory. This replaces a recursive walk over
   * MPrg_PId that issued one query per node -- a few hundred round trips on
   * every login -- and produced program branches with no menu or type grouping.
   *
   * Every node shares one shape (id, name, icon, aList) so the client renders
   * any level with the same component.
   *
   * Menu, type and program names are translated through the locale files. The
   * stored English text is the key, so a tenant with no translations reads
   * exactly as before.
   *
   * @param {Object} conn
   * @param {number} pgrpId 0 or less means no group restriction
   * @param {string} lang Language code from the request, e.g. 'en' or 'ar'
   * @returns {Promise<Array>} Menu nodes holding type nodes holding programs
   */
  async getMenu(conn, pgrpId, lang = 'en') {
    const logger = require('../utils/logger');
    const authRepository = require('../repository/authRepository');
    const t = (label) => i18nHelper.translateLabel(label, lang);

    const col = readColumn;

    try {
      const rows = await authRepository.getMenuRows(conn, pgrpId);
      if (!rows || rows.length === 0) {
        return [];
      }

      const menus = new Map();
      const typesByMenu = new Map();

      for (const row of rows) {
        const menuId = col(row, 'Menu_Id');
        const typeId = col(row, 'Type_Id');

        if (!menus.has(menuId)) {
          menus.set(menuId, {
            id: 'menu-' + menuId,
            level: 'menu',
            menuId,
            name: t(col(row, 'Menu_Name')),
            icon: col(row, 'Menu_Image'),
            url: col(row, 'Menu_URL'),
            descr: col(row, 'Menu_Descr'),
            aList: []
          });
          typesByMenu.set(menuId, new Map());
        }

        const menu = menus.get(menuId);
        const types = typesByMenu.get(menuId);

        if (!types.has(typeId)) {
          const type = {
            id: 'type-' + menuId + '-' + typeId,
            level: 'type',
            menuId,
            typeId,
            name: t(col(row, 'Type_Name')),
            icon: col(row, 'Type_Icon'),
            aList: []
          };
          types.set(typeId, type);
          menu.aList.push(type);
        }

        // MPrg_Params is stored as an a=1&b=2 query string.
        const paramsRaw = col(row, 'MPrg_Params');
        const hParams = {};
        if (paramsRaw) {
          String(paramsRaw).split('&').forEach((pair) => {
            const parts = pair.split('=');
            if (parts.length === 2) {
              hParams[parts[0]] = parts[1];
            }
          });
        }

        types.get(typeId).aList.push({
          id: col(row, 'MPrg_Id'),
          level: 'program',
          pId: col(row, 'MPrg_PId'),
          menuId,
          typeId,
          ord: col(row, 'MPrg_Ord'),
          name: t(col(row, 'MPrg_Name')),
          url: col(row, 'MPrg_URL'),
          apiUrl: col(row, 'MPrg_ApiURL'),
          icon: col(row, 'MPrg_Icon'),
          relTable: col(row, 'MPrg_RelTable'),
          statusId: col(row, 'MPrg_Status_Id'),
          hParams,
          aList: []
        });
      }

      return Array.from(menus.values());
    } catch (err) {
      logger.error(`[AuthService] Error in getMenu: ${err.message}`);
      return [];
    }
  }

  /** Superseded by getMenu; retained for callers still walking by parent id. */
  async getMenuByPidTree(conn, pgrpId, pid) {
    let aList = [];
    try {
      const authRepository = require('../repository/authRepository');
      let rows = await authRepository.getMenuByPid(conn, pgrpId, pid);

      if (rows && rows.length > 0) {
        for (let row of rows) {
          let hParamsStr = row.MPRG_PARAMS || row.MPrg_Params || row.mprg_params;
          let hParamsObj = {};
          if (hParamsStr) {
            hParamsStr.split('&').forEach(param => {
              let parts = param.split('=');
              if (parts.length === 2) hParamsObj[parts[0]] = parts[1];
            });
          }

          let obj = {
            id: row.MPRG_ID || row.MPrg_Id || row.mprg_id,
            pId: row.MPRG_PID || row.MPrg_PId || row.mprg_pid,
            menuId: row.MENU_ID || row.Menu_Id || row.menu_id,
            menuName: row.MENU_NAME || row.Menu_Name || row.menu_name,
            menuImage: row.MENU_IMAGE || row.Menu_Image || row.menu_image,
            menuUrl: row.MENU_URL || row.Menu_URL || row.menu_url,
            menuDescr: row.MENU_DESCR || row.Menu_Descr || row.menu_descr,
            menuStatusId: row.MENU_STATUS_ID || row.Menu_Status_Id || row.menu_status_id,
            menuStatusName: row.MENU_STATUS_NAME || row.Menu_Status_Name || row.menu_status_name,
            typeId: row.TYPE_ID || row.Type_Id || row.type_id,
            typeName: row.TYPE_NAME || row.Type_Name || row.type_name,
            typeIcon: row.TYPE_ICON || row.Type_Icon || row.type_icon,
            ord: row.MPRG_ORD || row.MPrg_Ord || row.mprg_ord,
            name: row.MPRG_NAME || row.MPrg_Name || row.mprg_name,
            url: row.MPRG_URL || row.MPrg_URL || row.mprg_url,
            apiUrl: row.MPRG_APIURL || row.MPrg_ApiURL || row.mprg_apiurl,
            icon: row.MPRG_ICON || row.MPrg_Icon || row.mprg_icon,
            relTable: row.MPRG_RELTABLE || row.MPrg_RelTable || row.mprg_reltable,
            hParams: hParamsObj,
            statusId: row.MPRG_STATUS_ID || row.MPrg_Status_Id || row.mprg_status_id,
            statusName: row.MPRG_STATUS_NAME || row.MPrg_Status_Name || row.mprg_status_name,
          };
          obj.aList = await this.getMenuByPidTree(conn, pgrpId, obj.id);
          aList.push(obj);
        }
      }
    } catch (err) {
      const logger = require('../utils/logger');
      logger.error(`[AuthService] Error in getMenu: ${err.message}`);
    }
    return aList;
  }

  /**
   * Changes the signed-in user's own password.
   *
   * The current password is checked the way login checks it -- the copy's own
   * Check_Login function first, then the stored value -- so whoever can sign in
   * can also change their password, whichever scheme their row is still held
   * under. The replacement is written as a bcrypt digest, the same form
   * scripts/migratePasswords.js writes, so a change also moves that row off
   * plaintext.
   *
   * The user is identified from the token rather than the body: this endpoint
   * changes the caller's own password and nobody else's.
   *
   * @param {Object} payload { currentPassword, newPassword }
   * @param {Object} context Request context (tenantId, userId, lang)
   * @returns {Promise<Object>} { userId, userName }
   */
  async changePassword(payload = {}, context = {}) {
    const logger = require('../utils/logger');
    const connectionPoolManager = require('../core/connectionPool');
    const authRepository = require('../repository/authRepository');

    const lang = context.lang || 'en';
    const msg = (key, params) => i18nHelper.getMessage(key, lang, params);

    const currentPassword = payload.currentPassword || payload.oldPassword;
    const newPassword = payload.newPassword;

    const tenantId = context.tenantId || context.copy || context.vCopy;
    const userId = context.userId || context.jui;

    if (!tenantId || !userId) {
      throw new AuthError('Missing tenant or user context', 400);
    }

    if (!currentPassword || !newPassword) {
      throw new AuthError(msg('PASSWORD_REQUIRED'), 400);
    }

    if (String(newPassword).length < passwordUtil.MIN_LENGTH) {
      throw new AuthError(msg('PASSWORD_TOO_SHORT', { min: passwordUtil.MIN_LENGTH }), 400);
    }

    if (String(currentPassword) === String(newPassword)) {
      throw new AuthError(msg('PASSWORD_UNCHANGED'), 400);
    }

    const pool = await connectionPoolManager.getPool(tenantId);
    const conn = await pool.getConnection();

    try {
      // Which table holds the row decides which one the update writes to, so
      // the candidates are walked here rather than assumed.
      let table = null;
      let dbUser = null;

      for (const candidate of USER_TABLES) {
        try {
          const rows = await authRepository.getUserByIdFrom(conn, candidate, userId);
          if (rows && rows.length > 0) {
            table = candidate;
            dbUser = rows[0];
            break;
          }
        } catch (tableErr) {
          logger.debug(`[AuthService] changePassword: ${candidate} unavailable: ${tableErr.message}`);
        }
      }

      if (!dbUser) {
        throw new AuthError(msg('NOT_FOUND'), 404);
      }

      const rowId = readColumn(dbUser, 'Id');
      const logon = readColumn(dbUser, 'Logon');
      const statusId = readColumn(dbUser, 'Status_Id');

      if (statusId !== undefined && Number(statusId) !== 1) {
        throw new AuthError(msg('USER_INACTIVE'), 403);
      }

      let verified = false;

      // Check_Login is consulted first for the same reason login consults it:
      // some copies hold the password in a scheme only that function knows.
      // Its absence or failure is not fatal -- the stored value is checked
      // below either way.
      try {
        const rows = await authRepository.executeCheckLogin(
          conn,
          String(logon).trim(),
          String(currentPassword).trim()
        );
        const first = rows && rows.length > 0 ? rows[0] : null;
        const checkedId = first ? readColumn(first, 'UserId') : undefined;
        verified = checkedId !== undefined && checkedId !== null && Number(checkedId) === Number(rowId);
      } catch (funcErr) {
        logger.debug(`[AuthService] changePassword: Check_Login skipped: ${funcErr.message}`);
      }

      if (!verified) {
        const { valid } = await passwordUtil.verify(currentPassword, readColumn(dbUser, 'Pass'));
        verified = valid;
      }

      if (!verified) {
        throw new AuthError(msg('PASSWORD_CURRENT_INVALID'), 401);
      }

      // Explicit, so the read-back below can undo the write. Without it a
      // PostgreSQL connection commits the UPDATE on its own and there is
      // nothing left to roll back; Oracle's wrapper already holds the
      // statement open and MySQL needs the same call.
      await conn.beginTransaction();

      const digest = await passwordUtil.hash(newPassword);
      await authRepository.updateUserPassword(conn, table, rowId, digest);

      // A Pass column too narrow for a 60-character digest is the one failure
      // that would lock the user out of the account they just changed, and not
      // every backend raises on truncation. Reading the value back costs one
      // query and turns that into a rejection instead. migratePasswords.js
      // checks the same width before it writes.
      const after = await authRepository.getUserByIdFrom(conn, table, rowId);
      const storedAfter = after && after.length > 0 ? readColumn(after[0], 'Pass') : null;
      const { valid: storedOk } = await passwordUtil.verify(newPassword, storedAfter);

      if (!storedOk) {
        logger.error(
          `[AuthService] New password for user '${logon}' in copy '${tenantId}' did not survive the write; rolling back`
        );
        throw new AuthError(msg('PASSWORD_STORE_FAILED'), 500);
      }

      await conn.commit();
      logger.info(`[AuthService] Password changed for user '${logon}' in copy '${tenantId}'`);

      return { userId: String(rowId), userName: readColumn(dbUser, 'Name') || logon };
    } catch (err) {
      // Harmless on a transaction that has written nothing, which is every
      // rejection above the update.
      try {
        await conn.rollback();
      } catch (rollbackErr) {
        logger.warn(`[AuthService] Rollback after a failed password change: ${rollbackErr.message}`);
      }
      throw err;
    } finally {
      await conn.release();
    }
  }

  async getUserProfile(context = {}) {
    const connectionPoolManager = require('../core/connectionPool');
    const authRepository = require('../repository/authRepository');
    
    // Extract properly from verified JWT token context (set by authenticateToken middleware)
    const tenantId = context.tenantId || context.copy || context.vCopy || (context.user && (context.user.tenantId || context.user.Copy));
    const userId = context.userId || context.jui || (context.user && (context.user.userId || context.user.jui || context.user.sub));

    if (!tenantId || !userId) {
      const logger = require('../utils/logger');
      logger.error(`[AuthService] Missing tenant or user context in getUserProfile. Context:`, context);
      throw new AuthError('Missing tenant or user context', 400);
    }

    const pool = await connectionPoolManager.getPool(tenantId);
    const conn = await pool.getConnection();

    try {
      const formatKeys = (obj, omitKeys = []) => {
        const result = {};
        const lowerOmitKeys = omitKeys.map(k => k.toLowerCase());
        for (const key in obj) {
          if (lowerOmitKeys.includes(key.toLowerCase())) continue;
          
          // CamelCase: convert entire key to lower, then remove _ and uppercase following char
          let newKey = key.toLowerCase().replace(/_([a-z0-9])/g, (g) => g[1].toUpperCase());
          
          result[newKey] = obj[key];
        }
        return result;
      };

      let profile = {};
      let pgrpId = 0;
      
      const userRows = await authRepository.getFullUserById(conn, userId);
      if (userRows && userRows.length > 0) {
        const rawProfile = userRows[0];
        pgrpId = rawProfile.PGRP_ID || rawProfile.PGrp_Id || rawProfile.pgrp_id || 0;
        profile = formatKeys(rawProfile, ['pass', 'password']);
      }

      let permissions = {};
      if (pgrpId > 0) {
        const pgrpRows = await authRepository.getPGrpById(conn, pgrpId);
        if (pgrpRows && pgrpRows.length > 0) {
          permissions = formatKeys(pgrpRows[0], []);
        }
      }

      let programs = await this.getMenu(conn, pgrpId, context.lang || 'en');

      return {
        profile,
        permissions,
        programs
      };
    } finally {
      await conn.release();
    }
  }

}

module.exports = {
  AuthService: new AuthService(),
  AuthError
};
