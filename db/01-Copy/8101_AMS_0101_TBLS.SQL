--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'AMS%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'AMS%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'AMS%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'AMS%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'AMS%' ;
----------------------------------------------------------------------------------------------------
Create Table AMS_Code_Years                                -- جدول ترميز
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Cod_Year_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Cod_Year_UK     UNIQUE      (Name),
  CONSTRAINT AMS_Cod_Year_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AMS_Cod_Year_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym AMS_Cod_Year For AMS_Code_Years
/
INSERT INTO AMS_Cod_Year (Id, Name) VALUES (0, '-');
INSERT INTO AMS_Cod_Year (Id, Name) VALUES (1, 'Year 1');
INSERT INTO AMS_Cod_Year (Id, Name) VALUES (2, 'Year 2');
INSERT INTO AMS_Cod_Year (Id, Name) VALUES (3, 'Year 3');
INSERT INTO AMS_Cod_Year (Id, Name) VALUES (4, 'Year 4');
INSERT INTO AMS_Cod_Year (Id, Name) VALUES (5, 'Year 5');
----------------------------------------------------------------------------------------------------
Create Table AMS_Code_Terms                                -- جدول ترميز
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Cod_Term_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Cod_Term_UK     UNIQUE      (Name),
  CONSTRAINT AMS_Cod_Term_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AMS_Cod_Term_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym AMS_Cod_Term For AMS_Code_Terms
/
INSERT INTO AMS_Cod_Term (Id, Name) VALUES (0, '-');
INSERT INTO AMS_Cod_Term (Id, Name) VALUES (1, 'Term 1');
INSERT INTO AMS_Cod_Term (Id, Name) VALUES (2, 'Term 2');
INSERT INTO AMS_Cod_Term (Id, Name) VALUES (3, 'Term 3');
----------------------------------------------------------------------------------------------------
Create Table AMS_Code_Price_Types                          -- جدول ترميز
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Cod_Price_Type_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Cod_Price_Type_UK     UNIQUE      (Name),
  CONSTRAINT AMS_Cod_Price_Type_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AMS_Cod_Price_Type_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym AMS_Cod_Price_Type For AMS_Code_Price_Types
/
INSERT INTO AMS_Cod_Price_Type (Id, Name) VALUES (0, '-');
INSERT INTO AMS_Cod_Price_Type (Id, Name) VALUES (1, 'One Time');
INSERT INTO AMS_Cod_Price_Type (Id, Name) VALUES (2, 'Per Term');
INSERT INTO AMS_Cod_Price_Type (Id, Name) VALUES (3, 'Per Item');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Cod_Fee_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Code_Fees                                 -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Cod_Fee_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Cod_Fee_UK     UNIQUE      (Name),
  CONSTRAINT AMS_Cod_Fee_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AMS_Cod_Fee_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym AMS_Cod_Fee For AMS_Code_Fees
/
INSERT INTO AMS_Cod_Fee (Id, Name) VALUES (0, '-');
INSERT INTO AMS_Cod_Fee (Id, Name) VALUES (1, 'رسم تسجيل');
INSERT INTO AMS_Cod_Fee (Id, Name) VALUES (2, 'رسم مادة');
INSERT INTO AMS_Cod_Fee (Id, Name) VALUES (3, 'رسم امتحان');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Cod_Disc_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Code_Discounts                            -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Cod_Disc_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Cod_Disc_UK     UNIQUE      (Name),
  CONSTRAINT AMS_Cod_Disc_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AMS_Cod_Disc_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym AMS_Cod_Disc For AMS_Code_Discounts
/
INSERT INTO AMS_Cod_Disc (Id, Name) VALUES (0, '-');
INSERT INTO AMS_Cod_Disc (Id, Name) VALUES (1, 'رسم تسجيل');
INSERT INTO AMS_Cod_Disc (Id, Name) VALUES (2, 'رسم مادة');
INSERT INTO AMS_Cod_Disc (Id, Name) VALUES (3, 'رسم امتحان');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Cod_Cert_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Code_Certificate                          -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Cod_Cert_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Cod_Cert_UK     UNIQUE      (Name),
  CONSTRAINT AMS_Cod_Cert_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AMS_Cod_Cert_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym AMS_Cod_Cert For AMS_Code_Certificate
/
INSERT INTO AMS_Cod_Cert (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Cod_Country_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Code_Countries                            -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Cod_Country_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Cod_Country_UK     UNIQUE      (Name),
  CONSTRAINT AMS_Cod_Country_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AMS_Cod_Country_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym AMS_Cod_Country For AMS_Code_Countries
/
INSERT INTO AMS_Cod_Country (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Cod_City_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Code_Cities                               -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Cod_City_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Cod_City_UK     UNIQUE      (Name),
  CONSTRAINT AMS_Cod_City_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AMS_Cod_City_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym AMS_Cod_City For AMS_Code_Cities
/
INSERT INTO AMS_Cod_City (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Cod_Stud_Kind_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Cod_Student_Kinds                         -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Cod_Stud_Kind_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Cod_Stud_Kind_UK     UNIQUE      (Name),
  CONSTRAINT AMS_Cod_Stud_Kind_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AMS_Cod_Stud_Kind_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym AMS_Cod_Stud_Kind For AMS_Cod_Student_Kinds
/
INSERT INTO AMS_Cod_Stud_Kind (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE AMS_Cod_Nat_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table AMS_Cod_Nationality                           -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT AMS_Cod_Nat_PK     PRIMARY KEY (Id  ),
  CONSTRAINT AMS_Cod_Nat_UK     UNIQUE      (Name),
  CONSTRAINT AMS_Cod_Nat_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT AMS_Cod_Nat_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym AMS_Cod_Nat For AMS_Cod_Nationality
/
INSERT INTO AMS_Cod_Nat (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------

AMS_Code_Adm_Order_Type
AMS_Code_Astatus
AMS_Code_Degree_Type
AMS_Code_Grad_Level
AMS_Code_Item_Force
AMS_Code_Item_Kind
AMS_Code_Sitem_Status
AMS_Code_Student_Classification
