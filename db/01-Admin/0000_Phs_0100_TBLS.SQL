Create Sequence PhsId_Seq  MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;

Create Table Phs_Code_Status    				                            -- جدول ترميز الحالات
( Id            Number(1) NOT NULL,				                          -- مفتاح رئيسي
  Name          Varchar2(100 Char) NOT NULL,				                -- الاسم
  Rem           Varchar2(100 Char),          				                -- ملاحظات
  CONSTRAINT    PhsCodStatus_PK PRIMARY KEY (Id  ),
  CONSTRAINT    PhsCodStatus_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Status For Phs_Code_Status
/

Create Table Phs_Frontend                                           -- جدول واجهات التخاطب
( Id            Number(20) NOT NULL,                                -- مفتاح رئيسي
  GId           Varchar2(50 Char) Default Sys_GUID() NOT NULL,      -- المفتاح الوحيد
  Status_Id     Number(1) Default 1 NOT NULL,                       -- الحالة 1 فعال - 2 غير فعال - 3 ملغى
  FDate         Date NOT NULL,                                      -- التاريخ
  Name          Varchar2(100 Char) NOT NULL,                        -- الاسم
  Logo          Varchar2(100 Char),                                 -- ملف الشعار
  Rem           Varchar2(200 Char),                                 -- ملاحظات
  CONSTRAINT    PhsFront_PK        PRIMARY KEY (Id  ),
  CONSTRAINT    PhsFront_GID       UNIQUE      (GId ),
  CONSTRAINT    PhsFront_Name_UK   UNIQUE      (Name),
  CONSTRAINT    PhsFront_Status_FK Foreign Key (status_Id) References Phs_Status(Id)
)
/
Create Synonym Phs_Front For Phs_Frontend
/

Create Table Phs_Customers         			                            -- جدول الزبائن
( Id            Number(20) NOT NULL,	  	                          -- مفتاح رئيسي
  GId           Varchar2(50 Char) Default Sys_GUID() NOT NULL,		  -- المفتاح الوحيد
  Status_Id     Number(1) Default 1 NOT NULL,                       -- الحالة 1 فعال - 2 غير فعال - 3 ملغى
  CDate         Date NOT NULL,                                      -- التاريخ
  Name          Varchar2(100 Char) NOT NULL,		  	                -- الاسم
  Rem           Varchar2(200 Char),		                              -- ملاحظات
  CONSTRAINT    PhsCst_PK        PRIMARY KEY (Id  ),
  CONSTRAINT    PhsCst_GID       UNIQUE      (GId ),
  CONSTRAINT    PhsCst_UK        UNIQUE      (Name),
  CONSTRAINT    PhsCst_Status_FK Foreign Key (status_Id) References Phs_Status(Id)
)
/
Create Synonym Phs_Cst For Phs_Customers
/

Create Table Phs_Copy	            			                            -- جدول النسخ
( Id            Number(20) NOT NULL,	  	                          -- مفتاح رئيسي
  GId           Varchar2(50 Char) Default Sys_GUID() NOT NULL,		  -- المفتاح الوحيد
  Cst_Id        Number(20) Default 0 NOT NULL,	                    -- الزبون
  Status_Id     Number(1) Default 1 NOT NULL,                       -- الحالة 1 فعال - 2 غير فعال - 3 ملغى
  CDate         Date NOT NULL,                                      -- تاريخ الإضافة
  EDate         Date NOT NULL,                                      -- تاريخ الانتهاء
  Name          Varchar2(100 Char) NOT NULL,		  	                -- الاسم
  URL           Varchar2(100 Char) NOT NULL,		  	                -- المسار
  OUser         Varchar2(100 Char) NOT NULL,		  	                -- مستخدم أوراكل
  OPass         Varchar2(100 Char) NOT NULL,		  	                -- كلمة مرور أوراكل
  Logo          Varchar2(100 Char),			                            -- مسار واسم ملف الشعار
  Theme         Varchar2(50 Char),			                            -- اسم نموذج الألوان الخاص بالنسخة
  LoginBG       Varchar2(512 Char) Default 'erp000.jpg',            -- خلفية واجهة الدخول
  ImgPath       Varchar2(512 Char),			                            -- مسار ملفات الصور
  Rem           Varchar2(200 Char),		                              -- ملاحظات
  CONSTRAINT    PhsCpy_PK        PRIMARY KEY (Id ),
  CONSTRAINT    PhsCpy_GID       UNIQUE      (GId),
  CONSTRAINT    PhsCpy_URL_UK    UNIQUE      (URL),
  CONSTRAINT    PhsCpy_Name_UK   UNIQUE      (Cst_Id, Name),
  CONSTRAINT    PhsCpy_Cst_FK    Foreign Key (Cst_Id   ) References Phs_Cst   (Id),
  CONSTRAINT    PhsCpy_Status_FK Foreign Key (status_Id) References Phs_Status(Id)
)
/
Create Synonym Phs_Cpy For Phs_Copy
/

Create Table Phs_Copy_Frontend          			                    -- جدول واجهات تخاطب النسخ
( Id            Number(20) NOT NULL,	                            -- مفتاح رئيسي
  GId           Varchar2(50 Char) Default Sys_GUID() NOT NULL,		-- مفتاح التطبيق
  Cpy_Id        Number(20) Default 0 NOT NULL,                    -- النسخة
  Front_Id      Number(20) Default 1 NOT NULL,                    -- الواجهة
  Status_Id     Number(1) Default 1 NOT NULL,                     -- الحالة 1 فعال - 2 غير فعال - 3 ملغى
  CDate         Date NOT NULL,                                    -- التاريخ
  Rem           Varchar2(200 Char),		                            -- ملاحظات
  CONSTRAINT    PhsCpyFront_PK        PRIMARY KEY (Id ),
  CONSTRAINT    PhsCpyFront_GID       UNIQUE      (GId),
  CONSTRAINT    PhsCpyFront_UK        UNIQUE      (Cpy_Id, Front_Id),
  CONSTRAINT    PhsCpyFront_Cpy_FK    Foreign Key (Cpy_Id   ) References Phs_Cpy   (Id),
  CONSTRAINT    PhsCpyFront_Front_FK  Foreign Key (Front_Id ) References Phs_Front (Id),
  CONSTRAINT    PhsCpyFront_Status_FK Foreign Key (status_Id) References Phs_Status(Id)
)
/
Create Synonym Phs_CpyFront For Phs_Copy_Frontend
/
