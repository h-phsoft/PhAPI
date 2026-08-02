Create Table Phs_Privileges                           -- جدول أنواع الصلاحيات
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1 NOT NULL,            -- الحالة
  Name       Varchar2(50 Char) NOT NULL,              -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  CONSTRAINT PhsPrv_PK PRIMARY KEY (Id  ),
  CONSTRAINT PhsPrv_Nam_UK UNIQUE  (Name),
  CONSTRAINT PhsPrv_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id)
)
/
Create Synonym Phs_Priv For Phs_Privileges
/

Create Table Phs_Special_Privileges                   -- جدول أنواع الصلاحيات الخاصة
( Id            Number(20) NOT NULL,                  -- مفتاح رئيسي
  Status_Id     Number(1) Default 1 NOT NULL,         -- الحالة
  Name          Varchar2(50 Char) NOT NULL,           -- الاسم
  Related       Varchar2(50 Char) NOT NULL,           -- المفتاح الرئيسي الذي سيتم إضافته لجدول Cpy_TList
  Field         Varchar2(50 Char) NOT NULL,           -- الحقل الذي سيركب مفيه الشرط بحيث يكون ضمن الشرط مثال: Cat_Id IN (SELECT Rel_Id From Cpy_TList WHERE List_Id={listId})
  Pkg           Varchar2(50 Char) NOT NULL,           -- Pkg سيتم استخدامه في Autocomplete
  model         Varchar2(100 Char) NOT NULL,          -- model سيتم استخدامه في Autocomplete
  Rem           Varchar2(100 Char),                   -- ملاحظات
  CONSTRAINT    PhsSpecPrv_PK         PRIMARY KEY (Id  ),
  CONSTRAINT    PhsSpecPrv_Name_UK    UNIQUE      (Name),
  CONSTRAINT    PhsSpecPrv_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id)
)
/
Create Synonym Phs_SpecPriv For Phs_Special_Privileges
/

Create Table Phs_Code_Program_Type                    -- جدول أنواع القوائم
( Id         Number(2) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1 NOT NULL,            -- الحالة
  Name       Varchar2(50 Char) NOT NULL,              -- الاسم
  Icon       Varchar2(100 Char),                      -- الرمز
  Rem        Varchar2(100 Char),                      -- ملاحظات
  CONSTRAINT Phs_Cod_ProgType_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_ProgType_UK        UNIQUE      (Name),
  CONSTRAINT Phs_Cod_ProgType_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id)
)
/
Create Synonym Phs_Cod_PrgType For Phs_Code_Program_Type
/

Create Table Phs_Menus                                -- جدول قوائم الخيارات الرئيسة
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1 NOT NULL,            -- الحالة
  Name       Varchar2(50 Char) NOT NULL,              -- الاسم
  Image      Varchar2(256 Char),                      -- الرمز أو الصورة
  URL        Varchar2(256 Char),                      -- الرابط
  Descr      Varchar2(1024 Char),                     -- الوصف
  CONSTRAINT PhsMenu_PK        PRIMARY KEY (Id  ),
  CONSTRAINT PhsMenu_UK        UNIQUE      (Name),
  CONSTRAINT PhsMenu_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id)
)
/
Create Synonym Phs_Menu For Phs_Menus
/

Create Table Phs_Menu_Programs                        -- جدول برامج قوائم الخيارات
( Id           Number(20) NOT NULL,                   -- مفتاح رئيسي
  MPrg_Id      Number(20) Default 0 NOT NULL,         -- مفتاح الأب        
  Menu_Id      Number(5) Default 1 NOT NULL,          -- فئة البرنامج 1يوميات 2تقارير 3إدارة 4مساعدة
  Ord          Number(7) Default 0 NOT NULL,          -- ترتيب البرنامج ضمن الفئة
  Status_Id    Number(1) Default 1 NOT NULL,          -- حالة الخيار 1 فعال 2 غير فعال
  Type_Id      Number(2) Default 0 NOT NULL,          -- نوع البرنامج
  Name         Varchar2(100 Char) NOT NULL,           -- الاسم
  ApiURL       Varchar2(50 Char),                     -- المسار
  URL          Varchar2(50 Char),                     -- ملف الواجهة
  RelTable     Varchar2(30 Char),                     -- الجدول المرتبط
  Icon         Varchar2(50 Char),                     -- الرمز
  Params       Varchar2(1024),                        -- البارامترات الممكن إرسالها
  CONSTRAINT   PhsPrg_PK         PRIMARY KEY (Id),
  CONSTRAINT   PhsPrg_MIO_UK     UNIQUE      (Menu_Id,Ord),
  CONSTRAINT   PhsPrg_Mnu_FK     Foreign Key (Menu_Id  ) References Phs_Menu       (Id),
  CONSTRAINT   PhsPrg_Type_FK    Foreign Key (Type_Id  ) References Phs_Cod_PrgType(Id),
  CONSTRAINT   PhsPrg_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status (Id)
)
/
Create Synonym Phs_MPrg For Phs_Menu_Programs
/
Alter Table Phs_Menu_Programs Add
( CONSTRAINT PhsPrg_MPrg_FK Foreign Key (MPrg_Id) References Phs_MPrg(Id)
)
/

Create Table Phs_Programs_Privileges                  -- جدول بنود صلاحيات البرامج
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  MPrg_Id    Number(20) NOT NULL,                     -- البرنامج
  Prv_Id     Number(5) NOT NULL,                      -- الصلاحية
  Status_Id  Number(1) Default 1 NOT NULL,            -- حالة الخيار 1 فعال 2 غير فعال
  CONSTRAINT PhsPrgP_PK      PRIMARY KEY (Id),
  CONSTRAINT PhsPrgP_UK      UNIQUE      (MPrg_Id, Prv_Id),
  CONSTRAINT PhsPrgP_MPrg_FK Foreign Key (MPrg_Id) References Phs_MPrg(Id),
  CONSTRAINT PhsPrgP_Prv_FK  Foreign Key (Prv_Id ) References Phs_Priv(Id)
)
/
Create Synonym Phs_MPrgPriv For Phs_Programs_Privileges
/

Create Table Phs_Programs_SpecPrivileges              -- جدول بنود صلاحيات البرامج الخاصة
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  MPrg_Id    Number(20) NOT NULL,                     -- مفتاح الأب
  SPrv_Id    Number(20) NOT NULL,                     -- الصلاحية
  Status_Id  Number(1) Default 1 NOT NULL,            -- حالة الخيار 1 فعال 2 غير فعال
  Cond       Varchar2(4000 Char),                     -- الشرط
  CONSTRAINT PhsPrgSP_PK      PRIMARY KEY (Id),
  CONSTRAINT PhsPrgSP_UK      UNIQUE      (MPrg_Id, SPrv_Id),
  CONSTRAINT PhsPrgSP_MPrg_FK Foreign Key (MPrg_Id) References Phs_MPrg    (Id),
  CONSTRAINT PhsPrgSP_Prv_FK  Foreign Key (SPrv_Id) References Phs_SpecPriv(Id)
)
/
Create Synonym Phs_MPrgSPriv For Phs_Programs_SpecPrivileges
/
