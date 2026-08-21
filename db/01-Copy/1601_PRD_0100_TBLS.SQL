--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'PRD%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'PRD%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'PRD%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'PRD%' ;
----------------------------------------------------------------------------------------------------
Create Table Prd_Code_Status                               -- جدول ترميز حالة الأمر
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Prd_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Prd_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Prd_Cod_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Prd_Cod_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Prd_Cod_Status For Prd_Code_Status
/
Insert into Prd_Cod_Status (Id,Name) values (0,'-'     );
Insert into Prd_Cod_Status (Id,Name) values (1,'Freez' );
Insert into Prd_Cod_Status (Id,Name) values (2,'Cancel');
----------------------------------------------------------------------------------------------------
Create Table Prd_Code_Production_Status                       -- جدول ترميز حالة الإنتاج
( Id         Number(2) NOT NULL,                              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                             -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                     -- الاسم
  Rem        Varchar2(100 Char),                              -- ملاحظات
  CONSTRAINT Prd_Cod_Prod_Status_PK PRIMARY KEY (Id  ),
  CONSTRAINT Prd_Cod_Prod_Status_UK UNIQUE      (Name)
)
/
Create Synonym Prd_Cod_Prod_Status For Prd_Code_Production_Status
/
Insert into Prd_Cod_Prod_Status (Id,Name) values (0 , 'New'        );
Insert into Prd_Cod_Prod_Status (Id,Name) values (10, 'In Progress');
Insert into Prd_Cod_Prod_Status (Id,Name) values (21, 'Paused'     );
Insert into Prd_Cod_Prod_Status (Id,Name) values (22, 'Canceled'   );
----------------------------------------------------------------------------------------------------
Create Table Prd_Code_Execition_Time                          -- جدول ترميز وقت التنفيذ
( Id         Number(2) NOT NULL,                              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                             -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                     -- الاسم
  Rem        Varchar2(100 Char),                              -- ملاحظات
  CONSTRAINT Prd_Cod_Exec_Time_PK PRIMARY KEY (Id  ),
  CONSTRAINT Prd_Cod_Exec_Time_UK UNIQUE      (Name)
)
/
Create Synonym Prd_Cod_Exec_Time For Prd_Code_Execition_Time
/
Insert into Prd_Cod_Exec_Time (Id,Status_Id,Name) values (-1, 1, 'Before');
Insert into Prd_Cod_Exec_Time (Id,Status_Id,Name) values (0 , 1, 'With'  );
Insert into Prd_Cod_Exec_Time (Id,Status_Id,Name) values ( 1, 1, 'After' );
----------------------------------------------------------------------------------------------------
Create Table Prd_Code_Field_Type                              -- جدول ترميز أنواع الحقول
( Id         Number(2) NOT NULL,                              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                             -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                     -- الاسم
  Rem        Varchar2(100 Char),                              -- ملاحظات
  CONSTRAINT Prd_Cod_FType_PK PRIMARY KEY (Id  ),
  CONSTRAINT Prd_Cod_FType_UK UNIQUE      (Name)
)
/
Create Synonym Prd_Cod_Fld_Type For Prd_Code_Field_Type
/
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (1 , 1, 'Yes/No'             );
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (2 , 1, 'Numeric'            );
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (3 , 1, 'Numeric Range'      );
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (4 , 1, 'Date'               );
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (5 , 1, 'Date Range'         );
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (6 , 1, 'Time Duration'      );
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (7 , 1, 'Time Duration Range');
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (8 , 1, 'Text'               );
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (9 , 1, 'Selection'          );
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (10, 2, 'File Reference'     );
Insert into Prd_Cod_Fld_Type (Id,Status_Id,Name) values (11, 2, 'Signature'          );
----------------------------------------------------------------------------------------------------
Create Table Prd_Code_Stage_Type                           -- جدول ترميز 
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  CONSTRAINT Prd_Cod_Type_PK PRIMARY KEY (Id  ),
  CONSTRAINT Prd_Cod_Type_UK UNIQUE      (Name)
)
/
Create Synonym Prd_Cod_Type For Prd_Code_Stage_Type
/
Insert Into Prd_Cod_Type (Id,Name) Values (1,'Raw Material');
Insert Into Prd_Cod_Type (Id,Name) Values (2,'Expense');
Insert Into Prd_Cod_Type (Id,Name) Values (3,'IN-Semi-Finished');
Insert Into Prd_Cod_Type (Id,Name) Values (4,'OU-Semi-Finished');
Insert Into Prd_Cod_Type (Id,Name) Values (5,'Product');
----------------------------------------------------------------------------------------------------
Create Table Prd_Code_Quality_Assurance_Result                -- جدول ترميز نتيجة اختبار الجودة
( Id         Number(2) NOT NULL,                              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                             -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                     -- الاسم
  Rem        Varchar2(100 Char),                              -- ملاحظات
  CONSTRAINT Prd_Cod_QA_Result_PK PRIMARY KEY (Id  ),
  CONSTRAINT Prd_Cod_QA_Result_UK UNIQUE      (Name)
)
/
Create Synonym Prd_Cod_QA_Result For Prd_Code_Quality_Assurance_Result
/
Insert into Prd_Cod_QA_Result (Id,Name) values (1, 'Accepted'   );
Insert into Prd_Cod_QA_Result (Id,Name) values (2, 'Rejected'   );
Insert into Prd_Cod_QA_Result (Id,Name) values (3, 'Conditional');
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Cod_Mchine_Cat_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Code_Machine_Category                     -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(10), Ins_Date     Date,
  Upd_User   Number(10), Upd_Date     Date,
  CONSTRAINT Prd_Cod_Mchine_Cat_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Prd_Cod_Mchine_Cat_UK        UNIQUE      (Name),
  CONSTRAINT Prd_Cod_Mchine_Cat_Ins_FK    Foreign Key (Ins_User ) References Cpy_User(Id),
  CONSTRAINT Prd_Cod_Mchine_Cat_Upd_FK    Foreign Key (Upd_User ) References Cpy_User(Id)
)
/
Create Synonym Prd_Cod_Mchine_Cat For Prd_Code_Machine_Category
/
Insert Into Prd_Cod_Mchine_Cat (Id,Name) Values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Prd_QA_Fld_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Quality_Assurance_Field                   -- حقول الجودة
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- الحالة
  FType_Id   Number(2) Default 1,                          -- النوع
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  vDefault   Varchar2(500 Char),                           -- قيمة افتراضية أبجدية
  dDef_Value Date,                                         -- قيمة افتراضية تاريخ
  dMin_Value Date,                                         -- قيمة دنيا تاريخ
  dMax_Value Date,                                         -- قيمة عليا تاريخ
  nDef_Value Number(25,3) Default 0,                       -- قيمة افتراضية رقمية
  nMin_Value Number(25,3) Default 0,                       -- قيمة دنيا رقمية
  nMax_Value Number(25,3) Default 0,                       -- قيمة عليا رقمية
  yDef_Value Number(1) Default 2,                          -- قيمة افتراضية Yes/No
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Prd_QA_Fld_PK        PRIMARY KEY (Id),
  CONSTRAINT Prd_QA_Fld_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status  (Id),
  CONSTRAINT Prd_QA_Fld_FType_FK  Foreign Key (FType_Id ) References Prd_Cod_Fld_Type(Id),
  CONSTRAINT Prd_QA_Fld_Ins_FK    Foreign Key (Ins_User ) References Cpy_User        (Id),
  CONSTRAINT Prd_QA_Fld_Upd_FK    Foreign Key (Upd_User ) References Cpy_User        (Id)
)
/
Create Synonym Prd_QA_Fld For Prd_Quality_Assurance_Field
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_QA_Fld_Vals_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Quality_Assurance_Field_Values            -- قيم حقول الجودة
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Fld_Id     Number(5) NOT NULL,                           -- الحقل
  Name       Varchar2(100 Char),                           -- الاسم
  FValue     Number(3),                                    -- القيمة
  Ok_Id      Number(1) Default 2,                          -- هل القيمة مقبولة
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Prd_QA_Fld_Vals_PK        PRIMARY KEY (Id),
  CONSTRAINT Prd_QA_Fld_Vals_Name_UK   UNIQUE      (Fld_Id, Name  ),
  CONSTRAINT Prd_QA_Fld_Vals_Value_UK  UNIQUE      (Fld_Id, FValue),
  CONSTRAINT Prd_QA_Fld_Vals_Fld_FK    Foreign Key (Fld_Id  ) References Prd_QA_Fld   (Id),
  CONSTRAINT Prd_QA_Fld_Vals_IsOk_FK   Foreign Key (Ok_Id   ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Prd_QA_Fld_Vals_Ins_FK    Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Prd_QA_Fld_Vals_Upd_FK    Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Prd_QA_Fld_Vals For Prd_Quality_Assurance_Field_Values
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_QA_Checklist_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Quality_Assurance_Checklist               -- قوائم تدقيق الجودة
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- الحالة
  Name       Varchar2(200 Char) NOT NULL,                  -- الاسم
  Code       Varchar2(20 Char),                            -- الرمز
  Version    Number(3) Default 1,                          -- الإصدار
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Prd_QA_Checklist_PK        PRIMARY KEY (Id),
  CONSTRAINT Prd_QA_Checklist_UK        UNIQUE      (Name, Version),
  CONSTRAINT Prd_QA_Checklist_Code_UK   UNIQUE      (Code),
  CONSTRAINT Prd_QA_Checklist_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Prd_QA_Checklist_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Prd_QA_Checklist_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Prd_QA_Checklist For Prd_Quality_Assurance_Checklist
/
Insert Into Prd_QA_Checklist (Id,Name,Code) Values (0,'-','-');
----------------------------------------------------------------------------------------------------
Create Sequence Prd_QA_Item_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Quality_Assurance_Checklist_Item          -- بنود قوائم تدقيق الجودة
( Id          Number(10) NOT NULL,                        -- مفتاح رئيسي
  List_Id     Number(5) NOT NULL,                         -- مفتاح القائمة الرئيسية
  Ord         Number(5) Default 0,                        -- الترتيب
  LText       Varchar2(500 Char) NOT NULL,                -- النص محلي
  IText       Varchar2(500 Char),                         -- النص أجنبي
  LHelp       Varchar2(500 Char),                         -- نص مساعد محلي
  IHelp       Varchar2(500 Char),                         -- نص مساعد أجنبي
  Code        Varchar2(20 Char),                          -- رمز البند
  Fld_Id      Number(5) NOT NULL,                         -- الحقل
  Required_Id Number(1) Default 1,                        -- هل الحقل إجباري
  Rem         Varchar2(250 Char),                         -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT Prd_QA_Item_PK          PRIMARY KEY (Id),
  CONSTRAINT Prd_QA_Item_List_FK     Foreign Key (List_Id    ) References Prd_QA_Checklist(Id),
  CONSTRAINT Prd_QA_Item_Fld_FK      Foreign Key (Fld_Id     ) References Prd_QA_Fld      (Id),
  CONSTRAINT Prd_QA_Item_Required_FK Foreign Key (Required_Id) References Phs_Cod_YesNo   (Id),
  CONSTRAINT Prd_QA_Item_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User        (Id),
  CONSTRAINT Prd_QA_Item_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User        (Id)
)
/
Create Synonym Prd_QA_Item For Prd_Quality_Assurance_Checklist_Item
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Machine_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Prd_Machines                                   -- دليل الآلات
( Id          Number(5),                                    -- مفتاح رئيسي
  LName       Varchar2(100) NOT NULL,                       -- الاسم محلي
  IName       Varchar2(100),                                -- الاسم اجنبي
  Status_Id   Number(1) Default 1,                          -- الحالة
  Curn_Id     Number(3) Default 1,                          -- العملة
  Cat_Id      Number(5) Default 0,                          -- الفئة
  Acc_Id      Number(9),                                    -- ألحساب
  HAmt        Number(20,5) Default 0,                       -- استهلاك ساعي
  HElec       Number(20,5) Default 0,                       -- استهلاك كهرباء ساعي
  Rem         VarChar2(250 Char),                           -- ملاحظات
  Ins_User    Number(10), Ins_Date     Date,
  Upd_User    Number(10), Upd_Date     Date,
  CONSTRAINT  Prd_Machine_PK        PRIMARY KEY (Id   ),
  CONSTRAINT  Prd_Machine_Name_Uk   Unique      (IName),
  CONSTRAINT  Prd_Machine_Cat_FK    Foreign Key (Cat_Id   ) References Prd_Cod_Mchine_Cat (Id),
  CONSTRAINT  Prd_Machine_Acc_FK    Foreign Key (Acc_Id   ) References Acc_acc            (Id),
  CONSTRAINT  Prd_Machine_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status     (Id),
  CONSTRAINT  Prd_Machine_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT  Prd_Machine_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Prd_Machine For Prd_Machines
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Expense_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Prd_Expenses                                   -- دليل الآلات
( Id          Number(5),                                    -- مفتاح رئيسي
  LName       Varchar2(100) NOT NULL,                       -- الاسم محلي
  IName       Varchar2(100),                                -- الاسم اجنبي
  Status_Id   Number(1) Default 1,                          -- الحالة
  Acc_Id      Number(9),                                    -- ألحساب
  Rem         VarChar2(250 Char),                           -- ملاحظات
  Ins_User    Number(10), Ins_Date     Date,
  Upd_User    Number(10), Upd_Date     Date,
  CONSTRAINT  Prd_Expense_PK        PRIMARY KEY (Id   ),
  CONSTRAINT  Prd_Expense_Name_Uk   Unique      (IName),
  CONSTRAINT  Prd_Expense_Acc_FK    Foreign Key (Acc_Id   ) References Acc_acc            (Id),
  CONSTRAINT  Prd_Expense_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status     (Id),
  CONSTRAINT  Prd_Expense_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT  Prd_Expense_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Prd_Expense For Prd_Expenses
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Form_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table 
                           -- دليل معادلات التصنيع
( Id          Number(9),                                    -- مفتاح رئيسي
  Item_Id     Number(9),                                    -- المادة
  List_Id     Number(5) Default 0,                          -- قائمة الجودة
  ExecTime_Id Number(1) Default 1,                          -- مت يتم تنفيذ القائمة
  Required_Id Number(1) Default 1,                          -- هل إجباري
  Status_Id   Number(1) Default 1,                          -- الحالة
  Num         Number(5) NOT NULL,                           -- الرقم
  Name        VarChar2(200 Char) NOT NULL,                  -- الاسم
  Qnt         Number(25,3) Default 1,                       -- الكمية
  Rem         VarChar2(250 Char),                           -- ملاحظات
  Ins_User    Number(10), Ins_Date     Date,
  Upd_User    Number(10), Upd_Date     Date,
  CONSTRAINT  Prd_Form_PK          PRIMARY KEY (Id  ),
  CONSTRAINT  Prd_Form_Num_Uk      Unique      (Num ),
  CONSTRAINT  Prd_Form_Name_Uk     Unique      (Name),
  CONSTRAINT  Prd_Form_Item_FK     Foreign Key (Item_Id    ) References Stor_Item        (Id),
  CONSTRAINT  Prd_Form_List_FK     Foreign Key (List_Id    ) References Prd_QA_Checklist (Id),
  CONSTRAINT  Prd_Form_ExecTime_FK Foreign Key (ExecTime_Id) References Prd_Cod_Exec_Time(Id),
  CONSTRAINT  Prd_Form_Required_FK Foreign Key (Required_Id) References Phs_Cod_YesNo    (Id),
  CONSTRAINT  Prd_Form_Status_FK   Foreign Key (Status_Id  ) References Phs_Cod_Status   (Id),
  CONSTRAINT  Prd_Form_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User         (Id),
  CONSTRAINT  Prd_Form_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User         (Id)
)
/
Create Synonym Prd_Form For Prd_Product_Formula
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Stage_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Production_Stage                          -- دليل مراحل الإنتاج
( Id          Number(10),                                  -- مفتاح رئيسي
  Form_Id     Number(9),                                   -- مفتاح المعادلة
  Num         Number(25) NOT NULL,                         -- الرقم
  Name        VarChar2(200 Char) NOT NULL,                 -- الاسم
  MAcc_Id     Number(9),                                   -- حساب الآلات المقابل
  EAcc_Id     Number(9),                                   -- حساب العمال المقابل
  Stor_Id     Number(9),                                   -- مستودع المرحلة
  List_Id     Number(5) Default 0,                         -- قائمة الجودة
  ExecTime_Id Number(1) Default 1,                         -- متى يتم تنفيذ القائمة
  Required_Id Number(1) Default 1,                         -- هل إجباري
  HTime       Number(5) Default 1,                         -- الوقت التقديري ساعة
  MTime       Number(2) Default 0,                         -- الوقت التقديري دقيقة
  Rem         VarChar2(250 Char),                          -- ملاحظات
  Ins_User    Number(10), Ins_Date     Date,
  Upd_User    Number(10), Upd_Date     Date,
  CONSTRAINT  Prd_Stage_PK          PRIMARY KEY (Id),
  CONSTRAINT  Prd_Stage_Num_Uk      Unique      (Form_Id, Num ),
  CONSTRAINT  Prd_Stage_Name_Uk     Unique      (Form_Id, Name),
  CONSTRAINT  Prd_Stage_Form_FK     Foreign Key (Form_Id    ) References Prd_Form         (Id),
  CONSTRAINT  Prd_Stage_MAcc_FK     Foreign Key (Macc_Id    ) References Acc_Acc          (Id),
  CONSTRAINT  Prd_Stage_EAcc_FK     Foreign Key (EAcc_Id    ) References Acc_Acc          (Id),
  CONSTRAINT  Prd_Stage_Stor_FK     Foreign Key (Stor_Id    ) References Stor_Store       (Id),
  CONSTRAINT  Prd_Stage_List_FK     Foreign Key (List_Id    ) References Prd_QA_Checklist (Id),
  CONSTRAINT  Prd_Stage_ExecTime_FK Foreign Key (ExecTime_Id) References Prd_Cod_Exec_Time(Id),
  CONSTRAINT  Prd_Stage_Required_FK Foreign Key (Required_Id) References Phs_Cod_YesNo    (Id),
  CONSTRAINT  Prd_Stage_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User         (Id),
  CONSTRAINT  Prd_Stage_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User         (Id)
)
/
Create Synonym Prd_Stage For Prd_Production_Stage
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Prod_Stage_Raw_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Productoin_Stage_Rawmaterial              -- بنود مراحل الإنتاج - المواد الأولية
( Id           Number(10),                                 -- مفتاح رئيسي
  Stage_Id     Number(10),                                 -- مفتاح المرحلة
  Ord          Number(5) Default 0,                        -- متسلسل
  Stor_Id      Number(5),                                  -- المستودع
  Item_Id      Number(9),                                  -- المادة
  Cost_Id      Number(9),                                  -- مركز كلفة الحركة الناشئة
  Acc_Id       Number(9),                                  -- حساب الحركة الناشئة
  Qnt          Number(25,3) Default 0,                     -- الكمية
  Descr        VarChar2(1024 Char),                        -- شرح
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_Prod_Stage_Raw_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_Prod_Stage_Raw_Stage_FK Foreign Key (Stage_Id ) References Prd_Stage (Id),
  CONSTRAINT   Prd_Prod_Stage_Raw_Stor_FK  Foreign Key (Stor_Id  ) References Stor_Store(Id),
  CONSTRAINT   Prd_Prod_Stage_Raw_Item_FK  Foreign Key (Item_Id  ) References Stor_Item (Id),
  CONSTRAINT   Prd_Prod_Stage_Raw_Cost_FK  Foreign Key (Cost_Id  ) References Acc_Cost  (Id),
  CONSTRAINT   Prd_Prod_Stage_Raw_Acc_FK   Foreign Key (Acc_Id   ) References Acc_Acc   (Id),
  CONSTRAINT   Prd_Prod_Stage_Raw_Ins_FK   Foreign Key (Ins_User ) References Cpy_User  (Id),
  CONSTRAINT   Prd_Prod_Stage_Raw_Upd_FK   Foreign Key (Upd_User ) References Cpy_User  (Id)
)
/
Create Synonym Prd_Prod_Stage_Raw For Prd_Productoin_Stage_Rawmaterial
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Prod_Stage_Prd_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Productoin_Stage_Product                  -- بنود مراحل الإنتاج - المواد المنتجة
( Id           Number(10),                                 -- مفتاح رئيسي
  Stage_Id     Number(10),                                 -- مفتاح المرحلة
  Ord          Number(5) Default 0,                        -- متسلسل
  Item_Id      Number(9),                                  -- المادة
  Cost_Id      Number(9),                                  -- مركز كلفة الحركة الناشئة
  Acc_Id       Number(9),                                  -- حساب الحركة الناشئة
  Qnt          Number(25,3) Default 0,                     -- الكمية
  Perc         Number(7,3) Default 100,                    -- النسبة
  Descr        VarChar2(1024 Char),                        -- شرح
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_Prod_Stage_Prd_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_Prod_Stage_Prd_Stage_FK Foreign Key (Stage_Id ) References Prd_Stage(Id),
  CONSTRAINT   Prd_Prod_Stage_Prd_Item_FK  Foreign Key (Item_Id  ) References Stor_Item(Id),
  CONSTRAINT   Prd_Prod_Stage_Prd_Cost_FK  Foreign Key (Cost_Id  ) References Acc_Cost (Id),
  CONSTRAINT   Prd_Prod_Stage_Prd_Acc_FK   Foreign Key (Acc_Id   ) References Acc_Acc  (Id),
  CONSTRAINT   Prd_Prod_Stage_Prd_Ins_FK   Foreign Key (Ins_User ) References Cpy_User (Id),
  CONSTRAINT   Prd_Prod_Stage_Prd_Upd_FK   Foreign Key (Upd_User ) References Cpy_User (Id)
)
/
Create Synonym Prd_Prod_Stage_Prd For Prd_Productoin_Stage_Product
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Prod_Stage_Exp_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Productoin_Stage_Expenses                 -- بنود مراحل الإنتاج - المصاريف
( Id           Number(10),                                 -- مفتاح رئيسي
  Stage_Id     Number(10),                                 -- مفتاح المرحلة
  Ord          Number(5) Default 0,                        -- متسلسل
  Acc_EId      Number(10),                                 -- حساب المصروف
  Acc_RId      Number(10),                                 -- حساب المصروف المقابل
  Amt          Number(25,3) Default 0,                     -- قيمة النفقات
  Perc         Number(7,3) Default 100,                    -- النسبة
  Descr        VarChar2(1024 Char),                        -- شرح
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_Prod_Stage_Exp_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_Prod_Stage_Exp_Stage_FK Foreign Key (Stage_Id ) References Prd_Stage(Id),
  CONSTRAINT   Prd_Prod_Stage_Exp_AccR_FK  Foreign Key (Acc_RId  ) References Acc_Acc  (Id),
  CONSTRAINT   Prd_Prod_Stage_Exp_AccE_FK  Foreign Key (Acc_EId  ) References Acc_Acc  (Id),
  CONSTRAINT   Prd_Prod_Stage_Exp_Ins_FK   Foreign Key (Ins_User ) References Cpy_User (Id),
  CONSTRAINT   Prd_Prod_Stage_Exp_Upd_FK   Foreign Key (Upd_User ) References Cpy_User (Id)
)
/
Create Synonym Prd_Prod_Stage_Exp For Prd_Productoin_Stage_Expenses
/
	----------------------------------------------------------------------------------------------------
	Create Sequence Prd_Prod_Stage_ISemi_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
	Create Table Prd_Productoin_Stage_InSemiproduct            -- بنود مراحل الإنتاج - مواد نصف مصنعة داخلة
	( Id           Number(10),                                 -- مفتاح رئيسي
	  Stage_Id     Number(10),                                 -- مفتاح المرحلة
	  Ord          Number(5) Default 0,                        -- متسلسل
	  Item_Id      Number(10),                                 -- المادة
	  Qnt          Number(25,3) Default 0,                     -- الكمية
	  Descr        VarChar2(1024 Char),                        -- شرح
	  Rem          VarChar2(250 Char),                         -- ملاحظات
	  Ins_User     Number(10), Ins_Date     Date,
	  Upd_User     Number(10), Upd_Date     Date,
	  CONSTRAINT   Prd_Prod_Stage_ISemi_PK       PRIMARY KEY (Id),
	  CONSTRAINT   Prd_Prod_Stage_ISemi_Stage_FK Foreign Key (Stage_Id ) References Prd_Stage(Id),
	  CONSTRAINT   Prd_Prod_Stage_ISemi_Item_FK  Foreign Key (Item_Id  ) References Stor_Item(Id),
	  CONSTRAINT   Prd_Prod_Stage_ISemi_Ins_FK   Foreign Key (Ins_User ) References Cpy_User (Id),
	  CONSTRAINT   Prd_Prod_Stage_ISemi_Upd_FK   Foreign Key (Upd_User ) References Cpy_User (Id)
	)
	/
	Create Synonym Prd_Prod_Stage_ISemi For Prd_Productoin_Stage_InSemiproduct
	/
	----------------------------------------------------------------------------------------------------
	Create Sequence Prd_Prod_Stage_OSemi_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
	Create Table Prd_Productoin_Stage_OuSemiproduct            -- بنود مراحل الإنتاج - مواد نصف مصنعة ناتجة
	( Id           Number(10),                                 -- مفتاح رئيسي
	  Stage_Id     Number(10),                                 -- مفتاح المرحلة
	  Ord          Number(5) Default 0,                        -- متسلسل
	  Item_Id      Number(10),                                 -- المادة
	  Qnt          Number(25,3) Default 0,                     -- الكمية
	  Perc         Number(7,3) Default 100,                    -- النسبة
	  Descr        VarChar2(1024 Char),                        -- شرح
	  Rem          VarChar2(250 Char),                         -- ملاحظات
	  Ins_User     Number(10), Ins_Date     Date,
	  Upd_User     Number(10), Upd_Date     Date,
	  CONSTRAINT   Prd_Prod_Stage_OSemi_PK       PRIMARY KEY (Id),
	  CONSTRAINT   Prd_Prod_Stage_OSemi_Stage_FK Foreign Key (Stage_Id ) References Prd_Stage(Id),
	  CONSTRAINT   Prd_Prod_Stage_OSemi_Item_FK  Foreign Key (Item_Id  ) References Stor_Item(Id),
	  CONSTRAINT   Prd_Prod_Stage_OSemi_Ins_FK   Foreign Key (Ins_User ) References Cpy_User (Id),
	  CONSTRAINT   Prd_Prod_Stage_OSemi_Upd_FK   Foreign Key (Upd_User ) References Cpy_User (Id)
	)
	/
	Create Synonym Prd_Prod_Stage_OSemi For Prd_Productoin_Stage_OuSemiproduct
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Prod_Stage_Mach_Cat_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Productoin_Stage_Machine_Category         -- بنود مراحل الإنتاج - فئات الآلات
( Id           Number(10),                                 -- مفتاح رئيسي
  Stage_Id     Number(10),                                 -- مفتاح المرحلة
  Cat_Id       Number(3),                                  -- فئة الآلة
  Ord          Number(5) Default 0,                        -- متسلسل
  Qnt          Number(3) Default 0,                        -- الكمية
  FTime        Number(5) Default 0,                        -- الزمن لكل آلة
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_Prod_Stage_Mach_Cat_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_Prod_Stage_Mach_Cat_Stage_FK Foreign Key (Stage_Id ) References Prd_Stage         (Id),
  CONSTRAINT   Prd_Prod_Stage_Mach_Cat_Cat_FK   Foreign Key (Cat_Id   ) References Prd_Cod_Mchine_Cat(Id),
  CONSTRAINT   Prd_Prod_Stage_Mach_Cat_Ins_FK   Foreign Key (Ins_User ) References Cpy_User          (Id),
  CONSTRAINT   Prd_Prod_Stage_Mach_Cat_Upd_FK   Foreign Key (Upd_User ) References Cpy_User          (Id)
)
/
Create Synonym Prd_Prod_Stage_Mach_Cat For Prd_Productoin_Stage_Machine_Category
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Prod_Stage_Emp_Job_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Productoin_Stage_Employee_Job             -- بنود مراحل الإنتاج - وظائف العمال
( Id           Number(10),                                 -- مفتاح رئيسي
  Stage_Id     Number(10),                                 -- مفتاح المرحلة
  Job_Id       Number(5),                                  -- فئة الآلة
  Ord          Number(5) Default 0,                        -- متسلسل
  Qnt          Number(3) Default 0,                        -- الكمية
  FTime        Number(5) Default 0,                        -- الزمن لكل عامل
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_Prod_Stage_Emp_Job_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_Prod_Stage_Emp_Job_Stage_FK Foreign Key (Stage_Id ) References Prd_Stage  (Id),
  CONSTRAINT   Prd_Prod_Stage_Emp_Job_Job_FK   Foreign Key (Job_Id   ) References Emp_Cod_Job(Id),
  CONSTRAINT   Prd_Prod_Stage_Emp_Job_Ins_FK   Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT   Prd_Prod_Stage_Emp_Job_Upd_FK   Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Prd_Prod_Stage_Emp_Job For Prd_Productoin_Stage_Employee_Job
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_MPLan_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Plan_Mst                                  -- ترويسة الخطط
( Id          Number(5) NOT NULL,                          -- مفتاح رئيسي
  Num         Number(9) NOT NULL,                          -- رقم الوثيقة
  dDate       Date,                                        -- التاريخ
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Prd_MPlan_PK        PRIMARY KEY (Id),
  CONSTRAINT  Prd_MPlan_UK        Unique      (Num),
  CONSTRAINT  Prd_MPlan_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT  Prd_MPlan_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Prd_MPlan For Prd_Plan_Mst
/
Create Sequence Prd_TPLan_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Plan_Trn                                  -- بنود الخطط
( Id          Number(10) NOT NULL,                         -- مفتاح رئيسي
  Plan_Id     Number(5) NOT NULL,                          -- مفتاح الالخطة
  Item_Id     Number(9) NOT NULL,                          -- مفتاح المادة
  Form_Id     Number(9) NOT NULL,                          -- مفتاح المعادلة
  Qnt         Number(25,3) Default 0,                      -- الكمية
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Prd_TPlan_PK        PRIMARY KEY (Id),
  CONSTRAINT  Prd_TPlan_UK        Unique      (Plan_Id, Item_Id, Form_Id),
  CONSTRAINT  Prd_TPlan_Plan_FK   Foreign Key (Plan_Id  ) References Prd_MPlan  (Id),
  CONSTRAINT  Prd_TPlan_Form_FK   Foreign Key (Form_Id  ) References Prd_Form   (Id),
  CONSTRAINT  Prd_TPlan_Item_FK   Foreign Key (Item_Id  ) References Stor_Item  (Id),
  CONSTRAINT  Prd_TPlan_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT  Prd_TPlan_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Prd_TPlan For Prd_Plan_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_MOrder_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Mst                                 -- ترويسة أوامر التصنيع
( Id          Number(5) NOT NULL,                          -- مفتاح رئيسي
  Period_Id   Number(5) Default 0,                         -- فترة العمل
  Num         Number(9) NOT NULL,                          -- الرقم
  dDate       Date,                                        -- التاريخ
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Prd_MOrder_PK        PRIMARY KEY (Id),
  CONSTRAINT  Prd_MOrder_UK        Unique      (Num),
  CONSTRAINT  Prd_MOrder_Period_FK Foreign Key (Period_Id) References Cpy_Period (Id),
  CONSTRAINT  Prd_MOrder_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT  Prd_MOrder_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Prd_MOrder For Prd_Order_Mst
/
Create Sequence Prd_TOrder_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Trn                                 -- بنود أوامر التصنيع - أوامر الإنتاج
( Id          Number(10) NOT NULL,                         -- مفتاح رئيسي
  MOrd_Id     Number(5) NOT NULL,                          -- مفتاح الأمر
  Item_Id     Number(9) NOT NULL,                          -- مفتاح المادة
  Form_Id     Number(9) NOT NULL,                          -- مفتاح المعادلة
  Status_Id   Number(2) Default 0,                         -- حالة أمر الإنتاج
  Ord         Number(5) Default 0,                         -- مسلسل
  Qnt         Number(25,3) Default 0,                      -- الكمية
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Prd_TOrder_PK        PRIMARY KEY (Id),
  CONSTRAINT  Prd_TOrder_UK        Unique      (MOrd_Id, Item_Id, Form_Id),
  CONSTRAINT  Prd_TOrder_Order_FK  Foreign Key (MOrd_Id  ) References Prd_MOrder         (Id),
  CONSTRAINT  Prd_TOrder_Item_FK   Foreign Key (Item_Id  ) References Stor_Item          (Id),
  CONSTRAINT  Prd_TOrder_Form_FK   Foreign Key (Form_Id  ) References Prd_Form           (Id),
  CONSTRAINT  Prd_TOrder_Status_FK Foreign Key (Status_Id) References Prd_Cod_Prod_Status(Id),
  CONSTRAINT  Prd_TOrder_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT  Prd_TOrder_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Prd_TOrder For Prd_Order_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_Order_Exp_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Expense                             -- مصاريف أوامر التصنيع 
( Id         Number(10) NOT NULL,                          -- مفتاح رئيسي
  Period_Id  Number(5) Default 0,                          -- فترة العمل
  MOrd_Id    Number(5) NOT NULL,                           -- مفتاح الأمر
  TOrd_Id    Number(10),                                   -- مفتاح البند في أمر التصنيع أي أمر العمل
  Exp_Id     Number(5) NOT NULL,                           -- نوع المصروف
  Num        Number(9) NOT NULL,                           -- الرقم
  dDate      Date      NOT NULL,                           -- التاريخ
  Curn_Id    Number(5) Default 1,                          -- العملة
  Curn_Rate  Number(17,5) Default 1,                       -- سعر صرف العملة
  Qnt        Number(25,3) Default 0,                       -- الكمية
  Price      Number(25,3) Default 0,                       -- السعر
  Amt        Number(25,3) Default 0,                       -- القيمة
  CAmt       Number(25,3) Default 0,                       -- القيمة قطع
  Gmst_Id    Number(10),                                   -- مفتاح سندات القيد
  Cost_FId   Number(9),                                    -- مركز الكلفة
  Acc_FId    Number(9),                                    -- الحساب
  Cost_TId   Number(9),                                    -- مركز الكلفة المقابل
  Acc_TId    Number(9),                                    -- الحساب المقابل
  Rem        VarChar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Prd_Order_Exp_PK        PRIMARY KEY (Id),
  CONSTRAINT Prd_Order_Exp_UK        UNIQUE      (Period_Id, Num),
  CONSTRAINT Prd_Order_Exp_Period_FK Foreign Key (Period_Id) References Cpy_Period (Id),
  CONSTRAINT Prd_Order_Exp_MOrder_FK Foreign Key (MOrd_Id  ) References Prd_MOrder (Id),
  CONSTRAINT Prd_Order_Exp_TOrder_FK Foreign Key (TOrd_Id  ) References Prd_TOrder (Id),
  CONSTRAINT Prd_Order_Exp_Exp_FK    Foreign Key (Exp_Id   ) References Prd_Expense(Id),
  CONSTRAINT Prd_Order_Exp_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn   (Id),
  CONSTRAINT Prd_Order_Exp_FCost_FK  Foreign Key (Cost_FId ) References Acc_Cost   (Id),
  CONSTRAINT Prd_Order_Exp_TCost_FK  Foreign Key (Cost_TId ) References Acc_Cost   (Id),
  CONSTRAINT Prd_Order_Exp_FAcc_FK   Foreign Key (Acc_FId  ) References Acc_Acc    (Id),
  CONSTRAINT Prd_Order_Exp_TAcc_FK   Foreign Key (Acc_TId  ) References Acc_Acc    (Id),
  CONSTRAINT Prd_Order_Exp_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT Prd_Order_Exp_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Prd_Order_Exp For Prd_Order_Expense
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OMachine_WTime_Seq MinValue 1 Increment By 1 Cache 20;
Create Table Prd_Order_Machine_Work_Times                  -- ساعات عمل الآلات على أمر تصنيع
( Id         Number(10),                                   -- مفتاح رئيسي
  MOrd_Id    Number(5) NOT NULL,                           -- مفتاح الأمر
  TOrd_Id    Number(10),                                   -- مفتاح البند في أمر التصنيع أي أمر العمل
  Stage_Id   Number(10) NOT NULL,                          -- مرحلة الإنتاج من الدليل
  Machine_Id Number(5) NOT NULL,                           -- الآلة
  dDate      Date      NOT NULL,                           -- التاريخ
  nHour      Number(2) Default 0,                          -- ساعات
  nMinute    Number(2) Default 0,                          -- دقائق
  Rem        Varchar2(250),                                -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Prd_OMachine_WTime_PK         Primary Key (Id),
  Constraint Prd_OMachine_WTime_EIWT_UK    UNIQUE      (MOrd_Id, TOrd_Id, Machine_Id, dDate),
  CONSTRAINT Prd_OMachine_WTime_MOrder_FK  Foreign Key (MOrd_Id   ) References Prd_MOrder (Id),
  CONSTRAINT Prd_OMachine_WTime_TOrder_FK  Foreign Key (TOrd_Id   ) References Prd_TOrder (Id),
  CONSTRAINT Prd_OMachine_WTime_Stage_FK   Foreign Key (Stage_Id  ) REFERENCES Prd_Stage  (Id),
  CONSTRAINT Prd_OMachine_WTime_Machine_FK Foreign Key (Machine_Id) References Prd_Machine(Id),
  CONSTRAINT Prd_OMachine_WTime_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User   (Id),
  CONSTRAINT Prd_OMachine_WTime_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User   (Id)
)
/
Create Synonym Prd_OMachine_WTime For Prd_Order_Machine_Work_Times
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OEmp_WTime_Seq MinValue 1 Increment By 1 Cache 20;
Create Table Prd_Order_Employee_Work_Times                  -- ساعات عمل الآلات على أمر تصنيع
( Id         Number(10),                                   -- مفتاح رئيسي
  MOrd_Id    Number(5) NOT NULL,                           -- مفتاح الأمر
  TOrd_Id    Number(10),                                   -- مفتاح البند في أمر التصنيع أي أمر العمل
  Stage_Id   Number(10) NOT NULL,                          -- مرحلة الإنتاج من الدليل
  Emp_Id     Number(5) NOT NULL,                           -- الآلة
  dDate      Date      NOT NULL,                           -- التاريخ
  nHour      Number(2) Default 0,                          -- ساعات
  nMinute    Number(2) Default 0,                          -- دقائق
  Rem        Varchar2(250),                                -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Prd_OEmp_WTime_PK         Primary Key (Id),
  Constraint Prd_OEmp_WTime_EIWT_UK    UNIQUE      (MOrd_Id, TOrd_Id, Emp_Id, dDate),
  CONSTRAINT Prd_OEmp_WTime_MOrder_FK  Foreign Key (MOrd_Id ) References Prd_MOrder (Id),
  CONSTRAINT Prd_OEmp_WTime_TOrder_FK  Foreign Key (TOrd_Id ) References Prd_TOrder (Id),
  CONSTRAINT Prd_OEmp_WTime_Stage_FK   Foreign Key (Stage_Id) REFERENCES Prd_Stage  (Id),
  CONSTRAINT Prd_OEmp_WTime_Emp_FK     Foreign Key (Emp_Id  ) References Emp_Emp    (Id),
  CONSTRAINT Prd_OEmp_WTime_Ins_FK     Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT Prd_OEmp_WTime_Upd_FK     Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Prd_OEmp_WTime For Prd_Order_Employee_Work_Times
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OExec_Stage_Seq MinValue 1 Start With 1 MaxValue 999999999999 INCREMENT BY 1 CACHE 20;
Create Table Prd_Order_Execution_Stage                     -- تنفيذ مراحل امر إنتاج
( Id              Number(10) NOT NULL,                     -- مفتاح رئيسي
  TOrder_Id       Number(10) NOT NULL,                     -- بند أمر التصنيع
  Stage_Id        Number(10) NOT NULL,                     -- مرحلة الإنتاج من الدليل
  Status_Id       Number(2) Default 0,                     -- حالة المرحلة
  dDate           Date,                                    -- التاريخ
  FQnt            Number(10,3) Default 0,                  -- الكمية المنفذة من المعادلة
  Duration        Number(4) Default 0,                     -- المدة التي تم تنفيذ المرحلة بها التاريخ بها
  Emp_Id          Number(5),                               -- المشرف المسؤول
  Rem             Varchar2(500 Char),
  Ins_User        Number(5), Ins_Date Date,
  Upd_User        Number(5), Upd_Date Date,
  CONSTRAINT Prd_Oexec_Stage_Pk          Primary Key (Id),
  CONSTRAINT Prd_Oexec_Stage_Torder_Fk   Foreign Key (Torder_Id) References Prd_Torder         (Id),
  CONSTRAINT Prd_Oexec_Stage_Stage_Fk    Foreign Key (Stage_Id ) References Prd_Stage          (Id),
  CONSTRAINT Prd_Oexec_Stage_Status_Fk   Foreign Key (Status_Id) References Prd_Cod_Prod_Status(Id),
  CONSTRAINT Prd_Oexec_Stage_Super_Fk    Foreign Key (Emp_Id   ) References Emp_Emp            (Id),
  CONSTRAINT Prd_Oexec_Stage_Ins_Fk      Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT Prd_Oexec_Stage_Upd_Fk      Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Prd_OExec_Stage For Prd_Order_Execution_Stage
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OExec_Stage_Raw_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Execution_Stage_Rawmaterial         -- بنود مراحل الإنتاج - المواد الأولية
( Id           Number(10),                                 -- مفتاح رئيسي
  OExec_Id     Number(10),                                 -- مفتاح المرحلة
  Ord          Number(5) Default 0,                        -- متسلسل
  Stor_Id      Number(5),                                  -- المستودع
  Item_Id      Number(9),                                  -- المادة
  Cost_Id      Number(9),                                  -- مركز كلفة الحركة الناشئة
  Acc_Id       Number(9),                                  -- حساب الحركة الناشئة
  FQnt         Number(25,3) Default 0,                     -- الكمية المعيارية
  AQnt         Number(25,3) Default 0,                     -- الكمية الفعلية
  Cst          Number(25,3) Default 0,                     -- الكلفة الفعلية
  Descr        VarChar2(1024 Char),                        -- شرح
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_OExec_Stage_Raw_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_OExec_Stage_Raw_Stage_FK Foreign Key (OExec_Id ) References Prd_OExec_Stage (Id),
  CONSTRAINT   Prd_OExec_Stage_Raw_Stor_FK  Foreign Key (Stor_Id  ) References Stor_Store(Id),
  CONSTRAINT   Prd_OExec_Stage_Raw_Item_FK  Foreign Key (Item_Id  ) References Stor_Item (Id),
  CONSTRAINT   Prd_OExec_Stage_Raw_Cost_FK  Foreign Key (Cost_Id  ) References Acc_Cost  (Id),
  CONSTRAINT   Prd_OExec_Stage_Raw_Acc_FK   Foreign Key (Acc_Id   ) References Acc_Acc   (Id),
  CONSTRAINT   Prd_OExec_Stage_Raw_Ins_FK   Foreign Key (Ins_User ) References Cpy_User  (Id),
  CONSTRAINT   Prd_OExec_Stage_Raw_Upd_FK   Foreign Key (Upd_User ) References Cpy_User  (Id)
)
/
Create Synonym Prd_OExec_Stage_Raw For Prd_Order_Execution_Stage_Rawmaterial
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OExec_Stage_Prd_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Execution_Stage_Product             -- بنود مراحل الإنتاج - المواد المنتجة
( Id           Number(10),                                 -- مفتاح رئيسي
  OExec_Id     Number(10),                                 -- مفتاح المرحلة
  Ord          Number(5) Default 0,                        -- متسلسل
  Item_Id      Number(9),                                  -- المادة
  Cost_Id      Number(9),                                  -- مركز كلفة الحركة الناشئة
  Acc_Id       Number(9),                                  -- حساب الحركة الناشئة
  FQnt         Number(25,3) Default 0,                     -- الكمية المعيارية
  AQnt         Number(25,3) Default 0,                     -- الكمية الفعلية
  Cst          Number(25,3) Default 0,                     -- الكلفة الفعلية
  Perc         Number(7,3) Default 100,                    -- النسبة
  Descr        VarChar2(1024 Char),                        -- شرح
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_OExec_Stage_Prd_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_OExec_Stage_Prd_Stage_FK Foreign Key (OExec_Id ) References Prd_OExec_Stage(Id),
  CONSTRAINT   Prd_OExec_Stage_Prd_Item_FK  Foreign Key (Item_Id  ) References Stor_Item(Id),
  CONSTRAINT   Prd_OExec_Stage_Prd_Cost_FK  Foreign Key (Cost_Id  ) References Acc_Cost (Id),
  CONSTRAINT   Prd_OExec_Stage_Prd_Acc_FK   Foreign Key (Acc_Id   ) References Acc_Acc  (Id),
  CONSTRAINT   Prd_OExec_Stage_Prd_Ins_FK   Foreign Key (Ins_User ) References Cpy_User (Id),
  CONSTRAINT   Prd_OExec_Stage_Prd_Upd_FK   Foreign Key (Upd_User ) References Cpy_User (Id)
)
/
Create Synonym Prd_OExec_Stage_Prd For Prd_Order_Execution_Stage_Product
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OExec_Stage_Exp_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Execution_Stage_Expenses            -- بنود مراحل الإنتاج - المصاريف
( Id           Number(10),                                 -- مفتاح رئيسي
  OExec_Id     Number(10),                                 -- مفتاح المرحلة
  Ord          Number(5) Default 0,                        -- متسلسل
  Acc_EId      Number(10),                                 -- حساب المصروف
  Acc_RId      Number(10),                                 -- حساب المصروف المقابل
  FAmt         Number(25,3) Default 0,                     -- قيمة النفقات المعيارية
  AAmt         Number(25,3) Default 0,                     -- قيمة النفقات الفعلية
  Perc         Number(7,3) Default 100,                    -- النسبة
  Descr        VarChar2(1024 Char),                        -- شرح
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_OExec_Stage_Exp_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_OExec_Stage_Exp_Stage_FK Foreign Key (OExec_Id ) References Prd_OExec_Stage(Id),
  CONSTRAINT   Prd_OExec_Stage_Exp_AccR_FK  Foreign Key (Acc_RId  ) References Acc_Acc  (Id),
  CONSTRAINT   Prd_OExec_Stage_Exp_AccE_FK  Foreign Key (Acc_EId  ) References Acc_Acc  (Id),
  CONSTRAINT   Prd_OExec_Stage_Exp_Ins_FK   Foreign Key (Ins_User ) References Cpy_User (Id),
  CONSTRAINT   Prd_OExec_Stage_Exp_Upd_FK   Foreign Key (Upd_User ) References Cpy_User (Id)
)
/
Create Synonym Prd_OExec_Stage_Exp For Prd_Order_Execution_Stage_Expenses
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OExec_Stage_ISemi_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Execution_Stage_InSemiproduct       -- بنود مراحل الإنتاج - مواد نصف مصنعة داخلة
( Id           Number(10),                                 -- مفتاح رئيسي
  OExec_Id     Number(10),                                 -- مفتاح المرحلة
  Ord          Number(5) Default 0,                        -- متسلسل
  Item_Id      Number(10),                                 -- المادة
  FQnt         Number(25,3) Default 0,                     -- الكمية المعيارية
  AQnt         Number(25,3) Default 0,                     -- الكمية الفعلية
  Cst          Number(25,3) Default 0,                     -- الكلفة الفعلية
  Descr        VarChar2(1024 Char),                        -- شرح
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_OExec_Stage_ISemi_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_OExec_Stage_ISemi_Stage_FK Foreign Key (OExec_Id ) References Prd_OExec_Stage(Id),
  CONSTRAINT   Prd_OExec_Stage_ISemi_Item_FK  Foreign Key (Item_Id  ) References Stor_Item(Id),
  CONSTRAINT   Prd_OExec_Stage_ISemi_Ins_FK   Foreign Key (Ins_User ) References Cpy_User (Id),
  CONSTRAINT   Prd_OExec_Stage_ISemi_Upd_FK   Foreign Key (Upd_User ) References Cpy_User (Id)
)
/
Create Synonym Prd_OExec_Stage_ISemi For Prd_Order_Execution_Stage_InSemiproduct
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OExec_Stage_OSemi_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Execution_Stage_InSemiproduct       -- بنود مراحل الإنتاج - مواد نصف مصنعة ناتجة
( Id           Number(10),                                 -- مفتاح رئيسي
  OExec_Id     Number(10),                                 -- مفتاح المرحلة
  Ord          Number(5) Default 0,                        -- متسلسل
  Item_Id      Number(10),                                 -- المادة
  FQnt         Number(25,3) Default 0,                     -- الكمية العيارية
  AQnt         Number(25,3) Default 0,                     -- الكمية الفعلية
  Cst          Number(25,3) Default 0,                     -- الكلفة الفعلية
  Perc         Number(7,3) Default 100,                    -- النسبة
  Descr        VarChar2(1024 Char),                        -- شرح
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_OExec_Stage_OSemi_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_OExec_Stage_OSemi_Stage_FK Foreign Key (OExec_Id ) References Prd_OExec_Stage(Id),
  CONSTRAINT   Prd_OExec_Stage_OSemi_Item_FK  Foreign Key (Item_Id  ) References Stor_Item(Id),
  CONSTRAINT   Prd_OExec_Stage_OSemi_Ins_FK   Foreign Key (Ins_User ) References Cpy_User (Id),
  CONSTRAINT   Prd_OExec_Stage_OSemi_Upd_FK   Foreign Key (Upd_User ) References Cpy_User (Id)
)
/
Create Synonym Prd_OExec_Stage_OSemi For Prd_Order_Execution_Stage_OuSemiproduct
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OExec_Stage_Mach_Cat_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Execution_Stage_Machine_Category    -- بنود مراحل الإنتاج - فئات الآلات
( Id           Number(10),                                 -- مفتاح رئيسي
  OExec_Id     Number(10),                                 -- مفتاح المرحلة
  Cat_Id       Number(3),                                  -- فئة الآلة
  Machine_Id   Number(5),                                  -- الآلة
  Ord          Number(5) Default 0,                        -- متسلسل
  FQnt         Number(4) Default 0,                        -- الكمية المعيارية
  AQnt         Number(4) Default 0,                        -- الكمية الفعلية
  HCst         Number(25,3) Default 0,                     -- الكلفة الفعلية اهتلاك
  ECst         Number(25,3) Default 0,                     -- الكلفة الفعلية استهلاك كهرباء
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_OExec_Stage_Mach_Cat_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_OExec_Stage_Mach_Cat_Stage_FK Foreign Key (OExec_Id ) References Prd_OExec_Stage   (Id),
  CONSTRAINT   Prd_OExec_Stage_Mach_Cat_Cat_FK   Foreign Key (Cat_Id   ) References Prd_Cod_Mchine_Cat(Id),
  CONSTRAINT   Prd_OExec_Stage_Mach_Cat_Ins_FK   Foreign Key (Ins_User ) References Cpy_User          (Id),
  CONSTRAINT   Prd_OExec_Stage_Mach_Cat_Upd_FK   Foreign Key (Upd_User ) References Cpy_User          (Id)
)
/
Create Synonym Prd_OExec_Stage_Mach_Cat For Prd_Order_Execution_Stage_Machine_Category
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OExec_Stage_Emp_Job_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Execution_Stage_Employee_Job        -- بنود مراحل الإنتاج - وظائف العمال
( Id           Number(10),                                 -- مفتاح رئيسي
  OExec_Id     Number(10),                                 -- مفتاح المرحلة
  Job_Id       Number(5),                                  -- فئة الآلة
  Emp_Id       Number(5),                                  -- العامل
  Ord          Number(5) Default 0,                        -- متسلسل
  FQnt         Number(4) Default 0,                        -- الكمية المعيارية
  AQnt         Number(4) Default 0,                        -- الكمية الفعلية
  Cst          Number(25,3) Default 0,                     -- الكلفة الفعلية
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_OExec_Stage_Emp_Job_PK       PRIMARY KEY (Id),
  CONSTRAINT   Prd_OExec_Stage_Emp_Job_Stage_FK Foreign Key (OExec_Id ) References Prd_OExec_Stage  (Id),
  CONSTRAINT   Prd_OExec_Stage_Emp_Job_Job_FK   Foreign Key (Job_Id   ) References Emp_Cod_Job(Id),
  CONSTRAINT   Prd_OExec_Stage_Emp_Job_Ins_FK   Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT   Prd_OExec_Stage_Emp_Job_Upd_FK   Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Prd_OExec_Stage_Emp_Job For Prd_Order_Execution_Stage_Employee_Job
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OExec_Stage_QA_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Execution_Stage_QA                  -- بنود مراحل الإنتاج - الجودة
( Id           Number(10),                                 -- مفتاح رئيسي
  OExec_Id     Number(10),                                 -- مفتاح المرحلة
  List_Id      Number(5) NOT NULL,                         -- قائمة التدقيق
  Result_Id    Number(2) Default 1,                        -- النتيجة النهائية (مقبول/مرفوض/مشروط)
  Sample_Size  Number(10,3) Default 0,                     -- حجم العينة
  ReWork_Qty   Number(25,3) Default 0,                     -- الكمية المطلوب إعادة عملها
  Report_No    Varchar2(50),                               -- رقم تقرير الجودة
  Rem          VarChar2(250 Char),                         -- ملاحظات
  Ins_User     Number(10), Ins_Date     Date,
  Upd_User     Number(10), Upd_Date     Date,
  CONSTRAINT   Prd_OExec_Stage_QA_PK        PRIMARY KEY (Id),
  CONSTRAINT   Prd_OExec_Stage_QA_Stage_FK  Foreign Key (OExec_Id ) References Prd_OExec_Stage  (Id),
  CONSTRAINT   Prd_OExec_Stage_QA_List_FK   Foreign Key (List_Id  ) References Prd_QA_Checklist (Id),
  CONSTRAINT   Prd_OExec_Stage_QA_Result_FK Foreign Key (Result_Id) References Prd_Cod_QA_Result(Id),
  CONSTRAINT   Prd_OExec_Stage_QA_Ins_FK    Foreign Key (Ins_User ) References Cpy_User         (Id),
  CONSTRAINT   Prd_OExec_Stage_QA_Upd_FK    Foreign Key (Upd_User ) References Cpy_User         (Id)
)
/
Create Synonym Prd_OExec_Stage_QA For Prd_Order_Execution_Stage_QA
/
Create Sequence Prd_TExec_Stage_QA_Item_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Order_Execution_Stage_QA_Item            -- بنود قوائم تدقيق الجودة
( Id          Number(10) NOT NULL,                        -- مفتاح رئيسي
  TExec_Id    Number(5) NOT NULL,                         -- متابعة الأنتاج - قائمة الجودة
  TList_Id    Number(10) NOT NULL,                        -- بند قائمة الجودة
  Ord         Number(5) Default 0,                        -- الترتيب
  Fld_Id      Number(5) NOT NULL,                         -- الحقل
  Required_Id Number(1) Default 1,                        -- هل الحقل إجباري
  fldDValue   Date,                                       -- قيمة افتراضية تاريخ
  fldNValue   Number(25,3) Default 0,                     -- قيمة افتراضية رقمية
  fldYValue   Number(1) Default 2,                        -- قيمة افتراضية Yes/No
  fldValue    Number(3),                                  -- القيمة
  Deviation   Number(6,2) Default 0,                      -- نسبة الانحراف
  Ok_Id       Number(1) Default 2,                        -- هل القيمة مقبولة
  Rem         Varchar2(250 Char),                         -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Prd_TExec_Stage_QA_Item_PK          PRIMARY KEY (Id),
  CONSTRAINT  Prd_TExec_Stage_QA_Item_List_FK     Foreign Key (TExec_Id   ) References Prd_OExec_Stage_QA(Id),
  CONSTRAINT  Prd_TExec_Stage_QA_Item_Item_FK     Foreign Key (TList_Id   ) References Prd_QA_Item       (Id),
  CONSTRAINT  Prd_TExec_Stage_QA_Item_Fld_FK      Foreign Key (Fld_Id     ) References Prd_QA_Fld        (Id),
  CONSTRAINT  Prd_TExec_Stage_QA_Item_Required_FK Foreign Key (Required_Id) References Phs_Cod_YesNo     (Id),
  CONSTRAINT  Prd_TExec_Stage_QA_Item_Ok_FK       Foreign Key (Ok_Id      ) References Phs_Cod_YesNo     (Id),
  CONSTRAINT  Prd_TExec_Stage_QA_Item_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User          (Id),
  CONSTRAINT  Prd_TExec_Stage_QA_Item_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User          (Id)
)
/
Create Synonym Prd_TExec_Item For Prd_Order_Execution_Stage_QA_Item
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_InMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Inbound_Mst                              -- جدول ترويسة الإدخال
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                          -- فترة العمل
  Status_Id  Number(1) Default 0 NOT NULL,                -- الحالة
  Curn_Id    Number(5) NOT NULL,                          -- العملة
  Acc_Id     Number(9) NOT NULL,                          -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                -- نوع المستند
  BCurn_Id   Number(5) Default 1,                         -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                      -- سعر الصرف
  Rel_Id     Number(10),                                  -- مفتاح الأمر المشكل نتيجة تثبيت هذه الحركة
  Fin_Id     Number(10),                                  -- مفتاح الورقة المالية
  Rate       Number(10,0) Default 0 NOT NULL,             -- سعر الصرف
  Num        Number(10) Default 0,                        -- الرقم
  dDate      Date NOT NULL,                               -- التاريخ
  DocN       Varchar2(15),                                -- رقم المستند
  DocD       Date,                                        -- تاريخ المستند
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Prd_InMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Prd_InMst_Period_FK Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT Prd_InMst_Status_FK Foreign Key (Status_Id) References Prd_Cod_Status(Id),
  CONSTRAINT Prd_InMst_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Prd_InMst_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn      (Id),
  CONSTRAINT Prd_InMst_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT Prd_InMst_Fin_FK    Foreign Key (Fin_Id   ) References Fin_MCrd      (Id),
  CONSTRAINT Prd_InMst_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc   (Id),
  CONSTRAINT Prd_InMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Prd_InMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Prd_InMst For Prd_Inbound_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_InTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Inbound_Trn                              -- جدول بنود الإدخال
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Ord        Number(5) Default 0,                         -- مسلسل
  Qnt        Number(25,3) Default 0,                      -- الكمية
  WQnt       Number(25,3) Default 0,                      -- الوزن
  SWQnt      Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price      Number(25,2) Default 0,                      -- السعر
  CAmt       Number(25,2) Default 0,                      -- القيمة بالعملة
  Amt        Number(25,2) Default 0,                      -- القيمة محلي
  BAmt       Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  Vat_Perc   Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value  Number(25,2) Default 0,                      -- فيمة الVAT
  ICS_Id     Number(30),                                  -- مفتاح الباركود 
  SICS_Id    Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id    Number(5) Default 0,                         -- الوحدة
  Model_Id   Number(5) Default 0,                         -- الموديل
  Color_Id   Number(5) Default 0,                         -- اللون 
  Size_Id    Number(5) Default 0,                         -- القياس 
  nLength    Number(25,2) Default 0,                      -- الطول
  nWidth     Number(25,2) Default 0,                      -- العرض
  nHeight    Number(25,2) Default 0,                      -- الارتفاع
  Barcode    Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer     Varchar2(50 Char),                           -- طبخة/مسلسل
  SDate      Date,                                        -- تاريخ بداية
  EDate      Date,                                        -- تاريخ نهاية
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Prd_InTrn_PK       PRIMARY KEY (Id),
  CONSTRAINT Prd_InTrn_Prd_FK   Foreign Key (Mst_Id  ) References Prd_InMst      (Id),
  CONSTRAINT Prd_InTrn_Item_FK  Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT Prd_InTrn_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT Prd_InTrn_Model_FK Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT Prd_InTrn_Color_FK Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT Prd_InTrn_Size_FK  Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT Prd_InTrn_Ins_FK   Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Prd_InTrn_Upd_FK   Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Prd_InTrn For Prd_Inbound_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_RiMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Return_Inbound_Mst                       -- جدول ترويسة مردود الإدخال
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                          -- فترة العمل
  Status_Id  Number(1) Default 0 NOT NULL,                -- الحالة
  Curn_Id    Number(5) NOT NULL,                          -- العملة
  Acc_Id     Number(9) NOT NULL,                          -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                -- نوع المستند
  BCurn_Id   Number(5) Default 1,                         -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                      -- سعر الصرف
  Rel_Id     Number(10),                                  -- مفتاح الأمر المشكل نتيجة تثبيت هذه الحركة
  Fin_Id     Number(10),                                  -- مفتاح الورقة المالية
  Rate       Number(10,0) Default 0 NOT NULL,             -- سعر الصرف
  Num        Number(10) Default 0,                        -- الرقم
  dDate      Date NOT NULL,                               -- التاريخ
  DocN       Varchar2(15),                                -- رقم المستند
  DocD       Date,                                        -- تاريخ المستند
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Prd_RiMst_PK      PRIMARY KEY (Id),
  CONSTRAINT Prd_RiMst_Period_FK Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT Prd_RiMst_Status_FK Foreign Key (Status_Id) References Prd_Cod_Status(Id),
  CONSTRAINT Prd_RiMst_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Prd_RiMst_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn      (Id),
  CONSTRAINT Prd_RiMst_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT Prd_RiMst_Fin_FK    Foreign Key (Fin_Id   ) References Fin_MCrd      (Id),
  CONSTRAINT Prd_RiMst_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc   (Id),
  CONSTRAINT Prd_RiMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Prd_RiMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Prd_RiMst For Prd_Return_Inbound_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_RiTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Return_Inbound_Trn                       -- جدول بنود مردود الإدخال
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Ord        Number(5) Default 0,                         -- مسلسل
  Qnt        Number(25,3) Default 0,                      -- الكمية
  WQnt       Number(25,3) Default 0,                      -- الوزن
  SWQnt      Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price      Number(25,2) Default 0,                      -- السعر
  CAmt       Number(25,2) Default 0,                      -- القيمة بالعملة
  Amt        Number(25,2) Default 0,                      -- القيمة محلي
  BAmt       Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  Vat_Perc   Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value  Number(25,2) Default 0,                      -- فيمة الVAT
  ICS_Id     Number(30),                                  -- مفتاح الباركود 
  SICS_Id    Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id    Number(5) Default 0,                         -- الوحدة
  Model_Id   Number(5) Default 0,                         -- الموديل
  Color_Id   Number(5) Default 0,                         -- اللون 
  Size_Id    Number(5) Default 0,                         -- القياس 
  nLength    Number(25,2) Default 0,                      -- الطول
  nWidth     Number(25,2) Default 0,                      -- العرض
  nHeight    Number(25,2) Default 0,                      -- الارتفاع
  Barcode    Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer     Varchar2(50 Char),                           -- طبخة/مسلسل
  SDate      Date,                                        -- تاريخ بداية
  EDate      Date,                                        -- تاريخ نهاية
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Prd_RiTrn_PK       PRIMARY KEY (Id),
  CONSTRAINT Prd_RiTrn_Prd_FK   Foreign Key (Mst_Id  ) References Prd_RiMst     (Id),
  CONSTRAINT Prd_RiTrn_Item_FK  Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT Prd_RiTrn_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT Prd_RiTrn_Model_FK Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT Prd_RiTrn_Color_FK Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT Prd_RiTrn_Size_FK  Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT Prd_RiTrn_Ins_FK   Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Prd_RiTrn_Upd_FK   Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Prd_RiTrn For Prd_Return_Inbound_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OuMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Outbound_Mst                             -- جدول ترويسة الإخراج
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                          -- فترة العمل
  Status_Id  Number(1) Default 0 NOT NULL,                -- الحالة
  Curn_Id    Number(5) NOT NULL,                          -- العملة
  Acc_Id     Number(9) NOT NULL,                          -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                -- نوع المستند
  BCurn_Id   Number(5) Default 1,                         -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                      -- سعر الصرف
  Rel_Id     Number(10),                                  -- مفتاح الأمر المشكل نتيجة تثبيت هذه الحركة
  Fin_Id     Number(10),                                  -- مفتاح الورقة المالية
  Rate       Number(10,0) Default 0 NOT NULL,             -- سعر الصرف
  Num        Number(10) Default 0,                        -- الرقم
  dDate      Date NOT NULL,                               -- التاريخ
  DocN       Varchar2(15),                                -- رقم المستند
  DocD       Date,                                        -- تاريخ المستند
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Prd_OuMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Prd_OuMst_Period_FK Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT Prd_OuMst_Status_FK Foreign Key (Status_Id) References Prd_Cod_Status(Id),
  CONSTRAINT Prd_OuMst_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Prd_OuMst_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn      (Id),
  CONSTRAINT Prd_OuMst_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT Prd_OuMst_Fin_FK    Foreign Key (Fin_Id   ) References Fin_MCrd      (Id),
  CONSTRAINT Prd_OuMst_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc   (Id),
  CONSTRAINT Prd_OuMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Prd_OuMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Prd_OuMst For Prd_Outbound_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_OuTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Outbound_Trn                             -- جدول بنود الإخراج
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Ord        Number(5) Default 0,                         -- مسلسل
  Qnt        Number(25,3) Default 0,                      -- الكمية
  WQnt       Number(25,3) Default 0,                      -- الوزن
  SWQnt      Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price      Number(25,2) Default 0,                      -- السعر
  CAmt       Number(25,2) Default 0,                      -- القيمة بالعملة
  Amt        Number(25,2) Default 0,                      -- القيمة محلي
  BAmt       Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  Vat_Perc   Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value  Number(25,2) Default 0,                      -- فيمة الVAT
  ICS_Id     Number(30),                                  -- مفتاح الباركود 
  SICS_Id    Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id    Number(5) Default 0,                         -- الوحدة
  Model_Id   Number(5) Default 0,                         -- الموديل
  Color_Id   Number(5) Default 0,                         -- اللون 
  Size_Id    Number(5) Default 0,                         -- القياس 
  nLength    Number(25,2) Default 0,                      -- الطول
  nWidth     Number(25,2) Default 0,                      -- العرض
  nHeight    Number(25,2) Default 0,                      -- الارتفاع
  Barcode    Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer     Varchar2(50 Char),                           -- طبخة/مسلسل
  SDate      Date,                                        -- تاريخ بداية
  EDate      Date,                                        -- تاريخ نهاية
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Prd_OuTrn_PK       PRIMARY KEY (Id),
  CONSTRAINT Prd_OuTrn_Prd_FK   Foreign Key (Mst_Id  ) References Prd_OuMst      (Id),
  CONSTRAINT Prd_OuTrn_Item_FK  Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT Prd_OuTrn_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT Prd_OuTrn_Model_FK Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT Prd_OuTrn_Color_FK Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT Prd_OuTrn_Size_FK  Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT Prd_OuTrn_Ins_FK   Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Prd_OuTrn_Upd_FK   Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Prd_OuTrn For Prd_Outbound_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_RoMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Return_Outbound_Mst                      -- جدول ترويسة مردود الإخراج
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                          -- فترة العمل
  Status_Id  Number(1) Default 0 NOT NULL,                -- الحالة
  Curn_Id    Number(5) NOT NULL,                          -- العملة
  Acc_Id     Number(9) NOT NULL,                          -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                -- نوع المستند
  BCurn_Id   Number(5) Default 1,                         -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                      -- سعر الصرف
  Rel_Id     Number(10),                                  -- مفتاح الأمر المشكل نتيجة تثبيت هذه الحركة
  Fin_Id     Number(10),                                  -- مفتاح الورقة المالية
  Rate       Number(10,0) Default 0 NOT NULL,             -- سعر الصرف
  Num        Number(10) Default 0,                        -- الرقم
  dDate      Date NOT NULL,                               -- التاريخ
  DocN       Varchar2(15),                                -- رقم المستند
  DocD       Date,                                        -- تاريخ المستند
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Prd_RoMst_PK      PRIMARY KEY (Id),
  CONSTRAINT Prd_RoMst_Period_FK Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT Prd_RoMst_Status_FK Foreign Key (Status_Id) References Prd_Cod_Status(Id),
  CONSTRAINT Prd_RoMst_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Prd_RoMst_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn      (Id),
  CONSTRAINT Prd_RoMst_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT Prd_RoMst_Fin_FK    Foreign Key (Fin_Id   ) References Fin_MCrd      (Id),
  CONSTRAINT Prd_RoMst_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc   (Id),
  CONSTRAINT Prd_RoMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Prd_RoMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Prd_RoMst For Prd_Return_Outbound_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Prd_RoTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Prd_Return_Outbound_Trn                      -- جدول بنود مردود الإخراج
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Ord        Number(5) Default 0,                         -- مسلسل
  Qnt        Number(25,3) Default 0,                      -- الكمية
  WQnt       Number(25,3) Default 0,                      -- الوزن
  SWQnt      Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price      Number(25,2) Default 0,                      -- السعر
  CAmt       Number(25,2) Default 0,                      -- القيمة بالعملة
  Amt        Number(25,2) Default 0,                      -- القيمة محلي
  BAmt       Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  Vat_Perc   Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value  Number(25,2) Default 0,                      -- فيمة الVAT
  ICS_Id     Number(30),                                  -- مفتاح الباركود 
  SICS_Id    Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id    Number(5) Default 0,                         -- الوحدة
  Model_Id   Number(5) Default 0,                         -- الموديل
  Color_Id   Number(5) Default 0,                         -- اللون 
  Size_Id    Number(5) Default 0,                         -- القياس 
  nLength    Number(25,2) Default 0,                      -- الطول
  nWidth     Number(25,2) Default 0,                      -- العرض
  nHeight    Number(25,2) Default 0,                      -- الارتفاع
  Barcode    Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer     Varchar2(50 Char),                           -- طبخة/مسلسل
  SDate      Date,                                        -- تاريخ بداية
  EDate      Date,                                        -- تاريخ نهاية
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Prd_RoTrn_PK       PRIMARY KEY (Id),
  CONSTRAINT Prd_RoTrn_Prd_FK   Foreign Key (Mst_Id  ) References Prd_RoMst     (Id),
  CONSTRAINT Prd_RoTrn_Item_FK  Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT Prd_RoTrn_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT Prd_RoTrn_Model_FK Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT Prd_RoTrn_Color_FK Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT Prd_RoTrn_Size_FK  Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT Prd_RoTrn_Ins_FK   Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Prd_RoTrn_Upd_FK   Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Prd_RoTrn For Prd_Return_Outbound_Trn
/
----------------------------------------------------------------------------------------------------
