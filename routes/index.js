const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/auth');
const resolveTenant = require('../middleware/tenantResolver');
const unifiedController = require('../controllers/unifiedController');
const authController = require('../controllers/authController');

// Public Auth route (unauthenticated)
router.post('/PhsAPI/Auth/Login', (req, res, next) => authController.login(req, res, next));

// Global authentication and tenant resolution middleware for protected PhsAPI routes
router.use(authenticateToken);
router.use(resolveTenant);

// Autocomplete route
router.get('/PhsAPI/:package/:table/Autocomplete', (req, res, next) => unifiedController.autocomplete(req, res, next));

// Generic REST routes for PhsAPI
router.post('/PhsAPI/:package/:table/New', (req, res, next) => unifiedController.newRecord(req, res, next));
router.get('/PhsAPI/:package/:table/List', (req, res, next) => unifiedController.listRecords(req, res, next));
router.get('/PhsAPI/:package/:table/Get/:id', (req, res, next) => unifiedController.getRecord(req, res, next));
router.put('/PhsAPI/:package/:table/Update/:id', (req, res, next) => unifiedController.updateRecord(req, res, next));
router.patch('/PhsAPI/:package/:table/Update/:id', (req, res, next) => unifiedController.updateRecord(req, res, next));
router.delete('/PhsAPI/:package/:table/Delete/:id', (req, res, next) => unifiedController.deleteRecord(req, res, next));

module.exports = router;