const mainApp = require('../metadata/registry');
const connectionPool = require('../core/connectionPool');
const repository = require('../repository/unifiedRepository');
const AutoNumberHelper = require('../repository/autoNumber');

/**
 * A payload the caller got wrong.
 *
 * It carries no HTTP status: a service states what happened and the HTTP layer
 * decides how to say so. Nothing is lost by dropping it -- the error handler
 * already matches on `name` and answers 400 for this class, which is what the
 * status it used to carry said.
 */
class ValidationError extends Error {
  constructor(message, details = []) {
    super(message);
    this.name = 'ValidationError';
    this.details = details;
  }
}

/**
 * The generic /CC/attached endpoints operate on the copy-level attachment table.
 *
 * These were looked up as 'Phs_Attached' / 'Cpy_Attached', neither of which is a
 * registered name -- the real entity is synonym 'Cpy_Attach' over table
 * Copy_Attached_Files. Both lookups therefore returned null on every call and
 * each handler fell through to a fabricated result, so uploads persisted
 * nothing, reads returned an invented filename and deletes deleted nothing,
 * all while reporting success. Resolution now fails loudly instead.
 */
const ATTACHMENT_LOOKUPS = [
  ['Cpy', 'Cpy_Attach'],
  ['Cpy', 'Copy_Attached_Files']
];

/**
 * @returns {Object} The attachment entity metadata
 * @throws {Error} When no attachment entity is registered
 */
