--set Pagesize 1000
--select 'Drop Table '   || table_name           ||                ';' from user_tables    where Table_name    like 'COPY%' ;
--select 'Drop Synonym ' || Synonym_name         ||                ';' from user_Synonyms  where Synonym_name  like 'CPY%' ;
--select 'Drop Sequence '|| Sequence_name        ||                ';' from user_Sequences where Sequence_name like 'CPY%' ;
--select 'Drop View '    || View_name            ||                ';' from user_Views     where View_name     like 'CPY%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'CPY%' ;
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Cod_Unit_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Code_Unit           				        -- جدول ترميز الوحدات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Cpy_Cod_Unit_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_Unit_UK        UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_Unit_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id)
)
/
--Alter Table Copy_Code_Unit Add CONSTRAINT Cpy_Cod_Unit_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id);
--Alter Table Copy_Code_Unit Add CONSTRAINT Cpy_Cod_Unit_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id);
Create Synonym Cpy_Cod_Unit For Copy_Code_Unit
/
Insert into Cpy_Cod_Unit (Id,Name) values (0,'Piece');
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Unit_Form_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Copy_Unit_Formula                             -- نسب التحويل بين الوحدات
( Id         Number(5),                                    -- مفتاح رئيسي
  FUnit_Id   Number(5) Default 0,                          -- الوحدة
  TUnit_Id   Number(5) Default 0,                          -- الوحدة
  Type_Id    Number(1) Default 0,                          -- النوع نسبة\عدد
  Perc       Number(25,3) Default 1,                       -- النسبة
  MInUnit    Number(25,3) Default 0.001,                   -- أصغر وحدة
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT  Cpy_UnitForm_PK       PRIMARY KEY (Id   ),
  CONSTRAINT  Cpy_UnitForm_FUnit_FK Foreign Key (FUnit_Id) References Cpy_Cod_Unit(Id),
  CONSTRAINT  Cpy_UnitForm_TUnit_FK Foreign Key (TUnit_Id) References Cpy_Cod_Unit(Id)
)
/
--Alter Table Copy_Unit_Formula Add CONSTRAINT Cpy_UnitForm_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id);
--Alter Table Copy_Unit_Formula Add CONSTRAINT Cpy_UnitForm_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id);
Create Synonym Cpy_Unit_Form For Copy_Unit_Formula
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Cod_Doc_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Code_Document        				        -- جدول ترميز أنواع الوثائق
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Cpy_Cod_Doc_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_Doc_UK        UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_Doc_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id)
)
/
Create Synonym Cpy_Cod_Doc For Copy_Code_Document
/
Insert into Cpy_Cod_Doc (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Cod_PStatus_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Code_PeriodStatus    				        -- جدول ترميز حالات فترة العمل
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Cpy_Cod_PStatus_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_PStatus_UK        UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_PStatus_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id)
)
/
Create Synonym Cpy_Cod_PStatus For Copy_Code_PeriodStatus
/
Insert into Cpy_Cod_PStatus (Id,Name) values (1,'Active'  );
Insert into Cpy_Cod_PStatus (Id,Name) values (2,'in Close');
Insert into Cpy_Cod_PStatus (Id,Name) values (3,'in Audit');
Insert into Cpy_Cod_PStatus (Id,Name) values (4,'Closed'  );
----------------------------------------------------------------------------------------------------
