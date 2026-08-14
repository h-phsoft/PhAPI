# PhsAPI - Metadata-Driven REST API Documentation

## Executive Overview
**PhsAPI** is a strict, multi-tenant, metadata-driven Node.js backend. All behavior—including SQL generation, data validation, audit logging, autonumbering, and routing—is dynamically derived from JSON schema resources stored under `resources/modules/`.

Governing Principle: **"Definition Once, Execute Everywhere"**

---

## Global Headers & Context Parameters

| Header Name | Type | Description | Required | Example |
| :--- | :--- | :--- | :---: | :--- |
| `Authorization` | `String` | Bearer JWT Token containing `userId` | **Yes** | `Bearer eyJhbGciOi...` |
| `x-tenant-id` | `String/Number` | Target Tenant ID or Slug (resolves Oracle schema) | **Yes** | `1` or `NSCC` |
| `x-period-id` | `Number` | Operating Period ID (injected into Mode 11 autonumbers) | Optional | `2026` |
| `accept-language`| `String` | Locale code for localized message keys | Optional | `en` or `ar` |

---

## Standard REST API Endpoints

### 1. Create New Record
* **Endpoint:** `POST /PhsAPI/:package/:table/New`
* **Description:** Validates input payload, generates autonumber fields, injects audit fields (`insUser`/`insDate`), and atomically inserts record and nested child arrays inside a transaction.
* **Request Body Example:**
```json
{
  "docNo": "DOC-2026-001",
  "mdate": "01-08-2026",
  "notes": "Accounting Master Entry",
  "transactions": [
    { "accountNo": "101", "amount": 5000.00 }
  ]
}
```
* **Response Example:**
```json
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
```

---

### 2. List Records
* **Endpoint:** `GET /PhsAPI/:package/:table/List`
* **Description:** Retrieves paginated and filtered records for an entity.
* **Query Parameters:**
  * `page`: Page number (Default: `1`)
  * `pageSize`: Page size (Default: `20`)
  * `sortBy`: Field to sort by
  * `sortOrder`: `ASC` or `DESC`
  * `<fieldName>`: Any filterable query field defined in entity metadata
* **Example:** `GET /PhsAPI/Acc/Acc_Master/List?page=1&pageSize=10&docNo=DOC-2026-001`

---

### 3. Get Single Record by ID
* **Endpoint:** `GET /PhsAPI/:package/:table/Get/:id`
* **Description:** Fetches parent record by primary key along with any nested child arrays if `hasChilds = true`.

---

### 4. Update Record by ID
* **Endpoint:** `PUT /PhsAPI/:package/:table/Update/:id` or `PATCH /PhsAPI/:package/:table/Update/:id`
* **Description:** Validates update permissions and writable fields, injects update audit fields (`updUser`/`updDate`), and updates record.

---

### 5. Delete Record by ID
* **Endpoint:** `DELETE /PhsAPI/:package/:table/Delete/:id`
* **Description:** Deletes parent record by primary key and cascades deletion to child records if `cascadeDelete = true`.

---

### 6. Autocomplete Query
* **Endpoint:** `GET /PhsAPI/:package/:table/Autocomplete`
* **Description:** Executes optimized autocomplete queries against 374+ predefined templates.
* **Query Parameters:**
  * `term`: Search term string
  * `<customParam>`: Context parameters defined in autocomplete template
* **Example:** `GET /PhsAPI/Acc/Account/Autocomplete?term=cash`

---

## Active Package & Entity Catalog

Registered Packages: **25 Packages**

### Package: `Acc` (28 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Account` | `Acc_Acc` | `id` | No | 14 |
| `AccountView` | `Acc_Vacc` | `id` | No | 16 |
| `AgesTemporary` | `Acc_Tmpage` | `id` | No | 27 |
| `BankMaster` | `Acc_Bank_Mst` | `id` | Yes | 11 |
| `BankTransaction` | `Acc_Bank_Trn` | `id` | No | 19 |
| `BudgetMaster` | `Acc_Budmst` | `id` | Yes | 9 |
| `BudgetTransaction` | `Acc_Budtrn` | `id` | No | 11 |
| `BudgetView` | `Acc_Vbud` | `id` | No | 15 |
| `CloseAccount` | `Acc_Close` | `id` | No | 8 |
| `CodeAmountSide` | `Acc_Cod_Amtside` | `id` | No | 8 |
| `CodeDocument` | `Acc_Cod_Doc` | `id` | No | 8 |
| `CodeLineType` | `Acc_Cod_Linetype` | `id` | No | 8 |
| `CodeReportAmount` | `Acc_Cod_Repamt` | `id` | No | 8 |
| `CostCenterView` | `Acc_Vcost` | `id` | No | 12 |
| `CostCenters` | `Acc_Cost` | `id` | No | 11 |
| `GenerateReports` | `Acc_Genrep` | `id` | No | 17 |
| `GrantAccount` | `Acc_Grantacc` | `id` | No | 8 |
| `GrantAccountView` | `Acc_Vgrant` | `id` | No | 7 |
| `Master` | `Acc_Mst` | `id` | Yes | 16 |
| `Report` | `Acc_Rep` | `id` | Yes | 7 |
| `ReportItems` | `Acc_Repitm` | `id` | No | 16 |
| `ReportView` | `Acc_Vrep` | `id` | No | 30 |
| `SumvoucherView` | `Acc_Vsvoucher` | `id` | No | 27 |
| `Total` | `Acc_Tot` | `id` | Yes | 8 |
| `TotalAccounts` | `Acc_Totacc` | `id` | No | 12 |
| `TotalView` | `Acc_Vtot` | `id` | No | 13 |
| `Transaction` | `Acc_Trn` | `id` | No | 22 |
| `VoucherView` | `Acc_Vvoucher` | `id` | No | 52 |

### Package: `Bank` (13 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Accounts` | `Bank_Acc` | `id` | No | 20 |
| `CodeMethod` | `Bank_Cod_Method` | `id` | No | 8 |
| `CodeStatus` | `Bank_Cod_Status` | `id` | No | 8 |
| `CodeTrt` | `Bank_Cod_Trt` | `id` | No | 8 |
| `CollectionOrder` | `Bank_Cord` | `id` | No | 39 |
| `DepositOrder` | `Bank_Dord` | `id` | No | 39 |
| `DorderStatus` | `Bank_Dordstatus` | `id` | No | 9 |
| `OrderView` | `Bank_Vord` | `id` | No | 83 |
| `PaymentOrder` | `Bank_Pord` | `id` | No | 39 |
| `TorderStatus` | `Bank_Tordstatus` | `id` | No | 9 |
| `TransferOrder` | `Bank_Tord` | `id` | No | 58 |
| `WithdrawOrder` | `Bank_Word` | `id` | No | 39 |
| `WorderStatus` | `Bank_Wordstatus` | `id` | No | 9 |

### Package: `Cash` (18 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `AdvancedPaymentOrder` | `Cash_Apord` | `id` | No | 38 |
| `AdvancedPaymentOrderView` | `Cash_Vapord` | `id` | No | 61 |
| `Boxes` | `Cash_Box` | `id` | No | 14 |
| `Cashiers` | `Cash_Cash` | `id` | No | 11 |
| `CashiersBoxesView` | `Cash_Vcash_Box` | `id` | No | 20 |
| `CodeCity` | `Cash_Cod_City` | `id` | No | 8 |
| `CodeMethod` | `Cash_Cod_Method` | `id` | No | 8 |
| `CodePhnby` | `Cash_Cod_Phnby` | `id` | No | 8 |
| `CodeStatus` | `Cash_Cod_Status` | `id` | No | 8 |
| `CodeTrt` | `Cash_Cod_Trt` | `id` | No | 8 |
| `CollectionOrder` | `Cash_Cord` | `id` | No | 38 |
| `CollectionOrderView` | `Cash_Vcord` | `id` | No | 61 |
| `ExchangeOrderView` | `Cash_Veord` | `id` | No | 62 |
| `OrderView` | `Cash_Vord` | `id` | No | 52 |
| `PaymentOrder` | `Cash_Pord` | `id` | No | 38 |
| `PaymentOrderView` | `Cash_Vpord` | `id` | No | 61 |
| `TransferOrder` | `Cash_Tord` | `id` | No | 50 |
| `TransferOrderView` | `Cash_Vtord` | `id` | No | 46 |

