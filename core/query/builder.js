/**
 * The statements, written once.
 *
 * There used to be three of these, one per engine, each implementing the same
 * six methods -- 495 lines in which the *shape* of a SELECT was repeated three
 * times so that three different quoting styles could be applied to it. Every
 * change had to be made three times, and the date work proved the cost: three
 * near-identical patches, two of which went in mangled before they went in
 * right.
 *
 * What actually differs between engines is spelling: how an identifier is
 * quoted, how a bind is written, which order pagination takes its arguments
 * in, what MAX + 1 is called. That is what a dialect declares, and it is all
 * it declares. Nothing in this file names an engine.
 */

const ParamBinder = require('./paramBinder');
const { dateKind, toDateParam } = require('../types/dates');

/**
 * The column a field maps to, as this engine spells it.
 *
 * @param {Object} dialect
 * @param {Object} fieldMeta A normalised field
 * @returns {string}
 */
function column(dialect, fieldMeta) {
  return dialect.object(fieldMeta.Name);
}

/**
 * Binds one value and returns the expression that reads it.
 *
 * A date is wrapped in the engine's conversion so the format is stated rather
 * than inherited from a session setting, and the value is normalised to match
 * it. Everything else binds as it is.
 *
 * @param {Object} dialect
 * @param {Object} bind The statement's ParamBinder
 * @param {Object} fieldMeta The field the value belongs to
 * @param {*} value
 * @returns {string} The expression to splice into the SQL
 */
function bindValue(dialect, bind, fieldMeta, value) {
  const kind = dateKind(fieldMeta);
  const placeholder = bind.add(kind ? toDateParam(value, kind) : value);
  return kind ? dialect.toDate(placeholder, kind) : placeholder;
}

/** The table a statement addresses. Synonym first, where the engine has them. */
function tableOf(entity) {
  return entity.synonym || entity.tableName;
}

/** The field a primary key names, or the key itself when it names nothing. */
function primaryKeyColumn(dialect, entity) {
  const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === String(entity.primaryKey).toLowerCase());
  return pkMeta ? column(dialect, pkMeta) : dialect.object(entity.primaryKey);
}

/**
 * SELECT, with optional projection, joins, filters, sorting and pagination.
 *
 * @param {Object} dialect
 * @param {Object} entity Entity metadata
 * @param {Object} options { fields, filters, joins, sortBy, sortOrder, page, pageSize }
 * @returns {{sql: string, params: Object|Array}}
 */
function buildSelect(dialect, entity, options = {}) {
  const { fields, filters = {}, joins = [], sortBy, sortOrder = 'ASC', page = 1, pageSize = 20 } = options;
  const table = tableOf(entity);
  const bind = new ParamBinder(dialect);

  // A named projection, else every column the entity declares. Either way each
  // column carries its API name as an alias, which is the contract the rest of
  // the system reads rows by.
  const selected = (fields && fields.length > 0)
    ? fields.map((name) => {
      const fieldMeta = entity.fields.find(m => m.Field.toLowerCase() === String(name).toLowerCase());
      return fieldMeta ? `${column(dialect, fieldMeta)} AS ${dialect.alias(fieldMeta.Field)}` : name;
    })
    : entity.fields.map(f => `${column(dialect, f)} AS ${dialect.alias(f.Field)}`);

  let sql = `SELECT ${selected.join(', ')} FROM ${dialect.object(table)}`;

  for (const join of (joins || [])) {
    const joined = dialect.joinTable(join);
    sql += ` LEFT JOIN ${dialect.object(joined)}`
      + ` ON ${dialect.object(table)}.${dialect.object(join.foreignKeyColumn)}`
      + ` = ${dialect.object(joined)}.${dialect.object(join.primaryKeyColumn)}`;
  }

  const where = [];
  for (const [key, value] of Object.entries(filters)) {
    const fieldMeta = entity.fields.find(f => f.Field.toLowerCase() === String(key).toLowerCase());
    if (fieldMeta && fieldMeta.query) {
      where.push(`${column(dialect, fieldMeta)} = ${bindValue(dialect, bind, fieldMeta, value)}`);
    }
  }

  if (where.length > 0) {
    sql += ` WHERE ${where.join(' AND ')}`;
  }

  if (sortBy) {
    const sortMeta = entity.fields.find(f => f.Field.toLowerCase() === String(sortBy).toLowerCase());
    const sortCol = sortMeta ? column(dialect, sortMeta) : dialect.object(sortBy);
    sql += ` ORDER BY ${sortCol} ${String(sortOrder).toUpperCase() === 'DESC' ? 'DESC' : 'ASC'}`;
  } else if (entity.primaryKey) {
    const pkMeta = entity.fields.find(f => f.Field.toLowerCase() === String(entity.primaryKey).toLowerCase());
    if (pkMeta) {
      sql += ` ORDER BY ${column(dialect, pkMeta)} ASC`;
    }
  }

  if (page && pageSize) {
    sql += dialect.paginate(bind, (page - 1) * pageSize, pageSize);
  }

  return { sql, params: bind.params };
}

