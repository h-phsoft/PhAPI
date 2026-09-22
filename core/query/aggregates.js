/**
 * The aggregate functions a query screen may ask for.
 *
 * A closed list, for the same reason the operators are one (D3): a function
 * name that reached the SQL from a request would be an injection point, and one
 * that reached it from stale metadata would be a runtime error in the database
 * rather than a refusal here.
 *
 * Two spellings arrive and both are the contract. The screen metadata carries
 * names -- `Sum`, `StdDev`, `Median`, as the 595 query definitions spell them.
 * The runtime payload carries the `PhAggregate_*` ordinals those names were
 * chosen from, because `PhsQuery.getQueryData` builds `{ "2": "amount" }` from
 * the select's own value. Reading only one of them would leave either the
 * screen files or the client unable to ask for anything.
 *
 * `PhAggregate_None` and `PhAggregate_Count` are both 1 in the original, so
 * ordinal 1 is Count and there is no way to distinguish "none" from "count" on
 * the wire. That is the Java behaviour and is not corrected here: a client that
 * means "no aggregate" omits the entry.
 *
 * What SQL each one becomes is not decided here. `MEDIAN` is a function in
 * Oracle, a window expression in PostgreSQL and absent from MySQL, so the
 * dialect spells it and a dialect that cannot refuses by name (L3).
 */

/** Which kinds of column an aggregate makes sense on. */
const NUMERIC_ONLY = ['number'];
const ANY_ORDERED = ['number', 'temporal', 'text'];
const ANYTHING = ['number', 'temporal', 'text', 'other'];

/**
 * Every aggregate, by the canonical name the dialects spell.
 *
 * `ordinal` is its `PhAggregate_*` value, which is what a client sends.
 */
const AGGREGATES = {
  COUNT:    { ordinal: 1, kinds: ANYTHING },
  SUM:      { ordinal: 2, kinds: NUMERIC_ONLY },
  AVG:      { ordinal: 3, kinds: NUMERIC_ONLY },
  MIN:      { ordinal: 4, kinds: ANY_ORDERED },
  MAX:      { ordinal: 5, kinds: ANY_ORDERED },
  STDDEV:   { ordinal: 6, kinds: NUMERIC_ONLY },
  VARIANCE: { ordinal: 7, kinds: NUMERIC_ONLY },
  MEDIAN:   { ordinal: 8, kinds: NUMERIC_ONLY }
};

/** The names the screen metadata and the Java constants use, to the canonical one. */
const ALIASES = {
  count: 'COUNT',
  sum: 'SUM',
  avg: 'AVG',
  average: 'AVG',
  min: 'MIN',
  max: 'MAX',
  stddev: 'STDDEV',
  std: 'STDDEV',
  variance: 'VARIANCE',
  var: 'VARIANCE',
  median: 'MEDIAN'
};

const BY_ORDINAL = new Map(
  Object.entries(AGGREGATES).map(([name, spec]) => [spec.ordinal, name])
);

/** Raised when an aggregate cannot be turned into SQL. */
class AggregateError extends Error {
  constructor(message, detail = null) {
    super(message);
    this.name = 'ValidationError';
    this.detail = detail;
  }
}

/**
 * The canonical name for whatever the caller asked for, or null.
 *
 * Accepts a name in any casing, or the ordinal as a number or a numeric string
 * -- a JSON object key is always a string, so `{ "2": "amount" }` arrives as
 * the latter.
 *
 * @param {string|number} asked
 * @returns {string|null}
 */
function resolve(asked) {
  if (asked === null || asked === undefined) {
    return null;
  }

  const text = String(asked).trim();
  if (text === '') {
    return null;
  }

  if (/^\d+$/.test(text)) {
    return BY_ORDINAL.get(Number(text)) || null;
  }

  return ALIASES[text.toLowerCase()] || (AGGREGATES[text.toUpperCase()] ? text.toUpperCase() : null);
}

/**
 * The aggregates a column may be asked for.
 *
 * @param {string} kind From conditions.kindOf
 * @returns {string[]}
 */
function aggregatesFor(kind) {
  return Object.entries(AGGREGATES)
    .filter(([, spec]) => spec.kinds.includes(kind))
    .map(([name]) => name);
}

/**
 * Checks one aggregate against a column and returns its canonical name.
 *
 * @param {string|number} asked
 * @param {string} kind From conditions.kindOf
 * @param {string} field For the error message
 * @returns {string}
 * @throws {AggregateError}
 */
function require_(asked, kind, field) {
  const name = resolve(asked);
  if (!name) {
    throw new AggregateError(`Unknown aggregate '${asked}'`, { field, aggregate: asked });
  }
  if (!AGGREGATES[name].kinds.includes(kind)) {
    throw new AggregateError(
      `Aggregate '${name}' is not allowed on ${field}`,
      { field, aggregate: name, allowed: aggregatesFor(kind) }
    );
  }
  return name;
}

module.exports = {
  AGGREGATES,
  AggregateError,
  resolve,
  aggregatesFor,
  check: require_
};
