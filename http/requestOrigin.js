/**
 * Where a request came from, as plain values.
 *
 * The audit trail records the caller's address, host and port. Reading them is
 * HTTP's business, so it happens here and the service is handed the answer --
 * rather than the service being handed a request and reaching into it, which
 * made a domain component depend on Express.
 *
 * @param {Object} req Express request
 * @returns {{ip: string, host: string, port: string}}
 */
function requestOrigin(req) {
  if (!req) {
    return { ip: '', host: '', port: '' };
  }

  return {
    ip: req.ip || (req.connection && req.connection.remoteAddress) || '',
    host: req.hostname || '',
    port: String((req.socket && req.socket.localPort) || '')
  };
}

module.exports = requestOrigin;
