const { UnifiedService } = require('../services/unifiedService');
const autocompleteService = require('../services/autocompleteService');
const reportService = require('../services/reportService');
const auditService = require('../services/auditService');
const ResultManager = require('../utils/responseManager');
const i18nHelper = require('../utils/i18nHelper');
const { coercePage, coercePageSize } = require('../utils/pagination');
const authorize = require('../middleware/authorize');

const NO_ATTACHMENT_ACCESS = 'You do not have permission to access this attachment';

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

      auditService.recordAsync({
        type: 'CREATE',
        text: `${pkg}/${table} id=${(result && (result.id || result.Id)) || '?'}`,
        context,
        req
      });

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
        page: coercePage(page),
        pageSize: coercePageSize(pageSize, 500),
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
      const page = coercePage(req.params.page);
      const size = coercePageSize(req.params.size);
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
      const page = coercePage(req.params.page);
      const size = coercePageSize(req.params.size);
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

      auditService.recordAsync({
        type: 'UPDATE',
        // Field names only: values may hold business data that does not belong
        // in a log line.
        text: `${pkg}/${table} id=${id} fields=${Object.keys(data || {}).join(',')}`,
        context,
        req
      });

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

      auditService.recordAsync({
        type: 'DELETE',
        text: `${pkg}/${table} id=${id}`,
        context,
        req
      });

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

  /**
   * The attachment routes carry no :package/:table pair, so the authorize
   * middleware skips them. An attachment is still program-scoped -- the row
   * holds the MPrg_Id of the program it belongs to -- so the check happens here,
   * once the row has been read, against the same Cpy_Perm grants.
   */
  async uploadFile(req, res, next) {
    try {
      const hParams = req.body || {};
      const context = req.context || {};

      // On upload the program id comes from the caller, so it is checked before
      // anything is written rather than after.
      const mprgId = hParams.mprgId !== undefined ? hParams.mprgId : context.mPrgId;
      const allowed = await authorize.checkProgram(context.tenantId, req.user, mprgId, 'a new attachment');
      if (!allowed) {
        return res.status(200).json(ResultManager.error(403, NO_ATTACHMENT_ACCESS));
      }

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
      if (!result) {
        return res.status(200).json(ResultManager.error(404, 'Attachment not found'));
      }

      const allowed = await authorize.checkProgram(context.tenantId, req.user, result.mprgId, `attachment ${id}`);
      if (!allowed) {
        return res.status(200).json(ResultManager.error(403, NO_ATTACHMENT_ACCESS));
      }

      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async deleteFile(req, res, next) {
    try {
      const id = req.params.id;
      const context = req.context || {};

      // Read first: the permission lives on the row, so it cannot be checked
      // without it, and a delete must not report success for a row that was
      // never there.
      const existing = await UnifiedService.getFile(id, context);
      if (!existing) {
        return res.status(200).json(ResultManager.error(404, 'Attachment not found'));
      }

      const allowed = await authorize.checkProgram(context.tenantId, req.user, existing.mprgId, `attachment ${id}`);
      if (!allowed) {
        return res.status(200).json(ResultManager.error(403, NO_ATTACHMENT_ACCESS));
      }

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

      const result = await reportService.init(pkgName, reportName);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async reportStatistics(req, res, next) {
    try {
      const { pkgName, reportName } = req.params;
      const context = req.context || {};

      const result = await reportService.statistics(pkgName, reportName, req.body, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async reportQuery(req, res, next) {
    try {
      const { pkgName, reportName } = req.params;
      const context = req.context || {};

      const result = await reportService.query(pkgName, reportName, req.body, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async reportPDF(req, res, next) {
    try {
      const { pkgName, reportName } = req.params;
      const context = req.context || {};
      const filename = `${reportName}_${Date.now()}.pdf`;

      // The document streams straight to the response, so headers must be set
      // before rendering starts. Any failure after that point cannot be turned
      // back into a JSON error body.
      res.setHeader('Content-Type', 'application/pdf');
      res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);

      await reportService.renderPDF(pkgName, reportName, req.body, context, res);
    } catch (err) {
      if (res.headersSent) {
        res.end();
        return;
      }
      next(err);
    }
  }

  async dashLine(req, res, next) {
    try {
      const { pkgName, reportName } = req.params;
      const context = req.context || {};

      const result = await reportService.dashLine(pkgName, reportName, req.body, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }

  async dashPie(req, res, next) {
    try {
      const { pkgName, reportName } = req.params;
      const context = req.context || {};

      const result = await reportService.dashPie(pkgName, reportName, req.body, context);
      res.status(200).json(ResultManager.ok(result));
    } catch (err) {
      next(err);
    }
  }
}

module.exports = new UnifiedController();