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

Registered Packages: **24 Packages**

### Package: `Acc` (28 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Acc_Account` | `Acc_Acc` | `id` | No | 14 |
| `Acc_Account_View` | `Acc_Vacc` | `id` | No | 16 |
| `Acc_Ages_Temporary` | `Acc_Tmpage` | `id` | No | 27 |
| `Acc_Bank_Master` | `Acc_Bank_Mst` | `id` | Yes | 11 |
| `Acc_Bank_Transaction` | `Acc_Bank_Trn` | `id` | No | 19 |
| `Acc_Budget_Master` | `Acc_Budmst` | `id` | Yes | 9 |
| `Acc_Budget_Transaction` | `Acc_Budtrn` | `id` | No | 11 |
| `Acc_Budget_View` | `Acc_Vbud` | `id` | No | 15 |
| `Acc_Close_Account` | `Acc_Close` | `id` | No | 8 |
| `Acc_Code_Amount_Side` | `Acc_Cod_Amtside` | `id` | No | 8 |
| `Acc_Code_Document` | `Acc_Cod_Doc` | `id` | No | 8 |
| `Acc_Code_Line_Type` | `Acc_Cod_Linetype` | `id` | No | 8 |
| `Acc_Code_Report_Amount` | `Acc_Cod_Repamt` | `id` | No | 8 |
| `Acc_Cost_Center_View` | `Acc_Vcost` | `id` | No | 12 |
| `Acc_Cost_Centers` | `Acc_Cost` | `id` | No | 11 |
| `Acc_Generate_Reports` | `Acc_Genrep` | `id` | No | 17 |
| `Acc_Grant_Account` | `Acc_Grantacc` | `id` | No | 8 |
| `Acc_Grant_Account_View` | `Acc_Vgrant` | `id` | No | 7 |
| `Acc_Master` | `Acc_Mst` | `id` | Yes | 16 |
| `Acc_Report` | `Acc_Rep` | `id` | Yes | 7 |
| `Acc_Report_Items` | `Acc_Repitm` | `id` | No | 16 |
| `Acc_Report_View` | `Acc_Vrep` | `id` | No | 30 |
| `Acc_Sumvoucher_View` | `Acc_Vsvoucher` | `id` | No | 27 |
| `Acc_Total` | `Acc_Tot` | `id` | Yes | 8 |
| `Acc_Total_Accounts` | `Acc_Totacc` | `id` | No | 12 |
| `Acc_Total_View` | `Acc_Vtot` | `id` | No | 13 |
| `Acc_Transaction` | `Acc_Trn` | `id` | No | 22 |
| `Acc_Voucher_View` | `Acc_Vvoucher` | `id` | No | 52 |

### Package: `Bank` (13 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Bank_Accounts` | `Bank_Acc` | `id` | No | 20 |
| `Bank_Code_Method` | `Bank_Cod_Method` | `id` | No | 8 |
| `Bank_Code_Status` | `Bank_Cod_Status` | `id` | No | 8 |
| `Bank_Code_Trt` | `Bank_Cod_Trt` | `id` | No | 8 |
| `Bank_Collection_Order` | `Bank_Cord` | `id` | No | 39 |
| `Bank_Deposit_Order` | `Bank_Dord` | `id` | No | 39 |
| `Bank_Dorder_Status` | `Bank_Dordstatus` | `id` | No | 9 |
| `Bank_Order_View` | `Bank_Vord` | `id` | No | 83 |
| `Bank_Payment_Order` | `Bank_Pord` | `id` | No | 39 |
| `Bank_Torder_Status` | `Bank_Tordstatus` | `id` | No | 9 |
| `Bank_Transfer_Order` | `Bank_Tord` | `id` | No | 58 |
| `Bank_Withdraw_Order` | `Bank_Word` | `id` | No | 39 |
| `Bank_Worder_Status` | `Bank_Wordstatus` | `id` | No | 9 |

### Package: `Cash` (18 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Cash_Advanced_Payment_Order` | `Cash_Apord` | `id` | No | 38 |
| `Cash_Advanced_Payment_Order_View` | `Cash_Vapord` | `id` | No | 61 |
| `Cash_Boxes` | `Cash_Box` | `id` | No | 14 |
| `Cash_Cashiers` | `Cash_Cash` | `id` | No | 11 |
| `Cash_Cashiers_Boxes_View` | `Cash_Vcash_Box` | `id` | No | 20 |
| `Cash_Code_City` | `Cash_Cod_City` | `id` | No | 8 |
| `Cash_Code_Method` | `Cash_Cod_Method` | `id` | No | 8 |
| `Cash_Code_Phnby` | `Cash_Cod_Phnby` | `id` | No | 8 |
| `Cash_Code_Status` | `Cash_Cod_Status` | `id` | No | 8 |
| `Cash_Code_Trt` | `Cash_Cod_Trt` | `id` | No | 8 |
| `Cash_Collection_Order` | `Cash_Cord` | `id` | No | 38 |
| `Cash_Collection_Order_View` | `Cash_Vcord` | `id` | No | 61 |
| `Cash_Exchange_Order_View` | `Cash_Veord` | `id` | No | 62 |
| `Cash_Order_View` | `Cash_Vord` | `id` | No | 52 |
| `Cash_Payment_Order` | `Cash_Pord` | `id` | No | 38 |
| `Cash_Payment_Order_View` | `Cash_Vpord` | `id` | No | 61 |
| `Cash_Transfer_Order` | `Cash_Tord` | `id` | No | 50 |
| `Cash_Transfer_Order_View` | `Cash_Vtord` | `id` | No | 46 |

### Package: `Clnc` (34 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Clnc_Appointment` | `Clnc_App` | `id` | No | 17 |
| `Clnc_Appointment_Change` | `Clnc_App_Change` | `id` | No | 9 |
| `Clnc_Appointment_Status` | `Clnc_App_Status` | `id` | No | 8 |
| `Clnc_Appointment_Type` | `Clnc_App_Type` | `id` | No | 11 |
| `Clnc_Appointment_View` | `Clnc_Vapp` | `id` | No | 77 |
| `Clnc_Category` | `Clnc_Cat` | `id` | Yes | 9 |
| `Clnc_Clinics` | `Clnc_Clinic` | `id` | No | 12 |
| `Clnc_Code_Discount` | `Clnc_Cod_Disc` | `id` | No | 7 |
| `Clnc_Code_Nationality` | `Clnc_Cod_Nat` | `id` | No | 8 |
| `Clnc_Code_Shift` | `Clnc_Cod_Shift` | `id` | No | 8 |
| `Clnc_Code_Vat` | `Clnc_Cod_Vat` | `id` | No | 7 |
| `Clnc_Discounts` | `Clnc_Disc` | `id` | No | 10 |
| `Clnc_Doctors` | `Clnc_Doctor` | `id` | No | 22 |
| `Clnc_Doctors_View` | `Clnc_Vdoctor` | `id` | No | 25 |
| `Clnc_Invoice_Treatments` | `Clnc_Invoice_Treat` | `id` | No | 7 |
| `Clnc_Invoices` | `Clnc_Invoice` | `id` | Yes | 13 |
| `Clnc_Laboratory` | `Clnc_Labor` | `id` | No | 11 |
| `Clnc_Laboratory_Receive` | `Clnc_Labor_Receive` | `id` | No | 13 |
| `Clnc_Laboratory_Send` | `Clnc_Labor_Send` | `id` | No | 13 |
| `Clnc_Lists` | `Clnc_List` | `id` | No | 8 |
| `Clnc_Patient_Note` | `Clnc_Pat_Note` | `id` | No | 9 |
| `Clnc_Patients` | `Clnc_Patient` | `id` | No | 22 |
| `Clnc_Patients_View` | `Clnc_Vpatient` | `id` | No | 24 |
| `Clnc_Payment` | `Clnc_Pay` | `id` | No | 11 |
| `Clnc_Payment_Type` | `Clnc_Pay_Type` | `id` | No | 7 |
| `Clnc_Procedures` | `Clnc_Proc` | `id` | No | 11 |
| `Clnc_Refunds` | `Clnc_Refund` | `id` | No | 10 |
| `Clnc_Specials` | `Clnc_Special` | `id` | No | 8 |
| `Clnc_Treatment` | `Clnc_Treat` | `id` | Yes | 12 |
| `Clnc_Treatment_Procedures` | `Clnc_Treat_Proc` | `id` | No | 16 |
| `Clnc_Treatment_Status` | `Clnc_Treat_Status` | `id` | No | 8 |
| `Clnc_Treatment_View` | `Clnc_Vtreat` | `id` | No | 83 |
| `Clnc_User_Clinics` | `Clnc_User_Clinic` | `id` | No | 7 |
| `Clnc_Worktimes` | `Clnc_Worktime` | `id` | No | 7 |

