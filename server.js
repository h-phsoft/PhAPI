/* global process, __dirname */

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const bodyParser = require('body-parser');
const path = require('path');
require('dotenv').config();

const mainApp = require('./config/mainApp');
const routes = require('./routes');
const errorHandler = require('./middleware/errorHandling');

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());

app.set('trust proxy', 1);

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
});
app.use(limiter);

// CORS
app.use(cors());

// Body parser
app.use(bodyParser.json({limit: '1mb'}));
app.use(bodyParser.urlencoded({extended: true, limit: '1mb'}));
app.use(bodyParser.text({type: ['text/*', 'text/plain', 'text/html', 'application/text'], limit: '1mb'}));


// Load metadata singleton at startup directly from resources/modules
const modulesDir = path.join(__dirname, 'resources', 'modules');
mainApp.loadMetadata(modulesDir);

// Serve static HTML documentation portal at /docs
app.use('/docs', express.static(path.join(__dirname, 'docs')));

// Serve static landing page at root
app.use(express.static(path.join(__dirname, 'public')));
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Public Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    packages: mainApp.getAllPackages()
  });
});

// Mount API routes
app.use('/', routes);

const ResultManager = require('./utils/responseManager');

// 404 handler
app.use((req, res) => {
  res.status(404).json(ResultManager.invalid('Route not found'));
});


// Global error handling middleware
app.use(errorHandler);

const {getTenantDbConfig} = require('./config/db.config');
const connectionPoolManager = require('./core/connectionPool');

async function checkDatabaseConnectionOnStartup() {
  try {
    const config = await getTenantDbConfig('default');
    console.log(`[Database] Checking connection to default database (${config.dbType} on ${config.host}:${config.port || 'default'})...`);

    const pool = await connectionPoolManager.getPool('default');
    const conn = await pool.getConnection();

    if (config.dbType === 'oracle') {
      await conn.query('SELECT 1 FROM DUAL');
    } else {
      await conn.query('SELECT 1');
    }
    await conn.release();
    console.log(`[Database] ✓ Connection to default database (${config.dbType}) verified successfully.`);
  } catch (err) {
    console.error(`[Database] ❌ Database startup connection check failed:`, err.message);
  }
}

// Start server
app.listen(PORT, async () => {
  console.log(`[PhsAPI] Server running on http://localhost:${PORT}`);
  console.log(`[PhsAPI] Interactive Docs available at http://localhost:${PORT}/docs/index.html`);
  console.log(`[PhsAPI] Environment: ${process.env.NODE_ENV || 'development'}`);
  await checkDatabaseConnectionOnStartup();
});

module.exports = app;

