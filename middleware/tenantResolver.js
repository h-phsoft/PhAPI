const { getTenantDbConfig } = require('../config/db.config');

async function resolveTenant(req, res, next) {
  const tenantId = (req.user && req.user.tenantId) || req.headers['x-tenant-id'] || 'default';
  const periodId = (req.user && req.user.periodId) || req.headers['x-period-id'] || req.body?.periodId || req.query?.periodId || null;
  const userId = (req.user && req.user.userId) || 'system';

  try {
    const dbConfig = await getTenantDbConfig(tenantId);

    req.context = {
      tenantId,
      periodId,
      userId,
      lang: req.headers['accept-language'] || req.query?.lang || 'en',
      dbConfig
    };

    next();
  } catch (err) {
    return res.status(400).json({
      success: false,
      status: 400,
      messageKey: 'TENANT_ERROR',
      message: err.message
    });
  }
}

module.exports = resolveTenant;
