--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'ACC%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'ACC%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'ACC%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'ACC%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'ACC%' ;
----------------------------------------------------------------------------------------------------
Create Sequence AccId_Seq    MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
----------------------------------------------------------------------------------------------------
Create Sequence Acc_Cod_Doc_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Code_Document                             -- جدول ترميز أنواع مستندات المطابقة المصرفية
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),       Ins_Date Date,
  Upd_User   Number(5),       Upd_Date Date,
  CONSTRAINT Acc_Cod_Doc_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Acc_Cod_Doc_UK        UNIQUE      (Name),
  CONSTRAINT Acc_Cod_Doc_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Acc_Cod_Doc_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Acc_Cod_Doc_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Acc_Cod_Doc For Acc_Code_Document
/
Insert into Acc_Cod_Doc (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Table Acc_Code_Line_Type                            -- جدول ترميز نوع السطر
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),       Ins_Date Date,
  Upd_User   Number(5),       Upd_Date Date,
  CONSTRAINT AccCod_LineType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AccCod_LineType_UK     UNIQUE      (Name),
  CONSTRAINT AccCod_LineType_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AccCod_LineType_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Acc_Cod_LineType For Acc_Code_Line_Type
/
Insert into Acc_Cod_LineType (Id,Name) values (1,'Account');
Insert into Acc_Cod_LineType (Id,Name) values (2,'Total Account');
Insert into Acc_Cod_LineType (Id,Name) values (3,'Seperator');
----------------------------------------------------------------------------------------------------
Create Table Acc_Code_Amount_Side                          -- جدول ترميز جهة المبلغ
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),       Ins_Date Date,
  Upd_User   Number(5),       Upd_Date Date,
  CONSTRAINT AccCod_AmtSide_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AccCod_AmtSide_UK     UNIQUE      (Name),
  CONSTRAINT AccCod_AmtSide_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AccCod_AmtSide_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Acc_Cod_AmtSide For Acc_Code_Amount_Side
/
Insert into Acc_Cod_AmtSide (Id,Name) values (1,'As Kind');
Insert into Acc_Cod_AmtSide (Id,Name) values (2,'As Balance');
Insert into Acc_Cod_AmtSide (Id,Name) values (3,'Debit Side');
Insert into Acc_Cod_AmtSide (Id,Name) values (4,'Credit Side');
----------------------------------------------------------------------------------------------------
Create Table Acc_Code_Report_Amount                        -- جدول ترميز المبلغ في التقرير
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),       Ins_Date Date,
  Upd_User   Number(5),       Upd_Date Date,
  CONSTRAINT AccCod_RepAmt_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AccCod_RepAmt_UK     UNIQUE      (Name),
  CONSTRAINT AccCod_RepAmt_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AccCod_RepAmt_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Acc_Cod_RepAmt For Acc_Code_Report_Amount
/
Insert into Acc_Cod_RepAmt (Id,Name) values (1,'Balance');
Insert into Acc_Cod_RepAmt (Id,Name) values (2,'Total Debits');
Insert into Acc_Cod_RepAmt (Id,Name) values (3,'Total Credits');
----------------------------------------------------------------------------------------------------
Create Sequence Acc_Close_Seq MinValue 1 Start With 1 MaxValue 999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Close_Account                             -- جدول ترميز حساب الإغلاق
( Id         Number(3) NOT NULL,                           -- مفتاح رئيسي
  Ord        Number(3) Default 0 NOT NULL,                 -- الترتيب
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),       Ins_Date Date,
  Upd_User   Number(5),       Upd_Date Date,
  CONSTRAINT Acc_Close_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Acc_Close_UK     UNIQUE      (Name),
  CONSTRAINT Acc_Close_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Acc_Close_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Acc_Close For Acc_Close_Account
