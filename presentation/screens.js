/**
 * Composing a screen for a client to render.
 *
 * A screen file is an overlay and deliberately thin: it says which fields, in
 * what order, under which label, and how a reference is picked. Everything else
 * about a field -- its type, whether it is required, what it defaults to, which
 * table it points at and which column carries that row's name -- is in the
 * generated entity model, and restating it in the screen file would be a second
 * source of truth (M3).
 *
 * So the two are put together here, and here rather than anywhere lower because
 * what comes out is display: a translated label, an input kind, a lookup URL.
 * A service returns domain values; presentation is what turns them into
 * something a screen can draw (L4).
 *
 * The client therefore receives one flat field list with nothing left to infer,
 * and does not need the entity model, the locale files, or any knowledge of how
 * a DBType maps to an input.
 */

const mainApp = require('../metadata/registry');
const screens = require('../metadata/screens');
const { operatorsFor } = require('../core/query/conditions');
const { dateKind } = require('../core/types/dates');
const i18nHelper = require('../utils/i18nHelper');

/**
 * The input a column is entered through, when the screen does not say.
 *
 * Derived, because every part of the answer is in the schema: a reference
 * column carries a relation and is picked from a list, a DATE is a date, a
 * NUMBER is a number. The screen overrides only what the schema cannot imply --
 * that a reference with thousands of rows is searched rather than listed.
 *
 * @param {Object} meta A field from the entity model
 * @returns {string}
 */
function inputFor(meta) {
  if (meta.relation) {
    return 'select';
  }

  // DATE, DATETIME and TIME as the column declares them, lower-cased into the
  // input a client renders. The declared type is the authority on whether a
  // value carries a time, which is the same rule the bind side follows (D4).
  const kind = dateKind(meta);
  if (kind) {
    return kind.toLowerCase();
  }

  const dbType = String(meta.DBType || '').toUpperCase();
  if (/INT|NUMBER|NUMERIC|DECIMAL|FLOAT|DOUBLE|REAL|MONEY/.test(dbType)) {
    return 'number';
  }

  return 'text';
}

/**
 * The name a client addresses an entity by: its model file's, without the
 * extension.
 *
 * A registry key is the table -- `Clnc_Doctors` -- while a client asks for
 * `/UC/Clnc/Doctors`, which is the file. The separator is whichever the host
 * uses, and getting that character class wrong on Windows turns the whole
 * absolute path into the name.
 *
 * @param {Object} entity
 * @returns {string}
 */
function modelNameOf(entity) {
  return String((entity && entity.sourcePath) || '')
    .split(/[\\/]/)
    .pop()
    .replace(/\.json$/, '');
}

/**
 * The `/UC` path a relation points at, or null when nothing describes it.
 *
 * A relation names the referenced table as the database spells it --
 * `Phs_Code_Gender` -- while a client addresses it by package and model name --
 * `/UC/Phs/CodeGender`. The registry knows both, so the translation happens
 * once here rather than in every screen file.
 *
 * @param {Object} relation
 * @returns {string|null}
 */
function lookupPath(relation) {
  if (!relation || !relation.refTable) {
    return null;
  }

  const target = mainApp.getEntityByTable(relation.refTable)
    || mainApp.getEntityBySynonym(relation.refSynonym || '');

  if (!target || !target.sourcePath) {
    return null;
  }

  return `/UC/${target.package}/${modelNameOf(target)}`;
}

/**
 * One field, as a client needs it.
 *
 * @param {Object} declared The screen's entry for this field
 * @param {Object} meta The entity's column
 * @param {string} lang
 * @returns {Object}
 */
function composeField(declared, meta, lang, withOperators) {
  const field = {
    name: meta.Field,
    label: i18nHelper.translateLabel(declared.labelKey || meta.Field, lang),
    input: declared.input || inputFor(meta)
  };

  // A column the server assigns is not asked for; a NOT NULL one is required.
  if (meta.isNull === false && !meta.isAutonumber) {
    field.required = true;
  }

  if (meta.Default !== undefined && meta.Default !== null && meta.Default !== '') {
    field.defaultValue = String(meta.Default);
  }

  if (meta.relation) {
    const path = lookupPath(meta.relation);
    if (path) {
      field.lookup = path;
    }
    if (meta.relation.apiDisplayField) {
      field.displayField = meta.relation.apiDisplayField;
    }
  }

  if (declared.endpoint) {
    field.endpoint = declared.endpoint;
  }
  if (declared.width) {
    field.width = declared.width;
  }
  if (declared.hidden) {
    field.hidden = true;
  }
  if (declared.readOnly) {
    field.readOnly = true;
  }

  // What the server will refuse, said plainly rather than discovered by having
  // a save rejected. 19 fields across 15 screens sit on a column the entity
  // marks un-insertable or un-updatable -- Stor_Stores_Materiales collects four
  // quantities that only a transaction may set, and three request screens
  // collect the approval they are waiting for -- so a renderer that does not
  // know shows an input whose every value is thrown away.
  //
  // Absent means permitted, which is the convention the rest of these flags
  // follow. Kept as two flags rather than one `readOnly` because the two are
  // genuinely different: a field that cannot be inserted may still be edited
  // afterwards, and one that cannot be updated is set once and then fixed.
  if (meta.insert === false) {
    field.noInsert = true;
  }
  if (meta.update === false) {
    field.noUpdate = true;
  }

  // What may be asked of this column, narrowed by its type -- and only where
  // something will be asked. An entry form does not compare, so carrying an
  // operator list on every form field would be sending a search vocabulary to a
  // screen that has no search.
  if (withOperators) {
    const allowed = operatorsFor(meta);
    const offered = Array.isArray(declared.operators) && declared.operators.length > 0
      ? declared.operators.filter(op => allowed.includes(op))
      : allowed;

    if (offered.length > 0) {
      field.operators = offered;
    }
  }

  return field;
}

