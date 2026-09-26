const mainApp = require('../metadata/registry');
const screens = require('../metadata/screens');
const repository = require('../repository/unifiedRepository');
const Report = require('../models/report');
const env = require('../config/env');
const { coercePage, coercePageSize } = require('../utils/pagination');

/**
 * Reporting and dashboard endpoints.
 *
 * Reports carry no stored SQL of their own -- they are registered as ordinary
 * entities alongside every other table, so the rows come from the same
 * metadata-driven repository path the CRUD endpoints use. That keeps tenant
 * scoping, dialect handling and bind parameters identical for both.
 */

// Reused for pie/doughnut slices so a chart's colours stay stable across calls.
const CHART_PALETTE = [
  '#EF4444', '#3B82F6', '#10B981', '#F59E0B',
  '#8B5CF6', '#EC4899', '#14B8A6', '#F97316'
];

const LINE_COLOR = '#3B82F6';
const LINE_FILL = 'rgba(59, 130, 246, 0.1)';

// Charts stay readable well below the general page ceiling.
const DEFAULT_REPORT_ROWS = 500;
const DEFAULT_CHART_ROWS = 100;

/**
 * Accepts the loosely-typed vParams bodies the legacy client sends: a JSON
 * string, an object, or something else entirely.
 * @param {*} vParams
 * @returns {Object}
 */
function parseParams(vParams) {
  if (!vParams) {
    return {};
  }
  if (typeof vParams === 'object') {
    return vParams;
  }
  try {
    const parsed = JSON.parse(vParams);
    return parsed && typeof parsed === 'object' ? parsed : { data: parsed };
  } catch (err) {
    return { data: vParams };
  }
}

/**
 * Waits until `stream` can take more, or has gone away.
 *
 * pdfkit writes whatever it is given and queues what the destination has not
 * taken yet, so a slow reader would let a streamed document pile up in memory
 * after all. Pausing between batches until the destination drains keeps that
 * queue to about one batch.
 *
 * @param {WritableStream} stream
 * @returns {Promise<boolean>} False when the destination closed instead
 */
function roomIn(stream) {
  if (stream.destroyed || stream.writableEnded) {
    return Promise.resolve(false);
  }
  if (!stream.writableNeedDrain) {
    return Promise.resolve(true);
  }
  return new Promise((resolve) => {
    const done = (open) => {
      stream.off('drain', onDrain);
      stream.off('close', onClose);
      resolve(open);
    };
    const onDrain = () => done(true);
    const onClose = () => done(false);
    stream.on('drain', onDrain);
    stream.on('close', onClose);
  });
}

/** @returns {boolean} True when the value can take part in numeric aggregation. */
function isNumeric(value) {
  return value !== null && value !== undefined && value !== '' && !Number.isNaN(parseFloat(value));
}

class ReportService {
  /**
   * @param {string} pkgName
   * @param {string} reportName
   * @returns {{entity: Object, report: Report}}
   * @throws {Error} When no metadata is registered for the report
   */
  resolve(pkgName, reportName) {
    // A report name is not always an entity name. `/UC/Acc/Budget/Query` names
    // the query definition `Acc/Budget`, whose entity is `Acc/BudgetView`, and
    // looking only in the entity registry made 60 of the 548 definitions
    // unreachable -- every one of them answering "Report metadata not found"
    // for a report that is right there on disk.
    //
    // The definition is asked first because it is the specific answer, and the
    // entity registry still answers for the 488 whose name is a table.
    const definition = screens.getReport(pkgName, reportName);

    let entity = null;
    if (definition && definition.entity) {
      const [pkg, name] = String(definition.entity).split('/');
      entity = mainApp.getEntity(pkg, name);
    }
    if (!entity) {
      entity = mainApp.getEntity(pkgName, reportName);
    }

    if (!entity) {
      throw new Error(`Report metadata not found for ${pkgName}/${reportName}`);
    }

    return { entity, definition, report: this.toReport(entity, reportName, definition) };
  }