### Package: `Clnc` (34 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Appointment` | `Clnc_App` | `id` | No | 17 |
| `AppointmentChange` | `Clnc_App_Change` | `id` | No | 9 |
| `AppointmentStatus` | `Clnc_App_Status` | `id` | No | 8 |
| `AppointmentType` | `Clnc_App_Type` | `id` | No | 11 |
| `AppointmentView` | `Clnc_Vapp` | `id` | No | 77 |
| `Category` | `Clnc_Cat` | `id` | Yes | 9 |
| `Clinics` | `Clnc_Clinic` | `id` | No | 12 |
| `CodeDiscount` | `Clnc_Cod_Disc` | `id` | No | 7 |
| `CodeNationality` | `Clnc_Cod_Nat` | `id` | No | 8 |
| `CodeShift` | `Clnc_Cod_Shift` | `id` | No | 8 |
| `CodeVat` | `Clnc_Cod_Vat` | `id` | No | 7 |
| `Discounts` | `Clnc_Disc` | `id` | No | 10 |
| `Doctors` | `Clnc_Doctor` | `id` | No | 22 |
| `DoctorsView` | `Clnc_Vdoctor` | `id` | No | 25 |
| `InvoiceTreatments` | `Clnc_Invoice_Treat` | `id` | No | 7 |
| `Invoices` | `Clnc_Invoice` | `id` | Yes | 13 |
| `Laboratory` | `Clnc_Labor` | `id` | No | 11 |
| `LaboratoryReceive` | `Clnc_Labor_Receive` | `id` | No | 13 |
| `LaboratorySend` | `Clnc_Labor_Send` | `id` | No | 13 |
| `Lists` | `Clnc_List` | `id` | No | 8 |
| `PatientNote` | `Clnc_Pat_Note` | `id` | No | 9 |
| `Patients` | `Clnc_Patient` | `id` | No | 22 |
| `PatientsView` | `Clnc_Vpatient` | `id` | No | 24 |
| `Payment` | `Clnc_Pay` | `id` | No | 11 |
| `PaymentType` | `Clnc_Pay_Type` | `id` | No | 7 |
| `Procedures` | `Clnc_Proc` | `id` | No | 11 |
| `Refunds` | `Clnc_Refund` | `id` | No | 10 |
| `Specials` | `Clnc_Special` | `id` | No | 8 |
| `Treatment` | `Clnc_Treat` | `id` | Yes | 12 |
| `TreatmentProcedures` | `Clnc_Treat_Proc` | `id` | No | 16 |
| `TreatmentStatus` | `Clnc_Treat_Status` | `id` | No | 8 |
| `TreatmentView` | `Clnc_Vtreat` | `id` | No | 83 |
| `UserClinics` | `Clnc_User_Clinic` | `id` | No | 7 |
| `Worktimes` | `Clnc_Worktime` | `id` | No | 7 |

### Package: `Cpy` (51 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `CopyAlerts` | `Cpy_Alert` | `id` | No | 11 |
| `CopyAttachedFiles` | `Cpy_Attach` | `id` | No | 16 |
| `CopyBranchePreferences` | `Cpy_Bpref` | `id` | No | 12 |
| `CopyBrancheView` | `Cpy_Vmbran` | `id` | No | 19 |
| `CopyBranches` | `Cpy_Bran` | `id` | No | 18 |
| `CopyCodeDocument` | `Cpy_Cod_Doc` | `id` | No | 8 |
| `CopyCodePeriodstatus` | `Cpy_Cod_Pstatus` | `id` | No | 8 |
| `CopyCodePrintFormats` | `Cpy_Cod_Print_Format` | `id` | No | 11 |
| `CopyCodeStatus` | `Cpy_Cod_Status` | `id` | No | 8 |
| `CopyCodeTaskAction` | `Cpy_Cod_Task_Action` | `id` | No | 8 |
| `CopyCodeTaskPriority` | `Cpy_Cod_Task_Priority` | `id` | No | 10 |
| `CopyCodeTaskPrivacy` | `Cpy_Cod_Task_Privacy` | `id` | No | 9 |
| `CopyCodeTaskStatus` | `Cpy_Cod_Task_Status` | `id` | No | 11 |
| `CopyCodeUnit` | `Cpy_Cod_Unit` | `id` | No | 8 |
| `CopyDashboardPermission` | `Cpy_Dash_Perm` | `id` | No | 4 |
| `CopyDepartmentUnit` | `Cpy_Unit` | `id` | No | 10 |
| `CopyDepartments` | `Cpy_Dept` | `id` | No | 8 |
| `CopyFinanceDocuments` | `Cpy_Fdoc` | `id` | No | 11 |
| `CopyGroupPermissionsView` | `Cpy_Vgperm` | `id` | Yes | 17 |
| `CopyMenuView` | `Cpy_Vmenu` | `id` | No | 4 |
| `CopyPeriods` | `Cpy_Period` | `id` | No | 11 |
| `CopyPeriodsView` | `Cpy_Vperiod` | `id` | No | 12 |
| `CopyPermision` | `Cpy_Perm` | `id` | Yes | 11 |
| `CopyPermisionPrivileges` | `Cpy_Permpriv` | `id` | No | 8 |
| `CopyPermisionPrivilegesView` | `Cpy_Vgppriv` | `id` | No | 16 |
| `CopyPermisionSpecprivileges` | `Cpy_Permspriv` | `id` | No | 9 |
| `CopyPermisionSpecprivsView` | `Cpy_Vgpspriv` | `id` | No | 18 |
| `CopyPermissionGroups` | `Cpy_Pgrp` | `id` | Yes | 9 |
| `CopyPreferences` | `Cpy_Pref` | `id` | No | 11 |
| `CopySpeciallists` | `Cpy_Slist` | `id` | No | 8 |
| `CopySpeciallistsView` | `Cpy_Vslist` | `id` | No | 16 |
| `CopySpecialliststrn` | `Cpy_Tlist` | `id` | No | 8 |
| `CopySpecpermission` | `Cpy_Specperm` | `id` | No | 8 |
| `CopyTask` | `Cpy_Task` | `id` | Yes | 22 |
| `CopyTaskActions` | `Cpy_Task_Action` | `id` | No | 11 |
| `CopyTaskRatingmst` | `Cpy_Task_Ratemst` | `id` | Yes | 9 |
| `CopyTaskRatingtrn` | `Cpy_Task_Ratetrn` | `id` | No | 9 |
| `CopyTaskUsers` | `Cpy_Task_User` | `id` | No | 9 |
| `CopyTokens` | `Cpy_Token` | `id` | No | 14 |
| `CopyUnitForwardStatus` | `Cpy_Unit_Frwrd_Status` | `id` | No | 9 |
| `CopyUnitOperations` | `Cpy_Oper` | `id` | No | 9 |
| `CopyUnitReceiveStatus` | `Cpy_Unit_Rec_Status` | `id` | No | 12 |
| `CopyUnitReceiveStatusView` | `Cpy_Vunit_Rec_Status` | `id` | No | 13 |
| `CopyUserDashboardList` | `Cpy_UDBoard_List` | `id` | Yes | 9 |
| `CopyUserDashboardListBlocks` | `Cpy_UDBoard_List_Blks` | `id` | No | 11 |
| `CopyUserDashboardListBlocksView` | `Cpy_Vudboard_List_Blks` | `id` | No | 31 |
| `CopyUserPreferences` | `Cpy_Upref` | `id` | No | 12 |
| `CopyUserUnits` | `Cpy_User_Unit` | `id` | No | 9 |
| `CopyUsers` | `Cpy_User` | `id` | No | 14 |
| `CopyUsersView` | `Cpy_Vuser` | `id` | No | 23 |
| `DgAdministrativeFeesView` | `Dg_Vadmin_Fees` | `id` | No | 9 |

### Package: `Crm` (12 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `CodeClearance` | `Crm_Cod_Clearance` | `id` | No | 8 |
| `CodeGroup` | `Crm_Cod_Grp` | `id` | Yes | 10 |
| `CodeItem` | `Crm_Cod_Itm` | `id` | No | 9 |
| `CodeKind` | `Crm_Cod_Kind` | `id` | No | 8 |
| `CodeStatus` | `Crm_Cod_Status` | `id` | No | 8 |
| `CodeType` | `Crm_Cod_Type` | `id` | No | 8 |
| `Contact` | `Crm_Cont` | `id` | Yes | 20 |
| `ContactBranche` | `Crm_Cont_Bran` | `id` | No | 14 |
| `ContactClassification` | `Crm_Cont_Class` | `id` | No | 9 |
| `ContactContact` | `Crm_Cont_Cont` | `id` | No | 16 |
| `ReportMaster` | `Crm_Mrep` | `id` | No | 15 |
| `Representatives` | `Crm_Repr` | `id` | No | 13 |