/**
 * Turns a screen's field list into composed fields, dropping any naming a
 * column the entity does not have.
 *
 * Dropped rather than passed through: a field that resolves to no column cannot
 * be read, written or searched, and forwarding its name to a client invites it
 * to send that name back as an identifier (D2).
 *
 * @returns {{fields: Object[], dropped: string[]}}
 */
function composeFields(list, entity, lang, withOperators = false) {
  const byExact = new Map(entity.fields.map(f => [f.Field, f]));
  const byLower = new Map(entity.fields.map(f => [String(f.Field).toLowerCase(), f]));

  const fields = [];
  const dropped = [];

  for (const declared of (list || [])) {
    if (!declared || !declared.name) {
      continue;
    }
    // Exact first: twenty-seven entities expose two columns whose API names
    // differ only in case, and a case-insensitive lookup picks between them at
    // random.
    const meta = byExact.get(declared.name) || byLower.get(String(declared.name).toLowerCase());
    if (!meta) {
      dropped.push(String(declared.name));
      continue;
    }
    fields.push(composeField(declared, meta, lang, withOperators));
  }

  return { fields, dropped };
}

/**
 * The screen a program renders, composed, or null when it has none.
 *
 * @param {string} programUrl The path as Phs_MPrg records it
 * @param {Object} context Request context, carrying `lang`
 * @returns {Object|null}
 */
function forProgram(programUrl, context = {}) {
  const screen = screens.getProgram(programUrl);
  if (!screen) {
    return null;
  }

  const [pkg, name] = String(screen.entity || '').split('/');
  const entity = mainApp.getEntity(pkg, name);
  if (!entity) {
    return null;
  }

  const lang = context.lang || context.vLang || 'en';
  const modelName = modelNameOf(entity);

  const composed = {
    version: screen.version || '1.0',
    kind: screen.kind || 'form',
    program: screen.program || programUrl,
    entity: `${entity.package}/${modelName}`,
    endpoint: `/UC/${entity.package}/${modelName}`,
    primaryKey: entity.primaryKey,
    dropped: []
  };

  if (screen.form) {
    const { fields, dropped } = composeFields(screen.form.fields, entity, lang);
    composed.form = { fields };
    composed.dropped.push(...dropped);
  }

  if (screen.search) {
    const { fields, dropped } = composeFields(screen.search.fields, entity, lang, true);
    composed.search = { fields };
    composed.dropped.push(...dropped);
  }

  // The line grids of a document screen. One entity per block (M4): each is
  // composed against its own child entity, so a line's columns carry their own
  // types, defaults, lookups and required flags exactly as the master's do.
  //
  // The foreign key is reported but not rendered -- the service sets it from
  // the master's key on save, and a screen that asked for it would be asking
  // the user which document their own lines belong to.
  if (Array.isArray(screen.lines) && screen.lines.length > 0) {
    composed.lines = [];

    for (const line of screen.lines) {
      const [linePkg, lineName] = String(line.entity || '').split('/');
      const lineEntity = mainApp.getEntity(linePkg, lineName);
      if (!lineEntity) {
        composed.dropped.push(String(line.entity));
        continue;
      }

      const { fields, dropped } = composeFields(line.fields, lineEntity, lang);
      composed.dropped.push(...dropped);

      const lineModel = modelNameOf(lineEntity);

      composed.lines.push({
        childKey: line.childKey,
        entity: `${lineEntity.package}/${lineModel}`,
        endpoint: `/UC/${lineEntity.package}/${lineModel}`,
        primaryKey: lineEntity.primaryKey,
        foreignKey: line.foreignKey,
        fields: fields.map((field) => {
          // The grid's own footer total, which the line file carries and the
          // schema cannot: one function over one money column.
          const declared = line.fields.find(
            f => String(f.name).toLowerCase() === String(field.name).toLowerCase()
          );
          return declared && declared.total ? { ...field, total: declared.total } : field;
        })
      });
    }
  }

  if (screen.order) {
    composed.order = screen.order;
  }

  // The query definition this screen drives, where it drives one. The condition
  // card says what may be asked; the definition says what comes back -- which
  // columns are shown, in what order, which may be grouped and what may be
  // aggregated over them. Neither source has the other's half, so a query
  // screen needs both and is given both here rather than fetching twice.
  if (screen.report) {
    const [reportPkg, reportName] = String(screen.report).split('/');
    const report = forReport(reportPkg, reportName, context);
    if (report) {
      composed.report = screen.report;
      composed.reportEndpoint = report.endpoint;
      composed.columns = report.fields.filter(field => field.display);
      composed.groupable = report.fields.filter(field => field.group).map(field => field.name);
      composed.aggregable = report.fields
        .filter(field => Array.isArray(field.aggregate) && field.aggregate.length > 0)
        .map(field => ({ name: field.name, label: field.label, aggregate: field.aggregate }));
      composed.sortable = report.fields.filter(field => field.sort).map(field => field.name);

      if (!composed.order && report.order) {
        composed.order = report.order;
      }
      composed.dropped.push(...report.dropped);
    }
  }

  return composed;
}

