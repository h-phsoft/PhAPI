const http = require('http');

console.log('--- Testing Login Endpoint ---');

const postData = JSON.stringify({
  username: "admin",
  password: "PhPass",
  tenantId: "1",
  periodId: 2026
});

const req = http.request({
  hostname: 'localhost',
  port: 3000,
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