### Package: `Cpy` (51 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Copy_Alerts` | `Cpy_Alert` | `id` | No | 11 |
| `Copy_Attached_Files` | `Cpy_Attach` | `id` | No | 16 |
| `Copy_Branche_Preferences` | `Cpy_Bpref` | `id` | No | 12 |
| `Copy_Branche_View` | `Cpy_Vmbran` | `id` | No | 19 |
| `Copy_Branches` | `Cpy_Bran` | `id` | No | 18 |
| `Copy_Code_Document` | `Cpy_Cod_Doc` | `id` | No | 8 |
| `Copy_Code_Periodstatus` | `Cpy_Cod_Pstatus` | `id` | No | 8 |
| `Copy_Code_Print_Formats` | `Cpy_Cod_Print_Format` | `id` | No | 11 |
| `Copy_Code_Status` | `Cpy_Cod_Status` | `id` | No | 8 |
| `Copy_Code_Task_Action` | `Cpy_Cod_Task_Action` | `id` | No | 8 |
| `Copy_Code_Task_Priority` | `Cpy_Cod_Task_Priority` | `id` | No | 10 |
| `Copy_Code_Task_Privacy` | `Cpy_Cod_Task_Privacy` | `id` | No | 9 |
| `Copy_Code_Task_Status` | `Cpy_Cod_Task_Status` | `id` | No | 11 |
| `Copy_Code_Unit` | `Cpy_Cod_Unit` | `id` | No | 8 |
| `Copy_Dashboard_Permission` | `Cpy_Dash_Perm` | `id` | No | 4 |
| `Copy_Department_Unit` | `Cpy_Unit` | `id` | No | 10 |
| `Copy_Departments` | `Cpy_Dept` | `id` | No | 8 |
| `Copy_Finance_Documents` | `Cpy_Fdoc` | `id` | No | 11 |
| `Copy_Group_Permissions_View` | `Cpy_Vgperm` | `id` | Yes | 17 |
| `Copy_Menu_View` | `Cpy_Vmenu` | `id` | No | 4 |
| `Copy_Periods` | `Cpy_Period` | `id` | No | 11 |
| `Copy_Periods_View` | `Cpy_Vperiod` | `id` | No | 12 |
| `Copy_Permision` | `Cpy_Perm` | `id` | Yes | 11 |
| `Copy_Permision_Privileges` | `Cpy_Permpriv` | `id` | No | 8 |
| `Copy_Permision_Privileges_View` | `Cpy_Vgppriv` | `id` | No | 16 |
| `Copy_Permision_Specprivileges` | `Cpy_Permspriv` | `id` | No | 9 |
| `Copy_Permision_Specprivs_View` | `Cpy_Vgpspriv` | `id` | No | 18 |
| `Copy_Permission_Groups` | `Cpy_Pgrp` | `id` | Yes | 9 |
| `Copy_Preferences` | `Cpy_Pref` | `id` | No | 11 |
| `Copy_Speciallists` | `Cpy_Slist` | `id` | No | 8 |
| `Copy_Speciallists_View` | `Cpy_Vslist` | `id` | No | 16 |
| `Copy_Specialliststrn` | `Cpy_Tlist` | `id` | No | 8 |
| `Copy_Specpermission` | `Cpy_Specperm` | `id` | No | 8 |
| `Copy_Task` | `Cpy_Task` | `id` | Yes | 22 |
| `Copy_Task_Actions` | `Cpy_Task_Action` | `id` | No | 11 |
| `Copy_Task_Ratingmst` | `Cpy_Task_Ratemst` | `id` | Yes | 9 |
| `Copy_Task_Ratingtrn` | `Cpy_Task_Ratetrn` | `id` | No | 9 |
| `Copy_Task_Users` | `Cpy_Task_User` | `id` | No | 9 |
| `Copy_Tokens` | `Cpy_Token` | `id` | No | 14 |
| `Copy_Unit_Forward_Status` | `Cpy_Unit_Frwrd_Status` | `id` | No | 9 |
| `Copy_Unit_Operations` | `Cpy_Oper` | `id` | No | 9 |
| `Copy_Unit_Receive_Status` | `Cpy_Unit_Rec_Status` | `id` | No | 12 |
| `Copy_Unit_Receive_Status_View` | `Cpy_Vunit_Rec_Status` | `id` | No | 13 |
| `Copy_User_Dashboard_List` | `Cpy_UDBoard_List` | `id` | Yes | 9 |
| `Copy_User_Dashboard_List_Blocks` | `Cpy_UDBoard_List_Blks` | `id` | No | 11 |
| `Copy_User_Dashboard_List_Blocks_View` | `Cpy_Vudboard_List_Blks` | `id` | No | 31 |
| `Copy_User_Preferences` | `Cpy_Upref` | `id` | No | 12 |
| `Copy_User_Units` | `Cpy_User_Unit` | `id` | No | 9 |
| `Copy_Users` | `Cpy_User` | `id` | No | 14 |
| `Copy_Users_View` | `Cpy_Vuser` | `id` | No | 23 |
| `Dg_Administrative_Fees_View` | `Dg_Vadmin_Fees` | `id` | No | 9 |

### Package: `Crm` (12 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Crm_Code_Clearance` | `Crm_Cod_Clearance` | `id` | No | 8 |
| `Crm_Code_Group` | `Crm_Cod_Grp` | `id` | Yes | 10 |
| `Crm_Code_Item` | `Crm_Cod_Itm` | `id` | No | 9 |
| `Crm_Code_Kind` | `Crm_Cod_Kind` | `id` | No | 8 |
| `Crm_Code_Status` | `Crm_Cod_Status` | `id` | No | 8 |
| `Crm_Code_Type` | `Crm_Cod_Type` | `id` | No | 8 |
| `Crm_Contact` | `Crm_Cont` | `id` | Yes | 20 |
| `Crm_Contact_Branche` | `Crm_Cont_Bran` | `id` | No | 14 |
| `Crm_Contact_Classification` | `Crm_Cont_Class` | `id` | No | 9 |
| `Crm_Contact_Contact` | `Crm_Cont_Cont` | `id` | No | 16 |
| `Crm_Report_Master` | `Crm_Mrep` | `id` | No | 15 |
| `Crm_Representatives` | `Crm_Repr` | `id` | No | 13 |