/**
 * The query definition behind a report endpoint, composed.
 *
 * @param {string} pkg
 * @param {string} name
 * @param {Object} context
 * @returns {Object|null}
 */
function forReport(pkg, name, context = {}) {
  const screen = screens.getReport(pkg, name);
  if (!screen) {
    return null;
  }

  const [entityPkg, entityName] = String(screen.entity || '').split('/');
  const entity = mainApp.getEntity(entityPkg, entityName);
  if (!entity) {
    return null;
  }

  const lang = context.lang || context.vLang || 'en';

  // A query definition marks each field for what it may take part in, and the
  // four are independent: a column can be shown without being filterable.
  const declared = (screen.fields || []).map(field => ({
    ...field,
    labelKey: field.labelKey || field.name
  }));

  const { fields, dropped } = composeFields(declared, entity, lang, true);

  // The flags the query definition carries and the entity does not.
  const flags = new Map((screen.fields || []).map(f => [String(f.name).toLowerCase(), f]));
  for (const field of fields) {
    const source = flags.get(String(field.name).toLowerCase());
    if (!source) {
      continue;
    }
    for (const flag of ['filter', 'display', 'group', 'sort']) {
      if (source[flag]) {
        field[flag] = true;
      }
    }
    if (Array.isArray(source.aggregate) && source.aggregate.length > 0) {
      field.aggregate = source.aggregate;
    }
    if (source.expression) {
      field.expression = source.expression;
    }
  }

  return {
    version: screen.version || '1.0',
    kind: 'query',
    screen: screen.screen || `${pkg}/${name}`,
    entity: screen.entity,
    endpoint: `/UC/${pkg}/${name}`,
    order: screen.order,
    condition: screen.condition,
    periodCondition: screen.periodCondition,
    fields,
    dropped
  };
}

/**
 * Marks the programs in a permitted menu tree that have a screen described.
 *
 * The client has to decide which menu entries become links, and until now it
 * decided from a list of nineteen paths compiled into its own bundle. That list
 * cannot know about a screen file, so a program described here was a menu entry
 * greyed out for no reason a user could see -- and keeping such a list in step
 * with a directory of metadata is exactly the registry edit M5 exists to
 * forbid.
 *
 * So the answer comes from where the registry actually is. Each program gains
 * `described`, and the client links a program when it holds a component for it
 * or when this says one can be drawn.
 *
 * It is not an authorisation decision and does not touch the tree's membership:
 * every node here is already one the caller was granted, and a program with no
 * screen stays in the tree marked `described: false` rather than being removed.
 * Nothing is added either -- a screen file for a program the caller does not
 * hold is not in this tree to be marked.
 *
 * Mutates in place; the tree is freshly built per request, not shared metadata.
 *
 * @param {Array|Object} tree Menus, or any node of one
 * @returns {Array|Object} The same tree
 */
function describeMenu(tree) {
  if (!tree) {
    return tree;
  }

  const nodes = Array.isArray(tree) ? tree : [tree];

  for (const node of nodes) {
    if (!node || typeof node !== 'object') {
      continue;
    }

    // A program is a node carrying a path. Menus and types carry a url too, so
    // the id is what distinguishes them -- a program's is its MPrg_Id and both
    // `url` and `apiUrl` hold its path, of which some tenants populate only one.
    const path = node.apiUrl || node.url;
    if (node.id !== undefined && path && !Array.isArray(node.programs) && !Array.isArray(node.progTypes)) {
      node.described = screens.getProgram(path) !== null;
    }

    for (const key of ['menus', 'progTypes', 'programs', 'aList', 'children']) {
      if (Array.isArray(node[key])) {
        describeMenu(node[key]);
      }
    }
  }

  return tree;
}

module.exports = { forProgram, forReport, composeFields, inputFor, lookupPath, describeMenu };
