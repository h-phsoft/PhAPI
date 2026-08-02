const fs = require('fs');
const path = require('path');
const mainApp = require('../config/mainApp');

const modulesDir = path.join(__dirname, '..', 'resources', 'modules');
const docsDir = path.join(__dirname, '..', 'docs');

function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

function generatePostman() {
  mainApp.loadMetadata(modulesDir);
  ensureDir(docsDir);

  const collection = {
    info: {
      name: 'PhsAPI - Postman Test Collection',
      _postman_id: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
      description: 'Complete Postman Collection with automatic JWT login and environment variable setting for PhsAPI.',
      schema: 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json'
    },
    variable: [
      { key: 'baseUrl', value: 'http://localhost:3000', type: 'string' },
      { key: 'jwtToken', value: '', type: 'string' },
      { key: 'tenantId', value: '1', type: 'string' },
      { key: 'periodId', value: '2026', type: 'string' }
    ],
    item: [
      {
        name: '01 - Auth & System Health',
        item: [
          {
            name: 'Login & Auto-Set JWT Token',
            event: [
              {
                listen: 'test',
                script: {
                  exec: [
                    'if (pm.response.code === 200) {',
                    '    var jsonData = pm.response.json();',
                    '    if (jsonData.data && jsonData.data.token) {',
                    '        pm.environment.set("jwtToken", jsonData.data.token);',
                    '        console.log("Successfully auto-updated jwtToken in environment!");',
                    '    }',
                    '}'
                  ],
                  type: 'text/javascript'
                }
              }
            ],
            request: {
              method: 'POST',
              header: [
                { key: 'Content-Type', value: 'application/json', type: 'text' }
              ],
              body: {
                mode: 'raw',
                raw: JSON.stringify({
                  username: "admin",
                  password: "PhPass",
                  tenantId: "1",
                  periodId: 2026
                }, null, 2)
              },
              url: {
                raw: '{{baseUrl}}/PhsAPI/Auth/Login',
                host: ['{{baseUrl}}'],
                path: ['PhsAPI', 'Auth', 'Login']
              }
            }
          },
          {
            name: 'Public Health Check',
            request: {
              method: 'GET',
              header: [],
              url: {
                raw: '{{baseUrl}}/health',
                host: ['{{baseUrl}}'],
                path: ['health']
              }
            }
          }
        ]
      },
      {
        name: '02 - Accounting (Acc) API',
        item: [
          {
            name: 'Create Acc Master with Transactions (New)',
            request: {
              method: 'POST',
              header: [
                { key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text' },
                { key: 'x-tenant-id', value: '{{tenantId}}', type: 'text' },
                { key: 'x-period-id', value: '{{periodId}}', type: 'text' },
                { key: 'Content-Type', value: 'application/json', type: 'text' }
              ],
              body: {
                mode: 'raw',
                raw: JSON.stringify({
                  docNo: "DOC-2026-101",
                  mdate: "01-08-2026",
                  notes: "Sample Accounting Master Entry",
                  transactions: [
                    { accountNo: "101", amount: 1500.00 },
                    { accountNo: "102", amount: 2500.50 }
                  ]
                }, null, 2)
              },
              url: {
                raw: '{{baseUrl}}/PhsAPI/Acc/Acc_Master/New',
                host: ['{{baseUrl}}'],
                path: ['PhsAPI', 'Acc', 'Acc_Master', 'New']
              }
            }
          },
          {
            name: 'List Acc Master Records',
            request: {
              method: 'GET',
              header: [
                { key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text' },
                { key: 'x-tenant-id', value: '{{tenantId}}', type: 'text' }
              ],
              url: {
                raw: '{{baseUrl}}/PhsAPI/Acc/Acc_Master/List?page=1&pageSize=10',
                host: ['{{baseUrl}}'],
                path: ['PhsAPI', 'Acc', 'Acc_Master', 'List'],
                query: [
                  { key: 'page', value: '1' },
                  { key: 'pageSize', value: '10' }
                ]
              }
            }
          },
          {
            name: 'Get Acc Master Record by ID',
            request: {
              method: 'GET',
              header: [
                { key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text' },
                { key: 'x-tenant-id', value: '{{tenantId}}', type: 'text' }
              ],
              url: {
                raw: '{{baseUrl}}/PhsAPI/Acc/Acc_Master/Get/101',
                host: ['{{baseUrl}}'],
                path: ['PhsAPI', 'Acc', 'Acc_Master', 'Get', '101']
              }
            }
          },
          {
            name: 'Update Acc Master Record',
            request: {
              method: 'PUT',
              header: [
                { key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text' },
                { key: 'x-tenant-id', value: '{{tenantId}}', type: 'text' },
                { key: 'Content-Type', value: 'application/json', type: 'text' }
              ],
              body: {
                mode: 'raw',
                raw: JSON.stringify({
                  notes: "Updated Accounting Master Notes"
                }, null, 2)
              },
              url: {
                raw: '{{baseUrl}}/PhsAPI/Acc/Acc_Master/Update/101',
                host: ['{{baseUrl}}'],
                path: ['PhsAPI', 'Acc', 'Acc_Master', 'Update', '101']
              }
            }
          },
          {
            name: 'Account Autocomplete Query',
            request: {
              method: 'GET',
              header: [
                { key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text' },
                { key: 'x-tenant-id', value: '{{tenantId}}', type: 'text' }
              ],
              url: {
                raw: '{{baseUrl}}/PhsAPI/Acc/Account/Autocomplete?term=cash',
                host: ['{{baseUrl}}'],
                path: ['PhsAPI', 'Acc', 'Account', 'Autocomplete'],
                query: [
                  { key: 'term', value: 'cash' }
                ]
              }
            }
          }
        ]
      },
      {
        name: '03 - Storage (Stor) API',
        item: [
          {
            name: 'List Items in Storage',
            request: {
              method: 'GET',
              header: [
                { key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text' },
                { key: 'x-tenant-id', value: '{{tenantId}}', type: 'text' }
              ],
              url: {
                raw: '{{baseUrl}}/PhsAPI/Stor/Items/List?page=1&pageSize=20',
                host: ['{{baseUrl}}'],
                path: ['PhsAPI', 'Stor', 'Items', 'List'],
                query: [
                  { key: 'page', value: '1' },
                  { key: 'pageSize', value: '20' }
                ]
              }
            }
          },
          {
            name: 'Items Autocomplete',
            request: {
              method: 'GET',
              header: [
                { key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text' },
                { key: 'x-tenant-id', value: '{{tenantId}}', type: 'text' }
              ],
              url: {
                raw: '{{baseUrl}}/PhsAPI/Stor/Items/Autocomplete?term=item',
                host: ['{{baseUrl}}'],
                path: ['PhsAPI', 'Stor', 'Items', 'Autocomplete'],
                query: [
                  { key: 'term', value: 'item' }
                ]
              }
            }
          }
        ]
      },
      {
        name: '04 - Employee (Emp) API',
        item: [
          {
            name: 'List Employees',
            request: {
              method: 'GET',
              header: [
                { key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text' },
                { key: 'x-tenant-id', value: '{{tenantId}}', type: 'text' }
              ],
              url: {
                raw: '{{baseUrl}}/PhsAPI/Emp/Employee/List?page=1&pageSize=10',
                host: ['{{baseUrl}}'],
                path: ['PhsAPI', 'Emp', 'Employee', 'List'],
                query: [
                  { key: 'page', value: '1' },
                  { key: 'pageSize', value: '10' }
                ]
              }
            }
          }
        ]
      }
    ]
  };

  const environment = {
    id: 'f1e2d3c4-b5a6-7890-1234-567890abcdef',
    name: 'PhsAPI Development Environment',
    values: [
      { key: 'baseUrl', value: 'http://localhost:3000', enabled: true },
      { key: 'jwtToken', value: '', enabled: true },
      { key: 'tenantId', value: '1', enabled: true },
      { key: 'periodId', value: '2026', enabled: true }
    ]
  };

  fs.writeFileSync(path.join(docsDir, 'PhsAPI.postman_collection.json'), JSON.stringify(collection, null, 2), 'utf8');
  fs.writeFileSync(path.join(docsDir, 'PhsAPI.postman_environment.json'), JSON.stringify(environment, null, 2), 'utf8');

  console.log(`Successfully generated Postman Collection in ${docsDir}/PhsAPI.postman_collection.json`);
  console.log(`Successfully generated Postman Environment in ${docsDir}/PhsAPI.postman_environment.json`);
}

generatePostman();
