-------------------------------------------------------------------------------------------------
Create Sequence Fre_CLR_Job_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_CLR_Job_Freight                 -- ملفات العمل للتخليص الجمركي
( Id           Number(10),                       -- مفتاح رئيسي
  Dept_Id      Number(5) Default 0,              -- النشاط
  Unit_Id      Number(5) Default 0,              -- القسم
  Oper_Id      Number(5) Default 0,              -- العملية
  Cont_Id      Number(9) Default 0,               -- المتعامل
  Period_Id    Number(5) Default 0,              -- السنة
  Ofer_Id      Number(5) Default 0,              -- مفتاح العرض
  Curn_Id      Number(3) Default 1,              -- العملة
  Curn_Rate    Number(25,9) Default 1,           -- سعر الصرف
  Mode_Id      Number(2) Default 2,              -- Is Consolidate mode, 0 normal, 1 consolidate تجميع
  Num          Number(10) Default 0,             -- رقم
  dDate        Date Default Sysdate,             -- تاريخ
  Descr        Varchar2(100 Char),               -- اسم ملف العمل أو وصفه
  ITerm_Id     Number(5) Default 0,              -- Inco Term
  PTerm_Id     Number(5) Default 0,              -- Payment Term
  OCntry_Id    Number(5) Default 0,              -- بلد المصر
  OCity_Id     Number(5) Default 0,              -- مدينة المصدر
  OPort_Id     Number(5) Default 0,              -- المعبر المصدر
  OSPort_Id    Number(5) Default 0,              -- الميناء المصدر
  OAPort_Id    Number(5) Default 0,              -- المطار المصدر
  OName        Varchar2(100 Char),               -- اسم المصدر في حال عدم وجوده ضمن التراميز
  OAddress     Varchar2(250 Char),               -- Orign Address
  DCntry_Id    Number(5) Default 0,              -- بلد المقصد
  DCity_Id     Number(5) Default 0,              -- مدينة المقصد
  DPort_Id     Number(5) Default 0,              -- المعبر المقصد
  DSPort_Id    Number(5) Default 0,              -- الميناء المقصد
  DAPort_Id    Number(5) Default 0,              -- المطار المقصد
  DName        Varchar2(100 Char),               -- اسم المقصد في حال عدم وجوده ضمن التراميز
  DAddress     Varchar2(250 Char),               -- Destination Address
  Comod_Id     Number(5) Default 0,              -- البضاعة
  vComd        Varchar2(250 Char),               -- البضاعة
  Ship         Varchar2(250 Char),               -- الشاحن
  Cons         Varchar2(250 Char),               -- المشحون إليه
  Qnt          Number(25,3) Default 0,           -- عدد الطرود
  Price        Number(25,3) Default 0,           -- السعر
  WNet         Number(25,3) Default 0,           -- الوزن الصافي
  WGros        Number(25,3) Default 0,           -- الوزن الوزن القائم
  WChrg        Number(25,3) Default 0,           -- الوزن المحاسب عليه
  Volume       Number(25,3) Default 0,           -- الحجم
  Amt          Number(25,3) Default 0,           -- Amount القيمة
  CAmt         Number(25,3) Default 0,           -- Amount Currency القيمة قطع
  Comm         Number(25,3) Default 0,           -- Commission العمولة
  CComm        Number(25,3) Default 0,           -- Commission Currency العمولة قطع
  ETD          Date,                             -- Estimated time of departure - ETD
  ETA          Date,                             -- Estimated time of arrival - ETA
  ATD          Date,                             -- Actual Time of Departure - ATD
  ATA          Date,                             -- Actual Time of Arrival - ATA
  Owner_Id     Number(5),                        -- منظم ملف العمل
  Status_Id    Number(2) Default 0,              -- الحالة
  SDate        Date,                             -- تاريخ الحالة
  SRem         Varchar2(250 Char),               -- ملاحظات الحالة
  DStatus_Id   Number(2) Default 2,              -- حالة التسليم
  DelDate      Date,                             -- تاريخ التسليم
  DelNum       Varchar2(10 Char),                -- رقم التسليم
  DelPerson    Varchar2(100 Char),               -- المستلم
  DCust        Varchar2(100 Char),               -- اسم الزبون الظاهر على الأوراق
  DueDate      Date,                             -- تاريخ الاستحقاق
  MNum         Varchar2(30 Char),                -- رقم الوثيقة الرئيسي
  MDate        Date,                             -- تاريخ
  HNum         Varchar2(30 Char),                -- رقم الوثيقة المحلي
  HDate        Date,                             -- تاريخ
  ENum         Varchar2(30 Char),                -- رقم الوثيقة express
  EDate        Date,                             -- تاريخ
  FNum         Varchar2(30 Char),                -- رقم رحلة الطيران
  FDate        Date,                             -- تاريخ رحلة الطيران
  AirLine_Id   Number(5) Default 0,              -- airLine
  ShipLine_Id  Number(5) Default 0,              -- Shipping Line 
  nRef         Varchar2(30 Char),                -- Reference Number
  BRef         Varchar2(30 Char),                -- Booking Reference Number
  POrder       Varchar2(30 Char),                -- Pickup Order Number
  Track_Id     Number(5) Default 0,              -- Truck Type
  LDM          Number(25,3) Default 0,           -- LDM
  CBM          Number(25,3) Default 0,           -- CBM
  CMRDate      Date,                             -- CMR Date
  Pack_Id      Number(5) Default 0,              -- نوع التغليف Packing Type
  KDocType_Id  Number(5) Default 0,              -- نوع الوثيقة المرتبطة
  KDocNum      Varchar2(30),                     -- رقم الوثيقة المرتبطة
  KDocDate     Date,                             -- تاريخ الوثيقة المرتبطة
  Waybill      Varchar2(30 Char),                -- رقم وثيقة النقل
  IDocType_Id  Number(5) Default 0,              -- نوع الوثيقة المرتبطة IN Transport Mode
  IDocNum      Varchar2(30 Char),                -- رقم البيان الجمريكي في حال الدخول IN Declaration Number
  IDocDate     Date,                             -- تاريخ ابيان الجمركي في حال الدخول IN Declaration Date
  ODocType_Id  Number(5) Default 0,              -- نوع الوثيقة المرتبطة OU Transport Mode
  ODocNum      Varchar2(30 Char),                -- رقم البيان الجمريكي في حال الخروج OU Declaration Number
  ODocDate     Date,                             -- تاريخ ابيان الجمركي في حال الخروج OU Declaration Date
  TripNo       Number(5) Default 1,              -- Trip Number
  TType_Id     Number(5) Default 0,              -- Truck Type
  Rel_Id       Number(9),                        -- مفتاح ملف العمل المرتبط
  Rem          Varchar2(250 Char),               -- ملاحظات
  PSStatus_Id  Number(10) Default 2,             -- ProfitShare Status
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT   Fre_CLR_Job_PK             Primary Key (Id),
  CONSTRAINT   Fre_CLR_Job_UK             Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT   Fre_CLR_Job_Ins_FK         Foreign Key (Ins_User   ) References Cpy_User           (Id),
  CONSTRAINT   Fre_CLR_Job_Upd_FK         Foreign Key (Upd_User   ) References Cpy_User           (Id)
)
/
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_WPer_FK        Foreign Key (Period_Id  ) References Cpy_Period         (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Dept_FK        Foreign Key (Dept_Id    ) References Cpy_Dept           (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Unit_FK        Foreign Key (Unit_Id    ) References Cpy_Unit           (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Oper_FK        Foreign Key (Oper_Id    ) References Cpy_Oper           (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Cont_FK        Foreign Key (Cont_Id    ) References Mng_Cont           (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Curn_FK        Foreign Key (Curn_Id    ) References Mng_Curn           (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Mode_FK        Foreign Key (Mode_Id    ) References Phs_Cod_YesNo      (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Owner_FK       Foreign Key (Owner_Id   ) References Cpy_User           (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Ofer_FK        Foreign Key (Ofer_Id    ) References Fre_MOffer         (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_ITerm_FK       Foreign Key (ITerm_Id   ) References Fre_Cod_Inco_Term  (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_PTerm_FK       Foreign Key (PTerm_Id   ) References Fre_Cod_Pay_Term   (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_OCntry_FK      Foreign Key (OCntry_Id  ) References Fre_Cod_Cntry      (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_OCity_FK       Foreign Key (OCity_Id   ) References Fre_Cod_City       (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_OPort_FK       Foreign Key (OPort_Id   ) References Fre_Cod_City       (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_OSPort_FK      Foreign Key (OSPort_Id  ) References Fre_Cod_SeaPort    (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_OAPort_FK      Foreign Key (OAPort_Id  ) References Fre_Cod_AirPort    (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_DCntry_FK      Foreign Key (DCntry_Id  ) References Fre_Cod_Cntry      (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_DCity_FK       Foreign Key (DCity_Id   ) References Fre_Cod_City       (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_DPort_FK       Foreign Key (DPort_Id   ) References Fre_Cod_City       (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_DSPort_FK      Foreign Key (DSPort_Id  ) References Fre_Cod_SeaPort    (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_DAPort_FK      Foreign Key (DAPort_Id  ) References Fre_Cod_AirPort    (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_nComd_FK       Foreign Key (Comod_Id   ) References Fre_Cod_Comod      (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_AirLine_FK     Foreign Key (AirLine_Id ) References Fre_Cod_Airline    (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_ShipLine_FK    Foreign Key (ShipLine_Id) References Fre_Cod_Shipline   (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Track_FK       Foreign Key (Track_Id   ) References Fre_Cod_Track      (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Pack_FK        Foreign Key (Pack_Id    ) References Fre_Cod_Pack       (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_KDocType_FK    Foreign Key (KDocType_Id) References Fre_Cod_KDocType   (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_IDocType_FK    Foreign Key (IDocType_Id) References Fre_Cod_IDocType   (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_ODocType_FK    Foreign Key (ODocType_Id) References Fre_Cod_ODocType   (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_Status_FK      Foreign Key (Status_Id)   References Fre_Cod_Job_Status (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_TType_FK       Foreign Key (TType_Id   ) References Fre_Cod_Truck_Type (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_DStatus_FK     Foreign Key (DStatus_Id)  References Phs_Cod_YesNo      (Id);
Alter Table Fre_CLR_Job_Freight Add CONSTRAINT   Fre_CLR_Job_PSStatus_FK    Foreign Key (PSStatus_Id) References Phs_Cod_YesNo      (Id);

Create Synonym Fre_CLR_Job For Fre_CLR_Job_Freight
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_CLR_DBCR_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_CLR_DBCR_Documents                  -- الوثائق المدينة
( Id          Number(20) NOT NULL,               -- مفتاح رئيسي
  Job_Id      Number(10) NOT NULL,               -- مفتاح ملف العمل
  Period_Id   Number(5) Default 0,               -- السنة
  nOrd        Number(4),                         -- مسلسل الإظهار
  Num         Number(10),                        -- الرقم
  dDate       Date,                              -- التاريخ
  Loc_Id      Number(5) Default 0,               -- المكان Location / 1 Origin / 2 Shipping / 3 Destination
  Trt_Id      Number(5) Default 1,               -- نوع البند / 1 Inv / 2 CN / 3 DN / 4 IER
  Cont_Id     Number(9) Default 0,               -- المتعامل
  Serv_Id     Number(5) Default 0,               -- الخدمة
  Item_Id     Number(9) Default 0,               -- المادة
  Unit_Id     Number(5) Default 0,               -- الوحدة
  Curn_Id     Number(5) Default 1,               -- العملة
  Curn_Rate   Number(25,9) Default 1,            -- سعر الصرف
  Qnt         Number(25,3) Default 0,            -- الكمية
  Price       Number(25,3) Default 0,            -- إفرادي
  CAmt        Number(25,3) Default 0,            -- المبلغ عملة
  Amt         Number(25,2) Default 0,            -- المبلغ محلي
  nRef        Varchar2(30 Char),                 -- الرقم المرجع
  dRef        Date,                              -- التاريخ المرجع
  Status_Id   Number(2) Default 0,               -- حالة الموافقة من مدير القسم 0 جديدة \ 1 موافق عليها
  Rem         Varchar2(250 Char),                -- البيان
  IFre_Id     Number(10),                        -- مفتاخ لبند الفاتورة في التدقيق المالي
  DFre_Id     Number(10),                        -- مفتاخ بند الوثيقة المدينة في التدقيق المالي
  CFre_Id     Number(10),                        -- مفتاخ بند الوثيقة الدائنة في التدقيق المالي
  Dept_RId    Number(5) Default 0,               -- النشاط المقابل
  Unit_RId    Number(5) Default 0,               -- القسم المقابل
  Job_RId     Number(10),                        -- مفتاح ملف العمل المقابل
  Ord_Id      Number(10),                        -- مفتاح سلفة العمل
  Waybill     Varchar2(25),                      -- Waybill
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Fre_CLR_DBCR_PK        PRIMARY KEY (Id),
  CONSTRAINT  Fre_CLR_DBCR_Job_FK    Foreign Key (Job_Id   ) References Fre_CLR_Job  (Id),
  CONSTRAINT  Fre_CLR_DBCR_Period_FK Foreign Key (Period_Id) References Cpy_Period   (Id),
  CONSTRAINT  Fre_CLR_DBCR_Trt_FK    Foreign Key (Trt_Id   ) References Fin_Cod_Trt  (Id),
  CONSTRAINT  Fre_CLR_DBCR_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont     (Id),
  CONSTRAINT  Fre_CLR_DBCR_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn     (Id),
  CONSTRAINT  Fre_CLR_DBCR_Serv_FK   Foreign Key (Serv_Id  ) References Mng_Serv     (Id),
  CONSTRAINT  Fre_CLR_DBCR_RDept_FK  Foreign Key (Dept_RId ) References Cpy_Dept     (Id),
  CONSTRAINT  Fre_CLR_DBCR_RUnit_FK  Foreign Key (Unit_RId ) References Cpy_Unit     (Id),
  CONSTRAINT  Fre_CLR_DBCR_CLRe_FK   Foreign Key (IFre_Id  ) References Fin_TInv     (Id),
  CONSTRAINT  Fre_CLR_DBCR_DFre_FK   Foreign Key (DFre_Id  ) References Fin_TDbt     (Id),
  CONSTRAINT  Fre_CLR_DBCR_CFre_FK   Foreign Key (CFre_Id  ) References Fin_TCrd     (Id),
  CONSTRAINT  Fre_CLR_DBCR_Ord_FK    Foreign Key (Ord_Id   ) References Cash_APOrd   (Id),
  CONSTRAINT  Fre_CLR_DBCR_LOC_FK    Foreign Key (Loc_Id   ) References Fre_Cod_Loc  (Id),
  CONSTRAINT  Fre_CLR_DBCR_Item_FK   Foreign Key (Item_Id  ) References Stor_Item    (Id),
  CONSTRAINT  Fre_CLR_DBCR_Unit_FK   Foreign Key (Unit_Id  ) References Cpy_Cod_Unit (Id),
  CONSTRAINT  Fre_CLR_DBCR_Status_FK Foreign Key (Status_Id) References Phs_Cod_YesNo(Id),
  CONSTRAINT  Fre_CLR_DBCR_Ins_FK    Foreign Key (Ins_User ) References Cpy_User     (Id),
  CONSTRAINT  Fre_CLR_DBCR_Upd_FK    Foreign Key (Upd_User ) References Cpy_User     (Id)
)
/
Create Synonym Fre_CLR_DBCR For Fre_CLR_DBCR_Documents
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_CLR_TJob_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_CLR_TJob_Freight                    -- بنود الشحنات
( Id         Number(20),                         -- مفتاح رئيسي
  Job_Id     Number(10),                         -- مفتاح الأب
  Comod_Id   Number(5) Default 0,                -- البضاعة
  Unit_Id    Number(5) Default 0,                -- Unit
  Curn_Id    Number(5) Default 1,                -- العملة
  Curn_Rate  Number(25,9) Default 1,             -- سعر الصرف
  nLength    Number(25,3) Default 0,             -- الوزن الصافي
  nWidth     Number(25,3) Default 0,             -- الوزن الصافي
  nHeight    Number(25,3) Default 0,             -- الوزن الصافي
  nVolume    Number(25,3) Default 0,             -- الحجم
  TCBM       Number(25,3) Default 0,             -- الوزن المحاسب عليه
  Qnt        Number(25,3) Default 0,             -- عدد الطرود
  DQnt       Number(25,3) Default 0,             -- Delivered Quantity
  LQnt       Number(25,3) Default 0,             -- Losses Quantity
  OQnt       Number(25,3) Default 0,             -- Overload Quantity
  WNet       Number(25,3) Default 0,             -- الوزن الصافي
  WGros      Number(25,3) Default 0,             -- الوزن الوزن القائم
  WChrg      Number(25,3) Default 0,             -- الوزن المحاسب عليه
  Price      Number(25,3) Default 0,             -- إفرادي
  CAmt       Number(25,3) Default 0,             -- المبلغ عملة
  Amt        Number(25,3) Default 0,             -- القيمة
  LOT_Id     Number(20) Default 0,               -- Loading Order Type
  LON        Varchar2(30 Char),                  -- Loading Order Number
  vComd      Varchar2(250 Char),                 -- البضاعة
  TRem       Varchar2(250 Char),                 -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_CLR_TJob_PK       Primary Key (Id),
  CONSTRAINT Fre_CLR_TJob_FK       Foreign Key (Job_Id   ) References Fre_CLR_Job         (Id),
  CONSTRAINT Fre_CLR_TJob_Curn_FK  Foreign Key (Curn_Id  ) References Mng_Curn            (Id),
  CONSTRAINT Fre_CLR_TJob_nComd_FK Foreign Key (Comod_Id ) References Fre_Cod_Comod       (Id),
  CONSTRAINT Fre_CLR_TJob_Unit_FK  Foreign Key (Unit_Id  ) References Cpy_Cod_Unit        (Id),
  CONSTRAINT Fre_CLR_TJob_Ins_FK   Foreign Key (Ins_User ) References Cpy_User            (Id),
  CONSTRAINT Fre_CLR_TJob_Upd_FK   Foreign Key (Upd_User ) References Cpy_User            (Id)
)
/
Create Synonym Fre_CLR_TJob For Fre_CLR_TJob_Freight
/
-------------------------------------------------------------------------------------------------
