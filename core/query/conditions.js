/**
 * Search conditions: the operators a screen may filter with, and the SQL each
 * one produces.
 *
 * Ported from the Java system's `Condition.java`, which is the contract 595
 * query screens are written against. The operator tokens are its tokens, and
 * two of them are easy to misread:
 *
 *   `<>` is BETWEEN.        It is not "not equal".
 *   `><` is NOT BETWEEN.
 *
 * Guessing those would silently invert every range filter in the system, which
 * is why they were read out of the original rather than assumed.
 *
 * What is deliberately NOT ported is how that file built the SQL. It
 * concatenated values into the statement and defended itself by doubling
 * single quotes, which meant numbers went in quoted, a value containing a
 * quote depended on one escape being right everywhere, and the `$$` operator
 * spliced raw SQL. Here every value is bound. The engine sees a placeholder.
 *
 * Three things are checked before a condition becomes SQL, and all three
 * reject rather than repair:
 *
 *   - the field must be a real column on the entity, resolved through the
 *     metadata, so a name from a request never reaches the statement;
 *   - the operator must be one of these, and one this column's type allows;
 *   - `$$` is refused outright from anything a client supplied.
 */

const { dateKind, toDateParam } = require('../types/dates');

/**
 * Every operator, by the token the client sends.
 *
 * `arity` says how many values it consumes: 1 for a comparison, 2 for a range,
 * 'list' for IN. `wrap` shapes the bound value -- the LIKE family binds the
 * wildcards with the value rather than splicing them into the SQL.
 */
const OPERATORS = {
  '=':    { arity: 1, sql: (col, p) => `${col} = ${p}` },
  '!=':   { arity: 1, sql: (col, p) => `${col} != ${p}` },
  '>':    { arity: 1, sql: (col, p) => `${col} > ${p}` },
  '>=':   { arity: 1, sql: (col, p) => `${col} >= ${p}` },
  '<':    { arity: 1, sql: (col, p) => `${col} < ${p}` },
  '<=':   { arity: 1, sql: (col, p) => `${col} <= ${p}` },

  // Ranges. The tokens look like comparisons and are not.
  '<>':   { arity: 2, sql: (col, a, b) => `${col} BETWEEN ${a} AND ${b}` },
  '><':   { arity: 2, sql: (col, a, b) => `${col} NOT BETWEEN ${a} AND ${b}` },

  // Text. Case-insensitive, as the original was.
  '[%':   { arity: 1, wrap: (v) => `${v}%`,  sql: (col, p) => `UPPER(${col}) LIKE UPPER(${p})` },
  '![%':  { arity: 1, wrap: (v) => `${v}%`,  sql: (col, p) => `UPPER(${col}) NOT LIKE UPPER(${p})` },
  '%]':   { arity: 1, wrap: (v) => `%${v}`,  sql: (col, p) => `UPPER(${col}) LIKE UPPER(${p})` },
  '!%]':  { arity: 1, wrap: (v) => `%${v}`,  sql: (col, p) => `UPPER(${col}) NOT LIKE UPPER(${p})` },
  '%':    { arity: 1, wrap: (v) => `%${v}%`, sql: (col, p) => `UPPER(${col}) LIKE UPPER(${p})` },
  '!%':   { arity: 1, wrap: (v) => `%${v}%`, sql: (col, p) => `UPPER(${col}) NOT LIKE UPPER(${p})` },

  'IN':   { arity: 'list', sql: (col, list) => `${col} IN (${list})` },
  '!IN':  { arity: 'list', sql: (col, list) => `${col} NOT IN (${list})` }
};

/**
 * The raw-SQL operator.
 *
 * It exists in the original and is never accepted here from a request. It is
 * listed so that a condition carrying it is refused by name rather than
 * falling through as "unknown operator", which would hide what was attempted.
 */
const FREE_SQL = '$$';