  /**
   * Projects a report onto the shape the client expects.
   *
   * With a query definition, its field list decides: the columns it marks for
   * display are the report's columns, and the ones it marks filterable are its
   * parameters. Without one, every column of the entity is both -- which is
   * what this always did, and is why the definitions mattered: an entity
   * flattened this way offers a hundred filters, none of them with an operator,
   * where the screen offered twelve.
   *
   * @param {Object} entity Entity metadata
   * @param {string} reportName
   * @param {Object} [definition] The query definition, when one exists
   * @returns {Report}
   */
  toReport(entity, reportName, definition = null) {
    const declared = definition && Array.isArray(definition.fields) ? definition.fields : null;
    const byName = new Map((entity.fields || []).map(f => [String(f.Field).toLowerCase(), f]));

    /** A declared field, paired with the column it names. */
    const paired = (declared || [])
      .map(field => ({ field, meta: byName.get(String(field.name).toLowerCase()) }))
      .filter(pair => pair.meta);

    const asColumn = ({ field, meta }) => ({
      name: meta.Field,
      label: meta.Name,
      type: meta.Type || 'String'
    });

    const fields = declared
      ? paired.filter(pair => pair.field.display !== false).map(asColumn)
      : (entity.fields || []).map(field => ({
        name: field.Field,
        label: field.Name,
        type: field.Type || 'String'
      }));

    const parameters = declared
      ? paired.filter(pair => pair.field.filter).map(({ field, meta }) => ({
        name: meta.Field,
        label: meta.Name,
        type: meta.Type || 'String',
        required: false,
        defaultValue: meta.Default !== '' ? meta.Default : null,
        operators: field.operators || []
      }))
      : (entity.fields || [])
        .filter((field) => field.query !== false)
        .map((field) => ({
          name: field.Field,
          label: field.Name,
          type: field.Type || 'String',
          required: false,
          defaultValue: field.Default !== '' ? field.Default : null
        }));

    return new Report({
      name: entity.tableName || reportName,
      title: entity.synonym || entity.tableName || reportName,
      description: entity.module || entity.package || '',
      fields,
      parameters,
      chartConfig: null,
      dashboard: false
    });
  }

  /**
   * What a report asks for, as the query layer's options.
   *
   * This is the whole of what was missing. The method read `params.filters` --
   * a map of equalities -- and nothing else, so a query screen's conditions,
   * grouping, aggregates and ordering were all discarded and every /Query and
   * /Statistics call returned the first five hundred rows of the view whatever
   * the user had asked for. Filters are still read, because the dashboard
   * endpoints send them.
   *
   * Each list is checked for its shape rather than trusted: a client that sends
   * an object where a list belongs should get an unfiltered report, not a
   * crash.
   *
   * @param {Object} params The parsed vParams
   * @param {number} defaultRows Page size when the caller names none
   * @returns {Object} Options for repository.find
   */
  static queryOptions(params, defaultRows = DEFAULT_REPORT_ROWS) {
    const list = (value) => (Array.isArray(value) ? value : []);

    return {
      filters: params.filters || params.vWhere || {},
      conditions: list(params.conditions),
      logic: params.logic || 'AND',
      group: list(params.group),
      aggregate: list(params.aggregate),
      order: list(params.order),
      page: coercePage(params.page),
      pageSize: coercePageSize(params.pageSize || params.size, defaultRows),
      sortBy: params.sortBy,
      sortOrder: params.sortOrder
    };
  }

  /**
   * Runs the report through the shared repository path.
   * @returns {Promise<Array>}
   */
  async fetchRows(entity, params, context, defaultRows = DEFAULT_REPORT_ROWS) {
    return repository.find(entity, ReportService.queryOptions(params, defaultRows), context);
  }

