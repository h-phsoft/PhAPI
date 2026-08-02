Create Sequence CpyId_Seq     MinValue 1 Start With 1 MaxValue 99999999999999999999 CACHE 2;
Create Sequence Mst_Seq       MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1   CACHE 2;
Create Sequence Trn_Seq       MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1   CACHE 2;

Create Sequence Cpy_SList_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;
Create Table Copy_SpecialLists	                  -- جدول القوائم الخاصة
( Id         Number(5) NOT NULL,			            -- مفتاح رئيسي
  SPrv_Id    Number(20) NOT NULL,		              -- الصلاحية
  Name       Varchar2(100 Char) NOT NULL,			    -- اسم القائمة
  Rem        Varchar2(100 Char),			            -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT CpySList_PK          PRIMARY KEY (Id),
  CONSTRAINT CpySList_UK          UNIQUE      (SPrv_Id, Name),
  CONSTRAINT CpySList_SPrv_FK     Foreign Key (SPrv_Id ) References Phs_SpecPriv(Id)
)
/
Create Synonym Cpy_SList For Copy_SpecialLists
/
INSERT INTO Cpy_SList (Id, SPrv_Id, Name) VALUES (0, 0, '-');

Create Sequence Cpy_TList_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;
Create Table Copy_SpecialListsTrn                 -- جدول القوائم الخاصة
( Id         Number(5) NOT NULL,			            -- مفتاح رئيسي
  SList_Id   Number(5) NOT NULL,		              -- الصلاحية
  Rel_Id     Number(9) NOT NULL,		              -- المفتاح المرتبط
  Rem        Varchar2(100 Char),			            -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT CpyTList_PK           PRIMARY KEY (Id),
  CONSTRAINT CpyTList_UK           UNIQUE      (SList_Id, Rel_Id),
  CONSTRAINT CpyTList_SList_FK     Foreign Key (SList_Id) References Cpy_SList(Id)
)
/
Create Synonym Cpy_TList For Copy_SpecialListsTrn
/

Create Sequence Cpy_PGrp_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;
Create Table Copy_Permission_Groups			            -- جدول مجموعات الصلاحيات
( Id          Number(5) NOT NULL,                   -- مفتاح رئيسي
  PStatus_Id  Number(1)  Default 2,		              -- حالة فترة العمل
  Status_Id   Number(1) Default 1 NOT NULL,         -- حالة الخيار 1 فعال 2 غير فعال
  Name        Varchar2(30 Char) NOT NULL,			      -- اسم الفئة
  Rem         Varchar2(100 Char),			              -- ملاحظات
  Ins_User    Number(5),       Ins_Date Date,
  Upd_User    Number(5),       Upd_Date Date,
  CONSTRAINT  CpyPGrp_PK          PRIMARY KEY (Id  ),
  CONSTRAINT  CpyPGrp_Name_UK     UNIQUE      (Name),
  CONSTRAINT  CpyPGrp_PStatus_FK  Foreign Key (PStatus_Id) References Cpy_Cod_PStatus(Id),
  CONSTRAINT  CpyPGrp_Status_FK   Foreign Key (Status_Id ) References Phs_Cod_Status (Id)
)
/
Create Synonym Cpy_PGrp For Copy_Permission_Groups
/

Create Sequence Cpy_Perm_Seq MinValue 1 Start With 1 MaxValue 9999999999 CACHE 2;
Create Table Copy_Permision			                  -- جدول صلاحيات فئات المستخدمين
( Id         Number(10) NOT NULL,			            -- مفتاح رئيسي
  PGrp_Id    Number(5) Default 0,	                -- فئة المستخدمين
  MPrg_Id    Number(20) Default 0,	              -- البرنامج
  VPeriod    Number(4) Default 9999,	            -- الفترة
  IPeriod    Number(4) Default 9999,	            -- الفترة
  Range_Id   Number(1) Default 0,		              -- مجال الرؤية 0 ضمن المجموعة 1 يرى نفسه فقط
  OK         Number(1) Default 1,		              -- السماحية
  Ins_User   Number(5),       Ins_Date Date,
  Upd_User   Number(5),       Upd_Date Date,
  CONSTRAINT CpyPerm_PK       PRIMARY KEY (Id),
  CONSTRAINT CpyPerm_UK       UNIQUE      (PGrp_Id, MPrg_Id),
  CONSTRAINT CpyPerm_PGrp_FK  Foreign Key (PGrp_Id ) References Cpy_PGrp          (Id),
  CONSTRAINT CpyPerm_MPrg_FK  Foreign Key (MPrg_Id ) References Phs_MPrg          (Id),
  CONSTRAINT CpyPerm_Range_Fk Foreign Key (Range_Id) References Phs_Cod_Perm_Range(Id)
)
/
Create Synonym Cpy_Perm For Copy_Permision
/

