Create Table Emp_Attendance                           -- ملخص الدوام
( Id          Number(20),                             -- مفتاح رئيسي
  dDate       Date,                                   -- التاريخ
  EName       Varchar2(100 Char),                     -- اسم الموظف
  ENum        Number(9),                              -- رقم العامل
  nAdd        Number(25,3) Default 0,                 -- الإضافي
  nAbs        Number(25,3) Default 0,                 -- الغياب
  nSik        Number(25,3) Default 0,                 -- المرض
  nDel        Number(25,3) Default 0,                 -- التأخير
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Constraint  Emp_Attend_PK     Primary Key (Id)
)
/
Create Synonym Emp_Att For Emp_Attendance
/

Create Table Emp_Finger_Print                         -- حركات الأجهزة
( Id           Number(20),                            -- مفتاح رئيسي
  nSession     Number(20),                            -- جلسة العمل
  MNUM         Number(9),                             -- رقم الجهاز
  ENUM         Number(9),                             -- رقم العامل
  VMODE        Number(9),                             -- نمط التدقيق
  OMODE        Number(9),                             -- نمط الخروج
  IOMODE       Number(9),                             -- حالة الدخول أو الخروج 1 دخول\2 خروج\3 مطعم
  vTIME        Varchar2(100 Char),                    -- الوقت
  dDate        Date Default SysDate,                  -- التاريخ
  nHour        Number(2) Default 0,                   -- الساعة
  nMinute      Number(2) Default 0,                   -- الدقيقة
  Constraint   Emp_Fngr_PK Primary Key (Id)
)
/
Create Synonym Emp_FngrPrnt For Emp_Finger_Print
/

Create Table Emp_FingerPrint_Logs                     -- حركات الأجهزة
( Id            Number(20),                           -- مفتاح رئيسي
  nSession      Number(20) Default 0,                 -- جلسة العمل
  MNum          Number(9) Default 1,                  -- رقم الجهاز
  ENum          Number(9),                            -- رقم العامل
  VMode         Number(9) Default 0,                  -- نمط التدقيق
  OMode         Number(9) Default 0,                  -- نمط الخروج
  IOMode        Number(9) Default 0,                  -- الحالة 0 غير محدد\1 دخول\2 خروج\3 مطعم
  vTime         Varchar2(100 Char),                   -- الوقت
  dDate         Date Default SysDate,                 -- التاريخ
  nHour         Number(2) Default 0,                  -- الساعة
  nMinute       Number(2) Default 0,                  -- الدقيقة
  Constraint    Emp_FPrint_PK Primary Key (Id)
)
/
Create Synonym Emp_FPrint   For Emp_FingerPrint_Logs
/