### Package: `Emp` (118 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Emp_Accredited` | `Emp_Acr` | `id` | No | 7 |
| `Emp_Addon_Salary` | `Emp_Aosal` | `id` | Yes | 20 |
| `Emp_Addon_Salary_Employees` | `Emp_Aosalemp` | `id` | No | 10 |
| `Emp_Admin_Consideration_Mst` | `Emp_Madmcon` | `id` | Yes | 9 |
| `Emp_Admin_Consideration_Trn` | `Emp_Tadmcon` | `id` | No | 12 |
| `Emp_Admin_Consideration_View` | `Emp_Vadmcons` | `id` | No | 34 |
| `Emp_Admin_Punishment_Mst` | `Emp_Madmpun` | `id` | Yes | 9 |
| `Emp_Admin_Punishment_Trn` | `Emp_Tadmpun` | `id` | No | 12 |
| `Emp_Admin_Punishment_View` | `Emp_Vadmpun` | `id` | No | 34 |
| `Emp_Application` | `Emp_Appl` | `id` | No | 27 |
| `Emp_Application_Appliedfor` | `Emp_Appfor` | `id` | No | 8 |
| `Emp_Application_Appliedvia` | `Emp_Appvia` | `id` | No | 8 |
| `Emp_Application_Course` | `Emp_Appcourse` | `id` | No | 11 |
| `Emp_Application_Education` | `Emp_Appeduc` | `id` | No | 10 |
| `Emp_Application_Fitfor` | `Emp_Appfit` | `id` | No | 8 |
| `Emp_Application_Hrnote` | `Emp_Apphrnote` | `id` | No | 7 |
| `Emp_Application_Interviewer` | `Emp_Appviewer` | `id` | No | 9 |
| `Emp_Application_Job` | `Emp_Appjob` | `id` | No | 13 |
| `Emp_Application_Language` | `Emp_Applang` | `id` | No | 11 |
| `Emp_Application_References` | `Emp_Appref` | `id` | No | 10 |
| `Emp_Appraisal_Employee_Mst` | `Emp_Apprempmst` | `id` | Yes | 12 |
| `Emp_Appraisal_Employee_Trn` | `Emp_Appremptrn` | `id` | No | 9 |
| `Emp_Appraisal_Evaluation` | `Emp_Appreval` | `id` | No | 11 |
| `Emp_Appraisal_Notes` | `Emp_Apprnote` | `id` | No | 13 |
| `Emp_Appraisal_Templates_Mst` | `Emp_Apprmst` | `id` | Yes | 8 |
| `Emp_Appraisal_Templates_Trn` | `Emp_Apprtrn` | `id` | No | 10 |
| `Emp_Attendance` | `Emp_Att` | `id` | No | 9 |
| `Emp_Change_Salary` | `Emp_Csal` | `id` | Yes | 17 |
| `Emp_Change_Salary_Employees` | `Emp_Csalemp` | `id` | No | 11 |
| `Emp_Changesalary_Brackets_Mst` | `Emp_Mchsalbrkt` | `id` | Yes | 8 |
| `Emp_Changesalary_Brackets_Trn` | `Emp_Tchsalbrkt` | `id` | No | 11 |
| `Emp_Code_Affected` | `Emp_Cod_Aff` | `id` | No | 8 |
| `Emp_Code_Affected_Salary` | `Emp_Cod_Affsal` | `id` | No | 8 |
| `Emp_Code_App_Result` | `Emp_Cod_App_Result` | `id` | No | 8 |
| `Emp_Code_Appraisal_Grp` | `Emp_Cod_Appraisal_Grp` | `id` | No | 8 |
| `Emp_Code_Appraisal_Item` | `Emp_Cod_Appraisal_Item` | `id` | No | 8 |
| `Emp_Code_Attend_Type` | `Emp_Cod_Atttype` | `id` | No | 8 |
| `Emp_Code_Calcsalary` | `Emp_Cod_Calcsal` | `id` | No | 8 |
| `Emp_Code_Change_Type` | `Emp_Cod_Chngtype` | `id` | No | 8 |
| `Emp_Code_Com_Per` | `Emp_Cod_Com_Per` | `id` | No | 8 |
| `Emp_Code_Comtype` | `Emp_Cod_Comtype` | `id` | No | 8 |
| `Emp_Code_Consideration` | `Emp_Cod_Cons` | `id` | No | 8 |
| `Emp_Code_Department` | `Emp_Cod_Department` | `id` | No | 8 |
| `Emp_Code_Education` | `Emp_Cod_Edu` | `id` | No | 8 |
| `Emp_Code_Graddegree` | `Emp_Cod_Graddegree` | `id` | No | 8 |
| `Emp_Code_Gradgrp` | `Emp_Cod_Gradgrp` | `id` | No | 8 |
| `Emp_Code_History` | `Emp_Cod_Hist` | `id` | No | 8 |
| `Emp_Code_Job` | `Emp_Cod_Job` | `id` | No | 8 |
| `Emp_Code_Language` | `Emp_Cod_Lang` | `id` | No | 8 |
| `Emp_Code_Leave` | `Emp_Cod_Leave` | `id` | No | 8 |
| `Emp_Code_Level` | `Emp_Cod_Level` | `id` | No | 8 |
| `Emp_Code_Location` | `Emp_Cod_Location` | `id` | No | 8 |
| `Emp_Code_Mission` | `Emp_Cod_Msn` | `id` | No | 8 |
| `Emp_Code_Nationality` | `Emp_Cod_Nat` | `id` | No | 8 |
| `Emp_Code_Overtime` | `Emp_Cod_Overtime` | `id` | No | 8 |
| `Emp_Code_Punishment` | `Emp_Cod_Pun` | `id` | No | 8 |
| `Emp_Code_Section` | `Emp_Cod_Section` | `id` | No | 8 |
| `Emp_Code_Specification1` | `Emp_Cod_Spec1` | `id` | No | 8 |
| `Emp_Code_Specification2` | `Emp_Cod_Spec2` | `id` | No | 8 |
| `Emp_Code_Specification3` | `Emp_Cod_Spec3` | `id` | No | 8 |
| `Emp_Code_Specification4` | `Emp_Cod_Spec4` | `id` | No | 8 |
| `Emp_Code_Status` | `Emp_Cod_Status` | `id` | No | 8 |
| `Emp_Code_Taxpay` | `Emp_Cod_Taxpay` | `id` | No | 8 |
| `Emp_Code_Testmarks` | `Emp_Cod_Testmark` | `id` | No | 8 |
| `Emp_Code_Wgrp_Shift` | `Emp_Cod_Wgrp_Shift` | `id` | No | 8 |
| `Emp_Code_Wgrp_Type` | `Emp_Cod_Wgrp_Type` | `id` | No | 8 |
| `Emp_Compensation` | `Emp_Com` | `id` | No | 15 |
| `Emp_Daily` | `Emp_Day` | `id` | No | 8 |
| `Emp_Daily_Entout` | `Emp_Deo` | `id` | No | 64 |
| `Emp_Day_Attendance_File` | `Emp_Dayattfile` | `id` | No | 9 |
| `Emp_Debit` | `Emp_Dbt` | `id` | No | 10 |
| `Emp_Deduction` | `Emp_Ded` | `id` | No | 9 |
| `Emp_Emploee_History` | `Emp_Emphist` | `id` | No | 11 |
| `Emp_Employee` | `Emp_Emp` | `id` | No | 15 |
| `Emp_Employee_Compensation` | `Emp_Ecom` | `id` | No | 13 |
| `Emp_Employee_Daily_Entout` | `Emp_Edeo` | `id` | No | 35 |
| `Emp_Employee_Deduction` | `Emp_Eded` | `id` | No | 12 |
| `Emp_Employee_Deo_Fingerprint` | `Emp_Edeof` | `id` | No | 10 |
| `Emp_Employee_Deo_Merge` | `Emp_Edeom` | `id` | No | 14 |
| `Emp_Employee_Grade_Tmplt_View` | `Emp_Vempgradtmplt` | `id` | No | 8 |
| `Emp_Entrance` | `Emp_Ent` | `id` | No | 10 |
| `Emp_Finger_Print` | `Emp_Fngrprnt` | `id` | No | 11 |
| `Emp_Fingerprint_Logs` | `Emp_Fprint` | `id` | No | 11 |
| `Emp_Functional_Chart` | `Emp_Fchart` | `id` | No | 11 |
| `Emp_Grade_Change` | `Emp_Chgrade` | `id` | No | 13 |
| `Emp_Grade_Templates_Mst` | `Emp_Gradmst` | `id` | Yes | 9 |
| `Emp_Grade_Templates_Trn` | `Emp_Gradtrn` | `id` | No | 12 |
| `Emp_Leave_Request` | `Emp_Leavereq` | `id` | No | 17 |
| `Emp_Leaves` | `Emp_Leave` | `id` | No | 17 |
| `Emp_Loan_Payments` | `Emp_Ploan` | `id` | No | 12 |
| `Emp_Loans` | `Emp_Loan` | `id` | No | 16 |
| `Emp_Missions` | `Emp_Msn` | `id` | No | 17 |
| `Emp_Missions_Request` | `Emp_Msnreq` | `id` | No | 17 |
| `Emp_Outgoing` | `Emp_Out` | `id` | No | 10 |
| `Emp_Overtime_Request` | `Emp_Otimereq` | `id` | No | 17 |
| `Emp_Overtimes` | `Emp_Otime` | `id` | No | 17 |
| `Emp_Recruitment` | `Emp_Recr` | `id` | No | 16 |
| `Emp_Salaries_Calculation` | `Emp_Sal` | `id` | Yes | 9 |
| `Emp_Salaries_Calculation_View` | `Emp_Vsalcalc` | `id` | Yes | 90 |
| `Emp_Salary_Attendance` | `Emp_Salatt` | `id` | No | 18 |
| `Emp_Salary_Calculated` | `Emp_Salcalc` | `id` | Yes | 70 |
| `Emp_Salary_Groups` | `Emp_Salgrp` | `id` | No | 17 |
| `Emp_Salcalc_Addon` | `Emp_Salcalcaosal` | `id` | No | 9 |
| `Emp_Salcalc_Compensation` | `Emp_Salcalccomp` | `id` | No | 13 |
| `Emp_Salcalc_Consideration` | `Emp_Salcalccon` | `id` | No | 13 |
| `Emp_Salcalc_Debit` | `Emp_Salcalcdbt` | `id` | No | 11 |
| `Emp_Salcalc_Deduction` | `Emp_Salcalcded` | `id` | No | 13 |
| `Emp_Salcalc_Loans` | `Emp_Salcalcloan` | `id` | No | 10 |
| `Emp_Salcalc_Punishment` | `Emp_Salcalcpun` | `id` | No | 14 |
| `Emp_Salcalc_Subfrom` | `Emp_Salcalcsfsal` | `id` | No | 9 |
| `Emp_Subfrom_Salary` | `Emp_Sfsal` | `id` | Yes | 19 |
| `Emp_Subfrom_Salary_Employees` | `Emp_Sfsalemp` | `id` | No | 10 |
| `Emp_Tax_Brackets_Master` | `Emp_Taxbrkt` | `id` | Yes | 11 |
| `Emp_Tax_Brackets_Trans` | `Emp_Ttaxbrkt` | `id` | No | 10 |
| `Emp_Temporary_Saldaily_Rep` | `Emp_Tmpsaldlyrep` | `id` | No | 5 |
| `Emp_Temporary_Vacation_Rep` | `Emp_Tmpvacrep` | `id` | No | 8 |
| `Emp_Work_Group_Days` | `Emp_Dwrkgrp` | `id` | No | 42 |
| `Emp_Work_Groups` | `Emp_Wrkgrp` | `id` | Yes | 8 |

### Package: `Fin` (21 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Fin_Allocate_Credit` | `Fin_Talccrd` | `id` | No | 18 |
| `Fin_Allocate_Debit` | `Fin_Alcdbt` | `id` | No | 18 |
| `Fin_Allocate_Mst` | `Fin_Malc` | `id` | No | 36 |
| `Fin_Code_Contract` | `Fin_Cod_Contract` | `id` | No | 8 |
| `Fin_Code_Keytype` | `Fin_Cod_Keytype` | `id` | No | 8 |
| `Fin_Code_Line_Type` | `Fin_Cod_Ltype` | `id` | No | 8 |
| `Fin_Code_Location` | `Fin_Cod_Loc` | `id` | No | 8 |
| `Fin_Code_Method` | `Fin_Cod_Method` | `id` | No | 8 |
| `Fin_Code_Status` | `Fin_Cod_Status` | `id` | No | 8 |
| `Fin_Code_Trt` | `Fin_Cod_Trt` | `id` | No | 8 |
| `Fin_Code_Type` | `Fin_Cod_Type` | `id` | No | 8 |
| `Fin_Credit_Mst` | `Fin_Mcrd` | `id` | Yes | 34 |
| `Fin_Credit_Trn` | `Fin_Tcrd` | `id` | No | 26 |
| `Fin_Debit_Mst` | `Fin_Mdbt` | `id` | Yes | 34 |
| `Fin_Debit_Trn` | `Fin_Tdbt` | `id` | No | 25 |
| `Fin_Expense_Mst` | `Fin_Mexp` | `id` | Yes | 34 |
| `Fin_Expense_Trn` | `Fin_Texp` | `id` | No | 26 |
| `Fin_Invoice_Mst` | `Fin_Minv` | `id` | Yes | 30 |
| `Fin_Invoice_Trn` | `Fin_Tinv` | `id` | No | 28 |
| `Fin_Reconcile` | `Fin_Mrec` | `id` | No | 44 |
| `Fre_Invoice_Report_View` | `Fre_Vinvoice_Report` | `id` | No | 32 |

