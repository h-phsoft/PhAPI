----------------------------------------------------------------------------------------------------
Create Sequence Fre_Driv_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Drivers                                   -- Drivers
( Id         Number(5) NOT NULL,                           -- PK
  NatId      Varchar2(30 Char) NOT NULL,                   -- National Number
  FName      Varchar2(200 Char) NOT NULL,                  -- First Name
  LName      Varchar2(200 Char) NOT NULL,                  -- Last Name
  Father     Varchar2(200 Char),                           -- Father Name
  Mother     Varchar2(200 Char),                           -- Mother Name
  Phone      Varchar2(30 Char),                            -- Phone
  Mobile     Varchar2(30 Char),                            -- Mobile
  Kind_Id    Number(1) Default 1,                          -- Type 1 Driver / 2 Assistant
  List_Id    Number(1) Default 0,                          -- List 0 Normal / 1 Wiht List / 2 Black List
  Rem        Varchar2(250 Char),                           -- Remarks
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_Driv_PK      PRIMARY KEY (Id   ),
  CONSTRAINT Fre_Driv_UK      UNIQUE      (NatId),
  CONSTRAINT Fre_Driv_Kind_FK Foreign Key (Kind_Id ) References Fre_Cod_Kind (Id),
  CONSTRAINT Fre_Driv_List_FK Foreign Key (List_Id ) References Fre_Cod_List (Id),
  CONSTRAINT Fre_Driv_Ins_FK  Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fre_Driv_Upd_FK  Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fre_Driv For Fre_Drivers
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Truk_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Trucks                                    -- Trucks
( Id         Number(5) NOT NULL,                           -- PK
  Num        Varchar2(200 Char) NOT NULL,                  -- Plate No
  City       Varchar2(200 Char),                           -- City
  Color      Varchar2(200 Char),                           -- Color
  Brand      Varchar2(200 Char),                           -- Brand
  Year       Number(4),                                    -- Product Year
  List_Id    Number(1) Default 0,                          -- Status 0 Normal / 1 Wiht List / 2 Black List
  Rem        Varchar2(250 Char),                           -- Remarks
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_Truk_PK      PRIMARY KEY (Id ),
  CONSTRAINT Fre_Truk_UK      UNIQUE      (Num),
  CONSTRAINT Fre_Truk_List_FK Foreign Key (List_Id ) References Fre_Cod_List (Id),
  CONSTRAINT Fre_Truk_Ins_FK  Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fre_Truk_Upd_FK  Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fre_Truk For Fre_Trucks
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cont_Comod_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Contact_Comodity                          -- دليل بضائع المتعاملين
( Id         Number(9),                                    -- PK
  Cont_Id    Number(9),                                    -- المتعامل
  Comod_Id   Number(5),                                    -- نوع البضاعة
  Descr      Varchar2(250 Char),                           -- البيان
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cont_Comod_PK       PRIMARY KEY (Id),
  CONSTRAINT Fre_Cont_Comod_UK       Unique      (Cont_Id, Comod_Id),
  CONSTRAINT Fre_Cont_Comod_Cont_FK  Foreign Key (Cont_Id ) References Mng_Cont     (Id),
  CONSTRAINT Fre_Cont_Comod_Comod_FK Foreign Key (Comod_Id) References Fre_Cod_Comod(Id),
  CONSTRAINT Fre_Cont_Comod_Ins_FK   Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fre_Cont_Comod_Upd_FK   Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fre_Cont_Comod For Fre_Contact_Comodity
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_DUServ_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Department_Unit_Services                  -- خدمات الأقسام ضمن النشاطات
( Id         Number(9),                                    -- مفتاح رئيسي
  Unit_Id    Number(5) Default 0,                          -- القسم ضمن النشاط
  Loc_Id     Number(1) Default 1,                          -- المكان Location / 1 Origin / 2 Shipping / 3 Destination
  Serv_Id    Number(5) Default 0,                          -- رقم
  Status_Id  Number(1) Default 1,                          -- الحالة
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_DUServ_PK        Primary Key (Id),
  CONSTRAINT Fre_DUServ_UK        Unique      (Unit_Id, Loc_Id, Serv_Id),
  CONSTRAINT Fre_DUServ_Unit_FK   Foreign Key (Unit_Id  ) References Cpy_Unit       (Id),
  CONSTRAINT Fre_DUServ_Loc_FK    Foreign Key (Loc_Id   ) References Fre_Cod_Loc    (Id),
  CONSTRAINT Fre_DUServ_Serv_FK   Foreign Key (Serv_Id  ) References Mng_Serv       (Id),
  CONSTRAINT Fre_DUServ_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_DUServ_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_DUServ_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_DUServ For Fre_Department_Unit_Services
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_DeptMBud_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Department_Mst_Budgets                    -- موازنات الأقسام
( Id         Number(5),                                    -- مفتاح رئيسي
  Num        Number(5),                                    -- الرقم
  dDate      Date,                                         -- التاريخ
  Name       Varchar2(100 Char),                           -- الاسم
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_DeptMBud_PK      Primary Key (Id  ),
  CONSTRAINT Fre_DeptMBud_NUM_UK  Unique      (Num ),
  CONSTRAINT Fre_DeptMBud_Nam_UK  Unique      (Name),
  CONSTRAINT Fre_DeptMBud_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Fre_DeptMBud_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Fre_DeptMBud For Fre_Department_Mst_Budgets
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_DeptTBud_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Department_Trn_Budgets                    -- بنود موازنات الأقسام
( Id         Number(9),                                    -- مفتاح رئيسي
  Bud_Id     Number(5),                                    -- مفتاح الأب
  Dept_Id    Number(5) Default 0,                          -- النشاط
  nJF        Number(5) Default 0,                          -- عدد ملفات العمل Job Files
  nCust      Number(5) Default 0,                          -- عدد الزبائن Customers
  nTEUs      Number(5) Default 0,                          -- عدد وحدات الشحن TEU's
  nWeight    Number(25,3) Default 0,                       -- الوزن المحاسب عليه Chargeable weight
  nGP        Number(25,3) Default 0,                       -- الربح الإجمالي GrossProfit
  nRevenue   Number(25,3) Default 0,                       -- إجمالي قيمة العمل
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_DeptTBud_PK      Primary Key (Id),
  CONSTRAINT Fre_DeptTBud_UK      Unique      (Bud_Id, Dept_Id),
  CONSTRAINT Fre_DeptTBud_FK      Foreign Key (Bud_Id  ) References Fre_DeptMBud(Id),
  CONSTRAINT Fre_DeptTBud_Dept_FK Foreign Key (Dept_Id ) References Cpy_Dept    (Id),
  CONSTRAINT Fre_DeptTBud_Ins_FK  Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Fre_DeptTBud_Upd_FK  Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Fre_DeptTBud For Fre_Department_Trn_Budgets
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_MCntrct_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Contract_Mst                              -- العقود
( Id                Number(5),                             -- مفتاح رئيسي
  Dept_Id           Number(5) Default 0,                   -- النشاط
  Unit_Id           Number(5) Default 0,                   -- القسم
  Oper_Id           Number(5) Default 0,                   -- العملية
  Cont_Id           Number(9) Default 0,                   -- المتعامل\الزبون
  Type_Id           Number(1) Default 1,                   -- نوع العقد مبيع أو شراء
  Num               Number(10) Default 0,                  -- رقم
  dDate             Date Default Sysdate,                  -- تاريخ
  Status_Id         Number(1) Default 0,                   -- الحالة
  SDate             Date,                                  -- تاريخ البداية
  EDate             Date,                                  -- تاريخ النهاية
  Dmrge_Serv_Id     Number(9) NOT NULL,                    -- Demurrage
  Dmrge_Curn_Id     Number(3) Default 1,                   -- العملة
  Dmrge_Unit_Id     Number(3) Default 0,                   -- الوحدة
  Load_Serv_Id      Number(9) NOT NULL,                    -- load Quantity
  Load_Curn_Id      Number(3) Default 1,                   -- العملة
  Load_Unit_Id      Number(3) Default 0,                   -- الوحدة
  Offload_Serv_Id   Number(9) NOT NULL,                    -- Offload Quantity
  Offload_Curn_Id   Number(3) Default 1,                   -- العملة
  Offload_Unit_Id   Number(3) Default 0,                   -- الوحدة
  Overload_Serv_Id  Number(9) NOT NULL,                    -- Overload Quantity
  Overload_Curn_Id  Number(3) Default 1,                   -- العملة
  Overload_Unit_Id  Number(3) Default 0,                   -- الوحدة
  Cooling_Serv_Id   Number(9) NOT NULL,                    -- Cooling Status
  Cooling_Curn_Id   Number(3) Default 1,                   -- العملة
  Cooling_Unit_Id   Number(3) Default 0,                   -- الوحدة
  Cancel_Serv_Id    Number(9) NOT NULL,                    -- Cancel Status
  Cancel_Curn_Id    Number(3) Default 1,                   -- العملة
  Cancel_Unit_Id    Number(3) Default 0,                   -- الوحدة
  OverDist_Serv_Id  Number(9) NOT NULL,                    -- Additional Distance
  OverDist_Curn_Id  Number(3) Default 1,                   -- العملة
  OverDist_Unit_Id  Number(3) Default 0,                   -- الوحدة
  TransMT_Serv_Id   Number(9) NOT NULL,                    -- Transport
  TransMT_Curn_Id   Number(3) Default 1,                   -- العملة
  TransMT_Unit_Id   Number(3) Default 0,                   -- الوحدة
  Descr             Varchar2(100 Char),                    -- اسم ملف العمل أو وصفه
  Rem               Varchar2(250 Char),                    -- Remarks
  Ins_User          Number(5), Ins_Date Date,
  Upd_User          Number(5), Upd_Date Date,
  CONSTRAINT        Fre_MCntrct_PK              Primary Key (Id ),
  CONSTRAINT        Fre_MCntrct_UK              Unique      (Num),
  CONSTRAINT        Fre_MCntrct_Dept_FK         Foreign Key (Dept_Id         ) References Cpy_Dept      (Id),
  CONSTRAINT        Fre_MCntrct_Unit_FK         Foreign Key (Unit_Id         ) References Cpy_Unit      (Id),
  CONSTRAINT        Fre_MCntrct_Oper_FK         Foreign Key (Oper_Id         ) References Cpy_Oper      (Id),
  CONSTRAINT        Fre_MCntrct_Cont_FK         Foreign Key (Cont_Id         ) References Mng_Cont      (Id),
  CONSTRAINT        Fre_MCntrct_Status_FK       Foreign Key (Status_Id       ) References Phs_Cod_Status(Id),
  CONSTRAINT        Fre_MCntrct_CurnDmrge_FK    Foreign Key (Dmrge_Curn_ID   ) References Mng_Curn      (Id),
  CONSTRAINT        Fre_MCntrct_Curnload_FK     Foreign Key (load_Curn_Id    ) References Mng_Curn      (Id),
  CONSTRAINT        Fre_MCntrct_Curnoffload_FK  Foreign Key (offload_Curn_Id ) References Mng_Curn      (Id),
  CONSTRAINT        Fre_MCntrct_CurnOverload_FK Foreign Key (Overload_Curn_Id) References Mng_Curn      (Id),
  CONSTRAINT        Fre_MCntrct_CurnCooling_FK  Foreign Key (Cooling_Curn_Id ) References Mng_Curn      (Id),
  CONSTRAINT        Fre_MCntrct_CurnCancel_FK   Foreign Key (Cancel_Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT        Fre_MCntrct_CurnOverDist_FK Foreign Key (OverDist_Curn_Id) References Mng_Curn      (Id),
  CONSTRAINT        Fre_MCntrct_CurnTransMT_FK  Foreign Key (TransMT_Curn_Id ) References Mng_Curn      (Id),
  CONSTRAINT        Fre_MCntrct_UnitDmrge_FK    Foreign Key (Dmrge_Unit_Id   ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT        Fre_MCntrct_Unitload_FK     Foreign Key (load_Unit_Id    ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT        Fre_MCntrct_Unitoffload_FK  Foreign Key (offload_Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT        Fre_MCntrct_UnitOverload_FK Foreign Key (Overload_Unit_Id) References Cpy_Cod_Unit  (Id),
  CONSTRAINT        Fre_MCntrct_UnitCooling_FK  Foreign Key (Cooling_Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT        Fre_MCntrct_UnitCancel_FK   Foreign Key (Cancel_Unit_Id  ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT        Fre_MCntrct_UnitOverDist_FK Foreign Key (OverDist_Unit_Id) References Cpy_Cod_Unit  (Id),
  CONSTRAINT        Fre_MCntrct_UnitTransMT_FK  Foreign Key (TransMT_Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT        Fre_MCntrct_Dmrge_FK        Foreign Key (Dmrge_Serv_Id   ) References Mng_Serv      (Id),
  CONSTRAINT        Fre_MCntrct_load_FK         Foreign Key (load_Serv_Id    ) References Mng_Serv      (Id),
  CONSTRAINT        Fre_MCntrct_offload_FK      Foreign Key (offload_Serv_Id ) References Mng_Serv      (Id),
  CONSTRAINT        Fre_MCntrct_Overload_FK     Foreign Key (Overload_Serv_Id) References Mng_Serv      (Id),
  CONSTRAINT        Fre_MCntrct_Cooling_FK      Foreign Key (Cooling_Serv_Id ) References Mng_Serv      (Id),
  CONSTRAINT        Fre_MCntrct_Cancel_FK       Foreign Key (Cancel_Serv_Id  ) References Mng_Serv      (Id),
  CONSTRAINT        Fre_MCntrct_OverDist_FK     Foreign Key (OverDist_Serv_Id) References Mng_Serv      (Id),
  CONSTRAINT        Fre_MCntrct_TransMT_FK      Foreign Key (TransMT_Serv_Id ) References Mng_Serv      (Id),
  CONSTRAINT        Fre_MCntrct_Ins_FK          Foreign Key (Ins_User        ) References Cpy_User      (Id),
  CONSTRAINT        Fre_MCntrct_Upd_FK          Foreign Key (Upd_User        ) References Cpy_User      (Id)
)
/
Create Synonym Fre_MCntrct For Fre_Contract_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_TCntrct_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Contract_Trn                              -- بنود العقود
( Id         Number(9),                                    -- مفتاح رئيسي
  Contr_Id   Number(5),                                    -- مفتاح رئيسي
  Kind_id    Number(2) Default 1,                          -- Kind 1 Shipping, 2 Demurrage, 3 Cancelation
  Curn_Id    Number(3) Default 1,                          -- العملة
  OCntry_Id  Number(5) Default 0,                          -- المصدر Country
  OCity_Id   Number(5) Default 0,                          -- Origin City
  DCntry_Id  Number(5) Default 0,                          -- المقصد Country
  DCity_Id   Number(5) Default 0,                          -- Destination City
  nDmrge     Number(25,3) Default 0,                       -- Demurrage
  nLoad      Number(25,3) Default 0,                       -- Load
  nOffload   Number(25,3) Default 0,                       -- Offload
  nOverload  Number(25,3) Default 0,                       -- Overload Quantity
  nCooling   Number(25,3) Default 0,                       -- Cooling
  nCancel    Number(25,3) Default 0,                       -- Cancel
  nOverDist  Number(25,3) Default 0,                       -- Additional Distance
  MT5        Number(25,3) Default 0,                       -- Transport 5
  MT10       Number(25,3) Default 0,                       -- Transport 10
  MT15       Number(25,3) Default 0,                       -- Transport 15
  MT20       Number(25,3) Default 0,                       -- Transport 20
  MT25       Number(25,3) Default 0,                       -- Transport 25
  MT30       Number(25,3) Default 0,                       -- Transport 30
  MT35       Number(25,3) Default 0,                       -- Transport 35
  MT40       Number(25,3) Default 0,                       -- Transport 40
  MT45       Number(25,3) Default 0,                       -- Transport 45
  MT50       Number(25,3) Default 0,                       -- Transport 50
  OAddress   Varchar2(250 Char),                           -- Origin Address
  DAddress   Varchar2(250 Char),                           -- Destination Address
  Rem        Varchar2(250 Char),                           -- Remarks
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_TCntrct_PK       Primary Key (Id),
  CONSTRAINT Fre_TCntrct_UK       Unique      (Contr_Id, Kind_Id, OCity_Id, DCity_Id, OAddress, DAddress),
  CONSTRAINT Fre_TCntrct_Contr_FK Foreign Key (Contr_Id ) References Fre_MCntrct       (Id),
  CONSTRAINT Fre_TCntrct_Kind_FK  Foreign Key (Kind_Id  ) References Fre_Cod_Contr_Kind(Id),
  CONSTRAINT Fre_TCntrct_Curn_FK  Foreign Key (Curn_Id  ) References Mng_Curn          (Id),
  CONSTRAINT Fre_TCntrct_Orig_FK  Foreign Key (OCntry_Id) References Fre_Cod_Cntry     (Id),
  CONSTRAINT Fre_TCntrct_Dest_FK  Foreign Key (DCntry_Id) References Fre_Cod_Cntry     (Id),
  CONSTRAINT Fre_TCntrct_OCity_FK Foreign Key (OCity_Id ) References Fre_Cod_City      (Id),
  CONSTRAINT Fre_TCntrct_DCity_FK Foreign Key (DCity_Id ) References Fre_Cod_City      (Id),
  CONSTRAINT Fre_TCntrct_Ins_FK   Foreign Key (Ins_User ) References Cpy_User          (Id),
  CONSTRAINT Fre_TCntrct_Upd_FK   Foreign Key (Upd_User ) References Cpy_User          (Id)
)
/
Create Synonym Fre_TCntrct For Fre_Contract_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_DCntrct_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Contract_Distance                         -- بنود العقود
( Id         Number(9),                                    -- مفتاح رئيسي
  Contr_Id   Number(9),                                    -- مفتاح رئيسي
  nFrom      Number(5) Default 0,                          -- بداية من كم
  nTo        Number(5) Default 0,                          -- لغاية كم
  Overload   Number(25,3) Default 0,                       -- Overload Quantity
  Cooling    Number(25,3) Default 0,                       -- Cooling
  MT5        Number(25,3) Default 0,                       -- Transport 5
  MT10       Number(25,3) Default 0,                       -- Transport 10
  MT15       Number(25,3) Default 0,                       -- Transport 15
  MT20       Number(25,3) Default 0,                       -- Transport 20
  MT25       Number(25,3) Default 0,                       -- Transport 25
  MT30       Number(25,3) Default 0,                       -- Transport 30
  MT35       Number(25,3) Default 0,                       -- Transport 35
  MT40       Number(25,3) Default 0,                       -- Transport 40
  MT45       Number(25,3) Default 0,                       -- Transport 45
  MT50       Number(25,3) Default 0,                       -- Transport 50
  Rem        Varchar2(250 Char),                           -- Remarks
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_DCntrct_PK       Primary Key (Id),
  CONSTRAINT Fre_DCntrct_UK       Unique      (Contr_Id, nFrom, nTo),
  CONSTRAINT Fre_DCntrct_Contr_FK Foreign Key (Contr_Id ) References Fre_MCntrct(Id),
  CONSTRAINT Fre_DCntrct_Ins_FK   Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT Fre_DCntrct_Upd_FK   Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Fre_DCntrct For Fre_Contract_Distance
/
----------------------------------------------------------------------------------------------------
