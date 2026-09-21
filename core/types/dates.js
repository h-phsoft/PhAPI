/**
 * Date values, in a form each engine will accept and each client can read.
 *
 * Two bugs live here, one at each boundary, and both come from the same cause:
 * a date was handed across without its format being stated, so whatever was on
 * the other side decided for itself.
 *
 * Going in, Oracle refused outright:
 *
 *   VALUES (..., :p_3, ...)   p_3 = '1995-09-01'
 *   ORA-01861: literal does not match format string
 *
 * because NLS_DATE_FORMAT is DD-MON-RR and nothing said otherwise. MySQL and
 * PostgreSQL accept ISO text silently, which is worse -- the bug only appears
 * on the engine that checks.
 *
 * Coming out, the day moved. The driver hands back a JS Date, and JSON turns
 * that into an instant in UTC:
 *
 *   stored in Oracle : 1995-09-01 00:00:00
 *   JSON.stringify   : "1995-08-31T21:00:00.000Z"
 *
 * Midnight in Damascus is nine the previous evening in London, so every
 * date-only value east of Greenwich read back a day early. Nothing was wrong
 * with the stored data; the serialisation invented a timezone the column never
 * had.
 *
 * So both directions state their format, and neither converts a timezone. A
 * date column holds a calendar date, not an instant, and is read and written
 * through its own components.
 */

/**
 * What a column holds, and therefore how it is written and read.
 *
 * The metadata decides. A field's `DBType` in resources/modules is the single
 * declaration of what that column is, and every engine is made to agree with
 * it -- which is the whole point of describing entities in JSON rather than
 * asking each database what it thinks.
 *
 * So `DATETIME` is a real type here even though Oracle has no such keyword.
 * Oracle's DATE carries a time either way; the builder simply gives it the
 * format the declaration calls for. MySQL and PostgreSQL have their own
 * spellings and get their own. None of that reaches this table or anything
 * above it.
 */
/**
 * Two notations, not three engines.
 *
 * `pattern` is the SQL-standard form that Oracle's TO_DATE and PostgreSQL's
 * TO_TIMESTAMP both read. `strftime` is the percent form MySQL's STR_TO_DATE
 * wants. Naming them after what they are rather than after who uses them is
 * what keeps this file from knowing an engine exists -- a dialect asks for the
 * notation it speaks and spells its own conversion around it.
 *
 * `bind` and `out` are the value itself: what is written to the database, and
 * what a client is handed back.
 */
const FORMATS = {
  DATE: {
    pattern: 'DD-MM-YYYY',
    strftime: '%d-%m-%Y',
    bind: (p) => `${pad(p.day)}-${pad(p.month)}-${pad(p.year, 4)}`,
    out: (p) => `${pad(p.year, 4)}-${pad(p.month)}-${pad(p.day)}`
  },
  DATETIME: {
    pattern: 'DD-MM-YYYY HH24:MI:SS',
    strftime: '%d-%m-%Y %H:%i:%s',
    bind: (p) => `${pad(p.day)}-${pad(p.month)}-${pad(p.year, 4)} ${pad(p.hours)}:${pad(p.minutes)}:${pad(p.seconds)}`,
    out: (p) => `${pad(p.year, 4)}-${pad(p.month)}-${pad(p.day)} ${pad(p.hours)}:${pad(p.minutes)}:${pad(p.seconds)}`
  },
  TIME: {
    pattern: 'HH24:MI:SS',
    strftime: '%H:%i:%s',
    bind: (p) => `${pad(p.hours)}:${pad(p.minutes)}:${pad(p.seconds)}`,
    out: (p) => `${pad(p.hours)}:${pad(p.minutes)}:${pad(p.seconds)}`
  }
};

/** `2026-09-21`, `2026-09-21T08:04:24.970Z`, `2026/09/21 08:04` */
const ISO_LIKE = /^(\d{4})[-/](\d{2})[-/](\d{2})(?:[T ](\d{2}):(\d{2})(?::(\d{2}))?)?/;

/** `21-09-2026`, `21/09/2026 08:04:24` */
const DMY_LIKE = /^(\d{2})[-/](\d{2})[-/](\d{4})(?:[T ](\d{2}):(\d{2})(?::(\d{2}))?)?$/;

/** `08:04`, `08:04:24` */
const TIME_LIKE = /^(\d{2}):(\d{2})(?::(\d{2}))?$/;

function pad(n, width = 2) {
  return String(n).padStart(width, '0');
}

/**
 * @param {Object} fieldMeta A normalised field from the entity metadata
 * @returns {string|null} 'DATE', 'DATETIME', 'TIME', or null when not a date
 */
function dateKind(fieldMeta) {
  const type = String(fieldMeta && fieldMeta.DBType).toUpperCase();
  return FORMATS[type] ? type : null;
}

/** @returns {boolean} Whether this column holds a date, time or both */
function isDateField(fieldMeta) {
  return dateKind(fieldMeta) !== null;
}

/**
 * Reads whatever arrived into plain calendar parts.
 *
 * A date-only string is read field by field rather than through `new Date`,
 * which would parse '1995-09-01' as UTC midnight and then report the previous
 * day anywhere west of Greenwich. The day a user typed is the value; no
 * timezone may move it.
 *
 * A Date object is read through its local getters, which is the same clock the
 * driver used to build it, so a row written at 11:04 reads back as 11:04.
 *
 * @returns {Object|null} {year, month, day, hours, minutes, seconds}
 */
