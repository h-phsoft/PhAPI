class Entity {
  constructor(tableName, fields = {}) {
    this.tableName = tableName;
    this.fields = fields;
    this.primaryKey = 'id';
    this.timestamps = {
      createdAt: 'created_at',
      updatedAt: 'updated_at'
    };
  }

  getTableName() {
    return this.tableName;
  }

  getFields() {
    return this.fields;
  }

  getPrimaryKey() {
    return this.primaryKey;
  }

  getFieldNames() {
    return Object.keys(this.fields);
  }

  getFieldType(fieldName) {
    return this.fields[fieldName] || null;
  }

  getTimestampFields() {
    return this.timestamps;
  }
}

module.exports = Entity;