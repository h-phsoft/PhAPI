class Autocomplete {
  constructor(config = {}) {
    this.tableName = config.tableName || '';
    this.searchField = config.searchField || 'name';
    this.displayField = config.displayField || 'name';
    this.valueField = config.valueField || 'id';
    this.conditions = config.conditions || [];
    this.orderBy = config.orderBy || 'name';
    this.limit = config.limit || 10;
  }

  getTableName() {
    return this.tableName;
  }

  getSearchField() {
    return this.searchField;
  }

  getDisplayField() {
    return this.displayField;
  }

  getValueField() {
    return this.valueField;
  }

  getConditions() {
    return this.conditions;
  }

  getOrderBy() {
    return this.orderBy;
  }

  getLimit() {
    return this.limit;
  }

  addCondition(field, operator, value) {
    this.conditions.push({field, operator, value});
    return this;
  }

  setLimit(limit) {
    this.limit = limit;
    return this;
  }
}

module.exports = Autocomplete;