### Package: `Fix` (32 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Fix_Actual_Master` | `Fix_Actmst` | `id` | Yes | 11 |
| `Fix_Actual_Trans` | `Fix_Acttrn` | `id` | No | 11 |
| `Fix_Code_Location1` | `Fix_Cod_Loc1` | `id` | No | 8 |
| `Fix_Code_Location2` | `Fix_Cod_Loc2` | `id` | No | 8 |
| `Fix_Code_Location3` | `Fix_Cod_Loc3` | `id` | No | 8 |
| `Fix_Code_Specification1` | `Fix_Cod_Spec1` | `id` | No | 8 |
| `Fix_Code_Specification2` | `Fix_Cod_Spec2` | `id` | No | 8 |
| `Fix_Code_Specification3` | `Fix_Cod_Spec3` | `id` | No | 8 |
| `Fix_Code_Specification4` | `Fix_Cod_Spec4` | `id` | No | 8 |
| `Fix_Code_Specification5` | `Fix_Cod_Spec5` | `id` | No | 8 |
| `Fix_Code_Status` | `Fix_Cod_Status` | `id` | No | 8 |
| `Fix_Fixeds_Items` | `Fix_Fixed` | `id` | No | 19 |
| `Fix_Fixeds_Items_View` | `Fix_Vfixed` | `id` | No | 34 |
| `Fix_Inbound_View` | `Fix_Vindocs` | `id` | No | 82 |
| `Fix_Input_Master` | `Fix_Inmst` | `id` | Yes | 12 |
| `Fix_Input_Trans` | `Fix_Intrn` | `id` | No | 33 |
| `Fix_Location_Master` | `Fix_Locmst` | `id` | Yes | 9 |
| `Fix_Location_Trans` | `Fix_Loctrn` | `id` | No | 16 |
| `Fix_Location_View` | `Fix_Vlocdocs` | `id` | No | 90 |
| `Fix_Outbound_View` | `Fix_Voudocs` | `id` | No | 97 |
| `Fix_Output_Master` | `Fix_Oumst` | `id` | Yes | 12 |
| `Fix_Output_Trans` | `Fix_Outrn` | `id` | No | 21 |
| `Fix_Responsibility_Master` | `Fix_Resmst` | `id` | Yes | 11 |
| `Fix_Responsibility_Trans` | `Fix_Restrn` | `id` | No | 11 |
| `Fix_Responsibility_View` | `Fix_Vresdocs` | `id` | No | 85 |
| `Fix_Specification_Master` | `Fix_Spcmst` | `id` | Yes | 9 |
| `Fix_Specification_Trans` | `Fix_Spctrn` | `id` | No | 24 |
| `Fix_Specification_View` | `Fix_Vspcdocs` | `id` | No | 102 |
| `Fix_Temp_Labels` | `Fix_Tmplbl` | `id` | No | 7 |
| `Fix_Temp_Total_Fixed` | `Fix_Temp` | `id` | No | 16 |
| `Fix_Total_Commit` | `Fix_Cmt` | `id` | No | 10 |
| `Fix_Total_Fixed` | `Fix_Tot` | `id` | No | 18 |

### Package: `Fre` (92 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Fre_Clr_Dbcr_Documents` | `Fre_Clr_Dbcr` | `id` | No | 34 |
| `Fre_Clr_Dbcr_Documents_View` | `Fre_Vclr_Dbcr` | `id` | No | 49 |
| `Fre_Clr_Job_Freight` | `Fre_Clr_Job` | `id` | Yes | 94 |
| `Fre_Clr_Job_Freight_View` | `Fre_Vclr_Job` | `id` | No | 145 |
| `Fre_Clr_Tjob_Freight` | `Fre_Clr_Tjob` | `id` | No | 29 |
| `Fre_Code_Airlines` | `Fre_Cod_Airline` | `id` | No | 8 |
| `Fre_Code_Airports` | `Fre_Cod_Airport` | `id` | No | 11 |
| `Fre_Code_Approve_Status` | `Fre_Cod_Approve` | `id` | No | 4 |
| `Fre_Code_City` | `Fre_Cod_City` | `id` | No | 10 |
| `Fre_Code_Cltype` | `Fre_Cod_Cltype` | `id` | No | 8 |
| `Fre_Code_Commodity` | `Fre_Cod_Comod` | `id` | No | 8 |
| `Fre_Code_Container_Load_Type` | `Fre_Cod_Cl_Type` | `id` | No | 8 |
| `Fre_Code_Contract_Kind` | `Fre_Cod_Contr_Kind` | `id` | No | 8 |
| `Fre_Code_Country` | `Fre_Cod_Cntry` | `id` | Yes | 16 |
| `Fre_Code_Idoctype` | `Fre_Cod_Idoctype` | `id` | No | 8 |
| `Fre_Code_Inco_Term` | `Fre_Cod_Inco_Term` | `id` | No | 8 |
| `Fre_Code_Job_Status` | `Fre_Cod_Job_Status` | `id` | No | 4 |
| `Fre_Code_Kdoctype` | `Fre_Cod_Kdoctype` | `id` | No | 8 |
| `Fre_Code_Kind` | `Fre_Cod_Kind` | `id` | No | 8 |
| `Fre_Code_Language` | `Fre_Cod_Lang` | `id` | No | 9 |
| `Fre_Code_List` | `Fre_Cod_List` | `id` | No | 8 |
| `Fre_Code_Location` | `Fre_Cod_Loc` | `id` | No | 8 |
| `Fre_Code_Module_Type` | `Fre_Cod_Module_Type` | `id` | No | 4 |
| `Fre_Code_Nationality` | `Fre_Cod_Nat` | `id` | No | 12 |
| `Fre_Code_Odoctype` | `Fre_Cod_Odoctype` | `id` | No | 8 |
| `Fre_Code_Operations_Status` | `Fre_Cod_Oper_Status` | `id` | No | 4 |
| `Fre_Code_Pack` | `Fre_Cod_Pack` | `id` | No | 8 |
| `Fre_Code_Payment_Term` | `Fre_Cod_Pay_Term` | `id` | No | 8 |
| `Fre_Code_Roadlines` | `Fre_Cod_Roadline` | `id` | No | 8 |
| `Fre_Code_Seaports` | `Fre_Cod_Seaport` | `id` | No | 10 |
| `Fre_Code_Shiplines` | `Fre_Cod_Shipline` | `id` | No | 8 |
| `Fre_Code_Status_Type` | `Fre_Cod_Status_Type` | `id` | No | 4 |
| `Fre_Code_Tltype` | `Fre_Cod_Tltype` | `id` | No | 8 |
| `Fre_Code_Track` | `Fre_Cod_Track` | `id` | No | 8 |
| `Fre_Code_Trt` | `Fre_Cod_Trt` | `id` | No | 8 |
| `Fre_Code_Truck_Load_Type` | `Fre_Cod_Tl_Type` | `id` | No | 8 |
| `Fre_Code_Truck_Type` | `Fre_Cod_Truck_Type` | `id` | No | 8 |
| `Fre_Code_Type` | `Fre_Cod_Type` | `id` | No | 8 |
| `Fre_Code_Yesno` | `Fre_Cod_Yesno` | `id` | No | 4 |
| `Fre_Contact_Comodity` | `Fre_Cont_Comod` | `id` | No | 9 |
| `Fre_Contract_Distance` | `Fre_Dcntrct` | `id` | No | 21 |
| `Fre_Contract_Mst` | `Fre_Mcntrct` | `id` | Yes | 41 |
| `Fre_Contract_Trn` | `Fre_Tcntrct` | `id` | No | 32 |
| `Fre_Dbcr_Documents_View` | `Fre_Vdbcr` | `id` | No | 50 |
| `Fre_Department_Mst_Budgets` | `Fre_Deptmbud` | `id` | No | 9 |
| `Fre_Department_Trn_Budgets` | `Fre_Depttbud` | `id` | No | 14 |
| `Fre_Department_Unit_Services` | `Fre_Duserv` | `id` | No | 10 |
| `Fre_Drivers` | `Fre_Driv` | `id` | No | 15 |
| `Fre_Hous_Airwabill` | `Fre_Hawb` | `id` | No | 34 |
| `Fre_Ifr_Dbcr_Documents` | `Fre_Ifr_Dbcr` | `id` | No | 34 |
| `Fre_Ifr_Dbcr_Documents_View` | `Fre_Vifr_Dbcr` | `id` | No | 43 |
| `Fre_Ifr_Job_Freight` | `Fre_Ifr_Job` | `id` | Yes | 92 |
| `Fre_Ifr_Job_Freight_Offers_View` | `Fre_Vifr_Job_Offers` | `id` | No | 144 |
| `Fre_Ifr_Job_Freight_View` | `Fre_Vifr_Job` | `id` | No | 137 |
| `Fre_Ifr_Job_Offers` | `Fre_Ifr_JobOffer` | `id` | No | 9 |
| `Fre_Ifr_Tjob_Freight` | `Fre_Ifr_Tjob` | `id` | No | 29 |
| `Fre_Inqry_DBCR` | `Fre_Idbcr` | `id` | No | 19 |
| `Fre_Inqueries_View` | `Fre_Vinqry` | `id` | No | 40 |
| `Fre_Job_Consignees` | `Fre_Cons` | `id` | No | 7 |
| `Fre_Job_Containers` | `Fre_Cntr` | `id` | No | 11 |
| `Fre_Job_Dbcr_Documents` | `Fre_Job_Dbcr` | `id` | No | 33 |
| `Fre_Job_Freight` | `Fre_Job` | `id` | Yes | 133 |
| `Fre_Job_Hdocuments` | `Fre_Hdoc` | `id` | No | 7 |
| `Fre_Job_Items` | `Fre_Job_Item` | `id` | No | 29 |
| `Fre_Job_Mdocuments` | `Fre_Mdoc` | `id` | No | 7 |
| `Fre_Job_Modules` | `Fre_Job_Module` | `id` | No | 33 |
| `Fre_Job_Offers` | `Fre_Jobofer` | `id` | No | 9 |
| `Fre_Job_Quotation` | `Fre_Job_Quot` | `id` | No | 9 |
| `Fre_Job_Shippers` | `Fre_Ship` | `id` | No | 7 |
| `Fre_Job_Shippers_Consignees` | `Fre_Ship_Cons` | `id` | No | 8 |
| `Fre_Lfr_Dbcr_Documents` | `Fre_Lfr_Dbcr` | `id` | No | 34 |
| `Fre_Lfr_Dbcr_Documents_View` | `Fre_Vlfr_Dbcr` | `id` | No | 43 |
| `Fre_Lfr_Job_Freight` | `Fre_Lfr_Job` | `id` | Yes | 94 |
| `Fre_Lfr_Job_Freight_View` | `Fre_Vlfr_Job` | `id` | No | 191 |
| `Fre_Lfr_Job_Offers` | `Fre_Lfr_Jobofer` | `id` | No | 9 |
| `Fre_Lfr_Tjob_Freight` | `Fre_Lfr_Tjob` | `id` | No | 29 |
| `Fre_Minqueries` | `Fre_Minqry` | `id` | Yes | 42 |
| `Fre_Moffers` | `Fre_Moffer` | `id` | Yes | 58 |
| `Fre_Offer_Dbcr` | `Fre_Odbcr` | `id` | No | 19 |
| `Fre_Offer_View` | `Fre_Voffer` | `id` | Yes | 104 |
| `Fre_Pinqueries` | `Fre_Pinqry` | `id` | No | 47 |
| `Fre_Plan_Request_For_Quotation` | `Fre_Plan_Rfq` | `id` | No | 47 |
| `Fre_Quot_Items` | `Fre_Quot_Item` | `id` | No | 25 |
| `Fre_Quotation` | `Fre_Quot` | `id` | No | 58 |
| `Fre_Quotation_Dbcr_Documents` | `Fre_Quotation_Dbcr` | `id` | No | 19 |
| `Fre_Related_Job_Files` | `Fre_Rjfs` | `id` | No | 9 |
| `Fre_Request_For_Quotation` | `Fre_Mrfq` | `id` | No | 42 |
| `Fre_Request_For_Quotation_Dbcr` | `Fre_Rfq_Dbcr` | `id` | No | 19 |
| `Fre_Tinqueries` | `Fre_Tinqry` | `id` | No | 23 |
| `Fre_Tjob_Freight` | `Fre_Tjob` | `id` | No | 29 |
| `Fre_Toffers` | `Fre_Toffer` | `id` | No | 25 |
| `Fre_Trucks` | `Fre_Truk` | `id` | No | 11 |

