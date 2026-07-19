const Database = require('../config/database');
const JWebToken = require('../utils/jwtToken');
const ResultManager = require('../utils/responseManager');
const Service = require('../services/service');
const AutocompleteService = require('../services/autocompleteService');
const UnifiedReportService = require('../services/unifiedReportService');
const DB = require('../utils/dbHelper');
const logger = require('../utils/logger');

// Configuration - would normally be loaded from config files
const aPackages = ['users', 'products', 'orders', 'customers'];
const hModels = {
  'users': {
    'users': {tableName: 'users', fields: {}},
    'profiles': {tableName: 'profiles', fields: {}}
  },
  'products': {
    'products': {tableName: 'products', fields: {}},
    'categories': {tableName: 'categories', fields: {}}
  }
};
const hCodes = {};
const hAutocompletes = {
  'users': {
    'users': {tableName: 'users', searchField: 'name', displayField: 'name', valueField: 'id'},
    'profiles': {tableName: 'profiles', searchField: 'name', displayField: 'name', valueField: 'id'}
  },
  'products': {
    'products': {tableName: 'products', searchField: 'name', displayField: 'name', valueField: 'id'},
    'categories': {tableName: 'categories', searchField: 'name', displayField: 'name', valueField: 'id'}
  }
};
const hReports = {
  'users': {
    'usersReport': {
      name: 'usersReport',
      title: 'Users Report',
      query: 'SELECT * FROM users',
      fields: ['id', 'name', 'email', 'created_at'],
      parameters: [],
      chartConfig: null,
      dashboard: false
    }
  },
  'products': {
    'productsReport': {
      name: 'productsReport',
      title: 'Products Report',
      query: 'SELECT * FROM products',
      fields: ['id', 'name', 'price', 'category'],
      parameters: [],
      chartConfig: null,
      dashboard: false
    },
    'salesReport': {
      name: 'salesReport',
      title: 'Sales Dashboard',
      query: 'SELECT * FROM sales',
      fields: ['date', 'amount', 'product'],
      parameters: [],
      chartConfig: {type: 'line'},
      dashboard: true
    }
  }
};

class UnifiedController {
  // Form initialization
  async doInitForm(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const vParameters = req.body;

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: ''
      };