Create Sequence Cpy_PermPriv_Seq MinValue 1 Start With 1 MaxValue 9999999999 CACHE 2;
Create Table Copy_Permision_Privileges		        -- جدول بنود صلاحيات فئات المستخدمين
( Id           Number(10) NOT NULL,			          -- مفتاح رئيسي
  Perm_Id      Number(10) NOT NULL,		            -- مفتاح الأب
  Prv_Id       Number(5) NOT NULL,		            -- الصلاحية
  OK           Number(1) Default 1,		            -- حالة الصلاحية
  Ins_User     Number(5),       Ins_Date Date,
  Upd_User     Number(5),       Upd_Date Date,
  CONSTRAINT   CpyPPrv_PK        PRIMARY KEY (Id),
  CONSTRAINT   CpyPPrv_UK        UNIQUE      (Perm_Id, Prv_Id),
  CONSTRAINT   CpyPPrv_MPrg_FK   Foreign Key (Perm_Id) References Cpy_Perm(Id),
  CONSTRAINT   CpyPPrv_Priv_FK   Foreign Key (Prv_Id ) References Phs_Priv(Id)
)
/
Create Synonym Cpy_PermPriv For Copy_Permision_Privileges
/

Create Sequence Cpy_PermSPriv_Seq MinValue 1 Start With 1 MaxValue 9999999999 CACHE 2;
Create Table Copy_Permision_SpecPrivileges		    -- جدول بنود صلاحيات فئات المستخدمين
( Id         Number(10) NOT NULL,			            -- مفتاح رئيسي
  Perm_Id    Number(10) NOT NULL,		              -- مفتاح الأب
  SPrv_Id    Number(20) NOT NULL,		              -- الصلاحية
  SList_Id   Number(5) NOT NULL,		              -- القائمة
  Status_Id  Number(1) Default 0,	                -- حالة التخصيص 0 غير مخصص(عام) / 1 الموجود في القائمة / -1 عدا الموجود في القائمة
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT CpyPSPrv_PK        PRIMARY KEY (Id),
  CONSTRAINT CpyPSPrv_UK        UNIQUE      (Perm_Id, SList_Id, Status_Id),
  CONSTRAINT CpyPSPrv_Perm_FK   Foreign Key (Perm_Id  ) References Cpy_Perm          (Id),
  CONSTRAINT CpyPSPrv_SPrv_FK   Foreign Key (SPrv_Id  ) References Phs_SpecPriv      (Id),
  CONSTRAINT CpyPSPrv_Status_FK Foreign Key (Status_Id) References Phs_Cod_SpecStatus(Id),
  CONSTRAINT CpyPSPrv_SList_FK  Foreign Key (SList_Id ) References Cpy_SList         (Id)
)
/
Create Synonym Cpy_PermSPriv For Copy_Permision_SpecPrivileges
/

Create Sequence Cpy_Dash_Perm_seq MinValue 1 Start With 1 MaxValue 9999999999 CACHE 2;
Create Table Copy_Dashboard_Permission		      -- جدول صلاحيات لوحة التحكم
( Id        	 Number(10) NOT NULL,			        -- مفتاح رئيسي
  PGrp_Id      Number(5) Default 0,	            -- فئة المستخدمين
  Dashboard_Id Number(5) NOT NULL,			        -- كتلة لوحة التحكم
  OK           Number(1) Default 1,		          -- السماحية
  CONSTRAINT   CpyDashPerm_PK      PRIMARY KEY (Id),
  CONSTRAINT   CpyDashPerm_UK      UNIQUE      (PGrp_Id, Dashboard_Id),
  CONSTRAINT   CpyDashPerm_PGrp_FK Foreign Key (PGrp_Id     ) References Cpy_PGrp       (Id),
  CONSTRAINT   CpyDashPerm_Dash_FK Foreign Key (Dashboard_Id) References Phs_Dash_Blocks(Id)
)
/
Create Synonym Cpy_Dash_Perm For Copy_Dashboard_Permission
/

Create Sequence Cpy_User_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;

