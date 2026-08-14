const mainApp = require('../config/mainApp');
const connectionPool = require('../core/connectionPool');
const repository = require('../repository/unifiedRepository');
const AutoNumberHelper = require('../utils/autoNumber');

class ValidationError extends Error {
  constructor(message, details = []) {
    super(message);
    this.name = 'ValidationError';
    this.statusCode = 400;
    this.details = details;
  }
}

class UnifiedService {
  /**
   * Validates input payload against entity metadata.
   */
  validatePayload(entity, data, isUpdate = false) {
    const errors = [];
    const validFieldsMap = new Map();

    for (const fieldMeta of entity.fields) {
      validFieldsMap.set(fieldMeta.Field.toLowerCase(), fieldMeta);
    }

    // Check for unsupported fields in request body
    for (const key of Object.keys(data)) {
      if (!validFieldsMap.has(key.toLowerCase()) && key !== 'children' && key !== entity.primaryKey) {
        // If entity has children defined in metadata, allow child keys
        const isChildKey = entity.children && entity.children.some(c => c.childKey.toLowerCase() === key.toLowerCase());
        if (!isChildKey) {
          errors.push(`Field '${key}' is not defined in metadata for entity ${entity.tableName}`);
        }
      }
    }

    // Field-level validations
    for (const fieldMeta of entity.fields) {
      const fieldName = fieldMeta.Field;
      const isPresent = data.hasOwnProperty(fieldName);
      const val = data[fieldName];

      // Insert / Update permissions
      if (!isUpdate && isPresent && fieldMeta.insert === false && !fieldMeta.isAutonumber) {
        errors.push(`Field '${fieldName}' is read-only on create`);
      }
      if (isUpdate && isPresent && fieldMeta.update === false) {
        errors.push(`Field '${fieldName}' is read-only on update`);
      }

      // Required fields check (isNull === false, not autonumber, not primaryKey on create)
      if (!isUpdate && !fieldMeta.isNull && !fieldMeta.isAutonumber && fieldName !== entity.primaryKey) {
        if (!isPresent || val === null || val === undefined || val === '') {
          errors.push(`Field '${fieldName}' is required`);
        }
      }

      // Type checking
      if (isPresent && val !== null && val !== undefined) {
        const type = fieldMeta.Type ? fieldMeta.Type.toLowerCase() : 'string';
        if (type === 'integer' || type === 'number') {
          if (isNaN(Number(val))) {
            errors.push(`Field '${fieldName}' must be a valid number`);
          }
        } else if (type === 'boolean') {
          if (typeof val !== 'boolean' && val !== 0 && val !== 1 && val !== 'true' && val !== 'false') {
            errors.push(`Field '${fieldName}' must be a boolean`);
          }
        }
      }
    }

    if (errors.length > 0) {
      throw new ValidationError(`Validation failed for entity ${entity.tableName}`, errors);
    }
  }

  /**
   * Injects audit fields into data object.
   */
  injectAuditFields(entity, data, context, isUpdate = false) {
    if (!entity.auditFields) return;

    const { createdBy, createdAt, updatedAt, updatedBy } = entity.auditFields;
    const now = new Date();
    const userId = context.userId || 'system';

    if (!isUpdate) {
      if (createdBy) data[createdBy] = userId;
      if (createdAt) data[createdAt] = now;
    }

    if (updatedBy) data[updatedBy] = userId;
    if (updatedAt) data[updatedAt] = now;
  }

  /**
   * Creates a record, with full parent-child transaction support.
   */
  async create(packageName, tableName, data, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    // 1. Validate master payload
    this.validatePayload(entity, data, false);

    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);
    const conn = await poolWrapper.getConnection();