      const service = new Service(requestParams);
      const result = await service.initForm(vParameters);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doInitForm error:', error);
      res.json(ResultManager.invalid('InitForm failed'));
    }
  }

  // List operation
  async doList(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName} = req.params;
      const vWhere = req.body;

      // Check if package and table exist
      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName}/List - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.list(vWhere);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doList error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}/List`));
    }
  }

  // Search operation
  async doSearch(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName, page, size} = req.params;
      const conditions = req.body;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName}/Search - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.search(conditions, parseInt(page), parseInt(size));
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doSearch error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}/Search`));
    }
  }

  // Find operation
  async doFind(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName, page, size} = req.params;
      const queryString = req.body;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName}/Find - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.find(queryString, parseInt(page), parseInt(size));
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doFind error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}/Find`));
    }
  }

  // Autocomplete operation
  async doAutocomplete(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName} = req.params;
      const term = req.body.term || req.body;

      if (!hAutocompletes[pkgName] || !hAutocompletes[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName}/Autocomplete - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const autocomplete = hAutocompletes[pkgName][tableName];
      const service = new AutocompleteService(
        autocomplete,
        dbConn,
        mPrgId,
        process.env.DEBUG_MODE === 'true'
        );

      const size = parseInt(process.env.AUTOCOMPLETE_SIZE) || 10;
      const result = await service.autocomplete(term, size, userId);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doAutocomplete error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}/Autocomplete`));
    }
  }

  // Get single record
  async doGet(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName, id} = req.params;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName}/${id} - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.get(parseInt(id));
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doGet error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}/${req.params.id}`));
    }
  }

  // Add (Create) operation
  async doAdd(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName} = req.params;
      const entity = req.body;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName}/New - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.add(entity);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doAdd error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}/New`));
    }
  }

  // Update operation
  async doUpdate(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName} = req.params;
      const entity = req.body;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName} - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.update(entity);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doUpdate error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}`));
    }
  }

  // Update single field
  async doUpdateField(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName, id, fieldName, fieldValue} = req.params;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName} - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.updateField(fieldName, fieldValue, parseInt(id));
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doUpdateField error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}`));
    }
  }

  // Update multiple fields
  async doUpdateFields(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName, id} = req.params;
      const entity = req.body;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName} - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.updateFields(entity, parseInt(id));
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doUpdateFields error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}`));
    }
  }

  // Delete operation
  async doDelete(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName, id} = req.params;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName}/${id} - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.delete(parseInt(id));
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doDelete error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}/${req.params.id}`));
    }
  }

  // Tree operation
  async doTree(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName} = req.params;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName}/Tree - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.tree();
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doTree error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}/Tree`));
    }
  }

  // New Tree operation
  async doNewTree(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName} = req.params;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName}/NewTree - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.newTree();
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doNewTree error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}/NewTree`));
    }
  }

  // List Save (Batch operations)
  async listSave(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, tableName} = req.params;
      const entities = req.body;

      if (!hModels[pkgName] || !hModels[pkgName][tableName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${tableName}/Save - Package or table not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const requestParams = {
        debugMode: process.env.DEBUG_MODE === 'true',
        aPackages: aPackages,
        hModels: hModels,
        hCodes: hCodes,
        dbConn: dbConn,
        authorization: authorization,
        mPrgId: mPrgId,
        periodId: periodId,
        vLang: vLang,
        vCopy: vCopy,
        userId: userId,
        pkgName: pkgName,
        tableName: tableName
      };

      const service = new Service(requestParams);
      const result = await service.listSave(entities);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/listSave error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.tableName}/Save`));
    }
  }

  // Get Codes
  async doGetCodes(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName} = req.params;

      if (!hModels[pkgName]) {
        return res.json(ResultManager.invalid(`${pkgName}/Codes - Package not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const codes = await DB.getCodes(dbConn, hModels, hCodes, pkgName, userId);
      dbConn.release();

      res.json(ResultManager.ok(codes));
    } catch (error) {
      logger.error('UC/doGetCodes error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/Codes`));
    }
  }

  // Get Package Code Groups By Group
  async doGetPkgCodeGroupsByGroup(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, groupName, codeType} = req.params;

      if (!hModels[pkgName]) {
        return res.json(ResultManager.invalid(`${pkgName}/CodeGroups - Package not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const codeGroups = await DB.getCodeGroups(dbConn, hCodes, pkgName, groupName, codeType);
      dbConn.release();

      res.json(ResultManager.ok(codeGroups));
    } catch (error) {
      logger.error('UC/doGetPkgCodeGroupsByGroup error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/CodeGroups`));
    }
  }

  // Get Package Code Groups
  async doGetPkgCodeGroups(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, codeType} = req.params;

      if (!hModels[pkgName]) {
        return res.json(ResultManager.invalid(`${pkgName}/CodeGroups - Package not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const codeGroups = await DB.getCodeGroups(dbConn, hCodes, pkgName, null, codeType);
      dbConn.release();

      res.json(ResultManager.ok(codeGroups));
    } catch (error) {
      logger.error('UC/doGetPkgCodeGroups error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/CodeGroups`));
    }
  }

  // Get Code Groups
  async doGetCodeGroups(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {codeType} = req.params;

      if (!['ALL', 'System', 'Public'].includes(codeType)) {
        return res.json(ResultManager.invalid(`CodeGroups/${codeType} - Invalid code type`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const codeGroups = await DB.getCodeGroups(dbConn, hCodes, null, null, codeType);
      dbConn.release();

      res.json(ResultManager.ok(codeGroups));
    } catch (error) {
      logger.error('UC/doGetCodeGroups error:', error);
      res.json(ResultManager.invalid(`CodeGroups/${req.params.codeType}`));
    }
  }

  // Report: Init
  async initReport(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, reportName} = req.params;
      const vParams = req.body;

      if (!hReports[pkgName] || !hReports[pkgName][reportName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${reportName}/Init - Report not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const report = hReports[pkgName][reportName];
      const service = new UnifiedReportService(report, dbConn);
      const result = await service.init(vParams);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/initReport error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.reportName}/Init`));
    }
  }

  // Report: Statistics
  async doReportQS(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, reportName} = req.params;
      const vParams = req.body;

      if (!hReports[pkgName] || !hReports[pkgName][reportName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${reportName}/Statistics - Report not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const report = hReports[pkgName][reportName];
      const service = new UnifiedReportService(report, dbConn);
      const result = await service.statistics(vParams);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doReportQS error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.reportName}/Statistics`));
    }
  }

  // Report: Query
  async doReportQT(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, reportName} = req.params;
      const vParams = req.body;

      if (!hReports[pkgName] || !hReports[pkgName][reportName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${reportName}/Query - Report not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const report = hReports[pkgName][reportName];
      const service = new UnifiedReportService(report, dbConn);
      const result = await service.query(vParams);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doReportQT error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.reportName}/Query`));
    }
  }

  // Report: PDF
  async doReportPDF(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, reportName} = req.params;
      const vParams = req.body;

      if (!hReports[pkgName] || !hReports[pkgName][reportName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${reportName}/PDF - Report not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const report = hReports[pkgName][reportName];
      const service = new UnifiedReportService(report, dbConn);
      const result = await service.queryPDF(userId, vParams);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/doReportPDF error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.reportName}/PDF`));
    }
  }

  // Dashboard: Line Chart
  async dashLine(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, reportName} = req.params;
      const vParams = req.body;

      if (!hReports[pkgName] || !hReports[pkgName][reportName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${reportName}/DashQueryLine - Report not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const report = hReports[pkgName][reportName];
      const service = new UnifiedReportService(report, dbConn);
      const result = await service.dashLine(vParams);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/dashLine error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.reportName}/DashQueryLine`));
    }
  }

  // Dashboard: Pie Chart
  async dashPie(req, res) {
    try {
      const {authorization, mPrgId, periodId, vLang} = req.headers;
      const {pkgName, reportName} = req.params;
      const vParams = req.body;

      if (!hReports[pkgName] || !hReports[pkgName][reportName]) {
        return res.json(ResultManager.invalid(`${pkgName}/${reportName}/DashQueryPie - Report not found`));
      }

      const token = JWebToken.getInstanceByAuthorization(authorization);
      const userId = token.getPayload().jui || token.getPayload().userId;
      const vCopy = token.getPayload().Copy || token.getPayload().vCopy || '';

      const dbConn = await Database.getConnection(vCopy, vLang, userId, periodId);

      const report = hReports[pkgName][reportName];
      const service = new UnifiedReportService(report, dbConn);
      const result = await service.dashPie(vParams);
      dbConn.release();

      res.json(result);
    } catch (error) {
      logger.error('UC/dashPie error:', error);
      res.json(ResultManager.invalid(`${req.params.pkgName}/${req.params.reportName}/DashQueryPie`));
    }
  }
}

module.exports = UnifiedController;