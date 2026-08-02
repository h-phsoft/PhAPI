--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'DSTR%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'DSTR%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'DSTR%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'DSTR%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'DSTR%' ;
----------------------------------------------------------------------------------------------------
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (0   , 2, 0 , '2008', To_Date('2008-01-01', 'YYYY-MM-DD'), To_Date('2008-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (1   , 2, 1 , '2009', To_Date('2009-01-01', 'YYYY-MM-DD'), To_Date('2009-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (2   , 2, 2 , '2010', To_Date('2010-01-01', 'YYYY-MM-DD'), To_Date('2010-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (3   , 2, 3 , '2011', To_Date('2011-01-01', 'YYYY-MM-DD'), To_Date('2011-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (4   , 2, 4 , '2012', To_Date('2012-01-01', 'YYYY-MM-DD'), To_Date('2012-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (5   , 2, 5 , '2013', To_Date('2013-01-01', 'YYYY-MM-DD'), To_Date('2013-12-31', 'YYYY-MM-DD'), 'عام النكبة للمستودعات 24-7-2013');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (6   , 2, 6 , '2014', To_Date('2014-01-01', 'YYYY-MM-DD'), To_Date('2014-12-31', 'YYYY-MM-DD'), 'احداث مستودعات جديدة 21-27');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (7   , 2, 7 , '2015', To_Date('2015-01-01', 'YYYY-MM-DD'), To_Date('2015-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (8   , 2, 8 , '2016', To_Date('2016-01-01', 'YYYY-MM-DD'), To_Date('2016-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (9   , 2, 9 , '2017', To_Date('2017-01-01', 'YYYY-MM-DD'), To_Date('2017-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (81  , 2, 10, '2018', To_Date('2018-01-01', 'YYYY-MM-DD'), To_Date('2018-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (101 , 2, 11, '2019', To_Date('2019-01-01', 'YYYY-MM-DD'), To_Date('2019-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (121 , 2, 12, '2020', To_Date('2020-01-01', 'YYYY-MM-DD'), To_Date('2020-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (141 , 2, 13, '2021', To_Date('2021-01-01', 'YYYY-MM-DD'), To_Date('2021-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (161 , 1, 14, '2022', To_Date('2022-01-01', 'YYYY-MM-DD'), To_Date('2022-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (2023, 1, 15, '2023', To_Date('2023-01-01', 'YYYY-MM-DD'), To_Date('2023-12-31', 'YYYY-MM-DD'), '');
INSERT INTO Cpy_Period (Id, Status_Id, Num, Name, SDate, EDate, Rem) VALUES (2024, 1, 16, '2024', To_Date('2024-01-01', 'YYYY-MM-DD'), To_Date('2024-12-31', 'YYYY-MM-DD'), '');
----------------------------------------------------------------------------------------------------
Create Table DStr_Code_Transaction_Type                    -- جدول ترميز
( Id         Number(3) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Trt_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Trt_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Trt_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Trt_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Trt For DStr_Code_Transaction_Type
/
INSERT INTO DStr_Cod_Trt (Id, Name, Rem) VALUES (100, 'ادخال', '1');
INSERT INTO DStr_Cod_Trt (Id, Name, Rem) VALUES (200, 'اخراج', '2');
----------------------------------------------------------------------------------------------------
Create Table DStr_Code_Document                            -- جدول ترميز
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Doc_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Doc_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Doc_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Doc_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Doc For DStr_Code_Document
/
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (-1, 'افتتاحي', '-1');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (1 , '1-إدخال', '1');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (2 , '2-مصاريف طلبيات', '2');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (3 , '3-إعادة - مردود إخراج', '3');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (4 , '4-4إخراج حسابات الصيانة', '4');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (5 , '5-5إخراج حسابات جارية', '5');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (6 , '6-6إخراج أشغال قيد التنفيذ', '6');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (7 , '7-إدخال أشغال المصنع', '7');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (8 , '8-8تسويات جردية', '8');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (24, '4-إخراج حسابات الصيانة', '4');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (25, '5-إخراج حسابات جارية', '5');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (26, '6-إخراج أشغال قيد التنفيذ', '6');
INSERT INTO DStr_Cod_Doc (Id,Name,Rem) VALUES (28, '8-تسويات جردية', '8');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE DStr_Cod_Doc_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Code_Units                               -- جدول ترميز الواحدات
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Unit_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Unit_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Unit_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Unit_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Unit For DStr_Code_Units
/
INSERT INTO DStr_Cod_Unit (Id, Name, Rem) VALUES (1, 'عدد', 'عدد');
INSERT INTO DStr_Cod_Unit (Id, Name, Rem) VALUES (2, 'كغ', 'كغ');
INSERT INTO DStr_Cod_Unit (Id, Name, Rem) VALUES (3, 'متر', 'م');
INSERT INTO DStr_Cod_Unit (Id, Name, Rem) VALUES (4, 'لتر', 'ل');
INSERT INTO DStr_Cod_Unit (Id, Name, Rem) VALUES (5, 'متر مكعب', 'م3');
INSERT INTO DStr_Cod_Unit (Id, Name, Rem) VALUES (6, 'متر مربع', 'م2');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE DStr_Cod_Spc1_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Code_Specification1                      -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Spc1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Spc1_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Spc1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Spc1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Spc1 For DStr_Code_Specification1
/
INSERT INTO DStr_Cod_Spc1 (Id, Name) VALUES (0, '-');
INSERT INTO DStr_Cod_Spc1 (Id, Name) VALUES (1, 'طلبيات مصنع');
INSERT INTO DStr_Cod_Spc1 (Id, Name) VALUES (2, 'التقرير الشهري');
INSERT INTO DStr_Cod_Spc1 (Id, Name) VALUES (3, '3');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE DStr_Cod_Spc2_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Code_Specification2                      -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Spc2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Spc2_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Spc2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Spc2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Spc2 For DStr_Code_Specification2
/
INSERT INTO DStr_Cod_Spc2 (Id, Name) VALUES (0, '-');
INSERT INTO DStr_Cod_Spc2 (Id, Name) VALUES (1, 'طلبيات مصنع');
INSERT INTO DStr_Cod_Spc2 (Id, Name) VALUES (2, 'التقرير الشهري');
INSERT INTO DStr_Cod_Spc2 (Id, Name) VALUES (3, '3');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE DStr_Cod_Spc3_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Code_Specification3                      -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Spc3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Spc3_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Spc3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Spc3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Spc3 For DStr_Code_Specification3
/
INSERT INTO DStr_Cod_Spc3 (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE DStr_Cod_Spc4_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Code_Specification4                      -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Spc4_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Spc4_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Spc4_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Spc4_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Spc4 For DStr_Code_Specification4
/
INSERT INTO DStr_Cod_Spc4 (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE DStr_Cod_Spc5_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Code_Specification5                      -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Spc5_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Spc5_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Spc5_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Spc5_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Spc5 For DStr_Code_Specification5
/
INSERT INTO DStr_Cod_Spc5 (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE DStr_Cod_Loc1_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Code_Location1                           -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Loc1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Loc1_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Loc1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Loc1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Loc1 For DStr_Code_Location1
/
INSERT INTO DStr_Cod_Loc1 (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE DStr_Cod_Loc2_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Code_Location2                           -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Loc2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Loc2_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Loc2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Loc2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Loc2 For DStr_Code_Location2
/
INSERT INTO DStr_Cod_Loc2 (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE DStr_Cod_Loc3_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Code_Location3                           -- جدول ترميز
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_Cod_Loc3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT DStr_Cod_Loc3_UK     UNIQUE      (Name),
  CONSTRAINT DStr_Cod_Loc3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT DStr_Cod_Loc3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym DStr_Cod_Loc3 For DStr_Code_Location3
/
INSERT INTO DStr_Cod_Loc3 (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
