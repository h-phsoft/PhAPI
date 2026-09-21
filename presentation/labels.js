/**
 * Translating the vocabulary a client is about to see.
 *
 * This is presentation, not domain: it depends on the request's language, it
 * changes nothing about what a row means, and a service that applied it would
 * be returning display text where it owes domain values. So it runs here, on
 * the way out, above the service that fetched the rows.
 *
 * What is translated is decided by the metadata, not by this file: a column
 * marked `isLabel` holds system vocabulary -- Phs_Cod_Status stores the literal
 * string 'Status.Active' -- rather than text a tenant typed. A person's Name
 * and a code table's Name are the same column to a schema, which is why the
 * flag is set by hand and read from here.
 *
 * Applied for every language, English included, because the stored value is a
 * key and not prose. Anything without an entry falls back to the stored text,
 * so an untranslated tenant reads exactly as it did before.
 */

const mainApp = require('../metadata/registry');
const i18nHelper = require('../utils/i18nHelper');

/**
 * Which properties of a row hold system vocabulary, worked out once per entity
 * and cached against it. The entity is a singleton built at startup.
 */
const plans = new WeakMap();

/**
 * @param {Object} entity Entity metadata
 * @returns {string[]} Row properties to translate
 */
function planFor(entity) {
  const cached = plans.get(entity);
  if (cached) {
    return cached;
  }

  const fields = Array.isArray(entity.fields) ? entity.fields : [];
  const plan = fields
    .filter(field => field.isLabel === true && field.Field)
    .map(field => field.Field);

  plans.set(entity, plan);
  return plan;
}

/**
 * Translates the flagged columns of a row or rows, in place.
 *
 * Rows are fresh objects from the query, never shared metadata, so mutating
 * them is safe and avoids copying a page of results to change two fields.
 *
 * @param {Object} entity Entity metadata
 * @param {Object|Object[]} rows A row or rows
 * @param {string} lang Language code, e.g. 'en' or 'ar'
 * @returns {Object|Object[]} The same rows
 */
function localizeRows(entity, rows, lang = 'en') {
  if (!rows || !entity) {
    return rows;
  }

  const plan = planFor(entity);
  if (plan.length === 0) {
    return rows;
  }

  const list = Array.isArray(rows) ? rows : [rows];

  for (const row of list) {
    if (!row || typeof row !== 'object') {
      continue;
    }
    for (const property of plan) {
      const value = row[property];
      if (typeof value === 'string' && value !== '') {
        row[property] = i18nHelper.translateLabel(value, lang);
      }
    }
  }

  return rows;
}

/**
 * Translates whatever shape a unified endpoint returns.
 *
 * The endpoints answer in three shapes -- a bare array from `list`, a single
 * record from `get`, and `{ data, page, size }` from `search` and `find` -- and
 * a caller should not have to know which it has before it can be localised.
 *
 * @param {string} packageName
 * @param {string} tableName
 * @param {*} payload Whatever the service returned
 * @param {Object} context Request context, carrying `lang`
 * @returns {*} The same payload
 */
function localize(packageName, tableName, payload, context = {}) {
  if (!payload) {
    return payload;
  }

  const entity = mainApp.getEntity(packageName, tableName);
  if (!entity) {
    return payload;
  }

  const lang = context.lang || context.vLang || 'en';

  if (Array.isArray(payload)) {
    return localizeRows(entity, payload, lang);
  }

  if (Array.isArray(payload.data)) {
    localizeRows(entity, payload.data, lang);
    return payload;
  }

  return localizeRows(entity, payload, lang);
}

/**
 * One label, for callers holding text rather than rows.
 *
 * @param {string} label Text as stored
 * @param {string} lang
 * @returns {string}
 */
function translate(label, lang = 'en') {
  return i18nHelper.translateLabel(label, lang);
}

/**
 * Translates the names in a permitted menu tree.
 *
 * Menu, type and program names are held in a single Name column with no
 * second-language equivalent, so the stored English text doubles as the
 * translation key and anything without an entry reads as it always did.
 *
 * The tree is walked rather than mapped because it has three levels and the
 * same rule applies at each. Walked defensively: a caller may hand in a bare
 * list of menus, a list of types, or a single node, and the shapes differ by
 * which key holds the children.
 *
 * Mutates in place; these are freshly built objects, not shared metadata.
 *
 * @param {Array|Object} tree Menus, or any node of one
 * @param {string} lang
 * @returns {Array|Object} The same tree
 */
function localizeMenu(tree, lang = 'en') {
  if (!tree) {
    return tree;
  }

  const nodes = Array.isArray(tree) ? tree : [tree];

  for (const node of nodes) {
    if (!node || typeof node !== 'object') {
      continue;
    }

    if (typeof node.name === 'string' && node.name !== '') {
      node.name = i18nHelper.translateLabel(node.name, lang);
    }

    // Only the keys that hold menu nodes. `profile` and `permissions` sit
    // beside `programs` in the same payload and must not be walked: a user's
    // own name is their data, not system vocabulary.
    for (const key of ['menus', 'progTypes', 'programs', 'aList', 'children']) {
      if (Array.isArray(node[key])) {
        localizeMenu(node[key], lang);
      }
    }
  }

  return tree;
}

module.exports = { localize, localizeRows, translate, localizeMenu };
