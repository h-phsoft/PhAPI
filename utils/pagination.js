/* global process */

/**
 * Pagination coercion for the generic endpoints.
 *
 * Page and size arrive as untyped route or query values, so parseInt alone lets
 * NaN through to the query builder (producing a driver error) and leaves the
 * page size unbounded, which lets one request pull an entire table. Both values
 * are coerced to a sane integer here instead.
 */

// Upper bound on rows a single page may return.
const MAX_PAGE_SIZE = parseInt(process.env.MAX_PAGE_SIZE || '1000', 10);

const DEFAULT_PAGE_SIZE = 20;

/**
 * @param {*} value Raw page value
 * @returns {number} 1-based page number, at least 1
 */
function coercePage(value) {
  const page = parseInt(value, 10);
  return Number.isInteger(page) && page > 0 ? page : 1;
}

/**
 * @param {*} value Raw page size
 * @param {number} [fallback] Used when the value is absent or unusable
 * @returns {number} Row count between 1 and MAX_PAGE_SIZE
 */
function coercePageSize(value, fallback = DEFAULT_PAGE_SIZE) {
  const size = parseInt(value, 10);
  if (!Number.isInteger(size) || size <= 0) {
    return Math.min(fallback, MAX_PAGE_SIZE);
  }
  return Math.min(size, MAX_PAGE_SIZE);
}

module.exports = { coercePage, coercePageSize, MAX_PAGE_SIZE, DEFAULT_PAGE_SIZE };
