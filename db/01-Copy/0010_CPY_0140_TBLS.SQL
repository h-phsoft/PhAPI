Create Sequence Cpy_Cod_Task_Action_Seq MinValue 1 Start With 1 MaxValue 999 INCREMENT BY 1 CACHE 2;
Create Table Copy_Code_Task_Action                         -- جدول ترميز إجراءات المهام
( Id         Number(3) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Cod_Task_Action_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_Task_Action_UK     UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_Task_Action_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Cod_Task_Action_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Cod_Task_Action_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Cod_Task_Action For Copy_Code_Task_Action
/
Insert into Cpy_Cod_Task_Action (Id,Name) values (0,'-');
Insert into Cpy_Cod_Task_Action (Id,Name) values (1,'اجرائية 1');
Insert into Cpy_Cod_Task_Action (Id,Name) values (2,'اجرائية 2');
----------------------------------------------------------------------------------------------------
Create Table Copy_Code_Rate                              -- جدول ترميز 
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Cod_Rate_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_Rate_UK     UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_Rate_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Cpy_Cod_Rate_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Cpy_Cod_Rate For Copy_Code_Rate
/
Insert into Cpy_Cod_Rate (Id,Name) values (0,'-');
Insert into Cpy_Cod_Rate (Id,Name) values (1,'1');
Insert into Cpy_Cod_Rate (Id,Name) values (2,'2');
Insert into Cpy_Cod_Rate (Id,Name) values (3,'3');
Insert into Cpy_Cod_Rate (Id,Name) values (4,'4');
Insert into Cpy_Cod_Rate (Id,Name) values (5,'5');
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Cod_Task_Status_Seq MinValue 1 Start With 1 MaxValue 99 INCREMENT BY 1 CACHE 2;
Create Table Copy_Code_Task_Status                         -- جدول ترميز حالات المهام
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Bcolor     Varchar2(20  Char) Default '#FFFFFF00',       -- لون الخلفية
  Fcolor     Varchar2(20  Char) Default '#000000'  ,       -- لون الكتابة
  NOrder     Number(3)          Default 0          ,       -- الترتيب
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Cod_Task_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_Task_Status_UK     UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_Task_Status_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Cod_Task_Status_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Cod_Task_Status_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Cod_Task_Status For Copy_Code_Task_Status
/
Insert into Cpy_Cod_Task_Status (Id,Name) values (0,'-');
Insert into Cpy_Cod_Task_Status (Id,Name,Bcolor) values (1,'New','blue');
Insert into Cpy_Cod_Task_Status (Id,Name,Bcolor) values (2,'In progress','orange');
Insert into Cpy_Cod_Task_Status (Id,Name,Bcolor) values (3,'Done','green');
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Cod_Task_Priority_Seq MinValue 1 Start With 1 MaxValue 99 INCREMENT BY 1 CACHE 2;
Create Table Copy_Code_Task_Priority                       -- جدول ترميز أولويات المهام
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Color      Varchar2(20  Char)  Default '#FFFFFF00',      -- اللون
  NOrder     Number(3)           Default 0          ,      -- الترتيب
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Cod_Task_Priority_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_Task_Priority_UK     UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_Task_Priority_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Cod_Task_Priority_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Cod_Task_Priority_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Cod_Task_Priority For Copy_Code_Task_Priority
/
Insert into Cpy_Cod_Task_Priority (Id,Name) values (0,'-');
Insert into Cpy_Cod_Task_Priority (Id,Name,Color) values (1,'مهمة جدا','red');
Insert into Cpy_Cod_Task_Priority (Id,Name,Color) values (2,'متوسط الاهمية','#eee');
----------------------------------------------------------------------------------------------------
Create Table Copy_Code_Task_Privacy                        -- جدول ترميز 
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Icon       Varchar2(20  Char),                           -- الرمز
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Cod_Task_Privacy_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_Task_Privacy_UK     UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_Task_Privacy_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Cpy_Cod_Task_Privacy_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Cpy_Cod_Task_Privacy For Copy_Code_Task_Privacy
/
Insert into Cpy_Cod_Task_Privacy (Id,Name,Icon) values (0,'-','');
Insert into Cpy_Cod_Task_Privacy (Id,Name,Icon) values (1,'Public'  , 'bi-unlock');
Insert into Cpy_Cod_Task_Privacy (Id,Name,Icon) values (2,'Member'  , 'bi-people');
Insert into Cpy_Cod_Task_Privacy (Id,Name,Icon) values (3,'Personal', 'bi-lock'  );
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Task_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Task              		                   -- المهام
( Id          Number(9) NOT NULL,                          -- مفتاح رئيسي
  Task_Id     Number(9),                                   -- مفتاح الأب
  Proj_Id     Number(9),                                   -- مفتاح المشروع
  User_Id     Number(5) NOT NULL,				                   -- الموظف
  Dept_Id     Number(5) Default 0,				                 -- الإدارة
  Unit_Id     Number(5) Default 0,				                 -- الوحدة
  Priority_Id Number(1) Default 1,			                   -- درجة الأهمية
  Status_Id   Number(2) Default 1,			                   -- الحالة
  Privacy_Id  Number(1) Default 1,			                   -- الخصوصية
  Comp_Perc   Number(3) Default 0,                         -- نسبة الإنجاز
  Reminder_Id Number(1) Default 1,			                   -- التذكير
  RemindDays  Number(3) Default 1,                         -- أيام تكرار التنبيه
  RemindDate  Date Default Sysdate,                        -- تاريخ التذكير
  SDate       Date Default Sysdate,                        -- تاريخ البداية المتوقع
  EDate       Date NOT NULL,                               -- تاريخ النهاية المتوقع
  ASDate      Date,                                        -- تاريخ البداية الفعلي
  AEDate      Date,                                        -- تاريخ النهاية الفعلي
  Name        Varchar2(100 Char) NOT NULL,	 	             -- الاسم
  Rem         Varchar2(250 Char),			                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Cpy_Task_PK          Primary Key (Id),
  CONSTRAINT  Cpy_Task_Status_FK   Foreign Key (Status_Id  ) References Cpy_Cod_Task_Status  (Id),
  CONSTRAINT  Cpy_Task_Priority_FK Foreign Key (Priority_Id) References Cpy_Cod_Task_Priority(Id),
  CONSTRAINT  Cpy_Task_Privacy_FK  Foreign Key (Privacy_Id ) References Cpy_Cod_Task_Privacy (Id),
  CONSTRAINT  Cpy_Task_Reminder_FK Foreign Key (Reminder_Id) References Phs_Cod_YesNo        (Id),
  CONSTRAINT  Cpy_Task_Dept_FK     Foreign Key (Dept_Id    ) References Cpy_Dept             (Id),
  CONSTRAINT  Cpy_Task_Unit_FK     Foreign Key (Unit_Id    ) References Cpy_Unit             (Id),
  CONSTRAINT  Cpy_Task_User_FK     Foreign Key (User_Id    ) References Cpy_User             (Id),
  CONSTRAINT  Cpy_Task_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User             (Id),
  CONSTRAINT  Cpy_Task_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User             (Id)
)
/
Create Synonym Cpy_Task For Copy_Task
/
-- INSERT INTO Cpy_Task (Id, Task_Id, User_Id, Name, EDate) VALUES (0, 0, 0, '-', To_Date('31-12-2999','DD-MM-YYYY'));
Alter Table Copy_Task Add CONSTRAINT Cpy_Task_Task_FK Foreign Key (Task_Id) References Cpy_Task(Id);
----------------------------------------------------------------------------------------------------
--Create Sequence Cpy_Task_Attache_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE TABLE Copy_Task_Attache
--( Id          Number(9) NOT NULL,                          -- PK
--  Task_Id     Number(9) NOT NULL,                          -- Project Task
--  DDate       Date NOT NULL,                               -- Date
--  Name        Varchar2(100 Char),                          -- اسم المرفق
--  FileName    Varchar2(100 Char),                          -- اسم الملف المرفق
--  Rem         Varchar2(100 Char),                          -- Remarks
--  Ins_User    Number(5), Ins_Date     Date,
--  Upd_User    Number(5), Upd_Date     Date,
--  CONSTRAINT Cpy_Task_Attache_PK         PRIMARY KEY (Id),
--  CONSTRAINT Cpy_Task_Attache_Task_FK    Foreign Key (Task_Id   ) References Cpy_Task(Id),
--  CONSTRAINT Cpy_Task_Attache_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User (Id),
--  CONSTRAINT Cpy_Task_Attache_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User (Id)
--)
--/
--Create Synonym Cpy_Task_Attache For Copy_Task_Attache
--/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Task_Status_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Copy_Task_Status        		                   -- جدول تبدل حالات المهام
( Id          Number(9) NOT NULL,                          -- مفتاح رئيسي
  Task_Id     Number(9),                                   -- مفتاح الأب
  Proj_Id     Number(9),                                   -- مفتاح المشروع
  User_Id     Number(5) NOT NULL,				                   -- الموظف الذي غير الحالة
  oStatus_Id  Number(2) Default 0,                         -- الحالة القديمة
  nStatus_Id  Number(2) Default 0,                         -- الحالة الحالية
  Status_Date Date Default Sysdate,                        -- تاريخ الحالة الحالية
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Cpy_Task_Status_PK          Primary Key (Id),
  CONSTRAINT  Cpy_Task_Status_OStatus_FK  Foreign Key (oStatus_Id) References Cpy_Cod_Task_Status(Id),
  CONSTRAINT  Cpy_Task_Status_NStatus_FK  Foreign Key (nStatus_Id) References Cpy_Cod_Task_Status(Id),
  CONSTRAINT  Cpy_Task_Status_User_FK     Foreign Key (User_Id   ) References Cpy_User           (Id),
  CONSTRAINT  Cpy_Task_Status_Ins_FK      Foreign Key (Ins_User  ) References Cpy_User           (Id),
  CONSTRAINT  Cpy_Task_Status_Upd_FK      Foreign Key (Upd_User  ) References Cpy_User           (Id)
)
/
Create Synonym Cpy_Task_Status For Copy_Task_Status
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Task_RateMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Copy_Task_RatingMst
( Id         Number(9) NOT NULL,                           -- PK
  Task_Id    Number(9) NOT NULL,                           -- Project
  SDate      Date NOT NULL,                                -- start Date
  EDate      Date NOT NULL,                                -- end Date
  Rem        Varchar2(100 Char),                           -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Task_RateMst_PK          PRIMARY KEY (Id),
  CONSTRAINT Cpy_Task_RateMst_Task_FK     Foreign Key (Task_Id    )References Cpy_Task       (Id),
  CONSTRAINT Cpy_Task_RateMst_Ins_FK      Foreign Key (Ins_User   )References Cpy_User       (Id),
  CONSTRAINT Cpy_Task_RateMst_Upd_FK      Foreign Key (Upd_User   )References Cpy_User       (Id)
)
/
Create Synonym Cpy_Task_RateMst For Copy_Task_RatingMst
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Task_RateTrn_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Copy_Task_RatingTrn
( Id         Number(9) NOT NULL,                          -- PK
  Mst_Id     Number(9) NOT NULL,                          -- Mst Id
  Rate_Id    Number(1) DEFAULT 0 NOT NULL,                -- Rate  
  User_Id    Number(9) NOT NULL,                          -- user
  Rem        Varchar2(100 Char),                          -- Remarks
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Task_RateTrn_PK          PRIMARY KEY (Id),
  CONSTRAINT Cpy_Task_RateTrn_Mst_FK      Foreign Key (Mst_Id     )References Cpy_Task_RateMst (Id),
  CONSTRAINT Cpy_Task_RateTrn_Rate_FK     Foreign Key (Rate_Id    )References Cpy_Cod_Rate     (Id),
  CONSTRAINT Cpy_Task_RateTrn_Ins_FK      Foreign Key (Ins_User   )References Cpy_User         (Id),
  CONSTRAINT Cpy_Task_RateTrn_Upd_FK      Foreign Key (Upd_User   )References Cpy_User         (Id)
)
/
Create Synonym Cpy_Task_RateTrn For Copy_Task_RatingTrn
/
----------------------------------------------------------------------------------------------------
--Create Sequence Cpy_Task_Follow_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE TABLE Copy_Task_Followup
--( Id         Number(9) NOT NULL,                           -- PK
--  Task_Id    Number(9) NOT NULL,                           -- Task
--  Team_Id    Number(9) NOT NULL,                           -- Team Member
--  Status_Id  Number(1) DEFAULT 1 NOT NULL,                 -- Status
--  Progress   Number(3) DEFAULT 0 NOT NULL,                 -- Progress Percent
--  Descr      Varchar2(4000 Char) NOT NULL,                 -- Description
--  DDate      Date DEFAULT Sysdate NOT NULL,                -- Datetime
--  Ins_User   Number(5), Ins_Date     Date,
--  Upd_User   Number(5), Upd_Date     Date,
--  CONSTRAINT Cpy_Task_Follow_PK        PRIMARY KEY (Id),
--  CONSTRAINT Cpy_Task_Follow_Task_FK   Foreign Key (Task_Id  ) References Cpy_Task       (Id),
--  CONSTRAINT Cpy_Task_Follow_Team_FK   Foreign Key (Team_Id  ) References Proj_Team      (Id),
--  CONSTRAINT Cpy_Task_Follow_Status_FK Foreign Key (Status_Id) References Proj_Cod_Status(Id),
--  CONSTRAINT Cpy_Task_Follow_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
--  CONSTRAINT Cpy_Task_Follow_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
--)
--/
--Create Synonym Cpy_Task_Follow For Copy_Task_Followup
--/
----------------------------------------------------------------------------------------------------
--Create Sequence Cpy_Folow_Attache_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
--CREATE TABLE Copy_Follow_Attache
--( Id            Number(9) NOT NULL,                        -- PK
--  Follow_Id     Number(9) NOT NULL,                        -- Project Expense
--  DDate         Date NOT NULL,                             -- Date
--  Name          Varchar2(100 Char),                        -- اسم المرفق
--  FileName      Varchar2(100 Char),                        -- اسم الملف المرفق
--  Rem           Varchar2(100 Char),                        -- Remarks
--  Ins_User      Number(5), Ins_Date     Date,
--  Upd_User      Number(5), Upd_Date     Date,
--  CONSTRAINT Cpy_Folow_Attache_PK           PRIMARY KEY (Id),
--  CONSTRAINT Cpy_Folow_Attache_Follow_FK    Foreign Key (Follow_Id )   References Cpy_Task_Follow(Id),
--  CONSTRAINT Cpy_Folow_Attache_Ins_FK       Foreign Key (Ins_User  )   References Cpy_User (Id),
--  CONSTRAINT Cpy_Folow_Attache_Upd_FK       Foreign Key (Upd_User  )   References Cpy_User (Id)
--)
--/
--Create Synonym Cpy_Folow_Attache For Copy_Follow_Attache
--/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Task_User_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Copy_Task_Users         		                   -- مستخدمي مهمة
( Id          Number(5) NOT NULL,                          -- مفتاح رئيسي
  Task_Id     Number(9) Default 0 NOT NULL,                -- مفتاح الأب
  Status_Id   Number(1) Default 1,			                   -- الحالة
  User_Id     Number(5),				                           -- الموظف
  Rem         Varchar2(250 Char),			                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Cpy_Task_User_PK          Primary Key (Id  ),
  CONSTRAINT  Cpy_Task_User_UK          UNIQUE      (Task_Id, User_Id),
  CONSTRAINT  Cpy_Task_User_Status_FK   Foreign Key (Status_Id  ) References Phs_Cod_Status(Id),
  CONSTRAINT  Cpy_Task_User_Task_FK     Foreign Key (Task_Id    ) References Cpy_Task      (Id),
  CONSTRAINT  Cpy_Task_User_User_FK     Foreign Key (User_Id    ) References Cpy_User      (Id),
  CONSTRAINT  Cpy_Task_User_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User      (Id),
  CONSTRAINT  Cpy_Task_User_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Task_User For Copy_Task_Users
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Task_Action_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Copy_Task_Actions      		                   -- إجراءات مهمة
( Id          Number(5) NOT NULL,                          -- مفتاح رئيسي
  Task_Id     Number(9) Default 0 NOT NULL,                -- مفتاح الأب
  Action_Id   Number(5) Default 1,			                   -- نوع الإجراء
  User_Id     Number(5),				                           -- الموظف
  Status_Id  Number(1) DEFAULT 1 NOT NULL,                 -- Status
  Progress   Number(3) DEFAULT 0 NOT NULL,                 -- Progress Percent
  Describtion Varchar2(4000 Char),			                   -- البيان
  Rem         Varchar2(250 Char),			                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Cpy_Task_Action_PK        Primary Key (Id),
  CONSTRAINT  Cpy_Task_Action_Task_FK   Foreign Key (Task_Id  ) References Cpy_Task           (Id),
  CONSTRAINT  Cpy_Task_Action_Action_FK Foreign Key (Action_Id) References Cpy_Cod_Task_Action(Id),
  CONSTRAINT  Cpy_Task_Action_Status_FK Foreign Key (Status_Id) References Cpy_Cod_Task_Status(Id),
  CONSTRAINT  Cpy_Task_Action_User_FK   Foreign Key (User_Id  ) References Cpy_User           (Id),
  CONSTRAINT  Cpy_Task_Action_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT  Cpy_Task_Action_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Cpy_Task_Action For Copy_Task_Actions
/
----------------------------------------------------------------------------------------------------
Create Table Copy_Code_Notification_Type                     -- جدول ترميز أنواع التنبيهات
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Cod_NotifType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_NotifType_UK     UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_NotifType_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Cod_NotifType_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Cod_NotifType_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Cod_NotifType For Copy_Code_Notification_Type
/
Insert into Cpy_Cod_NotifType (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Table Copy_Code_Notification_Status                   -- جدول ترميز حالات التنبيهات
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Cod_NotifStatus_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_NotifStatus_UK     UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_NotifStatus_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Cod_NotifStatus_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Cod_NotifStatus_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Cod_NotifStatus For Copy_Code_Notification_Status
/
Insert into Cpy_Cod_NotifStatus (Id,Name) values (0,'جديد');
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Notification_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Copy_Notification         		                 -- التنبيهات
( Id          Number(20) NOT NULL,                         -- مفتاح رئيسي
  User_Id     Number(5),				                           -- الموظف
  Type_Id     Number(1) Default 0 NOT NULL,                -- النوع
  Status_Id   Number(2) Default 0,			                   -- الحالة
  vTitle      varchar2(100) NOT NULL,                      -- عنوان التنبيه
  vIcon       Number(1) DEFAULT 0 NOT NULL,                -- الصورة المصغرة
  vBody       varchar2(512) NOT NULL,                      -- التنبيه
  Rem         Varchar2(250 Char),			                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Cpy_Notification_PK        Primary Key (Id),
  CONSTRAINT  Cpy_Notification_User_FK   Foreign Key (User_Id  ) References Cpy_User           (Id),
  CONSTRAINT  Cpy_Notification_Type_FK   Foreign Key (Type_Id  ) References Cpy_Cod_NotifType  (Id),
  CONSTRAINT  Cpy_Notification_Status_FK Foreign Key (Status_Id) References Cpy_Cod_NotifStatus(Id),
  CONSTRAINT  Cpy_Notification_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT  Cpy_Notification_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Cpy_Notification For Copy_Notification
/
----------------------------------------------------------------------------------------------------
--Drop Sequence Cpy_Alert_Seq;
--Drop Table Copy_Alerts;
--Drop Synonym Cpy_Alert;
Create Sequence Cpy_Alert_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Copy_Alerts                                   -- جدول ترميز جداول الإشعارات
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  User_Id    Number(5),				                             -- الموظف
  vColor     Varchar2(25) Default 'success',               -- اللون
  vIcon      Varchar2(25) Default 'bi bi-info-circle',     -- الصورة المصغرة
  vTitle     Varchar2(100) NOT NULL,                       -- العنوان
  vBody      Varchar2(512) NOT NULL,                       -- النص
  vFooter    Varchar2(100),                                -- التذييل
  Rem        Varchar2(250 Char),			                     -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Alert_PK      PRIMARY KEY (Id),
  CONSTRAINT Cpy_Alert_User_FK Foreign Key (User_Id ) References Cpy_User(Id),
  CONSTRAINT Cpy_Alert_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Cpy_Alert_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Cpy_Alert For Copy_Alerts
/
Insert Into  Cpy_Alert 
      ( Id     ,  vTitle ,  vBody  ,  vFooter ) VALUES (
        Cpy_Alert_Seq.nextval,
        'تنويه للتعديلات',
        'نعتذر إن حصل تقطع في الخدمة هذين اليومين لأننا نقوم بتطوير المخدمات',
        'Version 3.5.508'
);
