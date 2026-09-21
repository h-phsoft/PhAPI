/**
 * Reading a screen out of the Java client's page script.
 *
 * The Java front end describes each screen declaratively and then hands the
 * description to one of three widgets:
 *
 *   PhForm    an entry form with a list beneath it -- `aFields` and `aQFields`
 *   PhQForm   a query form -- condition, display and print cards
 *   PhsQuery  the same, with grouping and aggregation cards as well
 *
 * So the description already exists and does not need inventing. What it does
 * need is extracting, and a regular expression is the wrong tool: the field
 * lists are object literals holding function calls (`getLabel('Name')`),
 * references to lookup arrays filled by an earlier request, and string
 * concatenation (`getLabel('Phone') + ' 1'`).
 *
 * They are therefore run rather than parsed. The page is evaluated in a context
 * where the constants are real -- PhConst.js is evaluated first, so PhFC_Select
 * and aTOpers hold the values they hold in the browser -- and everything the
 * page would reach for outside itself is a stub: `$` does not touch a DOM,
 * `_ajax` never resolves, and the widget constructors record their arguments
 * instead of rendering. `getLabel` returns its own key, which is what a label is
 * here: a key into the same .properties bundle the API translates from.
 *
 * Nothing here trusts the page to be well behaved. It is another project's code
 * being run for its data, so every entry point is attempted independently and a
 * throw anywhere costs only what that attempt would have produced.
 */

const fs = require('fs');
const vm = require('vm');

/** The widget constructors worth capturing, and what each one draws. */
const WIDGETS = {
  PhForm: 'form',
  PhsForm: 'form',
  PhsFormOld: 'form',
  PhModalForm: 'form',
  PhQForm: 'query',
  PhsQuery: 'query',
  PhTable: 'table',
  PhsModal: 'form',
  PhModal: 'form',
  PhKanban: 'table'
};

/**
 * Something a page may reach into arbitrarily deep without ever being read.
 *
 * `PhSettings.UsrCodes.FixSpecification1` is a lookup array on a real page and
 * undefined here; answering with a proxy rather than undefined means the
 * property walk does not throw before the page reaches the declaration being
 * extracted.
 *
 * @param {string} label Where in the stub tree this sits, for debugging
 */
function deepStub(label = 'stub') {
  const target = function () { return deepStub(label); };

  return new Proxy(target, {
    get(_t, prop) {
      if (prop === Symbol.toPrimitive || prop === 'toString' || prop === 'valueOf') {
        return () => '';
      }
      if (prop === Symbol.iterator) {
        return function* () {};
      }
      if (prop === 'length') {
        return 0;
      }
      // `then` would make this look like a promise to an awaiting caller, and
      // a symbol reaching a string template is a TypeError.
      if (prop === 'then' || typeof prop === 'symbol') {
        return undefined;
      }
      return deepStub(`${label}.${String(prop)}`);
    },
    set() { return true; },
    has() { return true; },
    apply() { return deepStub(label); }
  });
}

/** A jQuery-shaped object that touches nothing and always answers. */
function jqueryStub(ready) {
  const chain = new Proxy(function () { return chain; }, {
    get(_t, prop) {
      if (prop === 'length') {
        return 0;
      }
      if (typeof prop === 'symbol') {
        return undefined;
      }
      if (['val', 'text', 'html', 'attr', 'data', 'prop'].includes(prop)) {
        return () => '';
      }
      return () => chain;
    },
    apply() { return chain; }
  });

  const $ = function (arg) {
    if (typeof arg === 'function') {
      ready.push(arg);
    }
    return chain;
  };

  $.extend = function (deep, ...rest) {
    const args = deep === true ? rest : [deep, ...rest];
    return Object.assign({}, ...args.filter(a => a && typeof a === 'object'));
  };
  $.ajax = () => deepStub('ajax');
  $.each = () => chain;
  $.fn = {};

  return $;
}

/** Everything a page calls that has no bearing on what it declares. */
const NOOPS = [
  '_ajax', 'select', 'showHeaderSpinner', 'isValidForm', 'swal', 'Swal', 'Toast',
  'initMaterialOutlined', 'formatNumber', 'minDateYearsAgo', 'today', 'IMask',
  'bootstrap', 'updateClipPath', 'showAlert', 'confirmDialog', 'printReport',
  'alert', 'confirm', 'moment', 'Chart', 'Highcharts'
];

/**
 * Builds the context a page script runs in.
 *
 * @param {string} constantsPath PhConst.js
 * @returns {{context: Object, captured: Array, ready: Function[]}}
 */
