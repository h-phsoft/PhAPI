--set Pagesize 1000
--select 'Drop table '   || table_name    || ';' from user_tables    where table_name    like 'PED%';
--select 'Drop Synonym ' || Synonym_name  || ';' from user_Synonyms  where Synonym_name  like 'PED%';
--select 'Drop Sequence '|| Sequence_name || ';' from user_Sequences where Sequence_name like 'PED%';
--select 'Drop View '    || View_name     || ';' from user_Views     where View_name     like 'PED%';

Create Sequence PED_Cod_Pregnancy_Type_Seq MinValue 1 Start With 1 MaxValue 9 CACHE 2;
Create Table PED_Code_Pregnancy_Type                        -- جدول ترميز طريقة الحمل     
( Id         Number(1) NOT NULL,                            -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                           -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                   -- الاسم
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT  PED_Cod_Pregnancy_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  PED_Cod_Pregnancy_Type_UK        UNIQUE      (Name),
  CONSTRAINT  PED_Cod_Pregnancy_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT  PED_Cod_Pregnancy_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT  PED_Cod_Pregnancy_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym PED_Cod_Pregnancy_Type For PED_Code_Pregnancy_Type
/
Insert into PED_Cod_Pregnancy_Type (Id,Name) values (1,'طبيعي');
Insert into PED_Cod_Pregnancy_Type (Id,Name) values (2,'يعد العلاج');
----------------------------------------------------------------------------------------------------
Create Sequence PED_Cod_Pregnancy_Condition_Seq MinValue 1 Start With 1 MaxValue 99 CACHE 2;
Create Table PED_Code_Pregnancy_Conditions                  -- جدول ترميز طبيعة فترة الحمل
( Id         Number(2) NOT NULL,                            -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                           -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                   -- الاسم
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT  PED_Cod_Pregnancy_Condition_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  PED_Cod_Pregnancy_Condition_UK        UNIQUE      (Name),
  CONSTRAINT  PED_Cod_Pregnancy_Condition_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT  PED_Cod_Pregnancy_Condition_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT  PED_Cod_Pregnancy_Condition_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym PED_Cod_Pregnancy_Condition For PED_Code_Pregnancy_Conditions
/
Insert into PED_Cod_Pregnancy_Condition (Id,Name) values (1,'طبيعية');
Insert into PED_Cod_Pregnancy_Condition (Id,Name) values (2,'غير اعتيادية');
----------------------------------------------------------------------------------------------------
Create Sequence PED_Cod_Birth_Type_Seq MinValue 1 Start With 1 MaxValue 99 CACHE 2;
Create Table PED_Code_Birth_Type                            -- جدول ترميز نوع الولادة
( Id         Number(2) NOT NULL,                            -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                           -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                   -- الاسم
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT  PED_Cod_Birth_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  PED_Cod_Birth_Type_UK        UNIQUE      (Name),
  CONSTRAINT  PED_Cod_Birth_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT  PED_Cod_Birth_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT  PED_Cod_Birth_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym PED_Cod_Birth_Type For PED_Code_Birth_Type
/
Insert into PED_Cod_Birth_Type (Id,Name) values (1,'طبيعية');
Insert into PED_Cod_Birth_Type (Id,Name) values (2,'قيصرية');
----------------------------------------------------------------------------------------------------
Create Sequence PED_Cod_Quality_Perf_Seq MinValue 1 Start With 1 MaxValue 99 CACHE 2;
Create Table PED_Code_Quality_Performance                   -- جدول ترميز الأداء
( Id         Number(2) NOT NULL,                            -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                           -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                   -- الاسم
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_Cod_Quality_Perf_PK        PRIMARY KEY (Id  ),
  CONSTRAINT PED_Cod_Quality_Perf_UK        UNIQUE      (Name),
  CONSTRAINT PED_Cod_Quality_Perf_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT PED_Cod_Quality_Perf_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT PED_Cod_Quality_Perf_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym PED_Cod_Quality_Perf For PED_Code_Quality_Performance
/
Insert into PED_Cod_Quality_Perf (Id,Name) values (1,'ايجابية');
Insert into PED_Cod_Quality_Perf (Id,Name) values (2,'سلبية');
Insert into PED_Cod_Quality_Perf (Id,Name) values (3,'سلبية متغيرة');
----------------------------------------------------------------------------------------------------
Create Sequence PED_Cats_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Categories                                 -- جدول الفئات
( Id         Number(5) NOT NULL,                            -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                           -- الحالة
  Name       Varchar2(100 Char) NOT NULL,                   -- الاسم
  Symbol     Varchar2(10 Char),                             -- الرمز
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_Cats_PK        PRIMARY KEY (Id  ),
  CONSTRAINT PED_Cats_UK        UNIQUE      (Name),
  CONSTRAINT PED_Cats_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT PED_Cats_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PED_Cats_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PED_Cats For PED_Categories
/

INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (1 , 'A', 'معارضة (عند)', 'مشكلة');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (2 , 'B', 'مشاكل معرفية', 'مشكلة متوسطة');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (3 , 'C', 'حركة زائدة', 'مشكلة');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (4 , 'D', 'خجل وقلق', 'درجة عادية');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (5 , 'E', 'الكماليات', 'درجة عادية');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (6 , 'F', 'مهارات اجتماعية', 'مشكلة متوسطة');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (7 , 'G', 'أمراض نفس جسمية', 'درجة عادية');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (8 , 'H', 'أعراض الإصابة بـ ADHD', 'مشكلة');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (9 , 'I', 'اندفاعية وعدم تركيز', 'مشكلة');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (10, 'J', 'مشكلات انفعالية', 'مشكلة متوسطة');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (11, 'K', 'مشكلة في التركيز', 'مشكلة');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (12, 'L', 'مشكلة في الانتباه', 'مشكلة');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (13, 'M', 'مشاكل حركة زائدة', 'مشكلة');
INSERT INTO PED_Categories (Id, Symbol, Name, Rem) VALUES (14, 'N', 'حركة زائدة ونقص تركيز واندفاع', 'مشكلة');
----------------------------------------------------------------------------------------------------
Create Sequence PED_Test_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Tests                                      -- جدول الاختبارات
( Id         Number(5) NOT NULL,                            -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                           -- الحالة
  Name       Varchar2(200 Char) NOT NULL,                   -- الاسم
  Version    Varchar2(50 Char),                             -- الإصدار
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_Test_PK        PRIMARY KEY (Id),
  CONSTRAINT PED_Test_UK        UNIQUE      (Name),
  CONSTRAINT PED_Test_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT PED_Test_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PED_Test_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PED_Test For PED_Tests
/
INSERT INTO PED_Test (Id, Status_Id, Name, Version, Rem) VALUES (0,1,'corner','0.0.1','');
----------------------------------------------------------------------------------------------------
Create Sequence PED_Test_Cats_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Test_Categories_Mst                        -- جدول فئات اختبار
( Id         Number(5) NOT NULL,                            -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                           -- الحالة
  Test_Id    Number(5) NOT NULL,                            -- الاختبار
  Cat_Id     Number(5) NOT NULL,                            -- الفئة
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_Test_Cats_PK        PRIMARY KEY (Id),
  CONSTRAINT PED_Test_Cats_UK        UNIQUE      (Test_Id, Cat_Id),
  CONSTRAINT PED_Test_Cats_Test_Fk   Foreign Key (Test_Id  ) References PED_Test      (Id),
  CONSTRAINT PED_Test_Cats_Cat_Fk    Foreign Key (Cat_Id   ) References PED_Cats      (Id),
  CONSTRAINT PED_Test_Cats_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT PED_Test_Cats_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PED_Test_Cats_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PED_Test_Cats For PED_Test_Categories_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Test_Cats_Trn_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Test_Categories_Trn                        -- جدول فئات اختبار
( Id         Number(5) NOT NULL,                            -- مفتاح رئيسي
  Mst_Id     Number(5) NOT NULL,                            -- الحالة
  Cat_From   Number(5) NOT NULL,                            -- الاختبار
  Cat_To     Number(5) NOT NULL,                            -- الفئة
  Text       Varchar2(100 Char),                            -- النص
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_Test_Cats_Trn_PK        PRIMARY KEY (Id),
  CONSTRAINT PED_Test_Cats_Trn_Test_Fk   Foreign Key (Mst_Id   ) References PED_Test_Cats (Id),
  CONSTRAINT PED_Test_Cats_Trn_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PED_Test_Cats_Trn_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PED_Test_Cats_Trn For PED_Test_Categories_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Test_Question_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Test_Questions                             -- أسئلة اختبار
( Id         Number(5) NOT NULL,                            -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                           -- الحالة
  Test_Id    Number(5) NOT NULL,                            -- الاختبار
  Ord        Number(3) NOT NULL,                            -- الترتيب
  QText      Varchar2(256) NOT NULL,                        -- نص السؤال
  IsCatA     Number(1) Default 0 CHECK (IsCatA IN (0,1)),   -- هل يؤثر على الفئة A
  IsCatB     Number(1) Default 0 CHECK (IsCatB IN (0,1)),   -- هل يؤثر على الفئة B
  IsCatC     Number(1) Default 0 CHECK (IsCatC IN (0,1)),   -- هل يؤثر على الفئة C
  IsCatD     Number(1) Default 0 CHECK (IsCatD IN (0,1)),   -- هل يؤثر على الفئة D
  IsCatE     Number(1) Default 0 CHECK (IsCatE IN (0,1)),   -- هل يؤثر على الفئة E
  IsCatF     Number(1) Default 0 CHECK (IsCatF IN (0,1)),   -- هل يؤثر على الفئة F
  IsCatG     Number(1) Default 0 CHECK (IsCatG IN (0,1)),   -- هل يؤثر على الفئة G
  IsCatH     Number(1) Default 0 CHECK (IsCatH IN (0,1)),   -- هل يؤثر على الفئة H
  IsCatI     Number(1) Default 0 CHECK (IsCatI IN (0,1)),   -- هل يؤثر على الفئة I
  IsCatJ     Number(1) Default 0 CHECK (IsCatJ IN (0,1)),   -- هل يؤثر على الفئة J
  IsCatK     Number(1) Default 0 CHECK (IsCatK IN (0,1)),   -- هل يؤثر على الفئة K
  IsCatL     Number(1) Default 0 CHECK (IsCatL IN (0,1)),   -- هل يؤثر على الفئة L
  IsCatM     Number(1) Default 0 CHECK (IsCatM IN (0,1)),   -- هل يؤثر على الفئة M
  IsCatN     Number(1) Default 0 CHECK (IsCatN IN (0,1)),   -- هل يؤثر على الفئة N
  Rem        Varchar2(100 Char),
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_Test_Question_PK        PRIMARY KEY (Id),
  CONSTRAINT PED_Test_Question_Test_Fk   Foreign Key (Test_Id  ) References PED_Test      (Id),
  CONSTRAINT PED_Test_Question_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT PED_Test_Question_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PED_Test_Question_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PED_Test_Question For PED_Test_Questions
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Ques_Ans_Seq MinValue 1 Start With 1 MaxValue 99999999 INCREMENT BY 1 CACHE 2;
Create Table PED_Questions_Answers                          -- جدول أجوبة الأسئلة
( Id         Number(8) NOT NULL,                            -- مفتاح رئيسي
  Test_Id    Number(5) NOT NULL,                            -- الاختبار
  Answer     Varchar2(50),                                  -- الاجابة
  Mark       Number(1),                                     -- العلامة
  Rem        Varchar2(100 Char),
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_Ques_Ans_PK        PRIMARY KEY (Id),
  CONSTRAINT PED_Ques_Ans_Test_Fk   Foreign Key (Test_Id  ) References PED_Test      (Id),
  CONSTRAINT PED_Ques_Ans_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PED_Ques_Ans_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PED_Ques_Ans For PED_Questions_Answers
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Test_Keys_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Test_Keys                                  -- جدول مفاتيح اختبار
( Id         Number(5) NOT NULL,                            -- مفتاح رئيسي
  Test_Id    Number(5) NOT NULL,                            -- الاختبار
  Gender_Id  Number(2) Default 1 NOT NULL,                  -- الجنس
  Age_From   Number(3) Default 0 NOT NULL,                  -- العمر من
  Age_To     Number(3) Default 0 NOT NULL,                  -- العمر إلى
  Degree     Number(3) Default 0 NOT NULL,                  -- الدرجة
  ACat_From  Number(2) Default -1,                          -- الفئة A من
  ACat_To    Number(2) Default -1,                          -- الفئة A إلى
  BCat_From  Number(2) Default -1,                          -- الفئة B من
  BCat_To    Number(2) Default -1,                          -- الفئة B إلى
  CCat_From  Number(2) Default -1,                          -- الفئة C من
  CCat_To    Number(2) Default -1,                          -- الفئة C إلى
  DCat_From  Number(2) Default -1,                          -- الفئة D من
  DCat_To    Number(2) Default -1,                          -- الفئة D إلى
  ECat_From  Number(2) Default -1,                          -- الفئة E من
  ECat_To    Number(2) Default -1,                          -- الفئة E إلى
  FCat_From  Number(2) Default -1,                          -- الفئة F من
  FCat_To    Number(2) Default -1,                          -- الفئة F إلى
  GCat_From  Number(2) Default -1,                          -- الفئة G من
  GCat_To    Number(2) Default -1,                          -- الفئة G إلى
  HCat_From  Number(2) Default -1,                          -- الفئة H من
  HCat_To    Number(2) Default -1,                          -- الفئة H إلى
  ICat_From  Number(2) Default -1,                          -- الفئة I من
  ICat_To    Number(2) Default -1,                          -- الفئة I إلى
  JCat_From  Number(2) Default -1,                          -- الفئة J من
  JCat_To    Number(2) Default -1,                          -- الفئة J إلى
  KCat_From  Number(2) Default -1,                          -- الفئة K من
  KCat_To    Number(2) Default -1,                          -- الفئة K إلى
  LCat_From  Number(2) Default -1,                          -- الفئة L من
  LCat_To    Number(2) Default -1,                          -- الفئة L إلى
  MCat_From  Number(2) Default -1,                          -- الفئة M من
  MCat_To    Number(2) Default -1,                          -- الفئة M إلى
  NCat_From  Number(2) Default -1,                          -- الفئة N من
  NCat_To    Number(2) Default -1,                          -- الفئة N إلى
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_Test_Key_PK        PRIMARY KEY (Id),
  CONSTRAINT PED_Test_Key_Age_Chk   CHECK       (Age_From <= Age_To),
  CONSTRAINT PED_Test_Key_UK        UNIQUE      (Gender_Id, Age_From, Age_To, Degree),
  CONSTRAINT PED_Test_Key_Test_Fk   Foreign Key (Test_Id  ) References PED_Test      (Id),
  CONSTRAINT PED_Test_Key_Gender_Fk Foreign Key (Gender_Id) References Phs_Cod_Gender(Id),
  CONSTRAINT PED_Test_Key_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PED_Test_Key_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PED_Test_Key For PED_Test_Keys
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Prog_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Programs                                   -- البرامج
( Id         Number(5) NOT NULL,                            -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                           -- الحالة
  Name       Varchar2(100 Char) NOT NULL,                   -- الاسم
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_Prog_PK        PRIMARY KEY (Id  ),
  CONSTRAINT PED_Prog_UK        UNIQUE      (Name),
  CONSTRAINT PED_Prog_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT PED_Prog_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PED_Prog_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PED_Prog For PED_Programs
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_App_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Appointments                                                                    -- جدول المواعيد
( Id                                                           Number(5) NOT NULL,               -- مفتاح رئيسي
  Info_Source                                                  Varchar2(100 Char),               -- مصدر المعلومات 
  ComingFrom                                                   Varchar2(100 Char),               -- جهة التحويل   
  Appointment_Date                                             Date,                             -- تاريخ المقابلة  
  Name                                                         Varchar2(100 Char) NOT NULL,      -- الاسم 
  Gender_Id                                                    Number(1) Default 1 NOT NULL,     -- الجنس
  Date_Of_Birth                                                Date,                             -- تاريخ الميلاد 
  Current_Class                                                Varchar2(100 Char),               -- الصف الحالي
  Assumed_Class                                                Varchar2(100 Char),               -- الصف المفترض
  Current_School                                               Varchar2(100 Char),               -- المدرسة الحالية
  Address                                                      Varchar2(200 Char),               -- العنوان
  Phone_1                                                      Varchar2(20  Char),               -- 1 رقم الهاتف 
  Phone_2                                                      Varchar2(20  Char),               -- 2 رقم الهاتف 
  Father_Name                                                  Varchar2(100 Char),               -- اسم الأب
  Father_Edu_Qualification                                     Varchar2(100 Char),               -- المؤهل العلمي للأب
  Father_Jop                                                   Varchar2(100 Char),               -- وظيفة الأب
  Mother_Name                                                  Varchar2(100 Char),               -- اسم الأم
  Mother_Edu_Qualification                                     Varchar2(100 Char),               -- المؤهل العلمي للأم
  Mother_Jop                                                   Varchar2(100 Char),               -- وظيفة الأم
  Brothers_Number                                              Number  (2),                      -- عدد الإخوة 
  Child_Order                                                  Number  (2),                      -- ترتيب الطفل
  Pathological_Allergies_Id                                    Number  (1) Default 2,            -- الحساسية المرضية
  General_Medical_Weakness_Id                                  Number  (1) Default 2,            -- الضعف الطبي العام
  Academic_Performance_Weakness_Id                             Number  (1) Default 2,            -- ضعف في التحصيل العلمي
  Speech_Problems_Id                                           Number  (1) Default 2,            -- مشاكل في النطق
  Wear_Glasses_Id                                              Number  (1) Default 2,            -- يرتدي نظارات
  Wear_Hearing_Aid_Id                                          Number  (1) Default 2,            -- يرتدي سماعة طبية
  Use_Crutch_Id                                                Number  (1) Default 2,            -- يستخدم عكاز   
  Use_Wheelchair_Id                                            Number  (1) Default 2,            -- يستخدم كرسي متحرك
  Other_Aids                                                   Varchar2(200 Char),               -- وسائل مساعدة أخرى
  Problem_Parents_Point_View                                   Varchar2(200 Char),               -- المشكلة من وجهة نظر الأبوين
  Is_Mother_Smoke_Before_Pregnancy_Id                          Number  (1) Default 2,            -- هل كانت الأم تدخن قبل الحمل
  Is_Mother_Smoke_During_Pregnancy_Id                          Number  (1) Default 2,            -- هل كانت الأم تدخن أثناء الحمل
  Is_Mother_Smoke_After_Pregnancy_Id                           Number  (1) Default 2,            -- هل كانت الأم تدخن بعد الحمل 
  Is_Mother_Non_Smoker_Id                                      Number  (1) Default 2,            -- هل كانت الأم غير مدخنة
  Pregnancy_Type_Id                                            Number  (1) Default 1,            -- نوع الحمل
  Pregnancy_Duration                                           Number  (2),                      -- مدة الحمل
  Mother_Receive_Radiation_Therapy_During_Pregnancy_Id         Number  (1) Default 2,            -- هل تلقت الأم علاجاً إشعاعياً أثناء الحمل
  Mother_Receive_Chemotherapy_During_Pregnancy_Id              Number  (1) Default 2,            -- هل تلقت الأم علاجاً كيميائياً أثناء الحمل
  Mother_Use_Hair_Dye_During_Pregnancy_Id                      Number  (1) Default 2,            -- هل استخدمت الأم صبغة شعر أثناء الحمل
  Mother_Use_LightFillings_During_Pregnancy_Id                 Number  (1) Default 2,            -- حشوات ضوئية
  Mother_Experience_Psychological_Problems_During_Pregnancy_Id Number  (1) Default 2,            -- هل عانت الأم من مشاكل نفسية أثناء الحمل
  Pregnancy_Condition_Id                                       Number  (2) Default 1,            -- ظروف الحمل
  Pregnancy_Conditions_Notes                                   Varchar2(200 Char),               -- ملاحظات ظروف الحمل
  Birth_Type_Id                                                Number  (1) Default 1,            -- نوع الولادة
  Labor_Period                                                 Varchar2(50 Char),                -- فترة المخاض
  Enter_Incubator_Id                                           Number  (1) Default 2,            -- دخول الحاضنة
  Child_Weight_At_Birth                                        Number(3),                        -- وزن الطفل عند الولادة 
  Problems_During_Child_Birth                                  Varchar2(200 Char),               -- مشاكل أثناء ولادة الطفل
  Breast_Feeding_Id                                            Number  (1) Default 1,            -- الرضاعة الطبيعية
  Breast_Feeding_Duration                                      Number  (2),                      -- مدة الرضاعة الطبيعية
  Artificial_Feeding_Id                                        Number  (1) Default 2,            -- الرضاعة الصناعية
  Artificial_Feeding_Duration                                  Number  (2),                      -- مدة الرضاعة الصناعية
  Weaning_Conditions                                           Varchar2(200 Char),               -- ظروف الفطام
  Stool_During_Breast_Feeding                                  Varchar2(200 Char),               -- براز الطفل أثناء الرضاعة الطبيعية
  Child_Condition_In_First_Three_Months                        Varchar2(200 Char),               -- حالة الطفل في الأشهر الثلاثة الأولى
  Nerve_Reflexes                                               Varchar2(200 Char),               -- المنعكسات العصبية
  Medical_Diagnosis                                            Varchar2(200 Char),               -- التشخيص الطبي
  Medical_Resonant_Image_Id                                    Number  (1) Default 2,            -- صورة طبية رنين 
  Medical_Brain_Mapping_Image_Id                               Number  (1) Default 2,            -- صورة تخطيط دماغ طبي
  Medical_Blood_Test_Id                                        Number  (1) Default 2,            -- تحاليل دم طبية          
  Medical_Food_Allergy_Test_Id                                 Number  (1) Default 2,            -- اختبار الحساسية الغذائية
  Medical_Previous_Report_Id                                   Number  (1) Default 2,            -- تقارير سابقة طبية
  Medical_Other                                                Varchar2(200 Char),               -- اختبارات طبية أخرى
  Child_Age_Sitting_Walking_Crawling                           Number(2),                        -- عمر الطفل في الجلوس والمشي والزحف
  Child_Age_When_Spoke_First_Word                              Number(2),                        -- عمر الطفل عند نطقه أول كلمة وأول جملة
  Movement_Problems                                            Varchar2(200 Char),               -- مشاكل في الحركة
  Congenital_Malformations                                     Varchar2(200 Char),               -- تشوهات خلقية
  Child_Involved_Accidents_Id                                  Number  (1) Default 2,            -- تعرض الطفل لحوادث
  Child_Involved_Experience_Fever_Id                           Number  (1) Default 2,            -- تعرض الطفل لنوبات حمى 
  Child_Involved_Seizures_Id                                   Number  (1) Default 2,            -- تعرض الطفل لنوبات صرع
  Child_Involved_Other                                         Varchar2(200 Char),               -- تعرض الطفل لأمور أخرى
  Other_Signs_Mention                                          Varchar2(200 Char),               -- علامات أخرى يذكرها الأبوين
  Personal_Social_Factor_Shyness_Id                            Number  (1) Default 2,            -- العوامل الشخصية والاجتماعية - الخجل
  Personal_Social_Factor_Introversion_Id                       Number  (1) Default 2,            -- العوامل الشخصية والاجتماعية - الانطواء
  Personal_Social_Factor_Withdrawal_Id                         Number  (1) Default 2,            -- العوامل الشخصية والاجتماعية - الانسحاب
  Personal_Social_Factor_Depression_Id                         Number  (1) Default 2,            -- العوامل الشخصية والاجتماعية - الاكتئاب
  Personal_Social_Factor_Anxiety_Id                            Number  (1) Default 2,            -- العوامل الشخصية والاجتماعية - القلق
  Personal_Social_Factor_Absentmindedness_Id                   Number  (1) Default 2,            -- العوامل الشخصية والاجتماعية - شرود الذهن
  Personal_Social_Factor_Hyperactivity_Id                      Number  (1) Default 2,            -- العوامل الشخصية والاجتماعية - فرط النشاط
  Personal_Social_Factor_Excessive_Inactivity_Id               Number  (1) Default 2,            -- العوامل الشخصية والاجتماعية -الخمول المفرط
  Personal_Social_Factor_Achievement_Motivation_Id             Number  (1) Default 2,            -- العوامل الشخصية والاجتماعية - دافع الإنجاز
  Personal_Social_Factor_Impulsiveness_Id                      Number  (1) Default 2,            -- العوامل الشخصية والاجتماعية - الاندفاعية
  Brother_Sister_Relationship                                  Varchar2(200 Char),               -- علاقة الأخوة والأخوات
  Friends_Relationship                                         Varchar2(200 Char),               -- علاقة الأصدقاء
  Hobbies_Interests                                            Varchar2(200 Char),               -- الهوايات والاهتمامات
  Acceptance_Taking_Responsibility                             Varchar2(200 Char),               -- القبول وتحمل المسؤولية
  Child_Entered_Kindergarten_Id                                Number  (1) Default 2,            -- دخول الطفل الروضة
  Child_Entered_Kindergarten_Age                               Number(2),                        -- عمر دخول الطفل الروضة
  Received_Special_Assistance_In_Past_Id                       Number  (1) Default 2,            -- تلقي مساعدة خاصة في الماضي
  Bring_Back_Classes_Id                                        Number  (1) Default 2,            -- هل أعيد له الصفوف
  Drop_Out_School_Id                                           Number  (1) Default 2,            -- هل انقطع عن المدرسة
  School_Teacher_Changed_Id                                    Number  (1) Default 2,            -- هل تم تغيير المدرسة والمعلمين
  Quality_Teacher_Report_Perf_Id                               Number  (3) Default 1,            -- تقارير المعلمين عن الأداء الدراسي 
  Child_Attitudes_Towards_School                               Varchar2(200 Char),               -- مواقف الطفل تجاه المدرسة
  Psychological_Counseling                                     Varchar2(200 Char),               -- استشارات نفسية
  Other_Medical_Consultations                                  Varchar2(200 Char),               -- استشارات طبية أخرى
  Service_Requested                                            Varchar2(200 Char),               -- الخدمة المطلوبة من المركز حسب طلب الاهل 
  Recommendations                                              Varchar2(200 Char),               -- التوصيات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_App_PK                                           PRIMARY KEY (Id),
  CONSTRAINT PED_App_UK                                           UNIQUE      (Name, Appointment_Date),                
  CONSTRAINT PED_App_FK                                           Foreign Key (Gender_Id)                                                    REFERENCES Phs_Cod_Gender              (Id),
  CONSTRAINT PED_App_Pathological_Allergies_Fk                    Foreign Key (Pathological_Allergies_Id)                                    REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_General_Medical_Weakness_Fk                  Foreign Key (General_Medical_Weakness_Id)                                  REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Academic_Performance_Weakness_Fk             Foreign Key (Academic_Performance_Weakness_Id)                             REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Speech_Problems_Fk                           Foreign Key (Speech_Problems_Id)                                           REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Wear_Glasses_Fk                              Foreign Key (Wear_Glasses_Id)                                              REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Wear_Hearing_Aid_Fk                          Foreign Key (Wear_Hearing_Aid_Id)                                          REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Use_Crutch_Fk                                Foreign Key (Use_Crutch_Id)                                                REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Is_Mother_Smoke_Before_Pregnancy_FK          Foreign Key (Is_Mother_Smoke_Before_Pregnancy_Id)                          REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Is_Mother_Smoke_During_Pregnancy_FK          Foreign Key (Is_Mother_Smoke_During_Pregnancy_Id)                          REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Is_Mother_Smoke_After_Pregnancy_FK           Foreign Key (Is_Mother_Smoke_After_Pregnancy_Id)                           REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Is_Mother_Non_Smoker_FK                      Foreign Key (Is_Mother_Non_Smoker_Id)                                      REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Mother_Receive_Radiation_Therapy_FK          Foreign Key (Mother_Receive_Radiation_Therapy_During_Pregnancy_Id)         REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Mother_Receive_Chemotherapy_FK               Foreign Key (Mother_Receive_Chemotherapy_During_Pregnancy_Id)              REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Mother_Use_Hair_Dye_FK                       Foreign Key (Mother_Use_Hair_Dye_During_Pregnancy_Id)                      REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Mother_Use_LightFillings_During_Pregnancy_FK Foreign Key (Mother_Use_LightFillings_During_Pregnancy_Id)                 REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Mother_Experience_Psychological_Problems_FK  Foreign Key (Mother_Experience_Psychological_Problems_During_Pregnancy_Id) REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Enter_Incubator_FK                           Foreign Key (Enter_Incubator_Id)                                           REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Breast_Feeding_FK                            Foreign Key (Breast_Feeding_Id)                                            REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Artificial_Feeding_FK                        Foreign Key (Artificial_Feeding_Id)                                        REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Medical_Resonant_Image_FK                    Foreign Key (Medical_Resonant_Image_Id)                                    REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Medical_Brain_Mapping_Image_FK               Foreign Key (Medical_Brain_Mapping_Image_Id)                               REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Medical_Blood_Test_FK                        Foreign Key (Medical_Blood_Test_Id)                                        REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Medical_Food_Allergy_Test_FK                 Foreign Key (Medical_Food_Allergy_Test_Id)                                 REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Medical_Previous_Reports_FK                  Foreign Key (Medical_Previous_Report_Id)                                   REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_Involved_Accidents_FK                   Foreign Key (Child_Involved_Accidents_Id)                                  REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_Involved_Experience_Fever_FK            Foreign Key (Child_Involved_Experience_Fever_Id)                           REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_Involved_Seizures_FK                    Foreign Key (Child_Involved_Seizures_Id)                                   REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_PS_Factors_Shyness_FK                   Foreign Key (Personal_Social_Factor_Shyness_Id)                            REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_PS_Factors_Introversion_FK              Foreign Key (Personal_Social_Factor_Introversion_Id)                       REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_PS_Factors_Withdrawal_FK                Foreign Key (Personal_Social_Factor_Withdrawal_Id)                         REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_PS_Factors_Depression_FK                Foreign Key (Personal_Social_Factor_Depression_Id)                         REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_PS_Factors_Anxiety_FK                   Foreign Key (Personal_Social_Factor_Anxiety_Id)                            REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_PS_Factors_Absentmindedness_FK          Foreign Key (Personal_Social_Factor_Absentmindedness_Id)                   REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_PS_Factors_Hyperactivity_FK             Foreign Key (Personal_Social_Factor_Hyperactivity_Id)                      REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_PS_Factors_Excessive_Inactivity_FK      Foreign Key (Personal_Social_Factor_Excessive_Inactivity_Id)               REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_PS_Factors_Achievement_Motivation_FK    Foreign Key (Personal_Social_Factor_Achievement_Motivation_Id)             REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_PS_Factors_Impulsiveness_FK             Foreign Key (Personal_Social_Factor_Impulsiveness_Id)                      REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_Child_Entered_Kindergarten_FK           Foreign Key (Child_Entered_Kindergarten_Id)                                REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_Received_Special_Assistance_In_Past_FK  Foreign Key (Received_Special_Assistance_In_Past_Id)                       REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_Bring_Back_Classes_FK                   Foreign Key (Bring_Back_Classes_Id)                                        REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_Drop_Out_School_FK                      Foreign Key (Drop_Out_School_Id)                                           REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_AppChild_School_Teacher_Changed_FK               Foreign Key (School_Teacher_Changed_Id)                                    REFERENCES Phs_Cod_YesNo               (Id),
  CONSTRAINT PED_App_Pregnancy_Type_FK                            Foreign Key (Pregnancy_Type_Id)                                            References PED_Cod_Pregnancy_Type      (Id),
  CONSTRAINT PED_App_Pregnancy_Condition_FK                       Foreign Key (Pregnancy_Condition_Id)                                       References PED_Cod_Pregnancy_Condition (Id),
  CONSTRAINT PED_App_Birth_Type_FK                                Foreign Key (Birth_Type_Id)                                                References PED_Cod_Birth_Type          (Id),
  CONSTRAINT PED_App_Quality_Perf_FK                              Foreign Key (Quality_Teacher_Report_Perf_Id)                               References PED_Cod_Quality_Perf        (Id),
  CONSTRAINT PED_App_Ins_FK                                       Foreign Key (Ins_User )                                                    References Cpy_User                    (Id),
  CONSTRAINT PED_App_Upd_FK                                       Foreign Key (Upd_User )                                                    References Cpy_User                    (Id)
)
/
Create Synonym PED_App For PED_Appointments
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_App_Test_Seq MinValue 1 Start With 1 MaxValue 9999999999 CACHE 2;
Create Table PED_Appointment_Tests                           -- جدول اختبارات مقابلة
( Id         Number(10) NOT NULL,                            -- مفتاح رئيسي
  App_Id     Number(5)  NOT NULL ,                           -- مفتاح الأب  
  Test_Id    Number(5)  NOT NULL,                            -- الاختبار  
  Rem        Varchar2(100 Char),                             -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT  PED_App_Test_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  PED_App_Test_Prog_FK   Foreign Key (App_Id   ) References PED_App    (Id),
  CONSTRAINT  PED_App_Test_Test_Fk   Foreign Key (Test_Id  ) References PED_Test   (Id),
  CONSTRAINT  PED_App_Test_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT  PED_App_Test_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym PED_App_Test For PED_Appointment_Tests
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Cod_Grp_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;
Create Table PED_Code_Group                                 -- جدول ترميز المجموعات
( Id         Number(5) NOT NULL,                            -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                           -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                   -- الاسم
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT  PED_Cod_Grp_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  PED_Cod_Grp_Type_UK        UNIQUE      (Name),
  CONSTRAINT  PED_Cod_Grp_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT  PED_Cod_Grp_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT  PED_Cod_Grp_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym PED_Cod_Grp For PED_Code_Group
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Prog_Itm_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;
Create Table PED_Program_Item                               -- جدول بنود البرامج
( Id         Number(5) NOT NULL,                            -- مفتاح رئيسي
  Prog_Id    Number(5) NOT NULL,                            -- مفتاح الأب              
  Grp_Id     Number(2) NOT NULL,                            -- المجموعة
  Name       Varchar2(100 Char),                            -- الاسم
  Ord        Number(2),                                     -- الترتيب
  Rem        Varchar2(100 Char),                            -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT  PED_Prog_Itm_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  PED_Prog_Itm_UK        UNIQUE      (Name),
  CONSTRAINT  PED_Prog_Itm_Prog_FK   Foreign Key (Prog_Id  ) References PED_Prog    (Id),
  CONSTRAINT  PED_Prog_Itm_Grp_FK    Foreign Key (Grp_Id   ) References PED_Cod_Grp (Id),
  CONSTRAINT  PED_Prog_Itm_Ins_FK    Foreign Key (Ins_User ) References Cpy_User    (Id),
  CONSTRAINT  PED_Prog_Itm_Upd_FK    Foreign Key (Upd_User ) References Cpy_User    (Id)
)
/
Create Synonym PED_Prog_Itm For PED_Program_Item
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_APP_Quest_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;
Create Table PED_Appointment_Test_Questions                  -- جدول تسجيل بنود اختبار مقابلة      
( Id          Number(5) NOT NULL ,                            -- مفتاح رئيسي
  App_Test_Id Number(10) NOT NULL ,                            -- مفتاح الأب              
  Quest_Id    Number(5) NOT NULL ,                            -- مفتاح الأب
  Degree      Number(1) DEFAULT 0,                            -- الدرجة
  Answer_Id   Number(1) DEFAULT 0,                            -- الدرجة
  Rem         Varchar2(100 Char) ,                            -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  PED_APP_Quest_PK       PRIMARY KEY (Id  ),
  CONSTRAINT  PED_APP_Quest_App_FK   Foreign Key (App_Test_Id) References PED_App_Test      (Id),
  CONSTRAINT  PED_APP_Quest_Quest_FK Foreign Key (Quest_Id   ) References PED_Test_Question (Id),
  CONSTRAINT  PED_APP_Quest_Ans_FK   Foreign Key (Answer_Id  ) References PED_Ques_Ans      (Id),
  CONSTRAINT  PED_APP_Quest_Ins_FK   Foreign Key (Ins_User   ) References Cpy_User          (Id),
  CONSTRAINT  PED_APP_Quest_Upd_FK   Foreign Key (Upd_User   ) References Cpy_User          (Id)
)
/
Create Synonym PED_APP_Quest For PED_Appointment_Test_Questions
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_App_Res_Seq MinValue 1 Start With 1 MaxValue 99999 CACHE 2;
Create Table PED_Appointment_Result                            -- جدول تقييم اختبار
( Id            Number(5) NOT NULL,                            -- مفتاح رئيسي
  App_Test_Id   Number(10) NOT NULL,                           -- مفتاح الأب              
  Cat_Id        Number(5) NOT NULL,                            -- المجموعة
  Total_Degree  Number(3) NOT NULL,                            -- مجموع الدرجات
  Degree        Number(3) NOT NULL,                            -- الدرجة
  DESCRIPTION   Varchar2(100 Char),                            -- النص
  Rem           Varchar2(100 Char),                            -- ملاحظات
  Ins_User      Number(5), Ins_Date     Date,
  Upd_User      Number(5), Upd_Date     Date,
  CONSTRAINT  PED_App_Res_PK       PRIMARY KEY (Id  ),
  CONSTRAINT  PED_App_Res_App_FK   Foreign Key (App_Test_Id) References PED_App_Test    (Id),
  CONSTRAINT  PED_App_Res_Cat_FK   Foreign Key (Cat_Id   ) References PED_Cats          (Id),
  CONSTRAINT  PED_App_Res_Ins_FK   Foreign Key (Ins_User ) References Cpy_User          (Id),
  CONSTRAINT  PED_App_Res_Upd_FK   Foreign Key (Upd_User ) References Cpy_User          (Id)
)
/
Create Synonym PED_App_Res For PED_Appointment_Result
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Lect_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Lecturer (
  Id           Number(5) NOT NULL,
  Status_Id    Number(1) Default 1,
  Name         Varchar2(100 Char) NOT NULL,
  Mobile       Varchar2(20  Char),
  Gender_Id    Number(2) Default 1 NOT NULL,
  Age          Number(3) Default 0 NOT NULL,
  StudyFld     Varchar2(100 Char) NOT NULL,
  Rem          Varchar2(100 Char),
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT PED_Lect_PK        PRIMARY KEY (Id),
  CONSTRAINT PED_Lect_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT PED_Lect_Gender_Fk Foreign Key (Gender_Id) References Phs_Cod_Gender(Id),
  CONSTRAINT PED_Lect_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PED_Lect_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PED_Lect For PED_Lecturer
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Lect_Prog_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Lecturer_Program (
  Id           Number(5) NOT NULL,
  Lect_Id      Number(5) NOT NULL,
  Prog_Id      Number(5) NOT NULL,
  Status_Id    Number(1) Default 1,
  Rem          Varchar2(100 Char),
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT PED_Lect_Prog_PK         PRIMARY KEY (Id),
  CONSTRAINT PED_Lect_Prog_Gender_Fk  Foreign Key (Lect_Id)    References PED_Lect       (Id),
  CONSTRAINT PED_Lect_Prog_Prog_Id_Fk Foreign Key (Prog_Id  )  References PED_Prog       (Id),
  CONSTRAINT PED_Lect_Prog_Status_Fk  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT PED_Lect_Prog_Ins_FK     Foreign Key (Ins_User )  References Cpy_User       (Id),
  CONSTRAINT PED_Lect_Prog_Upd_FK     Foreign Key (Upd_User )  References Cpy_User       (Id)
)
/
Create Synonym PED_Lect_Prog For PED_Lecturer_Program
/
----------------------------------------------------------------------------------------------------
--Create Sequence PED_Std_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
--Create Table PED_Students (
--  Id           Number(5) NOT NULL,
--  App_Id       Number(5) NOT NULL,            
--  Name         Varchar2(100 Char) NOT NULL,
--  Gender_Id    Number(2),
--  Age          Number(3),
--  Rem          Varchar2(100 Char),
--  Ins_User     Number(5), Ins_Date     Date,
--  Upd_User     Number(5), Upd_Date     Date,
--  CONSTRAINT PED_Std_PK        PRIMARY KEY (Id),
--  CONSTRAINT PED_Std_Gender_Fk Foreign Key (Gender_Id) References Phs_Cod_Gender(Id),
--  CONSTRAINT PED_Std_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
--  CONSTRAINT PED_Std_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
--)
--/
--Create Synonym PED_Std For PED_Students
----------------------------------------------------------------------------------------------------
Create Sequence PED_Std_Lect_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Students_Lecturer (
  Id         Number(5) NOT NULL,
  App_Id     Number(5) NOT NULL,   
  Prog_Id    Number(5) NOT NULL,
  Lect_Id    Number(5) NOT NULL, 
  Sdate      Date,
  Edate      Date,
  Rem        Varchar2(100 Char),
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_PED_Std_Lect_PK          PRIMARY KEY (Id), 
  CONSTRAINT PED_PED_Std_Lect_App_FK      Foreign Key (App_Id   ) References PED_App  (Id),
  CONSTRAINT PED_PED_Std_Lect_Prog_Fk     Foreign Key (Prog_Id  ) References PED_Prog (Id),
  CONSTRAINT PED_PED_Std_Lect_Lect_Fk     Foreign Key (Lect_Id  ) References PED_Lect (Id),
  CONSTRAINT PED_PED_Std_Lect_Ins_FK      Foreign Key (Ins_User ) References Cpy_User (Id),
  CONSTRAINT PED_PED_Std_Lect_Upd_FK      Foreign Key (Upd_User ) References Cpy_User (Id)
)
/
Create Synonym PED_Std_Lect For PED_Students_Lecturer
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Std_Sched_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table PED_Student_Schedule (
  Id             Number(10) NOT NULL,   
  Mst_Id         Number(5) NOT NULL,
  Day_Code       Varchar2(3),
  Shour          Number(2),
  Ehour          Number(2),  
  Sminute        Number(2),
  Eminute        Number(2),
  Activity_Desc  Varchar2(200 Char),
  Rem            Varchar2(100 Char),
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT PED_Std_Sched_PK      PRIMARY KEY (Id),
  CONSTRAINT PED_Std_Sched_LP_FK   Foreign Key (Mst_Id   ) References PED_Std_Lect (Id),
  CONSTRAINT PED_Std_Sched_Ins_FK  Foreign Key (Ins_User ) References Cpy_User     (Id),
  CONSTRAINT PED_Std_Sched_Upd_FK  Foreign Key (Upd_User ) References Cpy_User     (Id)
)
/
Create Synonym PED_Std_Sched For PED_Student_Schedule
/
----------------------------------------------------------------------------------------------------
Create Sequence PED_Sched_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table PED_Schedule (
  Id             Number(10) NOT NULL,
  App_Id         Number(5) NOT NULL,
  Lect_Id        Number(5) NOT NULL,
  dDate          Date,
  Day_Code       Varchar2(3),
  Shour          Number(2),
  Ehour          Number(2),
  Activity_Desc  Varchar2(200 Char),
  Rem            Varchar2(100 Char),
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT PED_Sched_PK      PRIMARY KEY (Id),
  CONSTRAINT PED_Sched_Std_Fk  Foreign Key (App_Id   ) References PED_App  (Id),
  CONSTRAINT PED_Sched_Fk      Foreign Key (Lect_Id  ) References PED_Lect (Id),
  CONSTRAINT PED_Sched_Ins_FK  Foreign Key (Ins_User ) References Cpy_User (Id),
  CONSTRAINT PED_Sched_Upd_FK  Foreign Key (Upd_User ) References Cpy_User (Id)
)
/
Create Synonym PED_Sched For PED_Schedule
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE PED_Special_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
Create Table PED_Specials                                                                         -- جدول الاختصاصات
( Id         Number(5) NOT NULL,				                                                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                                                           -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				                                                   -- الاسم
  Rem        Varchar2(100 Char),          				                                                 -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PED_Special_PK        PRIMARY KEY (Id  ),
  CONSTRAINT PED_Special_UK        UNIQUE      (Name),
  CONSTRAINT PED_Special_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT PED_Special_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PED_Special_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PED_Special For PED_Specials
/
Insert into PED_Special (Id,Name) values (0,'ALL');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE PED_Doct_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE PED_Doctors                                                                          -- جدول الأطباء
( Id          Number(5) NOT NULL,                                                                  -- PK
  Name        Varchar2(100 Char) NOT NULL,                                                         -- Name
  DoB         date NOT NULL,                                                                       -- Birthdate
  Status_id   Number(3) DEFAULT 1 NOT NULL,                                                         -- Status
  Gender_Id   Number(3) DEFAULT 1 NOT NULL,                                                        -- Gender
  Special_Id  Number(5) DEFAULT 0 NOT NULL,                                                        -- Speciality
  NatNum      Varchar2(25 Char),                                                                   -- National Id
  Mobile      Varchar2(100 Char) NOT NULL,                                                         -- Mobile
  Phone1      Varchar2(25 Char),                                                                   -- Phone 1
  Phone2      Varchar2(25 Char),                                                                   -- Phone 2
  Email       Varchar2(75 Char),                                                                   -- Email
  Langs       Varchar2(100 Char),                                                                  -- Languages Known
  Descr       Varchar2(100 Char),                                                                  -- Description
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT PED_Doctor_PK         PRIMARY KEY (Id    ),
  CONSTRAINT PED_Doctor_Mobile_UK  UNIQUE      (Mobile),
  CONSTRAINT PED_Doctor_Status_FK  Foreign Key (Status_id ) References Phs_Cod_Status (Id),
  CONSTRAINT PED_Doctor_Gender_FK  Foreign Key (Gender_Id ) References Phs_Cod_Gender (Id),
  CONSTRAINT PED_Doctor_Special_FK Foreign Key (Special_Id) References PED_Special    (Id),
  CONSTRAINT PED_Doctor_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT PED_Doctor_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym PED_Doct For PED_Doctors
/
----------------------------------------------------------------------------------------------------
CREATE TABLE PED_Appointment_Status                                                               -- جدول حالات المواعيد
( Id         Number(2) NOT NULL,                                                                   -- PK
  Name       Varchar2(100 Char) NOT NULL,                                                          -- Name
  BG         Varchar2(10 Char) DEFAULT '#CCC' NOT NULL,                                            -- Title Background Color
  FG         Varchar2(10 Char) DEFAULT '#000' NOT NULL,                                            -- Title Text Color
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT PED_App_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT PED_App_Status_UK     UNIQUE      (Name),
  CONSTRAINT PED_App_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT PED_App_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym PED_App_Status For PED_Appointment_Status
/
Insert into PED_App_Status (Id,Name,BG,FG) values (0,'New','#CCC','#000');
Insert into PED_App_Status (Id,Name,BG,FG) values (1,'Waiting','#CCC','#000');
Insert into PED_App_Status (Id,Name,BG,FG) values (2,'Progress','#CCC','#000');
Insert into PED_App_Status (Id,Name,BG,FG) values (3,'Done','#CCC','#000');
Insert into PED_App_Status (Id,Name,BG,FG) values (4,'Late','#CCC','#000');
Insert into PED_App_Status (Id,Name,BG,FG) values (5,'No Show','#CCC','#000');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE PED_App_Type_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE PED_Appointment_Type                                                                 -- جدول أنواع المواعيد
( Id         Number(5) NOT NULL,                                                                   -- PK
  Capacity   Number(3) DEFAULT 0 NOT NULL,                                                         -- Capacity
  Minutes    Number(3) DEFAULT 15 NOT NULL,                                                        -- Appointment Minutes
  Name       Varchar2(100 Char) NOT NULL,                                                          -- Name
  Title_BG   Varchar2(10 Char) DEFAULT '#CCC' NOT NULL,                                            -- Title Background Color
  Title_FG   Varchar2(10 Char) DEFAULT '#000' NOT NULL,                                            -- Title Text Color
  Patient_FG Varchar2(10 Char) DEFAULT '#777' NOT NULL,                                            -- Patient Name Text Color
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT PED_App_Type_PK     PRIMARY KEY (Id  ),
  CONSTRAINT PED_App_Type_UK     UNIQUE      (Name),
  CONSTRAINT PED_App_Type_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT PED_App_Type_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym PED_App_Type For PED_Appointment_Type
/
Insert into PED_App_Type (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
--CREATE SEQUENCE PED_Doct_App_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
--CREATE TABLE PED_Doctors_Appointment                                                                 -- جدول أنواع المواعيد
--( Id         Number(5) NOT NULL,                                                                   -- PK
--  Capacity   Number(3) DEFAULT 0 NOT NULL,                                                         -- Capacity
--  Minutes    Number(3) DEFAULT 15 NOT NULL,                                                        -- Appointment Minutes
--  Name       Varchar2(100 Char) NOT NULL,                                                          -- Name
--  Title_BG   Varchar2(10 Char) DEFAULT '#CCC' NOT NULL,                                            -- Title Background Color
--  Title_FG   Varchar2(10 Char) DEFAULT '#000' NOT NULL,                                            -- Title Text Color
--  Patient_FG Varchar2(10 Char) DEFAULT '#777' NOT NULL,                                            -- Patient Name Text Color
--  Ins_User   Number(5), Ins_Date   Date,
--  Upd_User   Number(5), Upd_Date   Date,
--  CONSTRAINT PED_Doct_App_Type_PK     PRIMARY KEY (Id  ),
--  CONSTRAINT PED_Doct_App_Type_UK     UNIQUE      (Name),
--  CONSTRAINT PED_Doct_App_Type_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
--  CONSTRAINT PED_Doct_App_Type_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
--)
--/
--Create Synonym PED_Doct_App For PED_Doctors_Appointment
--/
--Insert into PED_Doct_App (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE PED_App_Sched_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE PED_Appointment_Sched                                                                 -- جدول المواعيد
( Id            Number(9) NOT NULL,                                                                  -- PK
  Special_Id    Number(3) DEFAULT 0 NOT NULL,                                                        -- Speciality
  Status_Id     Number(2) DEFAULT 10 NOT NULL,                                                       -- Status
  Type_Id       Number(3) NOT NULL,                                                                  -- Type
  Doctor_Id     Number(3) NOT NULL,                                                                  -- Doctor
  Patient_Name  Varchar2(256 Char) NOT NULL,                                                         -- Patient
  dDate         Date NOT NULL,                                                                       -- Date
  nHour         Number(3) DEFAULT 0 NOT NULL,                                                        -- Appointment Hour
  nMinute       Number(3) DEFAULT 0 NOT NULL,                                                        -- Appointment Minute
  Minutes       Number(9) DEFAULT 15 NOT NULL,                                                       -- Appointment Minutes
  Amt           Number(25,3) DEFAULT 0 NOT NULL,                                                     -- Payment Amount
  Descr         Varchar2(512 Char),                                                                  -- Description
  Ins_User      Number(5), Ins_Date   Date,
  Upd_User      Number(5), Upd_Date   Date,
  CONSTRAINT  PED_App_Sched_PK         PRIMARY KEY (Id),
  CONSTRAINT  PED_App_Sched_UK         UNIQUE      (Doctor_Id, dDate, nHour, nMinute),
  CONSTRAINT  PED_App_Sched_Doctor_FK  Foreign Key (Doctor_Id ) References PED_Doct       (Id),
  CONSTRAINT  PED_App_Sched_Status_FK  Foreign Key (Status_Id ) References PED_App_Status(Id),
  CONSTRAINT  PED_App_Sched_Type_FK    Foreign Key (Type_Id   ) References PED_App_Type  (Id),
  CONSTRAINT  PED_App_Sched_Special_FK Foreign Key (Special_Id) References PED_Special   (Id),
  CONSTRAINT  PED_App_Sched_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT  PED_App_Sched_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym PED_App_Sched For PED_Appointment_Sched
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE PED_App_Change_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE PED_Appointment_Change                                                               -- جدول تبدل حالات موعد
( Id         Number(9) NOT NULL,                                                                   -- PK
  App_Id     Number(9) NOT NULL,                                                                   -- Appointment
  Status_Id  Number(3) NOT NULL,                                                                   -- Status
  dDate      Date DEFAULT SYSDATE NOT NULL,                                                        -- Date
  Reason     Varchar2(256 Char),                                                                   -- Reason
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date, 
  CONSTRAINT  PED_App_Change_PK        PRIMARY KEY (Id),
  CONSTRAINT  PED_App_Change_App_FK    Foreign Key (App_Id   ) References PED_App       (Id),
  CONSTRAINT  PED_App_Change_Status_FK Foreign Key (Status_Id) References PED_App_Status(Id),
  CONSTRAINT  PED_App_Change_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT  PED_App_Change_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym PED_App_Change For PED_Appointment_Change
/
