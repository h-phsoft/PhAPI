--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'NOTIF%';
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'NOTIF%';
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'NOTIF%';
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'NOTIF%';
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'NOTIF%';
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Cod_Type_Seq MinValue 1 Start With 1 MaxValue 99 CACHE 2;
Create Table Notif_Code_Type                               -- جدول ترميز  أنواع  الإشعارات
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Notif_Cod_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Notif_Cod_Type_UK        UNIQUE      (Name),
  CONSTRAINT Notif_Cod_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Notif_Cod_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Notif_Cod_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Notif_Cod_Type For Notif_Code_Type
/
Insert into Notif_Cod_Type (Id,Name) values (1,'System');
Insert into Notif_Cod_Type (Id,Name) values (2,'User');
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Cod_fld_Kind_Seq MinValue 1 Start With 1 MaxValue 99 CACHE 2;
Create Table Notif_Code_fields_Kind                        -- جدول ترميز أنواع حقول الجداول
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Notif_Cod_fld_Kind_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Notif_Cod_fld_Kind_UK        UNIQUE      (Name),
  CONSTRAINT Notif_Cod_fld_Kind_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Notif_Cod_fld_Kind_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Notif_Cod_fld_Kind_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Notif_Cod_fld_Kind For Notif_Code_fields_Kind
/
Insert into Notif_Cod_fld_Kind (Id,Name) values (1,'String');
Insert into Notif_Cod_fld_Kind (Id,Name) values (2,'Number');
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Cod_Event_Seq MinValue 1 Start With 1 MaxValue 99 CACHE 2;
Create Table Notif_Code_Events                             -- جدول ترميز الأحداث
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Notif_Cod_Event_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Notif_Cod_Event_UK        UNIQUE      (Name),
  CONSTRAINT Notif_Cod_Event_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Notif_Cod_Event_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Notif_Cod_Event_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Notif_Cod_Event For Notif_Code_Events
/
Insert into Notif_Cod_Event (Id,Name) values (1,'insert');
Insert into Notif_Cod_Event (Id,Name) values (2,'update');
Insert into Notif_Cod_Event (Id,Name) values (3,'delete');
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Cod_Cont_Type_Seq MinValue 1 Start With 1 MaxValue 99 CACHE 2;
Create Table Notif_Code_Content_Type                       -- جدول ترميز نوع محتوى الرسالة
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Notif_Cod_Cont_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Notif_Cod_Cont_Type_UK        UNIQUE      (Name),
  CONSTRAINT Notif_Cod_Cont_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Notif_Cod_Cont_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Notif_Cod_Cont_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Notif_Cod_Cont_Type For Notif_Code_Content_Type
/
Insert into Notif_Cod_Cont_Type (Id,Name) values (1,'value');
Insert into Notif_Cod_Cont_Type (Id,Name) values (2,'field');
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Cod_Dest_Type_Seq MinValue 1 Start With 1 MaxValue 99 CACHE 2;
Create Table Notif_Code_Destination_Type                   -- جدول ترميز جهات إرسال الإشعار
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Notif_Cod_Dest_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Notif_Cod_Dest_Type_UK        UNIQUE      (Name),
  CONSTRAINT Notif_Cod_Dest_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Notif_Cod_Dest_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Notif_Cod_Dest_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Notif_Cod_Dest_Type For Notif_Code_Destination_Type