function makeContext(constantsPath) {
  const captured = [];
  const ready = [];

  const sandbox = {
    console: { log() {}, warn() {}, error() {}, info() {} },
    setTimeout() {}, setInterval() {}, clearTimeout() {}, clearInterval() {},
    Math, Date, JSON, String, Number, Boolean, Array, Object, RegExp, Error,
    parseInt, parseFloat, isNaN, encodeURIComponent, decodeURIComponent
  };

  sandbox.window = sandbox;
  sandbox.globalThis = sandbox;
  sandbox.$ = jqueryStub(ready);
  sandbox.jQuery = sandbox.$;
  sandbox.document = deepStub('document');
  sandbox.navigator = deepStub('navigator');
  sandbox.localStorage = deepStub('localStorage');
  sandbox.PhSettings = deepStub('PhSettings');
  sandbox.Labels = deepStub('Labels');

  // A label here is a key into the same bundle the API translates from, so the
  // key is the useful thing and returning it keeps it.
  sandbox.getLabel = (key) => String(key === undefined || key === null ? '' : key);

  for (const name of NOOPS) {
    sandbox[name] = () => deepStub(name);
  }

  // A page reaches for names declared in framework files that are not worth
  // evaluating -- PHS_QRY_CARD_CONDITIONS lives at the top of PhsQuery.js,
  // PhTable_WIDTH_FIXED in PhDataTable.js, `currentDate` in main.js -- and one
  // missing name throws before the declaration being extracted is reached. That
  // cost 376 of 543 pages.
  //
  // So an unknown global answers with a stub rather than throwing. Only unknown
  // ones: anything the sandbox really holds is returned as it is, which keeps
  // the constants that do matter (PhFC_Select, aTOpers) exact. A value that was
  // a stub is dropped by JSON.stringify later, so a field whose default could
  // not be computed arrives without one rather than with a wrong one.
  const global = new Proxy(sandbox, {
    has() { return true; },
    get(target, prop) {
      if (prop in target) {
        return target[prop];
      }
      if (typeof prop === 'symbol') {
        return undefined;
      }
      return deepStub(String(prop));
    }
  });

  const context = vm.createContext(global);

  // The constants first, so PhFC_Select and aTOpers hold the values the browser
  // gives them rather than undefined.
  vm.runInContext(fs.readFileSync(constantsPath, 'utf8'), context, { timeout: 5000 });

  // The widget constructors record and return; nothing renders.
  for (const [name, kind] of Object.entries(WIDGETS)) {
    context[name] = function (...args) {
      captured.push({ widget: name, kind, args });
      return deepStub(name);
    };
  }

  return { context, captured, ready };
}

/** The declaration objects a widget was handed, whatever order they came in. */
function readWidgetArgs(args) {
  let fields = null;
  let qFields = null;
  let url = null;
  let options = null;

  for (const arg of args) {
    if (!arg || typeof arg !== 'object') {
      continue;
    }
    if (Array.isArray(arg.aFields)) {
      fields = arg.aFields;
    }
    if (Array.isArray(arg.aQFields)) {
      qFields = arg.aQFields;
    }
    if (arg.aURL && typeof arg.aURL === 'object') {
      url = arg.aURL;
    }
    if (arg.aUrl && typeof arg.aUrl === 'object') {
      url = arg.aUrl;
    }
    if (Array.isArray(arg.cards) || arg.conditonCard || arg.conditionCard) {
      options = arg;
    }
  }

  return { fields, qFields, url, options };
}

/**
 * Runs one page script and returns whatever description it yielded.
 *
 * @param {string} file The page script
 * @param {string} constantsPath PhConst.js
 * @returns {Object}
 */
function readScreen(file, constantsPath) {
  const errors = [];
  const { context, captured, ready } = makeContext(constantsPath);

  const attempt = (what, fn) => {
    try {
      return fn();
    } catch (err) {
      errors.push(`${what}: ${err.message}`);
      return undefined;
    }
  };

  attempt('load', () => vm.runInContext(fs.readFileSync(file, 'utf8'), context, { timeout: 10000 }));

  // A page builds its widget either inside the ready handler or inside an
  // initForm the ready handler calls once its lookups arrive. The stubbed
  // request never resolves, so both are tried.
  for (const fn of ready) {
    attempt('ready', () => fn.call(context));
  }
  if (captured.length === 0 && typeof context.initForm === 'function') {
    attempt('initForm', () => context.initForm());
  }

  const first = captured[0] || null;
  const fromWidget = first ? readWidgetArgs(first.args) : { fields: null, qFields: null, url: null, options: null };

  // Falling back to the builders directly covers a page whose widget could not
  // be reached at all.
  let { fields, qFields } = fromWidget;
  if (!fields && typeof context.getFields === 'function') {
    fields = attempt('getFields', () => context.getFields()) || null;
  }
  if (!qFields && typeof context.getaQFields === 'function') {
    qFields = attempt('getaQFields', () => context.getaQFields()) || null;
  }

  return {
    widget: first ? first.widget : null,
    kind: first ? first.kind : null,
    url: fromWidget.url,
    options: fromWidget.options,
    fields: Array.isArray(fields) ? fields : [],
    qFields: Array.isArray(qFields) ? qFields : [],
    errors
  };
}

module.exports = { readScreen, WIDGETS };
