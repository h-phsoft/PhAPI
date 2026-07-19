class DB {
  static async getCodes(dbConn, hModels, hCodes, pkgName, userId) {
    try {
      const [rows] = await dbConn.query(
        `SELECT * FROM sys_codes WHERE package = ? AND (userId = ? OR userId IS NULL)`,
        [pkgName, userId]
        );
      return rows;
    } catch (error) {
      throw new Error(`Failed to get codes: ${error.message}`);
    }
  }

  static async getCodeGroups(dbConn, hCodes, pkgName, groupName, codeType) {
    try {
      let query = 'SELECT * FROM sys_code_groups WHERE 1=1';
      const params = [];

      if (pkgName) {
        query += ' AND package = ?';
        params.push(pkgName);
      }
      if (groupName) {
        query += ' AND group_name = ?';
        params.push(groupName);
      }
      if (codeType && codeType !== 'ALL' && codeType !== 'all') {
        query += ' AND code_type = ?';
        params.push(codeType);
      }

      query += ' ORDER BY sort_order, group_name';

      const [rows] = await dbConn.query(query, params);
      return rows;
    } catch (error) {
      throw new Error(`Failed to get code groups: ${error.message}`);
    }
  }
}

module.exports = DB;