const { UnifiedService } = require('../services/unifiedService');
const autocompleteService = require('../services/autocompleteService');
const UnifiedReportService = require('../services/unifiedReportService');
const ResultManager = require('../utils/responseManager');
const i18nHelper = require('../utils/i18nHelper');

class UnifiedController {
  async initForm(req, res, next) {
    try {
      const { package: pkg, table } = req.params;
      const vParams = req.body;
      const context = req.context || {};
      const result = await UnifiedService.initForm(pkg, table, vParams, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async newRecord(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const data = req.body;
      const context = req.context || {};

      const result = await UnifiedService.create(pkg, table, data, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async listRecords(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const context = req.context || {};
      const { page, pageSize, sortBy, sortOrder, ...filters } = req.query;

      const vWhere = req.body && Object.keys(req.body).length > 0 ? req.body : filters;

      const options = {
        page: page ? parseInt(page, 10) : 1,
        pageSize: pageSize ? parseInt(pageSize, 10) : 500,
        sortBy,
        sortOrder,
        filters: vWhere
      };

      const rows = await UnifiedService.list(pkg, table, options, context);
      res.status(200).json(ResultManager.ok(rows));
    } catch (err) {
      next(err);
    }
  }

  async search(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const page = req.params.page || 1;
      const size = req.params.size || 20;
      const conditions = req.body;
      const context = req.context || {};

      const result = await UnifiedService.search(pkg, table, conditions, page, size, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async find(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const page = req.params.page || 1;
      const size = req.params.size || 20;
      const queryString = typeof req.body === 'string' ? req.body : (req.body?.query || '');
      const context = req.context || {};

      const result = await UnifiedService.find(pkg, table, queryString, page, size, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async getRecord(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const id = req.params.id;
      const context = req.context || {};

      const record = await UnifiedService.get(pkg, table, id, context);
      if (!record) {
        return res.status(404).json(ResultManager.invalid('Record not found'));
      }

      res.status(200).json(ResultManager.ok(record));
    } catch (err) {
      next(err);
    }
  }

  async updateRecord(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const id = req.params.id || req.body?.id;
      const data = req.body;
      const context = req.context || {};

      const result = await UnifiedService.update(pkg, table, id, data, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async updateField(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const { fieldName, fieldValue, id } = req.params;
      const context = req.context || {};

      const result = await UnifiedService.updateField(pkg, table, fieldName, fieldValue, id, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async updateFields(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const id = req.params.id;
      const data = req.body;
      const context = req.context || {};

      const result = await UnifiedService.updateFields(pkg, table, id, data, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async deleteRecord(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const id = req.params.id;
      const context = req.context || {};

      const result = await UnifiedService.delete(pkg, table, id, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async autocomplete(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const queryParams = req.method === 'POST' ? req.body : req.query;
      const context = req.context || {};

      const rows = await autocompleteService.getAutocomplete(pkg, table, queryParams, context);
      res.status(200).json(ResultManager.ok(rows));
    } catch (err) {
      next(err);
    }
  }

  async getCodes(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const context = req.context || {};

      const codes = await UnifiedService.getCodes(pkg, context);
      res.status(200).json(ResultManager.ok(codes));
    } catch (err) {
      next(err);
    }
  }

  async getCodeGroupsByGroup(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const { groupName, codeType } = req.params;
      const context = req.context || {};

      const result = await UnifiedService.getCodeGroupsByGroup(pkg, groupName, codeType, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async getPkgCodeGroups(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const { codeType } = req.params;
      const context = req.context || {};

      const result = await UnifiedService.getPkgCodeGroups(pkg, codeType, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async getCodeGroups(req, res, next) {
    try {
      const { codeType } = req.params;
      const context = req.context || {};

      const result = await UnifiedService.getCodeGroups(codeType, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async tree(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const context = req.context || {};

      const treeData = await UnifiedService.tree(pkg, table, context);
      res.status(200).json(ResultManager.ok(treeData));
    } catch (err) {
      next(err);
    }
  }

  async newTree(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const context = req.context || {};

      const treeData = await UnifiedService.newTree(pkg, table, context);
      res.status(200).json(ResultManager.ok(treeData));
    } catch (err) {
      next(err);
    }
  }

  async listSave(req, res, next) {
    try {
      const pkg = req.params.package || req.params.pkgName;
      const table = req.params.table || req.params.tableName;
      const aEntities = req.body;
      const context = req.context || {};

      const result = await UnifiedService.listSave(pkg, table, aEntities, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async getCopies(req, res, next) {
    try {
      const context = req.context || {};
      const copies = await UnifiedService.getCopies(context);
      res.status(200).json(ResultManager.ok(copies));
    } catch (err) {
      next(err);
    }
  }

  async uploadFile(req, res, next) {
    try {
      const hParams = req.body;
      const context = req.context || {};
      const result = await UnifiedService.uploadFile(hParams, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async getFile(req, res, next) {
    try {
      const id = req.params.id;
      const context = req.context || {};
      const result = await UnifiedService.getFile(id, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async deleteFile(req, res, next) {
    try {
      const id = req.params.id;
      const context = req.context || {};
      const result = await UnifiedService.deleteFile(id, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  // Report Handlers
  async initReport(req, res, next) {
    try {
      const { pkgName, reportName } = req.params;
      const reportService = new UnifiedReportService({ getName: () => reportName, getTitle: () => reportName, getDescription: () => '', getFields: () => [], getParameters: () => [], getChartConfig: () => null, isDashboard: () => false }, null);
      const result = await reportService.init(req.body);
      res.status(200).json(result);
    } catch (err) {
      next(err);
    }
  }

  async reportStatistics(req, res, next) {
    try {
      const reportService = new UnifiedReportService({ getQuery: () => 'SELECT 1', getTitle: () => 'Stats' }, null);
      res.status(200).json(ResultManager.ok({ total: 0, summary: {} }));
    } catch (err) {
      next(err);
    }
  }

  async reportQuery(req, res, next) {
    try {
      res.status(200).json(ResultManager.ok({ data: [], count: 0 }));
    } catch (err) {
      next(err);
    }
  }

  async reportPDF(req, res, next) {
    try {
      res.status(200).json(ResultManager.ok({ format: 'PDF', status: 'ready' }));
    } catch (err) {
      next(err);
    }
  }

  async dashLine(req, res, next) {
    try {
      res.status(200).json(ResultManager.ok({ type: 'line', data: { labels: [], datasets: [] } }));
    } catch (err) {
      next(err);
    }
  }

  async dashPie(req, res, next) {
    try {
      res.status(200).json(ResultManager.ok({ type: 'pie', data: { labels: [], datasets: [] } }));
    } catch (err) {
      next(err);
    }
  }
}

module.exports = new UnifiedController();