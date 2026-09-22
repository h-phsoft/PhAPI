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
const { buildWhere, kindOf } = require('./conditions');
const aggregates = require('./aggregates');

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
 * The field a name refers to, or null when the entity has no such column.
 *
 * Every name that reaches the SQL goes through here. A name from a request
 * never becomes an identifier (D2) -- it either resolves to a column the
 * entity declares or it is dropped.
 */
function fieldFor(entity, name) {
  if (!name) {
    return null;
  }
  const wanted = String(name).toLowerCase();
  return entity.fields.find(f => String(f.Field).toLowerCase() === wanted) || null;
}

/**
 * What a grouped SELECT projects, and what it groups by.
 *
 * A grouped query is a different statement from a flat one: only the grouped
 * columns and the aggregates may appear, so the projection is built from those
 * rather than from the entity's full field list. Projecting anything else is an
 * error in every engine, and building it anyway would produce SQL that fails at
 * the database rather than here.
 *
 * Each aggregate is aliased `<field><Fn>` -- `amtSum`, `idCount` -- because a
 * screen may ask for two aggregates of one column and both need somewhere to
 * land. Spelled in camelCase rather than with an underscore so that the alias
 * the SQL carries is exactly the key the row comes back under, on every engine
 * and without the repository having to convert it.
 *
 * @returns {{selected: string[], groupBy: string[]}}
 */
function grouping(dialect, entity, group, aggregate) {
  const selected = [];
  const groupBy = [];

  for (const name of group) {
    const fieldMeta = fieldFor(entity, name);
    if (!fieldMeta) {
      continue;
    }
    const col = column(dialect, fieldMeta);
    selected.push(`${col} AS ${dialect.alias(fieldMeta.Field)}`);
    groupBy.push(col);
  }

  for (const entry of aggregate) {
    // One function per key: `{ Sum: 'amt' }` from the screen metadata,
    // `{ "2": "amt" }` from the client.
    for (const [asked, field] of Object.entries(entry || {})) {
      const fieldMeta = fieldFor(entity, field);
      if (!fieldMeta) {
        continue;
      }
      const name = aggregates.check(asked, kindOf(fieldMeta), fieldMeta.Field);
      const alias = `${fieldMeta.Field}${name[0]}${name.slice(1).toLowerCase()}`;
      selected.push(
        `${dialect.aggregate(name, column(dialect, fieldMeta))} AS ${dialect.alias(alias)}`
      );
    }
  }

  return { selected, groupBy };
}

/**
 * ORDER BY, from whichever way the caller expressed it.
 *
 * Three shapes reach this. `sortBy` with `sortOrder` is one column, which is
 * what the list endpoints send. `order` is a list --
 * `[{ ddate: '-1' }, { id: '1' }]` -- which is what a query screen sends,
 * because its ordering card lets the user stack several. `1` and `-1` are the
 * Java client's directions and the words are accepted too.
 *
 * Falls back to something rather than nothing, because pagination over an
 * unordered query may repeat or skip rows between pages.
 *
 * @returns {string} The clause, including the leading keyword, or ''
 */
function ordering(dialect, entity, { order, sortBy, sortOrder, groupBy }) {
  const parts = [];

  for (const entry of (order || [])) {
    for (const [name, direction] of Object.entries(entry || {})) {
      const fieldMeta = fieldFor(entity, name);
      if (!fieldMeta) {
        continue;
      }
      const descending = String(direction) === '-1' || String(direction).toUpperCase() === 'DESC';
      parts.push(`${column(dialect, fieldMeta)} ${descending ? 'DESC' : 'ASC'}`);
    }
  }

  if (parts.length === 0 && sortBy) {
    const fieldMeta = fieldFor(entity, sortBy);
    const col = fieldMeta ? column(dialect, fieldMeta) : dialect.object(sortBy);
    parts.push(`${col} ${String(sortOrder).toUpperCase() === 'DESC' ? 'DESC' : 'ASC'}`);
  }

  if (parts.length === 0) {
    // A grouped query cannot order by a column it did not group by, so its
    // fallback is the first grouped column rather than the primary key.
    if (groupBy && groupBy.length > 0) {
      parts.push(`${groupBy[0]} ASC`);
    } else {
      const pkMeta = fieldFor(entity, entity.primaryKey);
      if (pkMeta) {
        parts.push(`${column(dialect, pkMeta)} ASC`);
      }
    }
  }

  return parts.length > 0 ? ` ORDER BY ${parts.join(', ')}` : '';
}