### Package: `Emp` (118 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Accredited` | `Emp_Acr` | `id` | No | 7 |
| `AddonSalary` | `Emp_Aosal` | `id` | Yes | 20 |
| `AddonSalaryEmployees` | `Emp_Aosalemp` | `id` | No | 10 |
| `AdminConsiderationMst` | `Emp_Madmcon` | `id` | Yes | 9 |
| `AdminConsiderationTrn` | `Emp_Tadmcon` | `id` | No | 12 |
| `AdminConsiderationView` | `Emp_Vadmcons` | `id` | No | 34 |
| `AdminPunishmentMst` | `Emp_Madmpun` | `id` | Yes | 9 |
| `AdminPunishmentTrn` | `Emp_Tadmpun` | `id` | No | 12 |
| `AdminPunishmentView` | `Emp_Vadmpun` | `id` | No | 34 |
| `Application` | `Emp_Appl` | `id` | No | 27 |
| `ApplicationAppliedfor` | `Emp_Appfor` | `id` | No | 8 |
| `ApplicationAppliedvia` | `Emp_Appvia` | `id` | No | 8 |
| `ApplicationCourse` | `Emp_Appcourse` | `id` | No | 11 |
| `ApplicationEducation` | `Emp_Appeduc` | `id` | No | 10 |
| `ApplicationFitfor` | `Emp_Appfit` | `id` | No | 8 |
| `ApplicationHrnote` | `Emp_Apphrnote` | `id` | No | 7 |
| `ApplicationInterviewer` | `Emp_Appviewer` | `id` | No | 9 |
| `ApplicationJob` | `Emp_Appjob` | `id` | No | 13 |
| `ApplicationLanguage` | `Emp_Applang` | `id` | No | 11 |
| `ApplicationReferences` | `Emp_Appref` | `id` | No | 10 |
| `AppraisalEmployeeMst` | `Emp_Apprempmst` | `id` | Yes | 12 |
| `AppraisalEmployeeTrn` | `Emp_Appremptrn` | `id` | No | 9 |
| `AppraisalEvaluation` | `Emp_Appreval` | `id` | No | 11 |
| `AppraisalNotes` | `Emp_Apprnote` | `id` | No | 13 |
| `AppraisalTemplatesMst` | `Emp_Apprmst` | `id` | Yes | 8 |
| `AppraisalTemplatesTrn` | `Emp_Apprtrn` | `id` | No | 10 |
| `Attendance` | `Emp_Att` | `id` | No | 9 |
| `ChangeSalary` | `Emp_Csal` | `id` | Yes | 17 |
| `ChangeSalaryEmployees` | `Emp_Csalemp` | `id` | No | 11 |
| `ChangesalaryBracketsMst` | `Emp_Mchsalbrkt` | `id` | Yes | 8 |
| `ChangesalaryBracketsTrn` | `Emp_Tchsalbrkt` | `id` | No | 11 |
| `CodeAffected` | `Emp_Cod_Aff` | `id` | No | 8 |
| `CodeAffectedSalary` | `Emp_Cod_Affsal` | `id` | No | 8 |
| `CodeAppResult` | `Emp_Cod_App_Result` | `id` | No | 8 |
| `CodeAppraisalGrp` | `Emp_Cod_Appraisal_Grp` | `id` | No | 8 |
| `CodeAppraisalItem` | `Emp_Cod_Appraisal_Item` | `id` | No | 8 |
| `CodeAttendType` | `Emp_Cod_Atttype` | `id` | No | 8 |
| `CodeCalcsalary` | `Emp_Cod_Calcsal` | `id` | No | 8 |
| `CodeChangeType` | `Emp_Cod_Chngtype` | `id` | No | 8 |
| `CodeComPer` | `Emp_Cod_Com_Per` | `id` | No | 8 |
| `CodeComtype` | `Emp_Cod_Comtype` | `id` | No | 8 |
| `CodeConsideration` | `Emp_Cod_Cons` | `id` | No | 8 |
| `CodeDepartment` | `Emp_Cod_Department` | `id` | No | 8 |
| `CodeEducation` | `Emp_Cod_Edu` | `id` | No | 8 |
| `CodeGraddegree` | `Emp_Cod_Graddegree` | `id` | No | 8 |
| `CodeGradgrp` | `Emp_Cod_Gradgrp` | `id` | No | 8 |
| `CodeHistory` | `Emp_Cod_Hist` | `id` | No | 8 |
| `CodeJob` | `Emp_Cod_Job` | `id` | No | 8 |
| `CodeLanguage` | `Emp_Cod_Lang` | `id` | No | 8 |
| `CodeLeave` | `Emp_Cod_Leave` | `id` | No | 8 |
| `CodeLevel` | `Emp_Cod_Level` | `id` | No | 8 |
| `CodeLocation` | `Emp_Cod_Location` | `id` | No | 8 |
| `CodeMission` | `Emp_Cod_Msn` | `id` | No | 8 |
| `CodeNationality` | `Emp_Cod_Nat` | `id` | No | 8 |
| `CodeOvertime` | `Emp_Cod_Overtime` | `id` | No | 8 |
| `CodePunishment` | `Emp_Cod_Pun` | `id` | No | 8 |
| `CodeSection` | `Emp_Cod_Section` | `id` | No | 8 |
| `CodeSpecification1` | `Emp_Cod_Spec1` | `id` | No | 8 |
| `CodeSpecification2` | `Emp_Cod_Spec2` | `id` | No | 8 |
| `CodeSpecification3` | `Emp_Cod_Spec3` | `id` | No | 8 |
| `CodeSpecification4` | `Emp_Cod_Spec4` | `id` | No | 8 |
| `CodeStatus` | `Emp_Cod_Status` | `id` | No | 8 |
| `CodeTaxpay` | `Emp_Cod_Taxpay` | `id` | No | 8 |
| `CodeTestmarks` | `Emp_Cod_Testmark` | `id` | No | 8 |
| `CodeWgrpShift` | `Emp_Cod_Wgrp_Shift` | `id` | No | 8 |
| `CodeWgrpType` | `Emp_Cod_Wgrp_Type` | `id` | No | 8 |
| `Compensation` | `Emp_Com` | `id` | No | 15 |
| `Daily` | `Emp_Day` | `id` | No | 8 |
| `DailyEntout` | `Emp_Deo` | `id` | No | 64 |
| `DayAttendanceFile` | `Emp_Dayattfile` | `id` | No | 9 |
| `Debit` | `Emp_Dbt` | `id` | No | 10 |
| `Deduction` | `Emp_Ded` | `id` | No | 9 |
| `EmploeeHistory` | `Emp_Emphist` | `id` | No | 11 |
| `Employee` | `Emp_Emp` | `id` | No | 15 |
| `EmployeeCompensation` | `Emp_Ecom` | `id` | No | 13 |
| `EmployeeDailyEntout` | `Emp_Edeo` | `id` | No | 35 |
| `EmployeeDeduction` | `Emp_Eded` | `id` | No | 12 |
| `EmployeeDeoFingerprint` | `Emp_Edeof` | `id` | No | 10 |
| `EmployeeDeoMerge` | `Emp_Edeom` | `id` | No | 14 |
| `EmployeeGradeTmpltView` | `Emp_Vempgradtmplt` | `id` | No | 8 |
| `Entrance` | `Emp_Ent` | `id` | No | 10 |
| `FingerPrint` | `Emp_Fngrprnt` | `id` | No | 11 |
| `FingerprintLogs` | `Emp_Fprint` | `id` | No | 11 |
| `FunctionalChart` | `Emp_Fchart` | `id` | No | 11 |
| `GradeChange` | `Emp_Chgrade` | `id` | No | 13 |
| `GradeTemplatesMst` | `Emp_Gradmst` | `id` | Yes | 9 |
| `GradeTemplatesTrn` | `Emp_Gradtrn` | `id` | No | 12 |
| `LeaveRequest` | `Emp_Leavereq` | `id` | No | 17 |
| `Leaves` | `Emp_Leave` | `id` | No | 17 |
| `LoanPayments` | `Emp_Ploan` | `id` | No | 12 |
| `Loans` | `Emp_Loan` | `id` | No | 16 |
| `Missions` | `Emp_Msn` | `id` | No | 17 |
| `MissionsRequest` | `Emp_Msnreq` | `id` | No | 17 |
| `Outgoing` | `Emp_Out` | `id` | No | 10 |
| `OvertimeRequest` | `Emp_Otimereq` | `id` | No | 17 |
| `Overtimes` | `Emp_Otime` | `id` | No | 17 |
| `Recruitment` | `Emp_Recr` | `id` | No | 16 |
| `SalariesCalculation` | `Emp_Sal` | `id` | Yes | 9 |
| `SalariesCalculationView` | `Emp_Vsalcalc` | `id` | Yes | 90 |
| `SalaryAttendance` | `Emp_Salatt` | `id` | No | 18 |
| `SalaryCalculated` | `Emp_Salcalc` | `id` | Yes | 70 |
| `SalaryGroups` | `Emp_Salgrp` | `id` | No | 17 |
| `SalcalcAddon` | `Emp_Salcalcaosal` | `id` | No | 9 |
| `SalcalcCompensation` | `Emp_Salcalccomp` | `id` | No | 13 |
| `SalcalcConsideration` | `Emp_Salcalccon` | `id` | No | 13 |
| `SalcalcDebit` | `Emp_Salcalcdbt` | `id` | No | 11 |
| `SalcalcDeduction` | `Emp_Salcalcded` | `id` | No | 13 |
| `SalcalcLoans` | `Emp_Salcalcloan` | `id` | No | 10 |
| `SalcalcPunishment` | `Emp_Salcalcpun` | `id` | No | 14 |
| `SalcalcSubfrom` | `Emp_Salcalcsfsal` | `id` | No | 9 |
| `SubfromSalary` | `Emp_Sfsal` | `id` | Yes | 19 |
| `SubfromSalaryEmployees` | `Emp_Sfsalemp` | `id` | No | 10 |
| `TaxBracketsMaster` | `Emp_Taxbrkt` | `id` | Yes | 11 |
| `TaxBracketsTrans` | `Emp_Ttaxbrkt` | `id` | No | 10 |
| `TemporarySaldailyRep` | `Emp_Tmpsaldlyrep` | `id` | No | 5 |
| `TemporaryVacationRep` | `Emp_Tmpvacrep` | `id` | No | 8 |
| `WorkGroupDays` | `Emp_Dwrkgrp` | `id` | No | 42 |
| `WorkGroups` | `Emp_Wrkgrp` | `id` | Yes | 8 |