Create Table Emp_Daily                                -- دليل الأيام
( Id          Number(10),                             -- مفتاح رئيسي
  dDate       Date Default SysDate,                   -- التاريخ
  Commit_Id   Number(1) Default 0,                    -- حالة التثبيت
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_Day_PK      Primary Key (Id),
  CONSTRAINT  Emp_Day_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT  Emp_Day_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Day For Emp_Daily
/

Create Table Emp_Day_Attendance_File                  -- ملفات الدوام
( Id          Number(20),                             -- مفتاح رئيسي
  Day_Id      Number(10) NOT NULL,                    -- مفتاح اليوم
  Name        Varchar2(100 Char),                     -- اسم الملف
  vFile       Varchar2(100 Char),                     -- اسم الملف
  Rem         Varchar2(250 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_DayAtt_PK      Primary Key (Id  ),
  Constraint  Emp_DayAtt_Name_UK Unique      (Day_Id, Name ),
  Constraint  Emp_DayAtt_File_UK Unique      (Day_Id, vFile),
  Constraint  Emp_DayAtt_Day_FK  Foreign Key (Day_Id  ) REFERENCES Emp_Day (Id),
  CONSTRAINT  Emp_DayAtt_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT  Emp_DayAtt_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_DayAttFile For Emp_Day_Attendance_File
/

Create Table Emp_Entrance                             -- ساعات الدخول ليوم
( Id          Number(20),                             -- مفتاح رئيسي
  Day_Id      Number(10) NOT NULL,                    -- مفتاح اليوم
  Emp_Id      Number(9) NOT NULL,                     -- العامل
  nHour       Number(2) Default 0,                    -- الساعة
  nMinute     Number(2) Default 0,                    -- الدقيقة
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_Ent_PK      Primary Key (Id),
  Constraint  Emp_Ent_Time_UK Unique      (Day_Id, Emp_Id, nHour, nMinute ),
  Constraint  Emp_Ent_Day_FK  Foreign Key (Day_Id  ) REFERENCES Emp_Day (Id),
  Constraint  Emp_Ent_Emp_FK  Foreign Key (Emp_Id  ) REFERENCES Emp_Emp (Id),
  CONSTRAINT  Emp_Ent_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT  Emp_Ent_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Ent For Emp_Entrance
/

Create Table Emp_Outgoing                             -- ساعات الخروج ليوم
( Id          Number(20),                             -- مفتاح رئيسي
  Day_Id      Number(10) NOT NULL,                    -- مفتاح اليوم
  Emp_Id      Number(9) NOT NULL,                     -- العامل
  nHour       Number(2) Default 0,                    -- الساعة
  nMinute     Number(2) Default 0,                    -- الدقيقة
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  Constraint  Emp_Out_PK      Primary Key (Id),
  Constraint  Emp_Out_Time_UK Unique      (Day_Id, Emp_Id, nHour, nMinute),
  Constraint  Emp_Out_Day_FK  Foreign Key (Day_Id  ) REFERENCES Emp_Day (Id),
  Constraint  Emp_Out_Emp_FK  Foreign Key (Emp_Id  ) REFERENCES Emp_Emp (Id),
  CONSTRAINT  Emp_Out_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT  Emp_Out_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Emp_Out For Emp_Outgoing
/

Create Table Emp_Employee_Daily_EntOut               -- ساعات الدخول و الخروج ليوم
( Id            Number(10),                           -- مفتاح رئيسي
  Emp_Id        Number(10) NOT NULL,                 -- العامل
  Day_Id        Number(10) NOT NULL,                 -- مفتاح اليوم
  WGrp_Id       Number(10) NOT NULL,                 -- مجموعة الدوام
  Audit_Id      Number(1) Default 2,                 -- حالة التدقيق \ 0 غير مدقق \ 1 مدقق
  Excuse_Id     Number(1) Default 2,                 -- حالة السماح أو تبرير أي مخالفة ضمن السطر \ 1 سماح \ 0 حسب المخالفة
  WeekEnd_Id    Number(1) Default 2,                 -- يوم عطلة اسبوعية \ 1 عطلة اسبوعية \ 0 يوم دوام
  HolyDay_Id    Number(1) Default 2,                 -- يوم عطلة \ 1 عطلة \ 0 دوام
  Off_Id        Number(1) Default 2,                 -- يوم غياب \ 1 غياب \ 0 دوام
  Sick_Id       Number(1) Default 2,                 -- يوم مرض \ 1  مرض \ 0 دوام
  Vac_Id        Number(1) Default 2,                 -- يوم إجازة \ 1 إجازة \ 0 دوام
  NPay_Id       Number(1) Default 2,                 -- يوم دون أجر \ 1 دون أجر \ 0 دوام
  VPar_Id       Number(1) Default 2,                 -- يوم أمومة \ 1 أمومة \ 0 دوام
  nHNPay        Number(4) Default 0,                 -- عدد دقائق الإجازة الساعية دون أجر
  nHPar         Number(4) Default 0,                 -- عدد دقائق الإجازة الساعية أمومة
  nHVac         Number(4) Default 0,                 -- عدد دقائق الإجازة الساعية
  nEPun         Number(2) Default 0,                 -- حالة تنفيذ عقوبة الدخول المبكر أو المتأخر
  nOPun         Number(2) Default 0,                 -- حالة تنفيذ عقوبة الخروج المبكر أو المتأخر
  nAddH         Number(2) Default 0,                 -- عدد ساعات العمل المطلوب ليحسب الإضافي بعدها
  nAddM         Number(2) Default 0,                 -- عدد دقائق العمل المطلوب ليحسب الإضافي بعدها
  nAdd          Number(4) Default 0,                 -- الإضافي
  nRAdd         Number(4) Default 0,                 -- الإضافي المطلوب
  nAbs          Number(4) Default 0,                 -- الغياب اليومي
  nHAbs         Number(4) Default 0,                 -- الغياب الساعي مجموع ساعات
  nHCAbs        Number(4) Default 0,                 -- الغياب الساعي عدد مرات
  nSik          Number(4) Default 0,                 -- المرض
  nDel          Number(4) Default 0,                 -- التأخير
  nErr          Number(2) Default 0,                 -- رمز الخطأ 0 لايوجد خطأ
  nCode         Number(5) Default 0,                 -- رمز الحالة ليتم التجميع عليها في الإحصائيات
  Rem           Varchar2(100 Char),                   -- ملاحظات
  ARem          Varchar2(100 Char),                   -- ملاحظات البرنامج
  Ins_User      Number(5), Ins_Date   Date,
  Upd_User      Number(5), Upd_Date   Date,
  Constraint    Emp_EDeo_PK          Primary Key (Id),
  Constraint    Emp_EDeo_Day_FK      Foreign Key (Day_Id    ) References Emp_Day      (Id),
  Constraint    Emp_EDeo_Emp_FK      Foreign Key (Emp_Id    ) References Emp_Emp      (Id),
  Constraint    Emp_EDeo_WGrp_FK     Foreign Key (WGrp_Id   ) References Emp_WrkGrp   (Id),
  Constraint    Emp_EDeo_Audit_FK    Foreign Key (Audit_Id  ) References Phs_Cod_YesNo(Id),
  Constraint    Emp_EDeo_Execuse_FK  Foreign Key (Excuse_Id ) References Phs_Cod_YesNo(Id),
  Constraint    Emp_EDeo_Weekend_FK  Foreign Key (WeekEnd_Id) References Phs_Cod_YesNo(Id),
  Constraint    Emp_EDeo_Hollyday_FK Foreign Key (HolyDay_Id) References Phs_Cod_YesNo(Id),
  Constraint    Emp_EDeo_Off_FK      Foreign Key (Off_Id    ) References Phs_Cod_YesNo(Id),
  Constraint    Emp_EDeo_Sick_FK     Foreign Key (Sick_Id   ) References Phs_Cod_YesNo(Id),
  Constraint    Emp_EDeo_Vac_FK      Foreign Key (Vac_Id    ) References Phs_Cod_YesNo(Id),
  Constraint    Emp_EDeo_NPay_FK     Foreign Key (NPay_Id   ) References Phs_Cod_YesNo(Id),
  Constraint    Emp_EDeo_VPay_FK     Foreign Key (VPar_Id   ) References Phs_Cod_YesNo(Id),
  Constraint    Emp_EDeo_Ins_FK      Foreign Key (Ins_User  ) References Cpy_User     (Id),
  Constraint    Emp_EDeo_Upd_FK      Foreign Key (Upd_User  ) References Cpy_User     (Id)
)
/
Create Synonym Emp_EDEO For Emp_Employee_Daily_EntOut
/

Create Table Emp_Employee_DEO_Fingerprint             -- ساعات الدخول و الخروج ليوم
( Id            Number(10),                           -- مفتاح رئيسي
  EDeo_Id       Number(10) NOT NULL,                  -- مفتاح الأب
  nHour         Number(2) Default 0,                  -- ساعة
  nMinute       Number(2) Default 0,                  -- دقيقة
  Type_Id       Number(1) Default 1,                  -- النوع 1 دخول / 2 خروج في الأجهزة التي يمكن تحديد نوع البصمة
  Rem           Varchar2(100 Char),                   -- ملاحظات
  Ins_User      Number(5), Ins_Date   Date,
  Upd_User      Number(5), Upd_Date   Date,
  Constraint    Emp_EDeoF_PK         Primary Key (Id),
  Constraint    Emp_EDeoF_ETime_UK   Unique      (EDeo_Id, nHour, nMinute),
  Constraint    Emp_EDeoF_EDeo_FK    Foreign Key (EDeo_Id ) References Emp_EDEO       (Id),
  Constraint    Emp_EDeoF_AttTyep_FK Foreign Key (EDeo_Id ) References Emp_Cod_AttType(Id),
  Constraint    Emp_EDeoF_Ins_FK     Foreign Key (Ins_User) References Cpy_User       (Id),
  Constraint    Emp_EDeoF_Upd_FK     Foreign Key (Upd_User) References Cpy_User       (Id)
)
/
Create Synonym Emp_EDEOF For Emp_Employee_DEO_Fingerprint
/

Create Table Emp_Employee_DEO_Merge                   -- ساعات الدخول و الخروج ليوم
( Id            Number(10),                           -- مفتاح رئيسي
  EDeo_Id       Number(10) NOT NULL,                 -- مفتاح الأب
  Audit_Id      Number(1) Default 2,                 -- حالة التدقيق \ 0 غير مدقق \ 1 مدقق
  Excuse_Id     Number(1) Default 2,                 -- حالة السماح أو تبرير أي مخالفة ضمن السطر \ 1 سماح \ 0 حسب المخالفة
  Type_Id       Number(1) Default 0,                 -- النوع / 1 دوام / 2 إضافي / 3 إجازة / 4 مرض
  EH            Number(2) Default 0,                 -- ساعة الدخول
  EM            Number(2) Default 0,                 -- دقيقة الدخول
  OH            Number(2) Default 0,                 -- ساعة الخروج
  OM            Number(2) Default 0,                 -- دقيقة الخروج
  Rem           Varchar2(100 Char),                   -- ملاحظات
  Ins_User      Number(5), Ins_Date   Date,
  Upd_User      Number(5), Upd_Date   Date,
  Constraint    Emp_EDeoM_PK        Primary Key (Id),
  Constraint    Emp_EDeoM_ETime_UK  Unique      (EDeo_Id, EH, EM),
  Constraint    Emp_EDeoM_OTime_UK  Unique      (EDeo_Id, OH, OM),
  Constraint    Emp_EDeoM_EDeo_FK   Foreign Key (EDeo_Id ) References Emp_EDEO     (Id),
  Constraint    Emp_EDeoM_Audit_FK  Foreign Key (Audit_Id) References Phs_Cod_YesNo(Id),
  Constraint    Emp_EDeoM_Ins_FK    Foreign Key (Ins_User) References Cpy_User     (Id),
  Constraint    Emp_EDeoM_Upd_FK    Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Emp_EDEOM For Emp_Employee_DEO_Merge
/

Create Table Emp_Daily_EntOut                         -- ساعات الدخول و الخروج ليوم
( Id            Number(20),                           -- مفتاح رئيسي
  Day_Id        Number(10) NOT NULL,                  -- مفتاح اليوم
  Emp_Id        Number(9) NOT NULL,                   -- العامل
  WGrp_Id       Number(5) NOT NULL,                   -- مجموعة الدوام
  Audit_Id      Number(2) Default 2,                  -- حالة التدقيق \ 0 غير مدقق \ 1 مدقق
  Excuse_Id     Number(2) Default 2,                  -- حالة السماح أو تبرير أي مخالفة ضمن السطر \ 1 سماح \ 0 حسب المخالفة
  WeekEnd_Id    Number(2) Default 2,                  -- يوم جمعة \ 1 جمعة \ 0 يوم دوام
  HolyDay_Id    Number(2) Default 2,                  -- يوم عطلة \ 1 عطلة \ 0 دوام
  Vacation_Id   Number(2) Default 2,                  -- إجازة \ 1 إجازة \ 0 دوام
  Mission_Id    Number(2) Default 2,                  -- مهمة \ 1 مهمة \ 0 دوام
  MHour         Number(2) Default 0,                  -- ساعات المهمة
  MMinute       Number(2) Default 0,                  -- دقائق المهمة
  HVacation_Id  Number(2) Default 2,                  -- إجازة ساعية \ 1 إجازة \ 0 دوام
  VHour         Number(2) Default 0,                  -- ساعات الإجازة
  VMinute       Number(2) Default 0,                  -- دقائق الإجازة
  Payed_Id      Number(2) Default 2,                  -- حالة الدفع \ 1 غير مدفوع \ 0 مدفوع
  Sick_Id       Number(2) Default 2,                  -- يوم مرض \ 1 مرض \ 0 دوام
  DayOff_Id     Number(2) Default 2,                  -- يوم غياب \ 1 غياب \ 0 دوام
  EPun_Id       Number(2) Default 2,                  -- حالة تنفيذ عقوبة الدخول المبكر أو المتأخر
  OPun_Id       Number(2) Default 2,                  -- حالة تنفيذ عقوبة الخروج المبكر أو المتأخر
  E1Hour        Number(2) Default 0,                  -- ساعة الدخول1
  E1Minute      Number(2) Default 0,                  -- دقيقة الدخول1
  O1Hour        Number(2) Default 0,                  -- ساعة الخروج1
  O1Minute      Number(2) Default 0,                  -- دقيقة الخروج1
  E2Hour        Number(2) Default 0,                  -- ساعة الدخول2
  E2Minute      Number(2) Default 0,                  -- دقيقة الدخول2
  O2Hour        Number(2) Default 0,                  -- ساعة الخروج2
  O2Minute      Number(2) Default 0,                  -- دقيقة الخروج2
  LEHour        Number(2) Default 0,                  -- ساعة تأخير
  LEMinute      Number(2) Default 0,                  -- دقيقة تأخير
  LOHour        Number(2) Default 0,                  -- ساعة خروج مبكر
  LOMinute      Number(2) Default 0,                  -- دقيقة خروج مبكر
  BEHour        Number(2) Default 0,                  -- ساعة دخول مبكر
  BEMinute      Number(2) Default 0,                  -- دقيقة دخول مبكر
  AOHour        Number(2) Default 0,                  -- ساعة خروج متأخر
  AOMinute      Number(2) Default 0,                  -- دقيقة خروج متأخر
  DAHour        Number(2) Default 0,                  -- ساعة إضافي نهاري
  DAMinute      Number(2) Default 0,                  -- دقيقة إضافي نهاري
  NAHour        Number(2) Default 0,                  -- ساعة إضافي ليلي
  NAMinute      Number(2) Default 0,                  -- دقيقة إضافي ليلي
  AHour         Number(2) Default 0,                  -- ساعة إضافي
  AMinute       Number(2) Default 0,                  -- دقيقة إضافي
  THour         Number(2) Default 0,                  -- مجموع الساعات
  TMinute       Number(2) Default 0,                  -- مجموع الدقائق
  AddH          Number(2) Default 0,                  -- عدد ساعات العمل المطلوب ليحسب الإضافي بعدها
  AddM          Number(2) Default 0,                  -- عدد دقائق العمل المطلوب ليحسب الإضافي بعدها
  nE1H          Number(2) Default 0,                  -- ساعة الدخول1
  nE1M          Number(2) Default 0,                  -- دقيقة الدخول1
  nO1H          Number(2) Default 0,                  -- ساعة الخروج1
  nO1M          Number(2) Default 0,                  -- دقيقة الخروج1
  nE2H          Number(2) Default 0,                  -- ساعة الدخول2
  nE2M          Number(2) Default 0,                  -- دقيقة الدخول2
  nO2H          Number(2) Default 0,                  -- ساعة الخروج2
  nO2M          Number(2) Default 0,                  -- دقيقة الخروج2
  nAdd          Number(4) Default 0,                  -- الإضافي
  nAddReq       Number(4) Default 0,                  -- الإضافي المطلوب
  nAbs          Number(4) Default 0,                  -- الغياب
  nSik          Number(4) Default 0,                  -- المرض
  nDel          Number(4) Default 0,                  -- التأخير
  Rem           Varchar2(100 Char),                   -- ملاحظات
  Ins_User      Number(5), Ins_Date   Date,
  Upd_User      Number(5), Upd_Date   Date,
  Constraint    Emp_DEO_PK        Primary Key (Id),
  Constraint    Emp_DEO_ETime1_UK Unique      (Day_Id, Emp_Id, E1Hour, E1Minute),
  Constraint    Emp_DEO_ETime2_UK Unique      (Day_Id, Emp_Id, E2Hour, E2Minute),
  Constraint    Emp_DEO_OTime1_UK Unique      (Day_Id, Emp_Id, O1Hour, O1Minute),
  Constraint    Emp_DEO_OTime2_UK Unique      (Day_Id, Emp_Id, O2Hour, O2Minute),
  Constraint    Emp_DEO_Day_FK    Foreign Key (Day_Id  ) REFERENCES Emp_Day   (Id),
  Constraint    Emp_DEO_Emp_FK    Foreign Key (Emp_Id  ) REFERENCES Emp_Emp   (Id),
  CONSTRAINT    Emp_DEO_WGrp_FK   Foreign Key (WGrp_Id ) References Emp_WrkGrp(Id),
  CONSTRAINT    Emp_DEO_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT    Emp_DEO_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Emp_DEO For Emp_Daily_EntOut
/