function partsOf(value) {
  if (value === null || value === undefined) {
    return null;
  }

  if (value instanceof Date) {
    if (Number.isNaN(value.getTime())) {
      return null;
    }
    return {
      year: value.getFullYear(), month: value.getMonth() + 1, day: value.getDate(),
      hours: value.getHours(), minutes: value.getMinutes(), seconds: value.getSeconds()
    };
  }

  if (typeof value === 'number') {
    return partsOf(new Date(value));
  }

  const text = String(value).trim();
  if (text === '') {
    return null;
  }

  const time = TIME_LIKE.exec(text);
  if (time) {
    return {
      year: 1970, month: 1, day: 1,
      hours: Number(time[1]), minutes: Number(time[2]), seconds: Number(time[3] || 0)
    };
  }

  const iso = ISO_LIKE.exec(text);
  if (iso) {
    return {
      year: Number(iso[1]), month: Number(iso[2]), day: Number(iso[3]),
      hours: Number(iso[4] || 0), minutes: Number(iso[5] || 0), seconds: Number(iso[6] || 0)
    };
  }

  const dmy = DMY_LIKE.exec(text);
  if (dmy) {
    return {
      year: Number(dmy[3]), month: Number(dmy[2]), day: Number(dmy[1]),
      hours: Number(dmy[4] || 0), minutes: Number(dmy[5] || 0), seconds: Number(dmy[6] || 0)
    };
  }

  const parsed = new Date(text);
  return Number.isNaN(parsed.getTime()) ? null : partsOf(parsed);
}

/**
 * The string to bind, in the format the matching conversion expects.
 *
 * @param {*} value Whatever arrived for this column
 * @param {string} kind 'DATE' | 'DATETIME' | 'TIME'
 * @returns {string|null}
 */
function toDateParam(value, kind = 'DATETIME') {
  const parts = partsOf(value);
  if (!parts) {
    // An unrecognised non-empty value is passed through so it fails at the
    // database rather than being silently turned into something else.
    const text = value === null || value === undefined ? null : String(value).trim();
    return text === '' ? null : text;
  }
  return (FORMATS[String(kind).toUpperCase()] || FORMATS.DATETIME).bind(parts);
}

/**
 * What a client is given for this column.
 *
 * ISO ordering, because that is what a date input reads and what sorts
 * correctly as text -- but the date itself, with no timezone attached, because
 * the column never had one.
 *
 * @param {*} value The value as the driver returned it
 * @param {string} kind 'DATE' | 'DATETIME' | 'TIME'
 * @returns {string|null}
 */
function toClientValue(value, kind = 'DATETIME') {
  const parts = partsOf(value);
  if (!parts) {
    return value === null || value === undefined || String(value).trim() === '' ? null : value;
  }
  return (FORMATS[String(kind).toUpperCase()] || FORMATS.DATETIME).out(parts);
}

/**
 * Which properties of a row hold a date, and of what kind. Cached against the
 * entity, which is a singleton built once at startup.
 */
const plans = new WeakMap();

/**
 * @param {Object} entity Entity metadata
 * @returns {Array<[string, string]>} [property, kind] pairs
 */
function datePlanFor(entity) {
  const cached = plans.get(entity);
  if (cached) {
    return cached;
  }

  const fields = Array.isArray(entity.fields) ? entity.fields : [];
  const plan = fields
    .map(field => [field.Field, dateKind(field)])
    .filter(([property, kind]) => property && kind);

  plans.set(entity, plan);
  return plan;
}

/**
 * Puts every date column of a row into the shape its type declares.
 *
 * This is the other half of `toDateParam`, and lives beside it on purpose:
 * writing a date and reading one back are the same concern, decided by the
 * same declaration. Splitting them would leave a column bound one way and
 * returned another, which is how the day came back wrong before either
 * existed.
 *
 * It is not presentation. A client that wanted a different format would be
 * presentation; turning a driver's Date back into the column's declared type
 * is reading it correctly.
 *
 * Rows are mutated in place: they are fresh objects from the query.
 *
 * @param {Object} entity Entity metadata
 * @param {Object|Object[]} rows A row or rows as the driver returned them
 * @returns {Object|Object[]} The same rows
 */
function shapeDates(entity, rows) {
  if (!rows || !entity) {
    return rows;
  }

  const plan = datePlanFor(entity);
  if (plan.length === 0) {
    return rows;
  }

  const list = Array.isArray(rows) ? rows : [rows];

  for (const row of list) {
    if (!row || typeof row !== 'object') {
      continue;
    }
    for (const [property, kind] of plan) {
      if (row[property] !== undefined) {
        row[property] = toClientValue(row[property], kind);
      }
    }
  }

  return rows;
}

/**
 * The format string a kind is written and read in.
 *
 * A dialect asks for this and spells its own conversion around it, so the
 * formats live in one place without this file knowing an engine exists.
 *
 * @param {string} kind 'DATE' | 'DATETIME' | 'TIME'
 * @param {string} notation 'pattern' for the SQL-standard form, 'strftime' for
 *   the percent form
 * @returns {string}
 */
function formatFor(kind, notation = 'pattern') {
  const fmt = FORMATS[String(kind).toUpperCase()] || FORMATS.DATETIME;
  return fmt[notation] || fmt.pattern;
}

module.exports = {
  formatFor,
  FORMATS,
  dateKind,
  isDateField,
  toDateParam,
  toClientValue,
  shapeDates
};
