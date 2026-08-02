--Set Pagesize 1000
--select 'Drop table '   || table_name    || ';' from user_tables    where table_name    like 'JOB%' ;
--select 'Drop Synonym ' || Synonym_name  || ';' from user_Synonyms  where Synonym_name  like 'JOB%' ;
--select 'Drop Sequence '|| Sequence_name || ';' from user_Sequences where Sequence_name like 'JOB%' ;
--select 'Drop View '    || View_name     || ';' from user_Views     where View_name     like 'JOB%' ;
----------------------------------------------------------------------------------------------------
Create Table Job_Code_Columns                              -- جدول الأعمدة
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Cod_Cols_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Job_Cod_Cols_UK        UNIQUE      (Name),
  CONSTRAINT Job_Cod_Cols_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Job_Cod_Cols_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Job_Cod_Cols_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Job_Cod_Cols For Job_Code_Columns
/
Insert into Job_Cod_Cols (Id,Name) values (2 ,'Small'  );
Insert into Job_Cod_Cols (Id,Name) values (3 ,'Medium' );
Insert into Job_Cod_Cols (Id,Name) values (5 ,'Large'  );
Insert into Job_Cod_Cols (Id,Name) values (11,'X-Large');
----------------------------------------------------------------------------------------------------
Create Table Job_Code_Employee_Specification_Type          -- جدول أنواع الحقول
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Cod_Emp_SType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Job_Cod_Emp_SType_UK     UNIQUE      (Name),
  CONSTRAINT Job_Cod_Emp_SType_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Job_Cod_Emp_SType_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Job_Cod_Emp_SType For Job_Code_Employee_Specification_Type
/
Insert into Job_Cod_Emp_SType (Id,Name) values ( 0,'Education'       );
Insert into Job_Cod_Emp_SType (Id,Name) values ( 1,'Job'             );
Insert into Job_Cod_Emp_SType (Id,Name) values ( 2,'Nationality'     );
Insert into Job_Cod_Emp_SType (Id,Name) values ( 3,'Specification 1' );
Insert into Job_Cod_Emp_SType (Id,Name) values ( 4,'Specification 2' );
Insert into Job_Cod_Emp_SType (Id,Name) values ( 5,'Specification 3' );
Insert into Job_Cod_Emp_SType (Id,Name) values ( 6,'Specification 4' );
----------------------------------------------------------------------------------------------------
Create Table Job_Code_Item_Specification_Type              -- جدول أنواع الحقول
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Cod_Item_SType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Job_Cod_Item_SType_UK     UNIQUE      (Name),
  CONSTRAINT Job_Cod_Item_SType_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Job_Cod_Item_SType_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Job_Cod_Item_SType For Job_Code_Item_Specification_Type
/
Insert into Job_Cod_Item_SType (Id,Name) values ( 0,'Category');
Insert into Job_Cod_Item_SType (Id,Name) values ( 1,'Specification 1' );
Insert into Job_Cod_Item_SType (Id,Name) values ( 2,'Specification 2' );
Insert into Job_Cod_Item_SType (Id,Name) values ( 3,'Specification 3' );
Insert into Job_Cod_Item_SType (Id,Name) values ( 4,'Specification 4' );
Insert into Job_Cod_Item_SType (Id,Name) values ( 5,'Specification 5' );
Insert into Job_Cod_Item_SType (Id,Name) values ( 6,'Specification 6' );
Insert into Job_Cod_Item_SType (Id,Name) values ( 7,'Specification 7' );
Insert into Job_Cod_Item_SType (Id,Name) values ( 8,'Specification 8' );
Insert into Job_Cod_Item_SType (Id,Name) values ( 9,'Specification 9' );
Insert into Job_Cod_Item_SType (Id,Name) values (10,'Specification 10');
----------------------------------------------------------------------------------------------------
Create Table Job_Code_Component_Type                       -- جدول أنواع الحقول
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Cod_CType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Job_Cod_CType_UK     UNIQUE      (Name),
  CONSTRAINT Job_Cod_CType_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Job_Cod_CType_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Job_Cod_CType For Job_Code_Component_Type
