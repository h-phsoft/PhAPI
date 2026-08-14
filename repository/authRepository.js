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

  async getMenuByPid(conn, pgrpId, pid) {
    let sql = `SELECT Menu_Id, Menu_Name, Menu_Image, Menu_URL, Menu_Descr,
                       Menu_Status_Id, Menu_Status_Name,
                       Type_Id, Type_Name, Type_Icon,
                       MPrg_Id, MPrg_PId, MPrg_Ord,
                       MPrg_Name, MPrg_URL, MPrg_ApiURL, MPrg_Icon,
                       MPrg_Params, MPrg_RelTable, MPrg_Status_Id, MPrg_Status_Name
                FROM Phs_VMIPrg
                WHERE MPrg_ID > 0 AND MPrg_PId = :pid AND MPrg_Status_Id = 1 AND Menu_Status_Id = 1`;
    
    if (pgrpId > 0) {
      sql += ` AND MPrg_Id IN (SELECT MPrg_Id FROM Cpy_Perm WHERE PGrp_Id = ${pgrpId} AND OK = 1)`;
    }
    sql += ` ORDER BY Menu_Id, MPrg_PId, MPrg_Ord`;

    // Ensure pid is passed properly in the params object
    return conn.query(sql, { pid: Number(pid) || 0 });
  }
}

module.exports = new AuthRepository();
