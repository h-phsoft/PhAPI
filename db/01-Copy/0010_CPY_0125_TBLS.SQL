Create Sequence Cpy_Period_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Periods				                      -- جدول فترات العمل
( Id         Number(4) NOT NULL,			              -- مفتاح رئيسي
  Num        Number(4) Default 1,			              -- الرقم
  Status_Id  Number(1) Default 1,			              -- الحالة
  SDate      Date NOT NULL,	                        -- تاريخ البداية
  EDate      Date NOT NULL,	                        -- تاريخ النهاية
  Name       Varchar2(100 Char) NOT NULL,            -- الاسم
  Rem        Varchar2(250 Char),			                -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Cpy_Period_PK        PRIMARY KEY (Id ),
  CONSTRAINT Cpy_Period_UK        UNIQUE      (Num ),
  CONSTRAINT Cpy_Period_Name_UK   UNIQUE      (Name),
  CONSTRAINT Cpy_Period_SEDate_UK UNIQUE      (SDate,EDate),
  CONSTRAINT Cpy_Period_Status_FK Foreign Key (Status_Id) References Cpy_Cod_PStatus(Id),
  CONSTRAINT Cpy_Period_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Cpy_Period_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Cpy_Period For Copy_Periods
/
------------------------------------------------------------------------------------------------------
Create Sequence Cpy_Bran_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Branches		                        -- دليل الفروع
( Id         Number(3) NOT NULL,		                -- مفتاح رئيسي
  Num        Number(3) NOT NULL,                    -- رقم
  Day1       Number(1) Default 1,	                  -- دوام يوم الأحد
  Day2       Number(1) Default 1,	                  -- دوام يوم الاثنين
  Day3       Number(1) Default 1,	                  -- دوام يوم الثلاثاء
  Day4       Number(1) Default 1,	                  -- دوام يوم الأربعاء
  Day5       Number(1) Default 1,	                  -- دوام يوم الخميس
  Day6       Number(1) Default 1,	                  -- دوام يوم الجمعة
  Day7       Number(1) Default 1,	                  -- دوام يوم السبت
  Status_Id  Number(1) Default 1,			              -- الحالة
  Curn_Id    Number(3) Default 1,                  -- العملة
  Cost_Id    Number(9) Default 0,                  -- مركز الكلفة الإفتراضي
  Name       Varchar2(100 Char) NOT NULL,           -- الاسم
  Rem        Varchar2(250 Char),	                  -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Cpy_Bran_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Bran_Num_UK    Unique      (Num ),
  CONSTRAINT Cpy_Bran_Name_UK   Unique      (Name),
  CONSTRAINT Cpy_Bran_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Bran_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Bran_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Bran For Copy_Branches
/
Alter Table Copy_Users Add CONSTRAINT CpyUser_Bran_FK Foreign Key (Bran_Id) References Cpy_Bran(Id);
------------------------------------------------------------------------------------------------------
Create Sequence Cpy_Pref_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Preferences			                    -- جدول التفضيلات
( Id         Number(5) NOT NULL,				            -- مفتاح رئيسي
  Key        Varchar2(30 Char) NOT NULL,				    -- المفتاح
  Visible_Id Number(1) Default 1,			              -- حالة الإظهار 1 ظاهر \ 0 مخفي
  Name       Varchar2(100 Char) NOT NULL,				    -- الاسم
  Value1     Varchar2(1024 Char) NOT NULL,				  -- القيمة 1
  Value2     Varchar2(1024 Char),             		  -- القيمة 2
  Rem        Varchar2(100 Char),				            -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Cpy_Pref_PK         PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Pref_UK         Unique      (Key ),
  CONSTRAINT Cpy_Pref_Name_UK    Unique      (Name),
  CONSTRAINT Cpy_Pref_Visible_FK Foreign Key (Visible_Id) References Phs_Cod_Visible(Id),
  CONSTRAINT Cpy_Pref_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT Cpy_Pref_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Cpy_Pref For Copy_Preferences
/
------------------------------------------------------------------------------------------------------
Create Sequence Cpy_BPref_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Branche_Preferences   			        -- جدول القيم الإفتراضية للفرع INI
( Id         Number(5) NOT NULL,				            -- مفتاح رئيسي
  Bran_Id    Number(3) NOT NULL,				            -- مفتاح الاب
  Visible_Id Number(1) NOT NULL,				            -- نوع الإظهار \ 1 مرئي \ 0 مخفي
  Key        Varchar2(30 Char) NOT NULL,				    -- مفتاح القيمة
  Name       Varchar2(100 Char),			              -- الاسم
  Value1     Varchar2(1024 Char),			              -- القيمة 1
  Value2     Varchar2(1024 Char),			              -- القيمة 2
  Rem        Varchar2(250 Char),			              -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Cpy_BPrefs_PK         PRIMARY KEY (Id),
  CONSTRAINT Cpy_BPrefs_UK         Unique      (Bran_Id, Key),
  CONSTRAINT Cpy_BPrefs_Bran_FK    Foreign Key (Bran_Id   ) References Cpy_Bran       (Id),
  CONSTRAINT Cpy_BPrefs_Visible_FK Foreign Key (Visible_Id) References Phs_Cod_Visible(Id),
  CONSTRAINT Cpy_BPrefs_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT Cpy_BPrefs_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Cpy_BPref For Copy_Branche_Preferences
/
------------------------------------------------------------------------------------------------------
Create Sequence Cpy_UPref_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_User_Preferences			              -- جدول القيم الإفتراضية للمستخدم INI
( Id         Number(5) NOT NULL,				            -- مفتاح رئيسي
  User_Id    Number(5) NOT NULL,				            -- مفتاح الاب
  Visible_Id Number(1) NOT NULL,				            -- نوع الإظهار \ 1 مرئي \ 0 مخفي
  Key        Varchar2(30 Char) NOT NULL,				    -- مفتاح القيمة
  Name       Varchar2(100 Char) NOT NULL,			      -- الاسم
  Value1     Varchar2(1024 Char) NOT NULL,			    -- القيمة 1
  Value2     Varchar2(1024 Char),         			    -- القيمة 2
  Rem        Varchar2(250 Char),			              -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Cpy_UPrefs_PK         PRIMARY KEY (Id),
  CONSTRAINT Cpy_UPrefs_UK         Unique      (User_Id, Key),
  CONSTRAINT Cpy_UPrefs_User_FK    Foreign Key (User_Id   ) References Cpy_User       (Id),
  CONSTRAINT Cpy_UPrefs_Visible_FK Foreign Key (Visible_Id) References Phs_Cod_Visible(Id),
  CONSTRAINT Cpy_UPrefs_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT Cpy_UPrefs_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Cpy_UPref For Copy_User_Preferences
/
------------------------------------------------------------------------------------------------------
Create Sequence Cpy_Attach_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Attached_Files  					        -- الملفات المرفقة
( Id         Number(20) NOT NULL,					          -- مفتاح رئيسي
  FDate      Date NOT NULL,							            -- التاريخ و الوقت
  User_Id    Number(5),                             -- المستخدم
  MPrg_Id    Number(20),        						        -- مفتاح الواجهة
  RId        Number(20),        						        -- مفتاح مرتبط
  BlockName  Varchar2(50 Char),					            -- اسم الكتلة
  Name       Varchar2(100 Char),					          -- الاسم
  FType      Varchar2(256 Char),					          -- نوع الملف
  Ext        Varchar2(50 Char),					            -- امتداد الملف
  OName      Varchar2(100 Char),					          -- الاسم الأصلي
  NName      Varchar2(100 Char),					          -- الاسم الجديد مع المسار
  Rem        Varchar2(250 Char),					          -- البيان
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Cpy_Attach_PK      PRIMARY KEY (Id),
  CONSTRAINT Cpy_Attach_User_Fk Foreign Key (User_Id ) References Cpy_User(Id),
  CONSTRAINT Cpy_Attach_Mprg_Fk Foreign Key (MPrg_Id ) References Phs_MPrg(Id),
  CONSTRAINT Cpy_Attach_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Cpy_Attach_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Cpy_Attach For Copy_Attached_Files
/
------------------------------------------------------------------------------------------------------
Create Sequence Cpy_UDBoard_List_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Copy_User_Dashboard_List			                 -- جدول القوائم   
( Id         Number(10) NOT NULL,				                   -- مفتاح رئيسي
  User_Id    Number(5)  NOT NULL,			                     -- المستخدم
  Status_Id  Number(1) Default 1 NOT NULL,                 -- الحالة  
  Name       Varchar2(100 Char),			                     -- الاسم
  Rem        Varchar2(250 Char),			                     -- ملاحظات  
  Ins_User   Number(5), Ins_Date    Date,
  Upd_User   Number(5), Upd_Date    Date,
  CONSTRAINT Cpy_UDBoard_List_List_PK        PRIMARY KEY (Id),
  CONSTRAINT Cpy_UDBoard_List_List_FK        Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT Cpy_UDBoard_List_List_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id)
)
/
Create Synonym Cpy_UDBoard_List For Copy_User_Dashboard_List
/
------------------------------------------------------------------------------------------------------
Create Sequence Cpy_UDBoard_List_Blks_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Copy_User_Dashboard_List_Blocks			         -- جدول تخصيص القوائم   
( Id         Number(20) NOT NULL,				                   -- مفتاح رئيسي
  List_Id    Number(10) NOT NULL,			                     -- مفتاح القائمة 
  Block_Id   Number(9)  NOT NULL,                          -- الكتلة
  Status_Id  Number(1)  Default 1 NOT NULL,                -- الحالة      
  Width      Number(2),			                               -- العرض
  Ord        Number(5) Default 0,                          -- الترتيب
  Rem        Varchar2(250 Char),			                     -- ملاحظات  
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_UDBoard_List_Blks_PK        PRIMARY KEY (Id),
  CONSTRAINT Cpy_UDBoard_List_Blks_FK        Foreign Key (List_Id  ) References Cpy_UDBoard_List(Id),
  CONSTRAINT Cpy_UDBoard_List_Blks_Block_FK  Foreign Key (Block_Id ) References Phs_Dash_Blocks (Id),
  CONSTRAINT Cpy_UDBoard_List_Blks_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status  (Id)
)
/
Create Synonym Cpy_UDBoard_List_Blks For Copy_User_Dashboard_List_Blocks
/