/**
 * Which operators each kind of column allows.
 *
 * Read off what the 595 query definitions actually declare: text columns offer
 * equality and the LIKE family, ordered columns offer comparison and ranges.
 * Offering a range on a name, or `starts with` on a number, is not a safety
 * problem but it is a nonsense, and refusing it here keeps a screen honest.
 */
const BY_KIND = {
  text: ['=', '!=', '[%', '![%', '%]', '!%]', '%', '!%', 'IN', '!IN'],
  number: ['=', '!=', '>', '>=', '<', '<=', '<>', '><', 'IN', '!IN'],
  temporal: ['=', '!=', '>', '>=', '<', '<=', '<>', '><'],
  other: ['=', '!=', 'IN', '!IN']
};

/**
 * What kind of column this is, for the purpose of choosing operators.
 *
 * Derived from the metadata's `DBType`, which is generated from the live
 * schema and is accurate -- unlike the legacy definitions' own `dataType`,
 * which is absent on 64% of fields.
 *
 * @param {Object} fieldMeta A normalised field
 * @returns {string} 'text' | 'number' | 'temporal' | 'other'
 */
function kindOf(fieldMeta) {
  const type = String(fieldMeta && fieldMeta.DBType).toUpperCase();
  if (type === 'VARCHAR2') {
    return 'text';
  }
  if (type === 'NUMBER') {
    return 'number';
  }
  if (type === 'DATE' || type === 'DATETIME' || type === 'TIME') {
    return 'temporal';
  }
  return 'other';
}

/**
 * The operators a column may be filtered with.
 *
 * @param {Object} fieldMeta
 * @returns {string[]}
 */
function operatorsFor(fieldMeta) {
  return BY_KIND[kindOf(fieldMeta)].slice();
}

/** Raised when a condition cannot be turned into SQL. */
class ConditionError extends Error {
  constructor(message, detail = null) {
    super(message);
    this.name = 'ValidationError';
    this.detail = detail;
  }
}

/**
 * Resolves one condition's field against the entity.
 *
 * Returns null rather than throwing for a field the entity does not have, so a
 * caller can drop it and carry on -- which is what the Java original does, and
 * changing that would turn a stale saved search into a failed request.
 *
 * @param {Object} entity Entity metadata
 * @param {string} name The field name as the client sent it
 * @returns {Object|null} The field metadata
 */
function resolveField(entity, name) {
  if (!name) {
    return null;
  }
  const wanted = String(name).toLowerCase();
  const field = entity.fields.find(f => String(f.Field).toLowerCase() === wanted);
  return field && field.query !== false ? field : null;
}

/**
 * Binds a value for a column, wrapping a date in the engine's conversion.
 *
 * @param {Object} dialect
 * @param {Object} bind The statement's ParamBinder
 * @param {Object} fieldMeta
 * @param {*} value
 * @returns {string} The expression that reads it
 */
function bindFor(dialect, bind, fieldMeta, value) {
  const kind = dateKind(fieldMeta);
  const placeholder = bind.add(kind ? toDateParam(value, kind) : value);
  return kind ? dialect.toDate(placeholder, kind) : placeholder;
}

/**
 * One condition, however the caller spelled it.
 *
 * Two spellings reach this endpoint and both are the same contract. The
 * canonical one is `{ field, operator, value, value2 }`. The Java client's
 * `PhForm.getQueryData` and `PhsQuery.getQueryData` both build
 * `{ fieldName, dataType, operation, value1, value2 }` instead, and reading only
 * the canonical names meant `condition.field` was undefined on every one of
 * them -- so the column never resolved, the condition was dropped as unknown,
 * and the search came back as an unfiltered page of rows. Every search that
 * client has made since the port has ignored what the user asked for.
 *
 * `dataType` is deliberately not read: it is the legacy `PHFC_*` component the
 * field was drawn as, and the column's own DBType decides how a value is bound
 * (P3 -- where the legacy metadata and the schema disagree, the schema wins).
 *
 * @param {Object} condition
 * @returns {{field: *, operator: string, value: *, value2: *, values: *}}
 */
