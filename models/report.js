class Report {
  constructor(config = {}) {
    this.name = config.name || '';
    this.title = config.title || '';
    this.description = config.description || '';
    this.query = config.query || '';
    this.fields = config.fields || [];
    this.parameters = config.parameters || [];
    this.chartConfig = config.chartConfig || null;
    this.dashboard = config.dashboard || false;
    this.permissions = config.permissions || [];
  }

  getName() {
    return this.name;
  }

  getTitle() {
    return this.title;
  }

  getDescription() {
    return this.description;
  }

  getQuery() {
    return this.query;
  }

  getFields() {
    return this.fields;
  }

  getParameters() {
    return this.parameters;
  }

  getChartConfig() {
    return this.chartConfig;
  }

  isDashboard() {
    return this.dashboard;
  }

  getPermissions() {
    return this.permissions;
  }

  addField(field) {
    this.fields.push(field);
    return this;
  }

  addParameter(param) {
    this.parameters.push(param);
    return this;
  }
}

module.exports = Report;