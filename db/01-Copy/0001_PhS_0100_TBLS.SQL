--set Pagesize 1000
--select 'Drop Table '   || table_name    || ';' from user_tables    where Table_name    like 'PHS%' ;
--select 'Drop Synonym ' || Synonym_name  || ';' from user_Synonyms  where Synonym_name  like 'PHS%' ;
--select 'Drop Sequence '|| Sequence_name || ';' from user_Sequences where Sequence_name like 'PHS%' ;
--select 'Drop View '    || View_name     || ';' from user_Views     where View_name     like 'PHS%' ;
----------------------------------------------------------------------------------------------------
Create Sequence PhsId_Seq  MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;

Create Table Phs_Code_Language                        -- جدول ترميز اللغات
( Id         Number(2) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  CONSTRAINT Phs_Code_Lang_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Code_Lang_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Lang For Phs_Code_Language
/
Insert into Phs_Cod_Lang (Id,Name) values (1,'Arabic' );
Insert into Phs_Cod_Lang (Id,Name) values (2,'English');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_System   		                         -- جدول ترميز الأنظمة
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_System_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_System_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_System For Phs_Code_System
/
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Special_Status    		          -- جدول حالات التخصيص
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  CONSTRAINT Phs_Cod_SpecStatus_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_SpecStatus_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_SpecStatus For Phs_Code_Special_Status
/
Insert into Phs_Cod_SpecStatus (Id,Name) values (-1,'Not IN');
Insert into Phs_Cod_SpecStatus (Id,Name) values (0 ,'NONE'  );
Insert into Phs_Cod_SpecStatus (Id,Name) values (1 ,'IN'    );
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Permission_Range                     -- جدول ترميز مجال الرؤية في الصلااحيات
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Perm_Range_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Perm_Range_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Perm_Range For Phs_Code_Permission_Range
/
Insert into Phs_Cod_Perm_Range (Id,Name) values (0,'As Group'     );
Insert into Phs_Cod_Perm_Range (Id,Name) values (1,'Only Themself');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Sign   		                           -- جدول ترميز الإشارة
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Sign_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Sign_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Sign For Phs_Code_Sign
/
Insert into Phs_Cod_Sign (Id,Name) values (-1,'Negative');
Insert into Phs_Cod_Sign (Id,Name) values (1 ,'Positive');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_DBCR   		                           -- جدول ترميز طبيعة الحساب
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_DBCR_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_DBCR_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_DBCR For Phs_Code_DBCR
/
Insert into Phs_Cod_DBCR (Id,Name) values (1,'Debit');
Insert into Phs_Cod_DBCR (Id,Name) values (2,'Credit');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Status    				                   -- جدول ترميز الحالات
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Status_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Status_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Status For Phs_Code_Status
/
Insert into Phs_Cod_Status (Id,Name) values (1,'Status.Active'  );
Insert into Phs_Cod_Status (Id,Name) values (2,'Status.Disabled');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_YesNo     				                   -- جدول ترميز نعم/لا   صح/خطأ
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_YesNo_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_YesNo_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_YesNo For Phs_Code_YesNo
/
Insert into Phs_Cod_YesNo (Id,Name) values (1,'Yes');
Insert into Phs_Cod_YesNo (Id,Name) values (2,'No');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Visible   				                   -- جدول ترميز الإظهار
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Visible_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Visible_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Visible For Phs_Code_Visible
/
Insert into Phs_Cod_Visible (Id,Name) values (0,'Hidden' );
Insert into Phs_Cod_Visible (Id,Name) values (1,'Visible');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Type    				                     -- جدول ترميز أنواع الحسابات أو فروع الشجرة
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Type_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Type_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Type For Phs_Code_Type
/
Insert into Phs_Cod_Type (Id,Name) values (1,'Type.Head');
Insert into Phs_Cod_Type (Id,Name) values (2,'Type.Active');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Gender    				                   -- جدول ترميز الجنس
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Gender_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Gender_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Gender For Phs_Code_Gender
/
Insert into Phs_Cod_Gender (Id,Name) values (1,'Male');
Insert into Phs_Cod_Gender (Id,Name) values (2,'Female');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Marital    				                   -- جدول ترميز الحالة الاجتماعية
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Marital_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Marital_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Marital For Phs_Code_Marital
/
Insert into Phs_Cod_Marital (Id,Name) values (1,'Single');
Insert into Phs_Cod_Marital (Id,Name) values (2,'Married');
Insert into Phs_Cod_Marital (Id,Name) values (3,'Widower');
Insert into Phs_Cod_Marital (Id,Name) values (4,'Divorce');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Source    				                   -- جدول ترميز أصل الحركة
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Src_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Src_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Src For Phs_Code_Source
/
Insert into Phs_Cod_Src (Id,Name) values (0,'Manual');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Amount_Type				                   -- جدول ترميز المبلغ
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Amount_Type_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Amount_Type_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_AmtType For Phs_Code_Amount_Type
/
Insert into Phs_Cod_AmtType (Id,Name) values (0,'-');
Insert into Phs_Cod_AmtType (Id,Name) values (1,'Percent');
Insert into Phs_Cod_AmtType (Id,Name) values (2,'Amount');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_UserGrp 				                     -- جدول ترميز صفة المستخدم
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_UGrp_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_UGrp_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_UGrp For Phs_Code_UserGrp
/
Insert into Phs_Cod_UGrp (Id,Name) values (-9,'GUEST' );
Insert into Phs_Cod_UGrp (Id,Name) values (-1,'Super' );
Insert into Phs_Cod_UGrp (Id,Name) values (0 ,'Admin' );
Insert into Phs_Cod_UGrp (Id,Name) values (1 ,'Normal');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Permission 				                   -- جدول ترميز الصلاحية
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Perm_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Perm_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Perm For Phs_Code_Permission
/
Insert into Phs_Cod_Perm (Id,Name) values (1,'Allow');
Insert into Phs_Cod_Perm (Id,Name) values (2,'Deny');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Direction 				                   -- جدول ترميز الاتجاه
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Dir_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Dir_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Dir For Phs_Code_Direction
/
Insert into Phs_Cod_Dir (Id,Name) values (1,'Left To Right');
Insert into Phs_Cod_Dir (Id,Name) values (2,'Right To Left');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Month    				                     -- جدول ترميز الأشهر
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Month_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Month_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Month For Phs_Code_Month
/
Insert into Phs_Cod_Month (Id,Name) values (1,'January');
Insert into Phs_Cod_Month (Id,Name) values (2,'February');
Insert into Phs_Cod_Month (Id,Name) values (3,'March');
Insert into Phs_Cod_Month (Id,Name) values (4,'April');
Insert into Phs_Cod_Month (Id,Name) values (5,'May');
Insert into Phs_Cod_Month (Id,Name) values (6,'June');
Insert into Phs_Cod_Month (Id,Name) values (7,'July');
Insert into Phs_Cod_Month (Id,Name) values (8,'August');
Insert into Phs_Cod_Month (Id,Name) values (9,'September');
Insert into Phs_Cod_Month (Id,Name) values (10,'October');
Insert into Phs_Cod_Month (Id,Name) values (11,'November');
Insert into Phs_Cod_Month (Id,Name) values (12,'December');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Week_Day 				                     -- جدول ترميز اليوم من الآسبوع
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_WDay_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_WDay_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_WDay For Phs_Code_Week_Day
/
Insert into Phs_Cod_WDay (Id,Name) values (1,'Sunday');
Insert into Phs_Cod_WDay (Id,Name) values (2,'Monday');
Insert into Phs_Cod_WDay (Id,Name) values (3,'Tuesday');
Insert into Phs_Cod_WDay (Id,Name) values (4,'Wednesday');
Insert into Phs_Cod_WDay (Id,Name) values (5,'Thursday');
Insert into Phs_Cod_WDay (Id,Name) values (6,'Friday');
Insert into Phs_Cod_WDay (Id,Name) values (7,'Saturday');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Commit_Status 		                   -- جدول ترميز حالة التثبيت
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Commit_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Commit_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Commit For Phs_Code_Commit_Status
/
Insert into Phs_Cod_Commit (Id,Name) values (0,'New');
Insert into Phs_Cod_Commit (Id,Name) values (1,'Committed');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Approve_Status 		                   -- جدول ترميز حالة الموافقة
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Approve_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Approve_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Approve For Phs_Code_Approve_Status
/
Insert into Phs_Cod_Approve (Id,Name) values (0,'New');
Insert into Phs_Cod_Approve (Id,Name) values (1,'Approved');
Insert into Phs_Cod_Approve (Id,Name) values (2,'Rejected');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Address_Type    				             -- جدول ترميز أنواع العناوين
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_AddressType_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_AddressType_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_AddressType For Phs_Code_Address_Type
/
Insert into Phs_Cod_AddressType (Id,Name) values (0,'Main');
Insert into Phs_Cod_AddressType (Id,Name) values (1,'Home');
Insert into Phs_Cod_AddressType (Id,Name) values (2,'Head Office');
Insert into Phs_Cod_AddressType (Id,Name) values (3,'Branch');
Insert into Phs_Cod_AddressType (Id,Name) values (5,'Other');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Military_Status		                   -- جدول ترميز حالة خدمة العلم
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_MilitaryStatus_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_MilitaryStatus_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Military For Phs_Code_Military_Status
/
Insert into Phs_Cod_Military (Id,Name) values (1,'Not Yet');
Insert into Phs_Cod_Military (Id,Name) values (2,'Done');
Insert into Phs_Cod_Military (Id,Name) values (3,'Exempted');
Insert into Phs_Cod_Military (Id,Name) values (4,'Delaied');
Insert into Phs_Cod_Military (Id,Name) values (5,'Under Age');
Insert into Phs_Cod_Military (Id,Name) values (6,'In Service');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Digits          	                   -- عدد الخانات
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_Digit_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_Digit_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_Digit For Phs_Code_Digits
/
Insert into Phs_Cod_Digit (Id,Name) values (0,'-');
Insert into Phs_Cod_Digit (Id,Name) values (1,'1');
Insert into Phs_Cod_Digit (Id,Name) values (2,'2');
Insert into Phs_Cod_Digit (Id,Name) values (3,'3');
Insert into Phs_Cod_Digit (Id,Name) values (4,'4');
Insert into Phs_Cod_Digit (Id,Name) values (5,'5');
Insert into Phs_Cod_Digit (Id,Name) values (6,'6');
Insert into Phs_Cod_Digit (Id,Name) values (7,'7');
Insert into Phs_Cod_Digit (Id,Name) values (8,'8');
Insert into Phs_Cod_Digit (Id,Name) values (9,'9');
Insert into Phs_Cod_Digit (Id,Name) values (10,'10');
Insert into Phs_Cod_Digit (Id,Name) values (11,'11');
Insert into Phs_Cod_Digit (Id,Name) values (12,'12');
Insert into Phs_Cod_Digit (Id,Name) values (13,'13');
Insert into Phs_Cod_Digit (Id,Name) values (14,'14');
Insert into Phs_Cod_Digit (Id,Name) values (15,'15');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Age_Days    				            -- جدول ترميز 
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  CONSTRAINT Phs_Cod_AgeDays_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_AgeDays_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_AgeDays For Phs_Code_Age_Days
/
Insert into Phs_Cod_AgeDays (Id,Name) values (0,'ALL');
Insert into Phs_Cod_AgeDays (Id,Name) values (1,'>120');
Insert into Phs_Cod_AgeDays (Id,Name) values (2,'91-120');
Insert into Phs_Cod_AgeDays (Id,Name) values (3,'61-90');
Insert into Phs_Cod_AgeDays (Id,Name) values (4,'31-60');
Insert into Phs_Cod_AgeDays (Id,Name) values (5,'0-30');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_IdType        		                   -- جدول ترميز أنواع الوثائق الشخصية
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Phs_Cod_IdType_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_IdType_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_IdType For Phs_Code_IdType
/
Insert into Phs_Cod_IdType (Id,Name) values (0,'-' );
Insert into Phs_Cod_IdType (Id,Name) values (1,'Id');
Insert into Phs_Cod_IdType (Id,Name) values (2,'Passport');
----------------------------------------------------------------------------------------------------
Create Sequence Phs_Lbl_Seq  MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Phs_Labels                               -- جدول أسماء الحقول والرسائل
( Id         Number(10) NOT NULL,				              -- مفتاح رئيسي
  Lang_Id    Number(2) Default 1,				              -- اللغة
  LKey       Varchar2(100 Char) NOT NULL,				      -- المفتاح
  LValue     Varchar2(256 Char) NOT NULL,				      -- القيمة
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  CONSTRAINT Phs_Lbl_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Lbl_UK UNIQUE      (Lang_Id, LKey)
)
/
Create Synonym Phs_Lbl For Phs_Labels
/
