const ResultManager = require('../utils/responseManager');
const i18nHelper = require('../utils/i18nHelper');
const logger = require('../utils/logger');

function errorHandler(err, req, res, next) {
  const lang = req.context?.lang || 'en';
  let statusCode = err.statusCode || 500;
  let messageKey = 'SERVER_ERROR';

  if (err.name === 'ValidationError') {
    statusCode = 400;
    messageKey = 'VALIDATION_ERROR';
  } else if (err.name === 'UnauthorizedError' || err.name === 'AuthError') {
    statusCode = 401;
    messageKey = 'UNAUTHORIZED';
  } else if (err.name === 'ForbiddenError') {
    statusCode = 403;
    messageKey = 'FORBIDDEN';
  } else if (err.name === 'NotFoundError') {
    statusCode = 404;
    messageKey = 'NOT_FOUND';
  }

  const localizedMessage = i18nHelper.getMessage(messageKey, lang);

  // Write full error metadata & stack trace to log file
  logger.error(`[GlobalErrorHandler] ${err.name} (${statusCode}): ${err.message}`, {
    method: req.method,
    url: req.originalUrl,
    headers: {
      mprgid: req.headers['mprgid'] || req.headers['mPrgId'],
      periodid: req.headers['periodid'] || req.headers['periodId'],
      vlang: req.headers['vlang'] || req.headers['vLang']
    },
    body: process.env.NODE_ENV === 'development' ? req.body : '[REDACTED FOR SECURITY]',
    context: req.context ? {copy: req.context.tenantId, userId: req.context.userId} : null,
    stack: err.stack
  });


  res.status(200).json(ResultManager.error(statusCode, err.message || localizedMessage));
}

module.exports = errorHandler;