### Package: `Fin` (21 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `AllocateCredit` | `Fin_Talccrd` | `id` | No | 18 |
| `AllocateDebit` | `Fin_Alcdbt` | `id` | No | 18 |
| `AllocateMst` | `Fin_Malc` | `id` | No | 36 |
| `CodeContract` | `Fin_Cod_Contract` | `id` | No | 8 |
| `CodeKeytype` | `Fin_Cod_Keytype` | `id` | No | 8 |
| `CodeLineType` | `Fin_Cod_Ltype` | `id` | No | 8 |
| `CodeLocation` | `Fin_Cod_Loc` | `id` | No | 8 |
| `CodeMethod` | `Fin_Cod_Method` | `id` | No | 8 |
| `CodeStatus` | `Fin_Cod_Status` | `id` | No | 8 |
| `CodeTrt` | `Fin_Cod_Trt` | `id` | No | 8 |
| `CodeType` | `Fin_Cod_Type` | `id` | No | 8 |
| `CreditMst` | `Fin_Mcrd` | `id` | Yes | 34 |
| `CreditTrn` | `Fin_Tcrd` | `id` | No | 26 |
| `DebitMst` | `Fin_Mdbt` | `id` | Yes | 34 |
| `DebitTrn` | `Fin_Tdbt` | `id` | No | 25 |
| `ExpenseMst` | `Fin_Mexp` | `id` | Yes | 34 |
| `ExpenseTrn` | `Fin_Texp` | `id` | No | 26 |
| `FreInvoiceReportView` | `Fre_Vinvoice_Report` | `id` | No | 32 |
| `InvoiceMst` | `Fin_Minv` | `id` | Yes | 30 |
| `InvoiceTrn` | `Fin_Tinv` | `id` | No | 28 |
| `Reconcile` | `Fin_Mrec` | `id` | No | 44 |

### Package: `Fix` (32 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `ActualMaster` | `Fix_Actmst` | `id` | Yes | 11 |
| `ActualTrans` | `Fix_Acttrn` | `id` | No | 11 |
| `CodeLocation1` | `Fix_Cod_Loc1` | `id` | No | 8 |
| `CodeLocation2` | `Fix_Cod_Loc2` | `id` | No | 8 |
| `CodeLocation3` | `Fix_Cod_Loc3` | `id` | No | 8 |
| `CodeSpecification1` | `Fix_Cod_Spec1` | `id` | No | 8 |
| `CodeSpecification2` | `Fix_Cod_Spec2` | `id` | No | 8 |
| `CodeSpecification3` | `Fix_Cod_Spec3` | `id` | No | 8 |
| `CodeSpecification4` | `Fix_Cod_Spec4` | `id` | No | 8 |
| `CodeSpecification5` | `Fix_Cod_Spec5` | `id` | No | 8 |
| `CodeStatus` | `Fix_Cod_Status` | `id` | No | 8 |
| `FixedsItems` | `Fix_Fixed` | `id` | No | 19 |
| `FixedsItemsView` | `Fix_Vfixed` | `id` | No | 34 |
| `InboundView` | `Fix_Vindocs` | `id` | No | 82 |
| `InputMaster` | `Fix_Inmst` | `id` | Yes | 12 |
| `InputTrans` | `Fix_Intrn` | `id` | No | 33 |
| `LocationMaster` | `Fix_Locmst` | `id` | Yes | 9 |
| `LocationTrans` | `Fix_Loctrn` | `id` | No | 16 |
| `LocationView` | `Fix_Vlocdocs` | `id` | No | 90 |
| `OutboundView` | `Fix_Voudocs` | `id` | No | 97 |
| `OutputMaster` | `Fix_Oumst` | `id` | Yes | 12 |
| `OutputTrans` | `Fix_Outrn` | `id` | No | 21 |
| `ResponsibilityMaster` | `Fix_Resmst` | `id` | Yes | 11 |
| `ResponsibilityTrans` | `Fix_Restrn` | `id` | No | 11 |
| `ResponsibilityView` | `Fix_Vresdocs` | `id` | No | 85 |
| `SpecificationMaster` | `Fix_Spcmst` | `id` | Yes | 9 |
| `SpecificationTrans` | `Fix_Spctrn` | `id` | No | 24 |
| `SpecificationView` | `Fix_Vspcdocs` | `id` | No | 102 |
| `TempLabels` | `Fix_Tmplbl` | `id` | No | 7 |
| `TempTotalFixed` | `Fix_Temp` | `id` | No | 16 |
| `TotalCommit` | `Fix_Cmt` | `id` | No | 10 |
| `TotalFixed` | `Fix_Tot` | `id` | No | 18 |

### Package: `Fre` (92 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `ClrDbcrDocuments` | `Fre_Clr_Dbcr` | `id` | No | 34 |
| `ClrDbcrDocumentsView` | `Fre_Vclr_Dbcr` | `id` | No | 49 |
| `ClrJobFreight` | `Fre_Clr_Job` | `id` | Yes | 94 |
| `ClrJobFreightView` | `Fre_Vclr_Job` | `id` | No | 145 |
| `ClrTjobFreight` | `Fre_Clr_Tjob` | `id` | No | 29 |
| `CodeAirlines` | `Fre_Cod_Airline` | `id` | No | 8 |
| `CodeAirports` | `Fre_Cod_Airport` | `id` | No | 11 |
| `CodeApproveStatus` | `Fre_Cod_Approve` | `id` | No | 4 |
| `CodeCity` | `Fre_Cod_City` | `id` | No | 10 |
| `CodeCltype` | `Fre_Cod_Cltype` | `id` | No | 8 |
| `CodeCommodity` | `Fre_Cod_Comod` | `id` | No | 8 |
| `CodeContainerLoadType` | `Fre_Cod_Cl_Type` | `id` | No | 8 |
| `CodeContractKind` | `Fre_Cod_Contr_Kind` | `id` | No | 8 |
| `CodeCountry` | `Fre_Cod_Cntry` | `id` | Yes | 16 |
| `CodeIdoctype` | `Fre_Cod_Idoctype` | `id` | No | 8 |
| `CodeIncoTerm` | `Fre_Cod_Inco_Term` | `id` | No | 8 |
| `CodeJobStatus` | `Fre_Cod_Job_Status` | `id` | No | 4 |
| `CodeKdoctype` | `Fre_Cod_Kdoctype` | `id` | No | 8 |
| `CodeKind` | `Fre_Cod_Kind` | `id` | No | 8 |
| `CodeLanguage` | `Fre_Cod_Lang` | `id` | No | 9 |
| `CodeList` | `Fre_Cod_List` | `id` | No | 8 |
| `CodeLocation` | `Fre_Cod_Loc` | `id` | No | 8 |
| `CodeModuleType` | `Fre_Cod_Module_Type` | `id` | No | 4 |
| `CodeNationality` | `Fre_Cod_Nat` | `id` | No | 12 |
| `CodeOdoctype` | `Fre_Cod_Odoctype` | `id` | No | 8 |
| `CodeOperationsStatus` | `Fre_Cod_Oper_Status` | `id` | No | 4 |
| `CodePack` | `Fre_Cod_Pack` | `id` | No | 8 |
| `CodePaymentTerm` | `Fre_Cod_Pay_Term` | `id` | No | 8 |
| `CodeRoadlines` | `Fre_Cod_Roadline` | `id` | No | 8 |
| `CodeSeaports` | `Fre_Cod_Seaport` | `id` | No | 10 |
| `CodeShiplines` | `Fre_Cod_Shipline` | `id` | No | 8 |
| `CodeStatusType` | `Fre_Cod_Status_Type` | `id` | No | 4 |
| `CodeTltype` | `Fre_Cod_Tltype` | `id` | No | 8 |
| `CodeTrack` | `Fre_Cod_Track` | `id` | No | 8 |
| `CodeTrt` | `Fre_Cod_Trt` | `id` | No | 8 |
| `CodeTruckLoadType` | `Fre_Cod_Tl_Type` | `id` | No | 8 |
| `CodeTruckType` | `Fre_Cod_Truck_Type` | `id` | No | 8 |
| `CodeType` | `Fre_Cod_Type` | `id` | No | 8 |
| `CodeYesno` | `Fre_Cod_Yesno` | `id` | No | 4 |
| `ContactComodity` | `Fre_Cont_Comod` | `id` | No | 9 |
| `ContractDistance` | `Fre_Dcntrct` | `id` | No | 21 |
| `ContractMst` | `Fre_Mcntrct` | `id` | Yes | 41 |
| `ContractTrn` | `Fre_Tcntrct` | `id` | No | 32 |
| `DbcrDocumentsView` | `Fre_Vdbcr` | `id` | No | 50 |
| `DepartmentMstBudgets` | `Fre_Deptmbud` | `id` | No | 9 |
| `DepartmentTrnBudgets` | `Fre_Depttbud` | `id` | No | 14 |
| `DepartmentUnitServices` | `Fre_Duserv` | `id` | No | 10 |
| `Drivers` | `Fre_Driv` | `id` | No | 15 |
| `HousAirwabill` | `Fre_Hawb` | `id` | No | 34 |
| `IfrDbcrDocuments` | `Fre_Ifr_Dbcr` | `id` | No | 34 |
| `IfrDbcrDocumentsView` | `Fre_Vifr_Dbcr` | `id` | No | 43 |
| `IfrJobFreight` | `Fre_Ifr_Job` | `id` | Yes | 92 |
| `IfrJobFreightOffersView` | `Fre_Vifr_Job_Offers` | `id` | No | 144 |
| `IfrJobFreightView` | `Fre_Vifr_Job` | `id` | No | 137 |
| `IfrJobOffers` | `Fre_Ifr_JobOffer` | `id` | No | 9 |
| `IfrTjobFreight` | `Fre_Ifr_Tjob` | `id` | No | 29 |
| `InqryDBCR` | `Fre_Idbcr` | `id` | No | 19 |
| `InqueriesView` | `Fre_Vinqry` | `id` | No | 40 |
| `JobConsignees` | `Fre_Cons` | `id` | No | 7 |
| `JobContainers` | `Fre_Cntr` | `id` | No | 11 |
| `JobDbcrDocuments` | `Fre_Job_Dbcr` | `id` | No | 33 |
| `JobFreight` | `Fre_Job` | `id` | Yes | 133 |
| `JobHdocuments` | `Fre_Hdoc` | `id` | No | 7 |
| `JobItems` | `Fre_Job_Item` | `id` | No | 29 |
| `JobMdocuments` | `Fre_Mdoc` | `id` | No | 7 |
| `JobModules` | `Fre_Job_Module` | `id` | No | 33 |
| `JobOffers` | `Fre_Jobofer` | `id` | No | 9 |
| `JobQuotation` | `Fre_Job_Quot` | `id` | No | 9 |
| `JobShippers` | `Fre_Ship` | `id` | No | 7 |
| `JobShippersConsignees` | `Fre_Ship_Cons` | `id` | No | 8 |
| `LfrDbcrDocuments` | `Fre_Lfr_Dbcr` | `id` | No | 34 |
| `LfrDbcrDocumentsView` | `Fre_Vlfr_Dbcr` | `id` | No | 43 |
| `LfrJobFreight` | `Fre_Lfr_Job` | `id` | Yes | 94 |
| `LfrJobFreightView` | `Fre_Vlfr_Job` | `id` | No | 191 |
| `LfrJobOffers` | `Fre_Lfr_Jobofer` | `id` | No | 9 |
| `LfrTjobFreight` | `Fre_Lfr_Tjob` | `id` | No | 29 |
| `Minqueries` | `Fre_Minqry` | `id` | Yes | 42 |
| `Moffers` | `Fre_Moffer` | `id` | Yes | 58 |
| `OfferDbcr` | `Fre_Odbcr` | `id` | No | 19 |
| `OfferView` | `Fre_Voffer` | `id` | Yes | 104 |
| `Pinqueries` | `Fre_Pinqry` | `id` | No | 47 |
| `PlanRequestForQuotation` | `Fre_Plan_Rfq` | `id` | No | 47 |
| `QuotItems` | `Fre_Quot_Item` | `id` | No | 25 |
| `Quotation` | `Fre_Quot` | `id` | No | 58 |
| `QuotationDbcrDocuments` | `Fre_Quotation_Dbcr` | `id` | No | 19 |
| `RelatedJobFiles` | `Fre_Rjfs` | `id` | No | 9 |
| `RequestForQuotation` | `Fre_Mrfq` | `id` | No | 42 |
| `RequestForQuotationDbcr` | `Fre_Rfq_Dbcr` | `id` | No | 19 |
| `Tinqueries` | `Fre_Tinqry` | `id` | No | 23 |
| `TjobFreight` | `Fre_Tjob` | `id` | No | 29 |
| `Toffers` | `Fre_Toffer` | `id` | No | 25 |
| `Trucks` | `Fre_Truk` | `id` | No | 11 |

