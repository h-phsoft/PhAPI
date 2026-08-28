const connectionPool = require('../core/connectionPool');

class AuthRepository {
  async executeCheckLogin(conn, logon, pass) {
    const sql = `SELECT Check_Login(:logon, :pass) AS UserId FROM DUAL`;
    return conn.query(sql, {logon, pass});
  }

  async getUserById(conn, id) {
    const sql = `SELECT Id, UGrp_Id, PGrp_Id, Gender_Id, Status_Id, Logon, Pass, Name, Picture FROM Cpy_User WHERE Id = :id`;
    return conn.query(sql, {id});
  }

  async getUserByLogon(conn, table, logon) {
    const sql = `SELECT Id, UGrp_Id, PGrp_Id, Gender_Id, Status_Id, Logon, Pass, Name, Picture FROM ${table} WHERE LOWER(Logon) = LOWER(:logon)`;
    return conn.query(sql, [logon]);
  }

  async getFullUserById(conn, userId) {
    return conn.query('SELECT * FROM Cpy_User WHERE Id = :userId', {userId});
  }

  async getPGrpById(conn, pgrpId) {
    return conn.query('SELECT * FROM Cpy_PGrp WHERE Id = :pgrpId', {pgrpId});
  }

  /**
   * Every program the given permission group may reach, regardless of menu
   * nesting. Used by the authorization middleware rather than for rendering.
   *
   * A pgrpId of 0 or less means "no group restriction", matching how getMenuByPid
   * already treats it.
   *
   * MPrg_RelTable is what ties a program to the data it governs. MPrg_ApiURL is
   * the UI screen route ('acc/mng/CodedTables') and does not correspond to the
   * /UC/:package/:table path an API call uses, so it cannot be matched against
   * one; MPrg_RelTable holds an entity synonym ('Acc_Mst') that can.
   *
   * @param {Object} conn
   * @param {number} pgrpId
   * @returns {Promise<Array>} rows of MPrg_Id / MPrg_Name / MPrg_ApiURL / MPrg_RelTable
   */
  async getPermittedPrograms(conn, pgrpId) {
    let sql = `SELECT MPrg_Id, MPrg_Name, MPrg_ApiURL, MPrg_RelTable
               FROM Phs_VMIPrg
               WHERE MPrg_Id > 1 AND MPrg_Status_Id = 1 AND Menu_Status_Id = 1`;
    const params = {};

    if (pgrpId > 0) {
      sql += ` AND MPrg_Id IN (SELECT MPrg_Id FROM Cpy_Perm WHERE PGrp_Id = :pgrpId AND OK = 1)`;
      params.pgrpId = Number(pgrpId);
    }

    return conn.query(sql, params);
  }

  /**
   * Every table bound to an active program, ignoring permission groups.
   *
   * This is the set of tables that are governed at all. A table no program binds
   * carries no permission of its own and must not be denied -- most programs have
   * no MPrg_RelTable, so without this distinction enforcement would reject nearly
   * every request.
   *
   * @param {Object} conn
   * @returns {Promise<Array>} rows of MPrg_RelTable
   */
  async getProgramTables(conn) {
    return conn.query(
      `SELECT DISTINCT MPrg_RelTable
       FROM Phs_VMIPrg
       WHERE MPrg_Id > 1 AND MPrg_Status_Id = 1 AND Menu_Status_Id = 1
         AND MPrg_RelTable IS NOT NULL`
      );
  }

  /**
   * Every menu row the permission group may reach, in one query.
   *
   * The tree is grouped in memory afterwards, so this deliberately does not
   * filter on MPrg_PId or recurse. The previous approach issued one query per
   * node, which for a few hundred entries meant a few hundred round trips on
   * every login.
   *
   * Ordering is by menu, then type, then the program's own order, so the
   * grouping can rely on the sequence rather than sorting again.
   *
   * Because the grouping is flat, a disabled parent no longer prunes its
   * subtree the way the recursive walk did, so the parent's status is checked
   * explicitly. Without it a disabled module such as Point of Sale keeps
   * showing every screen underneath it.
   *
   * @param {Object} conn
   * @param {number} pgrpId 0 or less means no group restriction
   * @returns {Promise<Array>}
   */
  async getMenuRows(conn, pgrpId) {
    let sql = `SELECT Menu_Id, Menu_Name, Menu_Image, Menu_URL, Menu_Descr,
                      Menu_Status_Id, Menu_Status_Name,
                      Type_Id, Type_Name, Type_Icon,
                      MPrg_Id, MPrg_PId, MPrg_Ord,
                      MPrg_Name, MPrg_URL, MPrg_ApiURL, MPrg_Icon,
                      MPrg_Params, MPrg_RelTable, MPrg_Status_Id, MPrg_Status_Name
                 FROM Phs_VMIPrg V
                WHERE V.MPrg_ID > 1 AND V.MPrg_Status_Id = 1 AND V.Menu_Status_Id = 1 AND V.MPrg_PId != 0
                  AND EXISTS (SELECT 1 FROM Phs_MPrg P
                               WHERE P.Id = V.MPrg_PId AND P.Status_Id = 1)`;
    const params = {};

    if (pgrpId > 0) {
      sql += ` AND V.MPrg_Id IN (SELECT MPrg_Id FROM Cpy_Perm WHERE PGrp_Id = :pgrpId AND OK = 1)`;
      params.pgrpId = Number(pgrpId);
    }

    sql += ` ORDER BY V.Menu_Id, V.Type_Id, V.MPrg_Ord, V.MPrg_Id`;

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
                WHERE MPrg_ID > 1 AND MPrg_PId = :pid AND MPrg_Status_Id = 1 AND Menu_Status_Id = 1`;

    const params = {pid: Number(pid) || 0};

    if (pgrpId > 0) {
      sql += ` AND MPrg_Id IN (SELECT MPrg_Id FROM Cpy_Perm WHERE PGrp_Id = :pgrpId AND OK = 1)`;
      params.pgrpId = Number(pgrpId);
    }
    sql += ` ORDER BY Menu_Id, MPrg_PId, MPrg_Ord`;

    return conn.query(sql, params);
  }
}

module.exports = new AuthRepository();
