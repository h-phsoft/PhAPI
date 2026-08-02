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
app.use(helmet({
  contentSecurityPolicy: false
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
});
app.use(limiter);

// CORS
app.use(cors());

// Body parser
app.use(bodyParser.json({ limit: '10mb' }));
app.use(bodyParser.urlencoded({ extended: true }));

// Load metadata singleton at startup directly from resources/modules
const modulesDir = path.join(__dirname, 'resources', 'modules');
mainApp.loadMetadata(modulesDir);

// Serve static HTML documentation portal at /docs
app.use('/docs', express.static(path.join(__dirname, 'docs')));

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

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    status: 404,
    messageKey: 'NOT_FOUND',
    message: 'Route not found'
  });
});

// Global error handling middleware
app.use(errorHandler);

// Start server
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`[PhsAPI] Server running on http://localhost:${PORT}`);
    console.log(`[PhsAPI] Interactive Docs available at http://localhost:${PORT}/docs/index.html`);
    console.log(`[PhsAPI] Environment: ${process.env.NODE_ENV || 'development'}`);
  });
}

module.exports = app;
