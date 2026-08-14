const fs = require('fs');
const path = require('path');
const mainApp = require('../config/mainApp');

const modulesDir = path.join(__dirname, '..', 'resources', 'modules');
const docsDir = path.join(__dirname, '..', 'docs');

function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, {recursive: true});
  }
}

function generatePostman() {
  mainApp.loadMetadata(modulesDir);
  ensureDir(docsDir);

  const aPkgs = mainApp.getAllPackages().map((pkg, index) => {
    const pkgIndex = String(index + 2).padStart(2, '0');
    return {
      name: `${pkgIndex} - ${pkg} API`,
      item: mainApp.getTablesInPackage(pkg).map(table => {
        return {
          name: `${table} Operations`,
          item: [
            {
              name: `Create ${table} (New)`,
              request: {
                method: 'POST',
                header: [
                  {key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text'},
                  {key: 'x-period-id', value: '{{periodId}}', type: 'text'},
                  {key: 'Content-Type', value: 'application/json', type: 'text'}
                ],
                body: {
                  mode: 'raw',
                  raw: JSON.stringify({}, null, 2)
                },
                url: {
                  raw: `{{baseUrl}}/PhsAPI/${pkg}/${table}/New`,
                  host: ['{{baseUrl}}'],
                  path: ['PhsAPI', pkg, table, 'New']
                }
              }
            },
            {
              name: `List ${table} Records`,
              request: {
                method: 'GET',
                header: [
                  {key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text'}
                ],
                url: {
                  raw: `{{baseUrl}}/PhsAPI/${pkg}/${table}/List?page=1&pageSize=10`,
                  host: ['{{baseUrl}}'],
                  path: ['PhsAPI', pkg, table, 'List'],
                  query: [
                    {key: 'page', value: '1'},
                    {key: 'pageSize', value: '10'}
                  ]
                }
              }
            },
            {
              name: `Get ${table} Record by ID`,
              request: {
                method: 'GET',
                header: [
                  {key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text'}
                ],
                url: {
                  raw: `{{baseUrl}}/PhsAPI/${pkg}/${table}/Get/1`,
                  host: ['{{baseUrl}}'],
                  path: ['PhsAPI', pkg, table, 'Get', '1']
                }
              }
            },
            {
              name: `Update ${table} Record`,
              request: {
                method: 'PUT',
                header: [
                  {key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text'},
                  {key: 'Content-Type', value: 'application/json', type: 'text'}
                ],
                body: {
                  mode: 'raw',
                  raw: JSON.stringify({}, null, 2)
                },
                url: {
                  raw: `{{baseUrl}}/PhsAPI/${pkg}/${table}/Update/1`,
                  host: ['{{baseUrl}}'],
                  path: ['PhsAPI', pkg, table, 'Update', '1']
                }
              }
            },
            {
              name: `${table} Autocomplete Query`,
              request: {
                method: 'GET',
                header: [
                  {key: 'Authorization', value: 'Bearer {{jwtToken}}', type: 'text'},
                ],
                url: {
                  raw: `{{baseUrl}}/PhsAPI/${pkg}/${table}/Autocomplete?term=test`,
                  host: ['{{baseUrl}}'],
                  path: ['PhsAPI', pkg, table, 'Autocomplete'],
                  query: [
                    {key: 'term', value: 'test'}
                  ]
                }
              }
            }
          ]
        };
      })
    };
  });

  const collection = {
    info: {
      name: 'PhsAPI - Postman Test Collection',
      _postman_id: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
      description: 'Complete Postman Collection with automatic JWT login and environment variable setting for PhsAPI.',
      schema: 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json'
    },
    event: [
      {
        listen: "prerequest",
        script: {
          type: "text/javascript",
          exec: [
            "pm.collectionVariables.set(\"baseURL\",pm.collectionVariables.get(\"localURL\"));",
            "if (pm.collectionVariables.get(\"isOnline\")===\"true\"){",
            "  pm.collectionVariables.set(\"baseURL\",pm.collectionVariables.get(\"webURL\"));",
            "}",
            "pm.request.headers.upsert({ key: \"mPrgId\"       , value: pm.collectionVariables.get(\"mPrgId\") });",
            "pm.request.headers.upsert({ key: \"vLang\"        , value: pm.collectionVariables.get(\"vLang\") });",
            "pm.request.headers.upsert({ key: \"apiKey\"       , value: pm.collectionVariables.get(\"apiKey\") });",
            "pm.request.headers.upsert({ key: \"Authorization\", value: pm.collectionVariables.get(\"jwtToken\") });",
            "pm.request.headers.upsert({ key: \"Accept\"       , value: \"application/json\" });",
            "console.log(\"Authorization:\", pm.request.headers.get(\"Authorization\"));",
            "console.log(pm.collectionVariables.get(\"jwtToken\"));"
          ]
        }
      }
    ],
    variable: [
      {key: 'isOnline', value: 'false', type: 'string'},
      {key: 'baseUrl', value: 'http://localhost:3000', type: 'string'},
      {key: 'localURL', value: 'http://localhost:3000', type: 'string'},
      {key: 'webURL', value: 'http://localhost:3000', type: 'string'},
      {key: 'jwtToken', value: '', type: 'string'},
      {key: 'mPrgId', value: '0', type: 'string'},
      {key: 'vLang', value: 'en', type: 'string'},
      {key: 'apiKey', value: '', type: 'string'},
      {key: 'Authorization', value: '', type: 'string'},
      {key: 'periodId', value: '2026', type: 'string'}
    ],
    item: [
      {
        name: '01 - Auth & System Health',
        item: [
          {
            name: 'Login & Auto-Set JWT Token',
            event: [
              {
                listen: 'postrequest',
                script: {
                  exec: [
                    'if (pm.response.code === 200) {',
                    '    var jsonData = pm.response.json();',
                    '    if (jsonData.token) {',
                    '        pm.collectionVariables.set("jwtToken", jsonData.token);',
                    '        console.log("Successfully auto-updated jwtToken in collection variables!");',
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
                {key: 'Content-Type', value: 'application/json', type: 'text'}
              ],
              body: {
                mode: 'raw',
                raw: JSON.stringify({
                  username: "admin",
                  password: "PhPass",
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
      ...aPkgs
    ]
  };

  fs.writeFileSync(path.join(docsDir, 'PhsAPI.postman_collection.json'), JSON.stringify(collection, null, 2), 'utf8');

  console.log(`Successfully generated Postman Collection in ${docsDir}/PhsAPI.postman_collection.json`);
}

generatePostman();
