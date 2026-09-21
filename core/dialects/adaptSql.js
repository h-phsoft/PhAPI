/**
 * Rewrites Oracle-style SQL so another engine can run it.
 *
 * Some statements are written against Oracle directly -- the autocomplete
 * templates carry their own SELECT, and a few repository methods name `:bind`
 * and `FROM DUAL` -- so rather than forking each of them per engine, the
 * statement is translated once, here.
 *
 * This lived inside the connection pool, which made connection management the
 * place that knew how each engine spells a placeholder. That is the dialect's
 * business, so it asks the dialect rather than comparing a name.
 *
 * Named binds are collected in first-appearance order. Values come from an
 * object by name, or from an array positionally, which is how the callers pass
 * them.
 *
 * @param {string} sql A statement written with Oracle's named binds
 * @param {Object|Array|undefined} params
 * @param {Object} dialect The dialect to translate into
 * @returns {{text: string, values: Array}}
 */
function adaptSql(sql, params, dialect) {
  const names = [];
  let text = '';
  let i = 0;

  while (i < sql.length) {
    const ch = sql[i];

    // Copy string literals verbatim: a colon inside one is data, not a bind.
    if (ch === "'") {
      const end = sql.indexOf("'", i + 1);
      const stop = end === -1 ? sql.length : end + 1;
      text += sql.slice(i, stop);
      i = stop;
      continue;
    }

    // PostgreSQL's :: cast must survive untouched.
    if (ch === ':' && sql[i + 1] === ':') {
      text += '::';
      i += 2;
      continue;
    }

    const bind = ch === ':' ? /^:([A-Za-z_][A-Za-z0-9_]*)/.exec(sql.slice(i)) : null;
    if (bind) {
      const name = bind[1];
      let index = names.indexOf(name);
      if (index === -1) {
        names.push(name);
        index = names.length - 1;
      }
      // The dialect spells its own placeholder. `bind` is given a throwaway
      // bag because the values are gathered by name below, in one pass, rather
      // than as they are met -- a repeated bind must reuse its first position.
      text += dialect.bind([], index + 1, undefined);
      i += bind[0].length;
      continue;
    }

    text += ch;
    i++;
  }

  // Oracle's dummy table has no equivalent; a bare SELECT is the same thing.
  text = text.replace(/\s+FROM\s+DUAL\b/gi, '');

  let values = [];
  if (names.length > 0) {
    values = names.map((name, index) =>
      Array.isArray(params) ? params[index] : (params ? params[name] : undefined));
  } else if (Array.isArray(params)) {
    values = params;
  }

  return { text, values };
}

module.exports = adaptSql;
