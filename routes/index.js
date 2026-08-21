const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/auth');
const resolveTenant = require('../middleware/tenantResolver');
const authorize = require('../middleware/authorize');
const unifiedController = require('../controllers/unifiedController');
const authController = require('../controllers/authController');

// Public Auth routes
router.post('/PhsAPI/Auth/Login', (req, res, next) => authController.login(req, res, next));
router.post('/Auth/Login', (req, res, next) => authController.login(req, res, next));
router.post('/PhsAPI/UserAccount/Authentication', (req, res, next) => authController.login(req, res, next));
router.post('/UserAccount/Authentication', (req, res, next) => authController.login(req, res, next));
router.post('/PhsAPI/UserAccount/getAccessToken', (req, res, next) => authController.login(req, res, next));
router.post('/UserAccount/getAccessToken', (req, res, next) => authController.login(req, res, next));


// Global authentication and tenant resolution middleware for protected routes
router.use(authenticateToken);
router.use(resolveTenant);

router.post('/PhsAPI/UserAccount/getUserProfile', (req, res, next) => authController.getUserProfile(req, res, next));
router.post('/UserAccount/getUserProfile', (req, res, next) => authController.getUserProfile(req, res, next));
router.get('/PhsAPI/UserAccount/getUserProfile', (req, res, next) => authController.getUserProfile(req, res, next));
router.get('/UserAccount/getUserProfile', (req, res, next) => authController.getUserProfile(req, res, next));

router.post('/PhsAPI/Auth/Logout', (req, res, next) => authController.logout(req, res, next));
router.post('/Auth/Logout', (req, res, next) => authController.logout(req, res, next));
router.post('/PhsAPI/UserAccount/Logout', (req, res, next) => authController.logout(req, res, next));
router.post('/UserAccount/Logout', (req, res, next) => authController.logout(req, res, next));


// Helper function to mount routes on both prefixed (/PhsAPI) and non-prefixed paths.
// authorize runs per-route rather than via router.use so that it can read the
// resolved :package/:table params and skip routes that are not program-scoped.
function mount(method, pathStr, handler) {
  router[method](pathStr, authorize, handler);
  if (!pathStr.startsWith('/PhsAPI')) {
    router[method](`/PhsAPI${pathStr}`, authorize, handler);
  }
}

// --- UNIFIED CONTROLLER (/UC & /PhsAPI/UC) ENDPOINTS ---
mount('post', '/UC/InitForm', (req, res, next) => unifiedController.initForm(req, res, next));
mount('post', '/UC/:package/:table/List', (req, res, next) => unifiedController.listRecords(req, res, next));
mount('post', '/UC/:package/:table/Search/:page/:size', (req, res, next) => unifiedController.search(req, res, next));
mount('post', '/UC/:package/:table/Find/:page/:size', (req, res, next) => unifiedController.find(req, res, next));
mount('post', '/UC/:package/:table/Autocomplete', (req, res, next) => unifiedController.autocomplete(req, res, next));
mount('get', '/UC/:package/:table/Autocomplete', (req, res, next) => unifiedController.autocomplete(req, res, next));
mount('get', '/UC/:package/:table/:id', (req, res, next) => unifiedController.getRecord(req, res, next));
mount('post', '/UC/:package/:table/New', (req, res, next) => unifiedController.newRecord(req, res, next));
mount('put', '/UC/:package/:table', (req, res, next) => unifiedController.updateRecord(req, res, next));
mount('put', '/UC/:package/:table/:fieldName/:id/:fieldValue', (req, res, next) => unifiedController.updateField(req, res, next));
mount('put', '/UC/:package/:table/:id', (req, res, next) => unifiedController.updateFields(req, res, next));
mount('delete', '/UC/:package/:table/:id', (req, res, next) => unifiedController.deleteRecord(req, res, next));

mount('get', '/UC/:package/Codes', (req, res, next) => unifiedController.getCodes(req, res, next));
mount('get', '/UC/:package/CodeGroups/:groupName/:codeType', (req, res, next) => unifiedController.getCodeGroupsByGroup(req, res, next));
mount('get', '/UC/:package/CodeGroups/:codeType', (req, res, next) => unifiedController.getPkgCodeGroups(req, res, next));
mount('get', '/UC/CodeGroups/:codeType', (req, res, next) => unifiedController.getCodeGroups(req, res, next));

mount('post', '/UC/:pkgName/:reportName/Init', (req, res, next) => unifiedController.initReport(req, res, next));
mount('post', '/UC/:pkgName/:reportName/Statistics', (req, res, next) => unifiedController.reportStatistics(req, res, next));
mount('post', '/UC/:pkgName/:reportName/Query', (req, res, next) => unifiedController.reportQuery(req, res, next));
mount('post', '/UC/:pkgName/:reportName/PDF', (req, res, next) => unifiedController.reportPDF(req, res, next));
mount('get', '/UC/:package/:table/Tree', (req, res, next) => unifiedController.tree(req, res, next));
mount('get', '/UC/:package/:table/NewTree', (req, res, next) => unifiedController.newTree(req, res, next));
mount('post', '/UC/:package/:table/Save', (req, res, next) => unifiedController.listSave(req, res, next));
mount('post', '/UC/:pkgName/:reportName/DashQueryLine', (req, res, next) => unifiedController.dashLine(req, res, next));
mount('post', '/UC/:pkgName/:reportName/DashQueryPie', (req, res, next) => unifiedController.dashPie(req, res, next));

// --- CUSTOMIZED CONTROLLER (/CC & /PhsAPI/CC) ENDPOINTS ---
mount('post', '/CC/getCopies', (req, res, next) => unifiedController.getCopies(req, res, next));
mount('post', '/CC/attached/new', (req, res, next) => unifiedController.uploadFile(req, res, next));
mount('get', '/CC/attached/:id', (req, res, next) => unifiedController.getFile(req, res, next));
mount('delete', '/CC/attached/:id', (req, res, next) => unifiedController.deleteFile(req, res, next));

// --- GENERIC REST ENDPOINTS (/PhsAPI/:package/:table/...) ---
router.get('/PhsAPI/:package/:table/Autocomplete', authorize, (req, res, next) => unifiedController.autocomplete(req, res, next));
router.post('/PhsAPI/:package/:table/New', authorize, (req, res, next) => unifiedController.newRecord(req, res, next));
router.get('/PhsAPI/:package/:table/List', authorize, (req, res, next) => unifiedController.listRecords(req, res, next));
router.post('/PhsAPI/:package/:table/List', authorize, (req, res, next) => unifiedController.listRecords(req, res, next));
router.get('/PhsAPI/:package/:table/Get/:id', authorize, (req, res, next) => unifiedController.getRecord(req, res, next));
router.put('/PhsAPI/:package/:table/Update/:id', authorize, (req, res, next) => unifiedController.updateRecord(req, res, next));
router.patch('/PhsAPI/:package/:table/Update/:id', authorize, (req, res, next) => unifiedController.updateRecord(req, res, next));
router.delete('/PhsAPI/:package/:table/Delete/:id', authorize, (req, res, next) => unifiedController.deleteRecord(req, res, next));

module.exports = router;