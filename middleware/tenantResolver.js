const {getTenantDbConfig} = require('../config/db.config');
const ResultManager = require('../utils/responseManager');

async function resolveTenant(req, res, next) {
  // Check headers for Java & Express naming conventions
  const tenantId = (req.user && (req.user.Copy || req.user.tenantId)) || req.headers['x-tenant-id'] || 'default';
  const periodId = req.headers['periodid'] || req.headers['periodId'] || (req.user && req.user.periodId) || req.headers['x-period-id'] || req.body?.periodId || req.query?.periodId || null;
  const mPrgId = req.headers['mprgid'] || req.headers['mPrgId'] || req.headers['x-program-id'] || null;
  const lang = req.headers['vlang'] || req.headers['vLang'] || req.headers['accept-language'] || req.query?.lang || 'en';
  const userId = (req.user && req.user.userId) || '1';

  try {
    const dbConfig = await getTenantDbConfig(tenantId);

    req.context = {
      tenantId,
      periodId,
      mPrgId,
      userId,
      lang,
      vLang: lang,
      authorization: req.headers['authorization'],
      dbConfig
    };

    next();
  } catch (err) {
    return res.status(200).json(ResultManager.invalid(err.message));
  }
}

module.exports = resolveTenant;


