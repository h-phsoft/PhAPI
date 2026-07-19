const mysql = require('mysql2/promise');
require('dotenv').config();

class Database {
  constructor() {
    this.pool = null;
  }

  async getConnection(vCopy, vLang, userId, periodId) {
    try {
      if (!this.pool) {
        this.pool = mysql.createPool({
          host: process.env.DB_HOST || 'localhost',
          user: process.env.DB_USER || 'root',
          password: process.env.DB_PASSWORD || '',
          database: process.env.DB_NAME || 'mydb',
          waitForConnections: true,
          connectionLimit: 10,
          queueLimit: 0,
          // You can customize connection based on parameters
          // For example, use different databases based on vCopy
        });
      }

      const connection = await this.pool.getConnection();
      return connection;
    } catch (error) {
      throw new Error(`Database connection failed: ${error.message}`);
    }
  }

  async closeConnection() {
    if (this.pool) {
      await this.pool.end();
    }
  }
}

module.exports = new Database();