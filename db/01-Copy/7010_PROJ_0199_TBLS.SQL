--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'PROJ%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'PROJ%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'PROJ%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'PROJ%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'PROJ%' ;
--ALTER TABLE Copy_Task DROP CONSTRAINT Cpy_Task_Proj_FK;
----------------------------------------------------------------------------------------------------
Create Table Proj_Code_Status                              -- جدول ترميز 
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Status For Proj_Code_Status
/
Insert into Proj_Cod_Status (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Table Proj_Code_MeetType                              -- جدول ترميز 
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_MeetType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_MeetType_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_MeetType_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_MeetType_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_MeetType For Proj_Code_MeetType
/
Insert into Proj_Cod_MeetType (Id,Name) values (0,'داخلي');
Insert into Proj_Cod_MeetType (Id,Name) values (1,'خارجي');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Meetkind_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_MeetKind                              -- جدول ترميز 
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_MeetKind_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_MeetKind_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_MeetKind_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_MeetKind_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_MeetKind For Proj_Code_MeetKind
/
Insert into Proj_Cod_MeetKind (Id,Name) values (0,'-');
Insert into Proj_Cod_MeetKind (Id,Name) values (1,'فني');
----------------------------------------------------------------------------------------------------
Create Table Proj_Code_Rate                              -- جدول ترميز 
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Rate_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Rate_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Rate_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Rate_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Rate For Proj_Code_Rate
/
Insert into Proj_Cod_Rate (Id,Name) values (0,'-');
Insert into Proj_Cod_Rate (Id,Name) values (1,'1');
Insert into Proj_Cod_Rate (Id,Name) values (2,'2');
Insert into Proj_Cod_Rate (Id,Name) values (3,'3');
Insert into Proj_Cod_Rate (Id,Name) values (4,'4');
Insert into Proj_Cod_Rate (Id,Name) values (5,'5');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Priority_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Priority                            -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Priority_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Priority_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Priority_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Priority_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Priority For Proj_Code_Priority
/
Insert into Proj_Cod_Priority (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Type_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Type                                -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Type_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Type_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Type_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Type_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Type For Proj_Code_Type
/
Insert into Proj_Cod_Type (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Proj_Class1_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Project_Class1                      -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Proj_Class1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Proj_Class1_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Proj_Class1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Proj_Class1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Proj_Class1 For Proj_Code_Project_Class1
/
Insert into Proj_Cod_Proj_Class1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Proj_Class2_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Project_Class2                      -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Proj_Class2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Proj_Class2_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Proj_Class2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Proj_Class2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Proj_Class2 For Proj_Code_Project_Class2
/
Insert into Proj_Cod_Proj_Class2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Proj_Class3_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Project_Class3                      -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Proj_Class3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Proj_Class3_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Proj_Class3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Proj_Class3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Proj_Class3 For Proj_Code_Project_Class3
/
Insert into Proj_Cod_Proj_Class3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Team_Class1_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Team_Class1                         -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Team_Class1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Team_Class1_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Team_Class1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Team_Class1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Team_Class1 For Proj_Code_Team_Class1
/
Insert into Proj_Cod_Team_Class1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Team_Class2_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Team_Class2                         -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Team_Class2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Team_Class2_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Team_Class2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Team_Class2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Team_Class2 For Proj_Code_Team_Class2
/
Insert into Proj_Cod_Team_Class2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Team_Class3_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Team_Class3                         -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Team_Class3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Team_Class3_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Team_Class3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Team_Class3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Team_Class3 For Proj_Code_Team_Class3
/
Insert into Proj_Cod_Team_Class3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Team_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Team_Members
( Id         Number(5) NOT NULL,                           -- PK
  User_Id    Number(5) NOT NULL,                           -- Related User
  Status_Id  Number(1) DEFAULT 1 NOT NULL,                 -- Status
  Class1_Id  Number(5) DEFAULT 0 NOT NULL,                 -- Member Classification 1
  Class2_Id  Number(5) DEFAULT 0 NOT NULL,                 -- Member Classification 2
  Class3_Id  Number(5) DEFAULT 0 NOT NULL,                 -- Member Classification 3
  Name       Varchar2(100 Char) NOT NULL,                  -- Name
  Image      Varchar2(512 Char),                           -- User Image
  Rem        Varchar2(100 Char),                           -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Team_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Team_UK        UNIQUE      (Name),
  CONSTRAINT Proj_Team_User_FK   Foreign Key (User_Id  ) References Cpy_User            (Id),
  CONSTRAINT Proj_Team_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status      (Id),
  CONSTRAINT Proj_Team_Class1_FK Foreign Key (Class1_Id) References Proj_Cod_Team_Class1(Id),
  CONSTRAINT Proj_Team_Class2_FK Foreign Key (Class2_Id) References Proj_Cod_Team_Class2(Id),
  CONSTRAINT Proj_Team_Class3_FK Foreign Key (Class3_Id) References Proj_Cod_Team_Class3(Id),
  CONSTRAINT Proj_Team_Ins_FK    Foreign Key (Ins_User ) References Cpy_User            (Id),
  CONSTRAINT Proj_Team_Upd_FK    Foreign Key (Upd_User ) References Cpy_User            (Id)
)
/
Create Synonym Proj_Team For Proj_Team_Members
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Team_RateMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Team_RatingMst
( Id         Number(9) NOT NULL,                          -- PK
  Team_Id    Number(9) NOT NULL,                          -- Team
  SDate      Date NOT NULL,                               -- start Date
  EDate      Date NOT NULL,                               -- end Date
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Team_RateMst_PK      PRIMARY KEY (Id),
  CONSTRAINT Proj_Team_RateMst_Team_FK Foreign Key (Team_Id ) References Proj_Team(Id),
  CONSTRAINT Proj_Team_RateMst_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Proj_Team_RateMst_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Proj_Team_RateMst For Proj_Team_RatingMst
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Team_RateTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Team_RatingTrn
( Id         Number(9) NOT NULL,                          -- PK
  Mst_Id     Number(9) NOT NULL,                          -- Mst Id
  Rate_Id    Number(1) DEFAULT 0 NOT NULL,                -- Rate  
  User_Id    Number(9) NOT NULL,                          -- user
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Team_RateTrn_PK      PRIMARY KEY (Id),
  CONSTRAINT Proj_Team_RateTrn_Mst_FK  Foreign Key (Mst_Id  ) References Proj_Team_RateMst(Id),
  CONSTRAINT Proj_Team_RateTrn_Rate_FK Foreign Key (Rate_Id ) References Proj_Cod_Rate    (Id),
  CONSTRAINT Proj_Team_RateTrn_Ins_FK  Foreign Key (Ins_User) References Cpy_User         (Id),
  CONSTRAINT Proj_Team_RateTrn_Upd_FK  Foreign Key (Upd_User) References Cpy_User         (Id)
)
/
Create Synonym Proj_Team_RateTrn For Proj_Team_RatingTrn
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Proj_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project
( Id          Number(5) NOT NULL,                          -- PK
  Proj_Id     Number(5),                                   -- ؛قختثؤف
  Team_Id     Number(5) DEFAULT 0 NOT NULL,                -- Manager
  Type_Id     NUmber(2) DEFAULT 0 NOT NULL,                -- Project Type
  Priority_Id NUmber(2) DEFAULT 1 NOT NULL,                -- Priority
  Status_Id   Number(1) DEFAULT 1 NOT NULL,                -- Status
  Class1_Id   NUmber(5) DEFAULT 0 NOT NULL,                -- Project Classification 1
  Class2_Id   NUmber(5) DEFAULT 0 NOT NULL,                -- Project Classification 2
  Class3_Id   NUmber(5) DEFAULT 0 NOT NULL,                -- Project Classification 3
  Acc_Id      Number(9) DEFAULT 0 NOT NULL,                -- Project Account
  Cost_Id     Number(9) DEFAULT 0 NOT NULL,                -- Project Cost Center
  Name        Varchar2(100 Char) NOT NULL,                 -- Project Name
  Customer    Varchar2(100 Char) NOT NULL,                 -- Customer
  SDate       Date NOT NULL,                               -- Start Date
  EDate       Date NOT NULL,                               -- End Date
  ASDate      Date,                                        -- Start Date
  AEDate      Date,                                        -- End Date
  Progress    Number(3) DEFAULT 0 NOT NULL,                -- Progress Percent
  Rem         Varchar2(100 Char),                          -- Remrks
  Descr       Varchar2(4000 Char),                         -- Project Description
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Proj_Proj_PK          PRIMARY KEY (Id  ),
  CONSTRAINT  Proj_Proj_UK          UNIQUE      (Name),
  CONSTRAINT  Proj_Proj_Team_FK     Foreign Key (Team_Id    ) References Proj_Team           (Id),
  CONSTRAINT  Proj_Proj_Type_FK     Foreign Key (Type_Id    ) References Proj_Cod_Type       (Id),
  CONSTRAINT  Proj_Proj_Priority_FK Foreign Key (Priority_Id) References Proj_Cod_Priority   (Id),
  CONSTRAINT  Proj_Proj_Status_FK   Foreign Key (Status_Id  ) References Proj_Cod_Status     (Id),
  CONSTRAINT  Proj_Proj_Class1_FK   Foreign Key (Class1_Id  ) References Proj_Cod_Proj_Class1(Id),
  CONSTRAINT  Proj_Proj_Class2_FK   Foreign Key (Class2_Id  ) References Proj_Cod_Proj_Class2(Id),
  CONSTRAINT  Proj_Proj_Class3_FK   Foreign Key (Class3_Id  ) References Proj_Cod_Proj_Class3(Id),
  CONSTRAINT  Proj_Proj_Acc_FK      Foreign Key (Acc_Id     ) References Acc_Acc             (Id),
  CONSTRAINT  Proj_Proj_Cost_FK     Foreign Key (Cost_Id    ) References Acc_Cost            (Id),
  CONSTRAINT  Proj_Proj_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User            (Id),
  CONSTRAINT  Proj_Proj_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User            (Id)
)
/
Create Synonym Proj_Proj For Proj_Project
/
ALTER TABLE Proj_Project ADD CONSTRAINT Proj_Proj_Proj_FK Foreign Key (Proj_Id) References Proj_Proj(Id);
----------------------------------------------------------------------------------------------------done
--Create Sequence Proj_Proj_Attache_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE TABLE Proj_Project_Attache
--( Id         Number(9) NOT NULL,                           -- PK
--  Proj_Id    Number(9) NOT NULL,                           -- Project
--  DDate      Date NOT NULL,                                -- Date
--  Name       Varchar2(100 Char),                           -- اسم المرفق
--  FileName   Varchar2(100 Char),                           -- اسم الملف المرفق
--  Rem        Varchar2(100 Char),                           -- Remarks
--  Ins_User   Number(5), Ins_Date     Date,
--  Upd_User   Number(5), Upd_Date     Date,
--  CONSTRAINT Proj_Proj_Attache_PK      PRIMARY KEY (Id),
--  CONSTRAINT Proj_Proj_Attache_Proj_FK Foreign Key (Proj_Id ) References Proj_Proj(Id),
--  CONSTRAINT Proj_Proj_Attache_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
--  CONSTRAINT Proj_Proj_Attache_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
--)
--/
--Create Synonym Proj_Proj_Attache For Proj_Project_Attache
--/
----------------------------------------------------------------------------------------------------done
Create Sequence Proj_proj_RateMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project_RatingMst
( Id         Number(9) NOT NULL,                          -- PK
  Project_Id Number(9) NOT NULL,                          -- project
  SDate      Date NOT NULL,                               -- start Date
  EDate      Date NOT NULL,                               -- end Date
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Proj_RateMst_PK          PRIMARY KEY (Id),
  CONSTRAINT Proj_Proj_RateMst_Project_FK  Foreign Key (Project_Id )References Proj_Proj      (Id),
  CONSTRAINT Proj_Proj_RateMst_Ins_FK      Foreign Key (Ins_User   )References Cpy_User       (Id),
  CONSTRAINT Proj_Proj_RateMst_Upd_FK      Foreign Key (Upd_User   )References Cpy_User       (Id)
)
/
Create Synonym Proj_Proj_RateMst For Proj_Project_RatingMst
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Proj_RateTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project_RatingTrn
( Id         Number(9) NOT NULL,                          -- PK
  Mst_Id     Number(9) NOT NULL,                          -- Mst Id
  Rate_Id    Number(1) DEFAULT 0  NOT NULL,               -- Rate  
  User_Id    Number(9) NOT NULL,                          -- user
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Proj_RateTrn_PK          PRIMARY KEY (Id),
  CONSTRAINT Proj_Proj_RateTrn_Mst_FK      Foreign Key (Mst_Id     )References Proj_Proj_RateMst (Id),
  CONSTRAINT Proj_Proj_RateTrn_Rate_FK     Foreign Key (Rate_Id    )References Proj_Cod_Rate    (Id),
  CONSTRAINT Proj_Proj_RateTrn_Ins_FK      Foreign Key (Ins_User   )References Cpy_User         (Id),
  CONSTRAINT Proj_Proj_RateTrn_Upd_FK      Foreign Key (Upd_User   )References Cpy_User         (Id)
)
/
Create Synonym Proj_Proj_RateTrn For Proj_Project_RatingTrn
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Proj_Expense_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project_Expense
( Id         Number(9) NOT NULL,                           -- PK
  Proj_Id    Number(9) NOT NULL,                           -- Project
  Cont_Id    Number(9) NOT NULL,                           -- Contact
  Serv_Id    Number(9) NOT NULL,                           -- Service
  DDate      Date NOT NULL,                                -- Date
  Qnt        Number(17,3) DEFAULT 0 NOT NULL,              -- Quantity
  Price      Number(17,2) DEFAULT 0 NOT NULL,              -- Price
  CAmt       Number(17,2) DEFAULT 0 NOT NULL,              -- Currency Amount
  Amt        Number(17,2) DEFAULT 0 NOT NULL,              -- Local Amount
  Curn_Id    Number(3) DEFAULT 1 NOT NULL,                 -- Currency
  Rate       Number(15,7) DEFAULT 1 NOT NULL,              -- Rate
  Rem        Varchar2(100 Char),                           -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Proj_Expense_PK      PRIMARY KEY (Id),
  CONSTRAINT Proj_Proj_Expense_Proj_FK Foreign Key (Proj_Id ) References Proj_Proj(Id),
  CONSTRAINT Proj_Proj_Expense_Cont_FK Foreign Key (Cont_Id ) References Mng_Cont (Id),
  CONSTRAINT Proj_Proj_Expense_Serv_FK Foreign Key (Serv_Id ) References Mng_Serv (Id),
  CONSTRAINT Proj_Proj_Expense_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn (Id),
  CONSTRAINT Proj_Proj_Expense_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Proj_Proj_Expense_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Proj_Proj_Expense For Proj_Project_Expense
/
----------------------------------------------------------------------------------------------------done
--Create Sequence Proj_ProjExp_Attache_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE TABLE Proj_Project_Expense_Attache
--( Id         Number(9) NOT NULL,                           -- PK
--  ProjExp_Id Number(9) NOT NULL,                           -- Project Expense
--  DDate      Date NOT NULL,                                -- Date
--  Name       Varchar2(100 Char),                           -- اسم المرفق
--  FileName   Varchar2(100 Char),                           -- اسم الملف المرفق
--  Rem        Varchar2(100 Char),                           -- Remarks
--  Ins_User   Number(5), Ins_Date     Date,
--  Upd_User   Number(5), Upd_Date     Date,
--  CONSTRAINT Proj_ProjExp_Attache_PK         PRIMARY KEY (Id),
--  CONSTRAINT Proj_ProjExp_Attache_ProjExp_FK Foreign Key (ProjExp_Id ) References Proj_Proj_Expense(Id),
--  CONSTRAINT Proj_ProjExp_Attache_Ins_FK     Foreign Key (Ins_User   ) References Cpy_User (Id),
--  CONSTRAINT Proj_ProjExp_Attache_Upd_FK     Foreign Key (Upd_User   ) References Cpy_User (Id)
--)
--/
--Create Synonym Proj_ProjExp_Attache For Proj_Project_Expense_Attache
--/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Proj_Note_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project_Note
( Id         Number(9) NOT NULL,                           -- PK
  Proj_Id    Number(5),                                    -- Project
  User_Id    Number(5),                                    -- User
  DDate      Date DEFAULT Sysdate NOT NULL,                -- Date
  Note       Varchar2(4000 Char),                          -- Note
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Proj_Note_PK      PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Proj_Note_Proj_FK Foreign Key (Proj_Id ) References Proj_Proj(Id),
  CONSTRAINT Proj_Proj_Note_User_FK Foreign Key (User_Id ) References Cpy_User (Id),
  CONSTRAINT Proj_Proj_Note_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Proj_Proj_Note_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Proj_Proj_Note For Proj_Project_Note
/
----------------------------------------------------------------------------------------------------done
--Create Sequence Proj_ProjNote_Attache_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE TABLE Proj_Project_Note_Attache
--( Id          Number(9) NOT NULL,                           -- PK
--  ProjNote_Id Number(9) NOT NULL,                           -- Project Expense
--  DDate       Date NOT NULL,                                -- Date
--  Name        Varchar2(100 Char),                           -- اسم المرفق
--  FileName    Varchar2(100 Char),                           -- اسم الملف المرفق
--  Rem         Varchar2(100 Char),                           -- Remarks
--  Ins_User    Number(5), Ins_Date     Date,
--  Upd_User    Number(5), Upd_Date     Date,
--  CONSTRAINT Proj_ProjNote_Attache_PK          PRIMARY KEY (Id),
--  CONSTRAINT Proj_ProjNote_Attache_ProjNote_FK Foreign Key (ProjNote_Id) References Proj_Proj_Note(Id),
--  CONSTRAINT Proj_ProjNote_Attache_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User (Id),
--  CONSTRAINT Proj_ProjNote_Attache_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User (Id)
--)
--/
--Create Synonym Proj_ProjNote_Attache For Proj_Project_Note_Attache
--/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Proj_Team_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project_Team
( Id         Number(9) NOT NULL,                           -- PK
  Proj_Id    Number(5) NOT NULL,                           -- Project
  Team_Id    Number(5) NOT NULL,                           -- Team Member
  Status_Id  Number(1) DEFAULT 1 NOT NULL,                 -- Status
  Title      Varchar2(100 Char) DEFAULT 'Member' NOT NULL, -- Member Title
  Rem        Varchar2(100 Char),                           -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Proj_Team_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Proj_Team_UK        UNIQUE      (Proj_Id, Team_Id),
  CONSTRAINT Proj_Proj_Team_Proj_FK   Foreign Key (Proj_Id  ) References Proj_Proj     (Id),
  CONSTRAINT Proj_Proj_Team_Team_FK   Foreign Key (Team_Id  ) References Proj_Team     (Id),
  CONSTRAINT Proj_Proj_Team_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Proj_Proj_Team_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Proj_Proj_Team_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Proj_Proj_Team For Proj_Project_Team
/
----------------------------------------------------------------------------------------------------done
Create Sequence Proj_ProjTeam_RateMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project_Team_RatingMst
( Id         Number(9) NOT NULL,                          -- PK
  Team_Id    Number(9) NOT NULL,                          -- Team
  SDate      Date NOT NULL,                               -- start Date
  EDate      Date NOT NULL,                               -- end Date
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_ProjTeam_RateMst_PK          PRIMARY KEY (Id),
  CONSTRAINT Proj_ProjTeam_RateMst_Task_FK     Foreign Key (Team_Id    )References Proj_Proj_Team (Id),
  CONSTRAINT Proj_ProjTeam_RateMst_Ins_FK      Foreign Key (Ins_User   )References Cpy_User       (Id),
  CONSTRAINT Proj_ProjTeam_RateMst_Upd_FK      Foreign Key (Upd_User   )References Cpy_User       (Id)
)
/
Create Synonym Proj_ProjTeam_RateMst For Proj_Project_Team_RatingMst
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_ProjTeam_RateTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project_Team_RatingTrn
( Id         Number(9) NOT NULL,                          -- PK
  Mst_Id     Number(9) NOT NULL,                          -- Mst Id
  Rate_Id    Number(1) DEFAULT 0 NOT NULL,                -- Rate  
  User_Id    Number(9) NOT NULL,                          -- user
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_ProjTeam_RateTrn_PK          PRIMARY KEY (Id),
  CONSTRAINT Proj_ProjTeam_RateTrn_Mst_FK      Foreign Key (Mst_Id     )References Proj_ProjTeam_RateMst (Id),
  CONSTRAINT Proj_ProjTeam_RateTrn_Rate_FK     Foreign Key (Rate_Id    )References Proj_Cod_Rate         (Id),
  CONSTRAINT Proj_ProjTeam_RateTrn_Ins_FK      Foreign Key (Ins_User   )References Cpy_User              (Id),
  CONSTRAINT Proj_ProjTeam_RateTrn_Upd_FK      Foreign Key (Upd_User   )References Cpy_User              (Id)
)
/
Create Synonym Proj_ProjTeam_RateTrn For Proj_Project_Team_RatingTrn
/
----------------------------------------------------------------------------------------------------
--Create Sequence Proj_Task_Team_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE TABLE Proj_Task_Team_Member
--( Id         Number(9) NOT NULL,                           -- PK
--  Task_Id    Number(9) NOT NULL,                           -- Task
--  Team_Id    Number(9) NOT NULL,                           -- Team Member
--  Status_Id  Number(2) NOT NULL,                           -- Status
--  Ins_User   Number(5), Ins_Date     Date,
--  Upd_User   Number(5), Upd_Date     Date,
--  CONSTRAINT Proj_Task_Team_PK        PRIMARY KEY (Id  ),
--  CONSTRAINT Proj_Task_Team_UK        UNIQUE      (Task_Id, Team_Id),
--  CONSTRAINT Proj_Task_Team_Task_FK   Foreign Key (Task_Id  ) References Cpy_Task      (Id),
--  CONSTRAINT Proj_Task_Team_Team_FK   Foreign Key (Team_Id  ) References Proj_Team     (Id),
--  CONSTRAINT Proj_Task_Team_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
--  CONSTRAINT Proj_Task_Team_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
--  CONSTRAINT Proj_Task_Team_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
--)
--/
--Create Synonym Proj_Task_Team For Proj_Task_Team_Member
--/
----------------------------------------------------------------------------------------------------
--Create Sequence Proj_Follow_Team_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE TABLE Proj_Followup_Team
--( Id         Number(9) NOT NULL,                           -- PK
--  Follow_Id  Number(9) NOT NULL,                           -- Follow
--  Team_Id    Number(9) NOT NULL,                           -- Team Member
--  Ins_User   Number(5), Ins_Date     Date,
--  Upd_User   Number(5), Upd_Date     Date,
--  CONSTRAINT Proj_Follow_Team_PK        PRIMARY KEY (Id),
--  CONSTRAINT Proj_Follow_Team_UK        UNIQUE      (Follow_Id, Team_Id),
--  CONSTRAINT Proj_Follow_Team_Follow_FK Foreign Key (Follow_Id) References Cpy_Task_Follow (Id),
--  CONSTRAINT Proj_Follow_Team_Team_FK   Foreign Key (Team_Id  ) References Proj_Team       (Id),
--  CONSTRAINT Proj_Follow_Team_Ins_FK    Foreign Key (Ins_User ) References Cpy_User        (Id),
--  CONSTRAINT Proj_Follow_Team_Upd_FK    Foreign Key (Upd_User ) References Cpy_User        (Id)
--)
--/
--Create Synonym Proj_Follow_Team For Proj_Followup_Team
--/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Meet_seq MinValue 0 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Meeting                                  -- طلب الاحتياج
( Id          Number(9) NOT NULL,                              -- مفتاح رئيسي
  Proj_Id     Number(9),                                       -- المشروع
  Kind_Id     Number(5) NOT NULL,                              -- جوهر الاجتماع
  SchedEmp_Id Number(9) NOT NULL,                              -- الموظف المقرر للاجتماع
  Type_Id     Number(1) NOT NULL,                              -- نوع الاجتماع
  Status_Id   Number(1) Default 2 NOT NULL,                    -- هل تم الاجتماع ام لم يتم
  ESDate      date NOT NULL ,                                  -- تاريخ البدء المتوقع
  EEDate      date NOT NULL ,                                  -- تاريخ نهاية المتوقع
  ASDate      date,                                            -- تاريخ البداية الفعلي
  AEDate      date,                                            -- تاريخ النهاية الفعلي
  Location    Varchar2(100 Char ) NOT NULL,                    -- مكان الاجتماع
  Title       Varchar2(100 Char ) NOT NULL,                    -- عنوان المشروع
  Exter_Emp   Varchar2(512 Char ),                             -- اشخاص خارجية 
  Result      Varchar2(1024 Char),                             -- نتيجة الاجتماع
  Rem         Varchar2(100 Char ),                             -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT Proj_Meet_PK          PRIMARY KEY (Id),
  CONSTRAINT Proj_Meet_Proj_FK     Foreign Key (Proj_Id    ) References Proj_Proj         (Id),
  CONSTRAINT Proj_Meet_SchedEmp_FK Foreign Key (SchedEmp_Id) References Cpy_User          (Id),
  CONSTRAINT Proj_Meet_Type_FK     Foreign Key (Type_Id    ) References Proj_Cod_MeetType (Id),
  CONSTRAINT Proj_Meet_Status_FK   Foreign Key (Status_Id  ) References Phs_Cod_YesNo     (Id),
  CONSTRAINT Proj_Meet_Kind_FK     Foreign Key (Kind_Id    ) References Proj_Cod_MeetKind (Id),
  CONSTRAINT Proj_Meet_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User          (Id),
  CONSTRAINT Proj_Meet_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User          (Id)  
)
/
Create Synonym Proj_Meet For Proj_Meeting
/
--------------------------------------------------------------------------------------------------   
Create Sequence Proj_Meet_Team_seq MinValue 0 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Meeting_Team                                  -- بنود طلب الاحتياج
( Id         Number(9) NOT NULL ,                               -- مفتاح رئيسي
  Mst_Id     Number(5) NOT NULL ,                               -- مفتاح الاب
  User_Id    Number(9) NOT NULL ,                               -- الموظفين
  App_Id     Number(1) Default 2,                               -- حضر ام لم يحضر
  Rem        Varchar2(100 Char) ,                               -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Proj_Meet_Team_PK      PRIMARY KEY (Id),
  CONSTRAINT Proj_Meet_Team_Mst_FK  Foreign Key (Mst_Id ) References Proj_Meet      (Id),
  CONSTRAINT Proj_Meet_Team_User_FK Foreign Key (User_Id ) References Cpy_User      (Id),
  CONSTRAINT Proj_Meet_Team_App_FK  Foreign Key (App_Id  ) References Phs_Cod_YesNo (Id),
  CONSTRAINT Proj_Meet_Team_Ins_FK  Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Proj_Meet_Team_Upd_FK  Foreign Key (Upd_User) References Cpy_User      (Id) 
)
/
Create Synonym Proj_Meet_Team For Proj_Meeting_Team
/
--------------------------------------------------------------------------------------------------
