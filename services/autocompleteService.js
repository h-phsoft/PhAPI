const ResultManager = require('../utils/responseManager');
const logger = require('../utils/logger');

class AutocompleteService {
  constructor(autocomplete, dbConn, mPrgId, debugMode) {
    this.autocomplete = autocomplete;
    this.dbConn = dbConn;
    this.mPrgId = mPrgId;
    this.debugMode = debugMode || false;
  }

  async autocomplete(term, size, userId) {
    try {
      if (!term || term.trim() === '') {
        return ResultManager.ok([]);
      }

      const searchField = this.autocomplete.getSearchField();
      const displayField = this.autocomplete.getDisplayField();
      const valueField = this.autocomplete.getValueField();
      const tableName = this.autocomplete.getTableName();

      let query = `SELECT ${valueField} as value, ${displayField} as label, ${searchField} as search
        FROM ${tableName}
        WHERE ${searchField} LIKE ?`;
      const params = [`%${term.trim()}%`];

      // Add custom conditions
      const conditions = this.autocomplete.getConditions();
      if (conditions && Array.isArray(conditions) && conditions.length > 0) {
        for (const condition of conditions) {
          if (condition.field && condition.value !== undefined) {
            query += ` AND ${condition.field} ${condition.operator || '='} ?`;
            params.push(condition.value);
          }
        }
      }

      // Add user-specific conditions if userId is provided
      if (userId) {
        query += ` AND (userId = ? OR userId IS NULL)`;
        params.push(userId);
      }

      const limit = size || this.autocomplete.getLimit() || 10;
      query += ` ORDER BY ${this.autocomplete.getOrderBy() || displayField} LIMIT ?`;
      params.push(parseInt(limit));

      const [rows] = await this.dbConn.query(query, params);

      // If no results, try a broader search
      if (rows.length === 0 && term.length > 0) {
        const broadQuery = query.replace('LIKE ?', 'LIKE ?');
        const broadParams = [`%${term.trim().charAt(0)}%`, ...params.slice(1)];
        const [broadRows] = await this.dbConn.query(broadQuery, broadParams);
        return ResultManager.ok(broadRows);
      }

      return ResultManager.ok(rows);
    } catch (error) {
      logger.error('AutocompleteService.autocomplete error:', error);
      return ResultManager.invalid(error.message);
    }
  }
}

module.exports = AutocompleteService;