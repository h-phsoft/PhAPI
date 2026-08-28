const fs = require('fs');
const path = require('path');

class I18nHelper {
  constructor() {
    this.locales = {};
    this.defaultLanguage = 'en';
    this.loadLocales();
  }

  loadLocales() {
    const localesDir = path.join(__dirname, '../locales');
    if (fs.existsSync(localesDir)) {
      const files = fs.readdirSync(localesDir);
      for (const file of files) {
        if (file.endsWith('.json')) {
          const lang = path.basename(file, '.json');
          const content = fs.readFileSync(path.join(localesDir, file), 'utf8');
          this.locales[lang] = JSON.parse(content);
        }
      }
    }
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
   * seed data pads names for column alignment.
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
    const labels = localeMap.labels;
    if (!labels || typeof labels !== 'object') {
      return text;
    }

    if (labels[text] !== undefined) {
      return labels[text];
    }

    // Build a lower-cased index once per locale so repeated menu lookups do not
    // rescan the table on every entry.
    if (!this._labelIndex) {
      this._labelIndex = {};
    }
    if (!this._labelIndex[lang]) {
      const index = {};
      for (const [key, value] of Object.entries(labels)) {
        index[String(key).trim().toLowerCase()] = value;
      }
      this._labelIndex[lang] = index;
    }

    const hit = this._labelIndex[lang][text.toLowerCase()];
    return hit === undefined ? text : hit;
  }
}

module.exports = new I18nHelper();
