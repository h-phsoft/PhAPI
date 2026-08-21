-- =========================================================================
-- 1. CLASSIFICATIONS (Class 1, 2, 3 for Customers, Team, and Projects)
-- =========================================================================

-- Customer Classifications
INSERT INTO Proj_Code_Customer_Class1 (Id, Status_Id, Name) VALUES (1, 1, 'Enterprise Corp');
INSERT INTO Proj_Code_Customer_Class1 (Id, Status_Id, Name) VALUES (2, 1, 'SME / Startup');

INSERT INTO Proj_Code_Customer_Class2 (Id, Status_Id, Name) VALUES (1, 1, 'Local Market');
INSERT INTO Proj_Code_Customer_Class2 (Id, Status_Id, Name) VALUES (2, 1, 'International');

INSERT INTO Proj_Code_Customer_Class3 (Id, Status_Id, Name) VALUES (1, 1, 'Retainer Client');
INSERT INTO Proj_Code_Customer_Class3 (Id, Status_Id, Name) VALUES (2, 1, 'Ad-hoc Client');

-- Team Member Classifications
INSERT INTO Proj_Code_Member_Class1 (Id, Status_Id, Name) VALUES (1, 1, 'Senior Partner');
INSERT INTO Proj_Code_Member_Class1 (Id, Status_Id, Name) VALUES (2, 1, 'Junior Associate');

INSERT INTO Proj_Code_Member_Class2 (Id, Status_Id, Name) VALUES (1, 1, 'Litigation Dept');
INSERT INTO Proj_Code_Member_Class2 (Id, Status_Id, Name) VALUES (2, 1, 'Corporate Advisory Dept');

INSERT INTO Proj_Code_Member_Class3 (Id, Status_Id, Name) VALUES (1, 1, 'Full-Time');
INSERT INTO Proj_Code_Member_Class3 (Id, Status_Id, Name) VALUES (2, 1, 'Of-Counsel / External');

-- Project / Case Classifications
INSERT INTO Proj_Code_Project_Class1 (Id, Status_Id, Name) VALUES (1, 1, 'High Value Case');
INSERT INTO Proj_Code_Project_Class1 (Id, Status_Id, Name) VALUES (2, 1, 'Standard Case');

INSERT INTO Proj_Code_Project_Class2 (Id, Status_Id, Name) VALUES (1, 1, 'Court Litigation');
INSERT INTO Proj_Code_Project_Class2 (Id, Status_Id, Name) VALUES (2, 1, 'Arbitration / Settlement');

INSERT INTO Proj_Code_Project_Class3 (Id, Status_Id, Name) VALUES (1, 1, 'External Counsel Involved');
INSERT INTO Proj_Code_Project_Class3 (Id, Status_Id, Name) VALUES (2, 1, 'In-House Managed');

-- =========================================================================
-- 2. LOOKUPS (Status, Types, Priority)
-- =========================================================================
INSERT INTO Proj_Code_Status (Id, Status_Id, Name) VALUES (1, 1, 'Drafting');
INSERT INTO Proj_Code_Status (Id, Status_Id, Name) VALUES (2, 1, 'In Progress');
INSERT INTO Proj_Code_Status (Id, Status_Id, Name) VALUES (3, 1, 'Under Review');
INSERT INTO Proj_Code_Status (Id, Status_Id, Name) VALUES (4, 1, 'Closed');

INSERT INTO Proj_Code_Types (Id, Status_Id, Name) VALUES (1, 1, 'Civil Litigation');
INSERT INTO Proj_Code_Types (Id, Status_Id, Name) VALUES (2, 1, 'Commercial Arbitration');
INSERT INTO Proj_Code_Types (Id, Status_Id, Name) VALUES (3, 1, 'Corporate Legal Counsel');
INSERT INTO Proj_Code_Types (Id, Status_Id, Name) VALUES (4, 1, 'Intellectual Property Dispute');

INSERT INTO Proj_Code_Priority (Id, Status_Id, Name) VALUES (1, 1, 'Low');
INSERT INTO Proj_Code_Priority (Id, Status_Id, Name) VALUES (2, 1, 'Medium');
INSERT INTO Proj_Code_Priority (Id, Status_Id, Name) VALUES (3, 1, 'High');
INSERT INTO Proj_Code_Priority (Id, Status_Id, Name) VALUES (4, 1, 'Urgent / Court Mandated');

-- =========================================================================
-- 3. WORK ITEMS
-- =========================================================================
INSERT INTO Proj_WorkItem_Mst (Id, Name, Status_Id) VALUES (1001, 'Case Preparation & Pleadings', 1);
INSERT INTO Proj_TWItem_Trn (Id, Mst_Id, nOrd, Status_Id, Billable_Id, Name) VALUES (1001, 1001, 1, 1, 1, 'Drafting Statement of Claim');

