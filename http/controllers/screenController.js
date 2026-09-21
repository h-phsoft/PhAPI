/**
 * Serving screen metadata.
 *
 * A client that renders from metadata has to read it from somewhere, and this
 * is the somewhere. Two questions, two endpoints:
 *
 *   GET /UC/Screen/Program/<program path>   what this program's screen is
 *   GET /UC/Screen/Report/<pkg>/<name>      what a query definition offers
 *
 * A program path carries slashes -- `clnc/mng/Doctors` -- so it is taken as the
 * rest of the path rather than as a parameter. It is matched against the
 * registry and never against a file system, so nothing a caller sends can
 * escape the screens directory.
 *
 * Both answers are composed, not the file on disk: labels translated into the
 * caller's language, types and lookups filled in from the entity model. What
 * comes back is ready to render.
 *
 * Authorisation is the same check every other program-scoped route makes. A
 * screen route names no package or table, so `authorize` decides on the
 * `mprgid` the client sends -- the same header it sends with the requests the
 * screen will go on to make.
 */

const screenView = require('../../presentation/screens');
const ResultManager = require('../responseManager');
const sendResult = require('../sendResult');

class ScreenController {
  /**
   * The screen a program renders.
   *
   * 404 when there is none, which is the honest answer and the one the client
   * acts on: it falls back to whatever it has of its own, or to not offering
   * the program at all.
   */
  async program(req, res, next) {
    try {
      // Everything after /UC/Screen/Program/, slashes included.
      const programUrl = req.params[0] || '';
      const screen = screenView.forProgram(programUrl, req.context || {});

      if (!screen) {
        return sendResult(res, ResultManager.error(404, `No screen for program '${programUrl}'`));
      }

      return res.status(200).json(ResultManager.ok(screen));
    } catch (err) {
      return next(err);
    }
  }

  /** The query definition behind a report endpoint. */
  async report(req, res, next) {
    try {
      const { pkgName, reportName } = req.params;
      const screen = screenView.forReport(pkgName, reportName, req.context || {});

      if (!screen) {
        return sendResult(res, ResultManager.error(404, `No query definition for '${pkgName}/${reportName}'`));
      }

      return res.status(200).json(ResultManager.ok(screen));
    } catch (err) {
      return next(err);
    }
  }
}

module.exports = new ScreenController();
