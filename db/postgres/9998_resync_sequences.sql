-- Run AFTER loading the seed data.
-- Inserting an explicit id does not advance a PostgreSQL sequence, so each
-- one is moved past the highest id its table already holds.
-- 25 sequence/table pairs, derived from the Oracle triggers.

\connect phsoftme_erp_demo

SELECT setval('Acc_Cost_Seq', COALESCE((SELECT MAX(Id) FROM Acc_Cost), 0) + 1, false);
SELECT setval('Cpy_Cod_Doc_Seq', COALESCE((SELECT MAX(Id) FROM Cpy_Cod_Doc), 0) + 1, false);
SELECT setval('Cpy_Cod_Unit_Seq', COALESCE((SELECT MAX(Id) FROM Cpy_Cod_Unit), 0) + 1, false);
SELECT setval('Cpy_Perm_Seq', COALESCE((SELECT MAX(Id) FROM Cpy_Perm), 0) + 1, false);
SELECT setval('Cpy_PermPriv_Seq', COALESCE((SELECT MAX(Id) FROM Cpy_PermPriv), 0) + 1, false);
SELECT setval('Cpy_Task_Status_Seq', COALESCE((SELECT MAX(Id) FROM Cpy_Task), 0) + 1, false);
SELECT setval('Cpy_User_Seq', COALESCE((SELECT MAX(Id) FROM Cpy_User), 0) + 1, false);
SELECT setval('EmpId_Seq', COALESCE((SELECT MAX(Id) FROM Emp_FngrPrnt), 0) + 1, false);
SELECT setval('Fix_Fixed_Seq', COALESCE((SELECT MAX(Id) FROM Fix_Fixed), 0) + 1, false);
SELECT setval('Mng_Curn_Seq', COALESCE((SELECT MAX(Id) FROM Mng_Curn), 0) + 1, false);
SELECT setval('Mng_CurnHist_Seq', COALESCE((SELECT MAX(Id) FROM Mng_CurnHist), 0) + 1, false);
SELECT setval('Phs_Dash_Blocks_Seq', COALESCE((SELECT MAX(Id) FROM Phs_Dash_Blocks), 0) + 1, false);
SELECT setval('Phs_LogId_Seq', COALESCE((SELECT MAX(Id) FROM Phs_Log), 0) + 1, false);
SELECT setval('Phs_Pref_Struct_Seq', COALESCE((SELECT MAX(Id) FROM Phs_Pref_Struct), 0) + 1, false);
SELECT setval('PhsId_Seq', COALESCE((SELECT MAX(Id) FROM Phs_Pref), 0) + 1, false);
SELECT setval('Stor_ICS_Seq', COALESCE((SELECT MAX(Id) FROM Stor_EITrn), 0) + 1, false);
SELECT setval('Stor_InOrdTrn_Seq', COALESCE((SELECT MAX(Id) FROM Stor_InOrdTrn), 0) + 1, false);
SELECT setval('Stor_Item_Seq', COALESCE((SELECT MAX(Id) FROM Stor_Item), 0) + 1, false);
SELECT setval('Stor_OuOrdTrn_Seq', COALESCE((SELECT MAX(Id) FROM Stor_OuOrdTrn), 0) + 1, false);
SELECT setval('Stor_SICS_Seq', COALESCE((SELECT MAX(Id) FROM Stor_SICS), 0) + 1, false);
SELECT setval('Stor_SMat_Seq', COALESCE((SELECT MAX(Id) FROM Stor_SMat), 0) + 1, false);
SELECT setval('Stor_Store_Seq', COALESCE((SELECT MAX(Id) FROM Stor_Store), 0) + 1, false);
SELECT setval('Str_Item_Seq', COALESCE((SELECT MAX(Id) FROM Str_Item), 0) + 1, false);
SELECT setval('Str_SMat_Seq', COALESCE((SELECT MAX(Id) FROM Str_SMat), 0) + 1, false);
SELECT setval('Str_Store_Seq', COALESCE((SELECT MAX(Id) FROM Str_Store), 0) + 1, false);