  /**
   * Every row a report selects, a batch at a time, up to `max` (D5).
   *
   * An export wants the whole result, not the page a screen shows, so page and
   * size are not read. One row past the ceiling is asked for, which is how a
   * result that was cut is told apart from one exactly that long.
   *
   * @param {Object} entity
   * @param {Object} params The parsed vParams
   * @param {Object} context
   * @param {number} max The most rows to hand over
   * @param {function({rows: Array<Object>, truncated: boolean}): (boolean|void|Promise<boolean|void>)} onBatch
   *   Called with each batch, and waited for; false stops the read
   * @returns {Promise<void>}
   */
  async streamRows(entity, params, context, max, onBatch) {
    let sent = 0;
    await repository.stream(entity, ReportService.queryOptions(params), context, max + 1, async (batch) => {
      const room = max - sent;
      if (batch.length > room) {
        await onBatch({ rows: batch.slice(0, room), truncated: true });
        return false;
      }
      sent += batch.length;
      return onBatch({ rows: batch, truncated: false });
    });
  }

  /**
   * Report metadata: fields, filterable parameters, title.
   */
  async init(pkgName, reportName) {
    const { report } = this.resolve(pkgName, reportName);
    return {
      name: report.getName(),
      title: report.getTitle(),
      description: report.getDescription(),
      fields: report.getFields(),
      parameters: report.getParameters(),
      chartConfig: report.getChartConfig(),
      isDashboard: report.isDashboard()
    };
  }

  /**
   * Row count plus per-column sum/avg/min/max over the numeric columns.
   */
  async statistics(pkgName, reportName, vParams, context) {
    const params = parseParams(vParams);
    const { entity, report } = this.resolve(pkgName, reportName);
    const rows = await this.fetchRows(entity, params, context);

    const answer = {
      name: report.getName(),
      title: report.getTitle(),
      total: rows.length,
      summary: {
        count: rows.length,
        fields: Object.keys(rows[0] || {}).length
      },
      // Computed in JavaScript over the page that came back, which is what this
      // always did. Where the caller named `group` and `aggregate` the database
      // has already done the work and `rows` is the answer -- these are the
      // per-column figures over whatever was returned, not a second opinion on
      // it.
      aggregations: this.calculateAggregations(rows)
    };

    answer.report = {
      name: answer.name,
      title: answer.title,
      rows,
      count: rows.length,
      columns: Object.keys(rows[0] || {})
    };

    return answer;
  }

  /**
   * The report's rows, filtered, grouped and ordered as asked, paginated.
   *
   * Answers under `report` as well as at the top level. The Java client reads
   * `data.report.rows`, so without it every result looked empty to that client
   * however many rows came back; the flat keys stay because PhApp reads those.
   *
   * What the Java client needs beyond this is a pre-rendered table -- its
   * `renderTable` reads `report.header[].cells[]` and `report.Footers[]`, which
   * the Java API built server-side. That is presentation and belongs above this
   * layer; it is not built here and those screens still need it.
   */
  async query(pkgName, reportName, vParams, context) {
    const params = parseParams(vParams);
    const { entity, report } = this.resolve(pkgName, reportName);
    const rows = await this.fetchRows(entity, params, context);

    const answer = {
      name: report.getName(),
      title: report.getTitle(),
      data: rows,
      count: rows.length,
      page: coercePage(params.page),
      size: coercePageSize(params.pageSize || params.size, DEFAULT_REPORT_ROWS)
    };

    answer.report = {
      name: answer.name,
      title: answer.title,
      rows,
      count: rows.length,
      // The columns actually returned, which a grouped query changes: it
      // projects its groups and aggregates, not the entity's field list.
      columns: Object.keys(rows[0] || {})
    };

    return answer;
  }

