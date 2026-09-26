/**
 * The worker thread an export's PDF is laid out on (Step 5.4).
 *
 * The request's thread reads the rows -- the database pool is its -- and posts
 * them here a batch at a time; this thread draws them and posts the document's
 * bytes back as pdfkit makes them. Messages in:
 *
 *   { type: 'start', title, generatedAt }
 *   { type: 'rows', rows }        answered with { type: 'drawn' } once drawn
 *   { type: 'end', truncated, limit }
 *
 * Messages out: { type: 'chunk', data }, { type: 'drawn' }, and
 * { type: 'done', rowCount } after the last chunk. An error ends the thread,
 * which the request's thread sees as the worker's 'error' event.
 */

const { parentPort } = require('worker_threads');
const { PdfTable } = require('./pdfTable');

let table = null;

// Every chunk made while drawing a batch is posted before 'drawn' is: a turn
// of the event loop lets pdfkit's stream hand them over first. Messages on a
// port arrive in the order they were sent.
const flushed = () => new Promise((resolve) => setImmediate(resolve));

parentPort.on('message', async (message) => {
  if (message.type === 'start') {
    table = new PdfTable(message.title, message.generatedAt);
    table.doc.on('data', (chunk) => {
      // A copy the port can take over, rather than one it must clone.
      const data = new Uint8Array(chunk);
      parentPort.postMessage({ type: 'chunk', data }, [data.buffer]);
    });
    table.doc.on('end', () => {
      parentPort.postMessage({ type: 'done', rowCount: table.rowCount });
    });
  } else if (message.type === 'rows') {
    table.addRows(message.rows);
    await flushed();
    parentPort.postMessage({ type: 'drawn' });
  } else if (message.type === 'end') {
    table.finish(message);
  }
});
