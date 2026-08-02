--set Pagesize 1000
--select 'Drop table '   || table_name    || ';' from user_tables    where table_name    like 'TRN_%';
--select 'Drop Synonym ' || Synonym_name  || ';' from user_Synonyms  where Synonym_name  like 'TRN_%';
--select 'Drop Sequence '|| Sequence_name || ';' from user_Sequences where Sequence_name like 'TRN_%';
--select 'Drop View '    || View_name     || ';' from user_Views     where View_name     like 'TRN_%';
----------------------------------------------------------------------------------------------------
--Insert Into Cpy_Pref (Id, Key, Name, Value1) Values (3000, 'TRN_LIMIT'    , 'Max Weight Limit'    , 0);
--Insert Into Cpy_Pref (Id, Key, Name, Value1) Values (3010, 'TRN_LIMIT_AXE', 'Max Axe Weight Limit', 0);
-----------------------------------------------------------------------------------------------------
Create Table Trn_Code_Reservation                     -- ترميز حالة الحجز
( Id         Number(1) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1 NOT NULL,            -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Cod_Res_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Trn_Cod_Res_UK        UNIQUE      (Name),
  CONSTRAINT Trn_Cod_Res_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Trn_Cod_Res_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Trn_Cod_Res_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Trn_Cod_Res For Trn_Code_Reservation
/
Insert into Trn_Cod_Res (Id,Name) values (0,'-');
Insert into Trn_Cod_Res (Id,Name) values (1,'مخالف');
Insert into Trn_Cod_Res (Id,Name) values (2,'مخالف مع حجز');
Insert into Trn_Cod_Res (Id,Name) values (3,'مخالف مع حجز وموافقة');
-----------------------------------------------------------------------------------------------------
Create Table Trn_Code_For                             -- ترميز الرسوم لكل
( Id         Number(1) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1 NOT NULL,            -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Cod_For_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Trn_Cod_For_UK        UNIQUE      (Name),
  CONSTRAINT Trn_Cod_For_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Trn_Cod_For_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Trn_Cod_For_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Trn_Cod_For For Trn_Code_For
/
Insert into Trn_Cod_For (Id,Name) values (1,'الكل');
Insert into Trn_Cod_For (Id,Name) values (2,'كيلو');
Insert into Trn_Cod_For (Id,Name) values (3,'طن');
-----------------------------------------------------------------------------------------------------
Create Table Trn_Code_PayType                         -- ترميز نوع الدفع
( Id         Number(1) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1 NOT NULL,            -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Cod_PType_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Trn_Cod_PType_UK        UNIQUE      (Name),
  CONSTRAINT Trn_Cod_PType_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Trn_Cod_PType_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Trn_Cod_PType_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Trn_Cod_PType For Trn_Code_PayType
/
Insert into Trn_Cod_PType (Id,Name) values (1,'رسم');
Insert into Trn_Cod_PType (Id,Name) values (2,'مخالفة');
----------------------------------------------------------------------------------------------------
Create Table Trn_Code_Type                            -- ترميز أنواع القبانات
( Id         Number(1) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1 NOT NULL,            -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Cod_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Trn_Cod_Type_UK        UNIQUE      (Name),
  CONSTRAINT Trn_Cod_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Trn_Cod_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Trn_Cod_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Trn_Cod_Type For Trn_Code_Type
/
Insert into Trn_Cod_Type (Id,Name) values (1,'ثابت');
Insert into Trn_Cod_Type (Id,Name) values (2,'متحرك');
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Cod_Loc_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Code_Location                        -- ترميز المواقع
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1 NOT NULL,            -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Cod_Loc_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Trn_Cod_Loc_UK        UNIQUE      (Name),
  CONSTRAINT Trn_Cod_Loc_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Trn_Cod_Loc_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Trn_Cod_Loc_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Trn_Cod_Loc For Trn_Code_Location
/
INSERT INTO Trn_Cod_Loc (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Bln_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Trn_Balance                              -- القبان
( Id         Number(9) NOT NULL,                      -- مفتاح رئيسي
  Name       Varchar2(100) NOT NULL,                  -- الاسم
  Status_Id  Number(1) Default 1 NOT NULL,            -- الحالة
  Type_Id    Number(1) Default 1 NOT NULL,            -- النوع
  Loc_Id     Number(5) Default 0 NOT NULL,            -- الموقع
  Rem        Varchar2(1024 Char),                     -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Bln_PK         PRIMARY KEY (Id ),
  CONSTRAINT Trn_Bln_UK         UNIQUE      (Name),
  CONSTRAINT Trn_Bln_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Trn_Bln_Typ_FK     Foreign Key (Type_Id  ) References Trn_Cod_Type  (Id),
  CONSTRAINT Trn_Bln_Loc_FK     Foreign Key (Loc_Id   ) References Trn_Cod_Loc   (Id),
  CONSTRAINT Trn_Bln_Loc_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Trn_Bln_Loc_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Trn_Bln For Trn_Balance
/
INSERT INTO Trn_Bln (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Bln_User_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Balance_User                         -- تسجيل بيانات توزين
( Id          Number(9) NOT NULL,                     -- مفتاح رئيسي
  Mst_Id      Number(9) NOT NULL,                     -- مفتاح الميزان
  User_Id     Number(5) Default 0 NOT NULL,           -- مفتاح المستخدم
  Status_Id  Number(1) Default 1 NOT NULL,            -- الحالة
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5),      Ins_Date Date,
  Upd_User    Number(5),      Upd_Date Date,
  CONSTRAINT  Trn_Bln_User_PK         PRIMARY KEY (Id),
  CONSTRAINT  Trn_Bln_User_Mst_FK     Foreign Key (Mst_Id   ) References Trn_Bln       (Id),
  CONSTRAINT  Trn_Bln_User_FK         Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT  Trn_Bln_User_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  Trn_Bln_User_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Trn_Bln_User_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Trn_Bln_User For Trn_Balance_User
/
----------------------------------------------------------------------------------------------------
Create Sequence Trn_ChLoc_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Change_Location                      -- تغيير المواقع
( Id         Number(9) NOT NULL,                      -- مفتاح رئيسي
  Bln_Id     Number(9) NOT NULL,                      -- القبان
  dDate      Date NOT NULL,                           -- التاريخ
  OLoc_Id    Number(5) Default 0 NOT NULL,            -- الموقع القديم
  NLoc_Id    Number(5) Default 0 NOT NULL,            -- الموقع الجديد
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_ChLoc_PK      PRIMARY KEY (Id),
  CONSTRAINT Trn_ChLoc_Bln_FK  Foreign Key (Bln_Id  ) References Trn_Bln    (Id),
  CONSTRAINT Trn_ChLoc_OLoc_FK Foreign Key (OLoc_Id ) References Trn_Cod_Loc(Id),  
  CONSTRAINT Trn_ChLoc_NLoc_FK Foreign Key (NLoc_Id ) References Trn_Cod_Loc(Id),
  CONSTRAINT Trn_ChLoc_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT Trn_ChLoc_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Trn_ChLoc For Trn_Change_Location
/
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Cod_Model_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Code_Model                           -- موديل
( Id           Number(5) NOT NULL,                    -- مفتاح رئيسي
  Status_Id    Number(1)Default 1 NOT NULL,           -- حالة الترميز
  Name         Varchar2(100 Char) NOT NULL,           -- الاسم
  Axes         Number(2) Default 2 NOT NULL,          -- عدد المحاور
  Weight       Number(7) Default 0 NOT NULL,          -- الوزن الإجمالي المسموح
  Image        Varchar2(512 Char),                    -- الصورة
  Rem          Varchar2(100 Char), 
  Ins_User     Number(5),      Ins_Date Date,
  Upd_User     Number(5),      Upd_Date Date,
  CONSTRAINT   Trn_Cod_Model_PK        PRIMARY KEY (Id  ),
  CONSTRAINT   Trn_Cod_Model_UK        UNIQUE      (Name),
  CONSTRAINT   Trn_Cod_Model_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT   Trn_Cod_Model_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT   Trn_Cod_Model_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Trn_Cod_Model For Trn_Code_Model
/
INSERT INTO Trn_Cod_Model (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Cod_Model_Detail_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Code_Model_Details                   -- موديل
( Id           Number(5) NOT NULL,                    -- مفتاح رئيسي
  Model_Id     Number(9) NOT NULL,                    -- الموديل
  Axe          Number(2) Default 0 NOT NULL,          -- المحور
  Wheel1Weight Number(7) Default 0 NOT NULL,          -- الوزن على العجلة 1
  Wheel2Weight Number(7) Default 0 NOT NULL,          -- الوزن على العجلة 2
  Rem          Varchar2(100 Char), 
  Ins_User     Number(5),      Ins_Date Date,
  Upd_User     Number(5),      Upd_Date Date,
  CONSTRAINT   Trn_Cod_Model_Detail_PK        PRIMARY KEY (Id  ),
  CONSTRAINT   Trn_Cod_Model_Detail_Status_FK Foreign Key (Model_Id ) References Trn_Cod_Model (Id),
  CONSTRAINT   Trn_Cod_Model_Detail_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT   Trn_Cod_Model_Detail_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Trn_Cod_Model_Detail For Trn_Code_Model_Details
/
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Fee_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Fees                                 -- دليل الرسوم
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(5)Default 1 NOT NULL,             -- الحالة
  Type_Id    Number(5) Default 1,                     -- 
  For_Id     Number(1) Default 1,                     -- 
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Amt        Number(25,2) Default 0 NOT NULL,         -- القيمة
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Fee_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Trn_Fee_Name_UK   UNIQUE      (Name),
  CONSTRAINT Trn_Fee_Typ_FK    Foreign Key (Type_Id  ) References Phs_Cod_Amttype(Id),
  CONSTRAINT Trn_Fee_Fr_FK     Foreign Key (For_Id   ) References Trn_Cod_For    (Id),
  CONSTRAINT Trn_Fee_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Trn_Fee_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Trn_Fee_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Trn_Fee For Trn_Fees
/
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Penalty_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Penalties                            -- دليل المخالفات
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(5)Default 1 NOT NULL,             -- الحالة
  Type_Id    Number(5) Default 1,                     -- 
  For_Id     Number(1) Default 1,                     -- 
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Amt        Number(25,2) Default 0 NOT NULL,         -- القيمة
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Penalty_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Trn_Penalty_Name_UK   UNIQUE      (Name),
  CONSTRAINT Trn_Penalty_Typ_FK    Foreign Key (Type_Id  ) References Phs_Cod_Amttype(Id),
  CONSTRAINT Trn_Penalty_Fr_FK     Foreign Key (For_Id   ) References Trn_Cod_For    (Id),
  CONSTRAINT Trn_Penalty_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Trn_Penalty_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Trn_Penalty_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Trn_Penalty For Trn_Penalties
/
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Bln_Mst_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Balance_Master                       -- تسجيل بيانات توزين
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Bln_Id     Number(9) NOT NULL,                      -- القبان
  Num        Number(9) NOT NULL,                      -- الرقم
  Model_Id   Number(9) NOT NULL,                      -- الموديل
  Res_Id     Number(1) Default 0,                     -- حالة الحجز
  Fee        Number(25,2) Default 0,                  -- قيمة رسم التوزين
  WPenalty   Number(25,2) Default 0,                  -- قيمة مخالفة الوزن الزائد
  APenalty   Number(25,2) Default 0,                  -- قيمة مخالفة الزوائد
  Net        Number(7) Default 0,                     -- الوزن الصافي
  Weight     Number(7) Default 0,                     -- الوزن الكلي
  OverWeight Number(7) Default 0,                     -- الوزن الزائد
  bDate      Date Default Sysdate NOT NULL,           -- تاريخ التوزين
  PNum       Varchar2(30 Char) NOT NULL,              -- رقم اللوحة
  RNum       Varchar2(30 Char),                       -- رقم الحجز
  Doc_Num    Varchar2(30 Char),                       -- رقم المستند
  Doc_Date   Varchar2(30 Char),                       -- تاريخ المستند
  Receipt    Varchar2(30 Char),                       -- رقم الإيصال
  Driver     Varchar2(100 Char),                      -- السائق
  Src        Varchar2(20 Char),                       -- المصدر
  Dest       Varchar2(20 Char),                       -- المقصد
  Commodity  Varchar2(100 Char),                      -- نوع البضاعة
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Bln_Mst_PK        PRIMARY KEY (Id ),
  CONSTRAINT Trn_Bln_Mst_Num_UK    UNIQUE      (Num),
  CONSTRAINT Trn_Bln_Mst_Bln_FK    Foreign Key (Bln_Id  ) References Trn_Bln      (Id),
  CONSTRAINT Trn_Bln_Mst_Model_FK  Foreign Key (Model_Id) References Trn_Cod_Model(Id),
  CONSTRAINT Trn_Bln_Mst_Rec_FK    Foreign Key (Res_Id  ) References Trn_Cod_Res  (Id),
  CONSTRAINT Trn_Bln_Mst_Ins_FK    Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Trn_Bln_Mst_Upd_FK    Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Trn_Bln_Mst For Trn_Balance_Master
/
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Bln_Trn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Balance_Transaction                  -- تسجيل بيانات توزين
( Id          Number(20) NOT NULL,                    -- مفتاح رئيسي
  Mst_Id      Number(20) NOT NULL,                    -- مفتاح الأب
  Axe         Number(2) Default 0,                    -- المحور
  Weight      Number(7) Default 0,                    -- الوزن الكلي
  Weight1     Number(7) Default 0,                    -- الوزن على العجلة 1
  Weight2     Number(7) Default 0,                    -- الوزن على العجلة 2
  OverWeight  Number(7) Default 0,                    -- الوزن الزائد
  OverWeight1 Number(7) Default 0,                    -- الوزن الزائد العجلة 1
  OverWeight2 Number(7) Default 0,                    -- الوزن الزائد العجلة 2
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5),      Ins_Date Date,
  Upd_User    Number(5),      Upd_Date Date,
  CONSTRAINT  Trn_Bln_Trn_PK     PRIMARY KEY (Id),
  CONSTRAINT  Trn_Bln_Trn_Mst_FK Foreign Key (Mst_Id  ) References Trn_Bln_Mst(Id),
  CONSTRAINT  Trn_Bln_Trn_Ins_FK Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT  Trn_Bln_Trn_Upd_FK Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Trn_Bln_Trn For Trn_Balance_Transaction
/
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Bln_Fee_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Balance_Fees                         -- تسجيل رسوم توزين
( Id          Number(9) NOT NULL,                     -- مفتاح رئيسي
  Mst_Id      Number(9) NOT NULL,                     -- مفتاح الأب
  Fee_Id      Number(9) NOT NULL,                     -- مفتاح الأب
  Amt         Number(25,2) Default 0 NOT NULL,        -- القيمة
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5),      Ins_Date Date,
  Upd_User    Number(5),      Upd_Date Date,
  CONSTRAINT  Trn_Bln_Fee_PK     PRIMARY KEY (Id),
  CONSTRAINT  Trn_Bln_Fee_Mst_FK Foreign Key (Mst_Id  ) References Trn_Bln_Mst(Id),
  CONSTRAINT  Trn_Bln_Fee_Fee_FK Foreign Key (Fee_Id  ) References Trn_Fee    (Id),
  CONSTRAINT  Trn_Bln_Fee_Ins_FK Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT  Trn_Bln_Fee_Upd_FK Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Trn_Bln_Fee For Trn_Balance_Fees
/
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Bln_Penalty_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Balance_Penalties                    -- تسجيل رسوم توزين
( Id         Number(9) NOT NULL,                      -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Fee_Id     Number(9),                               -- مفتاح الأب
  Penalty_Id Number(9),                               -- مفتاح الأب
  PType_Id   Number(1) Default 1,                     -- 
  For_Id     Number(1) Default 1,                     -- 
  Amt        Number(25,2) Default 0 NOT NULL,         -- القيمة
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Bln_Penalty_PK         PRIMARY KEY (Id),
  CONSTRAINT Trn_Bln_Penalty_Mst_FK     Foreign Key (Mst_Id    ) References Trn_Bln_Mst  (Id),
  CONSTRAINT Trn_Bln_Penalty_Fee_FK     Foreign Key (Fee_Id    ) References Trn_Fee      (Id),
  CONSTRAINT Trn_Bln_Penalty_Penalty_FK Foreign Key (Penalty_Id) References Trn_Penalty  (Id),
  CONSTRAINT Trn_Bln_Penalty_PType_FK   Foreign Key (PType_Id  ) References Trn_Cod_PType(Id),
  CONSTRAINT Trn_Bln_Penalty_For_FK     Foreign Key (For_Id    ) References Trn_Cod_For  (Id),
  CONSTRAINT Trn_Bln_Penalty_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User     (Id),
  CONSTRAINT Trn_Bln_Penalty_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User     (Id)
)
/
Create Synonym Trn_Bln_Penalty For Trn_Balance_Penalties
/
----------------------------------------------------------------------------------------------------
Create Sequence Trn_Leak_car_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Trn_Leaky_cars                           -- السيارات المتسربة
( Id         Number(9) NOT NULL,                      -- مفتاح رئيسي
  Bln_Id     Number(9) NOT NULL,                      -- القبان
  PNum       Varchar2(15 Char) NOT NULL,              -- رقم اللوحة
  dDate      Date Default Sysdate NOT NULL,           -- تاريخ التوزين
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Trn_Leak_car_PK     PRIMARY KEY (Id),
  CONSTRAINT Trn_Leak_car_Bln_FK Foreign Key (Bln_Id  ) References Trn_Bln (Id),
  CONSTRAINT Trn_Leak_car_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Trn_Leak_car_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Trn_Leak_car For Trn_Leaky_cars
/
----------------------------------------------------------------------------------------------------
