const { UnifiedService } = require('../services/unifiedService');
const autocompleteService = require('../services/autocompleteService');
const i18nHelper = require('../utils/i18nHelper');

class UnifiedController {
  async newRecord(req, res, next) {
    try {
      const { package: pkg, table } = req.params;
      const data = req.body;
      const context = req.context;

      const result = await UnifiedService.create(pkg, table, data, context);
      const msg = i18nHelper.getMessage('CREATED', context.lang);

      res.status(200).json({
        success: true,
        status: 200,
        messageKey: 'CREATED',
        message: msg,
        data: result
      });
    } catch (err) {
      next(err);
    }
  }

  async listRecords(req, res, next) {
    try {
      const { package: pkg, table } = req.params;
      const context = req.context;
      const { page, pageSize, sortBy, sortOrder, ...filters } = req.query;

      const options = {
        page: page ? parseInt(page, 10) : 1,
        pageSize: pageSize ? parseInt(pageSize, 10) : 20,
        sortBy,
        sortOrder,
        filters
      };

      const rows = await UnifiedService.list(pkg, table, options, context);
      const msg = i18nHelper.getMessage('SUCCESS', context.lang);

      res.status(200).json({
        success: true,
        status: 200,
        messageKey: 'SUCCESS',
        message: msg,
        data: rows
      });
    } catch (err) {
      next(err);
    }
  }

  async getRecord(req, res, next) {
    try {
      const { package: pkg, table, id } = req.params;
      const context = req.context;

      const record = await UnifiedService.get(pkg, table, id, context);

      if (!record) {
        const notFoundMsg = i18nHelper.getMessage('NOT_FOUND', context.lang);
        return res.status(404).json({
          success: false,
          status: 404,
          messageKey: 'NOT_FOUND',
          message: notFoundMsg
        });
      }

      const msg = i18nHelper.getMessage('SUCCESS', context.lang);
      res.status(200).json({
        success: true,
        status: 200,
        messageKey: 'SUCCESS',
        message: msg,
        data: record
      });
    } catch (err) {
      next(err);
    }
  }

  async updateRecord(req, res, next) {
    try {
      const { package: pkg, table, id } = req.params;
      const data = req.body;
      const context = req.context;

      await UnifiedService.update(pkg, table, id, data, context);
      const msg = i18nHelper.getMessage('UPDATED', context.lang);

      res.status(200).json({
        success: true,
        status: 200,
        messageKey: 'UPDATED',
        message: msg
      });
    } catch (err) {
      next(err);
    }
  }

  async deleteRecord(req, res, next) {
    try {
      const { package: pkg, table, id } = req.params;
      const context = req.context;

      await UnifiedService.delete(pkg, table, id, context);
      const msg = i18nHelper.getMessage('DELETED', context.lang);

      res.status(200).json({
        success: true,
        status: 200,
        messageKey: 'DELETED',
        message: msg
      });
    } catch (err) {
      next(err);
    }
  }

  async autocomplete(req, res, next) {
    try {
      const { package: pkg, table } = req.params;
      const queryParams = req.query;
      const context = req.context;

      const rows = await autocompleteService.getAutocomplete(pkg, table, queryParams, context);
      const msg = i18nHelper.getMessage('SUCCESS', context.lang);

      res.status(200).json({
        success: true,
        status: 200,
        messageKey: 'SUCCESS',
        message: msg,
        data: rows
      });
    } catch (err) {
      next(err);
    }
  }
}

module.exports = new UnifiedController();