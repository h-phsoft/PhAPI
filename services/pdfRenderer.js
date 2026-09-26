/**
 * Where an export's PDF is laid out: a worker thread, or the request's own.
 *
 * Laying out a table is pure CPU -- about 55 ms for every 500 rows of twenty
 * columns -- and on the request's thread that is 55 ms in which no other
 * request, of any user, is answered; a 50000-row export held the server that
 * way, a batch at a time, for ten seconds. In a worker the request's thread
 * only reads rows and passes bytes, and stays free between batches (Step 5.4).
 *
 * Both kinds answer to the same three calls, so the export does not know
 * which it has:
 *
 *   addRows(rows)   resolves once there is room for the next batch
 *   finish(end)     resolves once the whole document has reached `stream`
 *   abort()         stops, for a reader that went away
 *   failed          a promise that rejects if drawing fails
 *
 * At most EXPORT_WORKERS workers run at once; an export past that waits for
 * one to finish rather than starting another thread. EXPORT_WORKERS=0 lays
 * every export out on the request's thread, as before.
 */

const path = require('path');
const { Worker } = require('worker_threads');
const env = require('../config/env');
const { PdfTable } = require('./pdfTable');

/** The worker's script; a test may point it at one that fails. */
const settings = { workerFile: path.join(__dirname, 'pdfWorker.js') };

/** A count of workers in use, and the exports waiting for one. */
const slots = { busy: 0, waiting: [] };

function acquire() {
  if (slots.busy < env.exportWorkers) {
    slots.busy++;
    return Promise.resolve();
  }
  return new Promise((resolve) => slots.waiting.push(resolve));
}

function release() {
  const next = slots.waiting.shift();
  if (next) {
    // The slot passes straight to the next export.
    next();
  } else {
    slots.busy--;
  }
}

/** Resolves when `stream` has taken everything or been closed. */
function whenDone(stream) {
  return new Promise((resolve) => {
    stream.on('finish', resolve);
    stream.on('close', resolve);
  });
}

/** Lays the document out on this thread. */
function inThread(title, generatedAt, stream) {
  const table = new PdfTable(title, generatedAt);
  const failed = new Promise((resolve, reject) => table.doc.on('error', reject));
  failed.catch(() => {});
  const done = whenDone(stream);
  table.doc.pipe(stream);

  return {
    kind: 'thread',
    failed,
    async addRows(rows) {
      table.addRows(rows);
    },
    async finish(end) {
      table.finish(end);
      await Promise.race([done, failed]);
      return table.rowCount;
    },
    abort() {
      table.doc.unpipe(stream);
    }
  };
}

/** Lays the document out on a worker thread; resolves once it is running. */
async function inWorker(title, generatedAt, stream) {
  await acquire();

  let worker;
  try {
    worker = new Worker(settings.workerFile);
  } catch (err) {
    release();
    throw err;
  }

  let released = false;
  const free = () => {
    if (!released) {
      released = true;
      release();
    }
  };

  // Batches posted and not yet drawn. One may be drawn while the next is read
  // from the database; a third waits, so no more than two are ever held.
  let undrawn = 0;
  let waiter = null;
  let failure = null;
  let rowCount = 0;
  const done = whenDone(stream);
  // Settles when the worker ends, cleanly or not; an error along the way fails
  // whatever is waiting on it.
  const ended = new Promise((resolve, reject) => {
    worker.on('message', (message) => {
      if (message.type === 'chunk') {
        const { data } = message;
        stream.write(Buffer.from(data.buffer, data.byteOffset, data.byteLength));
      } else if (message.type === 'drawn') {
        undrawn--;
        if (waiter) {
          const settle = waiter;
          waiter = null;
          settle.resolve();
        }
      } else if (message.type === 'done') {
        rowCount = message.rowCount;
        stream.end();
        worker.terminate();
      }
    });
    worker.on('error', (err) => {
      failure = err;
      if (waiter) {
        waiter.reject(err);
      }
      reject(err);
    });
    worker.on('exit', () => {
      free();
      resolve();
    });
  });
  // Nothing may be left to reject unwatched: finish() and addRows() report it.
  ended.catch(() => {});
  // Rejects if the worker fails, and never settles otherwise: an export
  // waiting on a slow reader waits on this too, or it would wait forever on a
  // reader that no more bytes are coming for.
  const failed = new Promise((resolve, reject) => worker.on('error', reject));
  failed.catch(() => {});

  worker.postMessage({ type: 'start', title, generatedAt });

  return {
    kind: 'worker',
    failed,
    addRows(rows) {
      if (failure) {
        return Promise.reject(failure);
      }
      undrawn++;
      worker.postMessage({ type: 'rows', rows });
      if (undrawn < 2) {
        return Promise.resolve();
      }
      return new Promise((resolve, reject) => {
        waiter = { resolve, reject };
      });
    },
    async finish(end) {
      if (failure) {
        throw failure;
      }
      worker.postMessage({ type: 'end', truncated: end.truncated, limit: end.limit });
      await ended;
      await done;
      return rowCount;
    },
    abort() {
      worker.terminate();
    }
  };
}

/**
 * A renderer for one export, on a worker unless EXPORT_WORKERS is 0.
 *
 * @param {string} title
 * @param {WritableStream} stream where the document goes
 * @returns {Promise<{kind: string, addRows: Function, finish: Function, abort: Function}>}
 */
async function open(title, stream) {
  const generatedAt = new Date().toISOString();
  if (env.exportWorkers > 0) {
    return inWorker(title, generatedAt, stream);
  }
  return inThread(title, generatedAt, stream);
}

module.exports = { open, slots, settings };
