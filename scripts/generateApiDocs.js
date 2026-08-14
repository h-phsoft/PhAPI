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

function generateDocs() {
  mainApp.loadMetadata(modulesDir);
  ensureDir(docsDir);

  const packages = mainApp.getAllPackages().sort();

  let md = `# PhsAPI - Metadata-Driven REST API Documentation

## Executive Overview
**PhsAPI** is a strict, multi-tenant, metadata-driven Node.js backend. All behavior—including SQL generation, data validation, audit logging, autonumbering, and routing—is dynamically derived from JSON schema resources stored under \`resources/modules/\`.

Governing Principle: **"Definition Once, Execute Everywhere"**

---

## Global Headers & Context Parameters

| Header Name | Type | Description | Required | Example |
| :--- | :--- | :--- | :---: | :--- |
| \`Authorization\` | \`String\` | Bearer JWT Token containing \`userId\` | **Yes** | \`Bearer eyJhbGciOi...\` |
| \`x-tenant-id\` | \`String/Number\` | Target Tenant ID or Slug (resolves Oracle schema) | **Yes** | \`1\` or \`NSCC\` |
| \`x-period-id\` | \`Number\` | Operating Period ID (injected into Mode 11 autonumbers) | Optional | \`2026\` |
| \`accept-language\`| \`String\` | Locale code for localized message keys | Optional | \`en\` or \`ar\` |

---

## Standard REST API Endpoints

### 1. Create New Record
* **Endpoint:** \`POST /PhsAPI/:package/:table/New\`
* **Description:** Validates input payload, generates autonumber fields, injects audit fields (\`insUser\`/\`insDate\`), and atomically inserts record and nested child arrays inside a transaction.
* **Request Body Example:**
\`\`\`json
{
  "docNo": "DOC-2026-001",
  "mdate": "01-08-2026",
  "notes": "Accounting Master Entry",
  "transactions": [
    { "accountNo": "101", "amount": 5000.00 }
  ]
}
\`\`\`
* **Response Example:**
\`\`\`json
{
  "success": true,
  "status": 200,
  "messageKey": "CREATED",
  "message": "Record created successfully",
  "data": {
    "id": 1001,
    "docNo": "DOC-2026-001",
    "mdate": "01-08-2026"
  }
}
\`\`\`

---

### 2. List Records
* **Endpoint:** \`GET /PhsAPI/:package/:table/List\`
* **Description:** Retrieves paginated and filtered records for an entity.
* **Query Parameters:**
  * \`page\`: Page number (Default: \`1\`)
  * \`pageSize\`: Page size (Default: \`20\`)
  * \`sortBy\`: Field to sort by
  * \`sortOrder\`: \`ASC\` or \`DESC\`
  * \`<fieldName>\`: Any filterable query field defined in entity metadata
* **Example:** \`GET /PhsAPI/Acc/Acc_Master/List?page=1&pageSize=10&docNo=DOC-2026-001\`

---

### 3. Get Single Record by ID
* **Endpoint:** \`GET /PhsAPI/:package/:table/Get/:id\`
* **Description:** Fetches parent record by primary key along with any nested child arrays if \`hasChilds = true\`.

---

### 4. Update Record by ID
* **Endpoint:** \`PUT /PhsAPI/:package/:table/Update/:id\` or \`PATCH /PhsAPI/:package/:table/Update/:id\`
* **Description:** Validates update permissions and writable fields, injects update audit fields (\`updUser\`/\`updDate\`), and updates record.

---

### 5. Delete Record by ID
* **Endpoint:** \`DELETE /PhsAPI/:package/:table/Delete/:id\`
* **Description:** Deletes parent record by primary key and cascades deletion to child records if \`cascadeDelete = true\`.

---

### 6. Autocomplete Query
* **Endpoint:** \`GET /PhsAPI/:package/:table/Autocomplete\`
* **Description:** Executes optimized autocomplete queries against 374+ predefined templates.
* **Query Parameters:**
  * \`term\`: Search term string
  * \`<customParam>\`: Context parameters defined in autocomplete template
* **Example:** \`GET /PhsAPI/Acc/Account/Autocomplete?term=cash\`

---

## Active Package & Entity Catalog

Registered Packages: **${packages.length} Packages**

`;

  let totalEntities = 0;

  for (const pkg of packages) {
    const tables = mainApp.getTablesInPackage(pkg).sort();
    totalEntities += tables.length;

    md += `### Package: \`${pkg}\` (${tables.length} Entities)\n`;
    md += `| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |\n`;
    md += `| :--- | :--- | :--- | :---: | :---: |\n`;

    for (const table of tables) {
      const entity = mainApp.getEntity(pkg, table);
      const syn = entity ? (entity.synonym || '-') : '-';
      const pk = entity ? entity.primaryKey : 'id';
      const hasChilds = entity ? (entity.hasChilds ? 'Yes' : 'No') : 'No';
      const fieldCount = entity ? entity.fields.length : 0;

      md += `| \`${table}\` | \`${syn}\` | \`${pk}\` | ${hasChilds} | ${fieldCount} |\n`;
    }
    md += `\n`;
  }

  md += `\nTotal Registered Entities Across Application: **${totalEntities} Entities**\n`;

  // Write Markdown file
  fs.writeFileSync(path.join(docsDir, 'API_DOCUMENTATION.md'), md, 'utf8');

  // Generate OpenAPI 3.0 spec
  const openApi = {
    openapi: '3.0.3',
    info: {
      title: 'PhsAPI - Multi-Tenant Metadata-Driven REST API',
      version: '1.0.0',
      description: 'Strict metadata-driven architecture for ERP backend replacing legacy Java system.'
    },
    servers: [
      { url: 'http://localhost:3000', description: 'Local Development Server' }
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        },
        tenantHeader: {
          type: 'apiKey',
          in: 'header',
          name: 'x-tenant-id'
        }
      }
    },
    security: [
      { bearerAuth: [], tenantHeader: [] }
    ],
    paths: {
      '/health': {
        get: {
          summary: 'Public Health Check',
          responses: {
            '200': { description: 'System health status and registered packages' }
          }
        }
      },
      '/PhsAPI/Auth/Login': {
        post: {
          summary: 'User Login',
          requestBody: {
            required: true,
            content: { 'application/json': { schema: { type: 'object' } } }
          },
          responses: {
            '200': { description: 'JWT Token and user info' },
            '401': { description: 'Unauthorized' }
          }
        }
      },
      '/PhsAPI/UserAccount/getUserProfile': {
        get: {
          summary: 'Get User Profile',
          responses: {
            '200': { description: 'User profile, permissions, and programs' }
          }
        },
        post: {
          summary: 'Get User Profile',
          responses: {
            '200': { description: 'User profile, permissions, and programs' }
          }
        }
      },
      '/PhsAPI/{package}/{table}/New': {
        post: {
          summary: 'Create New Entity Record',
          parameters: [
            { name: 'package', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'table', in: 'path', required: true, schema: { type: 'string' } }
          ],
          requestBody: {
            required: true,
            content: { 'application/json': { schema: { type: 'object' } } }
          },
          responses: {
            '200': { description: 'Record created successfully' },
            '400': { description: 'Validation or Metadata error' },
            '401': { description: 'Unauthorized' }
          }
        }
      },
      '/PhsAPI/{package}/{table}/List': {
        get: {
          summary: 'List / Filter Entity Records',
          parameters: [
            { name: 'package', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'table', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'page', in: 'query', schema: { type: 'integer', default: 1 } },
            { name: 'pageSize', in: 'query', schema: { type: 'integer', default: 20 } },
            { name: 'sortBy', in: 'query', schema: { type: 'string' } },
            { name: 'sortOrder', in: 'query', schema: { type: 'string', enum: ['ASC', 'DESC'] } }
          ],
          responses: {
            '200': { description: 'List of entity records' }
          }
        }
      },
      '/PhsAPI/{package}/{table}/Get/{id}': {
        get: {
          summary: 'Get Record By ID with Nested Children',
          parameters: [
            { name: 'package', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'table', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'id', in: 'path', required: true, schema: { type: 'string' } }
          ],
          responses: {
            '200': { description: 'Record details with nested children' },
            '404': { description: 'Record not found' }
          }
        }
      },
      '/PhsAPI/{package}/{table}/Update/{id}': {
        put: {
          summary: 'Update Record By ID',
          parameters: [
            { name: 'package', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'table', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'id', in: 'path', required: true, schema: { type: 'string' } }
          ],
          requestBody: {
            required: true,
            content: { 'application/json': { schema: { type: 'object' } } }
          },
          responses: {
            '200': { description: 'Record updated successfully' }
          }
        }
      },
      '/PhsAPI/{package}/{table}/Delete/{id}': {
        delete: {
          summary: 'Delete Record By ID',
          parameters: [
            { name: 'package', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'table', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'id', in: 'path', required: true, schema: { type: 'string' } }
          ],
          responses: {
            '200': { description: 'Record deleted successfully' }
          }
        }
      },
      '/PhsAPI/{package}/{table}/Autocomplete': {
        get: {
          summary: 'Execute Autocomplete Query',
          parameters: [
            { name: 'package', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'table', in: 'path', required: true, schema: { type: 'string' } },
            { name: 'term', in: 'query', schema: { type: 'string' } }
          ],
          responses: {
            '200': { description: 'Autocomplete matches' }
          }
        }
      }
    }
  };

  fs.writeFileSync(path.join(docsDir, 'openapi.json'), JSON.stringify(openApi, null, 2), 'utf8');

  console.log(`Successfully generated API documentation in ${docsDir}/API_DOCUMENTATION.md`);
  console.log(`Successfully generated OpenAPI spec in ${docsDir}/openapi.json`);
}

generateDocs();
