const express = require('express');
const router = express.Router();

const UnifiedController = require('../controllers/unifiedController');
const authMiddleware = require('../middleware/auth');

const unifiedController = new UnifiedController();

// All routes require authentication
router.use(authMiddleware);

// Form initialization
router.post('/UC/InitForm', unifiedController.doInitForm.bind(unifiedController));

// CRUD operations
router.post('/UC/:pkgName/:tableName/List', unifiedController.doList.bind(unifiedController));
router.post('/UC/:pkgName/:tableName/Search/:page/:size', unifiedController.doSearch.bind(unifiedController));
router.post('/UC/:pkgName/:tableName/Find/:page/:size', unifiedController.doFind.bind(unifiedController));
router.post('/UC/:pkgName/:tableName/Autocomplete', unifiedController.doAutocomplete.bind(unifiedController));

router.get('/UC/:pkgName/:tableName/:id', unifiedController.doGet.bind(unifiedController));
router.post('/UC/:pkgName/:tableName/New', unifiedController.doAdd.bind(unifiedController));
router.put('/UC/:pkgName/:tableName', unifiedController.doUpdate.bind(unifiedController));
router.put('/UC/:pkgName/:tableName/:fieldName/:id/:fieldValue', unifiedController.doUpdateField.bind(unifiedController));
router.put('/UC/:pkgName/:tableName/:id', unifiedController.doUpdateFields.bind(unifiedController));
router.delete('/UC/:pkgName/:tableName/:id', unifiedController.doDelete.bind(unifiedController));

// Tree operations
router.get('/UC/:pkgName/:tableName/Tree', unifiedController.doTree.bind(unifiedController));
router.get('/UC/:pkgName/:tableName/NewTree', unifiedController.doNewTree.bind(unifiedController));

// List save
router.post('/UC/:pkgName/:tableName/Save', unifiedController.listSave.bind(unifiedController));

// Codes and code groups
router.get('/UC/:pkgName/Codes', unifiedController.doGetCodes.bind(unifiedController));
router.get('/UC/:pkgName/CodeGroups/:groupName/:codeType', unifiedController.doGetPkgCodeGroupsByGroup.bind(unifiedController));
router.get('/UC/:pkgName/CodeGroups/:codeType', unifiedController.doGetPkgCodeGroups.bind(unifiedController));
router.get('/UC/CodeGroups/:codeType', unifiedController.doGetCodeGroups.bind(unifiedController));

// Reports
router.post('/UC/:pkgName/:reportName/Init', unifiedController.initReport.bind(unifiedController));
router.post('/UC/:pkgName/:reportName/Statistics', unifiedController.doReportQS.bind(unifiedController));
router.post('/UC/:pkgName/:reportName/Query', unifiedController.doReportQT.bind(unifiedController));
router.post('/UC/:pkgName/:reportName/PDF', unifiedController.doReportPDF.bind(unifiedController));

// Dashboard
router.post('/UC/:pkgName/:reportName/DashQueryLine', unifiedController.dashLine.bind(unifiedController));
router.post('/UC/:pkgName/:reportName/DashQueryPie', unifiedController.dashPie.bind(unifiedController));

module.exports = router;