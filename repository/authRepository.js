const connectionPool = require('../core/connectionPool');

class AuthRepository {
  async executeCheckLogin(conn, logon, pass) {
    const sql = `SELECT Check_Login(:logon, :pass) AS UserId FROM DUAL`;
    return conn.query(sql, { logon, pass });
  }

  async getUserById(conn, id) {
    const sql = `SELECT Id, UGrp_Id, PGrp_Id, Gender_Id, Status_Id, Logon, Pass, Name, Picture FROM Cpy_User WHERE Id = :id`;
    return conn.query(sql, { id });
  }

  async getUserByLogon(conn, table, logon) {
    const sql = `SELECT Id, UGrp_Id, PGrp_Id, Gender_Id, Status_Id, Logon, Pass, Name, Picture FROM ${table} WHERE LOWER(Logon) = LOWER(:logon)`;
    return conn.query(sql, [logon]);
  }

  async getFullUserById(conn, userId) {
    return conn.query('SELECT * FROM Cpy_User WHERE Id = :userId', { userId });
  }

  async getPGrpById(conn, pgrpId) {
    return conn.query('SELECT * FROM Cpy_PGrp WHERE Id = :pgrpId', { pgrpId });
  }

  /**
   * Every program the given permission group may reach, regardless of menu
   * nesting. Used by the authorization middleware rather than for rendering.
   *
   * A pgrpId of 0 or less means "no group restriction", matching how getMenuByPid
   * already treats it.
   *
   * @param {Object} conn
   * @param {number} pgrpId
   * @returns {Promise<Array>} rows of MPrg_Id / MPrg_Name / MPrg_ApiURL
   */
  async getPermittedPrograms(conn, pgrpId) {
    let sql = `SELECT MPrg_Id, MPrg_Name, MPrg_ApiURL
               FROM Phs_VMIPrg
               WHERE MPrg_Id > 0 AND MPrg_Status_Id = 1 AND Menu_Status_Id = 1`;
    const params = {};

    if (pgrpId > 0) {
      sql += ` AND MPrg_Id IN (SELECT MPrg_Id FROM Cpy_Perm WHERE PGrp_Id = :pgrpId AND OK = 1)`;
      params.pgrpId = Number(pgrpId);
    }

    return conn.query(sql, params);
  }

  async getMenuByPid(conn, pgrpId, pid) {
    let sql = `SELECT Menu_Id, Menu_Name, Menu_Image, Menu_URL, Menu_Descr,
                       Menu_Status_Id, Menu_Status_Name,
                       Type_Id, Type_Name, Type_Icon,
                       MPrg_Id, MPrg_PId, MPrg_Ord,
                       MPrg_Name, MPrg_URL, MPrg_ApiURL, MPrg_Icon,
                       MPrg_Params, MPrg_RelTable, MPrg_Status_Id, MPrg_Status_Name
                FROM Phs_VMIPrg
                WHERE MPrg_ID > 0 AND MPrg_PId = :pid AND MPrg_Status_Id = 1 AND Menu_Status_Id = 1`;
    
    const params = { pid: Number(pid) || 0 };

    if (pgrpId > 0) {
      sql += ` AND MPrg_Id IN (SELECT MPrg_Id FROM Cpy_Perm WHERE PGrp_Id = :pgrpId AND OK = 1)`;
      params.pgrpId = Number(pgrpId);
    }
    sql += ` ORDER BY Menu_Id, MPrg_PId, MPrg_Ord`;

    return conn.query(sql, params);
  }
}

module.exports = new AuthRepository();
