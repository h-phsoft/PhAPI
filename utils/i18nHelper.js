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
}

module.exports = new I18nHelper();