### Package: `Fund` (5 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `BoxView` | `Fund_Vbox` | `id` | No | 13 |
| `Boxes` | `Fund_Box` | `id` | No | 11 |
| `CodeType` | `Fund_Cod_Type` | `id` | No | 4 |
| `Diaries` | `Fund_Diary` | `id` | No | 17 |
| `DiaryView` | `Fund_Vdiary` | `id` | No | 32 |

### Package: `Mkm` (17 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Brands` | `Mkm_Brand` | `id` | No | 9 |
| `Categories` | `Mkm_Cat` | `id` | No | 12 |
| `CodeCity` | `Mkm_Cod_City` | `id` | No | 10 |
| `CodeCountry` | `Mkm_Cod_Cntry` | `id` | No | 16 |
| `CodeInstallmentStatus` | `Mkm_Cod_Istatus` | `id` | No | 8 |
| `CodeTicketStatus` | `Mkm_Cod_Tstatus` | `id` | No | 8 |
| `InstallmentsItems` | `Mkm_Inst_Items` | `id` | No | 9 |
| `MemberInstallments` | `Mkm_Minstallment` | `id` | Yes | 13 |
| `Members` | `Mkm_Member` | `id` | No | 20 |
| `ProdSerials` | `Mkm_Prod_Serial` | `id` | No | 10 |
| `Products` | `Mkm_Product` | `id` | Yes | 21 |
| `Sales` | `Mkm_Sale` | `id` | Yes | 10 |
| `SalesItems` | `Mkm_Sales_Item` | `id` | No | 10 |
| `Tickets` | `Mkm_Ticket` | `id` | No | 14 |
| `UserProfileView` | `Mkm_Vuser_Profile` | `id` | No | 22 |
| `WorkerInstallmentsView` | `Mkm_Vminstallment` | `id` | No | 36 |
| `WorkersView` | `Mkm_Vworker` | `id` | No | 36 |

### Package: `Mng` (26 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `CodeGroup` | `Mng_Cod_Grp` | `id` | Yes | 10 |
| `CodeItem` | `Mng_Cod_Itm` | `id` | No | 9 |
| `CodeSpecification0` | `Mng_Cod_Spec0` | `id` | No | 8 |
| `CodeSpecification1` | `Mng_Cod_Spec1` | `id` | No | 8 |
| `CodeSpecification2` | `Mng_Cod_Spec2` | `id` | No | 8 |
| `CodeSpecification3` | `Mng_Cod_Spec3` | `id` | No | 8 |
| `CodeSpecification4` | `Mng_Cod_Spec4` | `id` | No | 8 |
| `CodeSpecification5` | `Mng_Cod_Spec5` | `id` | No | 8 |
| `CodeSpecification6` | `Mng_Cod_Spec6` | `id` | No | 8 |
| `CodeSpecification7` | `Mng_Cod_Spec7` | `id` | No | 8 |
| `CodeSpecification8` | `Mng_Cod_Spec8` | `id` | No | 8 |
| `CodeSpecification9` | `Mng_Cod_Spec9` | `id` | No | 8 |
| `Contact` | `Mng_Cont` | `id` | Yes | 38 |
| `ContactBranche` | `Mng_Cont_Bran` | `id` | No | 15 |
| `ContactContact` | `Mng_Cont_Cont` | `id` | No | 15 |
| `ContactView` | `Mng_Vcont` | `id` | No | 40 |
| `Currency` | `Mng_Curn` | `id` | No | 12 |
| `CurrencyHistory` | `Mng_Curnhist` | `id` | No | 9 |
| `CurrencyHistoryView` | `Mng_Vcurnhist` | `id` | No | 12 |
| `Services` | `Mng_Serv` | `id` | No | 13 |
| `Supplier` | `Mng_Supp` | `id` | Yes | 18 |
| `SupplierBranche` | `Mng_Supp_Bran` | `id` | No | 14 |
| `SupplierClassification` | `Mng_Supp_Class` | `id` | No | 9 |
| `SupplierContact` | `Mng_Supp_Cont` | `id` | No | 16 |
| `UnitFormula` | `Mng_Unit_Form` | `id` | No | 11 |
| `Units` | `Mng_Unit` | `id` | No | 7 |

### Package: `Notif` (12 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `CodeContentType` | `Notif_Cod_Cont_Type` | `id` | No | 8 |
| `CodeDestinationType` | `Notif_Cod_Dest_Type` | `id` | No | 8 |
| `CodeEvents` | `Notif_Cod_Event` | `id` | No | 8 |
| `CodeFieldsKind` | `Notif_Cod_Fld_Kind` | `id` | No | 8 |
| `CodeType` | `Notif_Cod_Type` | `id` | No | 8 |
| `Notification` | `Notif_Notif` | `id` | No | 17 |
| `TableEventActions` | `Notif_Table_Event_Action` | `id` | No | 12 |
| `TableEventDescription` | `Notif_Table_Event_Descr` | `id` | No | 11 |
| `TableEventRecipients` | `Notif_Table_Event_Recip` | `id` | No | 12 |
| `TableEvents` | `Notif_Table_Evnt` | `id` | Yes | 13 |
| `Tables` | `Notif_Table` | `id` | Yes | 9 |
| `TablesFields` | `Notif_Table_Fld` | `id` | No | 10 |