### Package: `Fund` (5 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Fund_Box_View` | `Fund_Vbox` | `id` | No | 13 |
| `Fund_Boxes` | `Fund_Box` | `id` | No | 11 |
| `Fund_Code_Type` | `Fund_Cod_Type` | `id` | No | 4 |
| `Fund_Diaries` | `Fund_Diary` | `id` | No | 17 |
| `Fund_Diary_View` | `Fund_Vdiary` | `id` | No | 32 |

### Package: `Mng` (26 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Mng_Code_Group` | `Mng_Cod_Grp` | `id` | Yes | 10 |
| `Mng_Code_Item` | `Mng_Cod_Itm` | `id` | No | 9 |
| `Mng_Code_Specification0` | `Mng_Cod_Spec0` | `id` | No | 8 |
| `Mng_Code_Specification1` | `Mng_Cod_Spec1` | `id` | No | 8 |
| `Mng_Code_Specification2` | `Mng_Cod_Spec2` | `id` | No | 8 |
| `Mng_Code_Specification3` | `Mng_Cod_Spec3` | `id` | No | 8 |
| `Mng_Code_Specification4` | `Mng_Cod_Spec4` | `id` | No | 8 |
| `Mng_Code_Specification5` | `Mng_Cod_Spec5` | `id` | No | 8 |
| `Mng_Code_Specification6` | `Mng_Cod_Spec6` | `id` | No | 8 |
| `Mng_Code_Specification7` | `Mng_Cod_Spec7` | `id` | No | 8 |
| `Mng_Code_Specification8` | `Mng_Cod_Spec8` | `id` | No | 8 |
| `Mng_Code_Specification9` | `Mng_Cod_Spec9` | `id` | No | 8 |
| `Mng_Contact` | `Mng_Cont` | `id` | Yes | 38 |
| `Mng_Contact_Branche` | `Mng_Cont_Bran` | `id` | No | 15 |
| `Mng_Contact_Contact` | `Mng_Cont_Cont` | `id` | No | 15 |
| `Mng_Contact_View` | `Mng_Vcont` | `id` | No | 40 |
| `Mng_Currency` | `Mng_Curn` | `id` | No | 12 |
| `Mng_Currency_History` | `Mng_Curnhist` | `id` | No | 9 |
| `Mng_Currency_History_View` | `Mng_Vcurnhist` | `id` | No | 12 |
| `Mng_Services` | `Mng_Serv` | `id` | No | 13 |
| `Mng_Supplier` | `Mng_Supp` | `id` | Yes | 18 |
| `Mng_Supplier_Branche` | `Mng_Supp_Bran` | `id` | No | 14 |
| `Mng_Supplier_Classification` | `Mng_Supp_Class` | `id` | No | 9 |
| `Mng_Supplier_Contact` | `Mng_Supp_Cont` | `id` | No | 16 |
| `Mng_Unit_Formula` | `Mng_Unit_Form` | `id` | No | 11 |
| `Mng_Units` | `Mng_Unit` | `id` | No | 7 |

### Package: `Notif` (12 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Notif_Code_Content_Type` | `Notif_Cod_Cont_Type` | `id` | No | 8 |
| `Notif_Code_Destination_Type` | `Notif_Cod_Dest_Type` | `id` | No | 8 |
| `Notif_Code_Events` | `Notif_Cod_Event` | `id` | No | 8 |
| `Notif_Code_Fields_Kind` | `Notif_Cod_Fld_Kind` | `id` | No | 8 |
| `Notif_Code_Type` | `Notif_Cod_Type` | `id` | No | 8 |
| `Notif_Notification` | `Notif_Notif` | `id` | No | 17 |
| `Notif_Table_Event_Actions` | `Notif_Table_Event_Action` | `id` | No | 12 |
| `Notif_Table_Event_Description` | `Notif_Table_Event_Descr` | `id` | No | 11 |
| `Notif_Table_Event_Recipients` | `Notif_Table_Event_Recip` | `id` | No | 12 |
| `Notif_Table_Events` | `Notif_Table_Evnt` | `id` | Yes | 13 |
| `Notif_Tables` | `Notif_Table` | `id` | Yes | 9 |
| `Notif_Tables_Fields` | `Notif_Table_Fld` | `id` | No | 10 |

### Package: `Ped` (34 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Ped_Appointment_Change` | `Ped_App_Change` | `id` | No | 9 |
| `Ped_Appointment_Result` | `Ped_App_Res` | `id` | No | 11 |
| `Ped_Appointment_Sched` | `Ped_App_Sched` | `id` | No | 16 |
| `Ped_Appointment_Status` | `Ped_App_Status` | `id` | No | 8 |
| `Ped_Appointment_Test_Questions` | `Ped_App_Quest` | `id` | No | 10 |
| `Ped_Appointment_Tests` | `Ped_App_Test` | `id` | Yes | 9 |
| `Ped_Appointment_Type` | `Ped_App_Type` | `id` | No | 11 |
| `Ped_Appointments` | `Ped_App` | `id` | Yes | 25 |
| `Ped_Categories` | `Ped_Cats` | `id` | No | 9 |
| `Ped_Categories_View` | `Ped_Vcats` | `id` | No | 4 |
| `Ped_Code_Birth_Type` | `Ped_Cod_Birth_Type` | `id` | No | 8 |
| `Ped_Code_Group` | `Ped_Cod_Grp` | `id` | No | 8 |
| `Ped_Code_Pregnancy_Conditions` | `Ped_Cod_Pregnancy_Condition` | `id` | No | 8 |
| `Ped_Code_Pregnancy_Type` | `Ped_Cod_Pregnancy_Type` | `id` | No | 8 |
| `Ped_Code_Quality_Performance` | `Ped_Cod_Quality_Perf` | `id` | No | 8 |
| `Ped_Doctors` | `Ped_Doct` | `id` | No | 17 |
| `Ped_Doctors_Appointment` | `Ped_Doct_App` | `id` | No | 11 |
| `Ped_Lecturer` | `Ped_Lect` | `id` | No | 12 |
| `Ped_Lecturer_Program` | `Ped_Lect_Prog` | `id` | No | 19 |
| `Ped_Program_Item` | `Ped_Prog_Itm` | `id` | No | 10 |
| `Ped_Programs` | `Ped_Prog` | `id` | Yes | 8 |
| `Ped_Questions_Answers` | `Ped_Ques_Ans` | `id` | No | 9 |
| `Ped_Specials` | `Ped_Special` | `id` | No | 8 |
| `Ped_Student_Schedule` | `Ped_Std_Sched` | `id` | No | 13 |
| `Ped_Students_Lecturer` | `Ped_Std_Lect` | `id` | Yes | 11 |
| `Ped_Test_Categories` | `Ped_Test_Cats` | `id` | No | 9 |
| `Ped_Test_Categories_View` | `Ped_Vtest_Cats` | `id` | No | 4 |
| `Ped_Test_Key_View` | `Ped_Vtest_Key` | `id` | No | 35 |
| `Ped_Test_Keys` | `Ped_Test_Key` | `id` | No | 39 |
| `Ped_Test_Question_Summary_View` | `Ped_Vtest_Question_Summary` | `id` | No | 16 |
| `Ped_Test_Question_View` | `Ped_Vtest_Question` | `id` | No | 19 |
| `Ped_Test_Questions` | `Ped_Test_Question` | `id` | No | 24 |
| `Ped_Test__View` | `Ped_Vtest` | `id` | No | 3 |
| `Ped_Tests` | `Ped_Test` | `id` | Yes | 9 |