    try {
      await conn.beginTransaction();

      const txContext = { ...context, dbType: poolWrapper.dbType };

      // 2. Process autonumber fields
      for (const fieldMeta of entity.fields) {
        if (fieldMeta.isAutonumber && fieldMeta.Autonumber) {
          const generatedNum = await AutoNumberHelper.generate(conn, poolWrapper.dbType, fieldMeta, txContext);
          if (generatedNum !== null) {
            data[fieldMeta.Field] = generatedNum;
          }
        }
      }

      // 3. Inject audit fields
      this.injectAuditFields(entity, data, context, false);

      // 5. Insert master row
      const { insertedId } = await repository.insert(entity, data, txContext, conn);
      const masterKey = insertedId || data[entity.primaryKey];

      // 7-9. Handle child arrays if hasChilds = true
      if (entity.hasChilds && entity.children && Array.isArray(entity.children)) {
        for (const childConfig of entity.children) {
          const childKey = childConfig.childKey;
          const childRows = data[childKey];

          if (childRows && Array.isArray(childRows)) {
            const childEntity = mainApp.getEntity(packageName, childConfig.table) ||
                                mainApp.getEntityBySynonym(childConfig.synonym) ||
                                mainApp.getEntityByTable(childConfig.table);

            if (!childEntity) {
              throw new Error(`Child entity metadata not found for ${childConfig.table}`);
            }

            for (const childData of childRows) {
              // 8. Set child foreign key to parent key
              childData[childConfig.foreignKey] = masterKey;

              // Validate child
              this.validatePayload(childEntity, childData, false);

              // Process child autonumbers
              for (const childFieldMeta of childEntity.fields) {
                if (childFieldMeta.isAutonumber && childFieldMeta.Autonumber) {
                  const childGenNum = await AutoNumberHelper.generate(conn, poolWrapper.dbType, childFieldMeta, txContext);
                  if (childGenNum !== null) {
                    childData[childFieldMeta.Field] = childGenNum;
                  }
                }
              }

              // Inject child audit fields
              this.injectAuditFields(childEntity, childData, context, false);

              // Insert child row
              await repository.insert(childEntity, childData, txContext, conn);
            }
          }
        }
      }

      // 10. Commit transaction
      await conn.commit();

      // Return created master record
      return { [entity.primaryKey]: masterKey, ...data };
    } catch (err) {
      // 11. Rollback on error
      await conn.rollback();
      throw err;
    } finally {
      conn.release();
    }
  }

  /**
   * Retrieves list of records.
   */
  async list(packageName, tableName, options = {}, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }
    return await repository.find(entity, options, context);
  }

  /**
   * Retrieves single record by ID along with nested children.
   */
  async get(packageName, tableName, id, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    const masterRecord = await repository.findById(entity, id, context);
    if (!masterRecord) return null;

    // Retrieve nested children
    if (entity.hasChilds && entity.children && Array.isArray(entity.children)) {
      for (const childConfig of entity.children) {
        const childEntity = mainApp.getEntity(packageName, childConfig.table) ||
                            mainApp.getEntityBySynonym(childConfig.synonym) ||
                            mainApp.getEntityByTable(childConfig.table);

        if (childEntity) {
          const filters = {};
          filters[childConfig.foreignKey] = id;
          const childrenRows = await repository.find(childEntity, { filters }, context);
          masterRecord[childConfig.childKey] = childrenRows;
        }
      }
    }

    return masterRecord;
  }

  /**
   * Updates record by ID.
   */
  async update(packageName, tableName, id, data, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    this.validatePayload(entity, data, true);
    this.injectAuditFields(entity, data, context, true);

    const result = await repository.update(entity, id, data, context);
    return result;
  }

  /**
   * Deletes record by ID.
   */
  async delete(packageName, tableName, id, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);
    const conn = await poolWrapper.getConnection();

    try {
      await conn.beginTransaction();
      const txContext = { ...context, dbType: poolWrapper.dbType };

      // Handle cascade delete for children if cascadeDelete === true
      if (entity.hasChilds && entity.children) {
        for (const childConfig of entity.children) {
          if (childConfig.cascadeDelete) {
            const childEntity = mainApp.getEntity(packageName, childConfig.table) ||
                                mainApp.getEntityBySynonym(childConfig.synonym) ||
                                mainApp.getEntityByTable(childConfig.table);
            if (childEntity) {
              const filters = {};
              filters[childConfig.foreignKey] = id;
              const childrenRows = await repository.find(childEntity, { filters }, context);
              for (const childRow of childrenRows) {
                const childId = childRow[childEntity.primaryKey];
                await repository.delete(childEntity, childId, txContext, conn);
              }
            }
          }
        }
      }

      const result = await repository.delete(entity, id, txContext, conn);
      await conn.commit();
      return result;
    } catch (err) {
      await conn.rollback();
      throw err;
    } finally {
      conn.release();
    }
  }

  /**
   * Form initialization metadata.
   */
  async initForm(packageName, tableName, vParameters = {}, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    const formMeta = {
      tableName: tableName,
      package: packageName,
      fields: entity ? entity.fields : [],
      children: entity ? entity.children : [],
      primaryKey: entity ? entity.primaryKey : 'id',
      meta: {
        pkgName: packageName,
        userId: context.userId || '1',
        periodId: context.periodId || null,
        mPrgId: context.mPrgId || null
      }
    };
    return formMeta;
  }

  /**
   * Advanced multi-condition search with pagination.
   */
  async search(packageName, tableName, conditions = [], page = 1, size = 20, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    const filters = {};
    if (Array.isArray(conditions)) {
      for (const cond of conditions) {
        if (cond.field && cond.value !== undefined) {
          filters[cond.field] = cond.value;
        }
      }
    } else if (conditions && typeof conditions === 'object') {
      Object.assign(filters, conditions);
    }

    const options = {
      filters,
      page: parseInt(page, 10) || 1,
      pageSize: parseInt(size, 10) || 20
    };

    const rows = await repository.find(entity, options, context);
    return {
      data: rows,
      page: options.page,
      size: options.pageSize
    };
  }

  /**
   * Text search across entity fields with pagination.
   */
  async find(packageName, tableName, queryString = '', page = 1, size = 20, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    const options = {
      page: parseInt(page, 10) || 1,
      pageSize: parseInt(size, 10) || 20,
      filters: {}
    };

    // If search term provided, find matching text fields
    if (queryString && queryString.trim()) {
      const stringFields = entity.fields.filter(f => {
        const type = (f.Type || f.DBType || '').toLowerCase();
        return type.includes('string') || type.includes('char') || type.includes('varchar');
      });
      if (stringFields.length > 0) {
        options.filters[stringFields[0].Field] = queryString;
      }
    }

    const rows = await repository.find(entity, options, context);
    return {
      data: rows,
      page: options.page,
      size: options.pageSize,
      query: queryString
    };
  }

  async updateField(packageName, tableName, fieldName, fieldValue, id, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    const fieldMeta = entity.fields.find(f => f.Field === fieldName || f.Name === fieldName);
    if (!fieldMeta) {
      throw new Error(`Invalid field name: ${fieldName}`);
    }

    const data = { [fieldName]: fieldValue };
    this.injectAuditFields(entity, data, context, true);
    return await repository.update(entity, id, data, context);
  }

  /**
   * Updates partial fields object by ID.
   */
  async updateFields(packageName, tableName, id, data, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    this.validatePayload(entity, data, true);
    this.injectAuditFields(entity, data, context, true);
    return await repository.update(entity, id, data, context);
  }

  /**
   * Gets lookup code tables for a package.
   */
  async getCodes(packageName, context = {}) {
    const tables = mainApp.getTablesInPackage(packageName);
    const codeTables = tables.filter(t => t.toLowerCase().endsWith('_code') || t.toLowerCase().includes('code'));

    const result = {};
    for (const table of codeTables) {
      const entity = mainApp.getEntity(packageName, table);
      if (entity) {
        const rows = await repository.find(entity, { pageSize: 100 }, context);
        result[packageName + table] = rows;
      }
    }

    return result;
  }

  /**
   * Returns code groups filtered by group and type.
   */
  async getCodeGroupsByGroup(packageName, groupName, codeType, context = {}) {
    const codeGroups = await this.getPkgCodeGroups(packageName, codeType, context);
    return codeGroups;
  }

  /**
   * Returns code groups for a package by type.
   */
  async getPkgCodeGroups(packageName, codeType, context = {}) {
    const tables = mainApp.getTablesInPackage(packageName);
    const codeMap = {};

    for (const table of tables) {
      const entity = mainApp.getEntity(packageName, table);
      if (entity && (codeType === 'ALL' || codeType === 'System' || codeType === 'Public')) {
        codeMap[table] = {
          package: packageName,
          table: entity.tableName,
          synonym: entity.synonym,
          codeType
        };
      }
    }

    return { [packageName]: codeMap };
  }

  /**
   * Returns global code groups across all packages.
   */
  async getCodeGroups(codeType, context = {}) {
    const pkgs = mainApp.getAllPackages();
    const result = {};

    for (const pkg of pkgs) {
      const pkgCodes = await this.getPkgCodeGroups(pkg, codeType, context);
      Object.assign(result, pkgCodes);
    }

    return result;
  }

  /**
   * Hierarchical tree structure query.
   */
  async tree(packageName, tableName, context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    const rows = await repository.find(entity, { pageSize: 500 }, context);
    const parentField = entity.fields.find(f => f.Field.toLowerCase().includes('parent') || f.Field.toLowerCase().includes('pid'));
    const parentKey = parentField ? parentField.Field : 'parentId';

    const map = {};
    const treeData = [];

    for (const row of rows) {
      const id = row[entity.primaryKey];
      map[id] = { ...row, children: [] };
    }

    for (const row of rows) {
      const id = row[entity.primaryKey];
      const pId = row[parentKey];
      if (!pId || !map[pId]) {
        treeData.push(map[id]);
      } else {
        map[pId].children.push(map[id]);
      }
    }

    return treeData;
  }

  /**
   * Flattened tree structure.
   */
  async newTree(packageName, tableName, context = {}) {
    return await this.tree(packageName, tableName, context);
  }

  /**
   * Batch save (add or update) an array of entities within a transaction.
   */
  async listSave(packageName, tableName, aEntities = [], context = {}) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    const results = [];
    for (const item of aEntities) {
      const id = item[entity.primaryKey] || item.id;
      if (id) {
        await this.update(packageName, tableName, id, item, context);
        results.push({ ...item, status: 'updated' });
      } else {
        const created = await this.create(packageName, tableName, item, context);
        results.push({ ...created, status: 'created' });
      }
    }

    return results;
  }

  /**
   * Gets available system/tenant copies.
   */
  async getCopies(context = {}) {
    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);
    
    try {
      const rows = await poolWrapper.query('SELECT Id, Name, URL FROM Phs_Cpy WHERE Status_Id = 1');
      return rows;
    } catch (e) {
      // Return default copy metadata if table not populated
      return [
        { id: 1, name: '01-Admin', url: '01-Admin' },
        { id: 2, name: '01-Copy', url: '01-Copy' }
      ];
    }
  }

  /**
   * Saves uploaded attachment metadata.
   */
  async uploadFile(hParams = {}, context = {}) {
    const entity = mainApp.getEntity('Phs', 'Phs_Attached') || mainApp.getEntity('Cpy', 'Cpy_Attached');
    if (entity) {
      const res = await repository.insert(entity, hParams, context);
      return { id: res.insertedId, ...hParams };
    }
    return { id: Date.now(), ...hParams };
  }

  /**
   * Gets attachment metadata by ID.
   */
  async getFile(id, context = {}) {
    const entity = mainApp.getEntity('Phs', 'Phs_Attached') || mainApp.getEntity('Cpy', 'Cpy_Attached');
    if (entity) {
      return await repository.findById(entity, id, context);
    }
    return { id, filename: `attachment_${id}` };
  }

  /**
   * Deletes attachment by ID.
   */
  async deleteFile(id, context = {}) {
    const entity = mainApp.getEntity('Phs', 'Phs_Attached') || mainApp.getEntity('Cpy', 'Cpy_Attached');
    if (entity) {
      return await repository.delete(entity, id, context);
    }
    return { success: true };
  }
}

module.exports = {
  UnifiedService: new UnifiedService(),
  ValidationError
};

