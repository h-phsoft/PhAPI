--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'EMP%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'EMP%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'EMP%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'EMP%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'EMP%' ;
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_CalcSalary                      -- جدول ترميز حالة احتساب الراتب
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_CalcSal_PK PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_CalcSal_UK UNIQUE      (Name),
  CONSTRAINT Emp_Cod_CalcSal_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_CalcSal_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_CalcSal For Emp_Code_CalcSalary
/
Insert into Emp_Cod_CalcSal (Id,Name) values (0,'قيد التحضير');
Insert into Emp_Cod_CalcSal (Id,Name) values (1,'محتسب');
Insert into Emp_Cod_CalcSal (Id,Name) values (2,'مثبت');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Status_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Status                          -- جدول ترميز حالة العامل
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Status For Emp_Code_Status
/
Insert into Emp_Cod_Status (Id,Name) values (1,'عادي');
Insert into Emp_Cod_Status (Id,Name) values (2,'مستقيل');
Insert into Emp_Cod_Status (Id,Name) values (3,'متوفى');
Insert into Emp_Cod_Status (Id,Name) values (4,'فصل');
Insert into Emp_Cod_Status (Id,Name) values (5,'طرد');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_Attend_Type                     -- جدول ترميز نوع حركة الدوام
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_AttType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_AttType_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_AttType_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_AttType_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_AttType For Emp_Code_Attend_Type
/
Insert into Emp_Cod_AttType (Id,Name) values (1,'دخول');
Insert into Emp_Cod_AttType (Id,Name) values (2,'خروج');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_Affected_Salary                 -- جدول ترميز الراتب المستهدف
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_AffSal_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_AffSal_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_AffSal_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_AffSal_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_AffSal For Emp_Code_Affected_Salary
/
Insert into Emp_Cod_AffSal (Id,Name) values (1,'الراتب المقطوع' );
Insert into Emp_Cod_AffSal (Id,Name) values (2,'الراتب التأميني');
Insert into Emp_Cod_AffSal (Id,Name) values (3,'الراتب الضريبي' );
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_Affected                        -- جدول ترميز الكشف المستهدف
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Aff_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Aff_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Aff_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Aff_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Aff For Emp_Code_Affected
/
Insert into Emp_Cod_Aff (Id,Name) values (1,'الراتب');
Insert into Emp_Cod_Aff (Id,Name) values (2,'الإضافي');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_Change_Type                     -- جدول ترميز نمط التعديل
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_ChngType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_ChngType_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_ChngType_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_ChngType_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_ChngType For Emp_Code_Change_Type
/
Insert into Emp_Cod_ChngType (Id,Name) values (1,'نسبة');
Insert into Emp_Cod_ChngType (Id,Name) values (2,'مبلغ');
Insert into Emp_Cod_ChngType (Id,Name) values (3,'مبلغ ثم نسبة');
Insert into Emp_Cod_ChngType (Id,Name) values (4,'نسبة ثم مبلغ');
Insert into Emp_Cod_ChngType (Id,Name) values (5,'حسب الشرائح');
Insert into Emp_Cod_ChngType (Id,Name) values (6,'مبلغ لكل عامل');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_Wgrp_Shift                      -- جدول ترميز فترات الدوام ضمن الوردية
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Wgrp_Shift_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Wgrp_Shift_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Wgrp_Shift_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Wgrp_Shift_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Wgrp_Shift For Emp_Code_Wgrp_Shift
/
Insert into Emp_Cod_Wgrp_Shift (Id,Name) values (1,'1 Shift');
Insert into Emp_Cod_Wgrp_Shift (Id,Name) values (2,'2 Shifts');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_Overtime                        -- جدول ترميز الإضافي
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Overtime_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Overtime_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Overtime_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Overtime_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Overtime For Emp_Code_Overtime
/
Insert into Emp_Cod_Overtime (Id,Name) values (0,'دون إضافي');
Insert into Emp_Cod_Overtime (Id,Name) values (1,'نهاري');
Insert into Emp_Cod_Overtime (Id,Name) values (2,'ليلي');
Insert into Emp_Cod_Overtime (Id,Name) values (3,'عطلة');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_Com_Per                         -- جدول ترميز حالة تعويض الوردية
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Com_Per_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Com_Per_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Com_Per_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Com_Per_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Com_Per For Emp_Code_Com_Per
/
Insert into Emp_Cod_Com_Per (Id,Name) values (0,'دون تعويض');
Insert into Emp_Cod_Com_Per (Id,Name) values (1,'لكل يوم');
Insert into Emp_Cod_Com_Per (Id,Name) values (2,'مرة في الشهر');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_WGrp_Type                       -- جدول ترميز أنواع الورديات
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_WGrp_Type_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_WGrp_Type_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_WGrp_Type_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_WGrp_Type_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_WGrp_Type For Emp_Code_WGrp_Type
/
Insert into Emp_Cod_WGrp_Type (Id,Name) values (1,'يومي');
Insert into Emp_Cod_WGrp_Type (Id,Name) values (2,'اسبوعية');
Insert into Emp_Cod_WGrp_Type (Id,Name) values (3,'شهرية');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_Leave                           -- جدول ترميز الإجازات
( Id         Number(3) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Leave_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Leave_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Leave_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Leave_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Leave For Emp_Code_Leave
/
Insert into Emp_Cod_Leave (Id,Name) values (100,'إدارية');
Insert into Emp_Cod_Leave (Id,Name) values (110,'طارئة');
Insert into Emp_Cod_Leave (Id,Name) values (200,'ساعية');
Insert into Emp_Cod_Leave (Id,Name) values (210,'ساعية طارئة');
Insert into Emp_Cod_Leave (Id,Name) values (300,'مرضية');
Insert into Emp_Cod_Leave (Id,Name) values (310,'مرضية ساعية');
Insert into Emp_Cod_Leave (Id,Name) values (320,'مرضية 80%');
Insert into Emp_Cod_Leave (Id,Name) values (330,'مرضية 70%');
Insert into Emp_Cod_Leave (Id,Name) values (340,'مرضية ساعية 80%');
Insert into Emp_Cod_Leave (Id,Name) values (350,'مرضية ساعية 70%');
Insert into Emp_Cod_Leave (Id,Name) values (410,'وفاة');
Insert into Emp_Cod_Leave (Id,Name) values (420,'زواج');
Insert into Emp_Cod_Leave (Id,Name) values (430,'أمومة');
Insert into Emp_Cod_Leave (Id,Name) values (440,'حج');
Insert into Emp_Cod_Leave (Id,Name) values (510,'إدارية دون أجر');
Insert into Emp_Cod_Leave (Id,Name) values (520,'ساعية دون أجر');

UPDATE Emp_Cod_Leave SET name='إدارية'          WHERE Id=100;
UPDATE Emp_Cod_Leave SET name='طارئة'           WHERE Id=110;
UPDATE Emp_Cod_Leave SET name='ساعية'           WHERE Id=200;
UPDATE Emp_Cod_Leave SET name='ساعية طارئة'     WHERE Id=210;
UPDATE Emp_Cod_Leave SET name='مرضية'           WHERE Id=300;
UPDATE Emp_Cod_Leave SET name='مرضية ساعية'     WHERE Id=310;
UPDATE Emp_Cod_Leave SET name='مرضية 80%'       WHERE Id=320;
UPDATE Emp_Cod_Leave SET name='مرضية 70%'       WHERE Id=330;
UPDATE Emp_Cod_Leave SET name='مرضية ساعية 80%' WHERE Id=340;
UPDATE Emp_Cod_Leave SET name='مرضية ساعية 70%' WHERE Id=350;
UPDATE Emp_Cod_Leave SET name='وفاة'            WHERE Id=410;
UPDATE Emp_Cod_Leave SET name='زواج'            WHERE Id=420;
UPDATE Emp_Cod_Leave SET name='أمومة'           WHERE Id=430;
UPDATE Emp_Cod_Leave SET name='حج'              WHERE Id=440;
UPDATE Emp_Cod_Leave SET name='إدارية دون أجر'  WHERE Id=510;
UPDATE Emp_Cod_Leave SET name='ساعية دون أجر'   WHERE Id=520;

----------------------------------------------------------------------------------------------------
Create Table Emp_Code_AppTest                         -- جدول ترميز نتائج الاختبارات
( Id         Number(2) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_AppTest_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_AppTest_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_AppTest_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_AppTest_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_AppTest For Emp_Code_AppTest
/
Insert into Emp_Cod_AppTest (Id,Name) values (0,'-');
Insert into Emp_Cod_AppTest (Id,Name) values (1,'ضعيف');
Insert into Emp_Cod_AppTest (Id,Name) values (2,'مقبول');
Insert into Emp_Cod_AppTest (Id,Name) values (3,'متوسط');
Insert into Emp_Cod_AppTest (Id,Name) values (4,'جيد');
Insert into Emp_Cod_AppTest (Id,Name) values (5,'جيد جدا');
Insert into Emp_Cod_AppTest (Id,Name) values (6,'ممتاز');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_App_Status                      -- جدول ترميز حالات الطلبات
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_App_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_App_Status_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_App_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_App_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_App_Status For Emp_Code_App_Status
/
Insert into Emp_Cod_App_Status (Id,Name) values (0,'-');
Insert into Emp_Cod_App_Status (Id,Name) values (1,'مقبول');
Insert into Emp_Cod_App_Status (Id,Name) values (2,'مرفوض');
Insert into Emp_Cod_App_Status (Id,Name) values (3,'مؤجل');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_App_Result                      -- جدول ترميز نتائج طلبات التوظيف
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_App_Result_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_App_Result_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_App_Result_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_App_Result_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_App_Result For Emp_Code_App_Result
/
Insert into Emp_Cod_App_Result (Id,Name) values (0,'-');
Insert into Emp_Cod_App_Result (Id,Name) values (1,'مقبول');
Insert into Emp_Cod_App_Result (Id,Name) values (2,'مرفوض');
Insert into Emp_Cod_App_Result (Id,Name) values (3,'مؤجل');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_ComType                         -- جدول ترميز نوع التعويض
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_ComType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_ComType_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_ComType_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_ComType_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_ComType For Emp_Code_ComType
/
Insert into Emp_Cod_ComType (Id,Name) values (1,'تعويض');
Insert into Emp_Cod_ComType (Id,Name) values (2,'متمم راتب');
Insert Into Emp_Cod_Comtype (Id,Name) VALUES (3,'عيني');
----------------------------------------------------------------------------------------------------
Create Table Emp_Code_TaxPay                          -- جدول ترميز دفع الضريبة
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_TaxPay_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_TaxPay_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_TaxPay_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_TaxPay_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_TaxPay For Emp_Code_TaxPay
/
Insert into Emp_Cod_TaxPay (Id,Name) values (1,'العامل');
Insert into Emp_Cod_TaxPay (Id,Name) values (2,'رب العمل');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Nat_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Nationality                     -- جدول ترميز الجنسيات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Nat_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Nat_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Nat_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Nat_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Nat For Emp_Code_Nationality
/
Insert into Emp_Cod_Nat (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Lang_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Language                        -- جدول ترميز اللغات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Code_Lang_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Code_Lang_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Code_Lang_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Code_Lang_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Lang For Emp_Code_Language
/
Insert into Emp_Cod_Lang (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_TestMark_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_TestMarks                       -- جدول ترميز درجات الاختبار
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_TestMark_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_TestMark_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_TestMark_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_TestMark_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_TestMark For Emp_Code_TestMarks
/
Insert into Emp_Cod_TestMark (Id,Name) values (0,'-');
Insert into Emp_Cod_TestMark (Id,Name) values (1,'ضعيف');
Insert into Emp_Cod_TestMark (Id,Name) values (2,'مقبول');
Insert into Emp_Cod_TestMark (Id,Name) values (3,'وسط');
Insert into Emp_Cod_TestMark (Id,Name) values (4,'جيد');
Insert into Emp_Cod_TestMark (Id,Name) values (5,'ممتاز');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Edu_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Education                       -- جدول ترميز الحالة التعليمية/الشهادة
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Edu_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Edu_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Edu_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Edu_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Edu For Emp_Code_Education
/
Insert into Emp_Cod_Edu (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_GradGrp_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_GradGrp                         -- جدول ترميز مجموعات الدرجات الوظيفية
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_GradGrp_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_GradGrp_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_GradGrp_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_GradGrp_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_GradGrp For Emp_Code_GradGrp
/
Insert into Emp_Cod_GradGrp (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_GradDegree_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_GradDegree                      -- جدول ترميز الدرجات الوظيفية
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_GradDegree_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_GradDegree_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_GradDegree_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_GradDegree_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_GradDegree For Emp_Code_GradDegree
/
Insert into Emp_Cod_GradDegree (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Appraisal_Grp_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Appraisal_Grp                   -- جدول ترميز مجموعات التقييم
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Appraisal_Grp_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Appraisal_Grp_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Appraisal_Grp_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Appraisal_Grp_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Appraisal_Grp For Emp_Code_Appraisal_Grp
/
Insert into Emp_Cod_Appraisal_Grp (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Appraisal_Item_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Appraisal_Item                  -- جدول ترميز بنود التقييم
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Appraisal_Item_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Appraisal_Item_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Appraisal_Item_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Appraisal_Item_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Appraisal_Item For Emp_Code_Appraisal_Item
/
Insert into Emp_Cod_Appraisal_Item (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Job_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Job                             -- جدول ترميز المهنة
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Job_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Job_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Job_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Job_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Job For Emp_Code_Job
/
Insert into Emp_Cod_Job (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Department_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Department                      -- جدول ترميز الدائرة
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Department_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Department_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Department_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Department_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Department For Emp_Code_Department
/
Insert into Emp_Cod_Department (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Section_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Section                         -- جدول ترميز القسم
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Section_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Section_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Section_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Section_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Section For Emp_Code_Section
/
Insert into Emp_Cod_Section (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Level_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Level                           -- جدول ترميز المستوى
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Level_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Level_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Level_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Level_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Level For Emp_Code_Level
/
Insert into Emp_Cod_Level (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Location_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Location                        -- جدول ترميز الموقع
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Location_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Location_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Location_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Location_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Location For Emp_Code_Location
/
Insert into Emp_Cod_Location (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Spec1_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Specification1                  -- جدول ترميز التصنيف 1
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Spec1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Spec1_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Spec1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Spec1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Spec1 For Emp_Code_Specification1
/
Insert into Emp_Cod_Spec1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Spec2_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Specification2                  -- جدول ترميز التصنيف 2
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Spec2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Spec2_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Spec2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Spec2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Spec2 For Emp_Code_Specification2
/
Insert into Emp_Cod_Spec2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Spec3_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Specification3                  -- جدول ترميز التصنيف 3
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Spec3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Spec3_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Spec3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Spec3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Spec3 For Emp_Code_Specification3
/
Insert into Emp_Cod_Spec3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Spec4_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Specification4                  -- جدول ترميز التصنيف 4
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Spec4_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Spec4_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Spec4_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Spec4_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Spec4 For Emp_Code_Specification4
/
Insert into Emp_Cod_Spec4 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Hist_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_History                         -- جدول ترميز أنواع القرارات الإدارية
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Hist_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Hist_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Hist_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Hist_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Hist For Emp_Code_History
/
Insert into Emp_Cod_Hist (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Cons_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Consideration                   -- جدول ترميز المكافآت
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Cons_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Cons_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Cons_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Cons_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Cons For Emp_Code_Consideration
/
Insert into Emp_Cod_Cons (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Pun_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Punishment                      -- جدول ترميز العقوبات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Pun_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Pun_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Pun_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Pun_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Pun For Emp_Code_Punishment
/
Insert into Emp_Cod_Pun (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Emp_Cod_Msn_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Code_Mission                         -- جدول ترميز المهام
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Emp_Cod_Msn_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Emp_Cod_Msn_UK     UNIQUE      (Name),
  CONSTRAINT Emp_Cod_Msn_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Emp_Cod_Msn_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Cod_Msn For Emp_Code_Mission
/
Insert into Emp_Cod_Msn (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
