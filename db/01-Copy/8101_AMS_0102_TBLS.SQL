--set Pagesize 1000
--select 'Drop Table '   || table_name    || ';' from user_tables    where Table_name    like 'AMS%' ;
--select 'Drop Synonym ' || Synonym_name  || ';' from user_Synonyms  where Synonym_name  like 'AMS%' ;
--select 'Drop Sequence '|| Sequence_name || ';' from user_Sequences where Sequence_name like 'AMS%' ;
--select 'Drop View '    || View_name     || ';' from user_Views     where View_name     like 'AMS%' ;
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Bran_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Branch                           -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- الحالة
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Bran_PK        PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Bran_UK        UNIQUE      (Name),
  CONSTRAINT AMS_Bran_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT AMS_Bran_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT AMS_Bran_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym AMS_Bran For AMS_Branch
/
INSERT INTO AMS_Bran (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Coleg_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_College                                    -- جدول 
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- الحالة
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Name_en    Varchar2(100 Char),        				           -- الاسم
  Study_Year Number(2) Default 1,                          -- Study Years
  Ext_Year   Number(2) Default 1,                          -- Extension Years
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Coleg_PK        PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Coleg_UK        UNIQUE      (Name),
  CONSTRAINT AMS_Coleg_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT AMS_Coleg_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT AMS_Coleg_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym AMS_Coleg For AMS_College
/
INSERT INTO AMS_Coleg (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Sec_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Section                                   -- جدول 
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Coleg_Id   Number(5) Default 0,                          -- الحالة
  Status_Id  Number(1) Default 1,                          -- الحالة
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Name_en    Varchar2(100 Char),        				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Sec_PK        PRIMARY KEY (Id),
  CONSTRAINT AMS_Sec_UK        UNIQUE      (Coleg_Id, Name),
  CONSTRAINT AMS_Sec_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT AMS_Sec_Coleg_FK  Foreign Key (Coleg_Id ) References AMS_Coleg     (Id),
  CONSTRAINT AMS_Sec_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT AMS_Sec_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym AMS_Sec For AMS_Section
/
INSERT INTO AMS_Sec (Id, Coleg_Id, Name) VALUES (0, 0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Spec_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Speciality                                -- جدول 
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Sec_Id     Number(5) Default 0,                          -- الحالة
  Status_Id  Number(1) Default 1,                          -- الحالة
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Name_en    Varchar2(100 Char),        				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Spec_PK        PRIMARY KEY (Id),
  CONSTRAINT AMS_Spec_UK        UNIQUE      (Sec_Id, Name),
  CONSTRAINT AMS_Spec_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT AMS_Spec_Coleg_FK  Foreign Key (Coleg_Id ) References AMS_Coleg     (Id),
  CONSTRAINT AMS_Spec_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT AMS_Spec_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym AMS_Spec For AMS_Speciality
/
INSERT INTO AMS_Spec (Id, Sec_Id, Name) VALUES (0, 0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_AcYear_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Academic_Year                                -- جدول 
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- الحالة
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_AcYear_PK        PRIMARY KEY (Id  ),
  CONSTRAINT AMS_AcYear_UK        UNIQUE      (Name),
  CONSTRAINT AMS_AcYear_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT AMS_AcYear_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT AMS_AcYear_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym AMS_AcYear For AMS_Academic_Year
/
INSERT INTO AMS_AcYear (Id, Sec_Id, Name) VALUES (0, 0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_AcTerm_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Academic_Term                             -- جدول 
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  AcYear_Id  Number(5) Default 0,                          -- الحالة
  Term_Id    Number(1) Default 0,                          -- Term/الفصل
  Status_Id  Number(1) Default 1,                          -- الحالة
  SDate      Date NOT NULL,                                -- Start Date
  EDate      Date NOT NULL,                                -- End Date
  RDate      Date,                                         -- Register Date
  DDate      Date,                                         -- Drop Date
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_AcTerm_PK        PRIMARY KEY (Id  ),
  CONSTRAINT AMS_AcTerm_UK        UNIQUE      (AcYear_Id, Term_Id),
  CONSTRAINT AMS_AcTerm_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT AMS_AcTerm_Term_FK   Foreign Key (Term_Id  ) References AMS_Cod_Term  (Id),
  CONSTRAINT AMS_AcTerm_AcYear_FK Foreign Key (AcYear_Id) References AMS_AcYear    (Id),
  CONSTRAINT AMS_AcTerm_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT AMS_AcTerm_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym AMS_AcTerm For AMS_Academic_Term
/
INSERT INTO AMS_AcTerm (Id, AcYear_Id, SDate, EDate) VALUES (0, 0, To_Date('01-01-2000','DD-MM-YYYY'), To_Date('31-12-2999','DD-MM-YYYY'));
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Item_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Academic_Item                             -- جدول 
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- الحالة
  Code       Varchar2(25 Char) NOT NULL,				           -- الرمز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Name_en    Varchar2(100 Char),        				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Item_PK        PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Item_Code_UK   UNIQUE      (Code),
  CONSTRAINT AMS_Item_NAme_UK   UNIQUE      (Name),
  CONSTRAINT AMS_Item_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT AMS_Item_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT AMS_Item_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym AMS_Item For AMS_Academic_Item
/
INSERT INTO AMS_Item (Id, Code, Name) VALUES (0, '0', '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Price_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Prices                                    -- جدول 
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- الحالة
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Price_PK        PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Price_Name_UK   UNIQUE      (Name),
  CONSTRAINT AMS_Price_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT AMS_Price_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT AMS_Price_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym AMS_Price For AMS_Prices
/
INSERT INTO AMS_Price (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Price_Fee_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Price_Fees                                -- جدول 
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Mst_Id     Number(5) Default 1,                          -- الأب
  Status_Id  Number(1) Default 1,                          -- الحالة
  Bran_Id    Number(5) Default 0,                          -- Branch
  Coleg_Id   Number(5) Default 0,                          -- College
  Sec_Id     Number(5) Default 0,                          -- Section
  Spec_Id    Number(5) Default 0,                          -- Speciality
  Type_Id    Number(1) Default 0,                          -- Type 1 one Time, 2 Per Term, 3 Per Item
  Fee_Id     Number(5) Default 0,                          -- Fee
  Curn1_Id   Number(3) Default 1,                          -- Syrian Currency
  Curn2_Id   Number(3) Default 1,                          -- Syrian Out Currency
  Curn3_Id   Number(3) Default 1,                          -- Others Currency
  Value1     Number(17,3) Default 0,                       -- Syrian Value
  Value2     Number(17,3) Default 0,                       -- Syrian Out Value
  Value3     Number(17,3) Default 0,                       -- Others Value
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Price_Fee_PK        PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Price_Fee_UK        UNIQUE      (Mst_Id, Bran_Id, Coleg_Id, Sec_Id, Spec_Id, Type_Id, Fee_Id),
  CONSTRAINT AMS_Price_Fee_Price_FK  Foreign Key (Mst_Id   ) References AMS_Price         (Id),
  CONSTRAINT AMS_Price_Fee_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status    (Id),
  CONSTRAINT AMS_Price_Fee_Bran_FK   Foreign Key (Bran_Id  ) References AMS_Bran          (Id),
  CONSTRAINT AMS_Price_Fee_Coleg_FK  Foreign Key (Coleg_Id ) References AMS_Coleg         (Id),
  CONSTRAINT AMS_Price_Fee_Sec_FK    Foreign Key (Sec_Id   ) References AMS_Sec           (Id),
  CONSTRAINT AMS_Price_Fee_Spec_FK   Foreign Key (Spec_Id  ) References AMS_SPec          (Id),
  CONSTRAINT AMS_Price_Fee_Type_FK   Foreign Key (Type_Id  ) References AMS_Cod_Price_Type(Id),
  CONSTRAINT AMS_Price_Fee_Fee_FK    Foreign Key (Fee_Id   ) References AMS_Cod_Fee       (Id),
  CONSTRAINT AMS_Price_Fee_Curn1_FK  Foreign Key (Curn1_Id ) References Mng_Curn          (Id),
  CONSTRAINT AMS_Price_Fee_Curn2_FK  Foreign Key (Curn2_Id ) References Mng_Curn          (Id),
  CONSTRAINT AMS_Price_Fee_Curn3_FK  Foreign Key (Curn3_Id ) References Mng_Curn          (Id),
  CONSTRAINT AMS_Price_Fee_Ins_FK    Foreign Key (Ins_User ) References Cpy_User          (Id),
  CONSTRAINT AMS_Price_Fee_Upd_FK    Foreign Key (Upd_User ) References Cpy_User          (Id)
)
/
Create Synonym AMS_Price_Fee For AMS_Price_Fees
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Disc_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Discounts                                 -- جدول 
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- الحالة
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Disc_PK        PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Disc_Name_UK   UNIQUE      (Name),
  CONSTRAINT AMS_Disc_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT AMS_Disc_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT AMS_Disc_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym AMS_Disc For AMS_Discounts
/
INSERT INTO AMS_Disc (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Disc_Fee_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Discount_Details                          -- جدول 
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Mst_Id     Number(5) Default 1,                          -- الأب
  Status_Id  Number(1) Default 1,                          -- الحالة
  Type_Id    Number(1) Default 0,                          -- Type 1 one Time, 2 Per Term, 3 Per Item
  Disc_Id    Number(5) Default 0,                          -- Fee
  AmtType_Id Number(1) Default 1,                          -- Amount Type
  Curn1_Id   Number(3) Default 1,                          -- Syrian Currency
  Curn2_Id   Number(3) Default 1,                          -- Syrian Out Currency
  Curn3_Id   Number(3) Default 1,                          -- Others Currency
  Value1     Number(17,3) Default 0,                       -- Syrian Value
  Value2     Number(17,3) Default 0,                       -- Syrian Out Value
  Value3     Number(17,3) Default 0,                       -- Others Value
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Disc_Detail_PK         PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Disc_Detail_UK         UNIQUE      (Mst_Id, Type_Id, Disc_Id),
  CONSTRAINT AMS_Disc_Detail_Disc_FK    Foreign Key (Mst_Id    ) References AMS_Disc          (Id),
  CONSTRAINT AMS_Disc_Detail_Status_FK  Foreign Key (Status_Id ) References Phs_Cod_Status    (Id),
  CONSTRAINT AMS_Disc_Detail_Type_FK    Foreign Key (Type_Id   ) References AMS_Cod_Price_Type(Id),
  CONSTRAINT AMS_Disc_Detail_Disc_FK    Foreign Key (Disc_Id   ) References AMS_Cod_Disc      (Id),
  CONSTRAINT AMS_Disc_Detail_AmtType_FK Foreign Key (AmtType_Id) References Phs_Cod_AmtType   (Id),
  CONSTRAINT AMS_Disc_Detail_Curn1_FK   Foreign Key (Curn1_Id  ) References Mng_Curn          (Id),
  CONSTRAINT AMS_Disc_Detail_Curn2_FK   Foreign Key (Curn2_Id  ) References Mng_Curn          (Id),
  CONSTRAINT AMS_Disc_Detail_Curn3_FK   Foreign Key (Curn3_Id  ) References Mng_Curn          (Id),
  CONSTRAINT AMS_Disc_Detail_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User          (Id),
  CONSTRAINT AMS_Disc_Detail_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User          (Id)
)
/
Create Synonym AMS_Disc_Detail For AMS_Price_Fees
/
----------------------------------------------------------------------------------------------------
