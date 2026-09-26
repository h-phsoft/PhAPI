const fs = require('fs');
const path = require('path');

class I18nHelper {
  constructor() {
    this.locales = {};
    this.defaultLanguage = 'en';
    this.localesDir = path.join(__dirname, '../locales');
    this.loadLocales();
  }

  /**
   * Reads every locale file, replacing the ones in use.
   *
   * The new set is built beside the old and swapped in whole. At startup a
   * file that cannot be read stops the process, as it always did -- a server
   * with no labels is not one to start. With `keepOnError`, as a reload asks,
   * the labels in use are kept instead and the failure is reported.
   *
   * @param {{keepOnError?: boolean}} [options]
   * @returns {{languages: number, errors: Array<{file: string, message: string}>, kept: boolean}}
   */
  loadLocales(options = {}) {
    const loaded = {};
    const errors = [];
    if (fs.existsSync(this.localesDir)) {
      const files = fs.readdirSync(this.localesDir);
      for (const file of files) {
        if (file.endsWith('.json')) {
          const lang = path.basename(file, '.json');
          const full = path.join(this.localesDir, file);
          try {
            loaded[lang] = JSON.parse(fs.readFileSync(full, 'utf8'));
          } catch (err) {
            if (!options.keepOnError) {
              throw err;
            }
            errors.push({ file: full, message: err.message });
          }
        }
      }
    }
    if (errors.length > 0) {
      return { languages: Object.keys(this.locales).length, errors, kept: true };
    }
    this.locales = loaded;
    return { languages: Object.keys(loaded).length, errors, kept: false };
  }

  /**
   * Translates message key into localized message string.
   * @param {string} key Message key
   * @param {string} lang Language code ('en', 'ar')
   * @param {Object} params Key-value params for string replacement
   * @returns {string}
   */
  getMessage(key, lang = 'en', params = {}) {
    const localeMap = this.locales[lang] || this.locales[this.defaultLanguage] || {};
    let msg = localeMap[key] || key;

    for (const [k, v] of Object.entries(params)) {
      msg = msg.replace(new RegExp(`\\{${k}\\}`, 'g'), v);
    }

    return msg;
  }

  /**
   * Translates a label stored in the database.
   *
   * Menu, type and program names are held in a single Name column with no
   * second-language equivalent, so the stored English text doubles as the
   * translation key. Anything without an entry falls back to that text, which
   * means an untranslated tenant keeps working and reads exactly as it did
   * before.
   *
   * Lookups are case-insensitive and ignore surrounding whitespace, because the
   * seed data pads names for column alignment. Two sections are searched:
   * `labels`, which is the Java bundle's hand-written vocabulary, then
   * `fields`, which is one readable default per column name.
   *
   * @param {string} label Text as stored in the database
   * @param {string} lang Language code, e.g. 'en' or 'ar'
   * @returns {string} The translation, or the original label
   */
  translateLabel(label, lang = 'en') {
    if (label === undefined || label === null) {
      return label;
    }

    const text = String(label).trim();
    if (text === '') {
      return text;
    }

    const localeMap = this.locales[lang] || this.locales[this.defaultLanguage] || {};

    // Two sections, in this order.
    //
    // `labels` is the vocabulary imported from the Java application's own
    // .properties bundle -- translated by hand, and what a menu name or a
    // screen's label key resolves through.
    //
    // `fields` is one entry per column name, seeded from the column itself:
    // `borrowerFname` becomes "Borrower Fname". A readable placeholder, so a
    // screen shows "Clinic Name" rather than `clinicName` while nobody has
    // written anything better. Only these 2386 keys were ever seeded and
    // nothing read them, because this method looked in `labels` alone -- which
    // is why a converted query screen's columns came back as their own names.
    //
    // `labels` first so a real translation always beats a generated one.
    const sections = [localeMap.labels, localeMap.fields].filter(
      (section) => section && typeof section === 'object'
    );

    if (sections.length === 0) {
      return text;
    }

    for (const section of sections) {
      if (section[text] !== undefined) {
        return section[text];
      }
    }

    // Built once per locale so repeated lookups do not rescan the tables.
    if (!this._labelIndex) {
      this._labelIndex = {};
    }
    if (!this._labelIndex[lang]) {
      const index = {};
      // Reverse order, so an earlier section overwrites a later one and the
      // precedence above still holds for a case-insensitive hit.
      for (const section of [...sections].reverse()) {
        for (const [key, value] of Object.entries(section)) {
          index[String(key).trim().toLowerCase()] = value;
        }
      }
      this._labelIndex[lang] = index;
    }

    const hit = this._labelIndex[lang][text.toLowerCase()];
    return hit === undefined ? text : hit;
  }
}

module.exports = new I18nHelper();