### Package: `Phs` (43 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Phs_Code_Address_Type` | `Phs_Cod_Addresstype` | `id` | No | 4 |
| `Phs_Code_Age_Days` | `Phs_Cod_AgeDays` | `id` | No | 4 |
| `Phs_Code_Amount_Type` | `Phs_Cod_Amttype` | `id` | No | 4 |
| `Phs_Code_Approve_Status` | `Phs_Cod_Approve` | `id` | No | 4 |
| `Phs_Code_Balance_Mode` | `Phs_Cod_Blncmode` | `id` | No | 4 |
| `Phs_Code_Commit_Status` | `Phs_Cod_Commit` | `id` | No | 4 |
| `Phs_Code_Cost_Method` | `Phs_Cod_Costmethod` | `id` | No | 4 |
| `Phs_Code_Dashboard_Subtype` | `Phs_Cod_Dash_Subtype` | `id` | No | 9 |
| `Phs_Code_Dashboard_Type` | `Phs_Cod_Dash_Type` | `id` | No | 8 |
| `Phs_Code_Dbcr` | `Phs_Cod_Dbcr` | `id` | No | 4 |
| `Phs_Code_Digits` | `Phs_Cod_Digit` | `id` | No | 4 |
| `Phs_Code_Direction` | `Phs_Cod_Dir` | `id` | No | 4 |
| `Phs_Code_Gender` | `Phs_Cod_Gender` | `id` | No | 4 |
| `Phs_Code_IdType` | `Phs_Cod_IdType` | `id` | No | 4 |
| `Phs_Code_Item_Method` | `Phs_Cod_Itemmethod` | `id` | No | 4 |
| `Phs_Code_Item_Type` | `Phs_Cod_Itemtype` | `id` | No | 4 |
| `Phs_Code_Language` | `Phs_Cod_Lang` | `id` | No | 4 |
| `Phs_Code_Marital` | `Phs_Cod_Marital` | `id` | No | 4 |
| `Phs_Code_Military_Status` | `Phs_Cod_Military` | `id` | No | 4 |
| `Phs_Code_Month` | `Phs_Cod_Month` | `id` | No | 4 |
| `Phs_Code_Own_Status` | `Phs_Cod_Ownstatus` | `id` | No | 4 |
| `Phs_Code_Permission` | `Phs_Cod_Perm` | `id` | No | 4 |
| `Phs_Code_Sign` | `Phs_Cod_Sign` | `id` | No | 4 |
| `Phs_Code_Source` | `Phs_Cod_Src` | `id` | No | 4 |
| `Phs_Code_Special_Status` | `Phs_Cod_SpecStatus` | `id` | No | 4 |
| `Phs_Code_Status` | `Phs_Cod_Status` | `id` | No | 4 |
| `Phs_Code_System` | `Phs_Cod_System` | `id` | No | 4 |
| `Phs_Code_Type` | `Phs_Cod_Type` | `id` | No | 4 |
| `Phs_Code_Usergrp` | `Phs_Cod_Ugrp` | `id` | No | 4 |
| `Phs_Code_Visible` | `Phs_Cod_Visible` | `id` | No | 4 |
| `Phs_Code_Yesno` | `Phs_Cod_Yesno` | `id` | No | 4 |
| `Phs_Dashboard_Blocks` | `Phs_Dash_Blocks` | `id` | No | 17 |
| `Phs_Dashboard_Blocks_View` | `Phs_Vdash_Block` | `id` | No | 20 |
| `Phs_Logs` | `Phs_Log` | `id` | No | 9 |
| `Phs_Menu_Programs` | `Phs_Mprg` | `id` | Yes | 11 |
| `Phs_Menus` | `Phs_Menu` | `id` | No | 5 |
| `Phs_Miprograms_View` | `Phs_Vmiprg` | `id` | No | 15 |
| `Phs_Mode` | `Phs_Mod` | `id` | No | 3 |
| `Phs_Preferences` | `Phs_Pref` | `id` | No | 6 |
| `Phs_Privileges` | `Phs_Priv` | `id` | No | 4 |
| `Phs_Programs_Privileges` | `Phs_Mprgpriv` | `id` | No | 4 |
| `Phs_Programs_Specprivileges` | `Phs_Mprgspriv` | `id` | No | 5 |
| `Phs_Special_Privileges` | `Phs_Specpriv` | `id` | No | 11 |

### Package: `Pms` (10 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Pms_Code_Status` | `Pms_Cod_Status` | `id` | No | 8 |
| `Pms_Delivery_Mst` | `Pms_Mdeliv` | `id` | No | 13 |
| `Pms_Delivery_Trn` | `Pms_Tdeliv` | `id` | No | 13 |
| `Pms_Delivery_View` | `Pms_Vdelivery` | `id` | No | 23 |
| `Pms_Purchase_Order_Mst` | `Pms_Mpurord` | `id` | No | 13 |
| `Pms_Purchase_Order_Trn` | `Pms_Tpurord` | `id` | No | 12 |
| `Pms_Purchase_Order_View` | `Pms_Vpurord` | `id` | No | 23 |
| `Pms_Request_Mst` | `Pms_Mreq` | `id` | No | 11 |
| `Pms_Request_Trn` | `Pms_Treq` | `id` | No | 10 |
| `Pms_Request_View` | `Pms_Vrequest` | `id` | No | 15 |

### Package: `Prd` (37 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Prd_Code_Execition_Time` | `Prd_Cod_Exec_Time` | `id` | No | 4 |
| `Prd_Code_Field_Type` | `Prd_Cod_Fld_Type` | `id` | No | 4 |
| `Prd_Code_Machine_Category` | `Prd_Cod_Mchine_Cat` | `id` | No | 8 |
| `Prd_Code_Production_Status` | `Prd_Cod_Prod_Status` | `id` | No | 4 |
| `Prd_Code_Quality_Assurance_Result` | `Prd_Cod_Qa_Result` | `id` | No | 4 |
| `Prd_Code_Stage_Type` | `Prd_Cod_Type` | `id` | No | 4 |
| `Prd_Expenses` | `Prd_Expense` | `id` | No | 10 |
| `Prd_Machines` | `Prd_Machine` | `id` | No | 14 |
| `Prd_Order_Employee_Work_Times` | `Prd_Oemp_Wtime` | `id` | No | 13 |
| `Prd_Order_Execution_Stage` | `Prd_Oexec_Stage` | `id` | Yes | 13 |
| `Prd_Order_Execution_Stage_Employee_Job` | `Prd_Oexec_Stage_Emp_Job` | `id` | No | 13 |
| `Prd_Order_Execution_Stage_Expenses` | `Prd_Oexec_Stage_Exp` | `id` | No | 14 |
| `Prd_Order_Execution_Stage_Insemiproduct` | `Prd_Oexec_Stage_Isemi` | `id` | No | 13 |
| `Prd_Order_Execution_Stage_Machine_Category` | `Prd_Oexec_Stage_Mach_Cat` | `id` | No | 14 |
| `Prd_Order_Execution_Stage_Ousemiproduct` | `Prd_Oexec_Stage_Osemi` | `id` | No | 14 |
| `Prd_Order_Execution_Stage_Product` | `Prd_Oexec_Stage_Prd` | `id` | No | 16 |
| `Prd_Order_Execution_Stage_Qa` | `Prd_Oexec_Stage_Qa` | `id` | No | 12 |
| `Prd_Order_Execution_Stage_Rawmaterial` | `Prd_Oexec_Stage_Raw` | `id` | No | 16 |
| `Prd_Order_Expense` | `Prd_Order_Exp` | `id` | No | 23 |
| `Prd_Order_Machine_Work_Times` | `Prd_Omachine_Wtime` | `id` | No | 13 |
| `Prd_Order_Mst` | `Prd_Morder` | `id` | Yes | 9 |
| `Prd_Order_Trn` | `Prd_Torder` | `id` | Yes | 12 |
| `Prd_Plan_Mst` | `Prd_Mplan` | `id` | Yes | 8 |
| `Prd_Plan_Trn` | `Prd_Tplan` | `id` | No | 10 |
| `Prd_Product_Formula` | `Prd_Form` | `id` | Yes | 11 |
| `Prd_Production_Stage` | `Prd_Stage` | `id` | Yes | 14 |
| `Prd_Productoin_Stage_Employee_Job` | `Prd_Prod_Stage_Emp_Job` | `id` | No | 10 |
| `Prd_Productoin_Stage_Expenses` | `Prd_Prod_Stage_Exp` | `id` | No | 13 |
| `Prd_Productoin_Stage_Insemiproduct` | `Prd_Prod_Stage_Isemi` | `id` | No | 11 |
| `Prd_Productoin_Stage_Machine_Category` | `Prd_Prod_Stage_Mach_Cat` | `id` | No | 10 |
| `Prd_Productoin_Stage_Ousemiproduct` | `Prd_Prod_Stage_Osemi` | `id` | No | 12 |
| `Prd_Productoin_Stage_Product` | `Prd_Prod_Stage_Prd` | `id` | No | 14 |
| `Prd_Productoin_Stage_Rawmaterial` | `Prd_Prod_Stage_Raw` | `id` | No | 14 |
| `Prd_Quality_Assurance_Checklist` | `Prd_Qa_Checklist` | `id` | Yes | 10 |
| `Prd_Quality_Assurance_Checklist_Item` | `Prd_Qa_Item` | `id` | No | 15 |
| `Prd_Quality_Assurance_Field` | `Prd_Qa_Fld` | `id` | Yes | 17 |
| `Prd_Quality_Assurance_Field_Values` | `Prd_Qa_Fld_Vals` | `id` | No | 10 |

