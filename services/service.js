const {UnifiedService} = require('./unifiedService');
const ResultManager = require('../utils/responseManager');
const logger = require('../utils/logger');

class Service {
  constructor(requestParams = {}) {
    this.requestParams = requestParams;
    this.dbConn = requestParams.dbConn;
    this.tableName = requestParams.tableName;
    this.pkgName = requestParams.pkgName;
    this.userId = requestParams.userId;
    this.periodId = requestParams.periodId;
    this.vLang = requestParams.vLang;
    this.debugMode = requestParams.debugMode || false;

    this.context = {
      tenantId: 'default',
      periodId: this.periodId,
      mPrgId: requestParams.mPrgId,
      userId: this.userId || '1',
      lang: this.vLang || 'en',
      vLang: this.vLang || 'en',
      vCopy: 'default'
    };
  }

  async initForm(vParameters) {
    try {
      const res = await UnifiedService.initForm(this.pkgName, this.tableName, vParameters, this.context);
      return ResultManager.ok(res);
    } catch (error) {
      logger.error('initForm error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async list(vWhere) {
    try {
      const filters = typeof vWhere === 'string' ? JSON.parse(vWhere) : (vWhere || {});
      const res = await UnifiedService.list(this.pkgName, this.tableName, {filters, pageSize: 500}, this.context);
      return ResultManager.ok(res);
    } catch (error) {
      logger.error('list error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async search(conditions, page = 1, size = 20) {
    try {
      const res = await UnifiedService.search(this.pkgName, this.tableName, conditions, page, size, this.context);
      return ResultManager.ok(res);
    } catch (error) {
      logger.error('search error:', error);
      return ResultManager.invalid(error.message);
  }
  }

  async find(queryString, page = 1, size = 20) {
    try {
      const res = await UnifiedService.find(this.pkgName, this.tableName, queryString, page, size, this.context);
      return ResultManager.ok(res);
    } catch (error) {
      logger.error('find error:', error);
      return ResultManager.invalid(error.message);
  }
  }

  async get(id) {
    try {
      const record = await UnifiedService.get(this.pkgName, this.tableName, id, this.context);
      if (!record)
        return ResultManager.invalid('Record not found');
      return ResultManager.ok(record);
    } catch (error) {
      logger.error('get error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async add(entity) {
    try {
      const res = await UnifiedService.create(this.pkgName, this.tableName, entity, this.context);
      return ResultManager.ok(res);
    } catch (error) {
      logger.error('add error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async update(entity) {
    try {
      const id = entity.id || entity.Id;
      if (!id)
        return ResultManager.invalid('ID is required for update');
      const res = await UnifiedService.update(this.pkgName, this.tableName, id, entity, this.context);
      return ResultManager.ok(res);
    } catch (error) {
      logger.error('update error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async updateField(fieldName, fieldValue, id) {
    try {
      const res = await UnifiedService.updateField(this.pkgName, this.tableName, fieldName, fieldValue, id, this.context);
      return ResultManager.ok(res);
    } catch (error) {
      logger.error('updateField error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async updateFields(entity, id) {
    try {
      const res = await UnifiedService.updateFields(this.pkgName, this.tableName, id, entity, this.context);
      return ResultManager.ok(res);
    } catch (error) {
      logger.error('updateFields error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async delete(id) {
    try {
      const res = await UnifiedService.delete(this.pkgName, this.tableName, id, this.context);
      return ResultManager.ok(res);
    } catch (error) {
      logger.error('delete error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async tree() {
    try {
      const treeData = await UnifiedService.tree(this.pkgName, this.tableName, this.context);
      return ResultManager.ok(treeData);
    } catch (error) {
      logger.error('tree error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async newTree() {
    try {
      const treeData = await UnifiedService.newTree(this.pkgName, this.tableName, this.context);
      return ResultManager.ok(treeData);
    } catch (error) {
      logger.error('newTree error:', error);
      return ResultManager.invalid(error.message);
    }
  }

  async listSave(entities) {
    try {
      const res = await UnifiedService.listSave(this.pkgName, this.tableName, entities, this.context);
      return ResultManager.ok(res);
    } catch (error) {
      logger.error('listSave error:', error);
      return ResultManager.invalid(error.message);
    }
  }
}

module.exports = Service;