Create Table Copy_Users                        -- جدول المستخدمين
( Id          Number(5) NOT NULL,              -- مفتاح رئيسي
  Bran_Id     Number(3) Default 0,             -- الفرع
  UGrp_Id     Number(1) Default 1,             -- فئة المستخدم
  PGrp_Id     Number(5) Default 1 NOT NULL,    -- مجموعة الصلاحيات
  Gender_Id   Number(1) Default 1 NOT NULL,    -- الجنس
  Status_Id   Number(1) Default 1 NOT NULL,    -- الحالة
  Verified_Id Number(1) Default 2 NOT NULL,    -- حالة التدقيق
  Logon       Varchar2(30 Char) NOT NULL,      -- اسم الدخول
  Pass        Varchar2(256 Char) NOT NULL,     -- كلمة المرور
  Name        Varchar2(200 Char) NOT NULL,     -- الأسم
  Picture     Varchar2(255 Char),              -- ملف الصورة
  Rem         Varchar2(200 Char),              -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  CpyUser_PK          PRIMARY KEY (Id    ),
  CONSTRAINT  CpyUser_Logon_UK    UNIQUE      (Logon ),
  CONSTRAINT  CpyUser_Name_UK     UNIQUE      (Name  ),
--CONSTRAINT  CpyUser_Bran_FK     Foreign Key (Bran_Id    ) References Cpy_Bran       (Id),
  CONSTRAINT  CpyUser_UGrp_FK     Foreign Key (UGrp_Id    ) References Phs_Cod_UGrp   (Id),
  CONSTRAINT  CpyUser_Gender_FK   Foreign Key (Gender_Id  ) References Phs_Cod_Gender (Id),
  CONSTRAINT  CpyUser_Status_FK   Foreign Key (Status_Id  ) References Phs_Cod_Status (Id),
  CONSTRAINT  CpyUser_Verified_FK Foreign Key (Verified_Id) References Phs_Cod_YesNo  (Id),
  CONSTRAINT  CpyUser_PGrp_FK     Foreign Key (PGrp_Id    ) References Cpy_PGrp       (Id)
)
/
Create Synonym Cpy_User For Copy_Users
/
Alter Table Copy_Users Add CONSTRAINT CpyUser_Bran_FK Foreign Key (Bran_Id) References Cpy_Bran(Id);

Create Sequence Cpy_SpecPerm_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;
Create Table Copy_SpecPermission	                -- جدول صلاحيات خاصة
( Id         Number(20) NOT NULL,			            -- مفتاح رئيسي
  Perm_Id    Number(20) NOT NULL,		              -- مفتاح الأب
  Rel_Id     Number(20) Default 0,			          -- المفتاح المرتبط
  Rem        Varchar2(250 Char),			            -- البيان
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT CpySpecPerm_PK       PRIMARY KEY (Id),
  CONSTRAINT CpySpecPerm_UK       UNIQUE      (Perm_Id, Rel_Id),
  CONSTRAINT CpySpecPerm_Perm_FK  Foreign Key (Perm_Id) References Cpy_Perm(Id)
)
/
Create Synonym Cpy_SpecPerm For Copy_SpecPermission
/

Create Sequence CpyToken_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 CACHE 2;
Create Table Copy_Tokens			                                  -- جدول أرقام جلسات الاتصال
( Id           Number(20) NOT NULL,			                        -- مفتاح رئيسي
  GId          Varchar2(50 Char) Default Sys_GUID() NOT NULL,		-- المفتاح
  CFront_Id    Number(2) Default 0 NOT NULL,	                  -- واجهة النسخة
  User_Id      Number(5) Default 0 NOT NULL,			              -- المستخدم
  Period_Id    Number(4) Default 0 NOT NULL,			              -- الفترة المالية
  Status       Number(5) Default 1 NOT NULL,	                  -- الحالة 1 فعال - 2 غير فعال - 3 ملغى
  SDate        Date Default sysdate NOT NULL,                   -- تاريخ ووقت بداية الجلسة
  EDate        Date Default (sysdate+1) NOT NULL,               -- تاريخ ووقت نهاية الجلسة
  ADate        Date Default sysdate NOT NULL,                   -- تاريخ ووقت آخر نشاط
  Gender       Number(1),                                       -- الجنس
  PGrp         Number(5),                                       -- مجموعة الصلاحيات
  Role         Number(1),                                       -- فئة المستخدم
  Copy         Varchar2(25 Char),                               -- النسخة
  Name         Varchar2(100 Char),                              -- الاسم
  Login        Varchar2(100 Char),                              -- اسم الدخول
  Picture      Varchar2(100 Char),                              -- الصورة
  PvKey        Varchar2(3072 Char),                             -- Private Key
  PbKey        Varchar2(3072 Char),                             -- Publice Key
  vIP          Varchar2(100 Char),                              -- IP
  vPort        Varchar2(100 Char),                              -- Port
  vHost        Varchar2(100 Char),                              -- Host
  CONSTRAINT   CpyToken_PK       PRIMARY KEY (Id ),
  CONSTRAINT   CpyToken_Token_UK UNIQUE      (GId),
  CONSTRAINT   CpyToken_User_FK  Foreign Key (User_Id) References Cpy_User(Id)
)
/
Create Synonym Cpy_Token For Copy_Tokens
/

