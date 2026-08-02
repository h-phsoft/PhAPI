--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'ARCH%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'ARCH%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'ARCH%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'ARCH%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'ARCH%' ;
----------------------------------------------------------------------------------------------------
Create Table Arch_Code_                 -- جدول ترميز 
( Id         Number(1) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                      -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,              -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Arch_Cod__PK PRIMARY KEY (Id  ),
  CONSTRAINT Arch_Cod__UK UNIQUE      (Name),
  CONSTRAINT Arch_Cod__Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Arch_Cod__Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Arch_Cod_ For Arch_Code_
/
Insert into Arch_Cod_ (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Arch_Fld_Seq MinValue 100 Start With 100 MaxValue 99999 CACHE 2;
Create Table Arch_Field                               -- جدول توصيف الحقول
( Id         Number(9) NOT NULL,                      -- مفتاح رئيسي
  Type_id    Number(2) NOT NULL,                      -- نوع الحقل
  Table_id   Number(5) DEFAULT '-1' COMMENT 'Fk Table',
  Name       Varchar2(100 Char) NOT NULL,              -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  CONSTRAINT Arch_Field_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Arch_Field_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Arch_Fld For Arch_Field
/

Create Table Arch_Form                                -- جدول توصيف النماذج
( Id         Number(9) NOT NULL,                      -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  CONSTRAINT Arch__Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Arch__Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Arch_ For Arch_
/

Create Table Arch_Form_Detail                         -- جدول بنود النماذج
( Id          Number(9) NOT NULL,                     -- مفتاح رئيسي
  form_id     int NOT NULL COMMENT 'FK Form',
  field_id    int NOT NULL COMMENT 'FK Field',
  required_id tinyint NOT NULL DEFAULT '2' COMMENT 'YES NO',
  ord         tinyint DEFAULT '1' COMMENT 'Order',
  size        tinyint DEFAULT '2' COMMENT 'Size',
  Rem         Varchar2(100 Char),                      -- ملاحظات
  CONSTRAINT  Arch__Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT  Arch__Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Arch_ For Arch_
/

Create Table Arch_Operation
( Id         Number(9) NOT NULL,                      -- مفتاح رئيسي
  Tree_id    int NOT NULL COMMENT 'FK Node',
  Form_Id    int NOT NULL COMMENT 'FK Form',
  Date       date DEFAULT NULL COMMENT 'Date',
  hour       tinyint DEFAULT '0' COMMENT 'Hour',
  min        tinyint DEFAULT '0' COMMENT 'Minut',
  CONSTRAINT Arch__Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Arch__Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Arch_ For Arch_
/

Create Table Arch_Operation_Detail
( Id           Number(9) NOT NULL,                      -- مفتاح رئيسي
  Operation_Id int NOT NULL COMMENT 'FK Operation',
  Field_Id     int NOT NULL COMMENT 'FK Field',
  value        Varchar2(512) NOT NULL COMMENT 'Value',
  CONSTRAINT Arch__Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Arch__Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Arch_ For Arch_
/

Create Table Arch_Operation_Img
( Id           Number(9) NOT NULL,                      -- مفتاح رئيسي
  Operation_Id int NOT NULL COMMENT 'FK Operation',
  oname        Varchar2(512) NOT NULL COMMENT 'File Name',
  nname        Varchar2(512) NOT NULL COMMENT 'File Name New',
  CONSTRAINT Arch__Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Arch__Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Arch_ For Arch_
/

Create Table Arch_Table
( Id         Number(9) NOT NULL,                      -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,              -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  CONSTRAINT Arch__Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Arch__Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Arch_ For Arch_
/

Create Table Arch_Table_Detail
( Id         Number(9) NOT NULL,                      -- مفتاح رئيسي
  Table_Id   int NOT NULL COMMENT 'PK',
  Name       Varchar2(100 Char) NOT NULL,              -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  CONSTRAINT Arch__Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Arch__Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Arch_ For Arch_
/

Create Table Arch_Operation_Tree
( Id         Number(9) NOT NULL,                      -- مفتاح رئيسي
  Tree_Id    int NOT NULL COMMENT 'FK Tree',
  Form_Id    int NOT NULL COMMENT 'FK Form',
  Name       Varchar2(100 Char) NOT NULL,              -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  CONSTRAINT Arch__Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Arch__Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Arch_Tree For Arch_Operation_Tree
/
