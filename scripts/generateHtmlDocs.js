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

function generateHtmlDocs() {
  mainApp.loadMetadata(modulesDir);
  ensureDir(docsDir);

  const packages = mainApp.getAllPackages().sort();
  const catalogData = {};

  let totalEntities = 0;
  for (const pkg of packages) {
    const tables = mainApp.getTablesInPackage(pkg).sort();
    totalEntities += tables.length;

    catalogData[pkg] = tables.map(table => {
      const entity = mainApp.getEntity(pkg, table);
      return {
        tableName: table,
        synonym: entity ? (entity.synonym || table) : table,
        primaryKey: entity ? entity.primaryKey : 'id',
        hasChilds: entity ? entity.hasChilds : false,
        fieldsCount: entity ? entity.fields.length : 0,
        fields: entity ? entity.fields.map(f => ({
          name: f.Name,
          field: f.Field,
          type: f.Type,
          dbType: f.DBType,
          isAutonumber: f.isAutonumber,
          isNull: f.isNull
        })) : []
      };
    });
  }

  const catalogJsonStr = JSON.stringify(catalogData);

  const htmlContent = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PhsAPI - Interactive API Documentation</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
  <style>
    :root {
      --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #0f172a 100%);
      --card-bg: rgba(30, 41, 59, 0.7);
      --card-border: rgba(255, 255, 255, 0.1);
      --accent-purple: #818cf8;
      --accent-cyan: #38bdf8;
      --accent-emerald: #34d399;
      --accent-rose: #f43f5e;
      --accent-amber: #fbbf24;
      --text-main: #f8fafc;
      --text-muted: #94a3b8;
      --code-bg: #090d16;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: 'Outfit', sans-serif;
      background: var(--bg-gradient);
      color: var(--text-main);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      overflow-x: hidden;
    }

    /* Glassmorphism Header */
    header {
      position: sticky;
      top: 0;
      z-index: 100;
      background: rgba(15, 23, 42, 0.85);
      backdrop-filter: blur(16px);
      border-bottom: 1px solid var(--card-border);
      padding: 1rem 2rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .brand-logo {
      width: 40px;
      height: 40px;
      background: linear-gradient(135deg, var(--accent-purple), var(--accent-cyan));
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 1.25rem;
      color: #fff;
      box-shadow: 0 4px 15px rgba(129, 140, 248, 0.4);
    }

    .brand-title {
      font-size: 1.5rem;
      font-weight: 700;
      background: linear-gradient(90deg, #fff, var(--accent-cyan));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    .stats-pills {
      display: flex;
      gap: 1rem;
    }

    .stat-pill {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid var(--card-border);
      padding: 0.35rem 0.85rem;
      border-radius: 20px;
      font-size: 0.85rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .stat-pill span {
      color: var(--accent-cyan);
      font-weight: 600;
    }

    /* Main Container */
    .app-container {
      display: flex;
      flex: 1;
    }

    /* Sidebar Navigation */
    sidebar {
      width: 300px;
      background: rgba(15, 23, 42, 0.6);
      border-right: 1px solid var(--card-border);
      padding: 1.5rem 1rem;
      display: flex;
      flex-direction: column;
      gap: 1rem;
      height: calc(100vh - 73px);
      position: sticky;
      top: 73px;
    }

    .search-box {
      position: relative;
    }

    .search-box input {
      width: 100%;
      background: rgba(0, 0, 0, 0.3);
      border: 1px solid var(--card-border);
      border-radius: 8px;
      padding: 0.6rem 1rem 0.6rem 2.2rem;
      color: #fff;
      font-family: inherit;
      font-size: 0.9rem;
      outline: none;
      transition: all 0.2s;
    }

    .search-box input:focus {
      border-color: var(--accent-purple);
      box-shadow: 0 0 10px rgba(129, 140, 248, 0.3);
    }

    .search-icon {
      position: absolute;
      left: 0.75rem;
      top: 50%;
      transform: translateY(-50%);
      color: var(--text-muted);
      font-size: 0.9rem;
    }

    .sidebar-menu {
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
      padding-right: 0.25rem;
    }

    .sidebar-section-title {
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: var(--text-muted);
      margin: 0.5rem 0 0.25rem 0.5rem;
    }

    .nav-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0.6rem 0.75rem;
      border-radius: 8px;
      color: var(--text-muted);
      text-decoration: none;
      font-size: 0.9rem;
      font-weight: 500;
      transition: all 0.2s;
      cursor: pointer;
    }

    .nav-item:hover, .nav-item.active {
      background: rgba(129, 140, 248, 0.15);
      color: #fff;
      border-left: 3px solid var(--accent-purple);
    }

    .badge-count {
      background: rgba(255, 255, 255, 0.1);
      padding: 0.15rem 0.5rem;
      border-radius: 12px;
      font-size: 0.75rem;
    }

    /* Content Area */
    main {
      flex: 1;
      padding: 2rem;
      display: flex;
      flex-direction: column;
      gap: 2rem;
      max-width: 1200px;
    }

    .section-card {
      background: var(--card-bg);
      border: 1px solid var(--card-border);
      border-radius: 16px;
      padding: 1.75rem;
      backdrop-filter: blur(12px);
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    }

    .section-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 1.25rem;
      border-bottom: 1px solid var(--card-border);
      padding-bottom: 0.75rem;
    }

    .section-title {
      font-size: 1.35rem;
      font-weight: 600;
      color: #fff;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    /* Method Badges */
    .method {
      padding: 0.25rem 0.6rem;
      border-radius: 6px;
      font-size: 0.8rem;
      font-weight: 700;
      font-family: 'Fira Code', monospace;
      text-transform: uppercase;
    }

    .method.post { background: rgba(52, 211, 153, 0.2); color: var(--accent-emerald); border: 1px solid var(--accent-emerald); }
    .method.get { background: rgba(56, 189, 248, 0.2); color: var(--accent-cyan); border: 1px solid var(--accent-cyan); }
    .method.put { background: rgba(251, 191, 36, 0.2); color: var(--accent-amber); border: 1px solid var(--accent-amber); }
    .method.delete { background: rgba(244, 63, 94, 0.2); color: var(--accent-rose); border: 1px solid var(--accent-rose); }

    /* Endpoint Items */
    .endpoint-card {
      background: rgba(15, 23, 42, 0.4);
      border: 1px solid var(--card-border);
      border-radius: 12px;
      margin-bottom: 1.25rem;
      overflow: hidden;
      transition: transform 0.2s;
    }

    .endpoint-card:hover {
      border-color: rgba(255, 255, 255, 0.2);
    }

    .endpoint-summary {
      padding: 1rem 1.25rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
      background: rgba(255, 255, 255, 0.02);
    }

    .endpoint-path {
      font-family: 'Fira Code', monospace;
      font-size: 0.95rem;
      color: #e2e8f0;
    }

    .endpoint-desc {
      padding: 1rem 1.25rem;
      font-size: 0.9rem;
      color: var(--text-muted);
      line-height: 1.5;
    }

    /* Code Snippets & Tabs */
    .code-tabs {
      display: flex;
      background: var(--code-bg);
      border-bottom: 1px solid var(--card-border);
      padding: 0 1rem;
    }

    .tab-btn {
      background: transparent;
      border: none;
      color: var(--text-muted);
      padding: 0.6rem 1rem;
      font-family: inherit;
      font-size: 0.85rem;
      font-weight: 500;
      cursor: pointer;
      border-bottom: 2px solid transparent;
      transition: all 0.2s;
    }

    .tab-btn.active {
      color: var(--accent-cyan);
      border-bottom-color: var(--accent-cyan);
    }

    .code-block {
      background: var(--code-bg);
      padding: 1.25rem;
      font-family: 'Fira Code', monospace;
      font-size: 0.85rem;
      color: #38bdf8;
      overflow-x: auto;
      white-space: pre;
      line-height: 1.5;
    }

    /* Entity Table */
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 1rem;
    }

    th, td {
      padding: 0.75rem 1rem;
      text-align: left;
      border-bottom: 1px solid var(--card-border);
      font-size: 0.9rem;
    }

    th {
      background: rgba(255, 255, 255, 0.05);
      color: var(--text-muted);
      font-weight: 600;
      text-transform: uppercase;
      font-size: 0.75rem;
      letter-spacing: 0.05em;
    }

    td {
      color: #e2e8f0;
    }

    .entity-tag {
      background: rgba(129, 140, 248, 0.2);
      color: var(--accent-purple);
      padding: 0.2rem 0.5rem;
      border-radius: 4px;
      font-family: 'Fira Code', monospace;
      font-size: 0.8rem;
    }

    /* Scrollbar Styling */
    ::-webkit-scrollbar {
      width: 6px;
      height: 6px;
    }

    ::-webkit-scrollbar-track {
      background: rgba(0, 0, 0, 0.2);
    }

    ::-webkit-scrollbar-thumb {
      background: rgba(255, 255, 255, 0.2);
      border-radius: 3px;
    }

    ::-webkit-scrollbar-thumb:hover {
      background: rgba(255, 255, 255, 0.4);
    }
  </style>
</head>
<body>

  <header>
    <div class="brand">
      <div class="brand-logo">P</div>
      <div class="brand-title">PhsAPI Documentation</div>
    </div>
    <div class="stats-pills">
      <div class="stat-pill">Packages: <span>${packages.length}</span></div>
      <div class="stat-pill">Entities: <span>${totalEntities}</span></div>
      <div class="stat-pill">Autocompletes: <span>374</span></div>
    </div>
  </header>

  <div class="app-container">
    <sidebar>
      <div class="search-box">
        <span class="search-icon">🔍</span>
        <input type="text" id="packageSearch" placeholder="Search packages & models..." onkeyup="filterSidebar()">
      </div>
      <div class="sidebar-menu" id="sidebarMenu">
        <div class="sidebar-section-title">Core Endpoints</div>
        <a class="nav-item active" onclick="showSection('overviewSection')">Overview & Auth</a>
        <a class="nav-item" onclick="showSection('endpointsSection')">Generic REST Endpoints</a>
        <a class="nav-item" onclick="showSection('autocompleteSection')">Autocomplete API</a>

        <div class="sidebar-section-title">Packages Catalog (${packages.length})</div>
        ${packages.map(pkg => `
          <a class="nav-item pkg-nav-item" onclick="selectPackage('${pkg}')">
            <span>${pkg}</span>
            <span class="badge-count">${catalogData[pkg].length}</span>
          </a>
        `).join('')}
      </div>
    </sidebar>

    <main>
      <!-- Overview Section -->
      <div id="overviewSection" class="section-card">
        <div class="section-header">
          <div class="section-title">⚡ Architecture & Global Authentication</div>
        </div>
        <p style="color: var(--text-muted); line-height: 1.6; margin-bottom: 1.5rem;">
          <strong>PhsAPI</strong> operates on a strict metadata-driven architecture governing SQL generation, payload validation, audit logging, autonumbering, and routing dynamically at runtime based on JSON schema files.
        </p>

        <h4 style="color: #fff; margin-bottom: 0.75rem;">Required Request Headers</h4>
        <table>
          <thead>
            <tr>
              <th>Header Name</th>
              <th>Type</th>
              <th>Description</th>
              <th>Example</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><span class="entity-tag">Authorization</span></td>
              <td>String</td>
              <td>Bearer JWT Token issued by <span class="entity-tag">POST /PhsAPI/Auth/Login</span></td>
              <td>Bearer eyJhbGciOi...</td>
            </tr>
            <tr>
              <td><span class="entity-tag">x-tenant-id</span></td>
              <td>String / Number</td>
              <td>Target Tenant Schema ID (Resolves Oracle Database pool)</td>
              <td>1 or NSCC</td>
            </tr>
            <tr>
              <td><span class="entity-tag">x-period-id</span></td>
              <td>Number</td>
              <td>Operating Period ID (Injected into Mode 11 autonumber queries)</td>
              <td>2026</td>
            </tr>
            <tr>
              <td><span class="entity-tag">accept-language</span></td>
              <td>String</td>
              <td>Response locale language code (<span class="entity-tag">en</span> or <span class="entity-tag">ar</span>)</td>
              <td>en</td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Endpoints Section -->
      <div id="endpointsSection" class="section-card">
        <div class="section-header">
          <div class="section-title">🚀 Generic Metadata REST Endpoints</div>
        </div>

        <!-- POST Login -->
        <div class="endpoint-card">
          <div class="endpoint-summary">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
              <span class="method post">POST</span>
              <span class="endpoint-path">/PhsAPI/Auth/Login</span>
            </div>
            <span style="color: var(--text-muted); font-size: 0.85rem;">User Authentication & JWT Issuance</span>
          </div>
          <div class="endpoint-desc">
            Authenticates username and password against tenant user table (<span class="entity-tag">Copy_Users</span> / <span class="entity-tag">Cpy_User</span>) and returns a signed 24h JWT token.
          </div>
          <div class="code-tabs">
            <button class="tab-btn active">cURL</button>
            <button class="tab-btn">JavaScript</button>
            <button class="tab-btn">Python</button>
          </div>
          <div class="code-block">curl -X POST http://localhost:3000/PhsAPI/Auth/Login \\
  -H "Content-Type: application/json" \\
  -d '{"username": "admin", "password": "PhPass", "tenantId": "1", "periodId": 2026}'</div>
        </div>

        <!-- POST New -->
        <div class="endpoint-card">
          <div class="endpoint-summary">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
              <span class="method post">POST</span>
              <span class="endpoint-path">/PhsAPI/:package/:table/New</span>
            </div>
            <span style="color: var(--text-muted); font-size: 0.85rem;">Create New Record + Children</span>
          </div>
          <div class="endpoint-desc">
            Validates input payload, computes autonumbers (Sequences / Max aggregation), injects audit fields (<span class="entity-tag">insUser</span>, <span class="entity-tag">insDate</span>), and inserts master and child arrays atomically in a transaction.
          </div>
          <div class="code-block">curl -X POST http://localhost:3000/PhsAPI/Acc/Acc_Master/New \\
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \\
  -H "x-tenant-id: 1" \\
  -H "x-period-id: 2026" \\
  -H "Content-Type: application/json" \\
  -d '{
    "docNo": "DOC-2026-001",
    "mdate": "01-08-2026",
    "notes": "Accounting Entry",
    "transactions": [{ "accountNo": "101", "amount": 5000.00 }]
  }'</div>
        </div>

        <!-- GET List -->
        <div class="endpoint-card">
          <div class="endpoint-summary">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
              <span class="method get">GET</span>
              <span class="endpoint-path">/PhsAPI/:package/:table/List</span>
            </div>
            <span style="color: var(--text-muted); font-size: 0.85rem;">List / Filter Records</span>
          </div>
          <div class="endpoint-desc">
            Fetches paginated and filtered entity records using database-native pagination syntax (Oracle 12c+ <span class="entity-tag">FETCH NEXT</span>, MySQL <span class="entity-tag">LIMIT OFFSET</span>).
          </div>
          <div class="code-block">curl -X GET "http://localhost:3000/PhsAPI/Acc/Acc_Master/List?page=1&pageSize=10&docNo=DOC-2026-001" \\
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \\
  -H "x-tenant-id: 1"</div>
        </div>

        <!-- GET Get/id -->
        <div class="endpoint-card">
          <div class="endpoint-summary">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
              <span class="method get">GET</span>
              <span class="endpoint-path">/PhsAPI/:package/:table/Get/:id</span>
            </div>
            <span style="color: var(--text-muted); font-size: 0.85rem;">Get Record by ID + Children</span>
          </div>
          <div class="endpoint-desc">
            Retrieves parent record by primary key and automatically fetches and nests child record arrays.
          </div>
          <div class="code-block">curl -X GET "http://localhost:3000/PhsAPI/Acc/Acc_Master/Get/1001" \\
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \\
  -H "x-tenant-id: 1"</div>
        </div>

        <!-- PUT Update/id -->
        <div class="endpoint-card">
          <div class="endpoint-summary">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
              <span class="method put">PUT</span>
              <span class="endpoint-path">/PhsAPI/:package/:table/Update/:id</span>
            </div>
            <span style="color: var(--text-muted); font-size: 0.85rem;">Update Record</span>
          </div>
          <div class="endpoint-desc">
            Validates update permissions on writable fields, injects update audit fields (<span class="entity-tag">updUser</span>, <span class="entity-tag">updDate</span>), and updates record.
          </div>
          <div class="code-block">curl -X PUT "http://localhost:3000/PhsAPI/Acc/Acc_Master/Update/1001" \\
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \\
  -H "x-tenant-id: 1" \\
  -H "Content-Type: application/json" \\
  -d '{"notes": "Updated Entry Notes"}'</div>
        </div>

        <!-- DELETE Delete/id -->
        <div class="endpoint-card">
          <div class="endpoint-summary">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
              <span class="method delete">DELETE</span>
              <span class="endpoint-path">/PhsAPI/:package/:table/Delete/:id</span>
            </div>
            <span style="color: var(--text-muted); font-size: 0.85rem;">Delete Record</span>
          </div>
          <div class="endpoint-desc">
            Deletes record by primary key and automatically cascades deletion to child records if <span class="entity-tag">cascadeDelete = true</span>.
          </div>
          <div class="code-block">curl -X DELETE "http://localhost:3000/PhsAPI/Acc/Acc_Master/Delete/1001" \\
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \\
  -H "x-tenant-id: 1"</div>
        </div>

        <!-- GET Autocomplete -->
        <div class="endpoint-card">
          <div class="endpoint-summary">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
              <span class="method get">GET</span>
              <span class="endpoint-path">/PhsAPI/:package/:table/Autocomplete</span>
            </div>
            <span style="color: var(--text-muted); font-size: 0.85rem;">Execute Autocomplete Search</span>
          </div>
          <div class="endpoint-desc">
            Executes optimized search queries across 374+ autocomplete templates with runtime parameter substitution.
          </div>
          <div class="code-block">curl -X GET "http://localhost:3000/PhsAPI/Acc/Account/Autocomplete?term=cash" \\
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \\
  -H "x-tenant-id: 1"</div>
        </div>
      </div>

      <!-- Package Entities Catalog -->
      <div id="catalogSection" class="section-card">
        <div class="section-header">
          <div class="section-title" id="catalogTitle">📦 Entity Catalog</div>
        </div>
        <div id="catalogContent">Select a package from the sidebar to inspect its entity models and schema details.</div>
      </div>
    </main>
  </div>

  <script>
    const catalogData = ${catalogJsonStr};

    function showSection(sectionId) {
      document.getElementById('overviewSection').style.display = sectionId === 'overviewSection' ? 'block' : 'none';
      document.getElementById('endpointsSection').style.display = sectionId === 'endpointsSection' ? 'block' : 'none';
      document.getElementById('catalogSection').style.display = sectionId === 'catalogSection' ? 'block' : 'none';
      
      document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));
      event.target.classList.add('active');
    }

    function selectPackage(pkg) {
      const entities = catalogData[pkg] || [];
      document.getElementById('catalogTitle').innerText = '📦 Package: ' + pkg + ' (' + entities.length + ' Entities)';

      let html = '<table><thead><tr><th>Entity / Table</th><th>Synonym</th><th>Primary Key</th><th>Children</th><th>Fields</th></tr></thead><tbody>';
      
      entities.forEach(ent => {
        html += '<tr>' +
          '<td><span class="entity-tag">' + ent.tableName + '</span></td>' +
          '<td>' + ent.synonym + '</td>' +
          '<td>' + ent.primaryKey + '</td>' +
          '<td>' + (ent.hasChilds ? 'Yes' : 'No') + '</td>' +
          '<td>' + ent.fieldsCount + ' fields</td>' +
          '</tr>';
      });

      html += '</tbody></table>';

      document.getElementById('catalogContent').innerHTML = html;

      document.getElementById('overviewSection').style.display = 'none';
      document.getElementById('endpointsSection').style.display = 'none';
      document.getElementById('catalogSection').style.display = 'block';

      document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));
      event.currentTarget.classList.add('active');
    }

    function filterSidebar() {
      const q = document.getElementById('packageSearch').value.toLowerCase();
      document.querySelectorAll('.pkg-nav-item').forEach(item => {
        const text = item.innerText.toLowerCase();
        item.style.display = text.includes(q) ? 'flex' : 'none';
      });
    }

    // Default view
    selectPackage('${packages[0]}');
  </script>
</body>
</html>`;

  fs.writeFileSync(path.join(docsDir, 'index.html'), htmlContent, 'utf8');
  console.log(`Successfully generated interactive HTML documentation at ${docsDir}/index.html`);
}

generateHtmlDocs();
