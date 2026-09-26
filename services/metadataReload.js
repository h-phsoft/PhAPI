/**
 * Reloads the metadata a running server reads, without a restart (Step 5.5).
 *
 * Four things are read from disk at startup and nothing else ever reads them
 * again: the entity models, the screens over them, the labels and the
 * autocomplete templates. Changing any of them meant restarting the server,
 * which drops every session's in-flight request and every pool's connections
 * to pick up a label.
 *
 * reload() runs the four loaders again, in the order startup runs them --
 * entities before screens, since a screen names an entity. Each builds its new
 * set beside the one in use and swaps it in only if every file read cleanly;
 * a file that does not keeps that part as it was, and is reported. Each loader
 * is synchronous, so a request never sees a registry half-built.
 *
 * Entities are new objects after a reload. What is cached per entity -- the
 * date plan, the label plan, the canonical column names -- is keyed on the
 * object in a WeakMap, so it is rebuilt for the new one and the old is
 * collected. Nothing holds a stale copy.
 *
 * watch() calls reload() when a file under those trees changes, once the
 * changes have been quiet for a moment: an editor saving a file writes it more
 * than once, and a script rewriting 500 models should cost one reload, not 500.
 */

const fs = require('fs');
const path = require('path');
const mainApp = require('../metadata/registry');
const screens = require('../metadata/screens');
const i18nHelper = require('../utils/i18nHelper');
const autocompleteService = require('./autocompleteService');

/** How long the trees must be quiet before a change is acted on. */
const QUIET_MS = 500;

/**
 * Reads every metadata tree again.
 *
 * @returns {{ok: boolean, ms: number, entities: Object, screens: Object, labels: Object, autocomplete: Object}}
 *   `ok` is false when any part kept its old set; that part's `errors` says why
 */
function reload() {
  const started = Date.now();
  const keep = { keepOnError: true };

  const entities = mainApp.sourceDirs
    ? mainApp.loadMetadata(mainApp.sourceDirs, keep)
    : { entities: 0, errors: [], kept: false };
  const screenSet = screens.dirs
    ? screens.load(screens.dirs, keep)
    : { programs: 0, reports: 0, errors: [], kept: false };
  const labels = i18nHelper.loadLocales(keep);
  const autocomplete = autocompleteService.loadAllAutocompleteMetadata(keep);

  const parts = [entities, screenSet, labels, autocomplete];
  return {
    ok: parts.every((part) => part.errors.length === 0),
    ms: Date.now() - started,
    entities,
    screens: screenSet,
    labels,
    autocomplete
  };
}

/** The directories reload() reads, as they were loaded. */
function watchedDirs() {
  const dirs = [
    ...(mainApp.sourceDirs || []),
    ...(screens.dirs ? [screens.dirs.programs, screens.dirs.reports] : []),
    i18nHelper.localesDir,
    autocompleteService.rootDir
  ];
  return [...new Set(dirs.filter((dir) => dir && fs.existsSync(dir)))];
}

/**
 * Reloads whenever a metadata file changes.
 *
 * @param {{quietMs?: number, onReload?: Function, dirs?: string[]}} [options]
 *   `onReload` receives each reload()'s result; `dirs` overrides what is watched
 * @returns {{stop: Function, dirs: string[]}}
 */
function watch(options = {}) {
  const quietMs = options.quietMs || QUIET_MS;
  const dirs = options.dirs || watchedDirs();
  let timer = null;

  const fire = () => {
    timer = null;
    const result = reload();
    const failed = [result.entities, result.screens, result.labels, result.autocomplete]
      .flatMap((part) => part.errors);
    if (result.ok) {
      console.log(`[MetadataReload] Reloaded in ${result.ms} ms.`);
    } else {
      console.error(`[MetadataReload] ${failed.length} file(s) could not be read; those parts were kept as they were:`);
      for (const { file, message } of failed) {
        console.error(`  ${file}: ${message}`);
      }
    }
    if (options.onReload) {
      options.onReload(result);
    }
  };

  const watchers = dirs.map((dir) => fs.watch(dir, { recursive: true }, (event, filename) => {
    // Some platforms name no file; anything that is named must be JSON.
    if (filename && path.extname(String(filename)) !== '.json') {
      return;
    }
    clearTimeout(timer);
    timer = setTimeout(fire, quietMs);
  }));

  console.log(`[MetadataReload] Watching ${dirs.length} director${dirs.length === 1 ? 'y' : 'ies'} for metadata changes.`);

  return {
    dirs,
    stop() {
      clearTimeout(timer);
      for (const watcher of watchers) {
        watcher.close();
      }
    }
  };
}

module.exports = { reload, watch, watchedDirs, QUIET_MS };