/
Insert into Job_Cod_CType (Id,Name) values (0,'-');
Insert into Job_Cod_CType (Id,Name) values (1,'Input'      );
Insert into Job_Cod_CType (Id,Name) values (2,'Select'     );
Insert into Job_Cod_CType (Id,Name) values (3,'Textarea'   );
Insert into Job_Cod_CType (Id,Name) values (4,'Checkbox'   );
Insert into Job_Cod_CType (Id,Name) values (5,'Multiselect');
Insert into Job_Cod_CType (Id,Name) values (6,'Label'      );
----------------------------------------------------------------------------------------------------
Create Table Job_Fld_Code_Data_Type                        -- جدول ترميز 
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Cod_DType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Job_Cod_DType_UK     UNIQUE      (Name),
  CONSTRAINT Job_Cod_DType_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Job_Cod_DType_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Job_Cod_DType For Job_Fld_Code_Data_Type
/
Insert into Job_Cod_DType (Id,Name) values (0,'-');
Insert into Job_Cod_DType (Id,Name) values (1,'String'   );
Insert into Job_Cod_DType (Id,Name) values (2,'Number'   );
Insert into Job_Cod_DType (Id,Name) values (3,'Date'     );
Insert into Job_Cod_DType (Id,Name) values (4,'Time'     );
Insert into Job_Cod_DType (Id,Name) values (5,'DateTime' );
Insert into Job_Cod_DType (Id,Name) values (6,'Decimal'  );
Insert into Job_Cod_DType (Id,Name) values (7,'Integer'  );
Insert into Job_Cod_DType (Id,Name) values (8,'FromTable');
----------------------------------------------------------------------------------------------------
Create Sequence Job_Res_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Job_Resources                                 -- جدول الحقول
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- الحالة
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Res_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Job_Res_UK        UNIQUE      (Name),
  CONSTRAINT Job_Res_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Job_Res_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Job_Res_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Job_Res For Job_Resources
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Fld_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Job_Field                                     -- جدول الحقول
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- الحالة
  DType_Id   Number(2) Default 1,                          -- نوع البيانات
  CType_Id   Number(2) Default 1,                          -- نوع الحقل
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  vValue     Varchar2(4000 Char),                          -- القيمة أبجدية
  nValue     Number(25,5),                                 -- القيمة رقمية
  dValue     Date,                                         -- القيمة تاريخ
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Fld_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Job_Fld_UK        UNIQUE      (Name),
  CONSTRAINT Job_Fld_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Job_Fld_DType_FK  Foreign Key (DType_Id ) References Job_Cod_DType (Id),
  CONSTRAINT Job_Fld_CType_FK  Foreign Key (CType_Id ) References Job_Cod_CType (Id),
  CONSTRAINT Job_Fld_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Job_Fld_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Job_Fld For Job_Field
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Fld_Vals_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Job_Field_Values                              -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Fld_Id     Number(5) Default 1,                          -- الأب
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Val        Number(3) Default 0,                          -- الرقم أو الترتيب
  Lbl        Varchar2(100 Char) NOT NULL,                  -- القيمة
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Fld_Vals_PK        PRIMARY KEY (Id),
  CONSTRAINT Job_Fld_Vals_UK        UNIQUE      (Fld_Id, Val),
  CONSTRAINT Job_Fld_Vals_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Job_Fld_Vals_Fld_FK    Foreign Key (Fld_Id   ) References Job_Fld       (Id),
  CONSTRAINT Job_Fld_Vals_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Job_Fld_Vals_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Job_Fld_Vals For Job_Field_Values
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Desc_Type_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Job_Desc_Types                                -- جدول أنواع المهام
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Desc_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Job_Desc_Type_UK        UNIQUE      (Name),
  CONSTRAINT Job_Desc_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Job_Desc_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Job_Desc_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Job_Desc_Type For Job_Desc_Types
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Desc_Type_Flds_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Job_Desc_Types_Fields                          -- جدول ترميز 
( Id          Number(5) NOT NULL,                           -- مفتاح رئيسي
  Job_Id      Number(5) NOT NULL,                           -- المهمة
  Fld_Id      Number(5) NOT NULL,                           -- الحقل
  Status_Id   Number(1) Default 1,                          -- الحالة
  Required_Id Number(1) Default 2,                          -- هل الحقل إجباري
  NewLine_Id  Number(1) Default 2,                          -- سطر جديد
  Cols_Id     Number(2) Default 2,                          -- عدد الأعمدة
  Ord         Number(2) Default 0,                          -- الترتيب
  Label       Varchar2(100 Char),                           -- الاسم
  vValue      Varchar2(4000 Char),                          -- القيمة أبجدية
  nValue      Number(25,5),                                 -- القيمة رقمية
  dValue      Date,                                         -- القيمة تاريخ
  dMinValue   Date,                                         -- القيمة تاريخ الدنيا
  dMaxValue   Date,                                         -- القيمة تاريخ العليا
  nMinValue   Number(25,5),                                 -- القيمة رقمية الدنيا
  nMaxValue   Number(25,5),                                 -- القيمة رقمية العليا
  Rem         Varchar2(100 Char),                           -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Job_Desc_Type_Fld_PK          PRIMARY KEY (Id  ),
  CONSTRAINT  Job_Desc_Type_Fld_UK          UNIQUE      (Job_Id, Fld_Id),
  CONSTRAINT  Job_Desc_Type_Fld_Job_FK      Foreign Key (Job_Id     ) References Job_Desc_Type (Id),
  CONSTRAINT  Job_Desc_Type_Fld_Fld_FK      Foreign Key (Fld_Id     ) References Job_Fld       (Id),
  CONSTRAINT  Job_Desc_Type_Fld_Status_FK   Foreign Key (Status_Id  ) References Phs_Cod_Status(Id),
  CONSTRAINT  Job_Desc_Type_Fld_Required_FK Foreign Key (Required_Id) References Phs_Cod_YesNo (Id),
  CONSTRAINT  Job_Desc_Type_Fld_NewLine_FK  Foreign Key (NewLine_Id ) References Phs_Cod_YesNo (Id),
  CONSTRAINT  Job_Desc_Type_Fld_Cols_FK     Foreign Key (Cols_Id    ) References Job_Cod_Cols  (Id),
  CONSTRAINT  Job_Desc_Type_Fld_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User      (Id),
  CONSTRAINT  Job_Desc_Type_Fld_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User      (Id)
)
/
Create Synonym Job_Desc_Type_Fld For Job_Desc_Types_Fields
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Desc_Type_ChkList_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Job_Desc_Types_Checklis                        -- جدول ترميز 
( Id          Number(5) NOT NULL,                           -- مفتاح رئيسي
  Job_Id      Number(5) NOT NULL,                           -- المهمة
  Status_Id   Number(1) Default 1,                          -- الحالة
  Ord         Number(3) Default 0,                          -- الترتيب
  Txt         Varchar2(4000 Char),                          -- البيان
  Rem         Varchar2(100 Char),                           -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Job_Desc_Type_ChkList_PK        PRIMARY KEY (Id),
  CONSTRAINT  Job_Desc_Type_ChkList_Job_FK    Foreign Key (Job_Id   ) References Job_Desc_Type (Id),
  CONSTRAINT  Job_Desc_Type_ChkList_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  Job_Desc_Type_ChkList_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Job_Desc_Type_ChkList_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Job_Desc_Type_ChkList For Job_Desc_Types_Checklis
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Desc_Type_Item_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Job_Desc_Types_Items                          -- جدول مواد نوع مهمة
( Id         Number(9) NOT NULL,                           -- مفتاح رئيسي
  Job_Id     Number(5) NOT NULL,                           -- المهمة
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Qnt        Number(17,3) Default 0,                       -- الكمية
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Desc_Type_Item_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Job_Desc_Type_Item_UK        UNIQUE      (Job_Id, Name),
  CONSTRAINT Job_Desc_Type_Item_Job_FK    Foreign Key (Job_Id   ) References Job_Desc_Type (Id),
  CONSTRAINT Job_Desc_Type_Item_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Job_Desc_Type_Item_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Job_Desc_Type_Item_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Job_Desc_Type_Item For Job_Desc_Types_Items
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Desc_Type_Item_Class_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Job_Desc_Types_Items_Class                    -- جدول تصانيف مادة مهمة
( Id         Number(9) NOT NULL,                           -- مفتاح رئيسي
  JItem_Id   Number(9) NOT NULL,                           -- مادة مهمة
  SType_Id   Number(2) Default 0,                          -- حقل التوصيف 0=Cat, 1=Spc1...
  Rel_Id     Number(5) Default 0,                          -- التصنيف
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Desc_Type_Item_Class_PK       PRIMARY KEY (Id),
  CONSTRAINT Job_Desc_Type_Item_Class_JItem_FK Foreign Key (JItem_Id) References Job_Desc_Type_Item(Id),
  CONSTRAINT Job_Desc_Type_Item_Class_SType_FK Foreign Key (SType_Id) References Job_Cod_Item_SType(Id),
  CONSTRAINT Job_Desc_Type_Item_Class_Ins_FK   Foreign Key (Ins_User) References Cpy_User          (Id),
  CONSTRAINT Job_Desc_Type_Item_Class_Upd_FK   Foreign Key (Upd_User) References Cpy_User          (Id)
)
/
Create Synonym Job_Desc_Type_Item_Class For Job_Desc_Types_Items_Class
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Desc_Type_Res_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Job_Desc_Types_Resources                      -- جدول ترميز 
( Id         Number(9) NOT NULL,                           -- مفتاح رئيسي
  Job_Id     Number(5) NOT NULL,                           -- المهمة
  Res_Id     Number(5) NOT NULL,                           -- المصادر
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Qnt        Number(17,3) Default 0,                       -- الكمية
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Desc_Type_Res_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Job_Desc_Type_Res_UK        UNIQUE      (Job_Id, Res_Id),
  CONSTRAINT Job_Desc_Type_Res_Job_FK    Foreign Key (Job_Id   ) References Job_Desc_Type (Id),
  CONSTRAINT Job_Desc_Type_Res_Res_FK    Foreign Key (Res_Id   ) References Job_Res       (Id),
  CONSTRAINT Job_Desc_Type_Res_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Job_Desc_Type_Res_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Job_Desc_Type_Res_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Job_Desc_Type_Res For Job_Desc_Types_Resources
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Desc_Type_Emp_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Job_Desc_Types_Employee                       -- جدول موظفي نوع مهمة
( Id         Number(9) NOT NULL,                           -- مفتاح رئيسي
  Job_Id     Number(5) NOT NULL,                           -- المهمة
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Qnt        Number(17,3) Default 0,                       -- الكمية
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Desc_Type_Emp_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Job_Desc_Type_Emp_UK        UNIQUE      (Job_Id, Name),
  CONSTRAINT Job_Desc_Type_Emp_Job_FK    Foreign Key (Job_Id   ) References Job_Desc_Type (Id),
  CONSTRAINT Job_Desc_Type_Emp_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Job_Desc_Type_Emp_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Job_Desc_Type_Emp_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Job_Desc_Type_Emp For Job_Desc_Types_Employee
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Desc_Type_Emp_Class_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Job_Desc_Types_Employee_Class                 -- جدول تصانيف مادة مهمة
( Id         Number(9) NOT NULL,                           -- مفتاح رئيسي
  JEmp_Id    Number(9) NOT NULL,                           -- مادة مهمة
  SType_Id   Number(2) Default 0,                          -- حقل التوصيف 0=Cat, 1=Spc1...
  Rel_Id     Number(5) Default 0,                          -- التصنيف
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Desc_Type_Emp_Class_PK       PRIMARY KEY (Id),
  CONSTRAINT Job_Desc_Type_Emp_Class_JEmp_FK  Foreign Key (JEmp_Id ) References Job_Desc_Type_Emp(Id),
  CONSTRAINT Job_Desc_Type_Emp_Class_SType_FK Foreign Key (SType_Id) References Job_Cod_Emp_SType(Id),
  CONSTRAINT Job_Desc_Type_Emp_Class_Ins_FK   Foreign Key (Ins_User) References Cpy_User         (Id),
  CONSTRAINT Job_Desc_Type_Emp_Class_Upd_FK   Foreign Key (Upd_User) References Cpy_User         (Id)
)
/
Create Synonym Job_Desc_Type_Emp_Class For Job_Desc_Types_Employee_Class
/
----------------------------------------------------------------------------------------------------
/*
Create Sequence Job_Jobs_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE Table Job_Jobs                                      -- جدول الأعمال
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
Create Synonym Job_Proj For Job_Project
/
ALTER Table Job_Project ADD CONSTRAINT Job_Proj_Proj_FK Foreign Key (Proj_Id) References Proj_Proj(Id);
*/
----------------------------------------------------------------------------------------------------done
--Create Sequence Job_Proj_Attache_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE Table Job_Project_Attache
--( Id         Number(9) NOT NULL,                           -- PK
--  Proj_Id    Number(9) NOT NULL,                           -- Project
--  DDate      Date NOT NULL,                                -- Date
--  Name       Varchar2(100 Char),                           -- اسم المرفق
--  FileName   Varchar2(100 Char),                           -- اسم الملف المرفق
--  Rem        Varchar2(100 Char),                           -- Remarks
--  Ins_User   Number(5), Ins_Date     Date,
--  Upd_User   Number(5), Upd_Date     Date,
--  CONSTRAINT Job_Proj_Attache_PK      PRIMARY KEY (Id),
--  CONSTRAINT Job_Proj_Attache_Proj_FK Foreign Key (Proj_Id ) References Proj_Proj(Id),
--  CONSTRAINT Job_Proj_Attache_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
--  CONSTRAINT Job_Proj_Attache_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
--)
--/
--Create Synonym Job_Proj_Attache For Job_Project_Attache
--/
----------------------------------------------------------------------------------------------------done
/*
Create Sequence Job_proj_RateMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE Table Job_Project_RatingMst
( Id         Number(9) NOT NULL,                          -- PK
  Project_Id Number(9) NOT NULL,                          -- project
  SDate      Date NOT NULL,                               -- start Date
  EDate      Date NOT NULL,                               -- end Date
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Proj_RateMst_PK          PRIMARY KEY (Id),
  CONSTRAINT Job_Proj_RateMst_Project_FK  Foreign Key (Project_Id )References Proj_Proj      (Id),
  CONSTRAINT Job_Proj_RateMst_Ins_FK      Foreign Key (Ins_User   )References Cpy_User       (Id),
  CONSTRAINT Job_Proj_RateMst_Upd_FK      Foreign Key (Upd_User   )References Cpy_User       (Id)
)
/
Create Synonym Job_Proj_RateMst For Job_Project_RatingMst
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Proj_RateTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE Table Job_Project_RatingTrn
( Id         Number(9) NOT NULL,                          -- PK
  Mst_Id     Number(9) NOT NULL,                          -- Mst Id
  Rate_Id    Number(1) DEFAULT 0  NOT NULL,               -- Rate  
  User_Id    Number(9) NOT NULL,                          -- user
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Proj_RateTrn_PK          PRIMARY KEY (Id),
  CONSTRAINT Job_Proj_RateTrn_Mst_FK      Foreign Key (Mst_Id     )References Proj_Proj_RateMst (Id),
  CONSTRAINT Job_Proj_RateTrn_Rate_FK     Foreign Key (Rate_Id    )References Proj_Cod_Rate    (Id),
  CONSTRAINT Job_Proj_RateTrn_Ins_FK      Foreign Key (Ins_User   )References Cpy_User         (Id),
  CONSTRAINT Job_Proj_RateTrn_Upd_FK      Foreign Key (Upd_User   )References Cpy_User         (Id)
)
/
Create Synonym Job_Proj_RateTrn For Job_Project_RatingTrn
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_Proj_Expense_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE Table Job_Project_Expense
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
  CONSTRAINT Job_Proj_Expense_PK      PRIMARY KEY (Id),
  CONSTRAINT Job_Proj_Expense_Proj_FK Foreign Key (Proj_Id ) References Proj_Proj(Id),
  CONSTRAINT Job_Proj_Expense_Cont_FK Foreign Key (Cont_Id ) References Mng_Cont (Id),
  CONSTRAINT Job_Proj_Expense_Serv_FK Foreign Key (Serv_Id ) References Mng_Serv (Id),
  CONSTRAINT Job_Proj_Expense_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn (Id),
  CONSTRAINT Job_Proj_Expense_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Job_Proj_Expense_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Job_Proj_Expense For Job_Project_Expense
/
*/
----------------------------------------------------------------------------------------------------done
--Create Sequence Job_ProjExp_Attache_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE Table Job_Project_Expense_Attache
--( Id         Number(9) NOT NULL,                           -- PK
--  ProjExp_Id Number(9) NOT NULL,                           -- Project Expense
--  DDate      Date NOT NULL,                                -- Date
--  Name       Varchar2(100 Char),                           -- اسم المرفق
--  FileName   Varchar2(100 Char),                           -- اسم الملف المرفق
--  Rem        Varchar2(100 Char),                           -- Remarks
--  Ins_User   Number(5), Ins_Date     Date,
--  Upd_User   Number(5), Upd_Date     Date,
--  CONSTRAINT Job_ProjExp_Attache_PK         PRIMARY KEY (Id),
--  CONSTRAINT Job_ProjExp_Attache_ProjExp_FK Foreign Key (ProjExp_Id ) References Proj_Proj_Expense(Id),
--  CONSTRAINT Job_ProjExp_Attache_Ins_FK     Foreign Key (Ins_User   ) References Cpy_User (Id),
--  CONSTRAINT Job_ProjExp_Attache_Upd_FK     Foreign Key (Upd_User   ) References Cpy_User (Id)
--)
--/
--Create Synonym Job_ProjExp_Attache For Job_Project_Expense_Attache
--/
----------------------------------------------------------------------------------------------------
/*
Create Sequence Job_Proj_Note_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE Table Job_Project_Note
( Id         Number(9) NOT NULL,                           -- PK
  Proj_Id    Number(5),                                    -- Project
  User_Id    Number(5),                                    -- User
  DDate      Date DEFAULT Sysdate NOT NULL,                -- Date
  Note       Varchar2(4000 Char),                          -- Note
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Proj_Note_PK      PRIMARY KEY (Id  ),
  CONSTRAINT Job_Proj_Note_Proj_FK Foreign Key (Proj_Id ) References Proj_Proj(Id),
  CONSTRAINT Job_Proj_Note_User_FK Foreign Key (User_Id ) References Cpy_User (Id),
  CONSTRAINT Job_Proj_Note_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Job_Proj_Note_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Job_Proj_Note For Job_Project_Note
/
*/
----------------------------------------------------------------------------------------------------done
--Create Sequence Job_ProjNote_Attache_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE Table Job_Project_Note_Attache
--( Id          Number(9) NOT NULL,                           -- PK
--  ProjNote_Id Number(9) NOT NULL,                           -- Project Expense
--  DDate       Date NOT NULL,                                -- Date
--  Name        Varchar2(100 Char),                           -- اسم المرفق
--  FileName    Varchar2(100 Char),                           -- اسم الملف المرفق
--  Rem         Varchar2(100 Char),                           -- Remarks
--  Ins_User    Number(5), Ins_Date     Date,
--  Upd_User    Number(5), Upd_Date     Date,
--  CONSTRAINT Job_ProjNote_Attache_PK          PRIMARY KEY (Id),
--  CONSTRAINT Job_ProjNote_Attache_ProjNote_FK Foreign Key (ProjNote_Id) References Proj_Proj_Note(Id),
--  CONSTRAINT Job_ProjNote_Attache_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User (Id),
--  CONSTRAINT Job_ProjNote_Attache_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User (Id)
--)
--/
--Create Synonym Job_ProjNote_Attache For Job_Project_Note_Attache
--/
----------------------------------------------------------------------------------------------------
/*
Create Sequence Job_Proj_Team_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE Table Job_Project_Team
( Id         Number(9) NOT NULL,                           -- PK
  Proj_Id    Number(5) NOT NULL,                           -- Project
  Team_Id    Number(5) NOT NULL,                           -- Team Member
  Status_Id  Number(1) DEFAULT 1 NOT NULL,                 -- Status
  Title      Varchar2(100 Char) DEFAULT 'Member' NOT NULL, -- Member Title
  Rem        Varchar2(100 Char),                           -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_Proj_Team_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Job_Proj_Team_UK        UNIQUE      (Proj_Id, Team_Id),
  CONSTRAINT Job_Proj_Team_Proj_FK   Foreign Key (Proj_Id  ) References Proj_Proj     (Id),
  CONSTRAINT Job_Proj_Team_Team_FK   Foreign Key (Team_Id  ) References Proj_Team     (Id),
  CONSTRAINT Job_Proj_Team_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Job_Proj_Team_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Job_Proj_Team_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Job_Proj_Team For Job_Project_Team
/
----------------------------------------------------------------------------------------------------done
Create Sequence Job_ProjTeam_RateMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE Table Job_Project_Team_RatingMst
( Id         Number(9) NOT NULL,                          -- PK
  Team_Id    Number(9) NOT NULL,                          -- Team
  SDate      Date NOT NULL,                               -- start Date
  EDate      Date NOT NULL,                               -- end Date
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_ProjTeam_RateMst_PK          PRIMARY KEY (Id),
  CONSTRAINT Job_ProjTeam_RateMst_Task_FK     Foreign Key (Team_Id    )References Proj_Proj_Team (Id),
  CONSTRAINT Job_ProjTeam_RateMst_Ins_FK      Foreign Key (Ins_User   )References Cpy_User       (Id),
  CONSTRAINT Job_ProjTeam_RateMst_Upd_FK      Foreign Key (Upd_User   )References Cpy_User       (Id)
)
/
Create Synonym Job_ProjTeam_RateMst For Job_Project_Team_RatingMst
/
----------------------------------------------------------------------------------------------------
Create Sequence Job_ProjTeam_RateTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE Table Job_Project_Team_RatingTrn
( Id         Number(9) NOT NULL,                          -- PK
  Mst_Id     Number(9) NOT NULL,                          -- Mst Id
  Rate_Id    Number(1) DEFAULT 0 NOT NULL,                -- Rate  
  User_Id    Number(9) NOT NULL,                          -- user
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Job_ProjTeam_RateTrn_PK          PRIMARY KEY (Id),
  CONSTRAINT Job_ProjTeam_RateTrn_Mst_FK      Foreign Key (Mst_Id     )References Proj_ProjTeam_RateMst (Id),
  CONSTRAINT Job_ProjTeam_RateTrn_Rate_FK     Foreign Key (Rate_Id    )References Proj_Cod_Rate         (Id),
  CONSTRAINT Job_ProjTeam_RateTrn_Ins_FK      Foreign Key (Ins_User   )References Cpy_User              (Id),
  CONSTRAINT Job_ProjTeam_RateTrn_Upd_FK      Foreign Key (Upd_User   )References Cpy_User              (Id)
)
/
Create Synonym Job_ProjTeam_RateTrn For Job_Project_Team_RatingTrn
/
*/
----------------------------------------------------------------------------------------------------
--Create Sequence Job_Task_Team_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE Table Job_Task_Team_Member
--( Id         Number(9) NOT NULL,                           -- PK
--  Task_Id    Number(9) NOT NULL,                           -- Task
--  Team_Id    Number(9) NOT NULL,                           -- Team Member
--  Status_Id  Number(2) NOT NULL,                           -- Status
--  Ins_User   Number(5), Ins_Date     Date,
--  Upd_User   Number(5), Upd_Date     Date,
--  CONSTRAINT Job_Task_Team_PK        PRIMARY KEY (Id  ),
--  CONSTRAINT Job_Task_Team_UK        UNIQUE      (Task_Id, Team_Id),
--  CONSTRAINT Job_Task_Team_Task_FK   Foreign Key (Task_Id  ) References Job_Task      (Id),
--  CONSTRAINT Job_Task_Team_Team_FK   Foreign Key (Team_Id  ) References Proj_Team     (Id),
--  CONSTRAINT Job_Task_Team_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
--  CONSTRAINT Job_Task_Team_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
--  CONSTRAINT Job_Task_Team_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
--)
--/
--Create Synonym Job_Task_Team For Job_Task_Team_Member
--/
----------------------------------------------------------------------------------------------------
--Create Sequence Job_Follow_Team_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE Table Job_Followup_Team
--( Id         Number(9) NOT NULL,                           -- PK
--  Follow_Id  Number(9) NOT NULL,                           -- Follow
--  Team_Id    Number(9) NOT NULL,                           -- Team Member
--  Ins_User   Number(5), Ins_Date     Date,
--  Upd_User   Number(5), Upd_Date     Date,
--  CONSTRAINT Job_Follow_Team_PK        PRIMARY KEY (Id),
--  CONSTRAINT Job_Follow_Team_UK        UNIQUE      (Follow_Id, Team_Id),
--  CONSTRAINT Job_Follow_Team_Follow_FK Foreign Key (Follow_Id) References Job_Task_Follow (Id),
--  CONSTRAINT Job_Follow_Team_Team_FK   Foreign Key (Team_Id  ) References Proj_Team       (Id),
--  CONSTRAINT Job_Follow_Team_Ins_FK    Foreign Key (Ins_User ) References Cpy_User        (Id),
--  CONSTRAINT Job_Follow_Team_Upd_FK    Foreign Key (Upd_User ) References Cpy_User        (Id)
--)
--/
--Create Synonym Job_Follow_Team For Job_Followup_Team
--/
----------------------------------------------------------------------------------------------------
/*
Create Sequence Job_Meet_seq MinValue 0 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Job_Meeting                                  -- طلب الاحتياج
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
  CONSTRAINT Job_Meet_PK          PRIMARY KEY (Id),
  CONSTRAINT Job_Meet_Proj_FK     Foreign Key (Proj_Id    ) References Proj_Proj         (Id),
  CONSTRAINT Job_Meet_SchedEmp_FK Foreign Key (SchedEmp_Id) References Cpy_User          (Id),
  CONSTRAINT Job_Meet_Type_FK     Foreign Key (Type_Id    ) References Proj_Cod_MeetType (Id),
  CONSTRAINT Job_Meet_Status_FK   Foreign Key (Status_Id  ) References Phs_Cod_YesNo     (Id),
  CONSTRAINT Job_Meet_Kind_FK     Foreign Key (Kind_Id    ) References Proj_Cod_MeetKind (Id),
  CONSTRAINT Job_Meet_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User          (Id),
  CONSTRAINT Job_Meet_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User          (Id)  
)
/
Create Synonym Job_Meet For Job_Meeting
/
--------------------------------------------------------------------------------------------------   
Create Sequence Job_Meet_Team_seq MinValue 0 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Job_Meeting_Team                                  -- بنود طلب الاحتياج
( Id         Number(9) NOT NULL ,                               -- مفتاح رئيسي
  Mst_Id     Number(5) NOT NULL ,                               -- مفتاح الاب
  User_Id    Number(9) NOT NULL ,                               -- الموظفين
  App_Id     Number(1) Default 2,                               -- حضر ام لم يحضر
  Rem        Varchar2(100 Char) ,                               -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Job_Meet_Team_PK      PRIMARY KEY (Id),
  CONSTRAINT Job_Meet_Team_Mst_FK  Foreign Key (Mst_Id ) References Proj_Meet      (Id),
  CONSTRAINT Job_Meet_Team_User_FK Foreign Key (User_Id ) References Cpy_User      (Id),
  CONSTRAINT Job_Meet_Team_App_FK  Foreign Key (App_Id  ) References Phs_Cod_YesNo (Id),
  CONSTRAINT Job_Meet_Team_Ins_FK  Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Job_Meet_Team_Upd_FK  Foreign Key (Upd_User) References Cpy_User      (Id) 
)
/
Create Synonym Job_Meet_Team For Job_Meeting_Team
/
*/
--------------------------------------------------------------------------------------------------
