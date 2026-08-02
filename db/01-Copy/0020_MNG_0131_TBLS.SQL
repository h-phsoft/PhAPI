Create Sequence Mng_Regn_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Regions                                   -- المناطق
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  P_Id       Number(5) NOT NULL,                           -- مفتاح الأب
  Name       Varchar2(100 char) NOT NULL,                  -- الاسم
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Mng_Regn_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Regn_Nam_UK UNIQUE      (Name),
  CONSTRAINT Mng_Regn_Ins_FK Foreign Key (Ins_User  ) References Cpy_User(Id),
  CONSTRAINT Mng_Regn_Upd_FK Foreign Key (Upd_User  ) References Cpy_User(Id)
)
/
Create Synonym Mng_Regn For Mng_Regions
/
INSERT INTO Mng_Regn (Id, P_Id, Name) VALUES (0, 0, '-');
Alter Table Mng_Regions Add CONSTRAINT Mng_Regn_Regn_FK Foreign Key (P_Id) References Mng_Regn(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cntry_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Countries                                 -- البلدان
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Num        Number(3) Default 1 NOT NULL,                 -- الرقم
  Name       Varchar2(100 char) NOT NULL,                  -- الاسم
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Mng_Cntry_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cntry_Num_UK UNIQUE      (Num ),
  CONSTRAINT Mng_Cntry_Nam_UK UNIQUE      (Name),
  CONSTRAINT Mng_Cntry_Ins_FK Foreign Key (Ins_User  ) References Cpy_User(Id),
  CONSTRAINT Mng_Cntry_Upd_FK Foreign Key (Upd_User  ) References Cpy_User(Id)
)
/
Create Synonym Mng_Cntry For Mng_Countries
/
INSERT INTO Mng_Cntry (Id, Num, Name) VALUES (0, 0, '-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_State_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_States                                    -- المحافظات\الولايات
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Cntry_Id   Number(5) NOT NULL,                           -- مفتاح الأب
  Name       Varchar2(100 char) NOT NULL,                  -- الاسم
  Num        Number(5) Default 1 NOT NULL,                 -- الرقم
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Mng_State_PK     PRIMARY KEY (Id),
  CONSTRAINT Mng_State_Num_UK UNIQUE      (Cntry_Id, Num ),
  CONSTRAINT Mng_State_Nam_UK UNIQUE      (Cntry_Id, Name),
  CONSTRAINT Mng_State_FK     Foreign Key (Cntry_Id) References Mng_Cntry(Id),
  CONSTRAINT Mng_State_Ins_FK Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Mng_State_Upd_FK Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Mng_State For Mng_States
/
INSERT INTO Mng_State (Id, Cntry_Id, Num, Name) VALUES (0, 0, 0, '-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_City_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Cities                                    -- المدن
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  State_Id   Number(5) NOT NULL,                           -- مفتاح الأب
  Num        Number(5) Default 1 NOT NULL,                 -- الرقم
  Name       Varchar2(100 char) NOT NULL,                  -- الاسم
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Mng_City_PK     PRIMARY KEY (Id),
  CONSTRAINT Mng_City_Num_UK UNIQUE      (State_Id, Num ),
  CONSTRAINT Mng_City_Nam_UK UNIQUE      (State_Id, Name),
  CONSTRAINT Mng_City_FK     Foreign Key (State_Id) References Mng_State(Id),
  CONSTRAINT Mng_City_Ins_FK Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Mng_City_Upd_FK Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Mng_City For Mng_Cities
/
INSERT INTO Mng_City (Id, State_Id, Num, Name) VALUES (0, 0, 0, '-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Street_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Streets                                   -- الأحياء\الشوارع
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  City_Id    Number(5) NOT NULL,                           -- مفتاح الأب
  Num        Number(10) Default 1 NOT NULL,                -- الرقم
  Name       Varchar2(100 char) NOT NULL,                  -- الاسم
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Mng_Street_PK     PRIMARY KEY (Id),
  CONSTRAINT Mng_Street_Num_UK UNIQUE      (City_Id, Num ),
  CONSTRAINT Mng_Street_Nam_UK UNIQUE      (City_Id, Name),
  CONSTRAINT Mng_Street_FK     Foreign Key (City_Id ) References Mng_City(Id),
  CONSTRAINT Mng_Street_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Mng_Street_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Mng_Street For Mng_Streets
/
INSERT INTO Mng_Street (Id, City_Id, Num, Name) VALUES (0, 0, 0, '-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Serv_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Services                                  -- الخدمات
( Id         Number(9),                                    -- مفتاح رئيسي
  Code       Varchar2(10 Char),                            -- الرمز
  Name       Varchar2(100 Char),                           -- الاسم
  Cost_Id    Number(9),                                    -- مركز الكلفة
  Acc_Id     Number(9),                                    -- حساب الكلفة
  Acc_RId    Number(9),                                    -- حساب الإيراد
  Cst        Number(25,2) Default 0,                       -- الكلفة
  Grp        Varchar2(100 Char),                           -- المجموعة للطباعة
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Mng_Serv_PK      Primary Key (Id  ),
  CONSTRAINT Mng_Serv_Cod_UK  Unique      (Code),
  CONSTRAINT Mng_Serv_Nam_UK  Unique      (Name),
  CONSTRAINT Mng_Serv_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Mng_Serv_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Mng_Serv For Mng_Services
/
--Alter Table Mng_Services Add CONSTRAINT Mng_Serv_Cost_FK Foreign Key (Cost_Id ) References Acc_Cost(Id);
--Alter Table Mng_Services Add CONSTRAINT Mng_Serv_Acc_FK  Foreign Key (Acc_Id  ) References Acc_Acc (Id);
--Alter Table Mng_Services Add CONSTRAINT Mng_Serv_RAcc_FK Foreign Key (Acc_RId ) References Acc_Acc (Id);
