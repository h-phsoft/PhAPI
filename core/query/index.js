/**
 * The query layer's entry point.
 *
 * Picks the dialect and hands it to the builder. The public shape is unchanged
 * from when three per-engine builders sat behind it -- `buildSelect(dbType,
 * entity, options)` and the rest -- so nothing above knows the difference.
 */

const builder = require('./builder');
const { dialectFor } = require('../dialects');

module.exports = {
  dialectFor,

  buildSelect(dbType, entity, options) {
    return builder.buildSelect(dialectFor(dbType), entity, options);
  },

  buildInsert(dbType, entity, data) {
    return builder.buildInsert(dialectFor(dbType), entity, data);
  },

  buildUpdate(dbType, entity, id, data) {
    return builder.buildUpdate(dialectFor(dbType), entity, id, data);
  },

  buildDelete(dbType, entity, id) {
    return builder.buildDelete(dialectFor(dbType), entity, id);
  },

  buildMaxAutonumber(dbType, autonumberRule, context) {
    return builder.buildMaxAutonumber(dialectFor(dbType), autonumberRule, context);
  }
};
