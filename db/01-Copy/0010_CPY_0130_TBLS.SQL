Create Sequence Cpy_Cod_Status_Seq MinValue 100 Start With 100 MaxValue 999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Code_Status                              -- جدول ترميز الحالات
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cpy_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Cpy_Cod_Status_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Cod_Status_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Cod_Status_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Cod_Status For Copy_Code_Status
/
Insert into Cpy_Cod_Status (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Dept_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Departments				                       -- جدول النشاطات\الأقسام
( Id          Number(5) NOT NULL,			                     -- مفتاح رئيسي
  Status_Id   Number(1) Default 1,			                   -- الحالة
  User_Id     Number(5) Default 0,			                   -- المدير
  Name        Varchar2(100 Char),			                     -- الاسم
  Rem         Varchar2(250 Char),			                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT Cpy_Dept_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Cpy_Dept_Nam_UK    UNIQUE      (Name),
  CONSTRAINT Cpy_Dept_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Dept_User_FK   Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Dept_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Dept_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Dept For Copy_Departments
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Unit_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Department_Unit			                     -- جدول وحدات دائرة
( Id          Number(5) NOT NULL,			                     -- مفتاح رئيسي
  Dept_Id     Number(5) NOT NULL,			                     -- مفتاح رئيسي
  Status_Id   Number(1) Default 1,			                   -- الحالة
  User_Id     Number(5) Default 0,			                   -- المدير
  Name        Varchar2(100 Char),			                     -- الاسم
  Rem         Varchar2(250 Char),				                   -- ملاحظات
  Cost_Id     Number(9),				                           -- مركز الكلفة
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT Cpy_Unit_PK        PRIMARY KEY (Id),
  CONSTRAINT Cpy_Unit_Nam_UK    UNIQUE      (Dept_Id,Name),
  CONSTRAINT Cpy_Unit_Dept_FK   Foreign Key (Dept_Id  ) References Cpy_Dept      (Id),
  CONSTRAINT Cpy_Unit_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_Unit_User_FK   Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Unit_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_Unit_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Unit For Copy_Department_Unit
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Oper_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Unit_Operations			                     -- جدول أنواع حركات وحدات الإدارات
( Id         Number(5) NOT NULL,			                     -- مفتاح رئيسي
  Unit_Id    Number(5) NOT NULL,			                     -- مفتاح الأب
  Status_Id  Number(1) Default 1,			                     -- الحالة
  Name       Varchar2(100 Char),			                     -- الاسم
  Rem        Varchar2(250 Char),			                     -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Cpy_UnitOper_PK        PRIMARY KEY (Id),
  CONSTRAINT Cpy_UnitOper_Nam_UK    UNIQUE      (Unit_Id,Name),
  CONSTRAINT Cpy_UnitOper_Unit_FK   Foreign Key (Unit_Id  ) References Cpy_Unit      (Id),
  CONSTRAINT Cpy_UnitOper_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cpy_UnitOper_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cpy_UnitOper_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Oper For Copy_Unit_Operations
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Unit_Rec_Status_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Unit_Receive_Status                      -- جدول ترميز الحالات التي يمكن للوحدة استلامها
( Id            Number(5) NOT NULL,				                 -- مفتاح رئيسي
  Status_Id     Number(1) Default 1,				               -- حالة الترميز
  Unit_Id       Number(5) Default 1,				               -- الوحدة
  RStatus_Id    Number(5) Default 0,				               -- الحالة المستلمة
  Head_Id       Number(1) Default 1,				               -- هل الحالة رئيسية أم لا
  ForceClose_Id Number(1) Default 1,				               -- للحالة الرئيسية هل يمكنها إغلاق الحالات الفرعية
  Days          Number(3) Default 1,				               -- الأيام التي يجب أن تنتهي بها هذه الحالة
  Rem           Varchar2(100 Char),          				       -- ملاحظات
  Ins_User      Number(5), Ins_Date     Date,
  Upd_User      Number(5), Upd_Date     Date,
  CONSTRAINT    Cpy_URStatus_PK            PRIMARY KEY (Id),
  CONSTRAINT    Cpy_URStatus_UK            UNIQUE      (Unit_Id, RStatus_Id),
  Constraint    Cpy_URStatus_Status_Fk     Foreign Key (Status_Id    ) References Phs_Cod_Status(Id),
  Constraint    Cpy_URStatus_Head_Fk       Foreign Key (Head_Id      ) References Phs_Cod_YesNo (Id),
  Constraint    Cpy_URStatus_ForceClose_Fk Foreign Key (ForceClose_Id) References Phs_Cod_YesNo (Id),
  CONSTRAINT    Cpy_URStatus_Unit_FK       Foreign Key (Unit_Id      ) References Cpy_Unit      (Id),
  CONSTRAINT    Cpy_URStatus_ReqStatus_FK  Foreign Key (RStatus_Id   ) References Cpy_Cod_Status(Id),
  CONSTRAINT    Cpy_URStatus_Ins_FK        Foreign Key (Ins_User     ) References Cpy_User      (Id),
  CONSTRAINT    Cpy_URStatus_Upd_FK        Foreign Key (Upd_User     ) References Cpy_User      (Id)
)
/
Create Synonym Cpy_Unit_Rec_Status For Copy_Unit_Receive_Status
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Unit_Frwrd_Status_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Unit_Forward_Status                      -- جدول ترميز الحالات التي والوحدات التي يمكن التوجيه لها
( Id           Number(5) NOT NULL,				                 -- مفتاح رئيسي
  Status_Id    Number(1) Default 1,				                 -- حالة الترميز
  URStatusR_Id Number(5) Default 1,				                 -- الحالة المستلمة
  URStatusF_Id Number(5) Default 1,				                 -- الحالة الممررة
  Rem          Varchar2(100 Char),          				       -- ملاحظات
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT   Cpy_UFStatus_PK           PRIMARY KEY (Id),
  CONSTRAINT   Cpy_UFStatus_UK           UNIQUE      (URStatusR_Id, URStatusF_Id),
  Constraint   Cpy_UFStatus_Status_Fk    Foreign Key (Status_Id   ) References Phs_Cod_Status     (Id),
  CONSTRAINT   Cpy_UFStatus_URStatusR_FK Foreign Key (URStatusR_Id) References Cpy_Unit_Rec_Status(Id),
  CONSTRAINT   Cpy_UFStatus_URStatusF_FK Foreign Key (URStatusF_Id) References Cpy_Unit_Rec_Status(Id),
  CONSTRAINT   Cpy_UFStatus_Ins_FK       Foreign Key (Ins_User    ) References Cpy_User           (Id),
  CONSTRAINT   Cpy_UFStatus_Upd_FK       Foreign Key (Upd_User    ) References Cpy_User           (Id)
)
/
Create Synonym Cpy_Unit_Frwrd_Status For Copy_Unit_Forward_Status
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_Status_Grp_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Status_Group_Mst                         -- جدول مجموعات الحالات
( Id            Number(5) NOT NULL,				                 -- مفتاح رئيسي
  Name          Varchar2(100 Char),          				       -- الاسم البرمجي
  Describ       Varchar2(256 Char),          				       -- البيان
  Rem           Varchar2(100 Char),          				       -- ملاحظات
  Ins_User      Number(5), Ins_Date     Date,
  Upd_User      Number(5), Upd_Date     Date,
  CONSTRAINT    Cpy_MStatus_Grp_PK     PRIMARY KEY (Id),
  CONSTRAINT    Cpy_MStatus_Grp_UK     UNIQUE      (Name),
  CONSTRAINT    Cpy_MStatus_Grp_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT    Cpy_MStatus_Grp_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Cpy_MStatus_Grp For Copy_Status_Group_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_TStatus_Grp_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_Status_Group_Trn                         -- جدول بنود مجموعات الحالات
( Id            Number(5) NOT NULL,				                 -- مفتاح رئيسي
  Mst_Id        Number(5) Default 1,				               -- المجموعة
  Status_Id     Number(5) Default 0,				               -- الحالة
  Rem           Varchar2(100 Char),          				       -- ملاحظات
  Ins_User      Number(5), Ins_Date     Date,
  Upd_User      Number(5), Upd_Date     Date,
  CONSTRAINT    Cpy_TStatus_Grp_PK        PRIMARY KEY (Id),
  CONSTRAINT    Cpy_TStatus_Grp_UK        UNIQUE      (Mst_Id, Status_Id),
  CONSTRAINT    Cpy_TStatus_Grp_Mst_Fk    Foreign Key (Mst_Id   ) References Cpy_MStatus_Grp    (Id),
  CONSTRAINT    Cpy_TStatus_Grp_Status_FK Foreign Key (Status_Id) References Cpy_Unit_Rec_Status(Id),
  CONSTRAINT    Cpy_TStatus_Grp_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT    Cpy_TStatus_Grp_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Cpy_TStatus_Grp For Copy_Status_Group_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Cpy_User_Unit_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Copy_User_Units	                             -- وحدات مستخدم
( Id         Number(5) NOT NULL,			                     -- مفتاح رئيسي
  User_Id    Number(5) Default 1,	                         -- المستخدم
  Dept_Id    Number(5) Default 0 NOT NULL,		             -- الدائرة
  Unit_Id    Number(5) Default 0 NOT NULL,		             -- الوحدة
  Rem        Varchar2(200 Char),		                       -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT CpyUser_Unit_PK          PRIMARY KEY (Id),
  CONSTRAINT CpyUser_Unit_UK      UNIQUE      (User_Id, Unit_Id),
  CONSTRAINT CpyUser_Dept_FK      Foreign Key (Dept_Id ) References Cpy_Dept(Id),
  CONSTRAINT CpyUser_Unit_FK      Foreign Key (Unit_Id ) References Cpy_Unit(Id),
  CONSTRAINT CpyUser_Unit_User_Fk Foreign Key (User_Id ) References Cpy_User(Id),
  CONSTRAINT CpyUser_Unit_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT CpyUser_Unit_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Cpy_User_Unit For Copy_User_Units
/
----------------------------------------------------------------------------------------------------
