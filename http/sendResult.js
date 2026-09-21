const env = require('../config/env');

/**
 * Sends a ResultManager envelope with an HTTP status line that matches it.
 *
 * The API has always answered 200 whatever the outcome, because the Java
 * front-end reads the result from the envelope's own `code` and treats any
 * non-2xx response as a transport failure. The cost of that shows up in odd
 * places: the login rate limiter needs a custom requestWasSuccessful precisely
 * because the status line carries no information, and nothing upstream -- a
 * proxy, a log aggregator, a browser devtools panel -- can tell a failure from a
 * success without parsing the body.
 *
 * While LEGACY_JAVA_CLIENT is on, that behaviour is preserved exactly. With it
 * off, the envelope's code becomes the HTTP status as well. The body is byte for
 * byte identical either way, so a client that reads `status`/`code` out of it
 * keeps working under both settings -- which is what makes this safe to flip.
 *
 * @param {Object} res Express response
 * @param {Object} envelope A ResultManager envelope
 * @returns {Object} The response, for `return sendResult(...)`
 */
function sendResult(res, envelope) {
  return res.status(httpStatusFor(envelope)).json(envelope);
}

/**
 * The status line an envelope should carry. Exported for tests.
 *
 * A code outside the valid HTTP range would make Express throw, so anything
 * unrecognised falls back to 200 rather than taking the process down.
 *
 * @param {Object} envelope
 * @returns {number}
 */
function httpStatusFor(envelope) {
  if (env.legacyJavaClient) {
    return 200;
  }

  const code = Number(envelope && envelope.code);
  if (!Number.isInteger(code) || code < 100 || code > 599) {
    return 200;
  }
  return code;
}

sendResult.httpStatusFor = httpStatusFor;

module.exports = sendResult;
