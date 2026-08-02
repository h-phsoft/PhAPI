const http = require('http');

console.log('--- Testing Login Validation Failure ---');

const postData = JSON.stringify({
  username: "admin",
  password: ""
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
    console.log('Validation Failure Status:', res.statusCode);
    console.log('Validation Failure Body:', JSON.parse(body));
  });
});

req.write(postData);
req.end();
