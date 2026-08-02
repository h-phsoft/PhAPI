--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'CRM%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'CRM%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'CRM%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'CRM%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'CRM%' ;
----------------------------------------------------------------------------------------------------
Create Table CRM_Code_Status                               -- جدول ترميز حالة التقرير
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT CRM_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT CRM_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT CRM_Cod_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT CRM_Cod_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym CRM_Cod_Status For CRM_Code_Status
/
Insert into CRM_Cod_Status (Id,Name) values (0,'-'     );
Insert into CRM_Cod_Status (Id,Name) values (1,'New'   );
Insert into CRM_Cod_Status (Id,Name) values (2,'Follow');
Insert into CRM_Cod_Status (Id,Name) values (3,'Closed');
----------------------------------------------------------------------------------------------------
Create Table CRM_Code_Type                                 -- جدول ترميز نوع التقرير
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT CRM_Cod_Type_PK     PRIMARY KEY (Id  ),
  CONSTRAINT CRM_Cod_Type_UK     UNIQUE      (Name),
  CONSTRAINT CRM_Cod_Type_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT CRM_Cod_Type_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym CRM_Cod_Type For CRM_Code_Type
/
Insert into CRM_Cod_Type (Id,Name) values (0,'-'     );
Insert into CRM_Cod_Type (Id,Name) values (1,'Visit' );
Insert into CRM_Cod_Type (Id,Name) values (2,'Call'  );
Insert into CRM_Cod_Type (Id,Name) values (3,'Email' );
----------------------------------------------------------------------------------------------------
Create Table CRM_Code_Kind                                 -- جدول ترميز طبيعة التقرير
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT CRM_Cod_Kind_PK     PRIMARY KEY (Id  ),
  CONSTRAINT CRM_Cod_Kind_UK     UNIQUE      (Name),
  CONSTRAINT CRM_Cod_Kind_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT CRM_Cod_Kind_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym CRM_Cod_Kind For CRM_Code_Kind
/
Insert into CRM_Cod_Kind (Id,Name) values (0,'-'          );
Insert into CRM_Cod_Kind (Id,Name) values (1,'Report'     );
Insert into CRM_Cod_Kind (Id,Name) values (2,'Opportunity');
----------------------------------------------------------------------------------------------------
Create Table CRM_Code_Clearance                            -- جدول ترميز التخليص الجمركي
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT CRM_Cod_Clearance_PK     PRIMARY KEY (Id  ),
  CONSTRAINT CRM_Cod_Clearance_UK     UNIQUE      (Name),
  CONSTRAINT CRM_Cod_Clearance_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT CRM_Cod_Clearance_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym CRM_Cod_Clearance For CRM_Code_Clearance
/
Insert into CRM_Cod_Clearance (Id,Name) values (0,'-'  );
Insert into CRM_Cod_Clearance (Id,Name) values (1,'Yes');
Insert into CRM_Cod_Clearance (Id,Name) values (2,'No' );
----------------------------------------------------------------------------------------------------
Create Sequence CRM_Cod_Grp_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table CRM_Code_Group                                -- جدول ترميز فئات التصنيف
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  FColor     Varchar2(100 Char),                           -- لون النص
  BColor     Varchar2(100 Char),                           -- لون الخلفية
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT CRM_Cod_Grp_PK        PRIMARY KEY (Id  ),
  CONSTRAINT CRM_Cod_Grp_UK        UNIQUE      (Name),
  CONSTRAINT CRM_Cod_Grp_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT CRM_Cod_Grp_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT CRM_Cod_Grp_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym CRM_Cod_Grp For CRM_Code_Group
/
Insert into CRM_Cod_Grp (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence CRM_Cod_Itm_Seq MinValue 1 Start With 1 MaxValue 9999999 INCREMENT BY 1 CACHE 2;
Create Table CRM_Code_Item                                 -- جدول ترميز بنود التصنيف
( Id         Number(7) NOT NULL,                           -- مفتاح رئيسي
  Grp_Id     Number(5) Default 1,                          -- مجموعة الترميز
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT CRM_Cod_Itm_PK        PRIMARY KEY (Id  ),
  CONSTRAINT CRM_Cod_Itm_UK        UNIQUE      (Name),
  CONSTRAINT CRM_Cod_Itm_Group_Fk  Foreign Key (Grp_Id   ) References CRM_Cod_Grp   (Id),
  CONSTRAINT CRM_Cod_Itm_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT CRM_Cod_Itm_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT CRM_Cod_Itm_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym CRM_Cod_Itm For CRM_Code_Item
/
Insert into CRM_Cod_Itm (Id,Grp_Id,Name) values (0,0,'-');
----------------------------------------------------------------------------------------------------