function normalize(condition) {
  return {
    field: condition.field !== undefined ? condition.field : condition.fieldName,
    operator: condition.operator !== undefined ? condition.operator : condition.operation,
    value: condition.value !== undefined ? condition.value : condition.value1,
    value2: condition.value2,
    values: condition.values
  };
}

/**
 * Turns one condition into a SQL fragment, binding every value.
 *
 * @param {Object} dialect
 * @param {Object} bind
 * @param {Object} entity
 * @param {Object} raw { field, operator, value, value2, values }, or the Java
 *   client's { fieldName, operation, value1, value2 }
 * @returns {string|null} The fragment, or null when the condition is dropped
 * @throws {ConditionError} When the operator is refused
 */
function toFragment(dialect, bind, entity, raw) {
  const condition = normalize(raw);
  const operator = String(condition.operator || '=').trim();

  if (operator === FREE_SQL) {
    throw new ConditionError(
      'The free-SQL operator is not accepted from a request',
      { field: condition.field, operator }
    );
  }

  const spec = OPERATORS[operator];
  if (!spec) {
    throw new ConditionError(`Unknown search operator '${operator}'`, { field: condition.field, operator });
  }

  const fieldMeta = resolveField(entity, condition.field);
  if (!fieldMeta) {
    // Unknown or unqueryable column: dropped, never passed through as text.
    return null;
  }

  if (!operatorsFor(fieldMeta).includes(operator)) {
    throw new ConditionError(
      `Operator '${operator}' is not allowed on ${fieldMeta.Field}`,
      { field: fieldMeta.Field, operator, allowed: operatorsFor(fieldMeta) }
    );
  }

  const column = dialect.object(fieldMeta.Name);
  const shape = spec.wrap || ((v) => v);

  if (spec.arity === 'list') {
    const values = Array.isArray(condition.values)
      ? condition.values
      : (condition.value === undefined ? [] : [condition.value]);

    if (values.length === 0) {
      return null;
    }

    const placeholders = values.map(v => bindFor(dialect, bind, fieldMeta, shape(v)));
    return spec.sql(column, placeholders.join(', '));
  }

  if (spec.arity === 2) {
    if (condition.value === undefined || condition.value2 === undefined) {
      return null;
    }
    return spec.sql(
      column,
      bindFor(dialect, bind, fieldMeta, shape(condition.value)),
      bindFor(dialect, bind, fieldMeta, shape(condition.value2))
    );
  }

  if (condition.value === undefined || condition.value === null || condition.value === '') {
    // An empty value is a filter the user left blank, not a filter for empty.
    return null;
  }

  return spec.sql(column, bindFor(dialect, bind, fieldMeta, shape(condition.value)));
}

/**
 * Builds a WHERE body from a list of conditions.
 *
 * @param {Object} dialect
 * @param {Object} entity Entity metadata
 * @param {Array} conditions
 * @param {string} logic 'AND' or 'OR'
 * @param {Object} bind The statement's ParamBinder, so the placeholders this
 *   adds keep their position among the statement's other values
 * @returns {{sql: string, dropped: string[]}} Empty sql when nothing survived
 */
function buildWhere(dialect, entity, conditions = [], logic = 'AND', bind) {
  const joiner = String(logic).toUpperCase() === 'OR' ? ' OR ' : ' AND ';
  const fragments = [];
  const dropped = [];

  for (const condition of (conditions || [])) {
    if (!condition || typeof condition !== 'object') {
      continue;
    }
    const fragment = toFragment(dialect, bind, entity, condition);
    if (fragment) {
      fragments.push(fragment);
    } else {
      dropped.push(normalize(condition).field);
    }
  }

  return { sql: fragments.join(joiner), dropped };
}

module.exports = {
  OPERATORS,
  FREE_SQL,
  BY_KIND,
  ConditionError,
  kindOf,
  operatorsFor,
  buildWhere,
  toFragment,
  normalize
};