/**
 * SELECT, with optional projection, joins, filters, grouping, aggregation,
 * sorting and pagination.
 *
 * @param {Object} dialect
 * @param {Object} entity Entity metadata
 * @param {Object} options { fields, filters, conditions, logic, joins, group,
 *   aggregate, order, sortBy, sortOrder, page, pageSize }. `filters` is
 *   equality shorthand; `conditions` carries an operator per field; `group`
 *   with `aggregate` makes it a grouped query.
 * @returns {{sql: string, params: Object|Array}}
 */
function buildSelect(dialect, entity, options = {}) {
  const {
    fields, filters = {}, conditions = [], logic = 'AND', joins = [],
    group = [], aggregate = [], order = [],
    sortBy, sortOrder = 'ASC', page = 1, pageSize = 20
  } = options;
  const table = tableOf(entity);
  const bind = new ParamBinder(dialect);

  const grouped = (group && group.length > 0) || (aggregate && aggregate.length > 0);
  const plan = grouped ? grouping(dialect, entity, group, aggregate) : null;

  // A grouped query projects its groups and its aggregates. Otherwise: a named
  // projection, else every column the entity declares. Either way each column
  // carries its API name as an alias, which is the contract the rest of the
  // system reads rows by.
  let selected;
  if (plan && plan.selected.length > 0) {
    selected = plan.selected;
  } else if (fields && fields.length > 0) {
    selected = fields.map((name) => {
      const fieldMeta = fieldFor(entity, name);
      return fieldMeta ? `${column(dialect, fieldMeta)} AS ${dialect.alias(fieldMeta.Field)}` : name;
    });
  } else {
    selected = entity.fields.map(f => `${column(dialect, f)} AS ${dialect.alias(f.Field)}`);
  }

  let sql = `SELECT ${selected.join(', ')} FROM ${dialect.object(table)}`;

  for (const join of (joins || [])) {
    const joined = dialect.joinTable(join);
    sql += ` LEFT JOIN ${dialect.object(joined)}`
      + ` ON ${dialect.object(table)}.${dialect.object(join.foreignKeyColumn)}`
      + ` = ${dialect.object(joined)}.${dialect.object(join.primaryKeyColumn)}`;
  }

  const where = [];

  // Equality filters: the shorthand every list endpoint uses.
  for (const [key, value] of Object.entries(filters)) {
    const fieldMeta = entity.fields.find(f => f.Field.toLowerCase() === String(key).toLowerCase());
    if (fieldMeta && fieldMeta.query) {
      where.push(`${column(dialect, fieldMeta)} = ${bindValue(dialect, bind, fieldMeta, value)}`);
    }
  }

  // Search conditions: an operator per field, which is what a query screen
  // sends. Bound and validated by core/query/conditions.
  if (conditions && conditions.length > 0) {
    const built = buildWhere(dialect, entity, conditions, logic, bind);
    if (built.sql) {
      where.push(conditions.length > 1 ? `(${built.sql})` : built.sql);
    }
  }

  if (where.length > 0) {
    sql += ` WHERE ${where.join(' AND ')}`;
  }

  if (plan && plan.groupBy.length > 0) {
    sql += ` GROUP BY ${plan.groupBy.join(', ')}`;
  }

  sql += ordering(dialect, entity, { order, sortBy, sortOrder, groupBy: plan && plan.groupBy });

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
