/* global process, __dirname */

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const bodyParser = require('body-parser');
const path = require('path');

// Validate configuration before anything else loads. A missing or unsafe secret
// has to stop the process here, not surface at the first authenticated request.
let env;
try {
  env = require('./config/env');
} catch (err) {
  console.error(err.message);
  process.exit(1);
}

const mainApp = require('./config/mainApp');
const routes = require('./routes');
const errorHandler = require('./middleware/errorHandling');

const app = express();
const PORT = env.port;

// Security middleware
app.use(helmet());

app.set('trust proxy', 1);

// Rate limiting. /health is exempt so uptime monitoring never eats a user's budget.
const limiter = rateLimit({
  windowMs: env.rateLimitWindowMs,
  max: env.rateLimitMax,
  skip: (req) => req.path === '/health'
});
app.use(limiter);

// Login endpoints get a far tighter budget of their own: they are the ones worth
// brute-forcing, and a legitimate user only hits them once per session.
const authLimiter = rateLimit({
  windowMs: env.rateLimitWindowMs,
  max: env.authRateLimitMax,
  skipSuccessfulRequests: true,
  // A rejected login still answers HTTP 200 to stay compatible with the legacy
  // Java client, so the status code cannot be trusted here — authController
  // marks genuine failures on res.locals instead.
  requestWasSuccessful: (req, res) => !res.locals.loginFailed,
  message: { status: false, code: 429, message: 'Too many login attempts. Try again later.' }
});
const AUTH_PATHS = [
  '/Auth/Login',
  '/UserAccount/Authentication',
  '/UserAccount/getAccessToken'
];
AUTH_PATHS.forEach((authPath) => {
  app.use(authPath, authLimiter);
  app.use(`/PhsAPI${authPath}`, authLimiter);
});

// CORS. env.corsOrigins is null only outside production, where any origin is allowed.
app.use(cors({
  origin: env.corsOrigins || true,
  credentials: true
}));

// Body parser
app.use(bodyParser.json({limit: '1mb'}));
app.use(bodyParser.urlencoded({extended: true, limit: '1mb'}));
app.use(bodyParser.text({type: ['text/*', 'text/plain', 'text/html', 'application/text'], limit: '1mb'}));


// Load metadata singleton at startup directly from resources/modules
const modulesDir = path.join(__dirname, 'resources', 'modules');
mainApp.loadMetadata(modulesDir);

// Serve the static HTML documentation portal at /docs. This mount sits ahead of
// authentication, so everything under docs/ is public wherever it is enabled --
// off by default in production.
if (env.docsEnabled) {
  app.use('/docs', express.static(path.join(__dirname, 'docs')));
}

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
  console.log(
    env.docsEnabled
      ? `[PhsAPI] Interactive Docs available at http://localhost:${PORT}/docs/index.html`
      : '[PhsAPI] Interactive Docs disabled (set DOCS_ENABLED=true to serve /docs)'
  );
  console.log(`[PhsAPI] Environment: ${env.nodeEnv}`);
  await checkDatabaseConnectionOnStartup();
});

module.exports = app;