Create Sequence Cpy_UDevice_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Copy_User_Devices                           -- دليل أجهزة مستخدم
( Id         Number(10) NOT NULL,                     -- مفتاح رئيسي
  User_Id    Number(5) NOT NULL,                      -- المستخدم المرتبط
  Serial     Varchar2(100 Char) NOT NULL,             -- الرقم التسلسلي للجهاز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  OS         Varchar2(100 Char) NOT NULL,             -- نظام التشغيل
  Token      Varchar2(512 Char) NOT NULL,             -- Token
  Ins_Date   Date Default sysdate,
  CONSTRAINT Cpy_UDevice_PK      PRIMARY KEY (Id),
  CONSTRAINT Cpy_UDevice_UK      UNIQUE      (User_Id, Serial),
  CONSTRAINT Cpy_UDevice_User_FK Foreign Key (User_Id) References Cpy_User(Id)
)
/
Create Synonym Cpy_UDevice For Copy_User_Devices
/

Create Sequence Cpy_RCode_Seq MinValue 1 Start With 1 MaxValue 999999999999999999999999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Copy_Reset_Codes                         -- دليل أكواد استرجاع كلمة المرور
( Id         Number(30) NOT NULL,                     -- مفتاح رئيسي
  User_Id    Number(5) NOT NULL,                      -- المستخدم
  Code       Varchar2(6 Char),          				      -- الرمز
  Ins_Date   Date Default Sysdate,
  CONSTRAINT Cpy_RCode_PK      PRIMARY KEY (Id),
  CONSTRAINT Cpy_RCode_User_FK Foreign Key (User_Id) References Cpy_User(Id)
)
/
Create Synonym Cpy_RCode For Copy_Reset_Codes
/

Create Sequence Cpy_Cod_Notif_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2
/
Create Table Copy_Cod_Notif
(
  Id           Number(5)          NOT NULL,
  Status_Id    Number(1)          Default 1 NOT NULL,
  Code         Varchar2(50 Char)  NOT NULL,
  IName        Varchar2(100 Char) NOT NULL, -- English Name
  LName        Varchar2(100 Char) NOT NULL, -- Arabic Name
  Rem          Varchar2(100 Char),
  Ins_User     Number(5),         Ins_Date Date,
  Upd_User     Number(5),         Upd_Date Date,
  
  CONSTRAINT Cpy_Cod_Notif_PK        PRIMARY KEY (Id),
  CONSTRAINT Cpy_Cod_Notif_Code_UK   UNIQUE (Code),
  CONSTRAINT Cpy_Cod_Notif_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Cod_Notif_Ins_FK    Foreign Key (Ins_User)  References Cpy_User(Id),
  CONSTRAINT Cpy_Cod_Notif_Upd_FK    Foreign Key (Upd_User)  References Cpy_User(Id)
)
/
Create Synonym Cpy_Cod_Notifs For Copy_Cod_Notif
/

-- 3. Recreate Per-User Notification Preferences Table
Create Sequence Cpy_User_Notif_Pref_Seq MinValue 1 Start With 1 MaxValue 99999999 INCREMENT BY 1 CACHE 2
/
Create Table Copy_User_Notification_Pref
(
  Id             Number(10)     NOT NULL,
  User_Id        Number(5)      NOT NULL,
  Notif_Id       Number(5)      NOT NULL,
  Status_Id      Number(1)      Default 1 NOT NULL,
  Rem            Varchar2(255 Char),
  Ins_User       Number(5),     Ins_Date Date,
  Upd_User       Number(5),     Upd_Date Date,
  
  CONSTRAINT Cpy_User_Notif_Pref_PK     PRIMARY KEY (Id),
  CONSTRAINT Cpy_User_Notif_Pref_UK     UNIQUE (User_Id, Notif_Id),
  CONSTRAINT Cpy_User_Notif_User_FK     Foreign Key (User_Id)   References Cpy_User(Id),
  CONSTRAINT Cpy_User_Notif_Status_FK   Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_User_Notif_Notif_FK    Foreign Key (Notif_Id)  References Cpy_Cod_Notifs(Id),
  CONSTRAINT Cpy_User_Notif_Ins_FK      Foreign Key (Ins_User)  References Cpy_User(Id),
  CONSTRAINT Cpy_User_Notif_Upd_FK      Foreign Key (Upd_User)  References Cpy_User(Id)
)
/
Create Synonym Cpy_User_Notif For Copy_User_Notification_Pref
/