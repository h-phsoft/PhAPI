/* global process */

const http = require('http');
require('dotenv').config();

console.log('--- Testing Interactive HTML Docs Endpoint ---');

http.get(`http://localhost:${process.env.PORT || 3000}/docs/index.html`, (res) => {
  console.log('HTML Docs Status:', res.statusCode);
  let body = '';
  res.on('data', chunk => body += chunk);
  res.on('end', () => {
    console.log('HTML Docs Byte Length:', body.length);
    console.log('Title Check:', /<title>(.*?)<\/title>/.exec(body)?.[1]);
  });
}).on('error', (e) => {
  console.error('Error fetching docs:', e.message);
});
