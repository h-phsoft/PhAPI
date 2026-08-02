----------------------------------------------------------------------------------------------------
Create Table Copy_Code_Print_Formats                       -- جدول ترميز نماذج الطباعة
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Pkg        Varchar2(10 Char) NOT NULL,                   -- الموديول
  Grp        Varchar2(10 Char) NOT NULL,                   -- المجموعة
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  vValue     Varchar2(100 Char),                           -- القيمة
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Cod_Print_Format_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_Print_Format_UK     UNIQUE      (Grp, Name),
  CONSTRAINT Cpy_Cod_Print_Format_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Cod_Print_Format_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Cod_Print_Format_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Cod_Print_Format For Copy_Code_Print_Formats
/
INSERT INTO Cpy_Cod_Print_Format (Id, Pkg, Grp, Name, vValue) VALUES (1, 'FIN', 'INV', 'Invoice', ''   );
INSERT INTO Cpy_Cod_Print_Format (Id, Pkg, Grp, Name, vValue) VALUES (2, 'FIN', 'INV', 'IFR'    , 'IFR');
INSERT INTO Cpy_Cod_Print_Format (Id, Pkg, Grp, Name, vValue) VALUES (3, 'FIN', 'INV', 'LFR'    , 'LFR');
INSERT INTO Cpy_Cod_Print_Format (Id, Pkg, Grp, Name, vValue) VALUES (4, 'FIN', 'INV', 'CLR'    , 'CLR');
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_FDoc_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Finance_Documents			                   -- أنواع الوثائق المالية
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Num        Number(5) Default 0,                          -- رقم
  DBCR_Id    Number(1) Default 1,			                     -- النوع 1 مدينة \ -1 دائنة
  Status_Id  Number(1) Default 1,			                     -- الحالة
  Code       Varchar2(10 Char) NOT NULL,				           -- الرمز
  Name       Varchar2(100 Char) NOT NULL,			             -- الاسم
  Rem        Varchar2(250 Char),			                     -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Cpy_FinDoc_PK        Primary Key (Id  ),
  CONSTRAINT Cpy_FinDoc_Num_UK    Unique      (Num ),
  CONSTRAINT Cpy_FinDoc_Cod_UK    Unique      (Code),
  CONSTRAINT Cpy_FinDoc_Nam_UK    Unique      (Name),
  CONSTRAINT Cpy_FinDoc_DBCR_FK   Foreign Key (Ins_User ) References Phs_Cod_DBCR  (Id),
  CONSTRAINT Cpy_FinDoc_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_FinDoc_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_FinDoc_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_FDoc For Copy_Finance_Documents
/
----------------------------------------------------------------------------------------------------