### Package: `Ped` (34 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `AppointmentChange` | `Ped_App_Change` | `id` | No | 9 |
| `AppointmentResult` | `Ped_App_Res` | `id` | No | 11 |
| `AppointmentSched` | `Ped_App_Sched` | `id` | No | 16 |
| `AppointmentStatus` | `Ped_App_Status` | `id` | No | 8 |
| `AppointmentTestQuestions` | `Ped_App_Quest` | `id` | No | 10 |
| `AppointmentTests` | `Ped_App_Test` | `id` | Yes | 9 |
| `AppointmentType` | `Ped_App_Type` | `id` | No | 11 |
| `Appointments` | `Ped_App` | `id` | Yes | 25 |
| `Categories` | `Ped_Cats` | `id` | No | 9 |
| `CategoriesView` | `Ped_Vcats` | `id` | No | 4 |
| `CodeBirthType` | `Ped_Cod_Birth_Type` | `id` | No | 8 |
| `CodeGroup` | `Ped_Cod_Grp` | `id` | No | 8 |
| `CodePregnancyConditions` | `Ped_Cod_Pregnancy_Condition` | `id` | No | 8 |
| `CodePregnancyType` | `Ped_Cod_Pregnancy_Type` | `id` | No | 8 |
| `CodeQualityPerformance` | `Ped_Cod_Quality_Perf` | `id` | No | 8 |
| `Doctors` | `Ped_Doct` | `id` | No | 17 |
| `DoctorsAppointment` | `Ped_Doct_App` | `id` | No | 11 |
| `Lecturer` | `Ped_Lect` | `id` | No | 12 |
| `LecturerProgram` | `Ped_Lect_Prog` | `id` | No | 19 |
| `ProgramItem` | `Ped_Prog_Itm` | `id` | No | 10 |
| `Programs` | `Ped_Prog` | `id` | Yes | 8 |
| `QuestionsAnswers` | `Ped_Ques_Ans` | `id` | No | 9 |
| `Specials` | `Ped_Special` | `id` | No | 8 |
| `StudentSchedule` | `Ped_Std_Sched` | `id` | No | 13 |
| `StudentsLecturer` | `Ped_Std_Lect` | `id` | Yes | 11 |
| `TestCategories` | `Ped_Test_Cats` | `id` | No | 9 |
| `TestCategoriesView` | `Ped_Vtest_Cats` | `id` | No | 4 |
| `TestKeyView` | `Ped_Vtest_Key` | `id` | No | 35 |
| `TestKeys` | `Ped_Test_Key` | `id` | No | 39 |
| `TestQuestionSummaryView` | `Ped_Vtest_Question_Summary` | `id` | No | 16 |
| `TestQuestionView` | `Ped_Vtest_Question` | `id` | No | 19 |
| `TestQuestions` | `Ped_Test_Question` | `id` | No | 24 |
| `TestView` | `Ped_Vtest` | `id` | No | 3 |
| `Tests` | `Ped_Test` | `id` | Yes | 9 |

### Package: `Phs` (43 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `CodeAddressType` | `Phs_Cod_Addresstype` | `id` | No | 4 |
| `CodeAgeDays` | `Phs_Cod_AgeDays` | `id` | No | 4 |
| `CodeAmountType` | `Phs_Cod_Amttype` | `id` | No | 4 |
| `CodeApproveStatus` | `Phs_Cod_Approve` | `id` | No | 4 |
| `CodeBalanceMode` | `Phs_Cod_Blncmode` | `id` | No | 4 |
| `CodeCommitStatus` | `Phs_Cod_Commit` | `id` | No | 4 |
| `CodeCostMethod` | `Phs_Cod_Costmethod` | `id` | No | 4 |
| `CodeDashboardSubtype` | `Phs_Cod_Dash_Subtype` | `id` | No | 9 |
| `CodeDashboardType` | `Phs_Cod_Dash_Type` | `id` | No | 8 |
| `CodeDbcr` | `Phs_Cod_Dbcr` | `id` | No | 4 |
| `CodeDigits` | `Phs_Cod_Digit` | `id` | No | 4 |
| `CodeDirection` | `Phs_Cod_Dir` | `id` | No | 4 |
| `CodeGender` | `Phs_Cod_Gender` | `id` | No | 4 |
| `CodeIdType` | `Phs_Cod_IdType` | `id` | No | 4 |
| `CodeItemMethod` | `Phs_Cod_Itemmethod` | `id` | No | 4 |
| `CodeItemType` | `Phs_Cod_Itemtype` | `id` | No | 4 |
| `CodeLanguage` | `Phs_Cod_Lang` | `id` | No | 4 |
| `CodeMarital` | `Phs_Cod_Marital` | `id` | No | 4 |
| `CodeMilitaryStatus` | `Phs_Cod_Military` | `id` | No | 4 |
| `CodeMonth` | `Phs_Cod_Month` | `id` | No | 4 |
| `CodeOwnStatus` | `Phs_Cod_Ownstatus` | `id` | No | 4 |
| `CodePermission` | `Phs_Cod_Perm` | `id` | No | 4 |
| `CodeSign` | `Phs_Cod_Sign` | `id` | No | 4 |
| `CodeSource` | `Phs_Cod_Src` | `id` | No | 4 |
| `CodeSpecialStatus` | `Phs_Cod_SpecStatus` | `id` | No | 4 |
| `CodeStatus` | `Phs_Cod_Status` | `id` | No | 4 |
| `CodeSystem` | `Phs_Cod_System` | `id` | No | 4 |
| `CodeType` | `Phs_Cod_Type` | `id` | No | 4 |
| `CodeUsergrp` | `Phs_Cod_Ugrp` | `id` | No | 4 |
| `CodeVisible` | `Phs_Cod_Visible` | `id` | No | 4 |
| `CodeYesno` | `Phs_Cod_Yesno` | `id` | No | 4 |
| `DashboardBlocks` | `Phs_Dash_Blocks` | `id` | No | 17 |
| `DashboardBlocksView` | `Phs_Vdash_Block` | `id` | No | 20 |
| `Logs` | `Phs_Log` | `id` | No | 9 |
| `MenuPrograms` | `Phs_Mprg` | `id` | Yes | 11 |
| `Menus` | `Phs_Menu` | `id` | No | 5 |
| `MiprogramsView` | `Phs_Vmiprg` | `id` | No | 15 |
| `Mode` | `Phs_Mod` | `id` | No | 3 |
| `Preferences` | `Phs_Pref` | `id` | No | 6 |
| `Privileges` | `Phs_Priv` | `id` | No | 4 |
| `ProgramsPrivileges` | `Phs_Mprgpriv` | `id` | No | 4 |
| `ProgramsSpecprivileges` | `Phs_Mprgspriv` | `id` | No | 5 |
| `SpecialPrivileges` | `Phs_Specpriv` | `id` | No | 11 |

### Package: `Pms` (10 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `CodeStatus` | `Pms_Cod_Status` | `id` | No | 8 |
| `DeliveryMst` | `Pms_Mdeliv` | `id` | No | 13 |
| `DeliveryTrn` | `Pms_Tdeliv` | `id` | No | 13 |
| `DeliveryView` | `Pms_Vdelivery` | `id` | No | 23 |
| `PurchaseOrderMst` | `Pms_Mpurord` | `id` | No | 13 |
| `PurchaseOrderTrn` | `Pms_Tpurord` | `id` | No | 12 |
| `PurchaseOrderView` | `Pms_Vpurord` | `id` | No | 23 |
| `RequestMst` | `Pms_Mreq` | `id` | No | 11 |
| `RequestTrn` | `Pms_Treq` | `id` | No | 10 |
| `RequestView` | `Pms_Vrequest` | `id` | No | 15 |

