/**
 * The screen registry: which screen a program renders, and what it declares.
 *
 * Two trees are loaded, because two different questions are being answered and
 * one file cannot answer both:
 *
 *   resources/programs   one file per program, at the program's own path.
 *                        `clnc/mng/Doctors.json` serves `clnc/mng/Doctors`.
 *                        It says what that screen is -- its field list, their
 *                        order, their labels, how a reference is picked.
 *
 *   resources/screens    one file per query definition, keyed `Pkg/Name`.
 *                        `Clnc/AppointmentView.json` is what
 *                        /UC/Clnc/AppointmentView/Query runs. It says what may
 *                        be searched, grouped and aggregated on that entity.
 *
 * Several programs share one query definition -- `clnc/qry/Treatments` and
 * `clnc/qry/s/Treatments` are the same report asked two ways -- which is why
 * the second tree is not keyed by program and the first is not keyed by entity.
 *
 * Both are data. Adding a screen is adding a file: nothing here is a list of
 * known screens, and no deploy, build step or registry edit stands between a
 * new file and a client rendering it (M5).
 *
 * This layer only loads and indexes. It does not compose a screen with the
 * entity it overlays, does not translate a label and does not know a request
 * exists -- that is `presentation/screens.js`, above it.
 */

const fs = require('fs');
const path = require('path');

/** A path reduced to what lookups compare: no edge slashes, lower case. */
function key(value) {
  return String(value === undefined || value === null ? '' : value)
    .replace(/^[/\\]+|[/\\]+$/g, '')
    .split('\\').join('/')
    .toLowerCase();
}

class ScreenRegistry {
  constructor() {
    if (ScreenRegistry.instance) {
      return ScreenRegistry.instance;
    }

    /** key: program path, lower case -> screen */
    this.byProgram = new Map();
    /** key: `pkg/name`, lower case -> query definition */
    this.byReport = new Map();
    /** Files the last load could not read. */
    this.errors = [];
    this.isLoaded = false;

    ScreenRegistry.instance = this;
  }

  /**
   * Loads both trees, replacing whatever was loaded before.
   *
   * Replacing rather than merging is what makes a reload safe to call at any
   * time: a screen deleted from disk disappears from the registry instead of
   * lingering until a restart. The new indexes are built beside the old and
   * swapped in at the end; with `keepOnError`, a load that met a file it could
   * not read keeps the old ones, so a half-saved file never costs a running
   * server its screen.
   *
   * @param {{programs: string, reports: string}} dirs Directories to read
   * @param {{keepOnError?: boolean}} [options]
   * @returns {{programs: number, reports: number, errors: Array<{file: string, message: string}>, kept: boolean}}
   */
  load(dirs = {}, options = {}) {
    const previous = { byProgram: this.byProgram, byReport: this.byReport };
    this.byProgram = new Map();
    this.byReport = new Map();
    this.errors = [];

    if (dirs.programs) {
      this.loadPrograms(dirs.programs);
    }
    if (dirs.reports) {
      this.loadReports(dirs.reports);
    }

    const errors = this.errors;
    if (options.keepOnError && errors.length > 0) {
      Object.assign(this, previous);
      console.error(`[Screens] Reload abandoned: ${errors.length} file(s) could not be read; the loaded screens are unchanged.`);
      return { programs: this.byProgram.size, reports: this.byReport.size, errors, kept: true };
    }

    this.dirs = dirs;
    this.isLoaded = true;
    console.log(`[Screens] Loaded ${this.byProgram.size} program screen(s) and ${this.byReport.size} query definition(s).`);
    return { programs: this.byProgram.size, reports: this.byReport.size, errors, kept: false };
  }

  /**
   * Reads every .json beneath a directory.
   *
   * @param {string} dir
   * @param {Function} onFile Called with (parsed, relativePathWithoutExtension)
   * @param {Array} [errors] Collects the files that could not be read
   */
  static walk(dir, onFile, errors = []) {
    if (!fs.existsSync(dir)) {
      console.warn(`[Screens] Directory does not exist: ${dir}`);
      return;
    }

    const visit = (at) => {
      for (const entry of fs.readdirSync(at, { withFileTypes: true })) {
        const full = path.join(at, entry.name);
        if (entry.isDirectory()) {
          visit(full);
          continue;
        }
        if (!entry.name.endsWith('.json')) {
          continue;
        }
        const rel = path.relative(dir, full).split(path.sep).join('/').replace(/\.json$/, '');
        try {
          onFile(JSON.parse(fs.readFileSync(full, 'utf8')), rel, full);
        } catch (err) {
          errors.push({ file: full, message: err.message });
          console.error(`[Screens] Error loading ${full}: ${err.message}`);
        }
      }
    };

    visit(dir);
  }

  /**
   * One file per program, indexed by the program's path.
   *
   * The path on disk is the index, and the `program` property inside the file
   * is indexed too when it differs. The two agree for everything the converter
   * wrote; a hand-written screen that moves keeps working from either.
   */
  loadPrograms(dir) {
    ScreenRegistry.walk(dir, (screen, rel, full) => {
      screen.sourcePath = full;
      this.byProgram.set(key(rel), screen);

      const declared = key(screen.program);
      if (declared && declared !== key(rel)) {
        this.byProgram.set(declared, screen);
      }
    }, this.errors);
  }

  /** One file per query definition, indexed `pkg/name`. */
  loadReports(dir) {
    ScreenRegistry.walk(dir, (screen, rel, full) => {
      screen.sourcePath = full;
      this.byReport.set(key(rel), screen);
    }, this.errors);
  }

  /**
   * The screen a program renders, or null.
   *
   * @param {string} programUrl The path as Phs_MPrg records it, e.g.
   *   `clnc/mng/Doctors`. Whatever casing the tenant seeded is accepted.
   * @returns {Object|null}
   */
  getProgram(programUrl) {
    return this.byProgram.get(key(programUrl)) || null;
  }

  /**
   * The query definition behind a report endpoint, or null.
   *
   * @param {string} pkg
   * @param {string} name
   * @returns {Object|null}
   */
  getReport(pkg, name) {
    if (!pkg || !name) {
      return null;
    }
    return this.byReport.get(key(`${pkg}/${name}`)) || null;
  }

  /** Every program path that has a screen, in their loaded order. */
  programs() {
    return Array.from(this.byProgram.keys());
  }
}

module.exports = new ScreenRegistry();
