const bcrypt = require('bcryptjs');
const crypto = require('crypto');

/**
 * Password verification that spans the migration from plaintext storage.
 *
 * Existing tenant databases hold passwords in clear text, so verify() accepts
 * both: a bcrypt digest is checked with bcrypt, anything else falls back to a
 * constant-time comparison and is reported as legacy so callers can log it or
 * upgrade the stored value.
 */

const BCRYPT_ROUNDS = 12;

// bcrypt digests are always "$2<variant>$<cost>$..." and 60 characters long.
const BCRYPT_PATTERN = /^\$2[aby]\$\d{2}\$/;

/**
 * @param {*} stored Value read from the user table
 * @returns {boolean} True when the value is already a bcrypt digest
 */
function isHashed(stored) {
  return typeof stored === 'string' && BCRYPT_PATTERN.test(stored);
}

/**
 * @param {string} plain
 * @returns {Promise<string>} A 60-character bcrypt digest
 */
function hash(plain) {
  return bcrypt.hash(String(plain), BCRYPT_ROUNDS);
}

/**
 * Length-independent constant-time comparison. Comparing buffers of different
 * lengths throws in crypto.timingSafeEqual, so mismatched lengths still perform
 * a comparison before returning false, keeping the timing profile flat.
 * @param {string} a
 * @param {string} b
 * @returns {boolean}
 */
function timingSafeEquals(a, b) {
  const left = Buffer.from(String(a), 'utf8');
  const right = Buffer.from(String(b), 'utf8');

  if (left.length !== right.length) {
    crypto.timingSafeEqual(left, left);
    return false;
  }
  return crypto.timingSafeEqual(left, right);
}

/**
 * Verifies a submitted password against the stored value.
 * @param {string} plain Password as submitted by the caller
 * @param {*} stored Value from the user table, hashed or plaintext
 * @returns {Promise<{valid: boolean, legacy: boolean}>} legacy marks a plaintext hit
 */
async function verify(plain, stored) {
  if (plain === undefined || plain === null || stored === undefined || stored === null) {
    return { valid: false, legacy: false };
  }

  if (isHashed(stored)) {
    return { valid: await bcrypt.compare(String(plain), stored), legacy: false };
  }

  return { valid: timingSafeEquals(plain, stored), legacy: true };
}

module.exports = { hash, verify, isHashed, BCRYPT_ROUNDS };
