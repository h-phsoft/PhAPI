const ResultManager = require('../utils/responseManager');
const logger = require('../utils/logger');

class Service {
  constructor(requestParams) {
    this.requestParams = requestParams;
    this.dbConn = requestParams.dbConn;
    this.tableName = requestParams.tableName;
    this.pkgName = requestParams.pkgName;
    this.userId = requestParams.userId;
    this.periodId = requestParams.periodId;
    this.vLang = requestParams.vLang;
    this.vCopy = requestParams.vCopy;
    this.debugMode = requestParams.debugMode || false;
  }

  async initForm(vParameters) {
    try {
      // Parse parameters if provided
      let params = {};
      if (vParameters) {
        try {
          params = typeof vParameters === 'string' ? JSON.parse(vParameters) : vParameters;
        } catch (e) {
          // If not JSON, use as is
          params = {data: vParameters};
        }
      }

      // Get table structure
      const [fields] = await this.dbConn.query(
        `SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
         FROM INFORMATION_SCHEMA.COLUMNS
         WHERE TABLE_NAME = ?`,
        [this.tableName]
        );

      // Get sample data
      const [sampleData] = await this.dbConn.query(
        `SELECT * FROM ${this.tableName} LIMIT 1`
        );

      const formData = {
        tableName: this.tableName,
        fields: fields.map(f => ({
            name: f.COLUMN_NAME,
            type: f.DATA_TYPE,
            nullable: f.IS_NULLABLE === 'YES',
            defaultValue: f.COLUMN_DEFAULT
          })),
        sampleData: sampleData[0] || null,
        meta: {
          pkgName: this.pkgName,
          userId: this.userId,
          periodId: this.periodId
        }
      };

      return ResultManager.ok(formData);
    } catch (error) {
      logger.error('initForm error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async list(vWhere) {
    try {
      let query = `SELECT * FROM ${this.tableName} WHERE 1=1`;
      const params = [];

      if (vWhere) {
        try {
          const whereConditions = typeof vWhere === 'string' ? JSON.parse(vWhere) : vWhere;
          for (const [key, value] of Object.entries(whereConditions)) {
            query += ` AND ${key} = ?`;
            params.push(value);
          }
        } catch (e) {
          // If vWhere is not JSON, treat as raw WHERE clause
          if (vWhere && typeof vWhere === 'string') {
            query += ` AND ${vWhere}`;
          }
        }
      }

      // Add default order
      query += ` ORDER BY id DESC`;

      const [rows] = await this.dbConn.query(query, params);
      return ResultManager.ok(rows);
    } catch (error) {
      logger.error('list error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async search(conditions, page, size) {
    try {
      let query = `SELECT * FROM ${this.tableName} WHERE 1=1`;
      const params = [];

      if (conditions && Array.isArray(conditions) && conditions.length > 0) {
        for (const condition of conditions) {
          if (condition.field && condition.value !== undefined) {
            query += ` AND ${condition.field} ${condition.operator || '='} ?`;
            params.push(condition.value);
          }
        }
      }

      const offset = (page - 1) * size;
      query += ` ORDER BY id DESC LIMIT ? OFFSET ?`;
      params.push(parseInt(size), parseInt(offset));

      const [rows] = await this.dbConn.query(query, params);

      // Get total count
      const countQuery = `SELECT COUNT(*) as total FROM ${this.tableName} WHERE 1=1`;
      const [countResult] = await this.dbConn.query(countQuery);

      return ResultManager.ok({
        data: rows,
        total: countResult[0].total,
        page: parseInt(page),
        size: parseInt(size),
        totalPages: Math.ceil(countResult[0].total / size)
      });
    } catch (error) {
      logger.error('search error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async find(queryString, page, size) {
    try {
      // Get table columns to search
      const [columns] = await this.dbConn.query(
        `SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
         WHERE TABLE_NAME = ? AND DATA_TYPE IN ('varchar', 'text', 'char')`,
        [this.tableName]
        );

      if (columns.length === 0) {
        return ResultManager.ok({data: [], page, size});
      }

      let searchQuery = `SELECT * FROM ${this.tableName} WHERE `;
      const searchConditions = columns.map(col => `${col.COLUMN_NAME} LIKE ?`).join(' OR ');
      searchQuery += searchConditions;

      const searchPattern = `%${queryString}%`;
      const params = columns.map(() => searchPattern);

      const offset = (page - 1) * size;
      searchQuery += ` ORDER BY id DESC LIMIT ? OFFSET ?`;
      params.push(parseInt(size), parseInt(offset));

      const [rows] = await this.dbConn.query(searchQuery, params);

      return ResultManager.ok({
        data: rows,
        page: parseInt(page),
        size: parseInt(size),
        query: queryString
      });
    } catch (error) {
      logger.error('find error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async get(id) {
    try {
      const [rows] = await this.dbConn.query(
        `SELECT * FROM ${this.tableName} WHERE id = ?`,
        [parseInt(id)]
        );

      if (rows.length === 0) {
        return ResultManager.invalid('Record not found');
      }

      return ResultManager.ok(rows[0]);
    } catch (error) {
      logger.error('get error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async add(entity) {
    try {
      // Add audit fields
      entity.created_by = entity.created_by || this.userId;
      entity.created_at = new Date();
      entity.updated_at = new Date();

      const [result] = await this.dbConn.query(
        `INSERT INTO ${this.tableName} SET ?`,
        [entity]
        );

      // Get the inserted record
      const [newRecord] = await this.dbConn.query(
        `SELECT * FROM ${this.tableName} WHERE id = ?`,
        [result.insertId]
        );

      return ResultManager.ok(newRecord[0] || {id: result.insertId});
    } catch (error) {
      logger.error('add error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async update(entity) {
    try {
      const id = entity.id;
      if (!id) {
        return ResultManager.invalid('ID is required for update');
      }

      delete entity.id;
      entity.updated_at = new Date();
      entity.updated_by = this.userId;

      await this.dbConn.query(
        `UPDATE ${this.tableName} SET ? WHERE id = ?`,
        [entity, parseInt(id)]
        );

      // Get updated record
      const [updatedRecord] = await this.dbConn.query(
        `SELECT * FROM ${this.tableName} WHERE id = ?`,
        [parseInt(id)]
        );

      return ResultManager.ok(updatedRecord[0] || {id});
    } catch (error) {
      logger.error('update error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async updateField(fieldName, fieldValue, id) {
    try {
      await this.dbConn.query(
        `UPDATE ${this.tableName} SET ${fieldName} = ?, updated_at = ?, updated_by = ? WHERE id = ?`,
        [fieldValue, new Date(), this.userId, parseInt(id)]
        );

      return ResultManager.success('Field updated successfully');
    } catch (error) {
      logger.error('updateField error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async updateFields(entity, id) {
    try {
      entity.updated_at = new Date();
      entity.updated_by = this.userId;

      await this.dbConn.query(
        `UPDATE ${this.tableName} SET ? WHERE id = ?`,
        [entity, parseInt(id)]
        );

      return ResultManager.success('Fields updated successfully');
    } catch (error) {
      logger.error('updateFields error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async delete(id) {
    try {
      // Check if record exists
      const [check] = await this.dbConn.query(
        `SELECT id FROM ${this.tableName} WHERE id = ?`,
        [parseInt(id)]
        );

      if (check.length === 0) {
        return ResultManager.invalid('Record not found');
      }

      await this.dbConn.query(
        `DELETE FROM ${this.tableName} WHERE id = ?`,
        [parseInt(id)]
        );

      return ResultManager.success('Record deleted successfully');
    } catch (error) {
      logger.error('delete error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async tree() {
    try {
      // Get tree structure - assumes parent_id field exists
      const [rows] = await this.dbConn.query(
        `SELECT * FROM ${this.tableName} WHERE parent_id IS NULL OR parent_id = 0`
        );

      // Get children for each parent
      const treeData = [];
      for (const parent of rows) {
        const [children] = await this.dbConn.query(
          `SELECT * FROM ${this.tableName} WHERE parent_id = ?`,
          [parent.id]
          );
        parent.children = children;
        treeData.push(parent);
      }

      return ResultManager.ok(treeData);
    } catch (error) {
      logger.error('tree error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async newTree() {
    try {
      // Get flattened tree structure
      const [rows] = await this.dbConn.query(
        `SELECT * FROM ${this.tableName} ORDER BY COALESCE(parent_id, 0), sort_order, id`
        );

      // Build tree structure
      const treeMap = {};
      const treeData = [];

      for (const row of rows) {
        const node = {...row, children: []};
        treeMap[row.id] = node;

        if (!row.parent_id || row.parent_id === 0) {
          treeData.push(node);
        } else if (treeMap[row.parent_id]) {
          treeMap[row.parent_id].children.push(node);
        }
      }

      return ResultManager.ok(treeData);
    } catch (error) {
      logger.error('newTree error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async listSave(entities) {
    try {
      const results = [];
      for (const entity of entities) {
        if (entity.id) {
          const updateResult = await this.update(entity);
          if (updateResult.success) {
            results.push({...entity, status: 'updated'});
          } else {
            results.push({...entity, status: 'failed', error: updateResult.message});
          }
        } else {
          const addResult = await this.add(entity);
          if (addResult.success) {
            results.push({...addResult.data, status: 'created'});
          } else {
            results.push({...entity, status: 'failed', error: addResult.message});
          }
        }
      }
      return ResultManager.ok(results);
    } catch (error) {
      logger.error('listSave error:', error);
      return ResultManager.invalid(error.message);
    }
  }
}

module.exports = Service;