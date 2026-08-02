const i18nHelper = require('../utils/i18nHelper');

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

  console.error(`[Error] ${err.name} (${statusCode}):`, err.message, err.stack);

  res.status(statusCode).json({
    success: false,
    status: statusCode,
    messageKey,
    message: err.message || localizedMessage,
    details: err.details || null
  });
}

module.exports = errorHandler;
