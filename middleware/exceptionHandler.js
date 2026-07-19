const ResultManager = require('../utils/responseManager');
const logger = require('../utils/logger');

const exceptionHandler = (err, req, res, next) => {
  logger.error(`Error: ${err.message}`, {
    stack: err.stack,
    path: req.path,
    method: req.method,
    ip: req.ip,
    userAgent: req.get('User-Agent')
  });

  if (res.headersSent) {
    return next(err);
  }

  // Check for specific error types
  if (err.code === 'ER_DUP_ENTRY') {
    return res.status(409).json(ResultManager.error('Duplicate entry found', 409));
  }

  if (err.code === 'ER_NO_REFERENCED_ROW') {
    return res.status(400).json(ResultManager.error('Invalid foreign key reference', 400));
  }

  return res.status(err.status || 500).json(
    ResultManager.error(
      process.env.NODE_ENV === 'production' ? 'Internal server error' : err.message,
      err.status || 500
      )
    );
};

module.exports = exceptionHandler;