INSERT INTO Proj_WorkItem_Mst (Id, Name, Status_Id) VALUES (1002, 'Discovery & Evidence', 1);
INSERT INTO Proj_TWItem_Trn (Id, Mst_Id, nOrd, Status_Id, Billable_Id, Name) VALUES (1002, 1002, 1, 1, 1, 'Reviewing Witness Testimonies');

INSERT INTO Proj_WorkItem_Mst (Id, Name, Status_Id) VALUES (1003, 'Court Proceedings', 1);
INSERT INTO Proj_TWItem_Trn (Id, Mst_Id, nOrd, Status_Id, Billable_Id, Name) VALUES (1003, 1003, 1, 1, 1, 'Oral Submissions and Hearings');

-- =========================================================================
-- 4. CUSTOMERS (Linked with Classifications 1, 2, 3)
-- =========================================================================
INSERT INTO Proj_Customers (Id, Name, Status_Id, Cat_Id, Class1_Id, Class2_Id, Class3_Id) 
VALUES (1001, 'Al-Mansoor Trading Group', 1, 0, 1, 1, 1);
INSERT INTO Proj_Customers (Id, Name, Status_Id, Cat_Id, Class1_Id, Class2_Id, Class3_Id) 
VALUES (1002, 'Global Logistics Enterprise', 1, 0, 1, 2, 1);
INSERT INTO Proj_Customers (Id, Name, Status_Id, Cat_Id, Class1_Id, Class2_Id, Class3_Id) 
VALUES (1003, 'National Real Estate Holding', 1, 0, 1, 1, 2);
INSERT INTO Proj_Customers (Id, Name, Status_Id, Cat_Id, Class1_Id, Class2_Id, Class3_Id) 
VALUES (1004, 'Apex Pharmaceuticals', 1, 0, 2, 2, 2);

-- =========================================================================
-- 5. TEAM MEMBERS (Linked with Classifications 1, 2, 3)
-- =========================================================================
INSERT INTO Proj_Team_Members (Id, User_Id, Name, HPrice, Status_Id, Class1_Id, Class2_Id, Class3_Id) 
VALUES (1001, 1, 'Ahmad Al-Khatib (Senior Counsel)', 250.00, 1, 1, 1, 1);
INSERT INTO Proj_Team_Members (Id, User_Id, Name, HPrice, Status_Id, Class1_Id, Class2_Id, Class3_Id) 
VALUES (1002, 1, 'Fatima Al-Zahra (Advocate)', 180.00, 1, 2, 1, 1);
INSERT INTO Proj_Team_Members (Id, User_Id, Name, HPrice, Status_Id, Class1_Id, Class2_Id, Class3_Id) 
VALUES (1003, 1, 'Tariq Bin Ziyad (Legal Consultant)', 220.00, 1, 1, 2, 1);
INSERT INTO Proj_Team_Members (Id, User_Id, Name, HPrice, Status_Id, Class1_Id, Class2_Id, Class3_Id) 
VALUES (1004, 1, 'Layla Hassan (Legal Researcher)', 150.00, 1, 2, 2, 2);

-- =========================================================================
-- 6. PROJECTS / CASES (Linked with Classifications 1, 2, 3)
-- =========================================================================
INSERT INTO Proj_Project (Id, Cust_Id, Type_Id, Status_Id, Priority_Id, Member_Id, Class1_Id, Class2_Id, Class3_Id, Name, Progress, SDate) 
VALUES (1001, 1001, 1, 4, 3, 1001, 1, 1, 1, 'Commercial Breach of Contract Case #402', 100, TO_DATE('2026-01-10', 'YYYY-MM-DD'));

INSERT INTO Proj_Project (Id, Cust_Id, Type_Id, Status_Id, Priority_Id, Member_Id, Class1_Id, Class2_Id, Class3_Id, Name, Progress, SDate) 
VALUES (1002, 1002, 2, 2, 4, 1002, 1, 2, 2, 'International Maritime Arbitration', 45, TO_DATE('2026-03-05', 'YYYY-MM-DD'));

INSERT INTO Proj_Project (Id, Cust_Id, Type_Id, Status_Id, Priority_Id, Member_Id, Class1_Id, Class2_Id, Class3_Id, Name, Progress, SDate) 
VALUES (1003, 1003, 3, 1, 2, 1003, 2, 2, 1, 'Real Estate Title Deed Dispute', 15, TO_DATE('2026-06-20', 'YYYY-MM-DD'));

INSERT INTO Proj_Project (Id, Cust_Id, Type_Id, Status_Id, Priority_Id, Member_Id, Class1_Id, Class2_Id, Class3_Id, Name, Progress, SDate) 
VALUES (1004, 1004, 4, 3, 4, 1004, 1, 1, 2, 'Patent Infringement Litigation', 85, TO_DATE('2026-05-15', 'YYYY-MM-DD'));