### Package: `Proj` (25 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Proj_Code_Customer_Class1` | `Proj_Cod_Cust_Class1` | `id` | No | 8 |
| `Proj_Code_Customer_Class2` | `Proj_Cod_Cust_Class2` | `id` | No | 8 |
| `Proj_Code_Customer_Class3` | `Proj_Cod_Cust_Class3` | `id` | No | 8 |
| `Proj_Code_Customers_Cat` | `Proj_Cod_Cust_Cat` | `id` | No | 8 |
| `Proj_Code_Member_Class1` | `Proj_Cod_Member_Class1` | `id` | No | 8 |
| `Proj_Code_Member_Class2` | `Proj_Cod_Member_Class2` | `id` | No | 8 |
| `Proj_Code_Member_Class3` | `Proj_Cod_Member_Class3` | `id` | No | 8 |
| `Proj_Code_Priority` | `Proj_Cod_Priority` | `id` | No | 8 |
| `Proj_Code_Project_Class1` | `Proj_Cod_Proj_Class1` | `id` | No | 8 |
| `Proj_Code_Project_Class2` | `Proj_Cod_Proj_Class2` | `id` | No | 8 |
| `Proj_Code_Project_Class3` | `Proj_Cod_Proj_Class3` | `id` | No | 8 |
| `Proj_Code_Status` | `Proj_Cod_Status` | `id` | No | 8 |
| `Proj_Code_Types` | `Proj_Cod_Type` | `id` | No | 8 |
| `Proj_Customers` | `Proj_Cust` | `id` | No | 13 |
| `Proj_Fin_Code_Status` | `Proj_Fin_Cod_Status` | `id` | No | 8 |
| `Proj_Fin_Code_Type` | `Proj_Fin_Cod_Type` | `id` | No | 8 |
| `Proj_Invoice_Mst` | `Proj_Minv` | `id` | Yes | 15 |
| `Proj_Invoice_Trn` | `Proj_Tinv` | `id` | No | 18 |
| `Proj_Project` | `Proj_Proj` | `id` | Yes | 22 |
| `Proj_Project_Expense` | `Proj_Proj_Expense` | `id` | No | 17 |
| `Proj_Project_Team` | `Proj_Proj_Team` | `id` | No | 10 |
| `Proj_Project_Timesheet` | `Proj_Proj_Tsheet` | `id` | No | 20 |
| `Proj_Team_Members` | `Proj_Team` | `id` | No | 15 |
| `Proj_Twitem_Trn` | `Proj_Twitem` | `id` | Yes | 11 |
| `Proj_Workitem_Mst` | `Proj_Mwitem` | `id` | Yes | 8 |

### Package: `Pur` (8 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Pur_All_Purchase_View` | `Pur_Vallpurchase` | `id` | No | 101 |
| `Pur_Code_Status` | `Pur_Cod_Status` | `id` | No | 8 |
| `Pur_Purchase_Mst` | `Pur_Mpur` | `id` | Yes | 21 |
| `Pur_Purchase_Trn` | `Pur_Tpur` | `id` | No | 29 |
| `Pur_Purchase_View` | `Pur_Vpurchase` | `id` | No | 101 |
| `Pur_Return_Mst` | `Pur_Mret` | `id` | Yes | 21 |
| `Pur_Return_Trn` | `Pur_Tret` | `id` | No | 29 |
| `Pur_Return_View` | `Pur_Vreturn` | `id` | No | 101 |

### Package: `Sales` (9 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Sal_All_Sales_View` | `Sal_Vallsales` | `id` | No | 111 |
| `Sal_Code_Commission` | `Sal_Cod_Comm` | `id` | No | 7 |
| `Sal_Code_Status` | `Sal_Cod_Status` | `id` | No | 8 |
| `Sal_Return_Mst` | `Sal_MRet` | `id` | Yes | 27 |
| `Sal_Return_Trn` | `Sal_TRet` | `id` | No | 29 |
| `Sal_Return_View` | `Sal_Vreturn` | `id` | No | 110 |
| `Sal_Sales_Mst` | `Sal_MSal` | `id` | Yes | 27 |
| `Sal_Sales_Trn` | `Sal_TSal` | `id` | No | 29 |
| `Sal_Sales_View` | `Sal_Vsales` | `id` | No | 110 |

### Package: `Sdesk` (25 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Sdesk_Attached_Files` | `Sdesk_Attach` | `id` | No | 12 |
| `Sdesk_Categories` | `Sdesk_Cat` | `id` | Yes | 10 |
| `Sdesk_Categories_Service_View` | `Sdesk_Vcat_Serv` | `id` | No | 15 |
| `Sdesk_Category_Service` | `Sdesk_Cat_Serv` | `id` | No | 9 |
| `Sdesk_Code_Auto_Conversation` | `Sdesk_Cod_Auto_Conv` | `id` | No | 8 |
| `Sdesk_Code_Rating` | `Sdesk_Cod_Rating` | `id` | No | 8 |
| `Sdesk_Code_Sla` | `Sdesk_Cod_Sla` | `id` | No | 9 |
| `Sdesk_Code_Ticket_Status` | `Sdesk_Cod_Tckt_Status` | `id` | No | 10 |
| `Sdesk_Code_Unit` | `Sdesk_Cod_Unit` | `id` | No | 8 |
| `Sdesk_Customer_Rating` | `Sdesk_Cust_Rate` | `id` | No | 9 |
| `Sdesk_Customer_Service` | `Sdesk_Cust_Serv` | `id` | No | 13 |
| `Sdesk_Customer_Sla` | `Sdesk_Cust_Sla` | `id` | Yes | 10 |
| `Sdesk_Customer_Sla_Matrix` | `Sdesk_Cust_Sla_Mtrx` | `id` | No | 15 |
| `Sdesk_Customer_Sla_Service` | `Sdesk_Cust_Sla_Serv` | `id` | No | 9 |
| `Sdesk_Customer_User` | `Sdesk_Cust_User` | `id` | No | 9 |
| `Sdesk_Service` | `Sdesk_Serv` | `id` | No | 10 |
| `Sdesk_Staff_Members` | `Sdesk_Staff` | `id` | Yes | 8 |
| `Sdesk_Staff_Service` | `Sdesk_Staff_Serv` | `id` | No | 8 |
| `Sdesk_Subcategories` | `Sdesk_Subcat` | `id` | No | 11 |
| `Sdesk_Ticket` | `Sdesk_Tckt` | `id` | No | 21 |
| `Sdesk_Ticket_Change_Status` | `Sdesk_Tckt_Chng_Status` | `id` | No | 15 |
| `Sdesk_Ticket_Conversation` | `Sdesk_Tckt_Conv` | `id` | Yes | 12 |
| `Sdesk_Ticket_View` | `Sdesk_Vtckt` | `id` | No | 32 |
| `Sdesk_Tickets_Sla_Changes` | `Sdesk_Tckt_Sla_Chng` | `id` | No | 14 |
| `Sdesk_Tickets_User_Changes` | `Sdesk_Tckt_User_Chng` | `id` | No | 13 |