### Package: `Prd` (37 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `CodeExecitionTime` | `Prd_Cod_Exec_Time` | `id` | No | 4 |
| `CodeFieldType` | `Prd_Cod_Fld_Type` | `id` | No | 4 |
| `CodeMachineCategory` | `Prd_Cod_Mchine_Cat` | `id` | No | 8 |
| `CodeProductionStatus` | `Prd_Cod_Prod_Status` | `id` | No | 4 |
| `CodeQualityAssuranceResult` | `Prd_Cod_Qa_Result` | `id` | No | 4 |
| `CodeStageType` | `Prd_Cod_Type` | `id` | No | 4 |
| `Expenses` | `Prd_Expense` | `id` | No | 10 |
| `Machines` | `Prd_Machine` | `id` | No | 14 |
| `OrderEmployeeWorkTimes` | `Prd_Oemp_Wtime` | `id` | No | 13 |
| `OrderExecutionStage` | `Prd_Oexec_Stage` | `id` | Yes | 13 |
| `OrderExecutionStageEmployeeJob` | `Prd_Oexec_Stage_Emp_Job` | `id` | No | 13 |
| `OrderExecutionStageExpenses` | `Prd_Oexec_Stage_Exp` | `id` | No | 14 |
| `OrderExecutionStageInsemiproduct` | `Prd_Oexec_Stage_Isemi` | `id` | No | 13 |
| `OrderExecutionStageMachineCategory` | `Prd_Oexec_Stage_Mach_Cat` | `id` | No | 14 |
| `OrderExecutionStageOusemiproduct` | `Prd_Oexec_Stage_Osemi` | `id` | No | 14 |
| `OrderExecutionStageProduct` | `Prd_Oexec_Stage_Prd` | `id` | No | 16 |
| `OrderExecutionStageQa` | `Prd_Oexec_Stage_Qa` | `id` | No | 12 |
| `OrderExecutionStageRawmaterial` | `Prd_Oexec_Stage_Raw` | `id` | No | 16 |
| `OrderExpense` | `Prd_Order_Exp` | `id` | No | 23 |
| `OrderMachineWorkTimes` | `Prd_Omachine_Wtime` | `id` | No | 13 |
| `OrderMst` | `Prd_Morder` | `id` | Yes | 9 |
| `OrderTrn` | `Prd_Torder` | `id` | Yes | 12 |
| `PlanMst` | `Prd_Mplan` | `id` | Yes | 8 |
| `PlanTrn` | `Prd_Tplan` | `id` | No | 10 |
| `ProductFormula` | `Prd_Form` | `id` | Yes | 11 |
| `ProductionStage` | `Prd_Stage` | `id` | Yes | 14 |
| `ProductoinStageEmployeeJob` | `Prd_Prod_Stage_Emp_Job` | `id` | No | 10 |
| `ProductoinStageExpenses` | `Prd_Prod_Stage_Exp` | `id` | No | 13 |
| `ProductoinStageInsemiproduct` | `Prd_Prod_Stage_Isemi` | `id` | No | 11 |
| `ProductoinStageMachineCategory` | `Prd_Prod_Stage_Mach_Cat` | `id` | No | 10 |
| `ProductoinStageOusemiproduct` | `Prd_Prod_Stage_Osemi` | `id` | No | 12 |
| `ProductoinStageProduct` | `Prd_Prod_Stage_Prd` | `id` | No | 14 |
| `ProductoinStageRawmaterial` | `Prd_Prod_Stage_Raw` | `id` | No | 14 |
| `QualityAssuranceChecklist` | `Prd_Qa_Checklist` | `id` | Yes | 10 |
| `QualityAssuranceChecklistItem` | `Prd_Qa_Item` | `id` | No | 15 |
| `QualityAssuranceField` | `Prd_Qa_Fld` | `id` | Yes | 17 |
| `QualityAssuranceFieldValues` | `Prd_Qa_Fld_Vals` | `id` | No | 10 |

### Package: `Proj` (25 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `CodeCustomerClass1` | `Proj_Cod_Cust_Class1` | `id` | No | 8 |
| `CodeCustomerClass2` | `Proj_Cod_Cust_Class2` | `id` | No | 8 |
| `CodeCustomerClass3` | `Proj_Cod_Cust_Class3` | `id` | No | 8 |
| `CodeCustomersCat` | `Proj_Cod_Cust_Cat` | `id` | No | 8 |
| `CodeMemberClass1` | `Proj_Cod_Member_Class1` | `id` | No | 8 |
| `CodeMemberClass2` | `Proj_Cod_Member_Class2` | `id` | No | 8 |
| `CodeMemberClass3` | `Proj_Cod_Member_Class3` | `id` | No | 8 |
| `CodePriority` | `Proj_Cod_Priority` | `id` | No | 8 |
| `CodeProjectClass1` | `Proj_Cod_Proj_Class1` | `id` | No | 8 |
| `CodeProjectClass2` | `Proj_Cod_Proj_Class2` | `id` | No | 8 |
| `CodeProjectClass3` | `Proj_Cod_Proj_Class3` | `id` | No | 8 |
| `CodeStatus` | `Proj_Cod_Status` | `id` | No | 8 |
| `CodeTypes` | `Proj_Cod_Type` | `id` | No | 8 |
| `Customers` | `Proj_Cust` | `id` | No | 13 |
| `FinCodeStatus` | `Proj_Fin_Cod_Status` | `id` | No | 8 |
| `FinCodeType` | `Proj_Fin_Cod_Type` | `id` | No | 8 |
| `InvoiceMst` | `Proj_Minv` | `id` | Yes | 15 |
| `InvoiceTrn` | `Proj_Tinv` | `id` | No | 18 |
| `Project` | `Proj_Proj` | `id` | Yes | 22 |
| `ProjectExpense` | `Proj_Proj_Expense` | `id` | No | 17 |
| `ProjectTeam` | `Proj_Proj_Team` | `id` | No | 10 |
| `ProjectTimesheet` | `Proj_Proj_Tsheet` | `id` | No | 20 |
| `TeamMembers` | `Proj_Team` | `id` | No | 15 |
| `TwitemTrn` | `Proj_Twitem` | `id` | Yes | 11 |
| `WorkitemMst` | `Proj_Mwitem` | `id` | Yes | 8 |

### Package: `Pur` (8 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `AllPurchaseView` | `Pur_Vallpurchase` | `id` | No | 101 |
| `CodeStatus` | `Pur_Cod_Status` | `id` | No | 8 |
| `PurchaseMst` | `Pur_Mpur` | `id` | Yes | 21 |
| `PurchaseTrn` | `Pur_Tpur` | `id` | No | 29 |
| `PurchaseView` | `Pur_Vpurchase` | `id` | No | 101 |
| `ReturnMst` | `Pur_Mret` | `id` | Yes | 21 |
| `ReturnTrn` | `Pur_Tret` | `id` | No | 29 |
| `ReturnView` | `Pur_Vreturn` | `id` | No | 101 |

### Package: `Sales` (9 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `AllSalesView` | `Sal_Vallsales` | `id` | No | 111 |
| `CodeCommission` | `Sal_Cod_Comm` | `id` | No | 7 |
| `CodeStatus` | `Sal_Cod_Status` | `id` | No | 8 |
| `ReturnMst` | `Sal_MRet` | `id` | Yes | 27 |
| `ReturnTrn` | `Sal_TRet` | `id` | No | 29 |
| `ReturnView` | `Sal_Vreturn` | `id` | No | 110 |
| `SalesMst` | `Sal_MSal` | `id` | Yes | 27 |
| `SalesTrn` | `Sal_TSal` | `id` | No | 29 |
| `SalesView` | `Sal_Vsales` | `id` | No | 110 |

### Package: `Sdesk` (25 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `AttachedFiles` | `Sdesk_Attach` | `id` | No | 12 |
| `Categories` | `Sdesk_Cat` | `id` | Yes | 10 |
| `CategoriesServiceView` | `Sdesk_Vcat_Serv` | `id` | No | 15 |
| `CategoryService` | `Sdesk_Cat_Serv` | `id` | No | 9 |
| `CodeAutoConversation` | `Sdesk_Cod_Auto_Conv` | `id` | No | 8 |
| `CodeRating` | `Sdesk_Cod_Rating` | `id` | No | 8 |
| `CodeSla` | `Sdesk_Cod_Sla` | `id` | No | 9 |
| `CodeTicketStatus` | `Sdesk_Cod_Tckt_Status` | `id` | No | 10 |
| `CodeUnit` | `Sdesk_Cod_Unit` | `id` | No | 8 |
| `CustomerRating` | `Sdesk_Cust_Rate` | `id` | No | 9 |
| `CustomerService` | `Sdesk_Cust_Serv` | `id` | No | 13 |
| `CustomerSla` | `Sdesk_Cust_Sla` | `id` | Yes | 10 |
| `CustomerSlaMatrix` | `Sdesk_Cust_Sla_Mtrx` | `id` | No | 15 |
| `CustomerSlaService` | `Sdesk_Cust_Sla_Serv` | `id` | No | 9 |
| `CustomerUser` | `Sdesk_Cust_User` | `id` | No | 9 |
| `Service` | `Sdesk_Serv` | `id` | No | 10 |
| `StaffMembers` | `Sdesk_Staff` | `id` | Yes | 8 |
| `StaffService` | `Sdesk_Staff_Serv` | `id` | No | 8 |
| `Subcategories` | `Sdesk_Subcat` | `id` | No | 11 |
| `Ticket` | `Sdesk_Tckt` | `id` | No | 21 |
| `TicketChangeStatus` | `Sdesk_Tckt_Chng_Status` | `id` | No | 15 |
| `TicketConversation` | `Sdesk_Tckt_Conv` | `id` | Yes | 12 |
| `TicketView` | `Sdesk_Vtckt` | `id` | No | 32 |
| `TicketsSlaChanges` | `Sdesk_Tckt_Sla_Chng` | `id` | No | 14 |
| `TicketsUserChanges` | `Sdesk_Tckt_User_Chng` | `id` | No | 13 |