/
Insert into Acc_Close (Id,Ord,Name) values (0,90,'Balance Sheet');
Insert into Acc_Close (Id,Ord,Name) values (1,30,'Profit And Loss');
Insert into Acc_Close (Id,Ord,Name) values (2,20,'Trade');
Insert into Acc_Close (Id,Ord,Name) values (3,10,'Production');
----------------------------------------------------------------------------------------------------
Create Sequence Acc_Cost_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Cost_Centers                              -- دليل مراكز الكلفة
( Id          Number(9) NOT NULL,                          -- مفتاح رئيسي
  Num         Varchar2(15 Char) NOT NULL,                  -- رقم المركز
  Name        Varchar2(200 Char) NOT NULL,                 -- الاسم
  Type_Id     Number(5) Default 2,                         -- النوع
  Status_Id   Number(5) Default 1,                         -- الحالة
  PId         Number(9),                                   -- الأب
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),       Ins_Date Date,
  Upd_User    Number(5),       Upd_Date Date,
  CONSTRAINT  Acc_Cost_PK        PRIMARY KEY (Id),
  CONSTRAINT  Acc_Cost_UK        UNIQUE      (Num),
  CONSTRAINT  Acc_Cost_Type_FK   Foreign Key (Type_Id  ) References Phs_Cod_Type  (Id),
  CONSTRAINT  Acc_Cost_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  Acc_Cost_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Acc_Cost_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Acc_Cost For Acc_Cost_Centers
/

Create Sequence Acc_Acc_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Account                                   -- دليل الحسابات
( Id          Number(9) NOT NULL,                          -- مفتاح رئيسي
  Num         Varchar2(25 Char) NOT NULL,                  -- رقم الحساب
  PNum        Varchar2(25 Char),                           -- رقم الحساب الطباعي
  Name        Varchar2(200 Char) NOT NULL,                 -- الاسم
  Type_Id     Number(5) Default 2,                         -- النوع
  Status_Id   Number(5) Default 1,                         -- الحالة
  DBCR_Id     Number(5) Default 1,                         -- طبيعة الحساب مدين/دائن
  Close_Id    Number(3) Default 1,                         -- عائدية الحساب/حساب الإغلاق
  PId         Number(9),                                   -- الأب
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),       Ins_Date Date,
  Upd_User    Number(5),       Upd_Date Date,
  CONSTRAINT  Acc_Acc_PK        PRIMARY KEY (Id ),
  CONSTRAINT  Acc_Acc_UK        UNIQUE      (Num),
  CONSTRAINT  Acc_Acc_Type_FK   Foreign Key (Type_Id  ) References Phs_Cod_Type  (Id),
  CONSTRAINT  Acc_Acc_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  Acc_Acc_DBCR_FK   Foreign Key (DBCR_Id  ) References Phs_Cod_DBCR  (Id),
  CONSTRAINT  Acc_Acc_Close_FK  Foreign Key (Close_Id ) References Acc_Close     (Id),
  CONSTRAINT  Acc_Acc_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Acc_Acc_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Acc_Acc For Acc_Account
/

Create Sequence Acc_GrantAcc_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Grant_Account                             -- دليل الحسابات
( Id          Number(9) NOT NULL,                          -- مفتاح رئيسي
  System_Id   Number(5) Default 0,                         -- النظام
  Acc_Id      Number(9) NOT NULL,                          -- الحساب
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),       Ins_Date Date,
  Upd_User    Number(5),       Upd_Date Date,
  CONSTRAINT  Acc_GrantAcc_PK        PRIMARY KEY (Id ),
  CONSTRAINT  Acc_GrantAcc_UK        UNIQUE      (System_Id, Acc_Id),
  CONSTRAINT  Acc_GrantAcc_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT  Acc_GrantAcc_System_FK Foreign Key (System_Id) References Phs_Cod_System(Id),
  CONSTRAINT  Acc_GrantAcc_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Acc_GrantAcc_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Acc_GrantAcc For Acc_Grant_Account
/

