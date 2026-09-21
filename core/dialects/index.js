/**
 * The engines this project speaks, and the names each answers to.
 *
 * Selection has to name them somewhere, and this is that somewhere -- the
 * layer whose whole job is knowing engines exist. Nothing above it compares an
 * engine name; it asks here for a dialect and talks to that.
 */

const oracle = require('./oracle');
const mysql = require('./mysql');
const postgres = require('./postgres');

const BY_NAME = { oracle, mysql, postgres };

/** Spellings a configuration might use, mapped to the dialect they mean. */
const ALIASES = {
  oracle: 'oracle',
  mysql: 'mysql',
  mariadb: 'mysql',
  postgres: 'postgres',
  postgresql: 'postgres',
  pg: 'postgres'
};

/**
 * @param {string} dbType As the configuration spells it
 * @returns {Object} The dialect
 * @throws {Error} When it is not an engine this project speaks
 */
function dialectFor(dbType = 'mysql') {
  const dialect = BY_NAME[ALIASES[String(dbType).toLowerCase()]];
  if (!dialect) {
    throw new Error(`[Dialects] Unsupported database type: ${dbType}`);
  }
  return dialect;
}

module.exports = { oracle, mysql, postgres, dialectFor };
