Create Sequence EmpId_Seq    MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
/*
Create Sequence Emp_FChart_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Functional_Chart                    -- هيكل وظيفي
( Id           Number(5) NOT NULL,                   -- مفتاح رئيسي
  PId          Number(5) DEFAULT 0,                  -- الأب
  Code         Varchar2(25 Char) NOT NULL,           -- الرمز
  Name         Varchar2(250 Char) NOT NULL,          -- الاسم
  Name2        Varchar2(250 Char),                   -- الاسم
  Description  Varchar2(512 Char),                   -- وصف
  Rem          Varchar2(250 Char),                   -- ملاحظات
  Ins_User     Number(5), Ins_Date Date,
  Upd_User     Number(5), Upd_Date Date,
  CONSTRAINT Emp_FChart_PK        PRIMARY KEY (Id),
  CONSTRAINT Emp_FChart_UK        UNIQUE      (Code),
  CONSTRAINT Emp_FChart_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT Emp_FChart_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Emp_FChart For Emp_Functional_Chart
/
Insert into Emp_FChart (Id, PId, Code, Name, Name2) VALUES (0, 0, '-', '-', '-');
ALTER TABLE Emp_Functional_Chart ADD CONSTRAINT Emp_FChart_PID_FK Foreign Key (PId) References Emp_FChart(Id);

Create Sequence Emp_OChart_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Organization_Chart                  -- هيكل تنظيمي
( Id           Number(5) NOT NULL,                   -- مفتاح رئيسي
  PId          Number(5) DEFAULT 0,                  -- الأب
  Code         Varchar2(25 Char) NOT NULL,           -- الرمز
  Name         Varchar2(250 Char) NOT NULL,          -- الاسم
  Name2        Varchar2(250 Char),                   -- الاسم
  Description  Varchar2(512 Char),                   -- وصف
  Rem          Varchar2(250 Char),                   -- ملاحظات
  Ins_User     Number(5), Ins_Date Date,
  Upd_User     Number(5), Upd_Date Date,
  CONSTRAINT Emp_Ohart_PK     PRIMARY KEY (Id),
  CONSTRAINT Emp_Ohart_UK     UNIQUE      (Code),
  CONSTRAINT Emp_Ohart_Ins_FK Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Emp_Ohart_Upd_FK Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Emp_OChart For Emp_Organization_Chart
/
Insert into Emp_OChart (Id, PId, Code, Name, Name2) VALUES (0, 0, '-', '-', '-');
ALTER TABLE Emp_Organization_Chart ADD CONSTRAINT Emp_OChart_PID_FK Foreign Key (PId) References Emp_OChart(Id);

Create Sequence Emp_Org_Func_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Organization_Function     -- جدول وظائف الهيكل التنيظيمي
( Id           Number(9) NOT NULL,               -- مفتاح رئيسي
  OChart_Id    Number(5) NOT NULL,               -- الأب
  FChart_Id    Number(5) NOT NULL,               -- الوظيفة
  Emp_Count    Number(2) NOT NULL,               -- الملاك
  Description  Varchar2(512 Char),               -- وصف
  Rem          Varchar2(250 Char),               -- ملاحظات
  Ins_User     Number(5), Ins_Date Date,
  Upd_User     Number(5), Upd_Date Date,
  CONSTRAINT Emp_Org_Func_PK        PRIMARY KEY (Id),
  CONSTRAINT Emp_Org_Func_UK        UNIQUE      (OChart_Id, FChart_Id),
  CONSTRAINT Emp_Org_Func_OChart_FK Foreign Key (OChart_Id) References Emp_OChart (Id),
  CONSTRAINT Emp_Org_Func_FChart_FK Foreign Key (FChart_Id) References Emp_FChart (Id),
  CONSTRAINT Emp_Org_Func_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT Emp_Org_Func_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Emp_Org_Func For Emp_Organization_Function
/

Create Sequence Emp_OFunc_Comp_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Org_Func_Compensation            -- تعويضات وظائف الهيكل التنيظيمي 
( Id         Number(9),                               -- مفتاح رئيسي
  OFunc_Id   Number(9) NOT NULL,                      -- وظيفة الهيكل التنيظيمي
  Com_Id     Number(5) NOT NULL,                      -- التعويض
  SDate      Date NOT NULL,                           -- بداية
  EDate      Date NOt NULL,                           -- نهاية
  Status_Id  Number(1) Default 1,                     -- حالة التثبيت
  Curn_Id    Number(3) NOT NULL,				                  -- مفتاح العملة
  PAmt       Number(25,3) Default 0,                  -- نسبة\مبلغ
  MaxAmt     Number(25,3) Default 0,                  -- مبلغ /نسبة سقف التعويض
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Emp_OFunc_Comp_PK          Primary Key (Id ),
  CONSTRAINT Emp_OFunc_Comp_ENum_UK     Unique      (OFunc_Id, Com_Id),
  CONSTRAINT Emp_OFunc_Comp_OFunc_Id_FK Foreign Key (OFunc_Id ) REFERENCES Emp_Org_Func    (Id),
  CONSTRAINT Emp_OFunc_Comp_Status_Fk   FOREIGN KEY (Status_Id) REFERENCES Phs_Cod_Status  (Id),
  CONSTRAINT Emp_OFunc_Comp_Curn_FK     Foreign Key (Curn_Id  ) References Mng_Curn        (Id),
  CONSTRAINT Emp_OFunc_Comp_Com_FK      Foreign Key (Com_Id   ) REFERENCES Emp_Com         (Id),
  CONSTRAINT Emp_OFunc_Comp_Ins_FK      Foreign Key (Ins_User ) References Cpy_User        (Id),
  CONSTRAINT Emp_OFunc_Comp_Upd_FK      Foreign Key (Upd_User ) References Cpy_User        (Id)
)
/
Create Synonym Emp_OFunc_Comp For Emp_Org_Func_Compensation
/

Create Sequence Emp_OFunc_Ded_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Org_Func_Deduction               -- حسميات وظائف الهيكل التنيظيمي
( Id         Number(9),                               -- مفتاح رئيسي
  OFunc_Id   Number(9) NOT NULL,                      -- وظيفة الهيكل التنيظيمي
  Ded_Id     Number(5) NOT NULL,                      -- الحسمية
  SDate      Date NOT NULL,                           -- بداية
  EDate      Date NOt NULL,                           -- نهاية
  Status_Id  Number(1) Default 1,                     -- حالة التثبيت
  Curn_Id    Number(3) NOT NULL,				                  -- مفتاح العملة
  PAmt       Number(25,3) Default 0,                  -- نسبة\مبلغ
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Emp_OrgFunDed_PK             Primary Key (Id),
  CONSTRAINT Emp_OrgFunDed_ENum_UK        Unique      (OFunc_Id, Ded_Id),
  CONSTRAINT Emp_OrgFunDed_OrgFunc_Ded_FK Foreign Key (OFunc_Id ) REFERENCES Emp_Org_Func     (Id),
  CONSTRAINT Emp_OrgFunDed_Status_Fk      FOREIGN KEY (Status_Id) REFERENCES Phs_Cod_Status   (Id),
  CONSTRAINT Emp_OrgFunDed_Ded_FK         Foreign Key (Ded_Id   ) REFERENCES Emp_Ded          (Id),
  CONSTRAINT Emp_OrgFunDed_Curn_FK        Foreign Key (Curn_Id  ) References Mng_Curn         (Id),
  CONSTRAINT Emp_OrgFunDed_Ins_FK         Foreign Key (Ins_User ) References Cpy_User         (Id),
  CONSTRAINT Emp_OrgFunDed_Upd_FK         Foreign Key (Upd_User ) References Cpy_User         (Id)
)
/
Create Synonym Emp_OFunc_Ded For Emp_Org_Func_Deduction
/
*/
Create Sequence EMP_RECR_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Recruitment                         -- التوظيف
( Id         Number(5) NOT NULL,                     -- مفتاح رئيسي
  Num        Number(9),                              -- الرقم
  dDate      Date,                                   -- التاريخ
  SDate      Date,                                   -- تاريخ بداية الإعلان
  EDate      Date,                                   -- تاريخ نهاية الإعلان
  Code       Varchar2(25 Char),                      -- الرمز
  Name       Varchar2(250 Char),                     -- الاسم
  GenInfo    Varchar2(1024 Char),                    -- General Information معلومات عامة
  PosPurp    Varchar2(1024 Char),                    -- Position Purpose المنصب المستهدف
  EssenFunc  Varchar2(1024 Char),                    -- Essential Functions الوظائف الأساسية
  MinReq     Varchar2(1024 Char),                    -- Minimum Requirements الحد الأدنى من المتطلبات
  PrefQlfy   Varchar2(1024 Char),                    -- Preferred Qualifications المؤهلات المفضلة
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Emp_Recr_PK        PRIMARY KEY (Id),
  CONSTRAINT Emp_Recr_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT Emp_Recr_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Emp_Recr For Emp_Recruitment
/

Create Sequence EMP_APPL_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application                         -- طلبات التوظيف
( Id           Number(5) NOT NULL,                   -- مفتاح رئيسي
  Recr_Id      Number(5) NOT NULL,                   -- مفتاح الأب
  Num          Number(9),                            -- رقم الطلب
  dDate        Date Default sysdate,                 -- تاريخ الطلب
  Name         Varchar2(100 Char) NOT NULL,          -- الاسم
  Father       Varchar2(50 Char),                    -- الأب
  Mother       Varchar2(50 Char),                    -- الأم
  PBirth       Varchar2(100 Char),                   -- مكان الولادة
  DBirth       Date,                                 -- تاريخ الولادة
  NatNum       Varchar2(30 Char),                    -- الرقم الوطني
  Kied         Varchar2(30 Char),                    -- محل و رقم القيد
  Phone        Varchar2(50 Char),                    -- هاتف
  Mobile       Varchar2(50 Char),                    -- موبايل
  EMail        Varchar2(50 Char),                    -- البريد الإلكتروني
  Address      Varchar2(512 Char),                   -- عنوان
  Gender_Id    Number(1) Default 1,                  -- الجنس
  Military_Id  Number(1) Default 1,                  -- خدمة العلم
  Martial_Id   Number(2) Default 0,                  -- الحالة الإجتماعية
  Nat_Id       Number(5) Default 0,                  -- الجنسية
  Status_Id    Number(1) Default 0,                  -- حالة الطلب
  Result_Id    Number(2) Default 0,                  -- النتيجة
  ReqSal       Number(25,3) Default 0,               -- الراتب المطلوب
  Language_Id  Number(2) Default 0,                  -- علامة اختبار اللغة
  Computer_Id  Number(2) Default 0,                  -- علامة اختبار الكمبيوتر
  Technical_Id Number(2) Default 0,                  -- علامة اختبار تقني
  Interview_Id Number(2) Default 0,                  -- علامة المقابلة
  Rem          Varchar2(250 Char),                   -- ملاحظات
  Ins_User     Number(5), Ins_Date Date,
  Upd_User     Number(5), Upd_Date Date,
  CONSTRAINT Emp_App_PK           PRIMARY KEY (Id),
  CONSTRAINT Emp_App_Num          UNIQUE      (Num),
  CONSTRAINT Emp_App_Recr_FK      Foreign Key (Recr_Id     ) References Emp_Recr          (Id),
  CONSTRAINT Emp_App_Gender_FK    Foreign Key (Gender_Id   ) References Phs_Cod_Gender    (Id),
  CONSTRAINT Emp_App_Military_FK  Foreign Key (Military_Id ) References Phs_Cod_Military  (Id),
  CONSTRAINT Emp_App_Martial_FK   Foreign Key (Martial_Id  ) References Phs_Cod_Marital   (Id),
  CONSTRAINT Emp_App_Nat_FK       Foreign Key (Nat_Id      ) References Emp_Cod_Nat       (Id),
  CONSTRAINT Emp_App_Status_FK    Foreign Key (Status_Id   ) References Emp_Cod_App_Status(Id),
  CONSTRAINT Emp_App_Result_FK    Foreign Key (Result_Id   ) References Emp_Cod_App_Result(Id),
  CONSTRAINT Emp_App_Language_FK  Foreign Key (Language_Id ) References Emp_Cod_AppTest   (Id),
  CONSTRAINT Emp_App_Computer_FK  Foreign Key (Computer_Id ) References Emp_Cod_AppTest   (Id),
  CONSTRAINT Emp_App_Techbical_FK Foreign Key (Technical_Id) References Emp_Cod_AppTest   (Id),
  CONSTRAINT Emp_App_Interview_FK Foreign Key (Interview_Id) References Emp_Cod_AppTest   (Id),
  CONSTRAINT Emp_App_Ins_FK       Foreign Key (Ins_User    ) References Cpy_User          (Id),
  CONSTRAINT Emp_App_Upd_FK       Foreign Key (Upd_User    ) References Cpy_User          (Id)
)
/
Create Synonym Emp_Appl For Emp_Application
/

Create Sequence EMP_APPLANG_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application_Language                -- طلبات التوظيف - اللغات
( Id             Number(10) NOT NULL,                -- مفتاح رئيسي
  MApp_Id        Number(5) NOT NULL,                 -- مفتاح الأب
  Lang_Id        Number(2) Default 0,                -- اللغة
  Read_Id        Number(1) Default 0,                -- قراءة
  Write_Id       Number(1) Default 0,                -- كتابة
  Speak_Id       Number(1) Default 0,                -- محادثة
  Rem            Varchar2(250 Char),                 -- ملاحظات
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_AppLang_PK        PRIMARY KEY (Id      ),
  CONSTRAINT     Emp_AppLang_Appl_FK   Foreign Key (MApp_Id ) References Emp_Appl        (Id),
  CONSTRAINT     Emp_AppLang_Lang_FK   Foreign Key (Lang_Id ) References Emp_Cod_Lang    (Id),
  CONSTRAINT     Emp_AppLang_Read_FK   Foreign Key (Read_Id ) References Emp_Cod_TestMark(Id),
  CONSTRAINT     Emp_AppLang_Write_FK  Foreign Key (Write_Id) References Emp_Cod_TestMark(Id),
  CONSTRAINT     Emp_AppLang_Speak_FK  Foreign Key (Speak_Id) References Emp_Cod_TestMark(Id),
  CONSTRAINT     Emp_AppLang_Ins_FK    Foreign Key (Ins_User) References Cpy_User        (Id),
  CONSTRAINT     Emp_AppLang_Upd_FK    Foreign Key (Upd_User) References Cpy_User        (Id)
)
/
Create Synonym Emp_AppLang For Emp_Application_Language
/

Create Sequence EMP_APPEDUC_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application_Education               -- طلبات التوظيف - الشهادات
( Id             Number(20) NOT NULL,                -- مفتاح رئيسي
  MApp_Id        Number(5) NOT NULL,                 -- مفتاح الأب
  University     Varchar2(250 Char),                 -- الجامعة/الكلية
  Edu_Id         Number(5) Default 0,                -- الحالة التعليمية - الشهادة
  nYear          Varchar2(10 Char),                  -- السنة
  Rem            Varchar2(250 Char),                 -- الوصف
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_AppEduc_PK        PRIMARY KEY (Id       ),
  CONSTRAINT     Emp_AppEduc_Appl_FK   Foreign Key (MApp_Id  ) References Emp_Appl   (Id),
  CONSTRAINT     Emp_AppEduc_Educ_FK   Foreign Key (Edu_Id   ) References Emp_Cod_Edu(Id),
  CONSTRAINT     Emp_AppEduc_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT     Emp_AppEduc_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Emp_AppEduc For Emp_Application_Education
/

Create Sequence EMP_APPCOURSE_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application_Course                  -- طلبات التوظيف - الدورات
( Id             Number(20) NOT NULL,                -- مفتاح رئيسي
  MApp_Id        Number(5) NOT NULL,                 -- مفتاح الأب
  Course         Varchar2(250 Char),                 -- الدورة
  Place          Varchar2(250 Char),                 -- مكان الدورة
  SDate          Date,                               -- تاريخ بداية
  EDate          Date,                               -- تاريخ نهاية
  Rem            Varchar2(250 Char),                 -- الوصف
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_AppCourse_PK        PRIMARY KEY (Id      ),
  CONSTRAINT     Emp_AppCourse_Appl_FK   Foreign Key (MApp_Id ) References Emp_Appl(Id),
  CONSTRAINT     Emp_AppCourse_Ins_FK    Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT     Emp_AppCourse_Upd_FK    Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_AppCourse For Emp_Application_Course
/

Create Sequence EMP_APPJOB_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application_Job                     -- طلبات التوظيف - الوظائف السابقة
( Id             Number(20) NOT NULL,                -- مفتاح رئيسي
  MApp_Id        Number(5) NOT NULL,                 -- مفتاح الأب
  Position       Varchar2(250 Char),                 -- المنصب
  Company        Varchar2(250 Char),                 -- الشركة
  SDate          Date,                               -- تاريخ بداية
  EDate          Date,                               -- تاريخ نهاية
  ReqSal         Number(25,3) Default 0,             -- الراتب
  Reason         Varchar2(250 Char),                 -- سبب ترك العمل
  Rem            Varchar2(250 Char),                 -- الوصف
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_AppJob_PK        PRIMARY KEY (Id      ),
  CONSTRAINT     Emp_AppJob_Appl_FK   Foreign Key (MApp_Id ) References Emp_Appl(Id),
  CONSTRAINT     Emp_AppJob_Ins_FK    Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT     Emp_AppJob_Upd_FK    Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_AppJob For Emp_Application_Job
/

Create Sequence EMP_APPHRNOTE_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application_HRNote                  -- طلبات التوظيف - ملاحظات قسم الذاتية
( Id             Number(20) NOT NULL,                -- مفتاح رئيسي
  MApp_Id        Number(5) NOT NULL,                 -- مفتاح الأب
  Note           Varchar2(250 Char),                 -- الوصف
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_AppHRNote_PK        PRIMARY KEY (Id      ),
  CONSTRAINT     Emp_AppHRNote_Appl_FK   Foreign Key (MApp_Id ) References Emp_Appl(Id),
  CONSTRAINT     Emp_AppHRNote_Ins_FK    Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT     Emp_AppHRNote_Upd_FK    Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_AppHRNote For Emp_Application_HRNote
/

Create Sequence EMP_APPVIEWER_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application_Interviewer             -- طلبات التوظيف - الذين أجروا المقابلة
( Id             Number(20) NOT NULL,                -- مفتاح رئيسي
  MApp_Id        Number(5) NOT NULL,                 -- مفتاح الأب
  Name           Varchar2(100 Char),                 -- الوصف
  dDate          Date,                               -- التاريخ
  Rem            Varchar2(250 Char),                 -- الملاحظات
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_AppViewer_PK        PRIMARY KEY (Id      ),
  CONSTRAINT     Emp_AppViewer_Appl_FK   Foreign Key (MApp_Id ) References Emp_Appl  (Id),
  CONSTRAINT     Emp_AppViewer_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT     Emp_AppViewer_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Emp_AppViewer For Emp_Application_Interviewer
/

Create Sequence EMP_APPFOR_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application_AppliedFor              -- طلبات التوظيف - الوظيفة المتقدم لها
( Id             Number(20) NOT NULL,                -- مفتاح رئيسي
  MApp_Id        Number(5) NOT NULL,                 -- مفتاح الأب
  Name           Varchar2(100 Char),                 -- الوظيفة
  Rem            Varchar2(250 Char),                 -- الملاحظات
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_AppFor_PK        PRIMARY KEY (Id      ),
  CONSTRAINT     Emp_AppFor_Appl_FK   Foreign Key (MApp_Id ) References Emp_Appl  (Id),
  CONSTRAINT     Emp_AppFor_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT     Emp_AppFor_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Emp_AppFor For Emp_Application_AppliedFor
/

Create Sequence EMP_APPFIT_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application_FitFor                  -- طلبات التوظيف - الوظيفة التي يمكن أن يشغلها
( Id             Number(20) NOT NULL,                -- مفتاح رئيسي
  MApp_Id        Number(5) NOT NULL,                 -- مفتاح الأب
  Name           Varchar2(100 Char),                 -- الوظيفة
  Rem            Varchar2(250 Char),                 -- الملاحظات
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_AppFit_PK        PRIMARY KEY (Id      ),
  CONSTRAINT     Emp_AppFit_Appl_FK   Foreign Key (MApp_Id ) References Emp_Appl  (Id),
  CONSTRAINT     Emp_AppFit_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT     Emp_AppFit_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Emp_AppFit For Emp_Application_FitFor
/

Create Sequence EMP_APPVIA_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application_AppliedVia              -- طلبات التوظيف - عن طريق
( Id             Number(20) NOT NULL,                -- مفتاح رئيسي
  MApp_Id        Number(5) NOT NULL,                 -- مفتاح الأب
  Name           Varchar2(250 Char),                 -- الاسم
  Rem            Varchar2(250 Char),                 -- ملاحظات
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_AppVia_PK        PRIMARY KEY (Id      ),
  CONSTRAINT     Emp_AppVia_Appl_FK   Foreign Key (MApp_Id ) References Emp_Appl  (Id),
  CONSTRAINT     Emp_AppVia_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT     Emp_AppVia_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Emp_AppVia For Emp_Application_AppliedVia
/

Create Sequence EMP_APPREF_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Application_References              -- طلبات التوظيف - المراجع
( Id             Number(20) NOT NULL,                -- مفتاح رئيسي
  MApp_Id        Number(5) NOT NULL,                 -- مفتاح الأب
  Name           Varchar2(250 Char),                 -- الاسم
  Pos            Varchar2(250 Char),                 -- العمل/المنصب
  Cont           Varchar2(250 Char),                 -- معلومات الاتصال
  Rem            Varchar2(250 Char),                 -- ملاحظات
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_AppRef_PK        PRIMARY KEY (Id       ),
  CONSTRAINT     Emp_AppRef_Appl_FK   Foreign Key (MApp_Id  ) References Emp_Appl  (Id),
  CONSTRAINT     Emp_AppRef_Ins_FK    Foreign Key (Ins_User ) References Cpy_User  (Id),
  CONSTRAINT     Emp_AppRef_Upd_FK    Foreign Key (Upd_User ) References Cpy_User  (Id)
)
/
Create Synonym Emp_AppRef For Emp_Application_References
/

Create Sequence EMP_ACR_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Accredited                          -- دليل معتمدي الرواتب
( Id          Number(5),                             -- مفتاح رئيسي
  Name        Varchar2(100 Char),                    -- الاسم
  Rem         Varchar2(100 Char),                    -- ملاحظات
  Ins_User    Number(20), Ins_Date   Date,
  Upd_User    Number(20), Upd_Date   Date,
  Constraint  Emp_Acr_PK      Primary Key (Id  ),
  Constraint  Emp_Acr_Nam_UK  UNIQUE      (Name),
  CONSTRAINT  Emp_Acr_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT  Emp_Acr_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Emp_Acr For Emp_Accredited
/
INSERT INTO Emp_Acr (Id, Name) VALUES ('0', '-');

Create Sequence EMP_TAXBRKT_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Tax_Brackets_Master                 -- دليل الشرائح الضريبية
( Id         Number(5),                              -- مفتاح رئيسي
  Num        Number(5),                              -- الرقم
  Name       Varchar2(100 Char),                     -- الاسم
  dDate      Date Default SysDate,                   -- التاريخ
  GNum       Varchar2(10 Char),                      -- رقم القرار الحكومي
  GDate      Date Default SysDate,                   -- تاريخ القرار الحكومي
  Rem        Varchar2(250 Char),                     -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_TaxBrkt_PK      Primary Key (Id  ),
  Constraint Emp_TaxBrkt_Num_UK  UNIQUE      (Num ),
  Constraint Emp_TaxBrkt_Nam_UK  UNIQUE      (Name),
  CONSTRAINT Emp_TaxBrkt_Ins_FK  Foreign Key (Ins_User ) References Cpy_User (Id),
  CONSTRAINT Emp_TaxBrkt_Upd_FK  Foreign Key (Upd_User ) References Cpy_User (Id)
)
/
Create Synonym Emp_TaxBrkt For Emp_Tax_Brackets_Master
/
INSERT INTO Emp_TaxBrkt (Id, Num, Name) VALUES ('0', '0', '-');

Create Sequence EMP_TTAXBRKT_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Tax_Brackets_Trans                  -- تفصيل شرائح الضريبة
( Id         Number(5),                              -- مفتاح رئيسي
  Brkt_Id    Number(5),                              -- الشرائح
  SAmt       Number(25,3) Default 0,                 -- من المبلغ
  EAmt       Number(25,3) Default 0,                 -- إلى المبلغ
  Type_Id    Number(1) Default 1,                    -- نوع الضريبة \1 نسبة \0 مبلغ مقطوع
  Tax        Number(25,3) Default 0,                 -- الضربة
  Rem        Varchar2(250 Char),                     -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_TTaxBrkt_PK      Primary Key (Id      ),
  Constraint Emp_TTaxBrkt_Brkt_FK Foreign Key (Brkt_Id ) REFERENCES Emp_TaxBrkt    (Id),
  Constraint Emp_TTaxBrkt_Type_FK Foreign Key (Type_Id ) REFERENCES Phs_Cod_AmtType(Id),
  CONSTRAINT Emp_TTaxBrkt_Ins_FK  Foreign Key (Ins_User) References Cpy_User       (Id),
  CONSTRAINT Emp_TTaxBrkt_Upd_FK  Foreign Key (Upd_User) References Cpy_User       (Id)
)
/
Create Synonym Emp_TTaxBrkt For Emp_Tax_Brackets_Trans
/

Create Sequence EMP_COM_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Compensation                        -- دليل التعويضات الدائمة
( Id           Number(5),                            -- مفتاح رئيسي
  Num          Number(5) NOT NULL,                   -- الرقم
  Name         Varchar2(100 Char) NOT NULL,          -- الاسم
  Brkt_Id      Number(5) Default 0,                  -- مفتاح الشرائح الضريبية
  ComType_Id   Number(1) Default 1,                  -- النوع 1 تعويض \ 2 متمم راتب
  TaxPay_Id    Number(1) Default 1,                  -- حالة الضريبة \ 1 يدفعها العامل \ 2 يدفعها رب العمل
  Type_Id      Number(1) Default 1,                  -- النوع \1 نسبة \2 مبلغ
  IsDed_Id     Number(1) Default 2,                  -- هل يدخل في كتلة الحسميات في حال الغياب والتأخير و غيرها
  MaxType_Id   Number(1) Default 1,                  -- هل السقف نبلغ أو تعويض 
  MaxSalTyp_Id Number(1) Default 1,                  -- الرتاب الذي يحسب منه السقف 
  PAmt         Number(25,3) Default 0,               -- النسبة
  MaxAmt       Number(25,3) Default 0,               -- مبلغ سقف التعويض
  Ins_User     Number(5), Ins_Date Date,
  Upd_User     Number(5), Upd_Date Date,
  Constraint   Emp_Com_PK           Primary Key (Id  ),
  Constraint   Emp_Com_Num_UK       Unique      (Num ),
  Constraint   Emp_Com_Nam_UK       UNIQUE      (Name),
  Constraint   Emp_Com_Brkt_FK      Foreign Key (Brkt_Id     ) REFERENCES Emp_TaxBrkt    (Id),
  Constraint   Emp_Com_Kind_FK      Foreign Key (ComType_Id  ) REFERENCES Emp_Cod_ComType(Id),
  Constraint   Emp_Com_Tax_FK       Foreign Key (TaxPay_Id   ) REFERENCES Emp_Cod_TaxPay (Id),
  Constraint   Emp_Com_Type_FK      Foreign Key (Type_Id     ) REFERENCES Phs_Cod_AmtType(Id),
  Constraint   Emp_Com_IsDed_FK     Foreign Key (IsDed_Id    ) REFERENCES Phs_Cod_YesNo  (Id),
  CONSTRAINT   Emp_Com_MaxSalTyp_FK Foreign Key (MaxSalTyp_Id) REFERENCES Emp_Cod_AffSal (Id),
  CONSTRAINT   Emp_Com_MaxType_FK   Foreign Key (MaxType_Id  ) REFERENCES Phs_Cod_AmtType(Id),
  CONSTRAINT   Emp_Com_Ins_FK       Foreign Key (Ins_User    ) References Cpy_User       (Id),
  CONSTRAINT   Emp_Com_Upd_FK       Foreign Key (Upd_User    ) References Cpy_User       (Id)
)
/
Create Synonym Emp_Com For Emp_Compensation
/

Create Sequence EMP_DED_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Deduction                            -- دليل الحسميات
( Id         Number(5),                               -- مفتاح رئيسي
  Num        Number(5),                               -- الرقم
  Name       Varchar2(100 Char),                      -- الاسم
  Type_Id    Number(1) Default 1,                     -- النوع \1 نسبة \0 مبلغ
  Brkt_Id    Number(5) Default 0,                     -- مفتاح الشرائح الضريبية
  TaxPay_Id  Number(1) Default 1,                     -- حالة الضريبة \ 1 يدفعها العامل \ 2 يدفعها رب العمل
  Amt        Number(25,3) Default 0,                  -- النسبة
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  Constraint Emp_Ded_PK      Primary Key (Id  ),
  Constraint Emp_Ded_Num_UK  Unique      (Num ),
  Constraint Emp_Ded_Nam_UK  UNIQUE      (Name),
  Constraint Emp_Ded_Type_FK Foreign Key (Type_Id  ) REFERENCES Phs_Cod_AmtType(Id),
  Constraint Emp_Ded_Brkt_FK Foreign Key (Brkt_Id  ) REFERENCES Emp_TaxBrkt    (Id),
  Constraint Emp_Ded_Tax_FK  Foreign Key (TaxPay_Id) REFERENCES Emp_Cod_TaxPay (Id),
  CONSTRAINT Emp_Ded_Ins_FK  Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Emp_Ded_Upd_FK  Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Emp_Ded For Emp_Deduction
/

Create Sequence EMP_WRKGRP_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Work_Groups                         -- دليل مجموعات الدوام
( Id            Number(5),                          -- مفتاح رئيسي
  Num           Number(5),                           -- الرقم
  Name          Varchar2(100 Char),                  -- الاسم
  Type_Id       Number(1) Default 1,                 -- طبيعة الوردية 1=عامة لكل الأيام \ 2=أسبوعية \ 3=شهرية
  Ins_User      Number(5), Ins_Date   Date,
  Upd_User      Number(5), Upd_Date   Date,
  Constraint    Emp_WGrp_PK      Primary Key (Id  ),
  Constraint    Emp_WGrp_Num_UK  UNIQUE      (Num ),
  Constraint    Emp_WGrp_Nam_UK  UNIQUE      (Name),
  Constraint    Emp_WGrp_Type_FK Foreign Key (Type_Id ) REFERENCES Emp_Cod_WGrp_Type(Id),
  CONSTRAINT    Emp_WGrp_Ins_FK  Foreign Key (Ins_User) References Cpy_User         (Id),
  CONSTRAINT    Emp_WGrp_Upd_FK  Foreign Key (Upd_User) References Cpy_User         (Id)
)
/
Create Synonym Emp_WrkGrp For Emp_Work_Groups
/

Create Sequence EMP_DWRKGRP_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Work_Group_Days                      -- أيام مجموعات العمل
( Id             Number(10),                           -- مفتاح رئيسي
  WGrp_Id        Number(5),                           -- مجموعة العمل
  Day            Number(2),                           -- اليوم من الأسبوع
  Shift_Id       Number(1) Default 1,                 -- الدوام ضمن فترة أو فترتين
  Excuse_Id      Number(1) Default 2,                 -- حالة السماح \1 مجموعة معفاة من العقوبات \ 0 مجموعة عادية
  CrosDays_Id    Number(1) Default 2,                 -- تداخل مع الأيام \ 0 دون تداخل نفس التاريخ \ 1 تداخل يوم \ 2 تداخل يومين
  OTimeStatus_Id Number(1) Default 1,                 -- حالة الإضافي \ 1 نهاري \ 2 ليلي \ 3 دون إضافي
  ComPer_Id      Number(1) Default 1,                 -- صرف التعويض \ 1 بلا \ 2 لكل يوم \ 3 للشهر
  Com_Id         Number(5),                           -- التعويض الذي يدفع لمن يداوم ضمن هذه المجموعة
  St1H           Number(2) Default 0,                 -- ساعة بدء دوام الفترة الأولى
  St1M           Number(2) Default 0,                 -- دقيقة بدء دوام الفترة الأولى
  Ed1H           Number(2) Default 0,                 -- ساعة نهاية دوام الفترة الأولى
  Ed1M           Number(2) Default 0,                 -- دقيقة نهاية دوام الفترة الأولى
  L1H            Number(2) Default 0,                 -- مجال التأخير ساعة الفترة الأولى
  L1M            Number(2) Default 0,                 -- مجال التأخير دقيقة الفترة الأولى
  L1MRound       Number(3) Default 0,                 -- دقائق مجال جبر التأخير للدخول الأول
  E1H            Number(2) Default 0,                 -- مجال الخروج ساعة الفترة الأولى
  E1M            Number(2) Default 0,                 -- مجال الخروج دقيقة الفترة الأولى
  St2H           Number(2) Default 0,                 -- ساعة بدء دوام الفترة الثانية
  St2M           Number(2) Default 0,                 -- دقيقة بدء دوام الفترة الثانية
  Ed2H           Number(2) Default 0,                 -- ساعة نهاية دوام الفترة الثانية
  Ed2M           Number(2) Default 0,                 -- دقيقة نهاية دوام الفترة الثانية
  L2H            Number(2) Default 0,                 -- مجال التأخير ساعة الفترة الثانية
  L2M            Number(2) Default 0,                 -- مجال التأخير دقيقة الفترة الثانية
  L2MRound       Number(3) Default 0,                 -- دقائق مجال جبر التأخير للدخول الثانية
  E2H            Number(2) Default 0,                 -- مجال الخروج ساعة الفترة الثانية
  E2M            Number(2) Default 0,                 -- مجال الخروج دقيقة الفترة الثانية
  FBH            Number(2) Default 0,                 -- ساعة الإستراحة الإجبارية
  FBM            Number(2) Default 0,                 -- دقيقة الإستراحة الإجبارية
  AddH           Number(2) Default 0,                 -- عدد ساعات العمل المطلوب ليحسب الإضافي بعدها
  AddM           Number(2) Default 0,                 -- عدد دقائق العمل المطلوب ليحسب الإضافي بعدها
  ZeroH          Number(2) Default 0,                 -- ساعة الصفر
  ZeroM          Number(2) Default 0,                 -- دقيقة الصفر
  REntH          Number(2) Default 0,                 -- ساعة رفض الدخول المبكر قبل الدوام
  REntM          Number(2) Default 0,                 -- دقيقة رفض الدخول المبكر قبل الدوام
  ROutH          Number(2) Default 0,                 -- ساعة رفض الخروج المتأخر بعد الدوام
  ROutM          Number(2) Default 0,                 -- دقيقة رفض الخروج المتأخر بعد الدوام
  ROMRound       Number(3) Default 0,                 -- دقيقة جبر الخروج المتأخر بعد الدوام
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  Constraint     Emp_DWGrp_PK              Primary Key (Id ),
  Constraint     Emp_DWGrp_Num_UK          UNIQUE      (WGrp_Id, Day  ),
  Constraint     Emp_DWGrp_WGrp_FK         Foreign Key (WGrp_Id       ) References Emp_WrkGrp      (Id),
  CONSTRAINT     Emp_DWGrp_Com_FK          Foreign Key (Com_Id        ) References Emp_Com         (Id),
  CONSTRAINT     Emp_DWGrp_Shift_FK        Foreign Key (Shift_Id      ) References Phs_Cod_YesNo   (Id),
  CONSTRAINT     Emp_DWGrp_Execuse_FK      Foreign Key (Excuse_Id     ) References Phs_Cod_YesNo   (Id),
  CONSTRAINT     Emp_DWGrp_CrosDays_FK     Foreign Key (CrosDays_Id   ) References Phs_Cod_YesNo   (Id),
  CONSTRAINT     Emp_DWGrp_OTimeStatus_FK  Foreign Key (OTimeStatus_Id) References Emp_Cod_Overtime(Id),
  CONSTRAINT     Emp_DWGrp_ComPer_FK       Foreign Key (ComPer_Id     ) References Emp_Cod_Com_Per (Id),
  CONSTRAINT     Emp_DWGrp_Ins_FK          Foreign Key (Ins_User      ) References Cpy_User        (Id),
  CONSTRAINT     Emp_DWGrp_Upd_FK          Foreign Key (Upd_User      ) References Cpy_User        (Id)
)
/
Create Synonym Emp_DWrkGrp For Emp_Work_Group_Days
/

Create Sequence EMP_SALGRP_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Salary_Groups                        -- دليل مجموعات الراتب
( Id              Number(5),                          -- مفتاح رئيسي
  Name            Varchar2(100 Char),                 -- الاسم
  SalStatus_Id    Number(1) Default 2,                -- حالة الراتب \1 حسب الدوام \2 راتب دون دوام
  AddStatus_Id    Number(1) Default 1,                -- حالة الإضافي \1 حسب الدوام \2 ليس له إضافي
  Brkt_Id         Number(5) Default 0,                -- مفتاح الشرائح الضريبية
  GTaxPay_Id      Number(1) Default 1,                -- حالة الضريبة \ 1 يدفعها العامل \ 2 يدفعها رب العمل
  GTamPay_Id      Number(1) Default 1,                -- حالة التأمينات \ 1 يدفعها العامل \ 2 يدفعها رب العمل 
  GTamEPerc       Number(7,3) Default 0,              -- نسبة التأمينات \ حصة العامل
  GTamOPerc1      Number(7,3) Default 0,              -- نسبة التأمينات \ حصة رب العمل1
  GTamOPerc2      Number(7,3) Default 0,              -- نسبة التأمينات \ حصة رب العمل2
  GTamOPerc3      Number(7,3) Default 0,              -- نسبة التأمينات \ حصة رب العمل3
  DPrice          Number(7,3) Default 0,              -- نسبة ساعة الإضافي النهاري
  NPrice          Number(7,3) Default 0,              -- نسبة ساعة الإضافي الليلي
  WPrice          Number(7,3) Default 0,              -- نسبة ساعة الإضافي نهاية الاسبوع
  VPrice          Number(7,3) Default 0,              -- نسبة ساعة الإضافي عطلة
  Absence         Number(7,3) Default 0,              -- نسبة ساعة الغياب
  Delay           Number(7,3) Default 0,              -- نسبة ساعة التأخير
  Ins_User        Number(5), Ins_Date   Date,
  Upd_User        Number(5), Upd_Date   Date,
  Constraint      Emp_SGrp_PK            Primary Key (Id  ),
  Constraint      Emp_SGrp_Nam_UK        UNIQUE      (Name),
  Constraint      Emp_SGrp_TaxBrkt_FK    Foreign Key (Brkt_Id     ) REFERENCES Emp_TaxBrkt   (Id),
  Constraint      Emp_SGrp_TaxPay_FK     Foreign Key (GTaxPay_Id  ) REFERENCES Emp_Cod_TaxPay(Id),
  Constraint      Emp_SGrp_TamPay_FK     Foreign Key (GTamPay_Id  ) REFERENCES Emp_Cod_TaxPay(Id),
  Constraint      Emp_SGrp_SalStatus_FK  Foreign Key (SalStatus_Id) REFERENCES Phs_Cod_YesNo (Id),
  Constraint      Emp_SGrp_AddStatus_FK  Foreign Key (AddStatus_Id) REFERENCES Phs_Cod_YesNo (Id),
  CONSTRAINT      Emp_SGrp_Ins_FK        Foreign Key (Ins_User    ) References Cpy_User      (Id),
  CONSTRAINT      Emp_SGrp_Upd_FK        Foreign Key (Upd_User    ) References Cpy_User      (Id)
)
/
Create Synonym Emp_SalGrp For Emp_Salary_Groups
/
INSERT INTO Emp_SalGrp
       (Id, Name, Salstatus_Id, Addstatus_Id, Brkt_Id, Gtaxpay_Id, Gtampay_Id)
VALUES (0 , '-' , 1           , 1           , 0      , 1         , 1         );


Create Sequence EMP_GRADMST_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Grade_Templates_MST                  -- قوالب الدرجات الوظيفية
( Id           Number(5) NOT NULL,                    -- مفتاح رئيسي
  Num          Number(9),                             -- الرقم
  Name         Varchar2(100 Char),                    -- الاسم
  Rem          Varchar2(250 Char),                    -- ملاحظات
  isDefault_Id Number(1) Default 2,                   -- مؤشر القالب الافتراضي
  Ins_User     Number(5), Ins_Date Date,
  Upd_User     Number(5), Upd_Date Date,
  CONSTRAINT   Emp_MGradTemp_PK           PRIMARY KEY (Id  ),
  CONSTRAINT   Emp_MGradTemp_Num          UNIQUE      (Num ),
  CONSTRAINT   Emp_MGradTemp_Nam          UNIQUE      (Name),
  CONSTRAINT   Emp_MGradTemp_isDefault_FK Foreign Key (isDefault_Id ) References Phs_Cod_YesNo(Id),
  CONSTRAINT   Emp_MGradTemp_Ins_FK       Foreign Key (Ins_User     ) References Cpy_User     (Id),
  CONSTRAINT   Emp_MGradTemp_Upd_FK       Foreign Key (Upd_User     ) References Cpy_User     (Id)
)
/
Create Synonym Emp_GradMst For Emp_Grade_Templates_MST
/

Create Sequence EMP_GRADTRN_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Grade_Templates_TRN                  -- بنود قوالب الدرجات الوظيفية
( Id          Number(5) NOT NULL,                     -- مفتاح رئيسي
  Grad_Id     Number(5) NOT NULL,                     -- مفتاح الأب
  Grp_Id      Number(5),                              -- المجموعة
  Degree_Id   Number(5),                              -- الدرجة
  Days        Number(4) Default 0,                    -- الأيام ضمن الدرجة
  MinSal      Number(25,3) Default 0,                 -- الحد الأدنى للراتب
  MaxSal      Number(25,3) Default 0,                 -- الحد الأعلى للراتب
  TRem        Varchar2(250 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Emp_TGradTemp_PK      PRIMARY KEY (Id),
  CONSTRAINT  Emp_TGradTemp_UK      UNIQUE      (Grad_Id, Grp_Id, Degree_Id),
  CONSTRAINT  Emp_TGradTemp_FK      Foreign Key (Grad_Id  ) References Emp_GradMst       (Id),
  CONSTRAINT  Emp_TGradTemp_Grp_FK  Foreign Key (Grp_Id   ) References Emp_Cod_GradGrp   (Id),
  CONSTRAINT  Emp_TGradTemp_Deg_FK  Foreign Key (Degree_Id) References Emp_Cod_GradDegree(Id),
  CONSTRAINT  Emp_TGradTemp_Ins_FK  Foreign Key (Ins_User ) References Cpy_User          (Id),
  CONSTRAINT  Emp_TGradTemp_Upd_FK  Foreign Key (Upd_User ) References Cpy_User          (Id)
)
/
Create Synonym Emp_GradTrn For Emp_Grade_Templates_TRN
/

Create Sequence EMP_APPRMST_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Appraisal_Templates_MST              -- قوالب التقييم
( Id         Number(10) NOT NULL,                     -- مفتاح رئيسي
  Num        Number(9) NOT NULL,                      -- الرقم
  Name       Varchar2(100 Char),                      -- الاسم
  Rem        Varchar2(250 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Emp_MApprTemp_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Emp_MApprTemp_Num       UNIQUE      (Num ),
  CONSTRAINT Emp_MApprTemp_Nam       UNIQUE      (Name),
  CONSTRAINT Emp_MApprTemp_Ins_FK    Foreign Key (Ins_User ) References Cpy_User(Id),
  CONSTRAINT Emp_MApprTemp_Upd_FK    Foreign Key (Upd_User ) References Cpy_User(Id)
)
/
Create Synonym Emp_ApprMst For Emp_Appraisal_Templates_MST
/

Create Sequence EMP_APPRTRN_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Appraisal_Templates_TRN              -- بنود التقييم
( Id          Number(20) NOT NULL,                    -- مفتاح رئيسي
  Appr_Id     Number(10) NOT NULL,                    -- مفتاح الأب
  ApprGrp_Id  Number(5),                              -- المجموعة
  ApprItm_Id  Number(5),                              -- البند
  Points      Number(5) Default 100,                  -- العلامة القصوى
  Rem         Varchar2(250 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Emp_TApprTemp_PK      PRIMARY KEY (Id),
  CONSTRAINT  Emp_TApprTemp_UK      UNIQUE      (Appr_Id, ApprGrp_Id, ApprItm_Id),
  CONSTRAINT  Emp_TApprTemp_FK      Foreign Key (Appr_Id   ) References Emp_ApprMst           (Id),
  CONSTRAINT  Emp_TApprTemp_Grp_FK  Foreign Key (ApprGrp_Id) References Emp_Cod_Appraisal_Grp (Id),
  CONSTRAINT  Emp_TApprTemp_Item_FK Foreign Key (ApprItm_Id) References Emp_Cod_Appraisal_Item(Id),
  CONSTRAINT  Emp_TApprTemp_Ins_FK  Foreign Key (Ins_User  ) References Cpy_User              (Id),
  CONSTRAINT  Emp_TApprTemp_Upd_FK  Foreign Key (Upd_User  ) References Cpy_User              (Id)
)
/
Create Synonym Emp_ApprTrn For Emp_Appraisal_Templates_TRN
/

Create Sequence EMP_APPREVAL_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Appraisal_Evaluation                 -- قواعد التقييم
( Id          Number(20) NOT NULL,                    -- مفتاح رئيسي
  Appr_Id     Number(20) NOT NULL,                    -- مفتاح الأب
  Eval        Varchar2(100),                          -- اسم التقييم
  SPoints     Number(7) Default 0,                    -- من
  EPoints     Number(7) Default 0,                    -- إلى
  SalInc      Number(6,2) Default 0,                  -- Salary Increase
  Rem         Varchar2(250 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Emp_ApprEval_PK     PRIMARY KEY (Id ),
  CONSTRAINT  Emp_ApprEval_UK     UNIQUE      (Appr_Id, Eval),
  CONSTRAINT  Emp_ApprEval_FK     Foreign Key (Appr_Id  ) References Emp_ApprMst(Id),
  CONSTRAINT  Emp_ApprEval_Ins_FK Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT  Emp_ApprEval_Upd_FK Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Emp_ApprEval For Emp_Appraisal_Evaluation
/

Create Sequence EMP_EMP_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Employee                             -- دليل العاملين
( Id             Number(9) NOT NULL,                  -- مفتاح رئيسي
  Num            Varchar2(15 Char),                   -- مفتاح العامل
  NNum           Varchar2(15 Char),                   -- الرقم الوطني
  PNum           Varchar2(15 Char),                   -- الرقم الذاتي
  INum           Varchar2(15 Char),                   -- الرقم التأميني
  AttNum         Varchar2(15 Char),                   -- الرقم في مراقبة الدوام
  PCard          Varchar2(15 Char),                   -- رقم الهوية
  Kied           Varchar2(25 Char),                   -- محل ورقم القيد
  Name           Varchar2(100 Char),                  -- الاسم
  aName          Varchar2(100 Char),                  -- الاسم عربي
  eName          Varchar2(100 Char),                  -- الاسم أجنبي
  Father         Varchar2(50 Char),                   -- الأب
  Mother         Varchar2(50 Char),                   -- الأم
  PBirth         Varchar2(50 Char),                   -- مكان الولادة
  DBirth         Date,                                -- تاريخ الولادة
  Addr           Varchar2(100 Char),                  -- عنوان
  Phone1         Varchar2(15 Char),                   -- هاتف1
  Phone2         Varchar2(15 Char),                   -- هاتف2
  Mobile1        Varchar2(15 Char),                   -- موبايل
  Mobile2        Varchar2(15 Char),                   -- موبايل
  Fax            Varchar2(15 Char),                   -- فاكس
  Ext            Varchar2(5 Char),                    -- رقم التحويلة
  EMail1         Varchar2(50 Char),                   -- البريد الإلكتروني
  EMail2         Varchar2(50 Char),                   -- البريد الإلكتروني
  EPerson        Varchar2(50 Char),                   -- في الطوارئ الإتصل بـ
  EPhone         Varchar2(30 Char),                   -- هاتف طوارئ
  Computer       Varchar2(30 Char),                   -- اسم الكمبيوتر
  Username       Varchar2(30 Char),                   -- اسم الدخول للشبكة
  BankAcc        Varchar2(50 Char),                   -- رقم الحساب في المصرف
  BankName       Varchar2(100 Char),                  -- الاسم في المصرف
  BankStatus_Id  Number(1) Default 2,                 -- حالة التوطين المصرفي
  Status_Id      Number(1) Default 1,                 -- حالة العامل \1 عادي\2 مستقيل\3 متوفى\4 طرد\5 فصل
  WStatus_Id     Number(1) Default 2,                 -- حالة الدوام \1 يسجل دوامه \2 معفى من تسجيل الدوام
  Military_Id    Number(1) Default 1,                 -- خدمة العلم
  isOwner_Id     Number(1) Default 2,                 -- هل العامل من أحد مالكي الشركة
  Lang_Id        Number(5) Default 0,                 -- اللغة
  Educat_Id      Number(5) Default 0,                 -- الحالة التعليمية - الشهادة
  Job_Id         Number(5) Default 0,                 -- المهنة - الوظيفة
  Dept_Id        Number(5) Default 0,                 -- الدائرة
  Sect_Id        Number(5) Default 0,                 -- القسم
  Level_Id       Number(5) Default 0,                 -- الفئة
  Loc_Id         Number(5) Default 0,                 -- موقع المكتب
  Spc1_Id        Number(5) Default 0,                 -- تصنيف1
  Spc2_Id        Number(5) Default 0,                 -- تصنيف2
  Spc3_Id        Number(5) Default 0,                 -- تصنيف3
  Spc4_Id        Number(5) Default 0,                 -- تصنيف4
  Gender_Id      Number(1) Default 1,                 -- الجنس
  Nat_Id         Number(5) Default 0,                 -- الجنسية
  Martial_Id     Number(5) Default 0,                 -- الحالة الإجتماعية
  Child          Number(2) Default 0,                 -- عدد الأطفال
  Wife_Id        Number(1) Default 2,                 -- حالة الزوجة
  IFamily_Id     Number(1) Default 2,                 -- التأمين العائلي Family Insurance
  IHelth_Id      Number(1) Default 2,                 -- التأمين الصحي Helth Insurance
  IChild         Number(2) Default 2,                 -- عدد أولاد التأمين الصحي No of Covered Child
  Director_Id    Number(9),                           -- المدير Director
  Manager_Id     Number(9),                           -- المدير Manager
  FAppraisal_Id  Number(9),                           -- First Appraisal
  SAppraisal_Id  Number(9),                           -- Second Appraisal
  User_Id        Number(5),                           -- المستخدم المرتب بالعامل \ اسم الدخول للنظام إن وجد
  Acr_Id         Number(5),                           -- معتمد الرواتب
  WGrp_Id        Number(5),                           -- مجموعة الدوام
  SGrp_Id        Number(5),                           -- مجموعة الرواتب
  Appr_Id        Number(10),                          -- قالب التقييم
  TGrad_Id       Number(20),                          -- مفتاح الدرجة الوظيفية
  GradCons       Number(5) Default 0,                 -- أيام مكافآت القدم
  GradPuns       Number(5) Default 0,                 -- أيام عقوبة تأخير الترفيع
  GradDays       Number(5) Default 0,                 -- الخبرة الأيام
  GradSDate      Date,                                -- تاريخ بداية الدرجة الحالية
  CSDate         Date,                                -- تاريخ بداية العقد
  CEDate         Date,                                -- تاريخ نهاية العقد
  SDate          Date,                                -- تاريخ المباشرة
  Idate          Date,                                -- تاريخ التسجيل في التأمينات
  EDate          Date,                                -- تاريخ الإنتهاء من العمل\أي ترك العمل
  BaseSal        Number(25,3) Default 0,              -- الراتب الأساس
  FinanceSal     Number(25,3) DEfault 0,              -- الراتب المالي
  InsurSal       Number(25,3) DEfault 0,              -- الراتب التأميني
  Years          Number(7,3) Default 0,               -- سنوات الخبرة Years of Services
  VacDays        Number(3) Default 0,                 -- الإجازات أيام
  VacHours       Number(3) Default 0,                 -- الإجازات ساعات
  VacBDays       Number(3) Default 0,                 -- رصيد الإجازات أيام
  VacBHours      Number(3) Default 0,                 -- رصيد الإجازات ساعات
  Img            Varchar2(250 Char),                  -- الصورة الشخصية
  Rem            Varchar2(250 Char),                  -- ملاحظات
  Ins_User       Number(5), Ins_Date Date,
  Upd_User       Number(5), Upd_Date Date,
  CONSTRAINT     Emp_Emp_PK            PRIMARY KEY (Id  ),
  CONSTRAINT     Emp_Emp_Num           UNIQUE      (Num ),
  CONSTRAINT     Emp_Emp_NNum          UNIQUE      (NNum),
  CONSTRAINT     Emp_Emp_PNum          UNIQUE      (PNum),
  CONSTRAINT     Emp_Emp_INum          UNIQUE      (INum),
  CONSTRAINT     Emp_Emp_AttNum        UNIQUE      (AttNum),
  CONSTRAINT     Emp_Emp_NFM           UNIQUE      (Name, Father, Mother),
  CONSTRAINT     Emp_Emp_User_FK       Foreign Key (User_Id      ) References Cpy_User          (Id),
  CONSTRAINT     Emp_Emp_Acr_FK        Foreign Key (Acr_Id       ) References Emp_Acr           (Id),
  CONSTRAINT     Emp_Emp_WGrp_FK       Foreign Key (WGrp_Id      ) References Emp_WrkGrp        (Id),
  CONSTRAINT     Emp_Emp_SGrp_FK       Foreign Key (SGrp_Id      ) References Emp_SalGrp        (Id),
  CONSTRAINT     Emp_Emp_Appr_FK       Foreign Key (Appr_Id      ) References Emp_ApprMst       (Id),
  CONSTRAINT     Emp_Emp_Grad_FK       Foreign Key (TGrad_Id     ) References Emp_GradTrn       (Id),
  CONSTRAINT     Emp_Emp_BankStatus_FK Foreign Key (BankStatus_Id) References Phs_Cod_YesNo     (Id),
  CONSTRAINT     Emp_Emp_Status_FK     Foreign Key (Status_Id    ) References Emp_Cod_Status    (Id),
  CONSTRAINT     Emp_Emp_WStatus_FK    Foreign Key (WStatus_Id   ) References Phs_Cod_YesNo     (Id),
  CONSTRAINT     Emp_Emp_Military_FK   Foreign Key (Military_Id  ) References Phs_Cod_Military  (Id),
  CONSTRAINT     Emp_Emp_isOwner_FK    Foreign Key (isOwner_Id   ) References Phs_Cod_YesNo     (Id),
  CONSTRAINT     Emp_Emp_Lang_FK       Foreign Key (Lang_Id      ) References Emp_Cod_Lang      (Id),
  CONSTRAINT     Emp_Emp_Educat_FK     Foreign Key (Educat_Id    ) References Emp_Cod_Edu       (Id),
  CONSTRAINT     Emp_Emp_Job_FK        Foreign Key (Job_Id       ) References Emp_Cod_Job       (Id),
  CONSTRAINT     Emp_Emp_Dept_FK       Foreign Key (Dept_Id      ) References Emp_Cod_Department(Id),
  CONSTRAINT     Emp_Emp_Sect_FK       Foreign Key (Sect_Id      ) References Emp_Cod_Section   (Id),
  CONSTRAINT     Emp_Emp_Level_FK      Foreign Key (Level_Id     ) References Emp_Cod_Level     (Id),
  CONSTRAINT     Emp_Emp_Loc_FK        Foreign Key (Loc_Id       ) References Emp_Cod_Location  (Id),
  CONSTRAINT     Emp_Emp_Spc1_FK       Foreign Key (Spc1_Id      ) References Emp_Cod_Spec1     (Id),
  CONSTRAINT     Emp_Emp_Spc2_FK       Foreign Key (Spc2_Id      ) References Emp_Cod_Spec2     (Id),
  CONSTRAINT     Emp_Emp_Spc3_FK       Foreign Key (Spc3_Id      ) References Emp_Cod_Spec3     (Id),
  CONSTRAINT     Emp_Emp_Spc4_FK       Foreign Key (Spc4_Id      ) References Emp_Cod_Spec4     (Id),
  CONSTRAINT     Emp_Emp_Gender_FK     Foreign Key (Gender_Id    ) References Phs_Cod_Gender    (Id),
  CONSTRAINT     Emp_Emp_Nat_FK        Foreign Key (Nat_Id       ) References Emp_Cod_Nat       (Id),
  CONSTRAINT     Emp_Emp_Martial_FK    Foreign Key (Martial_Id   ) References Phs_Cod_Marital   (Id),
  CONSTRAINT     Emp_Emp_Wife_FK       Foreign Key (Wife_Id      ) References Phs_Cod_YesNo     (Id),
  CONSTRAINT     Emp_Emp_IFamily_FK    Foreign Key (IFamily_Id   ) References Phs_Cod_YesNo     (Id),
  CONSTRAINT     Emp_Emp_IHelth_FK     Foreign Key (IHelth_Id    ) References Phs_Cod_YesNo     (Id),
  CONSTRAINT     Emp_Emp_Ins_FK        Foreign Key (Ins_User     ) References Cpy_User          (Id),
  CONSTRAINT     Emp_Emp_Upd_FK        Foreign Key (Upd_User     ) References Cpy_User          (Id)
)
/
Create Synonym Emp_Emp For Emp_Employee
/

Alter Table Emp_Employee Add
( CONSTRAINT     Emp_Emp_DEmp_FK    Foreign Key (Director_Id  ) References Emp_Emp(Id),
  CONSTRAINT     Emp_Emp_MEmp_FK    Foreign Key (Manager_Id   ) References Emp_Emp(Id),
  CONSTRAINT     Emp_Emp_FAEmp_FK   Foreign Key (FAppraisal_Id) References Emp_Emp(Id),
  CONSTRAINT     Emp_Emp_SAEmp_FK   Foreign Key (SAppraisal_Id) References Emp_Emp(Id)
)
/

Create Sequence EMP_EMPHIST_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Emploee_History                      -- السيرة الوظيفية
( Id           Number(20) NOT NULL,                   -- مفتاح رئيسي
  Num          Number(20),                            -- الرقم
  dDate        Date,                                  -- التاريخ
  Emp_Id       Number(20) NOT NULL,                   -- العامل
  Type_Id      Number(5),                             -- النوع
  Note         Varchar2(500 Char),                    -- نص القرار
  Rem          Varchar2(250 Char),                    -- ملاحظات
  Ins_User     Number(5), Ins_Date Date,
  Upd_User     Number(5), Upd_Date Date,
  CONSTRAINT   Emp_EmpHist_PK      PRIMARY KEY (Id ),
  CONSTRAINT   Emp_EmpHist_Num     UNIQUE      (Num),
  CONSTRAINT   Emp_EmpHist_Emp_FK  Foreign Key (Emp_Id  ) REFERENCES Emp_Emp     (Id),
  CONSTRAINT   Emp_EmpHist_Hist_FK Foreign Key (Type_Id ) REFERENCES Emp_Cod_Hist(Id),
  CONSTRAINT   Emp_EmpHist_Ins_FK  Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT   Emp_EmpHist_Upd_FK  Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Emp_EmpHist For Emp_Emploee_History
/

Create Sequence EMP_ChGrade_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Grade_Change                         -- تعديل الدرجة الوظيفية
( Id          Number(10) NOT NULL,                    -- مفتاح رئيسي
  Num         Number(9),                              -- الرقم
  dDate       Date,                                   -- التاريخ
  Emp_Id      Number(9) NOT NULL,                     -- العامل
  TGrad_OId   Number(5),                              -- الدرجة القديمة
  TGrad_NId   Number(5),                              -- الدرجة الجديدة
  SDate       Date,                                   -- تارخ بداية الدرجة
  Days        Number(5) Default 0,                    -- الأشهر
  Rem         Varchar2(250 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Emp_ChGrad_PK       PRIMARY KEY (Id ),
  CONSTRAINT  Emp_ChGrad_UK       UNIQUE      (Num),
  CONSTRAINT  Emp_ChGrad_Emp_FK   Foreign Key (Emp_Id   ) REFERENCES Emp_Emp    (Id),
  CONSTRAINT  Emp_ChGrad_OGrad_FK Foreign Key (TGrad_OId) REFERENCES Emp_GradTrn(Id),
  CONSTRAINT  Emp_ChGrad_NGrad_FK Foreign Key (TGrad_NId) REFERENCES Emp_GradTrn(Id),
  CONSTRAINT  Emp_ChGrad_Ins_FK   Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT  Emp_ChGrad_Upd_FK   Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Emp_ChGrade For Emp_Grade_Change
/

Create Sequence EMP_MADMCON_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Admin_Consideration_MST              -- ترويسة المكافآت الإدارية
( Id         Number(10),                              -- مفتاح رئيسي
  Type_Id    Number(5) Default 0,                     -- النوع
  Num        Number(9),                               -- الرقم
  dDate      Date Default Sysdate,                    -- التاريخ
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_MAdmCon_PK      Primary Key (Id ),
  Constraint Emp_MAdmCon_Num_UK  Unique      (Num),
  CONSTRAINT Emp_MAdmCon_Type_FK Foreign Key (Type_Id ) References Emp_Cod_Cons(Id),
  CONSTRAINT Emp_MAdmCon_Ins_FK  Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Emp_MAdmCon_Upd_FK  Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Emp_MAdmCon For Emp_Admin_Consideration_MST
/
Create Sequence EMP_TADMCON_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Admin_Consideration_TRN              -- بنود المكافآت الإدارية
( Id           Number(20),                            -- مفتاح رئيسي
  MACon_Id     Number(10),                            -- مفتاح الأب
  Emp_Id       Number(9) NOT NULL,                    -- العامل
  ApprGrp_Id   Number(5) Default 0 NOT NULL,          -- المجموعة
  ApprItm_Id   Number(5) Default 0 NOT NULL,          -- البند
  Points       Number(4) Default 100 NOT NULL,        -- العلامة
  Days         Number(5) Default 0,                   -- الأيام  في حال مكأفأة قدم
  Rem          Varchar2(100 Char),                    -- ملاحظات
  Ins_User     Number(5), Ins_Date   Date,
  Upd_User     Number(5), Upd_Date   Date,
  Constraint   Emp_TAdmCon_PK      Primary Key (Id),
  Constraint   Emp_TAdmCon_UK      Unique      (MACon_Id, Emp_Id),
  Constraint   Emp_TAdmCon_FK      Foreign Key (MACon_Id  ) REFERENCES Emp_MAdmCon           (Id),
  Constraint   Emp_TAdmCon_Emp_FK  Foreign Key (Emp_Id    ) REFERENCES Emp_Emp               (Id),
  CONSTRAINT   Emp_TAdmCon_Grp_FK  Foreign Key (ApprGrp_Id) References Emp_Cod_Appraisal_Grp (Id),
  CONSTRAINT   Emp_TAdmCon_Item_FK Foreign Key (ApprItm_Id) References Emp_Cod_Appraisal_Item(Id),
  CONSTRAINT   Emp_TAdmCon_Ins_FK  Foreign Key (Ins_User  ) References Cpy_User              (Id),
  CONSTRAINT   Emp_TAdmCon_Upd_FK  Foreign Key (Upd_User  ) References Cpy_User              (Id)
)
/
Create Synonym Emp_TAdmCon For Emp_Admin_Consideration_TRN
/

Create Sequence EMP_MADMPUN_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Admin_Punishment_MST                 -- العقوبات الإدارية
( Id         Number(20),                              -- مفتاح رئيسي
  Num        Number(20),                              -- الرقم
  Type_Id    Number(5) Default 0,                     -- النوع
  dDate      Date Default Sysdate,                    -- التاريخ
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_MAdmPun_PK      Primary Key (Id ),
  Constraint Emp_MAdmPun_Num_UK  Unique      (Num),
  CONSTRAINT Emp_MAdmPun_Type_FK Foreign Key (Type_Id ) References Emp_Cod_Pun(Id),
  CONSTRAINT Emp_MAdmPun_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT Emp_MAdmPun_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Emp_MAdmPun For Emp_Admin_Punishment_MST
/
Create Sequence EMP_TADMPUN_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Admin_Punishment_TRN                 -- العقوبات الإدارية
( Id           Number(20),                            -- مفتاح رئيسي
  MAPun_Id     Number(10),                            -- مفتاح رئيسي
  Emp_Id       Number(9) NOT NULL,                    -- العامل
  ApprGrp_Id   Number(5) Default 0 NOT NULL,          -- المجموعة
  ApprItm_Id   Number(5) Default 0 NOT NULL,          -- البند
  Points       Number(4) Default 100 NOT NULL,        -- العلامة
  Days         Number(3) Default 0,                   -- الأيام في حال عقوبة تأخير ترفيع
  Rem          Varchar2(100 Char),                    -- ملاحظات
  Ins_User     Number(5), Ins_Date   Date,
  Upd_User     Number(5), Upd_Date   Date,
  Constraint   Emp_TAdmPun_PK      Primary Key (Id),
  Constraint   Emp_TAdmPun_UK      Unique      (MAPun_Id,Emp_Id),
  Constraint   Emp_TAdmPun_FK      Foreign Key (MAPun_Id  ) REFERENCES Emp_MAdmPun           (Id),
  Constraint   Emp_TAdmPun_Emp_FK  Foreign Key (Emp_Id    ) REFERENCES Emp_Emp               (Id),
  CONSTRAINT   Emp_TAdmPun_Grp_FK  Foreign Key (ApprGrp_Id) References Emp_Cod_Appraisal_Grp (Id),
  CONSTRAINT   Emp_TAdmPun_Item_FK Foreign Key (ApprItm_Id) References Emp_Cod_Appraisal_Item(Id),
  CONSTRAINT   Emp_TAdmPun_Ins_FK  Foreign Key (Ins_User  ) References Cpy_User              (Id),
  CONSTRAINT   Emp_TAdmPun_Upd_FK  Foreign Key (Upd_User  ) References Cpy_User              (Id)
)
/
Create Synonym Emp_TAdmPun For Emp_Admin_Punishment_TRN
/

Create Sequence EMP_APPRNOTE_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Appraisal_Notes                      -- ملاحظات التقييم
( Id           Number(10) NOT NULL,                   -- مفتاح رئيسي
  Num          Number(9),                             -- الرقم
  dDate        Date,                                  -- التاريخ
  Emp_Id       Number(9) NOT NULL,                    -- العامل
  Type_Id      Number(1),                             -- النوع
  ApprGrp_Id   Number(5),                             -- المجموعة
  ApprItm_Id   Number(5),                             -- البند
  Points       Number(4) Default 100 NOT NULL,        -- العلامة
  Rem          Varchar2(250 Char),                    -- ملاحظات
  Ins_User     Number(5), Ins_Date Date,
  Upd_User     Number(5), Upd_Date Date,
  CONSTRAINT   Emp_ApprNote_PK      PRIMARY KEY (Id ),
  CONSTRAINT   Emp_ApprNote_Num     UNIQUE      (Num),
  CONSTRAINT   Emp_ApprNote_Emp_FK  Foreign Key (Emp_Id    ) REFERENCES Emp_Emp               (Id),
  CONSTRAINT   Emp_ApprNote_Type_FK Foreign Key (Type_Id   ) References Phs_Cod_Sign          (Id),
  CONSTRAINT   Emp_ApprNote_Grp_FK  Foreign Key (ApprGrp_Id) References Emp_Cod_Appraisal_Grp (Id),
  CONSTRAINT   Emp_ApprNote_Item_FK Foreign Key (ApprItm_Id) References Emp_Cod_Appraisal_Item(Id),
  CONSTRAINT   Emp_ApprNote_Ins_FK  Foreign Key (Ins_User  ) References Cpy_User              (Id),
  CONSTRAINT   Emp_ApprNote_Upd_FK  Foreign Key (Upd_User  ) References Cpy_User              (Id)
)
/
Create Synonym Emp_ApprNote For Emp_Appraisal_Notes
/

Create Sequence EMP_APPREMPMST_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Appraisal_Employee_MST               -- تقييم العاملين
( Id         Number(10) NOT NULL,                     -- مفتاح رئيسي
  Appr_Id    Number(5) NOT NULL,                      -- مفتاح التقييم
  Emp_Id     Number(9) NOT NULL,                      -- العامل
  Num        Number(9),                               -- الرقم
  dDate      Date,                                    -- التاريخ
  FDate      Date,                                    -- التاريخ من
  TDate      Date,                                    -- التاريخ إلى
  Rem        Varchar2(250 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Emp_MApprEmp_PK      PRIMARY KEY (Id ),
  CONSTRAINT Emp_MApprEmp_Num     UNIQUE      (Num),
  CONSTRAINT Emp_MApprEmp_Appr_FK Foreign Key (Appr_Id  ) REFERENCES Emp_ApprMst(Id),
  CONSTRAINT Emp_MApprEmp_Emp_FK  Foreign Key (Emp_Id   ) REFERENCES Emp_Emp    (Id),
  CONSTRAINT Emp_MApprEmp_Ins_FK  Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT Emp_MApprEmp_Upd_FK  Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Emp_ApprEmpMst For Emp_Appraisal_Employee_MST
/

Create Sequence EMP_APPREMPTRN_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Appraisal_Employee_TRN               -- بنود التقييم
( Id          Number(20) NOT NULL,                    -- مفتاح رئيسي
  AEmp_Id     Number(10) NOT NULL,                    -- مفتاح الأب
  TAppr_Id    Number(20) NOT NULL,                    -- مفتاح بند التقييم
  Points      Number(5) Default 100,                  -- العلامة
  Rem         Varchar2(250 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Emp_TApprEmp_PK       PRIMARY KEY (Id),
  CONSTRAINT  Emp_TApprEmp_FK       Foreign Key (AEmp_Id  ) References Emp_ApprEmpMst(Id),
  CONSTRAINT  Emp_TApprEmp_TAppr_FK Foreign Key (TAppr_Id ) REFERENCES Emp_ApprTrn   (Id),
  CONSTRAINT  Emp_TApprEmp_Ins_FK   Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Emp_TApprEmp_Upd_FK   Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Emp_ApprEmpTrn For Emp_Appraisal_Employee_TRN
/

Create Sequence EMP_ECOM_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Employee_Compensation                -- تعويضات العاملين الدائمة
( Id         Number(9),                               -- مفتاح رئيسي
  Emp_Id     Number(9) NOT NULL,                      -- العامل
  Com_Id     Number(5) NOT NULL,                      -- التعويض
  SDate      Date NOT NULL,                           -- بداية
  EDate      Date NOt NULL,                           -- نهاية
  Status_Id  Number(1) Default 1,                     -- حالة التثبيت
  PAmt       Number(25,3) Default 0,                  -- نسبة\مبلغ
  MaxAmt     Number(25,3) Default 0,                  -- مبلغ /نسبة سقف التعويض
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  Constraint Emp_ECom_PK        Primary Key (Id ),
  Constraint Emp_ECom_ENum_UK   Unique      (Emp_Id, Com_Id),
  CONSTRAINT Emp_ECom_Status_Fk FOREIGN KEY (Status_Id) REFERENCES Phs_Cod_Status (Id),
  Constraint Emp_ECom_Emp_FK    Foreign Key (Emp_Id   ) REFERENCES Emp_Emp        (Id),
  Constraint Emp_ECom_Com_FK    Foreign Key (Com_Id   ) REFERENCES Emp_Com        (Id),
  CONSTRAINT Emp_ECom_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Emp_ECom_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Emp_ECom For Emp_Employee_Compensation
/

Create Sequence EMP_EDED_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Employee_Deduction                   -- حسميات العاملين الدائمة
( Id         Number(9),                               -- مفتاح رئيسي
  Emp_Id     Number(9) NOT NULL,                      -- العامل
  Ded_Id     Number(5) NOT NULL,                      -- الحسمية
  SDate      Date NOT NULL,                           -- بداية
  EDate      Date NOt NULL,                           -- نهاية
  Status_Id  Number(1) Default 1,                     -- حالة التثبيت
  PAmt       Number(25,3) Default 0,                  -- نسبة\مبلغ
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  Constraint Emp_EDed_PK        Primary Key (Id),
  Constraint Emp_EDed_ENum_UK   Unique      (Emp_Id, Ded_Id),
  CONSTRAINT Emp_EDed_Status_Fk FOREIGN KEY (Status_Id) REFERENCES Phs_Cod_Status (Id),
  Constraint Emp_EDed_Emp_FK    Foreign Key (Emp_Id   ) REFERENCES Emp_Emp        (Id),
  Constraint Emp_EDed_Ded_FK    Foreign Key (Ded_Id   ) REFERENCES Emp_Ded        (Id),
  CONSTRAINT Emp_EDed_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Emp_EDed_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Emp_EDed For Emp_Employee_Deduction
/

Create Sequence EMP_MCHSALBRKT_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_ChangeSalary_Brackets_Mst            -- دليل الشرائح تعديل الرواتب
( Id         Number(5),                               -- مفتاح رئيسي
  Name       Varchar2(100 Char),                      -- الاسم
  dDate      Date Default SysDate,                    -- التاريخ
  Rem        Varchar2(250 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_MChSalBrkt_PK      Primary Key (Id  ),
  Constraint Emp_MChSalBrkt_Nam_UK  UNIQUE      (Name),
  CONSTRAINT Emp_MChSalBrkt_Ins_FK  Foreign Key (Ins_User ) References Cpy_User (Id),
  CONSTRAINT Emp_MChSalBrkt_Upd_FK  Foreign Key (Upd_User ) References Cpy_User (Id)
)
/
Create Synonym Emp_MChSalBrkt For Emp_ChangeSalary_Brackets_Mst
/

Create Sequence EMP_TCHSALBRKT_seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Emp_ChangeSalary_Brackets_Trn            -- تفصيل شرائح تعديل الرواتب
( Id         Number(5),                               -- مفتاح رئيسي
  Brkt_Id    Number(5),                               -- الشرائح
  Type_Id    Number(5) Default 1,                     -- نوع الضريبة \1 نسبة \0 مبلغ مقطوع
  SAmt       Number(25,3) Default 0,                  -- من المبلغ
  EAmt       Number(25,3) Default 0,                  -- إلى المبلغ
  Amt        Number(25,3) Default 0,                  -- الضربة
  Rem        Varchar2(250 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_TChSalBrkt_PK      Primary Key (Id),
  Constraint Emp_TChSalBrkt_Brkt_FK Foreign Key (Brkt_Id ) REFERENCES Emp_MChSalBrkt (Id),
  Constraint Emp_TChSalBrkt_Type_FK Foreign Key (Type_Id ) REFERENCES Phs_Cod_AmtType(Id),
  CONSTRAINT Emp_TChSalBrkt_Ins_FK  Foreign Key (Ins_User) References Cpy_User       (Id),
  CONSTRAINT Emp_TChSalBrkt_Upd_FK  Foreign Key (Upd_User) References Cpy_User       (Id)
)
/
Create Synonym Emp_TChSalBrkt For Emp_ChangeSalary_Brackets_Trn
/

Create Sequence EMP_CSAL_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Change_Salary                        -- تعديلات الرواتب
( Id           Number(10),                            -- مفتاح رئيسي
  Num          Number(5),                             -- الرقم
  dDate        Date Default SysDate,                  -- التاريخ
  DocN         Varchar2(10 Char),                     -- رقم الوثيقة
  DocD         Date Default SysDate,                  -- تاريخها
  Status_Id    Number(1) Default 1,                   -- حالة التثبيت
  SalTyp_Id    Number(5) Default 1,                   -- الراتب المعدل  \1 راتب أساسي \2 راتب تأميني \3 راتب مالي
  Type_Id      Number(5) Default 1,                   -- نمط التعديل \1 نسبة \2 مبلغ \3 مبلغ مضاف ثم نسبة \4 نسبة ثم مبلغ مضاف \5 حسب الشرائح
  Brkt_Id      Number(5) Default 0,                   -- مفتاح شرائح تعديل الراتب
  Perc         Number(7,3) Default 0,                 -- النسبة
  Amt          Number(25,3) Default 0,                -- المبلغ
  nMin         Number(25,3) Default 0,                -- الحد الأدنى
  nMax         Number(25,3) Default 9999999999,       -- الحد الأعلى
  Rem          Varchar2(100 Char),                    -- ملاحظات
  Ins_User     Number(5), Ins_Date   Date,
  Upd_User     Number(5), Upd_Date   Date,
  Constraint   Emp_CSal_PK        Primary Key (Id),
  CONSTRAINT   Emp_CSal_Status_Fk FOREIGN KEY (Status_Id) REFERENCES Phs_Cod_Status  (Id),
  CONSTRAINT   Emp_CSal_Brkt_FK   Foreign Key (Brkt_Id  ) References Emp_MChSalBrkt  (Id),
  CONSTRAINT   Emp_CSal_SalTyp_FK Foreign Key (SalTyp_Id) References Emp_Cod_AffSal  (Id),
  CONSTRAINT   Emp_CSal_Type_FK   Foreign Key (Type_Id  ) References Emp_Cod_ChngType(Id),
  CONSTRAINT   Emp_CSal_Ins_FK    Foreign Key (Ins_User ) References Cpy_User        (Id),
  CONSTRAINT   Emp_CSal_Upd_FK    Foreign Key (Upd_User ) References Cpy_User        (Id)
)
/
Create Synonym Emp_CSal For Emp_Change_Salary
/

Create Sequence EMP_CSALEMP_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Change_Salary_Employees              -- العمال في تعديل الرواتب
( Id               Number(20),                        -- مفتاح رئيسي
  CSal_Id          Number(10),                        -- مفتاح الأب
  Emp_Id           Number(9),                         -- الفرع
  OSal             Number(25,3) DEfault 0,            -- الراتب قبل التعديل
  Chnge            Number(25,3) DEfault 0,            -- التعديل
  NSal             Number(25,3) DEfault 0,            -- الراتب بعد التعديل
  Rem              Varchar2(100 Char),                -- ملاحظات
  Ins_User         Number(5), Ins_Date   Date,
  Upd_User         Number(5), Upd_Date   Date,
  Constraint       Emp_CSalEmp_PK      Primary Key (Id),
  Constraint       Emp_CSalEmp_UK      Unique      (CSal_Id, Emp_Id),
  CONSTRAINT       Emp_CSalEmp_CSal_FK Foreign Key (CSal_Id ) References Emp_CSal(Id),
  CONSTRAINT       Emp_CSalEmp_Emp_FK  Foreign Key (Emp_Id  ) References Emp_Emp (Id),
  CONSTRAINT       Emp_CSalEmp_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT       Emp_CSalEmp_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_CSalEmp For Emp_Change_Salary_Employees
/

Create Sequence EMP_AOSAL_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_AddOn_Salary                         -- إضافة على الراتب
( Id          Number(10),                             -- مفتاح رئيسي
  Num         Number(5),                              -- الرقم
  dDate       Date Default SysDate,                   -- التاريخ
  DocN        Varchar2(10 Char),                      -- رقم الوثيقة
  DocD        Date Default SysDate,                   -- تاريخها
  AddTo_Id    Number(1) Default 1,                    -- مضافا إلى \ 1 الراتب \ 2 الإضافي
  SalTyp_Id   Number(1) Default 1,                    -- الراتب المعدل  \1 راتب أساسي \2 راتب تأميني \3 راتب مالي
  Type_Id     Number(1) Default 1,                    -- نمط التعديل \1 نسبة \2 مبلغ \3 مبلغ مضاف ثم نسبة \4 نسبة ثم مبلغ مضاف
  Brkt_Id     Number(5) Default 0,                    -- الضريبة
  nYear       Number(4) NOT NULL,                     -- السنة المتأثرة
  nMonth      Number(2) NOT NULL,                     -- الشهر المتأثر
  Perc        Number(7,3) Default 0,                  -- النسبة
  Amt         Number(25,3) Default 0,                 -- المبلغ
  nMin        Number(25,3) Default 0,                 -- الحد الأدنى
  nMax        Number(25,3) Default 9999999999,        -- الحد الأعلى
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_ASal_PK        Primary Key (Id),
  Constraint  Emp_ASal_Tax_FK    Foreign Key (Brkt_Id  ) References Emp_TaxBrkt     (Id),
  CONSTRAINT  Emp_ASal_AddTo_FK  Foreign Key (AddTo_Id ) References Emp_Cod_Aff     (Id),
  CONSTRAINT  Emp_ASal_SalTyp_FK Foreign Key (SalTyp_Id) References Emp_Cod_AffSal  (Id),
  CONSTRAINT  Emp_ASal_Type_FK   Foreign Key (Type_Id  ) References Emp_Cod_ChngType(Id),
  CONSTRAINT  Emp_ASal_Ins_FK    Foreign Key (Ins_User ) References Cpy_User        (Id),
  CONSTRAINT  Emp_ASal_Upd_FK    Foreign Key (Upd_User ) References Cpy_User        (Id)
)
/
Create Synonym Emp_AOSal For Emp_AddOn_Salary
/

Create Sequence EMP_AOSALEMP_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_AddOn_Salary_Employees               -- العمال في إضافة على الراتب
( Id           Number(20),                            -- مفتاح رئيسي
  ASal_Id      Number(10),                            -- مفتاح الأب
  Emp_Id       Number(9),                             -- العامل
  Sal          Number(25,3) Default 0,                -- الراتب
  Amt          Number(25,3) Default 0,                -- التعديل
  Rem          Varchar2(100 Char),                    -- ملاحظات
  Ins_User     Number(5), Ins_Date   Date,
  Upd_User     Number(5), Upd_Date   Date,
  Constraint   Emp_ASalEmp_PK      Primary Key (Id),
  Constraint   Emp_ASalEmp_UK      Unique      (ASal_Id, Emp_Id),
  CONSTRAINT   Emp_ASalEmp_CSal_FK Foreign Key (ASal_Id ) References Emp_AOSal(Id),
  CONSTRAINT   Emp_ASalEmp_Emp_FK  Foreign Key (Emp_Id  ) References Emp_Emp  (Id),
  CONSTRAINT   Emp_ASalEmp_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT   Emp_ASalEmp_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Emp_AOSalEmp For Emp_AddOn_Salary_Employees
/

Create Sequence EMP_SFSAL_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_SubFrom_Salary                       -- حسم على الراتب
( Id           Number(10),                            -- مفتاح رئيسي
  Num          Number(5),                             -- الرقم
  dDate        Date Default SysDate,                  -- التاريخ
  DocN         Varchar2(10 Char),                     -- رقم الوثيقة
  DocD         Date Default SysDate,                  -- تاريخها
  SubFrom_Id   Number(1) Default 1,                   -- مطروحاً من  \ 1 الراتب \ 2 الإضافي
  SalTyp_Id    Number(1) Default 1,                   -- الراتب المعدل  \1 راتب أساسي \2 راتب تأميني \3 راتب مالي
  Type_Id      Number(1) Default 1,                   -- نمط التعديل \1 نسبة \2 مبلغ \3 مبلغ مضاف ثم نسبة \4 نسبة ثم مبلغ مضاف
  Perc         Number(7,3) Default 0,                 -- النسبة
  Amt          Number(25,3) Default 0,                -- المبلغ
  nMin         Number(25,3) Default 0,                -- الحد الأدنى
  nMax         Number(25,3) Default 9999999999,       -- الحد الأعلى
  nYear        Number(4) NOT NULL,                    -- السنة المتأثرة
  nMonth       Number(2) NOT NULL,                    -- الشهر المتأثر
  Rem          Varchar2(100 Char),                    -- ملاحظات
  Ins_User     Number(5), Ins_Date   Date,
  Upd_User     Number(5), Upd_Date   Date,
  Constraint   Emp_SSal_PK        Primary Key (Id),
  CONSTRAINT   Emp_SSal_AddTo_FK  Foreign Key (SubFrom_Id) References Emp_Cod_Aff     (Id),
  CONSTRAINT   Emp_SSal_SalTyp_FK Foreign Key (SalTyp_Id ) References Emp_Cod_AffSal  (Id),
  CONSTRAINT   Emp_SSal_Type_FK   Foreign Key (Type_Id   ) References Emp_Cod_ChngType(Id),
  CONSTRAINT   Emp_SSal_Ins_FK    Foreign Key (Ins_User  ) References Cpy_User        (Id),
  CONSTRAINT   Emp_SSal_Upd_FK    Foreign Key (Upd_User  ) References Cpy_User        (Id)
)
/
Create Synonym Emp_SFSal For Emp_SubFrom_Salary
/

Create Sequence EMP_SFSALEMP_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_SubFrom_Salary_Employees             -- العمال في حسم على الراتب
( Id           Number(20),                            -- مفتاح رئيسي
  SSal_Id      Number(10),                            -- مفتاح الأب
  Emp_Id       Number(9),                             -- العامل
  Sal          Number(25,3) Default 0,                -- الراتب
  Amt          Number(25,3) Default 0,                -- التعديل
  Rem          Varchar2(100 Char),                    -- ملاحظات
  Ins_User     Number(5), Ins_Date   Date,
  Upd_User     Number(5), Upd_Date   Date,
  Constraint   Emp_SSalEmp_PK      Primary Key (Id),
  Constraint   Emp_SSalEmp_UK      Unique      (SSal_Id, Emp_Id),
  CONSTRAINT   Emp_SSalEmp_CSal_FK Foreign Key (SSal_Id ) References Emp_SFSal(Id),
  CONSTRAINT   Emp_SSalEmp_Emp_FK  Foreign Key (Emp_Id  ) References Emp_Emp  (Id),
  CONSTRAINT   Emp_SSalEmp_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT   Emp_SSalEmp_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Emp_SFSalEmp For Emp_SubFrom_Salary_Employees
/

Create Sequence EMP_MSNREQ_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Missions_Request                     -- طلب مهمة
( Id         Number(9),                               -- مفتاح رئيسي
  Emp_Id     Number(9) NOT NULL,                      -- العامل
  Type_Id    Number(5) Default 1,                     -- نوع المهمة
  Approve_Id Number(1) Default 0,                     -- الموافقة \ 0 طلب \ 1 موافق \ 2 مرفوض
  Num        Number(9),                               -- الرقم
  dDate      Date Default Sysdate,                    -- التاريخ
  SDate      Date Default Sysdate,                    -- تاريخ البداية
  SHour       Number(2) DEFAULT 0,                    -- ساعة البداية
  SMinute     Number(2) DEFAULT 0,                    -- دقيقة البداية
  EDate       Date Default Sysdate,                   -- تاريخ النهاية
  EHour       Number(2) DEFAULT 23,                   -- ساعة النهاية
  EMinute     Number(2) DEFAULT 59,                   -- دقيقة النهاية
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_MsnReq_PK         Primary Key (Id ),
  Constraint Emp_MsnReq_Num_UK     Unique      (Num),
  Constraint Emp_MsnReq_Emp_FK     Foreign Key (Emp_Id    ) REFERENCES Emp_Emp        (Id),
  Constraint Emp_MsnReq_Type_FK    Foreign Key (Type_Id   ) REFERENCES Emp_Cod_Msn    (Id),
  Constraint Emp_MsnReq_Approve_FK Foreign Key (Approve_Id) REFERENCES Phs_Cod_Approve(Id),
  CONSTRAINT Emp_MsnReq_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT Emp_MsnReq_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Emp_MsnReq For Emp_Missions_Request
/

Create Sequence EMP_LEAVEREQ_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Leave_Request                        -- طلب أجازة
( Id         Number(9),                               -- مفتاح رئيسي
  Emp_Id     Number(9) NOT NULL,                      -- العامل
  Type_Id    Number(3) Default 100,                   -- نوع الإجازة
  Approve_Id Number(1) Default 0,                     -- الموافقة \ 0 طلب \ 1 موافق \ 2 مرفوض
  Num        Number(9),                               -- الرقم
  dDate      Date Default Sysdate,                    -- التاريخ
  SDate      Date Default Sysdate,                    -- تاريخ البداية
  SHour       Number(2) DEFAULT 0,                    -- ساعة البداية
  SMinute     Number(2) DEFAULT 0,                    -- دقيقة البداية
  EDate       Date Default Sysdate,                   -- تاريخ النهاية
  EHour       Number(2) DEFAULT 23,                   -- ساعة النهاية
  EMinute     Number(2) DEFAULT 59,                   -- دقيقة النهاية
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_LeaveReq_PK         Primary Key (Id ),
  Constraint Emp_LeaveReq_Num_UK     Unique      (Num),
  Constraint Emp_LeaveReq_SDate_UK   Unique      (Emp_Id, SDate),
  Constraint Emp_LeaveReq_EDate_UK   Unique      (Emp_Id, EDate),
  Constraint Emp_LeaveReq_Emp_FK     Foreign Key (Emp_Id    ) REFERENCES Emp_Emp        (Id),
  Constraint Emp_LeaveReq_Type_FK    Foreign Key (Type_Id   ) REFERENCES Emp_Cod_Leave  (Id),
  Constraint Emp_LeaveReq_Approve_FK Foreign Key (Approve_Id) REFERENCES Phs_Cod_Approve(Id),
  CONSTRAINT Emp_LeaveReq_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT Emp_LeaveReq_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Emp_LeaveReq For Emp_Leave_Request
/

Create Sequence EMP_OTIMEREQ_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Overtime_Request                     -- طلب إضافي
( Id          Number(9),                              -- مفتاح رئيسي
  Emp_Id      Number(9) NOT NULL,                     -- العامل
  Type_Id     Number(1) Default 1,                    -- نوع الإضافي 1 نهاري\2 ليلي\3 عطلة
  Approve_Id  Number(1) Default 0,                    -- الموافقة \ 0 طلب \ 1 موافق \ 2 مرفوض
  Num         Number(9),                              -- الرقم
  dDate       Date Default Sysdate,                   -- التاريخ
  SDate       Date Default Sysdate,                   -- تاريخ البداية
  SHour       Number(2) DEFAULT 0,                    -- ساعة البداية
  SMinute     Number(2) DEFAULT 0,                    -- دقيقة البداية
  EDate       Date Default Sysdate,                   -- تاريخ النهاية
  EHour       Number(2) DEFAULT 23,                   -- ساعة النهاية
  EMinute     Number(2) DEFAULT 59,                   -- دقيقة النهاية
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_OTimeReq_PK         Primary Key (Id ),
  Constraint  Emp_OTimeReq_Num_UK     Unique      (Num),
  Constraint  Emp_OTimeReq_SDate_UK   Unique      (Emp_Id, SDate),
  Constraint  Emp_OTimeReq_EDate_UK   Unique      (Emp_Id, EDate),
  Constraint  Emp_OTimeReq_Emp_FK     Foreign Key (Emp_Id    ) REFERENCES Emp_Emp         (Id),
  Constraint  Emp_OTimeReq_Type_FK    Foreign Key (Type_Id   ) REFERENCES Emp_Cod_Overtime(Id),
  Constraint  Emp_OTimeReq_Approve_FK Foreign Key (Approve_Id) REFERENCES Phs_Cod_Approve (Id),
  CONSTRAINT  Emp_OTimeReq_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User        (Id),
  CONSTRAINT  Emp_OTimeReq_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User        (Id)
)
/
Create Synonym Emp_OTimeReq For Emp_Overtime_Request
/

Create Sequence EMP_MSN_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Missions                             -- مهام العاملين
( Id          Number(9),                              -- مفتاح رئيسي
  Emp_Id      Number(9) NOT NULL,                     -- العامل
  Type_Id     Number(5) Default 1,                    -- نوع المهمة
  Num         Number(9),                              -- الرقم
  dDate       Date Default Sysdate,                   -- التاريخ
  SDate       Date Default Sysdate,                   -- تاريخ البداية
  SHour       Number(2) DEFAULT 0,                    -- ساعة البداية
  SMinute     Number(2) DEFAULT 0,                    -- دقيقة البداية
  EDate       Date Default Sysdate,                   -- تاريخ النهاية
  EHour       Number(2) DEFAULT 23,                   -- ساعة النهاية
  EMinute     Number(2) DEFAULT 59,                   -- دقيقة النهاية
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Req_Id      Number(9),                              -- الطلب
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_Msn_PK       Primary Key (Id  ),
  Constraint  Emp_Msn_Num_UK   Unique      (Num ),
  Constraint  Emp_Msn_Emp_FK   Foreign Key (Emp_Id  ) REFERENCES Emp_Emp     (Id),
  Constraint  Emp_Msn_Type_FK  Foreign Key (Type_Id ) REFERENCES Emp_Cod_Msn (Id),
  Constraint  Emp_Msn_Req_FK   Foreign Key (Req_Id  ) REFERENCES Emp_MsnReq  (Id),
  CONSTRAINT  Emp_Msn_Ins_FK   Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT  Emp_Msn_Upd_FK   Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Emp_Msn For Emp_Missions
/

Create Sequence EMP_LEAVE_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Leaves                               -- الإجازات
( Id          Number(9),                              -- مفتاح رئيسي
  Emp_Id      Number(9) NOT NULL,                     -- العامل
  Type_Id     Number(5) Default 100,                  -- نوع الإجازة 1 إدارية\2 مرضية
  Num         Number(9),                              -- الرقم
  dDate       Date Default Sysdate,                   -- التاريخ
  SDate       Date Default Sysdate,                   -- تاريخ البداية
  SHour       Number(2) DEFAULT 0,                    -- ساعة البداية
  SMinute     Number(2) DEFAULT 0,                    -- دقيقة البداية
  EDate       Date Default Sysdate,                   -- تاريخ النهاية
  EHour       Number(2) DEFAULT 23,                   -- ساعة النهاية
  EMinute     Number(2) DEFAULT 59,                   -- دقيقة النهاية
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Req_Id      Number(9),                              -- الطلب
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_Leave_PK       Primary Key (Id ),
  Constraint  Emp_Leave_Num_UK   Unique      (Num),
  Constraint  Emp_Leave_SDate_UK Unique      (Emp_Id, SDate),
  Constraint  Emp_Leave_EDate_UK Unique      (Emp_Id, EDate),
  Constraint  Emp_Leave_Emp_FK   Foreign Key (Emp_Id  ) REFERENCES Emp_Emp      (Id),
  Constraint  Emp_Leave_Type_FK  Foreign Key (Type_Id ) REFERENCES Emp_Cod_Leave(Id),
  Constraint  Emp_Leave_Req_FK   Foreign Key (Req_Id  ) REFERENCES Emp_LeaveReq (Id),
  CONSTRAINT  Emp_Leave_Ins_FK   Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT  Emp_Leave_Upd_FK   Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Emp_Leave For Emp_Leaves
/

Create Sequence EMP_OTIME_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Overtimes                            -- إضافي العاملين
( Id          Number(9),                              -- مفتاح رئيسي
  Emp_Id      Number(9) NOT NULL,                     -- العامل
  Type_Id     Number(5) Default 1,                    -- نوع المهمة
  Num         Number(9),                              -- الرقم
  dDate       Date Default Sysdate,                   -- التاريخ
  SDate       Date Default Sysdate,                   -- تاريخ البداية
  SHour       Number(2) DEFAULT 0,                    -- ساعة البداية
  SMinute     Number(2) DEFAULT 0,                    -- دقيقة البداية
  EDate       Date Default Sysdate,                   -- تاريخ النهاية
  EHour       Number(2) DEFAULT 23,                   -- ساعة النهاية
  EMinute     Number(2) DEFAULT 59,                   -- دقيقة النهاية
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Req_Id      Number(9),                              -- الطلب
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_OTime_PK       Primary Key (Id ),
  Constraint  Emp_OTime_Num_UK   Unique      (Num),
  Constraint  Emp_OTime_Emp_FK   Foreign Key (Emp_Id  ) REFERENCES Emp_Emp         (Id),
  Constraint  Emp_OTime_Type_FK  Foreign Key (Type_Id ) REFERENCES Emp_Cod_Overtime(Id),
  Constraint  Emp_OTime_Req_FK   Foreign Key (Req_Id  ) REFERENCES Emp_OTimeReq    (Id),
  CONSTRAINT  Emp_OTime_Ins_FK   Foreign Key (Ins_User) References Cpy_User        (Id),
  CONSTRAINT  Emp_OTime_Upd_FK   Foreign Key (Upd_User) References Cpy_User        (Id)
)
/
Create Synonym Emp_OTime For Emp_Overtimes
/

Create Sequence EMP_DBT_seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Debit                                -- الاستجرارات
( Id          Number(9),                              -- مفتاح رئيسي
  Emp_Id      Number(9) NOT NULL,                     -- العامل
  Num         Number(9),                              -- الرقم
  dDate       Date Default Sysdate,                   -- التاريخ
  Amt         Number(25,3) Default 0,                 -- المبلغ
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_Dbt_PK      Primary Key (Id),
  Constraint  Emp_Dbt_Num_UK  Unique      (Num),
  Constraint  Emp_Dbt_Date_UK Unique      (Emp_Id, dDate),
  Constraint  Emp_Dbt_Emp_FK  Foreign Key (Emp_Id  ) REFERENCES Emp_Emp (Id),
  CONSTRAINT  Emp_Dbt_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT  Emp_Dbt_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Dbt For Emp_Debit
/

Create Sequence EMP_LOAN_seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Loans                                -- سلف العاملين
( Id          Number(10),                             -- مفتاح رئيسي
  Emp_Id      Number(9) NOT NULL,                     -- العامل
  Status_Id   Number(1) Default 1,                    -- حالة السلفة \ 1 عادي \ 2 ملغاة أو موقوفة
  PFlg_Id     Number(1) Default 1,                    -- مؤشر دفع القسط في الشهر الحال \ 1 يدفع \ 2 لا يدفع
  TAmt        Number(25,3) Default 0,                 -- قيمة السلفة
  MAmt        Number(25,3) Default 0,                 -- القسط الشهري
  BAmt        Number(25,3) Default 0,                 -- رصيد السلفة
  Num         Number(9),                              -- الرقم
  dDate       Date Default Sysdate,                   -- التاريخ
  SDate       Date Default Sysdate,                   -- تاريخ البداية
  EDate       Date Default Sysdate,                   -- تاريخ النهاية
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_Loan_PK        Primary Key (Id ),
  Constraint  Emp_Loan_Num_UK    Unique      (Num),
  Constraint  Emp_Loan_SDate_UK  Unique      (Emp_Id, SDate),
  Constraint  Emp_Loan_EDate_UK  Unique      (Emp_Id, EDate),
  Constraint  Emp_Loan_Emp_FK    Foreign Key (Emp_Id   ) REFERENCES Emp_Emp       (Id),
  Constraint  Emp_Loan_Status_FK Foreign Key (Status_Id) REFERENCES Phs_Cod_Status(Id),
  Constraint  Emp_Loan_PFlg_FK   Foreign Key (PFlg_Id  ) REFERENCES Phs_Cod_YesNo (Id),
  CONSTRAINT  Emp_Loan_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Emp_Loan_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Emp_Loan For Emp_Loans
/

Create Sequence Emp_PLoan_Seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Loan_Payments                        -- تسديدات سلف العاملين
( Id          Number(10),                             -- مفتاح رئيسي
  Src_Id      Number(1) Default 0,                    -- أصل الوثيقة \ 0 يديوي \ 1 آلي
  TSal_Id     Number(20),                             -- مقتاح سطر العامل في احتساب الراتب
  Loan_Id     Number(10),                             -- مفتاح السلفة
  Amt         Number(25,3) Default 0,                 -- المبلغ
  Num         Number(9),                              -- الرقم
  dDate       Date Default Sysdate,                   -- التاريخ
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_PLoan_PK       Primary Key (Id ),
  Constraint  Emp_PLoan_Num_UK   Unique      (Num),
  Constraint  Emp_PLoan_Loan_FK  Foreign Key (Loan_Id ) REFERENCES Emp_Loan(Id),
  CONSTRAINT  Emp_PLoan_Ins_FK   Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT  Emp_PLoan_Upd_FK   Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_PLoan For Emp_Loan_Payments
/

Create Sequence Emp_Sal_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Salaries_Calculation                 -- احتساب الرواتب
( Id          Number(20),                             -- مفتاح رئيسي
  nYear       Number(4) Default 0,                    -- السنة
  nMonth      Number(2) Default 0,                    -- الشهر
  Status_Id   Number(1) Default 0,                    -- الحالة 0 قيد التحضير \ 1 تم الاحتساب دون اعتماد النتائج \ 2 تم اعتماد احتساب الرواتب
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  Constraint  Emp_Sal_PK        Primary Key (Id),
  Constraint  Emp_Sal_UK        UNIQUE      (nYear, nMonth),
  Constraint  Emp_Sal_Status_FK Foreign Key (Status_Id) References Emp_Cod_CalcSal(Id),
  Constraint  Emp_Sal_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  Constraint  Emp_Sal_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Emp_Sal For Emp_Salaries_Calculation
/

Create Sequence EMP_SALATT_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Salary_Attendance                    -- ملخص الدوام
( Id            Number(20),                           -- مفتاح رئيسي
  Sal_Id        Number(10) NOT NULL,                  -- مفتاح الشهر ضمن السنة
  Emp_Id        Number(9) NOT NULL,                   -- مفتاح العامل
  DAdd          Number(7) Default 0,                  -- الإضافي النهاري
  NAdd          Number(7) Default 0,                  -- الإضافي الليلي
  WAdd          Number(7) Default 0,                  -- الإضافي نهاية الاسبوع
  HAdd          Number(7) Default 0,                  -- الإضافي عطلة
  nAbs          Number(7) Default 0,                  -- الغياب
  nSik70        Number(7) Default 0,                  -- المرض
  nSik80        Number(7) Default 0,                  -- المرض
  nDel          Number(7) Default 0,                  -- التأخير
  nPar          Number(7) Default 0,                  -- الأمومة
  nNPay         Number(7) Default 0,                  -- دون أجر
  Rem           Varchar2(100 Char),                   -- ملاحظات
  Ins_User      Number(5), Ins_Date Date,
  Upd_User      Number(5), Upd_Date Date,
  Constraint    Emp_SalAtt_PK     Primary Key (Id),
  Constraint    Emp_SalAtt_Emp_UK UNIQUE      (Sal_Id, Emp_Id),
  Constraint    Emp_SalAtt_FK     Foreign Key (Sal_Id  ) References Emp_Sal (Id),
  Constraint    Emp_SalAtt_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  Constraint    Emp_SalAtt_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_SalAtt For Emp_Salary_Attendance
/

Create Sequence emp_SalCalc_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Salary_Calculated                    -- جدول احتساب الرواتب
( Id              Number(20),                         -- مفتاح رئيسي
  Sal_Id          Number(20) NOT NULL,                -- مفتاح الشهر ضمن السنة
  Session_Id      Number(20),                         -- مفتاح العملية
  Emp_Id          Number(9) NOT NULL,                 -- العامل
  Sal             Number(25,3) Default 0,             -- الراتب
  FSal            Number(25,3) Default 0,             -- الراتب المالي
  Tam             Number(25,3) Default 0,             -- الراتب التأميني
  WSal            Number(25,3) Default 0,             -- الراتب حسب الدوام
  TaxableSal      Number(25,3) Default 0,             -- الراتب الضريبي
  Net             Number(25,3) Default 0,             -- صافي الراتب
  nRound          Number(25,3) Default 0,             -- القيمة المدورة لأقرب 50
  GETam           Number(25,3) Default 0,             -- حصة العامل من التأمينات الإجتماعية
  GBTam1          Number(25,3) Default 0,             -- نسبة حصة رب العمل من التأمينات الإجتماعية 1
  GBTam2          Number(25,3) Default 0,             -- نسبة حصة رب العمل من التأمينات الإجتماعية 2
  GBTam3          Number(25,3) Default 0,             -- نسبة حصة رب العمل من التأمينات الإجتماعية 3
  GAETam          Number(25,3) Default 0,             -- مبلغ التأمينات - حصة العامل - المبلغ الذي سيحسم الراتب المقطوع والذي سينتج عنه الراتب الذي سيتم احتساب الضريبة بناءا عليه
  GABTam1         Number(25,3) Default 0,             -- مبلغ التأمينات - حصة رب العمل 1
  GABTam2         Number(25,3) Default 0,             -- مبلغ التأمينات - حصة رب العمل 2
  GABTam3         Number(25,3) Default 0,             -- مبلغ التأمينات - حصة رب العمل 3
  GTamStatus_Id   Number(5) Default 1,                -- حالة التأمينات \ 1 يدفعها العامل \ 2 يدفعها رب العمل
  GTaxStatus_Id   Number(5) Default 1,                -- حالة الضريبة \ 1 يدفعها العامل \ 2 يدفعها رب العمل
  GTaxFree        Number(25,3) Default 0,             -- الحد الأدنى المعفى من الضريبة بعد حسم التأمينات
  GTax            Number(25,3) Default 0,             -- الضريبة
  Comp            Number(25,3) Default 0,             -- التعويضات الدائمة
  Ded             Number(25,3) Default 0,             -- الحسميات الدائمة
  AddAdd          Number(25,3) Default 0,             -- الإضافة على الإضافي
  AddSal          Number(25,3) Default 0,             -- الإضافة على الراتب
  SubAdd          Number(25,3) Default 0,             -- الحسم من الإضافي
  SubSal          Number(25,3) Default 0,             -- الحسم من الراتب
  Cons            Number(25,3) Default 0,             -- المكافآت
  SalCons         Number(25,3) Default 0,             -- الإضافات على الراتب
  AddCons         Number(25,3) Default 0,             -- الإضافات على الإضافي
  Pun             Number(25,3) Default 0,             -- العقوبات
  SalPun          Number(25,3) Default 0,             -- الحسميات من الراتب
  AddPun          Number(25,3) Default 0,             -- الحسميات من الإضافي
  Dbt             Number(25,3) Default 0,             -- استجرارات
  Loan            Number(25,3) Default 0,             -- سلف
  NAddPrice       Number(7,3) Default 0,              -- نسبة  الإضافي الليلي
  DAddPrice       Number(7,3) Default 0,              -- نسبة الإضافي النهاري
  WAddPrice       Number(7,3) Default 0,              -- نسبة الإضافي عطلة نهاية الاسبوع
  HAddPrice       Number(7,3) Default 0,              -- نسبة الإضافي عطلة
  DAdd            Number(7) Default 0,                -- دقائق الإضافي النهاري
  NAdd            Number(7) Default 0,                -- دقائق الإضافي الليلي
  WAdd            Number(7) Default 0,                -- دقائق الإضافي نهاية الاسبوع
  HAdd            Number(7) Default 0,                -- دقائق الإضافي عطلة
  NAddAmt         Number(25,3) Default 0,             -- قيمة الإضافي الليلي
  DAddAmt         Number(25,3) Default 0,             -- قيمة الإضافي النهاري
  WAddAmt         Number(25,3) Default 0,             -- قيمة الإضافي عطلة نهاية الاسبوع
  HAddAmt         Number(25,3) Default 0,             -- قيمة الإضافي عطلة
  DelsPrice       Number(7,3) Default 0,              -- نسبة ساعة الغياب
  AbsPrice        Number(7,3) Default 0,              -- نسبة ساعة التأخير
  nDels           Number(7) Default 0,                -- دقائق التأخير
  nAbs            Number(7) Default 0,                -- دقائق الغياب
  nSick           Number(7) Default 0,                -- دقائق المرض
  nSick70         Number(7) Default 0,                -- دقائق المرض
  nSick80         Number(7) Default 0,                -- دقائق المرض
  nPar            Number(7) Default 0,                -- دقائق الأمومة
  nNPay           Number(7) Default 0,                -- دقائق دون أجر
  DelAmt          Number(25,3) Default 0,             -- قيمة التأخير
  AbsAmt          Number(25,3) Default 0,             -- قيمة الغياب
  SickAmt         Number(25,3) Default 0,             -- قيمة المرض
  SickAmt70       Number(25,3) Default 0,             -- قيمة المرض
  SickAmt80       Number(25,3) Default 0,             -- قيمة المرض
  ParAmt          Number(25,3) Default 0,             -- قيمة الأمومة
  NPayAmt         Number(25,3) Default 0,             -- قيمة دون أجر
  Rem             Varchar2(250 Char),                  -- ملاحظات
  Ins_User        Number(5), Ins_Date   Date,
  Upd_User        Number(5), Upd_Date   Date,
  Constraint      Emp_SalCalc_PK      Primary Key (Id),
  Constraint      Emp_SalCalc_UK      UNIQUE      (Sal_Id, Session_Id, Emp_Id),
  Constraint      Emp_SalCalc_FK      Foreign Key (Sal_Id  ) References Emp_Sal (Id),
  Constraint      Emp_SalCalc_Emp_FK  Foreign Key (Emp_Id  ) REFERENCES Emp_Emp (Id),
  CONSTRAINT      Emp_SalCalc_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT      Emp_SalCalc_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_SalCalc For Emp_Salary_Calculated
/

Create Sequence EMP_SALCALCDBT_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_SalCalc_Debit                        -- استجرارات راتب
( Id          Number(20),                             -- مفتاح رئيسي
  TSal_Id     Number(20) NOT NULL,                    -- مفتاح احتساب الراتب
  Dbt_Id      Number(5),                              -- مفتاح رئيسي
  Num         Number(9),                              -- الرقم
  dDate       Date Default Sysdate,                   -- التاريخ
  Amt         Number(25,3) Default 0,                 -- المبلغ
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_SalCalcDbt_PK      Primary Key (Id ),
  CONSTRAINT  Emp_SalCalcDbt_TSal_FK Foreign Key (TSal_Id ) References Emp_SalCalc(Id),
  CONSTRAINT  Emp_SalCalcDbt_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT  Emp_SalCalcDbt_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Emp_SalCalcDbt For Emp_SalCalc_Debit
/

Create Sequence EMP_SALCALCLOAN_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_SalCalc_Loans                        -- سلف راتب
( Id         Number(20),                              -- مفتاح رئيسي
  TSal_Id    Number(20) NOT NULL,                     -- مفتاح احتساب الراتب
  Loan_Id    Number(9),                               -- مفتاح السلفة
  dDate      Date Default Sysdate,                    -- التاريخ
  MAmt       Number(25,3) Default 0,                  -- القسط الشهري
  BAmt       Number(25,3) Default 0,                  -- رصيد السلفة
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_SalCalcLoan_PK      Primary Key (Id),
  CONSTRAINT Emp_SalCalcLoan_TSal_FK Foreign Key (TSal_Id ) References Emp_SalCalc(Id),
  CONSTRAINT Emp_SalCalcLoan_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT Emp_SalCalcLoan_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Emp_SalCalcLoan For Emp_SalCalc_Loans
/

Create Sequence EMP_SALCALCCON_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_SalCalc_Consideration                -- مكافآت راتب
( Id           Number(20),                            -- مفتاح رئيسي
  TSal_Id      Number(20) NOT NULL,                   -- مفتاح احتساب الراتب
  Num          Number(9),                             -- الرقم
  dDate        Date Default Sysdate,                  -- التاريخ
  CTyp_Id      Number(5),                             -- مفتاح العقوبة
  Kind_Id      Number(1) Default 1,                   -- النوع 1 نسبة \2 مقطوع \3 تحدد حين المكافأة
  Amt          Number(25,3) Default 0,                -- القيمة
  Rem          Varchar2(100 Char),                    -- ملاحظات
  Minutes      Number(9) Default 0,                   -- الدقائق
  Ins_User     Number(5), Ins_Date   Date,
  Upd_User     Number(5), Upd_Date   Date,
  Constraint   Emp_SalCalcCon_PK      Primary Key (Id),
  CONSTRAINT   Emp_SalCalcCon_TSal_FK Foreign Key (TSal_Id ) References Emp_SalCalc(Id),
  CONSTRAINT   Emp_SalCalcCon_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT   Emp_SalCalcCon_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Emp_SalCalcCon For Emp_SalCalc_ConsIderation
/

Create Sequence EMP_SALCALCPUN_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_SalCalc_Punishment                   -- عقوبات راتب
( Id           Number(20),                            -- مفتاح رئيسي
  TSal_Id      Number(20) NOT NULL,                   -- مفتاح احتساب الراتب
  Num          Number(9),                             -- الرقم
  dDate        Date Default Sysdate,                  -- التاريخ
  PTyp_Id      Number(20),                            -- مفتاح العقوبة
  Kind_Id      Number(1) Default 1,                   -- النوع 1 نسبة \2 مقطوع \3 تحدد حين العقوبة
  Amt          Number(25,3) Default 0,                -- القيمة
  RInM         Number(3)  Default 0,                  -- التكرار ضمن الشهر
  Minutes      Number(9) Default 0,                   -- دقائق العقوبة
  Rem          Varchar2(100 Char),                    -- ملاحظات
  Ins_User     Number(5), Ins_Date   Date,
  Upd_User     Number(5), Upd_Date   Date,
  Constraint   Emp_SalCalcPun_PK      Primary Key (Id),
  CONSTRAINT   Emp_SalCalcPun_TSal_FK Foreign Key (TSal_Id ) References Emp_SalCalc(Id),
  CONSTRAINT   Emp_SalCalcPun_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT   Emp_SalCalcPun_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Emp_SalCalcPun For Emp_SalCalc_Punishment
/

Create Sequence EMP_SALCALCCOMP_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_SalCalc_Compensation                 -- تعويضات راتب
( Id         Number(20),                              -- مفتاح رئيسي
  TSal_Id    Number(20) NOT NULL,                     -- مفتاح احتساب الراتب
  ECom_Id    Number(20) NOT NULL,                     -- مفتاح تعويض العامل
  Com_Id     Number(20) NOT NULL,                     -- التعويض
  Type_Id    Number(5) Default 1,                     -- النوع
  PAmt       Number(25,3) Default 0,                  -- مبلغ\نسبة
  Amt        Number(25,3) Default 0,                  -- المبلغ
  Tax        Number(25,3) Default 0,                  -- الضريبة
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_SalCalcCom_PK      Primary Key (Id),
  CONSTRAINT Emp_SalCalcCom_TSal_FK Foreign Key (TSal_Id ) References Emp_SalCalc(Id),
  CONSTRAINT Emp_SalCalcCom_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT Emp_SalCalcCom_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Emp_SalCalcComp For Emp_SalCalc_Compensation
/

Create Sequence EMP_SALCALCDED_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_SalCalc_Deduction                    -- حسميات راتب
( Id         Number(20),                              -- مفتاح رئيسي
  TSal_Id    Number(20) NOT NULL,                     -- مفتاح احتساب الراتب
  EDed_Id    Number(20) NOT NULL,                     -- مفتاح حسم العامل
  Ded_Id     Number(20) NOT NULL,                     -- الحسم
  Type_Id    Number(1) Default 1,                     -- النوع
  PAmt       Number(25,3) Default 0,                  -- مبلغ\نسبة
  Amt        Number(25,3) Default 0,                  -- المبلغ
  Tax        Number(25,3) Default 0,                  -- الضريبة
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Emp_SalCalcDed_PK      Primary Key (Id),
  CONSTRAINT Emp_SalCalcDed_TSal_FK Foreign Key (TSal_Id ) References Emp_SalCalc(Id),
  CONSTRAINT Emp_SalCalcDed_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT Emp_SalCalcDed_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Emp_SalCalcDed For Emp_SalCalc_Deduction
/

Create Sequence EMP_SALCALCAOSAL_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_SalCalc_AddOn                       -- الإضافات على الراتب
( Id          Number(20),                            -- مفتاح رئيسي
  TSal_Id     Number(20) NOT NULL,                   -- مفتاح الأب
  AddTo_Id    Number(1) Default 2,                   -- مضافا إلى \ 1 الراتب \ 2 الإضافي
  Amt         Number(25,3) Default 0,                -- القيمة
  Rem         Varchar2(100 Char),                    -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_CalcSalAdd_PK      Primary Key (Id),
  CONSTRAINT  Emp_CalcSalAdd_TSal_FK Foreign Key (TSal_Id ) References Emp_SalCalc(Id),
  CONSTRAINT  Emp_CalcSalAdd_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT  Emp_CalcSalAdd_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Emp_SalCalcAOSal For Emp_SalCalc_AddOn
/

Create Sequence EMP_SALCALCSFSAL_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_SalCalc_SubFrom                      -- طرح من راتب
( Id          Number(20),                             -- مفتاح رئيسي
  TSal_Id     Number(20) NOT NULL,                   -- مفتاح الأب
  SubFrom_Id  Number(1) Default 2,                    -- مطروحا من \ 1 الراتب \ 2 الإضافي
  Amt         Number(25,3) Default 0,                 -- القيمة
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_SalCalcSub_PK      Primary Key (Id),
  CONSTRAINT  Emp_SalCalcSub_TSal_FK Foreign Key (TSal_Id ) References Emp_SalCalc(Id),
  CONSTRAINT  Emp_SalCalcSub_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT  Emp_SalCalcSub_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Emp_SalCalcSFSal For Emp_SalCalc_SubFrom
/

Create Sequence EMP_TMPVACREP_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Temporary_Vacation_Rep               -- تقرير أرصدة الإجازات
( Id          Number(20),                             -- مفتاح رئيسي
  Emp_Id      Number(9),                              -- العامل
  SDate       Date Default Sysdate,                   -- تاريخ المباشرة
  Base        Number(7,2),                            -- عدد ساعات الإجازات المفترض أخذها
  Done        Number(7,2),                            -- عدد ساعات الإجازات المأخوذة
  Blnc        Number(7,2),                            -- عدد ساعات الإجازات المأخوذة
  Amt         Number(25,3) Default 0,                 -- قيمة الرصيد المتبقي حسب أجر العامل
  Rem         Varchar2(100 Char),                     -- ملاحظات
  CONSTRAINT  Emp_TmpVacRep_Emp_FK Foreign Key (Emp_Id) References Emp_Emp(Id)
)
/
Create Synonym Emp_TmpVacRep For Emp_Temporary_Vacation_Rep
/

Create Sequence EMP_TMPSALDLYREP_seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Emp_Temporary_SalDaily_Rep               -- تقرير الرواتب - يومية صندوق
( Id          Number(20),                             -- مفتاح
  Ord         Number(9),                              -- مسلسل
  Dbt         Number(25,3) Default 0,                 -- مدين
  Crd         Number(25,3) Default 0,                 -- دائن
  vDesc        Varchar2(100 Char)                      -- البيان
)
/
Create Synonym Emp_TmpSalDlyRep For Emp_Temporary_SalDaily_Rep
/
