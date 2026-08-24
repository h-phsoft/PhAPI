/* global Buffer, process */

const http = require('http');
require('dotenv').config();

console.log('--- Testing Login Endpoint ---');

// Credentials come from the environment so no real password lives in the repo.
const username = process.env.TEST_LOGIN_USER;
const password = process.env.TEST_LOGIN_PASS;

if (!username || !password) {
  console.error('Set TEST_LOGIN_USER and TEST_LOGIN_PASS before running this script.');
  console.error('  Example: TEST_LOGIN_USER=admin TEST_LOGIN_PASS=secret node scripts/manual/testLogin.js');
  process.exit(1);
}

const postData = JSON.stringify({
  username,
  password,
  tenantId: process.env.TEST_LOGIN_TENANT || "1",
  periodId: Number(process.env.TEST_LOGIN_PERIOD || 2026)
});

const req = http.request({
  hostname: 'localhost',
  port: process.env.PORT || 3000,
  path: '/PhsAPI/Auth/Login',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(postData)
  }
}, (res) => {
  let body = '';
  res.on('data', chunk => body += chunk);
  res.on('end', () => {
    console.log('Login Response Status:', res.statusCode);
    console.log('Login Response Body:', JSON.parse(body));
  });
});

req.on('error', (e) => {
  console.error('Request Error:', e.message);
});

req.write(postData);
req.end();
