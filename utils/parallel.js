/**
 * Runs independent reads side by side, a bounded number at a time (Step 5.3).
 *
 * A request that reads several things none of which needs another -- a
 * record's child grids, a package's code tables -- waited for each before
 * asking for the next. Each read takes its own connection from the tenant's
 * pool, so they can run together; the bound keeps one request from taking the
 * whole pool while other users wait on it.
 */

/**
 * Maps `items` through `fn`, at most `limit` calls in flight at once.
 *
 * Results keep the order of `items`, whatever order the calls finish in. The
 * first call to fail rejects the whole; calls already running finish on their
 * own, and none is started after it.
 *
 * @param {Array} items
 * @param {number} limit at least 1
 * @param {(item: *, index: number) => Promise<*>} fn
 * @returns {Promise<Array>}
 */
async function mapLimit(items, limit, fn) {
  const list = Array.from(items);
  const results = new Array(list.length);
  const width = Math.max(1, Math.min(Number(limit) || 1, list.length));
  let next = 0;
  let failed = false;

  const lane = async () => {
    while (!failed && next < list.length) {
      const index = next++;
      try {
        results[index] = await fn(list[index], index);
      } catch (err) {
        failed = true;
        throw err;
      }
    }
  };

  await Promise.all(Array.from({ length: width }, lane));
  return results;
}

module.exports = { mapLimit };