Create Sequence Acc_BudMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Budget_Master                             -- ترويسة الموازنة
( Id          Number(10),                                  -- مفتاح رئيسي
  Num         Number(9) NOT NULL,                          -- رقم
  BDate       Date NOT NULL,                               -- تاريخ
  Name        Varchar2(200 Char) NOT NULL,                 -- الاسم
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Acc_BudMst_PK      Primary Key (Id ),
  CONSTRAINT  Acc_BudMst_UK      Unique      (Num),
  CONSTRAINT  Acc_BudMst_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT  Acc_BudMst_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Acc_BudMst For Acc_Budget_Master
/

Create Sequence Acc_BudTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Budget_Transaction                        -- بنود الموازنة
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Mst_Id     Number(10) NOT NULL,                          -- مفتاح الأب
  Acc_Id     Number(9) Default 0,                          -- الحساب
  Cost_Id    Number(9) Default 0,                          -- المركز
  Ord        Number(5) Default 0,                          -- مسلسل الإظهار
  Bud        Number(25,3) Default 0,                       -- مبلغ الموازنة
  Rem        Varchar2(100 Char),                           -- البيان
  Ins_User   Number(5),  Ins_Date  Date,
  Upd_User   Number(5),  Upd_Date  Date,
  CONSTRAINT Acc_BudTrn_PK      PRIMARY KEY (Id),
  CONSTRAINT Acc_BudTrn_Mst_FK  Foreign Key (Mst_Id  ) References Acc_BudMst(Id),
  CONSTRAINT Acc_BudTrn_Acc_FK  Foreign Key (Acc_Id  ) References Acc_Acc   (Id),
  CONSTRAINT Acc_BudTrn_Cost_FK Foreign Key (Cost_Id ) References Acc_Cost  (Id),
  CONSTRAINT Acc_BudTrn_Ins_FK  Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT Acc_BudTrn_Upd_FK  Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Acc_BudTrn For Acc_Budget_Transaction
/

Create Sequence Acc_Mst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Master                                    -- ترويسة سندات القيد
( Id          Number(10),                                  -- مفتاح رئيسي
  Bran_Id     Number(5) Default 0,                         -- الفرع
  Period_Id   Number(5) Default 0,                         -- فترة العمل
  Src_Id      Number(5) Default 0,                         -- أصل السند - رقم النظام الذي شكل السند آلياً أو 0 يدوي
  Commit_Id   Number(1) Default 0,                         -- الحالة
  Num         Number(9) NOT NULL,                          -- رقم السند
  PNum        Number(9) NOT NULL,                          -- رقم السند الطباعي - الرقم الذي يطبع على اليومية
  MDate       Date NOT NULL,                               -- تاريخ السند
  Doc_Id      Number(5) Default 0,                         -- نوع المستند
  Docn        Varchar2(15 Char),                           -- رقم المستند
  Docd        Date,                                        -- تاريخ المستند
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Acc_Mst_PK        Primary Key (Id ),
  CONSTRAINT  Acc_Mst_UK        Unique      (Bran_Id,Period_Id,Num),
  CONSTRAINT  Acc_Mst_Period_FK Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT  Acc_Mst_Bran_FK   Foreign Key (Bran_Id  ) References Cpy_Bran      (Id),
  CONSTRAINT  Acc_Mst_Commit_FK Foreign Key (Commit_Id) References Phs_Cod_Commit(Id),
  CONSTRAINT  Acc_Mst_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc   (Id),
  CONSTRAINT  Acc_Mst_Src_FK    Foreign Key (Src_Id   ) References Phs_Cod_Src   (Id),
  CONSTRAINT  Acc_Mst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Acc_Mst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Acc_Mst For Acc_Master
/

Create Sequence Acc_Trn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Transaction                               -- بنود سندات القيد
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Mst_Id     Number(10) NOT NULL,                          -- مفتاح الأب
  Acc_Id     Number(9) NOT NULL,                           -- الحساب
  Cost_Id    Number(9) NOT NULL,                           -- المركز
  Acc_RId    Number(9) Default 0,                          -- الحساب المقابل
  TDoc_Id    Number(5) Default 0,                          -- نوع المستند
  TDocn      Varchar2(15 Char),                            -- رقم المستند
  TDocd      Date,                                         -- تاريخ المستند
  Ord        Number(5) Default 0,                          -- مسلسل
  Deb        Number(25,2) Default 0,                       -- المبلغ مدين محلي
  Crd        Number(25,2) Default 0,                       -- المبلغ دائن محلي
  Curn_Id    Number(3) Default 1,                          -- العملة
  Curn_Rate  Number(25,9) Default 1,                       -- سعر الصرف
  DebC       Number(25,3) Default 0,                       -- المبلغ مدين عملة
  CrdC       Number(25,3) Default 0,                       -- المبلغ دائن عملة
  Rem        Varchar2(250 Char),                           -- البيان
  RId        Number(20) Default 0,                         -- مفتاح الوثيقة المقابلة
  SRem       Varchar2(100 Char),                           -- ملاحظات النظام عند الترحيل
  Ins_User   Number(5),  Ins_Date  Date,
  Upd_User   Number(5),  Upd_Date  Date,
  CONSTRAINT Acc_Trn_PK      PRIMARY KEY (Id),
  CONSTRAINT Acc_Trn_Mst_FK  Foreign Key (Mst_Id  ) References Acc_Mst    (Id),
  CONSTRAINT Acc_Trn_Acc_FK  Foreign Key (Acc_Id  ) References Acc_Acc    (Id),
  CONSTRAINT Acc_Trn_Cost_FK Foreign Key (Cost_Id ) References Acc_Cost   (Id),
  CONSTRAINT Acc_Trn_RAcc_FK Foreign Key (Acc_RId ) References Acc_Acc    (Id),
  CONSTRAINT Acc_Trn_Doc_FK  Foreign Key (TDoc_Id ) References Acc_Cod_Doc(Id),
  CONSTRAINT Acc_Trn_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn   (Id),
  CONSTRAINT Acc_Trn_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT Acc_Trn_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Acc_Trn For Acc_Transaction
/

Create Sequence Acc_Bank_Mst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Bank_Master                               -- ترويسة جدول المطابقة المصرفية
( Id          Number(10),                                  -- مفتاح رئيسي
  Bran_Id     Number(5) Default 0,                         -- الفرع
  Period_Id   Number(3) Default 0,                         -- فترة العمل
  Num         Number(9) NOT NULL,                          -- رقم السند
  MDate       Date NOT NULL,                               -- تاريخ السند
  Acc_Id      Number(9) NOT NULL,                          -- الحساب
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Acc_Bank_Mst_PK        Primary Key (Id ),
  CONSTRAINT  Acc_Bank_Mst_UK        Unique      (Bran_Id,Period_Id,Num),
  CONSTRAINT  Acc_Bank_Mst_Period_FK Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT  Acc_Bank_Mst_Bran_FK   Foreign Key (Bran_Id  ) References Cpy_Bran      (Id),
  CONSTRAINT  Acc_Bank_Mst_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT  Acc_Bank_Mst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Acc_Bank_Mst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Acc_Bank_Mst For Acc_Bank_Master
/

Create Sequence Acc_Bank_Trn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Bank_Transaction                          -- بنود سندات القيد
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Mst_Id     Number(10) NOT NULL,                          -- مفتاح الأب
  TDoc_Id    Number(5) Default 0,                          -- نوع المستند
  TDocn      Varchar2(15 Char),                            -- رقم المستند
  TDocd      Date,                                         -- تاريخ المستند
  Ord        Number(5) Default 0,                          -- مسلسل
  Deb        Number(25,2) Default 0,                       -- المبلغ مدين محلي
  Crd        Number(25,2) Default 0,                       -- المبلغ دائن محلي
  Curn_Id    Number(3) Default 1,                          -- العملة
  Curn_Rate  Number(25,9) Default 1,                       -- سعر الصرف
  DebC       Number(25,3) Default 0,                       -- المبلغ مدين عملة
  CrdC       Number(25,3) Default 0,                       -- المبلغ دائن عملة
  Rem        Varchar2(250 Char),                           -- البيان
  Ins_User   Number(5),  Ins_Date  Date,
  Upd_User   Number(5),  Upd_Date  Date,
  CONSTRAINT Acc_Bank_Trn_PK      PRIMARY KEY (Id),
  CONSTRAINT Acc_Bank_Trn_Mst_FK  Foreign Key (Mst_Id  ) References Acc_Bank_Mst(Id),
  CONSTRAINT Acc_Bank_Trn_Doc_FK  Foreign Key (TDoc_Id ) References Acc_Cod_Doc (Id),
  CONSTRAINT Acc_Bank_Trn_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn    (Id),
  CONSTRAINT Acc_Bank_Trn_Ins_FK  Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Acc_Bank_Trn_Upd_FK  Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Acc_Bank_Trn For Acc_Bank_Transaction
/

Create Sequence Acc_Tot_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Total                                     -- دليل مجمع الحسابات
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Num        Varchar2(15 Char) NOT NULL,                   -- رقم
  Name       Varchar2(200 Char) NOT NULL,                  -- اسم
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Acc_Tot_PK        PRIMARY KEY (Id ),
  CONSTRAINT Acc_Tot_UK        UNIQUE      (Num),
  CONSTRAINT Acc_Tot_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Acc_Tot_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Acc_Tot For Acc_Total
/

Create Sequence Acc_TotAcc_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Total_Accounts                            -- دليل بنود مجمع الحسابات
( Id         Number(10) NOT NULL,                          -- مفتاح رئيسي
  Tot_Id     Number(5) Default 0,                          -- المجمع
  Cost_Id    Number(9) Default 0,                          -- المركز
  Acc_Id     Number(9) Default 0,                          -- الحساب
  Sign_Id    Number(1) Default 1,                          -- الإشارة - 1=جمع أو -1=طرح
  AmtTyp_Id  Number(1) Default 1,                          -- نوع المبلغ 1 = الرصيد \ 2 = الطرف المدين \ 3 = الطرف الدائن
  Perc       Number(6,2) Default 100,                      -- النسبة
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Acc_TotAcc_PK        PRIMARY KEY (Id),
  CONSTRAINT Acc_TotAcc_UK        UNIQUE      (Tot_Id, Cost_Id, Acc_Id),
  CONSTRAINT Acc_TotAcc_Tot_FK    Foreign Key (Tot_Id   ) References Acc_Tot       (Id),
  CONSTRAINT Acc_TotAcc_Cost_FK   Foreign Key (Cost_Id  ) References Acc_Cost      (Id),
  CONSTRAINT Acc_TotAcc_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT Acc_TotAcc_AmtTyp_FK Foreign Key (AmtTyp_Id) References Acc_Cod_RepAmt(Id),
  CONSTRAINT Acc_TotAcc_Sign_FK   Foreign Key (Sign_Id  ) References Phs_Cod_Sign  (Id),
  CONSTRAINT Acc_TotAcc_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Acc_TotAcc_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Acc_TotAcc For Acc_Total_Accounts
/

Create Sequence Acc_Rep_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Report                                    -- دليل ترويسة قوالب التقارير
( Id          Number(10) NOT NULL,                         -- مفتاح رئيسي
  Name        Varchar2(200 Char) NOT NULL,                 -- الاسم
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Acc_Rep_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  Acc_Rep_UK        UNIQUE      (Name),
  CONSTRAINT  Acc_Rep_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Acc_Rep_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Acc_Rep For Acc_Report
/

Create Sequence Acc_RepItm_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Acc_Report_Items                              -- دليل بنود قوالب التقارير
( Id          Number(20) NOT NULL,                         -- مفتاح رئيسي
  Rep_Id      Number(10) NOT NULL,                         -- مفتاح الأب
  Ord         Number(5) Default 0,                         -- مسلسل السطر
  LineType_Id Number(5) Default 1,                         -- نوع السطر
  AmtSide_Id  Number(5) Default 1,                         -- اتجاه المبلغ
  AmtTyp_Id   Number(5) Default 1,                         -- نوع المبلغ 1 = الرصيد \ 2 = الطرف المدين \ 3 = الطرف الدائن
  Perc        Number(6,2) Default 100,                     -- النسبة
  Acc_Id      Number(9) Default 0,                         -- الحساب
  Tot_Id      Number(5) Default 0,                         -- مجمع الحسابات
  Cost_Id     Number(9) Default 0,                         -- المركز
  Label       Varchar2(100 Char),                          -- البيان
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT Acc_RepItm_PK        PRIMARY KEY (Id),
  CONSTRAINT Acc_RepItm_FK        Foreign Key (Rep_Id     ) References Acc_Rep         (Id),
  CONSTRAINT Acc_RepItm_Acc_FK    Foreign Key (Acc_Id     ) References Acc_Acc         (Id),
  CONSTRAINT Acc_RepItm_Tot_FK    Foreign Key (Tot_Id     ) References Acc_Tot         (Id),
  CONSTRAINT Acc_RepItm_Cost_FK   Foreign Key (Cost_Id    ) References Acc_Cost        (Id),
  CONSTRAINT Acc_RepItm_LinTyp_FK Foreign Key (LineType_Id) References Acc_Cod_LineType(Id),
  CONSTRAINT Acc_RepItm_AmtSid_FK Foreign Key (AmtSide_Id ) References Acc_Cod_AmtSide (Id),
  CONSTRAINT Acc_RepItm_AmtTyp_FK Foreign Key (AmtTyp_Id  ) References Acc_Cod_RepAmt  (Id),
  CONSTRAINT Acc_RepItm_Ins_FK    Foreign Key (Ins_User   ) References Cpy_User        (Id),
  CONSTRAINT Acc_RepItm_Upd_FK    Foreign Key (Upd_User   ) References Cpy_User        (Id)
)
/
Create Synonym Acc_RepItm For Acc_Report_Items
/










Create Table Acc_Generate_Reports                          -- جدول تنفيذ التقارير يستخدم لحظة التنفيذ
( Id         Number(20) NOT NULL,                          -- رقم المهمة رقم آلي للتقرير المنفذ حالياً
  Ord        Number(5) Default 0,                          -- مسلسل الطباعة
  TypeD_Id   Number(5) Default 1,                          -- نوع السطر مدين
  TypeC_Id   Number(5) Default 1,                          -- نوع السطر دائن
  Rep_Id     Number(9) Default 0,                          -- التقرير
  Acc_Id     Number(9) Default 0,                          -- الحساب
  Cost_Id    Number(9) Default 0,                          -- المركز
  Tot_Id     Number(5) Default 0,                          -- مجمع الحسابات
  Deb        Number(25,3) Default 0,                       -- المبلغ مدين
  Crd        Number(25,3) Default 0,                       -- المبلغ دائن
  PDeb       Number(25,3) Default 0,                       -- المبلغ مدين مقارن
  PCrd       Number(25,3) Default 0,                       -- المبلغ دائن مقارن
  Bud        Number(25,3) Default 0,                       -- المبلغ في الموازنة
  BudP       Number(10,2) Default 0,                       -- نسبة الرصيد للموازنة
  LabelD     Varchar2(100 Char),                           -- البيان مدين
  LabelC     Varchar2(100 Char),                           -- البيان دائن
  Seper      Varchar2(2000 Char),                          -- الفاصل
  CONSTRAINT Acc_GenRep_PK PRIMARY KEY (Rep_Id,Ord)
)
/
Create Synonym Acc_GenRep For Acc_Generate_Reports
/

Create Table Acc_Ages_Temporary                            -- جدول تنفيذ استعلام أعمار الذمم 
( Id           Number(20) NOT NULL,                        -- مفتاح رئيسي
  Session_Id   Number(20) NOT NULL,                        -- جلسة العمل
  Mst_Id       Number(10),                                 -- مفتاح السند
  Num          Number(9),                                  -- رقم السند
  MDate        Date,                                       -- تاريخ السند
  MRem         Varchar2(250 Char),                         -- ملاحظات
  Acc_Id       Number(9),                                  -- الحساب
  Cost_Id      Number(9),                                  -- المركز
  Rel_Id       Number(9),                                  -- مفتاح الوثيقة المقابلة
  Acc_DBCR     Number(5) Default 1,                        -- المدين \ الدائن
  Deb          Number(25,2) Default 0,                     -- المبلغ مدين محلي
  Crd          Number(25,2) Default 0,                     -- المبلغ دائن محلي
  DebSYP       Number(25,2) Default 0,                     -- المبلغ مدين
  CrdSYP       Number(25,2) Default 0,                     -- المبلغ دائن
  DebUSD       Number(25,2) Default 0,                     -- المبلغ مدين
  CrdUSD       Number(25,2) Default 0,                     -- المبلغ دائن
  DebEUR       Number(25,2) Default 0,                     -- المبلغ مدين
  CrdEUR       Number(25,2) Default 0,                     -- المبلغ دائن
  BDeb         Number(25,2) Default 0,                     -- المبلغ مدين محلي
  BCrd         Number(25,2) Default 0,                     -- المبلغ دائن محلي
  BDebSYP      Number(25,2) Default 0,                     -- المبلغ مدين
  BCrdSYP      Number(25,2) Default 0,                     -- المبلغ دائن
  BDebUSD      Number(25,2) Default 0,                     -- المبلغ مدين
  BCrdUSD      Number(25,2) Default 0,                     -- المبلغ دائن
  BDebEUR      Number(25,2) Default 0,                     -- المبلغ مدين
  BCrdEUR      Number(25,2) Default 0,                     -- المبلغ دائن
  TRem         Varchar2(250 Char),                         -- البيان
  CONSTRAINT   Acc_TmpAge_PK PRIMARY KEY (Id)
)
/
Create Synonym Acc_TmpAge For Acc_Ages_Temporary
/
Create INDEX Acc_TmpAge_Session_IDX ON Acc_Ages_Temporary(Session_Id)
/
Create INDEX Acc_TmpAge_Acc_IDX     ON Acc_Ages_Temporary(Acc_Id)
/
Create INDEX Acc_TmpAge_Date_IDX    ON Acc_Ages_Temporary(MDate)
/
Update Acc_Code_Report_Amount Set Name='رصيد'         Where Id=1;
Update Acc_Code_Report_Amount Set Name='مدين'         Where Id=2;
Update Acc_Code_Report_Amount Set Name='دائن'         Where Id=3;

Update Acc_Code_Amount_Side   Set Name='طبيعة الحساب' Where Id=1;
Update Acc_Code_Amount_Side   Set Name='رصيد'         Where Id=2;
Update Acc_Code_Amount_Side   Set Name='مدين'         Where Id=3;
Update Acc_Code_Amount_Side   Set Name='دائن'         Where Id=4;

Update Acc_Code_Line_Type     Set Name='حساب'         Where Id=1;
Update Acc_Code_Line_Type     Set Name='حساب تجميعي'  Where Id=2;
Update Acc_Code_Line_Type     Set Name='فاصل'         Where Id=3;
