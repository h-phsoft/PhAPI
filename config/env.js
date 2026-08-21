/* global process */

require('dotenv').config();

/**
 * Validated environment configuration.
 *
 * Every secret the API depends on is read once here and validated at startup, so
 * a missing or unsafe value fails at boot instead of silently falling back to a
 * shared default that would leave issued tokens forgeable. Modules should read
 * from this object rather than touching process.env directly.
 */

const MIN_JWT_SECRET_LENGTH = 32;

// Values that previously shipped as hardcoded fallbacks, plus common placeholders.
// A deployment running any of these is effectively unauthenticated, because the
// secret is public knowledge to anyone who has seen the source.
const FORBIDDEN_JWT_SECRETS = new Set([
  'phs_api_secret_key_2026',
  'phs_api_secret_key',
  'your-secret-key',
  'changeme',
  'secret'
]);

const nodeEnv = process.env.NODE_ENV || 'development';
const isProduction = nodeEnv === 'production';

const errors = [];
const warnings = [];

function validateJwtSecret(secret) {
  if (!secret || !secret.trim()) {
    errors.push(
      'JWT_SECRET is not set. Every token this API issues and verifies depends on it.\n' +
      '      Generate one with: node -e "console.log(require(\'crypto\').randomBytes(48).toString(\'hex\'))"'
    );
    return;
  }

  if (FORBIDDEN_JWT_SECRETS.has(secret.trim().toLowerCase())) {
    errors.push('JWT_SECRET is set to a known default/placeholder value. Replace it with a unique random secret.');
    return;
  }

  if (secret.length < MIN_JWT_SECRET_LENGTH) {
    const message = `JWT_SECRET is ${secret.length} characters long; at least ${MIN_JWT_SECRET_LENGTH} is recommended.`;
    if (isProduction) {
      errors.push(message);
    } else {
      warnings.push(message);
    }
  }
}

validateJwtSecret(process.env.JWT_SECRET);

/**
 * Parses CORS_ORIGINS into an allow-list. Returns null for "allow any origin",
 * which is only tolerated outside production.
 * @param {string|undefined} raw Comma-separated origins
 * @returns {string[]|null}
 */
function parseCorsOrigins(raw) {
  const origins = (raw || '')
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);

  if (origins.length > 0) {
    return origins;
  }

  if (isProduction) {
    errors.push(
      'CORS_ORIGINS is not set. Production must name the origins allowed to call this API\n' +
      '      (comma-separated), rather than accepting credentialed requests from anywhere.'
    );
    return null;
  }

  warnings.push('CORS_ORIGINS is not set; allowing any origin. Set it before deploying.');
  return null;
}

const corsOrigins = parseCorsOrigins(process.env.CORS_ORIGINS);

if (errors.length > 0) {
  throw new Error(
    '\n[PhsAPI] Invalid environment configuration:\n' +
    errors.map((message) => `  - ${message}`).join('\n') +
    '\n\n  See .env.example for the full list of supported variables.\n'
  );
}

warnings.forEach((message) => {
  console.warn(`[PhsAPI] Configuration warning: ${message}`);
});

module.exports = {
  nodeEnv,
  isProduction,
  port: parseInt(process.env.PORT || '3000', 10),
  jwtSecret: process.env.JWT_SECRET,
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '24h',
  autocompleteSize: parseInt(process.env.AUTOCOMPLETE_SIZE || '50', 10),

  // null means "any origin" — permitted in development only.
  corsOrigins,

  rateLimitWindowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || String(15 * 60 * 1000), 10),
  // Generous, because an ERP screen fans out into many lookup calls per user action.
  rateLimitMax: parseInt(process.env.RATE_LIMIT_MAX || '1000', 10),
  // Deliberately tight: this one is what makes credential stuffing expensive.
  authRateLimitMax: parseInt(process.env.AUTH_RATE_LIMIT_MAX || '10', 10)
};
