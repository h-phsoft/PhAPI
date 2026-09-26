/**
 * Lays a report out as a landscape PDF table, a batch of rows at a time.
 *
 * Only drawing: it knows nothing of the query, the request or the thread it
 * runs on. The export runs it in a worker thread (Step 5.4) so that laying out
 * tens of thousands of rows does not hold up every other request, and in the
 * request's own thread where a worker cannot be had.
 */

const PDFDocument = require('pdfkit');

const ROW_HEIGHT = 16;

class PdfTable {
  /**
   * @param {string} title
   * @param {string} generatedAt shown under the title
   */
  constructor(title, generatedAt) {
    this.doc = new PDFDocument({ size: 'A4', layout: 'landscape', margin: 36 });
    this.columns = null;
    this.columnWidth = 0;
    this.rowCount = 0;

    const doc = this.doc;
    doc.fontSize(16).text(title, { align: 'left' });
    doc.fontSize(9).fillColor('#666').text(`Generated ${generatedAt}`);
    doc.moveDown(0.8);
    doc.fillColor('#000');
    this.bottomLimit = doc.page.height - doc.page.margins.bottom - ROW_HEIGHT;
    this.y = doc.y;
  }

  drawRow(values, top, bold) {
    const doc = this.doc;
    doc.fontSize(8).font(bold ? 'Helvetica-Bold' : 'Helvetica');
    values.forEach((value, index) => {
      const text = value === null || value === undefined ? '' : String(value);
      doc.text(text, doc.page.margins.left + index * this.columnWidth, top, {
        width: this.columnWidth - 4,
        height: ROW_HEIGHT,
        ellipsis: true,
        lineBreak: false
      });
    });
  }

  /** Draws the next rows, starting a page, with its header, when one is full. */
  addRows(rows) {
    const doc = this.doc;
    for (const row of rows) {
      if (!this.columns) {
        // A grouped query projects its own columns, so they are read from
        // the first row rather than the entity.
        this.columns = Object.keys(row);
        const usableWidth = doc.page.width - doc.page.margins.left - doc.page.margins.right;
        this.columnWidth = usableWidth / Math.max(this.columns.length, 1);
        this.drawRow(this.columns, this.y, true);
        this.y += ROW_HEIGHT;
      }
      if (this.y > this.bottomLimit) {
        doc.addPage();
        this.y = doc.page.margins.top;
        this.drawRow(this.columns, this.y, true);
        this.y += ROW_HEIGHT;
      }
      this.drawRow(this.columns.map((column) => row[column]), this.y, false);
      this.y += ROW_HEIGHT;
      this.rowCount++;
    }
  }

  /**
   * Prints the row count -- only known now -- and closes the document.
   *
   * @param {{truncated: boolean, limit: number}} end
   */
  finish({ truncated, limit }) {
    const doc = this.doc;
    doc.font('Helvetica').fontSize(9).fillColor('#666');
    if (this.rowCount === 0) {
      doc.fontSize(11).fillColor('#000').text('No data for the selected parameters.', doc.page.margins.left, this.y);
    } else {
      if (this.y > this.bottomLimit) {
        doc.addPage();
        this.y = doc.page.margins.top;
      }
      const note = truncated
        ? `${this.rowCount} row(s) -- stopped at the export limit of ${limit}; narrow the query for the rest.`
        : `${this.rowCount} row(s)`;
      doc.text(note, doc.page.margins.left, this.y + 4);
    }
    doc.end();
  }
}

module.exports = { PdfTable };