### Package: `Stor` (65 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Number_Of_OverLimit` | `Num_OverLimit` | `id` | No | 3 |
| `Stor_Accounts` | `Stor_Acc` | `id` | No | 13 |
| `Stor_Actual_Master` | `Stor_Actmst` | `id` | Yes | 14 |
| `Stor_Actual_Trans` | `Stor_Acttrn` | `id` | No | 18 |
| `Stor_Categories_Accounts` | `Stor_Cat_Acc` | `id` | No | 14 |
| `Stor_Change_Location_Master` | `Stor_Chlocmst` | `id` | No | 13 |
| `Stor_Change_Location_Trans` | `Stor_Chloctrn` | `id` | No | 16 |
| `Stor_Code_Color` | `Stor_Cod_Color` | `id` | No | 8 |
| `Stor_Code_Cost` | `Stor_Cod_Cost` | `id` | No | 8 |
| `Stor_Code_Document` | `Stor_Cod_Doc` | `id` | No | 8 |
| `Stor_Code_Group` | `Stor_Cod_Grp` | `id` | Yes | 10 |
| `Stor_Code_Group_Item_View` | `Stor_Vcod_Grp_Itm` | `id` | No | 10 |
| `Stor_Code_Item` | `Stor_Cod_Itm` | `id` | No | 9 |
| `Stor_Code_Location1` | `Stor_Cod_Loc1` | `id` | No | 8 |
| `Stor_Code_Location2` | `Stor_Cod_Loc2` | `id` | No | 8 |
| `Stor_Code_Location3` | `Stor_Cod_Loc3` | `id` | No | 8 |
| `Stor_Code_Method` | `Stor_Cod_Method` | `id` | No | 19 |
| `Stor_Code_Model` | `Stor_Cod_Model` | `id` | No | 8 |
| `Stor_Code_Order_Status` | `Stor_Cod_Ord_Status` | `id` | No | 8 |
| `Stor_Code_Own` | `Stor_Cod_Own` | `id` | No | 8 |
| `Stor_Code_Size` | `Stor_Cod_Size` | `id` | No | 8 |
| `Stor_Code_Transaction_Type` | `Stor_Cod_Trntyp` | `id` | No | 8 |
| `Stor_Code_Type` | `Stor_Cod_Type` | `id` | No | 8 |
| `Stor_Code_Unit` | `Stor_Cod_Unit` | `id` | No | 8 |
| `Stor_Execute_Inbound_Master` | `Stor_Eimst` | `id` | Yes | 18 |
| `Stor_Execute_Inbound_Trans` | `Stor_Eitrn` | `id` | No | 35 |
| `Stor_Execute_Inbound_View` | `Stor_Vexecinbound` | `id` | No | 89 |
| `Stor_Execute_Orders_View` | `Stor_Vexec_Ords` | `id` | No | 89 |
| `Stor_Execute_Outbound_Master` | `Stor_Eomst` | `id` | Yes | 20 |
| `Stor_Execute_Outbound_Trans` | `Stor_Eotrn` | `id` | No | 35 |
| `Stor_Execute_Outbound_View` | `Stor_Vexecoutbound` | `id` | No | 89 |
| `Stor_Inbound_Master` | `Stor_Inmst` | `id` | Yes | 17 |
| `Stor_Inbound_Order_Master` | `Stor_Inordmst` | `id` | Yes | 21 |
| `Stor_Inbound_Order_Trans` | `Stor_Inordtrn` | `id` | No | 28 |
| `Stor_Inbound_Order_View` | `Stor_Vinord` | `id` | No | 93 |
| `Stor_Inbound_Trans` | `Stor_Intrn` | `id` | No | 31 |
| `Stor_Inbound_View` | `Stor_Vinbound` | `id` | No | 87 |
| `Stor_Item_Category` | `Stor_Item_Cat` | `id` | No | 10 |
| `Stor_Item_Classes` | `Stor_Item_Class` | `id` | No | 9 |
| `Stor_Item_Classes_View` | `Stor_Vitem_Classes` | `id` | No | 57 |
| `Stor_Item_Classification` | `Stor_Ics` | `id` | Yes | 31 |
| `Stor_Item_Classification_View` | `Stor_Vics` | `id` | No | 75 |
| `Stor_Item_Formula` | `Stor_Itm_Form` | `id` | No | 9 |
| `Stor_Item_Specification` | `Stor_Item_Spec` | `id` | No | 9 |
| `Stor_Item_View` | `Stor_Vitem` | `id` | No | 45 |
| `Stor_Items` | `Stor_Item` | `id` | Yes | 52 |
| `Stor_Orders_View` | `Stor_Vords` | `id` | No | 93 |
| `Stor_Outbound_Master` | `Stor_Oumst` | `id` | Yes | 17 |
| `Stor_Outbound_Order_Master` | `Stor_Ouordmst` | `id` | Yes | 21 |
| `Stor_Outbound_Order_Trans` | `Stor_Ouordtrn` | `id` | No | 35 |
| `Stor_Outbound_Order_View` | `Stor_Vouord` | `id` | No | 93 |
| `Stor_Outbound_Trans` | `Stor_Outrn` | `id` | No | 24 |
| `Stor_Outbound_View` | `Stor_Voutbound` | `id` | No | 87 |
| `Stor_Stor_Item_Classification` | `Stor_Sics` | `id` | Yes | 25 |
| `Stor_Stor_Item_Classification_View` | `Stor_Vsics` | `id` | No | 99 |
| `Stor_Store_Accounts` | `Stor_Str_Acc` | `id` | No | 14 |
| `Stor_Store_Item_Accounts` | `Stor_Stritemacc` | `id` | No | 13 |
| `Stor_Stores` | `Stor_Store` | `id` | No | 23 |
| `Stor_Stores_Materiales` | `Stor_Smat` | `id` | No | 19 |
| `Stor_Stores_Materiales_Accounts` | `Stor_Smat_Acc` | `id` | No | 15 |
| `Stor_Transactions_View` | `Stor_Vtrans` | `id` | No | 87 |
| `Stor_Transfer_Master` | `Stor_Trmst` | `id` | Yes | 15 |
| `Stor_Transfer_Trans` | `Stor_Trtrn` | `id` | No | 19 |
| `Stor_Transfer_View` | `Stor_Vtransfer` | `id` | No | 88 |
| `Stor_Unit_Formula` | `Stor_Unit_Form` | `id` | No | 9 |

### Package: `Str` (22 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Str_Actual_Master` | `Str_Actmst` | `id` | Yes | 14 |
| `Str_Actual_Trans` | `Str_Acttrn` | `id` | No | 10 |
| `Str_Code_Document` | `Str_Cod_Doc` | `id` | No | 8 |
| `Str_Code_Location1` | `Str_Cod_Loc1` | `id` | No | 8 |
| `Str_Code_Location2` | `Str_Cod_Loc2` | `id` | No | 8 |
| `Str_Code_Location3` | `Str_Cod_Loc3` | `id` | No | 8 |
| `Str_Code_Specification1` | `Str_Cod_Spec1` | `id` | No | 8 |
| `Str_Code_Specification2` | `Str_Cod_Spec2` | `id` | No | 8 |
| `Str_Code_Specification3` | `Str_Cod_Spec3` | `id` | No | 8 |
| `Str_Code_Specification4` | `Str_Cod_Spec4` | `id` | No | 8 |
| `Str_Code_Specification5` | `Str_Cod_Spec5` | `id` | No | 8 |
| `Str_Code_Transaction_Type` | `Str_Cod_Trntyp` | `id` | No | 8 |
| `Str_Default_Accounts` | `Str_Defacc` | `id` | No | 10 |
| `Str_Input_Master` | `Str_Inmst` | `id` | Yes | 15 |
| `Str_Input_Trans` | `Str_Intrn` | `id` | No | 13 |
| `Str_Items` | `Str_Item` | `id` | No | 15 |
| `Str_Output_Master` | `Str_Oumst` | `id` | Yes | 15 |
| `Str_Output_Trans` | `Str_Outrn` | `id` | No | 13 |
| `Str_Stores` | `Str_Store` | `id` | No | 13 |
| `Str_Stores_Materiales` | `Str_Smat` | `id` | No | 16 |
| `Str_Transfer_Master` | `Str_Trmst` | `id` | Yes | 12 |
| `Str_Transfer_Trans` | `Str_Trtrn` | `id` | No | 13 |

### Package: `Trn` (22 Entities)
| Table / Entity Name | Synonym | Primary Key | Has Children | Fields Count |
| :--- | :--- | :--- | :---: | :---: |
| `Trn_Balance` | `Trn_Bln` | `id` | Yes | 10 |
| `Trn_Balance_Fees` | `Trn_Bln_Fee` | `id` | No | 9 |
| `Trn_Balance_Master` | `Trn_Bln_Mst` | `id` | Yes | 24 |
| `Trn_Balance_Penalties` | `Trn_Bln_Penalty` | `id` | No | 12 |
| `Trn_Balance_Transaction` | `Trn_Bln_Trn` | `id` | No | 14 |
| `Trn_Balance_User` | `Trn_Bln_User` | `id` | No | 9 |
| `Trn_Balance_View` | `Trn_Vbln` | `id` | No | 10 |
| `Trn_Balancing_Master_View` | `Trn_Vblncing_Mst` | `id` | No | 38 |
| `Trn_Balancing_Pay_View` | `Trn_Vpay` | `id` | No | 38 |
| `Trn_Balancing_View` | `Trn_Vblncing` | `id` | No | 47 |
| `Trn_Change_Location` | `Trn_Chloc` | `id` | No | 10 |
| `Trn_Code_For` | `Trn_Cod_For` | `id` | No | 8 |
| `Trn_Code_Location` | `Trn_Cod_Loc` | `id` | No | 8 |
| `Trn_Code_Model` | `Trn_Cod_Model` | `id` | Yes | 7 |
| `Trn_Code_Model_Details` | `Trn_Cod_Model_Detail` | `id` | No | 6 |
| `Trn_Code_Paytype` | `Trn_Cod_Ptype` | `id` | No | 8 |
| `Trn_Code_Reservation` | `Trn_Cod_Res` | `id` | No | 8 |
| `Trn_Code_Type` | `Trn_Cod_Type` | `id` | No | 8 |
| `Trn_Fees` | `Trn_Fee` | `id` | No | 11 |
| `Trn_Leaky_Cars` | `Trn_Leak_Car` | `id` | No | 9 |
| `Trn_Penalties` | `Trn_Penalty` | `id` | No | 11 |
| `Trn_Total_Balancing_View` | `Trn_Vtblncing` | `id` | No | 44 |


Total Registered Entities Across Application: **762 Entities**
