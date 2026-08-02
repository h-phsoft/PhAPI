const OracleSqlBuilder = require('./sqlBuilder.oracle');
const MysqlSqlBuilder = require('./sqlBuilder.mysql');
const PgSqlBuilder = require('./sqlBuilder.pg');

class SqlBuilder {
  constructor() {
    this.builders = {
      oracle: new OracleSqlBuilder(),
      mysql: new MysqlSqlBuilder(),
      postgres: new PgSqlBuilder(),
      postgresql: new PgSqlBuilder(),
      pg: new PgSqlBuilder()
    };
  }

  getBuilder(dbType = 'mysql') {
    const builder = this.builders[dbType.toLowerCase()];
    if (!builder) {
      throw new Error(`[SqlBuilder] Unsupported database type: ${dbType}`);
    }
    return builder;
  }

  buildSelect(dbType, entity, options) {
    return this.getBuilder(dbType).buildSelect(entity, options);
  }

  buildInsert(dbType, entity, data) {
    return this.getBuilder(dbType).buildInsert(entity, data);
  }

  buildUpdate(dbType, entity, id, data) {
    return this.getBuilder(dbType).buildUpdate(entity, id, data);
  }

  buildDelete(dbType, entity, id) {
    return this.getBuilder(dbType).buildDelete(entity, id);
  }

  buildMaxAutonumber(dbType, autonumberRule, context) {
    return this.getBuilder(dbType).buildMaxAutonumber(autonumberRule, context);
  }
}

module.exports = new SqlBuilder();
