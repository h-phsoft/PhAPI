const env = require('../config/env');

/**
 * Rewrites the URL shapes the legacy Java front-end uses onto the canonical ones.
 *
 * That client sends a /PhsAPI path prefix -- a leftover from the servlet context
 * path, redundant now the API has its own host -- and reaches login and logout
 * under older endpoint names. Handling it here means the routing table declares
 * each operation exactly once rather than carrying a duplicate registration per
 * alias, which is where more than half of the route table came from.
 *
 * It also keeps the entire compatibility surface in one file. When the Java
 * front-end is retired, set LEGACY_JAVA_CLIENT=false to turn it off, then delete
 * this middleware; nothing else in the codebase has to change.
 */

// Servlet context path the Java client prefixes to every request.
const PREFIX = '/PhsAPI';

// Older names for endpoints that still exist under a canonical path. Keys are
// lower-cased because the Java client is not consistent about casing.
const ALIASES = new Map([
  ['/useraccount/authentication', '/Auth/Login'],
  ['/useraccount/getaccesstoken', '/Auth/Login'],
  ['/useraccount/logout', '/Auth/Logout']
]);

/**
 * @param {string} url
 * @returns {[string, string]} pathname and the query string including '?', or ''
 */
function splitQuery(url) {
  const index = url.indexOf('?');
  return index === -1 ? [url, ''] : [url.slice(0, index), url.slice(index)];
}

/**
 * Reduces a legacy request URL to its canonical form. Exported for tests.
 *
 * @param {string} url Raw req.url
 * @returns {string} The canonical URL, unchanged when nothing matched
 */
function canonicalize(url) {
  if (!url) {
    return url;
  }

  let [pathname, query] = splitQuery(url);

  if (pathname === PREFIX || pathname.startsWith(`${PREFIX}/`)) {
    pathname = pathname.slice(PREFIX.length) || '/';
  }

  const alias = ALIASES.get(pathname.toLowerCase());
  if (alias) {
    pathname = alias;
  }

  return pathname + query;
}

function legacyRoutes(req, res, next) {
  if (env.legacyJavaClient) {
    req.url = canonicalize(req.url);
  }
  next();
}

legacyRoutes.canonicalize = canonicalize;
legacyRoutes.PREFIX = PREFIX;

module.exports = legacyRoutes;
