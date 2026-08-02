Create Table Phs_Code_Field_Type   		                    -- جدول ترميز الأنظمة
( Id         Number(2) NOT NULL,				                  -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                  -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				          -- الاسم
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  CONSTRAINT Phs_Cod_FldType_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_FldType_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_FldType For Phs_Code_Field_Type
/
Insert Into Phs_Cod_FldType Values (0, 1, 'Text'        , NULL);
Insert Into Phs_Cod_FldType Values (1, 1, 'Select'      , NULL);
Insert Into Phs_Cod_FldType Values (2, 1, 'Autocomplete', NULL);
Insert Into Phs_Cod_FldType Values (3, 1, 'Date'        , NULL);
Insert Into Phs_Cod_FldType Values (4, 1, 'Integer'     , NULL);
Insert Into Phs_Cod_FldType Values (5, 1, 'Decimal'     , NULL);
Insert Into Phs_Cod_FldType Values (6, 1, 'Percent'     , NULL);
Insert Into Phs_Cod_FldType Values (7, 1, 'Folder'      , NULL);
Insert Into Phs_Cod_FldType Values (8, 1, 'File'        , NULL);
Insert Into Phs_Cod_FldType Values (9, 1, 'Image'       , NULL);
----------------------------------------------------------------------------------------------------
Create Sequence Phs_Pref_Struct_Seq  MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Phs_Preferences_Structure                    -- جدول بنية التفضيلات
( Id         Number(5) NOT NULL,				                  -- مفتاح رئيسي
  isPhs      Number(1) Default 1,                         -- تفضيلات نظام
  isCpy      Number(1) Default 0,                         -- تفضيلات نسخة
  isBran     Number(1) Default 0,                         -- تفضيلات فرع
  isUser     Number(1) Default 0,                         -- تفضيلات مستخدم
  isGetLabel Number(1) Default 0,                         -- حالة استخدام اللغة في عرض الاسم
  isVisible  Number(1) Default 0,                         -- حالة الإظهار
  isBetween  Number(1) Default 0,                         -- بين قيمتين
  FldType_Id Number(2) Default 0,                         -- نوع الحقل
  Menu_Id    Number(5) Default 0 NOT NULL,			          -- القائمة/Model
  Key        Varchar2(30 Char) NOT NULL,				          -- المفتاح
  Name       Varchar2(100 Char) NOT NULL,                 -- الاسم
  LovAPI     Varchar2(50 Char),        		                -- Autocomplete
  LovId      Varchar2(50 Char),		                        -- حقل المفتاح
  LovName    Varchar2(50 Char),		                        -- حقل الاسم
  LovTable   Varchar2(50 Char),                           -- الجدول
  LovWhere   Varchar2(50 Char),        		                -- الشرط
  DefValue1  Varchar2(100 Char),        				          -- القيمة 1
  DefValue2  Varchar2(100 Char),				                  -- القيمة 2
  Mask       Varchar2(100 Char),        				          -- Formtat Mask
  Rem        Varchar2(100 Char),				                  -- ملاحظات
  CONSTRAINT Phs_Pref_Struct_PK         PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Pref_Struct_UK         Unique      (Key ),
  CONSTRAINT Phs_Pref_Struct_Name_UK    Unique      (Name),
  CONSTRAINT Phs_Pref_Struct_FldType_FK Foreign Key (FldType_Id) References Phs_Cod_FldType(Id),
  CONSTRAINT Phs_Pref_Struct_Menu_FK    Foreign Key (Menu_Id   ) References Phs_Menu       (Id)
)
/
Create Synonym Phs_Pref_Struct For Phs_Preferences_Structure
/
----------------------------------------------------------------------------------------------------
Create Sequence Phs_Pref_Seq  MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Phs_Preferences			                        -- جدول التفضيلات
( Id      Number(5) NOT NULL,				                      -- مفتاح رئيسي
  Key     Varchar2(30 Char) NOT NULL,				              -- المفتاح
  Name    Varchar2(100 Char),				                      -- الاسم
  Value1  Varchar2(100 Char) NOT NULL,				            -- القيمة 1
  Value2  Varchar2(100 Char),				                      -- القيمة 2
  Rem     Varchar2(100 Char),				                      -- ملاحظات
  CONSTRAINT   Phs_Pref_PK      PRIMARY KEY (Id  ),
  CONSTRAINT   Phs_Pref_UK      Unique      (Key ),
  CONSTRAINT   Phs_Pref_Name_UK Unique      (Name)
)
/
Create Synonym Phs_Pref For Phs_Preferences
/
----------------------------------------------------------------------------------------------------
Create Table Phs_Themes	       		                        -- جدول قوالب الألوان
( Id      Number(5) NOT NULL,				                      -- مفتاح رئيسي
  Name    Varchar2(100 Char) NOT NULL,                    -- الاسم
  Css     Varchar2(100 Char) NOT NULL,                    -- الملف
  Rem     Varchar2(100 Char),				                      -- ملاحظات
  CONSTRAINT   Phs_Theme_PK PRIMARY KEY (Id  ),
  CONSTRAINT   Phs_Theme_UK Unique      (Name)
)
/
Create Synonym Phs_Theme For Phs_Themes
/
Insert into Phs_Theme (Id,Name,Css) values (0,'افتراضي','default');
Insert into Phs_Theme (Id,Name,Css) values (1,'سماوي' ,'cyan');
Insert into Phs_Theme (Id,Name,Css) values (2,'أزرق'  ,'blue');
Insert into Phs_Theme (Id,Name,Css) values (3,'أحمر'  ,'red');
----------------------------------------------------------------------------------------------------
Create Table Phs_Mode	       		                        -- جدول قوالب الألوان
( Id      Number(5) NOT NULL,				                      -- مفتاح رئيسي
  Name    Varchar2(100 Char) NOT NULL,                    -- الاسم
  Rem     Varchar2(100 Char),				                      -- ملاحظات
  CONSTRAINT   Phs_Mod_PK PRIMARY KEY (Id  ),
  CONSTRAINT   Phs_Mod_UK Unique      (Name)
)
/
Create Synonym Phs_Mod For Phs_Mode
/
Insert into Phs_Mod (Id,Name) values (0,'light');
Insert into Phs_Mod (Id,Name) values (1,'dark' );
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Dashboard_Type                  -- جدول أنماط لوحة التحكم
( Id         Number(9) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Phs_Cod_Dash_Type_PK         PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Dash_Type_UK         UNIQUE      (Name),
  CONSTRAINT Phs_Cod_Dash_Type_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id)
)
/
--Alter Table Phs_Code_Dashboard_Type Add CONSTRAINT Phs_Cod_Dash_Type_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id);
--Alter Table Phs_Code_Dashboard_Type Add CONSTRAINT Phs_Cod_Dash_Type_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id);
Create Synonym Phs_Cod_Dash_Type For Phs_Code_Dashboard_Type
/
Insert into Phs_Cod_Dash_type (Id,Name) values (0,'Block'   );
Insert into Phs_Cod_Dash_type (Id,Name) values (1,'Table'   );
Insert into Phs_Cod_Dash_type (Id,Name) values (2,'Chart'   );
Insert into Phs_Cod_Dash_type (Id,Name) values (3,'Calendar');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Dashboard_SubType               -- جدول أنواع الأنماط الفرعية
( Id         Number(9) NOT NULL,				              -- مفتاح رئيسي
  Mst_id     Number(9) NOT NULL,                      -- مفتاح النمط الرئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Phs_Cod_Dash_SubType_PK         PRIMARY KEY (Id),
  CONSTRAINT Phs_Cod_Dash_SubType_UK         UNIQUE      (Name, Mst_id),
  CONSTRAINT Phs_Cod_Dash_SubType_Mst_FK     Foreign Key (Mst_id)    References Phs_Cod_Dash_Type(Id),
  CONSTRAINT Phs_Cod_Dash_SubType_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status   (Id)  
)
/
--Alter Table Phs_Code_Dashboard_SubType Add CONSTRAINT Phs_Cod_Dash_SubType_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id);
--Alter Table Phs_Code_Dashboard_SubType Add CONSTRAINT Phs_Cod_Dash_SubType_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id);
Create Synonym Phs_Cod_Dash_SubType For Phs_Code_Dashboard_subtype
/
Insert into Phs_Cod_Dash_SubType (Id,Mst_id,Name) values (0  ,0,'Block'         );
Insert into Phs_Cod_Dash_SubType (Id,Mst_id,Name) values (101,1,'Table'         );
Insert into Phs_Cod_Dash_SubType (Id,Mst_id,Name) values (200,2,'Column'        );
Insert into Phs_Cod_Dash_SubType (Id,Mst_id,Name) values (201,2,'Line'          );
Insert into Phs_Cod_Dash_SubType (Id,Mst_id,Name) values (202,2,'Pie'           );
Insert into Phs_Cod_Dash_SubType (Id,Mst_id,Name) values (203,2,'Progress'      );
Insert into Phs_Cod_Dash_SubType (Id,Mst_id,Name) values (204,2,'Multi Progress');
Insert into Phs_Cod_Dash_SubType (Id,Mst_id,Name) values (301,3,'Calendar'      );
----------------------------------------------------------------------------------------------------
Create Sequence Phs_Dash_Blocks_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Phs_Dashboard_Blocks                     -- جدول توصيف لوحة التحكم
( Id            Number(9) NOT NULL,				            -- مفتاح رئيسي
  Ord           Number(5) Default 0,                  -- ترتيب الإظهار
  Name          Varchar2(100 Char),                   -- الاسم
  Type_Id       Number(9) NOT NULL,	                  -- النمط
  Menu_Id       Number(5) Default 0,                  -- لأي موديول يتبع البلوك
  Customize_Id  Number(1) Default 2,                  -- يوجد تخصيص أم لا
  Title         Varchar2(100 Char),                   -- العنوان
  Method        Varchar2(10 Char),                    -- نمط الاستدعاء
  Url           Varchar2(100 Char),                   -- رابط الكتلة
  Options       Varchar2(1024 Char),                  -- الخيارات الإفتراضية المرسلة للكتلة
  Duration      Number(5) Default 0,                  -- المدة الزمنية لإعادة الطلب
  MCol          Number(2) Default 3,                  -- عدد الأعمدة للرسم للكتلة الكلية
  SCol          Number(2) Default 3,                  -- عدد الأعمدة للرسم للكتلة الفرعية
  Rem           Varchar2(100 Char),          				  -- ملاحظات
  Ins_User      Number(5), Ins_Date     Date,
  Upd_User      Number(5), Upd_Date     Date,
  CONSTRAINT    Phs_Dash_Blocks_PK           PRIMARY KEY (Id),
  CONSTRAINT    Phs_Dash_Blocks_UK           UNIQUE      (Menu_Id, Name),
  CONSTRAINT    Phs_Dash_Blocks_Type_FK      Foreign Key (Type_Id     ) References Phs_Cod_Dash_SubType(Id),
  CONSTRAINT    Phs_Dash_Blocks_Menu_FK      Foreign Key (Menu_Id     ) References Phs_Menu            (Id),
  CONSTRAINT    Phs_Dash_Blocks_Customize_FK Foreign Key (Customize_Id) References Phs_Cod_YesNo       (Id)
)
/
--Alter Table Phs_Dashboard_Blocks Add CONSTRAINT Phs_Dash_Blocks_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id);
--Alter Table Phs_Dashboard_Blocks Add CONSTRAINT Phs_Dash_Blocks_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id);
Create Synonym Phs_Dash_Blocks For Phs_Dashboard_Blocks
/
----------------------------------------------------------------------------------------------------
