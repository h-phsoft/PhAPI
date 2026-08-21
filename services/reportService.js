const mainApp = require('../config/mainApp');
const repository = require('../repository/unifiedRepository');
const Report = require('../models/report');
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
    const entity = mainApp.getEntity(pkgName, reportName);
    if (!entity) {
      throw new Error(`Report metadata not found for ${pkgName}/${reportName}`);
    }
    return { entity, report: this.toReport(entity, reportName) };
  }

  /**
   * Projects entity metadata onto the Report shape the client expects.
   * @returns {Report}
   */
  toReport(entity, reportName) {
    const fields = (entity.fields || []).map((field) => ({
      name: field.Field,
      label: field.Name,
      type: field.Type || 'String'
    }));

    return new Report({
      name: entity.tableName || reportName,
      title: entity.synonym || entity.tableName || reportName,
      description: entity.module || entity.package || '',
      fields,
      // Any queryable field can be supplied as a filter.
      parameters: (entity.fields || [])
        .filter((field) => field.query !== false)
        .map((field) => ({
          name: field.Field,
          label: field.Name,
          type: field.Type || 'String',
          required: false,
          defaultValue: field.Default !== '' ? field.Default : null
        })),
      chartConfig: null,
      dashboard: false
    });
  }

  /**
   * Runs the report through the shared repository path.
   * @returns {Promise<Array>}
   */
  async fetchRows(entity, params, context, defaultRows = DEFAULT_REPORT_ROWS) {
    const options = {
      filters: params.filters || params.vWhere || {},
      page: coercePage(params.page),
      pageSize: coercePageSize(params.pageSize || params.size, defaultRows),
      sortBy: params.sortBy,
      sortOrder: params.sortOrder
    };
    return repository.find(entity, options, context);
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

    return {
      name: report.getName(),
      title: report.getTitle(),
      total: rows.length,
      summary: {
        count: rows.length,
        fields: Object.keys(rows[0] || {}).length
      },
      aggregations: this.calculateAggregations(rows)
    };
  }

  /**
   * The report's rows, paginated.
   */
  async query(pkgName, reportName, vParams, context) {
    const params = parseParams(vParams);
    const { entity, report } = this.resolve(pkgName, reportName);
    const rows = await this.fetchRows(entity, params, context);

    return {
      name: report.getName(),
      title: report.getTitle(),
      data: rows,
      count: rows.length,
      page: coercePage(params.page),
      size: coercePageSize(params.pageSize || params.size, DEFAULT_REPORT_ROWS)
    };
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
   * Writes directly to the response rather than buffering, so a large report
   * does not sit in memory, and resolves once the document is flushed.
   *
   * @param {string} pkgName
   * @param {string} reportName
   * @param {*} vParams
   * @param {Object} context
   * @param {WritableStream} stream Destination, normally the HTTP response
   * @returns {Promise<{rowCount: number, title: string}>}
   */
  async renderPDF(pkgName, reportName, vParams, context, stream) {
    const PDFDocument = require('pdfkit');

    const params = parseParams(vParams);
    const { entity, report } = this.resolve(pkgName, reportName);
    const rows = await this.fetchRows(entity, params, context);

    const title = report.getTitle();
    const columns = Object.keys(rows[0] || {});

    const doc = new PDFDocument({ size: 'A4', layout: 'landscape', margin: 36 });
    const finished = new Promise((resolve, reject) => {
      stream.on('finish', resolve);
      doc.on('error', reject);
    });

    doc.pipe(stream);

    doc.fontSize(16).text(title, { align: 'left' });
    doc.fontSize(9).fillColor('#666')
      .text(`${rows.length} row(s) — generated ${new Date().toISOString()}`);
    doc.moveDown(0.8);
    doc.fillColor('#000');

    if (columns.length === 0) {
      doc.fontSize(11).text('No data for the selected parameters.');
      doc.end();
      await finished;
      return { rowCount: 0, title };
    }

    const usableWidth = doc.page.width - doc.page.margins.left - doc.page.margins.right;
    const columnWidth = usableWidth / columns.length;
    const rowHeight = 16;
    const bottomLimit = doc.page.height - doc.page.margins.bottom - rowHeight;

    const drawRow = (values, y, bold) => {
      doc.fontSize(8).font(bold ? 'Helvetica-Bold' : 'Helvetica');
      values.forEach((value, index) => {
        const text = value === null || value === undefined ? '' : String(value);
        doc.text(text, doc.page.margins.left + index * columnWidth, y, {
          width: columnWidth - 4,
          height: rowHeight,
          ellipsis: true,
          lineBreak: false
        });
      });
    };

    let y = doc.y;
    drawRow(columns, y, true);
    y += rowHeight;

    for (const row of rows) {
      if (y > bottomLimit) {
        doc.addPage();
        y = doc.page.margins.top;
        drawRow(columns, y, true);
        y += rowHeight;
      }
      drawRow(columns.map((column) => row[column]), y, false);
      y += rowHeight;
    }

    doc.end();
    await finished;

    return { rowCount: rows.length, title };
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