/
Insert into Notif_Cod_Dest_Type (Id,Name) values (1,'user');
Insert into Notif_Cod_Dest_Type (Id,Name) values (2,'permGroup');
Insert into Notif_Cod_Dest_Type (Id,Name) values (3,'Departement');
Insert into Notif_Cod_Dest_Type (Id,Name) values (4,'unit');
Insert into Notif_Cod_Dest_Type (Id,Name) values (5,'broadcast');
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Table_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;
Create Table Notif_Tables                                                                          -- جدول ترميز جداول الإشعارات
( Id         Number(5) NOT NULL,                                                                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                                                                  -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                                                          -- الاسم
  DName      Varchar2(100 Char) NOT NULL,                                                          -- الاسم الظاهر للمستخدم النهائي
  Rem        Varchar2(100 Char),                                                                   -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Notif_Table_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Notif_Table_UK        UNIQUE      (Name),
  CONSTRAINT Notif_Table_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Notif_Table_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Notif_Table_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Notif_Table For Notif_Tables
/
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Table_fld_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;
Create Table Notif_Tables_Fields                                                                   -- جدول  حقول جداول الإشعارات
( Id         Number(5) NOT NULL,                                                                   -- مفتاح رئيسي
  Table_Id   Number(5) NOT NULL,                                                                   -- الجدول
  Kind_Id    Number(2) NOT NULL,                                                                   -- نوع الحقل
  Name       Varchar2(100 Char) NOT NULL,                                                          -- الاسم
  DName      Varchar2(100 Char) NOT NULL,                                                          -- الاسم الظاهر للمستخدم النهائي
  Rem        Varchar2(100 Char),                                                                   -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Notif_Table_fld_PK       PRIMARY KEY (Id  ),
  CONSTRAINT Notif_Table_fld_UK       UNIQUE      (table_Id, Name),
  CONSTRAINT Notif_Table_fld_Table_FK Foreign Key (table_Id) References Notif_Table        (Id),
  CONSTRAINT Notif_Table_fld_kind_FK  Foreign Key (kind_Id ) References Notif_Cod_Fld_Kind (Id),
  CONSTRAINT Notif_Table_fld_Ins_FK   Foreign Key (Ins_User) References Cpy_User           (Id),
  CONSTRAINT Notif_Table_fld_Upd_FK   Foreign Key (Upd_User) References Cpy_User           (Id)
)
/
Create Synonym Notif_Table_Fld For Notif_Tables_Fields
/
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Table_Evnt_Seq MinValue 1 Start With 1 MaxValue 999999999 CACHE 2;
Create Table Notif_Table_Events                                                                    -- جدول الإشعارات
( Id         Number(9) NOT NULL,                                                                   -- مفتاح رئيسي
  table_Id   Number(5) NOT NULL,                                                                   -- الجدول
  event_Id   Number(2) NOT NULL,                                                                   -- الحدث 
  type_Id    Number(2) NOT NULL,                                                                   -- نوع الإشعار
  Status_Id  Number(1) Default 1,                                                                  -- حالة الترميز
  Title      Varchar2(100 Char) NOT NULL,                                                          -- العنوان
  Color      Varchar2(10  Char) NOT NULL,                                                          -- اللون
  Icon       Varchar2(100 Char) NOT NULL,                                                          -- الأيقونة
  Rem        Varchar2(100 Char),                                                                   -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Notif_Table_Event_PK        PRIMARY KEY (Id),
  CONSTRAINT Notif_Table_Event_UK        UNIQUE      (table_Id, Event_Id),
  CONSTRAINT Notif_Table_Event_table_FK  Foreign Key (table_Id ) References Notif_Table    (Id),
  CONSTRAINT Notif_Table_Event_event_FK  Foreign Key (event_Id ) References Notif_Cod_Event(Id),
  CONSTRAINT Notif_Table_Event_type_FK   Foreign Key (type_Id  ) References Notif_Cod_Type (Id),
  CONSTRAINT Notif_Table_Event_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Notif_Table_Event_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Notif_Table_Event_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Notif_Table_Eevnt For Notif_Table_Events
/
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Table_Event_Descr_Seq MinValue 1 Start With 1 MaxValue 999999999 CACHE 2;
Create Table Notif_Table_Event_Description                                                         -- جدول توصيف الرسالة
( Id         Number(9) NOT NULL,                                                                   -- مفتاح رئيسي
  TEvent_Id  Number(9) NOT NULL,                                                                   -- الرسالة
  Field_Id   Number(5),                                                                            -- حقل الجدول المراد قيمته
  Type_Id    Number(2) Default 1 ,                                                                 -- النوع نص /حقل 
  nOrder     Number(3) Default 0,                                                                  -- الترتيب
  Value      Varchar2(1024 Char),                                                                  -- النص 
  Rem        Varchar2(100 Char),                                                                   -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Notif_Table_Event_Descr_PK       PRIMARY KEY (Id),  
  CONSTRAINT Notif_Table_Event_Descr_Notif_FK Foreign Key (TEvent_Id) References Notif_Table_Eevnt   (Id),
  CONSTRAINT Notif_Table_Event_Descr_Field_FK Foreign Key (Field_Id ) References Notif_Table_Fld    (Id),
  CONSTRAINT Notif_Table_Event_Descr_Type_FK  Foreign Key (Type_Id  ) References Notif_Cod_Cont_Type(Id),
  CONSTRAINT Notif_Table_Event_Descr_Ins_FK   Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT Notif_Table_Event_Descr_Upd_FK   Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Notif_Table_Event_Descr For Notif_Table_Event_Description
/
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Table_Event_Recip_Seq MinValue 1 Start With 1 MaxValue 999999999 CACHE 2;
Create Table Notif_Table_Event_Recipients                                                          -- جدول جهات الإرسال
( Id         Number(9) NOT NULL,                                                                   -- مفتاح رئيسي
  TEvent_Id  Number(9) NOT NULL,                                                                   -- الرسالة
  Type_Id    Number(2) Default 1,                                                                  -- نوع الوجهة
  User_Id    Number(5),                                                                            -- المستخدم
  Dept_Id    Number(5) Default 0,                                                                  -- الإدارة
  Unit_Id    Number(5) Default 0,                                                                  -- الوحدة
  PGrp_Id    Number(5) Default 0,                                                                  -- مجموعة الصلاحيات
  Rem        Varchar2(100 Char),                                                                   -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date, 
  CONSTRAINT Notif_Table_Event_Recip_PK       PRIMARY KEY (Id),
  CONSTRAINT Notif_Table_Event_Recip_Notif_FK Foreign Key (TEvent_Id) References Notif_Table_Eevnt  (Id),
  CONSTRAINT Notif_Table_Event_Recip_Dest_FK  Foreign Key (Type_Id  ) References Notif_Cod_Dest_Type(Id),
  CONSTRAINT Notif_Table_Event_Recip_user_FK  Foreign Key (User_Id  ) References Cpy_User           (Id),
  CONSTRAINT Notif_Table_Event_Recip_Dept_FK  Foreign Key (Dept_Id  ) References Cpy_Dept           (Id),
  CONSTRAINT Notif_Table_Event_Recip_Unit_FK  Foreign Key (Unit_Id  ) References Cpy_Unit           (Id),
  CONSTRAINT Notif_Table_Event_Recip_PGrp_FK  Foreign Key (PGrp_Id  ) References Cpy_PGrp           (Id),
  CONSTRAINT Notif_Table_Event_Recip_Ins_FK   Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT Notif_Table_Event_Recip_Upd_FK   Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Notif_Table_Event_Recip For Notif_Table_Event_Recipients
/
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Table_Event_Action_Seq MinValue 1 Start With 1 MaxValue 999999999 CACHE 2;
Create Table Notif_Table_Event_Actions                                                             -- جدول أحداث الإشعار
( Id         Number(9) NOT NULL,                                                                   -- مفتاح رئيسي
  TEvent_Id  Number(9) NOT NULL,                                                                   -- الرسالة
  Field_Id   Number(5),                                                                            -- الحقل الذي سترسل قيمته إلى ال  api 
  Name       Varchar2(100 Char) NOT NULL,                                                          -- الاسم
  DName      Varchar2(100 Char) NOT NULL,                                                          -- الاسم الظاهر للمستخدم النهائي
  Api        Varchar2(1024 Char),                                                                  -- الرابط
  Icon       Varchar2(100 Char),                                                                   -- الأيقونة
  Rem        Varchar2(100 Char),                                                                   -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date, 
  CONSTRAINT Notif_Table_Event_Action_PK       PRIMARY KEY (Id),
  CONSTRAINT Notif_Table_Event_Action_UK       UNIQUE      (TEvent_Id, Name),
  CONSTRAINT Notif_Table_Event_Action_Def_FK   Foreign Key (TEvent_Id) References Notif_Table_Eevnt(Id),
  CONSTRAINT Notif_Table_Event_Action_Field_FK Foreign Key (Field_Id ) References Notif_Table_Fld  (Id),
  CONSTRAINT Notif_Table_Event_Action_Ins_FK   Foreign Key (Ins_User ) References Cpy_User         (Id),
  CONSTRAINT Notif_Table_Event_Action_Upd_FK   Foreign Key (Upd_User ) References Cpy_User         (Id)
)
/
Create Synonym Notif_Table_Event_Action For Notif_Table_Event_Actions
/
----------------------------------------------------------------------------------------------------
Create Sequence Notif_Notif_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 CACHE 2;
Create Table Notif_Notification                                                                    -- جدول أحداث الإشعار
( Id           Number(20) NOT NULL,                                                                -- مفتاح رئيسي
  TEvent_Id    Number(9),                                                                          -- الرسالة
  User_Id      Number(5),                                                                          -- المستخدم المرسل له الإشعار
  DDate        Date Default Sysdate,                                                               -- تاريخ الإرسال
  RDate        Date,                                                                               -- تاريخ الاستقبال 
  SDate        Date,                                                                               -- تاريخ الرؤية
  Seen_Id      Number(1) Default 2,                                                                -- حالة الرؤية 
  RelId        Number(20),                                                                          -- المفتاح المرتبط
  Title        Varchar2(100 Char ) NOT NULL,                                                       -- العنوان
  Color        Varchar2(10  Char ) NOT NULL,                                                       -- اللون
  Icon         Varchar2(100 Char ) NOT NULL,                                                       -- الأيقونة
  Message      Varchar2(1024 Char) NOT NULL,                                                       -- الرسالة
  Rem          Varchar2(100 Char ),                                                                -- ملاحظات
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date, 
  CONSTRAINT Notif_Notif_PK       PRIMARY KEY (Id),
  CONSTRAINT Notif_Notif_Event_FK Foreign Key (TEvent_Id) References Notif_Table_Eevnt(Id),
  CONSTRAINT Notif_Notif_User_FK  Foreign Key (User_Id  ) References Cpy_User         (Id),
  CONSTRAINT Notif_Notif_Seen_FK  Foreign Key (Seen_Id  ) References Phs_Cod_YesNo    (Id),
  CONSTRAINT Notif_Notif_Ins_FK   Foreign Key (Ins_User ) References Cpy_User         (Id),
  CONSTRAINT Notif_Notif_Upd_FK   Foreign Key (Upd_User ) References Cpy_User         (Id)
)
/
Create Synonym Notif_Notif For Notif_Notification
/
----------------------------------------------------------------------------------------------------