INSERT INTO Proj_Project (Id, Cust_Id, Type_Id, Status_Id, Priority_Id, Member_Id, Class1_Id, Class2_Id, Class3_Id, Name, Progress, SDate) 
VALUES (1005, 1001, 3, 2, 3, 1001, 2, 2, 1, 'Corporate Governance Advisory', 60, TO_DATE('2026-07-01', 'YYYY-MM-DD'));

-- =========================================================================
-- 7. TIMESHEETS
-- =========================================================================
INSERT INTO Proj_Project_Timesheet (Id, Proj_Id, Team_Id, MWItem_Id, TWItem_Id, DDate, Hours, CPrice, Cst, SPrice, Amt) 
VALUES (1001, 1001, 1001, 1001, 1001, TO_DATE('2026-01-20', 'YYYY-MM-DD'), 40, 120, 4800, 250, 10000);

INSERT INTO Proj_Project_Timesheet (Id, Proj_Id, Team_Id, MWItem_Id, TWItem_Id, DDate, Hours, CPrice, Cst, SPrice, Amt) 
VALUES (1002, 1002, 1002, 1002, 1002, TO_DATE('2026-04-10', 'YYYY-MM-DD'), 85, 90, 7650, 180, 15300);

INSERT INTO Proj_Project_Timesheet (Id, Proj_Id, Team_Id, MWItem_Id, TWItem_Id, DDate, Hours, CPrice, Cst, SPrice, Amt) 
VALUES (1003, 1003, 1003, 1003, 1003, TO_DATE('2026-07-05', 'YYYY-MM-DD'), 20, 110, 2200, 220, 4400);

INSERT INTO Proj_Project_Timesheet (Id, Proj_Id, Team_Id, MWItem_Id, TWItem_Id, DDate, Hours, CPrice, Cst, SPrice, Amt) 
VALUES (1004, 1004, 1004, 1003, 1003, TO_DATE('2026-06-01', 'YYYY-MM-DD'), 120, 75, 9000, 150, 18000);

INSERT INTO Proj_Project_Timesheet (Id, Proj_Id, Team_Id, MWItem_Id, TWItem_Id, DDate, Hours, CPrice, Cst, SPrice, Amt) 
VALUES (1005, 1005, 1001, 1001, 1001, TO_DATE('2026-08-02', 'YYYY-MM-DD'), 50, 120, 6000, 250, 12500);

-- =========================================================================
-- 8. INVOICES
-- =========================================================================
INSERT INTO Proj_Invoice_Mst (Id, Period_Id, Status_Id, Cust_Id, Num, dDate, DueDate, Paid_Id) 
VALUES (1001, NULL, 0, 1001, 91001, TO_DATE('2026-02-01', 'YYYY-MM-DD'), TO_DATE('2026-02-15', 'YYYY-MM-DD'), 1);
INSERT INTO Proj_Invoice_Trn (Id, Mst_Id, Proj_Id, Qnt, Price, Amt) VALUES (1001, 1001, 1001, 1, 10000, 10000);

INSERT INTO Proj_Invoice_Mst (Id, Period_Id, Status_Id, Cust_Id, Num, dDate, DueDate, Paid_Id) 
VALUES (1002, NULL, 0, 1002, 91002, TO_DATE('2026-04-30', 'YYYY-MM-DD'), TO_DATE('2026-05-15', 'YYYY-MM-DD'), 1);
INSERT INTO Proj_Invoice_Trn (Id, Mst_Id, Proj_Id, Qnt, Price, Amt) VALUES (1002, 1002, 1002, 1, 15300, 15300);

INSERT INTO Proj_Invoice_Mst (Id, Period_Id, Status_Id, Cust_Id, Num, dDate, DueDate, Paid_Id) 
VALUES (1003, NULL, 0, 1004, 91003, TO_DATE('2026-06-30', 'YYYY-MM-DD'), TO_DATE('2026-07-15', 'YYYY-MM-DD'), 1);
INSERT INTO Proj_Invoice_Trn (Id, Mst_Id, Proj_Id, Qnt, Price, Amt) VALUES (1003, 1003, 1004, 1, 18000, 18000);

INSERT INTO Proj_Invoice_Mst (Id, Period_Id, Status_Id, Cust_Id, Num, dDate, DueDate, Paid_Id) 
VALUES (1004, NULL, 0, 1001, 91004, TO_DATE('2026-08-10', 'YYYY-MM-DD'), TO_DATE('2026-08-25', 'YYYY-MM-DD'), 1);
INSERT INTO Proj_Invoice_Trn (Id, Mst_Id, Proj_Id, Qnt, Price, Amt) VALUES (1004, 1004, 1005, 1, 12500, 12500);

COMMIT;