  /**
   * Chooses the label and value columns for a chart.
   *
   * Explicit labelField/valueField win. Otherwise the first column becomes the
   * label and the first numeric column that is not the label becomes the value,
   * which beats indexing blindly into Object.values(row).
   *
   * @returns {{labelField: string|null, valueField: string|null}}
   */
  resolveChartFields(rows, params) {
    const first = rows[0] || {};
    const keys = Object.keys(first);

    const labelField = params.labelField && keys.includes(params.labelField)
      ? params.labelField
      : (keys[0] || null);

    if (params.valueField && keys.includes(params.valueField)) {
      return { labelField, valueField: params.valueField };
    }

    const valueField = keys.find((key) => key !== labelField && isNumeric(first[key])) || null;
    return { labelField, valueField };
  }

  /**
   * Builds the label/value series shared by both chart types.
   * @returns {{labels: Array, values: Array, valueField: string|null}}
   */
  async buildSeries(pkgName, reportName, params, context) {
    const { entity, report } = this.resolve(pkgName, reportName);
    const rows = await this.fetchRows(entity, params, context, DEFAULT_CHART_ROWS);
    const { labelField, valueField } = this.resolveChartFields(rows, params);

    const labels = rows.map((row) => (labelField ? row[labelField] : null));
    const values = rows.map((row) => {
      if (!valueField) {
        return 0;
      }
      const raw = row[valueField];
      return isNumeric(raw) ? parseFloat(raw) : 0;
    });

    return { labels, values, labelField, valueField, title: report.getTitle() };
  }