function getAttachmentEntity() {
  for (const [packageName, tableName] of ATTACHMENT_LOOKUPS) {
    const entity = mainApp.getEntity(packageName, tableName);
    if (entity) {
      return entity;
    }
  }
  throw new Error('Entity metadata not found for the attachment table (Cpy/Cpy_Attach)');
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

      // Required: NOT NULL, not autonumber, not the key on a create -- and
      // only where the caller could actually supply it.
      //
      // Two exemptions, both of which used to make a payload unsatisfiable:
      //
      //   A column the server refuses in this mode cannot be required in it.
      //   Ten columns are NOT NULL with no default and `insert: false`, so a
      //   create was rejected for omitting a value it would also have been
      //   rejected for sending. pur/Purchase, pur/Returns and sales/Sales could
      //   not be saved at all.
      //
      //   A column with a database default does not need one from the client.
      //   366 columns are NOT NULL with a default, and demanding a value for
      //   them is asking for something the database already knows -- which is
      //   why PhApp carries a `blankValue` on every such field to send the
      //   default back by hand.
      //
      // Neither weakens the constraint: NOT NULL with a DEFAULT is always
      // populated, and a column the server will not write is not the client's
      // to fill.
      const refusedHere = isUpdate ? fieldMeta.update === false : fieldMeta.insert === false;
      const hasDatabaseDefault = fieldMeta.Default !== undefined
        && fieldMeta.Default !== null
        && String(fieldMeta.Default) !== '';

      if (!isUpdate
        && !fieldMeta.isNull
        && !fieldMeta.isAutonumber
        && fieldName !== entity.primaryKey
        && !refusedHere
        && !hasDatabaseDefault) {
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
    const rows = await repository.find(entity, options, context);
    return rows;
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
          // Localised against the child's own metadata, not the master's.
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

    const childKeys = (entity.children || [])
      .map((child) => child.childKey)
      .filter((key) => Array.isArray(data[key]));

    // Nothing nested: one statement, no transaction to open.
    if (childKeys.length === 0) {
      return repository.update(entity, id, data, context);
    }

    const tenantId = context.tenantId || 'default';
    const poolWrapper = await connectionPool.getPool(tenantId);
    const conn = await poolWrapper.getConnection();

    try {
      await conn.beginTransaction();
      const txContext = { ...context, dbType: poolWrapper.dbType };

      const result = await repository.update(entity, id, data, txContext, conn);

      for (const childConfig of (entity.children || [])) {
        if (!Array.isArray(data[childConfig.childKey])) {
          continue;
        }
        await this.replaceChildren(packageName, entity, childConfig, id, data[childConfig.childKey], txContext, conn);
      }

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
   * Brings one child collection into line with what the client sent.
   *
   * `update` used to ignore children entirely: it validated a payload that was
   * allowed to carry them, then handed it to a repository that builds its SET
   * from the entity's own columns -- so a child array was silently dropped and
   * every line a user changed on a document screen was discarded while the save
   * reported success. `create` handled children, `get` returned them and
   * `delete` cascaded them; only the middle of the four did not.
   *
   * The whole collection arrives, because that is what a line grid holds, so
   * this is a replacement rather than a patch. It is diffed by key rather than
   * emptied and refilled:
   *
   *   a row carrying a real key is updated, keeping its identity;
   *   a row with no key, or 0, is inserted and autonumbered;
   *   a row the payload no longer mentions is deleted.
   *
   * Emptying and refilling would be shorter and would renumber every line on
   * every save, which loses anything referencing them and churns the sequence.
   * The Java grid carries `id` and `mstId` as hidden columns for exactly this
   * reason -- so the server can tell the three cases apart.
   *
   * The foreign key is set from the master's own key, never from the row: a
   * client cannot reassign a line to another document by editing a field it was
   * not asked for.
   *
   * @param {string} packageName
   * @param {Object} entity The master entity
   * @param {Object} childConfig One entry of entity.children
   * @param {*} masterId
   * @param {Object[]} rows What the client sent for this collection
   * @param {Object} context Carries dbType, inside the caller's transaction
   * @param {Object} conn The active connection
   */
  async replaceChildren(packageName, entity, childConfig, masterId, rows, context, conn) {
    const childEntity = mainApp.getEntity(packageName, childConfig.table)
      || mainApp.getEntityBySynonym(childConfig.synonym)
      || mainApp.getEntityByTable(childConfig.table);

    if (!childEntity) {
      throw new Error(`Child entity metadata not found for ${childConfig.table}`);
    }

    const key = childEntity.primaryKey;

    const existing = await repository.find(
      childEntity, { filters: { [childConfig.foreignKey]: masterId } }, context
    );
    const existingIds = new Set(existing.map((row) => String(row[key])));

    const keep = new Set();

    for (const row of rows) {
      const data = { ...row };
      data[childConfig.foreignKey] = masterId;

      const sent = data[key];
      const isExisting = sent !== undefined && sent !== null && String(sent) !== '0'
        && existingIds.has(String(sent));

      if (isExisting) {
        keep.add(String(sent));
        this.validatePayload(childEntity, data, true);
        this.injectAuditFields(childEntity, data, context, true);
        await repository.update(childEntity, sent, data, context, conn);
        continue;
      }

      // A new line. Whatever key came with it is not its key.
      delete data[key];
      this.validatePayload(childEntity, data, false);

      for (const fieldMeta of childEntity.fields) {
        if (fieldMeta.isAutonumber && fieldMeta.Autonumber) {
          const generated = await AutoNumberHelper.generate(conn, context.dbType, fieldMeta, context);
          if (generated !== null) {
            data[fieldMeta.Field] = generated;
          }
        }
      }

      this.injectAuditFields(childEntity, data, context, false);
      await repository.insert(childEntity, data, context, conn);
    }

    for (const row of existing) {
      const rowKey = String(row[key]);
      if (!keep.has(rowKey)) {
        await repository.delete(childEntity, row[key], context, conn);
      }
    }
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
  async search(packageName, tableName, conditions = [], page = 1, size = 20, context = {}, logic = 'AND') {
    const entity = mainApp.getEntity(packageName, tableName);
    if (!entity) {
      throw new Error(`Entity metadata not found for ${packageName}/${tableName}`);
    }

    // A list of conditions, each carrying its own operator. This used to
    // collapse to `filters[field] = value`, which discarded the operator and
    // made every search an equality test however it was asked for.
    //
    // An object is still accepted, because callers that only ever wanted
    // equality send one, and it means exactly that.
    const options = {
      page: parseInt(page, 10) || 1,
      pageSize: parseInt(size, 10) || 20
    };

    if (Array.isArray(conditions)) {
      options.conditions = conditions;
      options.logic = logic;
    } else if (conditions && typeof conditions === 'object') {
      options.filters = { ...conditions };
    }

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
    const entity = getAttachmentEntity();
    const data = { ...hParams };
    this.injectAuditFields(entity, data, context, false);

    const res = await repository.insert(entity, data, context);
    return { ...data, id: res.insertedId };
  }

  /**
   * Gets attachment metadata by ID.
   */
  async getFile(id, context = {}) {
    const entity = getAttachmentEntity();
    return await repository.findById(entity, id, context);
  }

  /**
   * Deletes attachment by ID.
   */
  async deleteFile(id, context = {}) {
    const entity = getAttachmentEntity();
    return await repository.delete(entity, id, context);
  }
}

module.exports = {
  UnifiedService: new UnifiedService(),
  ValidationError
};