### Package: `Stor` (65 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Accounts` | `Stor_Acc` | `id` | No | 13 |
| `ActualMaster` | `Stor_Actmst` | `id` | Yes | 14 |
| `ActualTrans` | `Stor_Acttrn` | `id` | No | 18 |
| `CategoriesAccounts` | `Stor_Cat_Acc` | `id` | No | 14 |
| `ChangeLocationMaster` | `Stor_Chlocmst` | `id` | No | 13 |
| `ChangeLocationTrans` | `Stor_Chloctrn` | `id` | No | 16 |
| `CodeColor` | `Stor_Cod_Color` | `id` | No | 8 |
| `CodeCost` | `Stor_Cod_Cost` | `id` | No | 8 |
| `CodeDocument` | `Stor_Cod_Doc` | `id` | No | 8 |
| `CodeGroup` | `Stor_Cod_Grp` | `id` | Yes | 10 |
| `CodeGroupItemView` | `Stor_Vcod_Grp_Itm` | `id` | No | 10 |
| `CodeItem` | `Stor_Cod_Itm` | `id` | No | 9 |
| `CodeLocation1` | `Stor_Cod_Loc1` | `id` | No | 8 |
| `CodeLocation2` | `Stor_Cod_Loc2` | `id` | No | 8 |
| `CodeLocation3` | `Stor_Cod_Loc3` | `id` | No | 8 |
| `CodeMethod` | `Stor_Cod_Method` | `id` | No | 19 |
| `CodeModel` | `Stor_Cod_Model` | `id` | No | 8 |
| `CodeOrderStatus` | `Stor_Cod_Ord_Status` | `id` | No | 8 |
| `CodeOwn` | `Stor_Cod_Own` | `id` | No | 8 |
| `CodeSize` | `Stor_Cod_Size` | `id` | No | 8 |
| `CodeTransactionType` | `Stor_Cod_Trntyp` | `id` | No | 8 |
| `CodeType` | `Stor_Cod_Type` | `id` | No | 8 |
| `CodeUnit` | `Stor_Cod_Unit` | `id` | No | 8 |
| `ExecuteInboundMaster` | `Stor_Eimst` | `id` | Yes | 18 |
| `ExecuteInboundTrans` | `Stor_Eitrn` | `id` | No | 35 |
| `ExecuteInboundView` | `Stor_Vexecinbound` | `id` | No | 89 |
| `ExecuteOrdersView` | `Stor_Vexec_Ords` | `id` | No | 89 |
| `ExecuteOutboundMaster` | `Stor_Eomst` | `id` | Yes | 20 |
| `ExecuteOutboundTrans` | `Stor_Eotrn` | `id` | No | 35 |
| `ExecuteOutboundView` | `Stor_Vexecoutbound` | `id` | No | 89 |
| `InboundMaster` | `Stor_Inmst` | `id` | Yes | 17 |
| `InboundOrderMaster` | `Stor_Inordmst` | `id` | Yes | 21 |
| `InboundOrderTrans` | `Stor_Inordtrn` | `id` | No | 28 |
| `InboundOrderView` | `Stor_Vinord` | `id` | No | 93 |
| `InboundTrans` | `Stor_Intrn` | `id` | No | 31 |
| `InboundView` | `Stor_Vinbound` | `id` | No | 87 |
| `ItemCategory` | `Stor_Item_Cat` | `id` | No | 10 |
| `ItemClasses` | `Stor_Item_Class` | `id` | No | 9 |
| `ItemClassesView` | `Stor_Vitem_Classes` | `id` | No | 57 |
| `ItemClassification` | `Stor_Ics` | `id` | Yes | 31 |
| `ItemClassificationView` | `Stor_Vics` | `id` | No | 75 |
| `ItemFormula` | `Stor_Itm_Form` | `id` | No | 9 |
| `ItemSpecification` | `Stor_Item_Spec` | `id` | No | 9 |
| `ItemView` | `Stor_Vitem` | `id` | No | 45 |
| `Items` | `Stor_Item` | `id` | Yes | 52 |
| `NumberOfOverLimit` | `Num_OverLimit` | `id` | No | 3 |
| `OrdersView` | `Stor_Vords` | `id` | No | 93 |
| `OutboundMaster` | `Stor_Oumst` | `id` | Yes | 17 |
| `OutboundOrderMaster` | `Stor_Ouordmst` | `id` | Yes | 21 |
| `OutboundOrderTrans` | `Stor_Ouordtrn` | `id` | No | 35 |
| `OutboundOrderView` | `Stor_Vouord` | `id` | No | 93 |
| `OutboundTrans` | `Stor_Outrn` | `id` | No | 24 |
| `OutboundView` | `Stor_Voutbound` | `id` | No | 87 |
| `StorItemClassification` | `Stor_Sics` | `id` | Yes | 25 |
| `StorItemClassificationView` | `Stor_Vsics` | `id` | No | 99 |
| `StoreAccounts` | `Stor_Str_Acc` | `id` | No | 14 |
| `StoreItemAccounts` | `Stor_Stritemacc` | `id` | No | 13 |
| `Stores` | `Stor_Store` | `id` | No | 23 |
| `StoresMateriales` | `Stor_Smat` | `id` | No | 19 |
| `StoresMaterialesAccounts` | `Stor_Smat_Acc` | `id` | No | 15 |
| `TransactionsView` | `Stor_Vtrans` | `id` | No | 87 |
| `TransferMaster` | `Stor_Trmst` | `id` | Yes | 15 |
| `TransferTrans` | `Stor_Trtrn` | `id` | No | 19 |
| `TransferView` | `Stor_Vtransfer` | `id` | No | 88 |
| `UnitFormula` | `Stor_Unit_Form` | `id` | No | 9 |

### Package: `Str` (22 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `ActualMaster` | `Str_Actmst` | `id` | Yes | 14 |
| `ActualTrans` | `Str_Acttrn` | `id` | No | 10 |
| `CodeDocument` | `Str_Cod_Doc` | `id` | No | 8 |
| `CodeLocation1` | `Str_Cod_Loc1` | `id` | No | 8 |
| `CodeLocation2` | `Str_Cod_Loc2` | `id` | No | 8 |
| `CodeLocation3` | `Str_Cod_Loc3` | `id` | No | 8 |
| `CodeSpecification1` | `Str_Cod_Spec1` | `id` | No | 8 |
| `CodeSpecification2` | `Str_Cod_Spec2` | `id` | No | 8 |
| `CodeSpecification3` | `Str_Cod_Spec3` | `id` | No | 8 |
| `CodeSpecification4` | `Str_Cod_Spec4` | `id` | No | 8 |
| `CodeSpecification5` | `Str_Cod_Spec5` | `id` | No | 8 |
| `CodeTransactionType` | `Str_Cod_Trntyp` | `id` | No | 8 |
| `DefaultAccounts` | `Str_Defacc` | `id` | No | 10 |
| `InputMaster` | `Str_Inmst` | `id` | Yes | 15 |
| `InputTrans` | `Str_Intrn` | `id` | No | 13 |
| `Items` | `Str_Item` | `id` | No | 15 |
| `OutputMaster` | `Str_Oumst` | `id` | Yes | 15 |
| `OutputTrans` | `Str_Outrn` | `id` | No | 13 |
| `Stores` | `Str_Store` | `id` | No | 13 |
| `StoresMateriales` | `Str_Smat` | `id` | No | 16 |
| `TransferMaster` | `Str_Trmst` | `id` | Yes | 12 |
| `TransferTrans` | `Str_Trtrn` | `id` | No | 13 |

### Package: `Trn` (22 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Balance` | `Trn_Bln` | `id` | Yes | 10 |
| `BalanceFees` | `Trn_Bln_Fee` | `id` | No | 9 |
| `BalanceMaster` | `Trn_Bln_Mst` | `id` | Yes | 24 |
| `BalancePenalties` | `Trn_Bln_Penalty` | `id` | No | 12 |
| `BalanceTransaction` | `Trn_Bln_Trn` | `id` | No | 14 |
| `BalanceUser` | `Trn_Bln_User` | `id` | No | 9 |
| `BalanceView` | `Trn_Vbln` | `id` | No | 10 |
| `BalancingMasterView` | `Trn_Vblncing_Mst` | `id` | No | 38 |
| `BalancingPayView` | `Trn_Vpay` | `id` | No | 38 |
| `BalancingView` | `Trn_Vblncing` | `id` | No | 47 |
| `ChangeLocation` | `Trn_Chloc` | `id` | No | 10 |
| `CodeFor` | `Trn_Cod_For` | `id` | No | 8 |
| `CodeLocation` | `Trn_Cod_Loc` | `id` | No | 8 |
| `CodeModel` | `Trn_Cod_Model` | `id` | Yes | 7 |
| `CodeModelDetails` | `Trn_Cod_Model_Detail` | `id` | No | 6 |
| `CodePaytype` | `Trn_Cod_Ptype` | `id` | No | 8 |
| `CodeReservation` | `Trn_Cod_Res` | `id` | No | 8 |
| `CodeType` | `Trn_Cod_Type` | `id` | No | 8 |
| `Fees` | `Trn_Fee` | `id` | No | 11 |
| `LeakyCars` | `Trn_Leak_Car` | `id` | No | 9 |
| `Penalties` | `Trn_Penalty` | `id` | No | 11 |
| `TotalBalancingView` | `Trn_Vtblncing` | `id` | No | 44 |


Total Registered Entities Across Application: **779 Entities**