  async dashLine(pkgName, reportName, vParams, context) {
    const params = parseParams(vParams);
    const { labels, values, valueField, title } = await this.buildSeries(pkgName, reportName, params, context);

    return {
      type: 'line',
      data: {
        labels,
        datasets: [{
          label: valueField || title,
          data: values,
          borderColor: LINE_COLOR,
          backgroundColor: LINE_FILL,
          fill: true
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { position: 'top' },
          title: { display: true, text: title }
        }
      }
    };
  }

  async dashPie(pkgName, reportName, vParams, context) {
    const params = parseParams(vParams);
    const { labels, values, title } = await this.buildSeries(pkgName, reportName, params, context);

    return {
      type: 'pie',
      data: {
        labels,
        datasets: [{
          data: values,
          backgroundColor: labels.map((_, index) => CHART_PALETTE[index % CHART_PALETTE.length])
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { position: 'top' },
          title: { display: true, text: title }
        }
      }
    };
  }

  /**
   * Renders the report as a landscape PDF table and pipes it to `stream`.
   *
   * The rows stream in from the database and out to the document a batch at a
   * time (D5), so neither end ever holds the report. That is also what lets it
   * be the whole report: it used to print the first page of the query -- 500
   * rows by default, 1000 at most -- whatever the query matched. The page and
   * size a screen sends are not read; EXPORT_MAX_ROWS is the ceiling, and a
   * document that reaches it says so.
   *
   * The row count is only known at the end, so it is printed there.
   *
   * @param {string} pkgName
   * @param {string} reportName
   * @param {*} vParams
   * @param {Object} context
   * @param {WritableStream} stream Destination, normally the HTTP response
   * @returns {Promise<{rowCount: number, title: string, truncated: boolean}>}
   */
  async renderPDF(pkgName, reportName, vParams, context, stream) {
    const PDFDocument = require('pdfkit');

    const params = parseParams(vParams);
    const { entity, report } = this.resolve(pkgName, reportName);
    const title = report.getTitle();

    const rowHeight = 16;
    let doc = null;
    let finished = null;
    let bottomLimit = 0;
    let columns = null;
    let columnWidth = 0;
    let y = 0;
    let rowCount = 0;
    let truncated = false;
    let aborted = false;

    // The document is started by the first batch, not before the query: a
    // query that fails -- a column the view lacks, a bad condition -- then
    // fails before a byte is written, as an error the caller can answer, not
    // as a truncated download.
    const start = () => {
      doc = new PDFDocument({ size: 'A4', layout: 'landscape', margin: 36 });
      // 'close' as well as 'finish': a reader that leaves mid-document never
      // lets it finish, and waiting for that would hold the request forever.
      finished = new Promise((resolve, reject) => {
        stream.on('finish', resolve);
        stream.on('close', resolve);
        doc.on('error', reject);
      });
      doc.pipe(stream);
      doc.fontSize(16).text(title, { align: 'left' });
      doc.fontSize(9).fillColor('#666').text(`Generated ${new Date().toISOString()}`);
      doc.moveDown(0.8);
      doc.fillColor('#000');
      bottomLimit = doc.page.height - doc.page.margins.bottom - rowHeight;
      y = doc.y;
    };

    const drawRow = (values, top, bold) => {
      doc.fontSize(8).font(bold ? 'Helvetica-Bold' : 'Helvetica');
      values.forEach((value, index) => {
        const text = value === null || value === undefined ? '' : String(value);
        doc.text(text, doc.page.margins.left + index * columnWidth, top, {
          width: columnWidth - 4,
          height: rowHeight,
          ellipsis: true,
          lineBreak: false
        });
      });
    };

    await this.streamRows(entity, params, context, env.exportMaxRows, async (batch) => {
      if (!doc) {
        start();
      }
      for (const row of batch.rows) {
        if (!columns) {
          // A grouped query projects its own columns, so they are read from
          // the first row rather than the entity.
          columns = Object.keys(row);
          const usableWidth = doc.page.width - doc.page.margins.left - doc.page.margins.right;
          columnWidth = usableWidth / Math.max(columns.length, 1);
          drawRow(columns, y, true);
          y += rowHeight;
        }
        if (y > bottomLimit) {
          doc.addPage();
          y = doc.page.margins.top;
          drawRow(columns, y, true);
          y += rowHeight;
        }
        drawRow(columns.map((column) => row[column]), y, false);
        y += rowHeight;
        rowCount++;
      }
      truncated = truncated || batch.truncated;

      // A reader that went away stops the query too: returning false closes
      // the cursor and returns the connection.
      if (!(await roomIn(stream))) {
        aborted = true;
        return false;
      }
      return true;
    });

    if (aborted) {
      return { rowCount, title, truncated, aborted: true };
    }
    if (!doc) {
      start();
    }

    doc.font('Helvetica').fontSize(9).fillColor('#666');
    if (rowCount === 0) {
      doc.fontSize(11).fillColor('#000').text('No data for the selected parameters.', doc.page.margins.left, y);
    } else {
      if (y > bottomLimit) {
        doc.addPage();
        y = doc.page.margins.top;
      }
      const note = truncated
        ? `${rowCount} row(s) -- stopped at the export limit of ${env.exportMaxRows}; narrow the query for the rest.`
        : `${rowCount} row(s)`;
      doc.text(note, doc.page.margins.left, y + 4);
    }

    doc.end();
    await finished;

    return { rowCount, title, truncated };
  }

  /**
   * Sum, average, count, min and max for every numeric column present.
   * @param {Array<Object>} rows
   * @returns {Object}
   */
  calculateAggregations(rows) {
    if (!rows || rows.length === 0) {
      return {};
    }

    const aggregations = {};

    for (const key of Object.keys(rows[0])) {
      const numericValues = rows
        .map((row) => row[key])
        .filter(isNumeric)
        .map((value) => parseFloat(value));

      if (numericValues.length === 0) {
        continue;
      }

      const sum = numericValues.reduce((total, value) => total + value, 0);
      aggregations[`${key}_sum`] = sum;
      aggregations[`${key}_avg`] = sum / numericValues.length;
      aggregations[`${key}_count`] = numericValues.length;
      aggregations[`${key}_min`] = Math.min(...numericValues);
      aggregations[`${key}_max`] = Math.max(...numericValues);
    }

    return aggregations;
  }
}

module.exports = new ReportService();
module.exports.parseParams = parseParams;