/**
 * INSERT of every column the payload carries.
 *
 * @returns {{sql: string, params: Object|Array}}
 */
function buildInsert(dialect, entity, data) {
  const bind = new ParamBinder(dialect);
  const columns = [];
  const values = [];

  for (const fieldMeta of entity.fields) {
    if (Object.prototype.hasOwnProperty.call(data, fieldMeta.Field)) {
      columns.push(column(dialect, fieldMeta));
      values.push(bindValue(dialect, bind, fieldMeta, data[fieldMeta.Field]));
    }
  }

  // PostgreSQL hands the generated key back this way; the other engines report
  // it through their driver, so they add nothing here.
  const returning = dialect.insertReturning
    ? dialect.insertReturning(primaryKeyColumn(dialect, entity))
    : '';

  const sql = `INSERT INTO ${dialect.object(tableOf(entity))}`
    + ` (${columns.join(', ')}) VALUES (${values.join(', ')})${returning}`;

  return { sql, params: bind.params };
}

/**
 * UPDATE by primary key, of every updatable column the payload carries.
 *
 * @returns {{sql: string, params: Object|Array}}
 */
function buildUpdate(dialect, entity, id, data) {
  const bind = new ParamBinder(dialect);
  const assignments = [];

  for (const fieldMeta of entity.fields) {
    if (fieldMeta.update && Object.prototype.hasOwnProperty.call(data, fieldMeta.Field)) {
      assignments.push(`${column(dialect, fieldMeta)} = ${bindValue(dialect, bind, fieldMeta, data[fieldMeta.Field])}`);
    }
  }

  // Bound last, so it follows the assignments in a positional dialect.
  const key = bind.add(id);

  const sql = `UPDATE ${dialect.object(tableOf(entity))} SET ${assignments.join(', ')}`
    + ` WHERE ${primaryKeyColumn(dialect, entity)} = ${key}`;

  return { sql, params: bind.params };
}

/**
 * DELETE by primary key.
 *
 * @returns {{sql: string, params: Object|Array}}
 */
function buildDelete(dialect, entity, id) {
  const bind = new ParamBinder(dialect);
  const key = bind.add(id);

  const sql = `DELETE FROM ${dialect.object(tableOf(entity))}`
    + ` WHERE ${primaryKeyColumn(dialect, entity)} = ${key}`;

  return { sql, params: bind.params };
}

/**
 * The next value for a column numbered by MAX + 1.
 *
 * The period condition is a template from the metadata, not a client value,
 * and is substituted rather than bound -- it is a fragment of SQL, which is
 * why only server-side metadata may supply one.
 *
 * @returns {{sql: string, params: Object|Array}}
 */
function buildMaxAutonumber(dialect, autonumberRule, context = {}) {
  const bind = new ParamBinder(dialect);
  const table = dialect.autonumberTable(autonumberRule);
  const col = dialect.object(autonumberRule.Column);

  let sql = `SELECT ${dialect.maxPlusOne(col)} AS ${dialect.nextValAlias}`
    + ` FROM ${dialect.object(table)}`;

  if (autonumberRule.PeriodCondition) {
    let condition = autonumberRule.PeriodCondition;
    for (const [key, value] of Object.entries(context)) {
      condition = condition.replace(new RegExp(`\\{${key}\\}`, 'g'), value);
    }
    sql += ` WHERE ${condition}`;
  }

  return { sql, params: bind.params };
}

module.exports = {
  buildSelect,
  buildInsert,
  buildUpdate,
  buildDelete,
  buildMaxAutonumber
};
