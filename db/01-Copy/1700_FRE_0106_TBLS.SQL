Create Sequence Fre_MRFQ_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Request_For_Quotation                     -- الطلبات
( Id            Number(9) NOT NULL,                        -- مفتاح رئيسي
  Period_Id     Number(4) Default 0,                       -- السنة
  Dept_Id       Number(5) Default 0,                       -- النشاط
  Unit_Id       Number(5) Default 0,                       -- القسم
  Oper_Id       Number(5) Default 0,                       -- العملية
  Contr_Id      Number(5),                                 -- العقد
  User_Id       Number(5),                                 -- منظم ملف العمل
  Num           Number(10) Default 0,                      -- رقم
  dDate         Date,                                      -- تاريخ
  Cont_Id       Number(9) Default 0,                       -- المتعامل
  Freight_Id    Number(1) Default 2,                       -- Freight   0 None, 1 With Freight   ,2 without Freight شحن
  Transport_Id  Number(1) Default 2,                       -- Transport 0 None, 1 With Transport ,2 without Transport نقل
  Clearance_Id  Number(1) Default 2,                       -- Clearance 0 None, 1 With papers    ,2 without papers تخليص
  ITerm_Id      Number(5) Default 0,                       -- Inco Term
  PTerm_Id      Number(5) Default 0,                       -- Payment Term
  OCntry_Id     Number(5) Default 0,                       -- المصدر Country
  OCity_Id      Number(5) Default 0,                       -- المصدر City
  OPort_Id      Number(5) Default 0,                       -- المصدر Port (LFR/RFR) المعبر
  OSPort_Id     Number(5) Default 0,                       -- المصدر Port (OFR) ميناء
  OAPort_Id     Number(5) Default 0,                       -- المصدر Airport (AFR) المطار
  DCntry_Id     Number(5) Default 0,                       -- المقصد Country
  DCity_Id      Number(5) Default 0,                       -- المقصد City
  DPort_Id      Number(5) Default 0,                       -- المقصد Port (LFR/RFR) المعبر
  DSPort_Id     Number(5) Default 0,                       -- المقصد Port (OFR) الميناء
  DAPort_Id     Number(5) Default 0,                       -- المقصد Aurport (AFR) المعبر
  OAddress      Varchar2(250 Char),                        -- العنوان في المصدر
  DAddress      Varchar2(250 Char),                        -- العنوان في المقصد
  Qnt           Number(25,3) Default 0,                    -- عدد الطرود
  WNet          Number(25,3) Default 0,                    -- الوزن الصافي
  WGros         Number(25,3) Default 0,                    -- الوزن الوزن القائم
  WChrg         Number(25,3) Default 0,                    -- الوزن المحاسب عليه
  LDM           Number(25,3) Default 0,                    -- LDM
  CBM           Number(25,3) Default 0,                    -- CBM
  vComod        Varchar2(250 Char),                        -- البضاعة
  Ref           Varchar2(10 Char),                         -- الرقم لدى الزبون
  Cust          Varchar2(250 Char),                        -- اسم الزبون في حال عدم وجوده ضمن قائمة المتعاملين
  Note          Varchar2(1024 Char),                       -- الطلب
  Rem           Varchar2(250 Char),                        -- ملاحظات
  Ins_User      Number(5), Ins_Date Date,
  Upd_User      Number(5), Upd_Date Date,
  CONSTRAINT Fre_MRFQ_PK              Primary Key (Id   ),
  CONSTRAINT Fre_MRFQ_UK              Unique      (Period_Id, Num),
  CONSTRAINT Fre_MRFQ_Period_FK       Foreign Key (Period_Id   ) References Cpy_Period       (Id),
  CONSTRAINT Fre_MRFQ_Dept_FK         Foreign Key (Dept_Id     ) References Cpy_Dept         (Id),
  CONSTRAINT Fre_MRFQ_Unit_FK         Foreign Key (Unit_Id     ) References Cpy_Unit         (Id),
  CONSTRAINT Fre_MRFQ_Oper_FK         Foreign Key (Oper_Id     ) References Cpy_Oper         (Id),
  CONSTRAINT Fre_MRFQ_Cont_FK         Foreign Key (Cont_Id     ) References Mng_Cont         (Id),
  CONSTRAINT Fre_MRFQ_User_FK         Foreign Key (User_Id     ) References Cpy_User         (Id),
  CONSTRAINT Fre_MRFQ_Freight_FK      Foreign Key (Freight_Id  ) References Phs_Cod_YesNo    (Id),
  CONSTRAINT Fre_MRFQ_Transport_FK    Foreign Key (Transport_Id) References Phs_Cod_YesNo    (Id),
  CONSTRAINT Fre_MRFQ_Clearance_FK    Foreign Key (Clearance_Id) References Phs_Cod_YesNo    (Id),
  CONSTRAINT Fre_MRFQ_ITerm_FK        Foreign Key (ITerm_Id    ) References Fre_Cod_Inco_Term(Id),
  CONSTRAINT Fre_MRFQ_PTerm_FK        Foreign Key (PTerm_Id    ) References Fre_Cod_Pay_Term (Id),
  CONSTRAINT Fre_MRFQ_Orig_FK         Foreign Key (OCntry_Id   ) References Fre_Cod_Cntry    (Id),
  CONSTRAINT Fre_MRFQ_OCity_FK        Foreign Key (OCity_Id    ) References Fre_Cod_City     (Id),
  CONSTRAINT Fre_MRFQ_OPort_FK        Foreign Key (OPort_Id    ) References Fre_Cod_City     (Id),
  CONSTRAINT Fre_MRFQ_OSPort_FK       Foreign Key (OSPort_Id   ) References Fre_Cod_SeaPort  (Id),
  CONSTRAINT Fre_MRFQ_OAPort_FK       Foreign Key (OAPort_Id   ) References Fre_Cod_AirPort  (Id),
  CONSTRAINT Fre_MRFQ_Dest_FK         Foreign Key (DCntry_Id   ) References Fre_Cod_Cntry    (Id),
  CONSTRAINT Fre_MRFQ_DCity_FK        Foreign Key (DCity_Id    ) References Fre_Cod_City     (Id),
  CONSTRAINT Fre_MRFQ_DPort_FK        Foreign Key (DPort_Id    ) References Fre_Cod_City     (Id),
  CONSTRAINT Fre_MRFQ_DSPort_FK       Foreign Key (DSPort_Id   ) References Fre_Cod_SeaPort  (Id),
  CONSTRAINT Fre_MRFQ_DAPort_FK       Foreign Key (DAPort_Id   ) References Fre_Cod_AirPort  (Id),
  CONSTRAINT Fre_MRFQ_Ins_FK          Foreign Key (Ins_User    ) References Cpy_User         (Id),
  CONSTRAINT Fre_MRFQ_Upd_FK          Foreign Key (Upd_User    ) References Cpy_User         (Id)
)
/
Create Synonym Fre_MRFQ For Fre_Request_For_Quotation
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_TRFQ_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_TRequest_For_Quotation                    -- بنود الطلبات
( Id         Number(9),                                    -- مفتاح رئيسي
  RFQ_Id     Number(9),                                    -- مفتاح الأب
  Comod_Id   Number(5) Default 0,                          -- البضاعة
  Curn_Id    Number(3) Default 1,                          -- العملة
  Curn_Rate  Number(25,9) Default 1,                       -- سعر الصرف
  nLength    Number(25,3) Default 0,                       -- الوزن الصافي
  nWidth     Number(25,3) Default 0,                       -- الوزن الصافي
  nHeight    Number(25,3) Default 0,                       -- الوزن الصافي
  nVolume    Number(25,3) Default 0,                       -- الحجم
  CBM        Number(25,3) Default 0,                       -- الوزن المحاسب عليه
  Qnt        Number(25,3) Default 0,                       -- عدد الطرود
  WNet       Number(25,3) Default 0,                       -- الوزن الصافي
  WGros      Number(25,3) Default 0,                       -- الوزن الوزن القائم
  WChrg      Number(25,3) Default 0,                       -- الوزن المحاسب عليه
  Price      Number(25,3) Default 0,                       -- إفرادي
  CAmt       Number(25,3) Default 0,                       -- المبلغ عملة
  Amt        Number(25,3) Default 0,                       -- القيمة
  vComod     Varchar2(250 Char),                           -- البضاعة
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_TRFQ_PK       Primary Key (Id  ),
  CONSTRAINT Fre_TRFQ_FK       Foreign Key (RFQ_Id  ) References Fre_MRFQ   (Id),
  CONSTRAINT Fre_TRFQ_nComd_FK Foreign Key (Comod_Id) References Fre_Cod_Comod(Id),
  CONSTRAINT Fre_TRFQ_Curn_FK  Foreign Key (Curn_Id ) References Mng_Curn     (Id),
  CONSTRAINT Fre_TRFQ_Ins_FK   Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fre_TRFQ_Upd_FK   Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fre_TRFQ For Fre_TRequest_For_Quotation
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Plan_RFQ_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Plan_Request_For_Quotation                -- خطط الطلبات
( Id          Number(9) NOT NULL,                          -- مفتاح رئيسي
  RFQ_Id      Number(9) NOT NULL,                          -- الطلب
  nOrd        Number(3) Default 0,                         -- تسلسل
  OCntry_Id   Number(5) Default 0,                         -- المصدر Country
  OCity_Id    Number(5) Default 0,                         -- المصدر City
  DCntry_Id   Number(5) Default 0,                         -- المقصد Country
  DCity_Id    Number(5) Default 0,                         -- المقصد City
  Status_Id   Number(2) Default 0,                         -- الحالة
  OpStatus_ID Number(2) Default 0,                         -- حالة العملية
  Comod_Id    Number(5) Default 0,                         -- البضاعة
  TType_Id    Number(2) Default 0,                         -- Truck Type
  Pack_Id     Number(5) Default 0,                         -- نوع التغليف Packing Type
  Cooling_Id  Number(1) Default 0,                         -- Cooling Status
  Cancel_Id   Number(1) Default 0,                         -- Cancel Status
  Driv_Id     Number(5) Default 0,                         -- Driver
  Truk_Id     Number(5) Default 0,                         -- Truck
  Qnt         Number(25,3) Default 0,                      -- عدد الطرود
  WNet        Number(25,3) Default 0,                      -- الوزن الصافي
  WGros       Number(25,3) Default 0,                      -- الوزن الوزن القائم
  WChrg       Number(25,3) Default 0,                      -- الوزن المحاسب عليه
  LDM         Number(25,3) Default 0,                      -- LDM
  CBM         Number(25,3) Default 0,                      -- CBM
  ETD         Date,                                        -- Estimated time of departure
  ETA         Date,                                        -- Estimated time of arrival
  ATD         Date,                                        -- Actual Time of Departure
  ATA         Date,                                        -- Actual Time of Arrival
  dArrODate   Date,                                        -- Arrival Date at Origin
  dLoadDate   Date,                                        -- Loading Date
  dDispDate   Date,                                        -- Dispatch Date
  dArrDDate   Date,                                        -- Arrival Date at Destination
  dUDate      Date,                                        -- Unloading Date
  Truck       Varchar2(30 Char),                           -- رقم السيارة
  Driver      Varchar2(100 Char),                          -- اسم السائق
  OAddress    Varchar2(250 Char),                          -- العنوان في المصدر
  DAddress    Varchar2(250 Char),                          -- العنوان في المقصد
  OPlace      Varchar2(250 Char),                          -- Offloading Place
  OPSRem      Varchar2(250 Char),                          -- ملاحظات حالة العملية
  vComod      Varchar2(250 Char),                          -- البضاعة
  Shipper     Varchar2(250 Char),                          -- الشاحن
  Consignee   Varchar2(250 Char),                          -- المشحون إليه
  vPath       Varchar2(250 Char),                          -- المسار
  OverDist    Varchar2(250 Char),                          -- Overdistance Place
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Fre_Plan_RFQ_PK       Primary Key (Id  ) ,
  CONSTRAINT  Fre_Plan_RFQ_RFQ_FK   Foreign Key (RFQ_Id   ) References Fre_MRFQ          (Id),
  CONSTRAINT  Fre_Plan_RFQ_Orig_FK  Foreign Key (OCntry_Id) References Fre_Cod_Cntry     (Id),
  CONSTRAINT  Fre_Plan_RFQ_Dest_FK  Foreign Key (DCntry_Id) References Fre_Cod_Cntry     (Id),
  CONSTRAINT  Fre_Plan_RFQ_OCity_FK Foreign Key (OCity_Id ) References Fre_Cod_City      (Id),
  CONSTRAINT  Fre_Plan_RFQ_DCity_FK Foreign Key (DCity_Id ) References Fre_Cod_City      (Id),
  CONSTRAINT  Fre_Plan_RFQ_Driv_FK  Foreign Key (Driv_Id  ) References Fre_Driv          (Id),
  CONSTRAINT  Fre_Plan_RFQ_Truk_FK  Foreign Key (Truk_Id  ) References Fre_Truk          (Id),
  CONSTRAINT  Fre_Plan_RFQ_Track_FK Foreign Key (TTYpe_Id ) References Fre_Cod_Truck_Type(Id),
  CONSTRAINT  Fre_Plan_RFQ_Pack_FK  Foreign Key (Pack_Id  ) References Fre_Cod_Pack      (Id),
  CONSTRAINT  Fre_Plan_RFQ_Comd_FK  Foreign Key (Comod_Id ) References Fre_Cod_Comod     (Id),
  CONSTRAINT  Fre_Plan_RFQ_Ins_FK   Foreign Key (Ins_User ) References Cpy_User          (Id),
  CONSTRAINT  Fre_Plan_RFQ_Upd_FK   Foreign Key (Upd_User ) References Cpy_User          (Id)
)
/
Create Synonym Fre_Plan_RFQ For Fre_Plan_Request_For_Quotation
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_RFQ_DBCR_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Request_For_Quotation_DBCR                -- خدمات طلب عرض
( Id          Number(10) NOT NULL,                         -- مفتاح رئيسي
  RFQ_Id      Number(9) NOT NULL,                          -- مفتاح العرض
  nOrd        Number(4) Default 0,                         -- مسلسل الإظهار
  Loc_Id      Number(1) Default 0,                         -- Location / 1 Origin / 2 Shipping / 3 Destination
  Cont_Id     Number(9) Default 0,                         -- المتعامل
  Serv_Id     Number(5) Default 0,                         -- الخدمة
  Item_Id     Number(9) Default 0,                         -- المادة
  Unit_Id     Number(5) Default 1,                         -- الوحدة
  Curn_Id     Number(3) Default 1,                         -- العملة
  Curn_Rate   Number(25,9) Default 1,                      -- سعر الصرف
  Qnt         Number(25,3) Default 0,                      -- الكمية
  Price       Number(25,3) Default 0,                      -- إفرادي
  CAmt        Number(25,3) Default 0,                      -- المبلغ عملة
  Amt         Number(25,2) Default 0,                      -- المبلغ محلي
  Rem         Varchar2(250 Char),                          -- البيان
  Ins_User    Number(20),  Ins_Date  Date,
  Upd_User    Number(20),  Upd_Date  Date,
  CONSTRAINT  Fre_RFQ_DBCR_PK       PRIMARY KEY (Id),
  CONSTRAINT  Fre_RFQ_DBCR_RFQ_FK   Foreign Key (RFQ_Id  ) References Fre_MRFQ    (Id),
  CONSTRAINT  Fre_RFQ_DBCR_Cont_FK  Foreign Key (Cont_Id ) References Mng_Cont    (Id),
  CONSTRAINT  Fre_RFQ_DBCR_Serv_FK  Foreign Key (Serv_Id ) References Mng_Serv    (Id),
  CONSTRAINT  Fre_RFQ_DBCR_Curn_FK  Foreign Key (Curn_Id ) References Mng_Curn    (Id),
  CONSTRAINT  Fre_RFQ_DBCR_Item_FK  Foreign Key (Item_Id ) References Stor_Item   (Id),
  CONSTRAINT  Fre_RFQ_DBCR_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit(Id),
  CONSTRAINT  Fre_RFQ_DBCR_LOC_FK   Foreign Key (Loc_Id  ) References Fre_Cod_Loc (Id),
  CONSTRAINT  Fre_RFQ_DBCR_Ins_FK   Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT  Fre_RFQ_DBCR_Upd_FK   Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Fre_RFQ_DBCR For Fre_Request_For_Quotation_DBCR
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Quot_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Quotation                                   -- العروض
( Id            Number(9) NOT NULL,                        -- مفتاح رئيسي
  Period_Id     Number(4) Default 0,                       -- السنة
  Dept_Id       Number(5) Default 0,                       -- النشاط
  Unit_Id       Number(5) Default 0,                       -- القسم
  Oper_Id       Number(5) Default 0,                       -- العملية
  Contr_Id      Number(5),                                 -- العقد
  RFQ_Id        Number(9),                                 -- الطلب
  User_Id       Number(5),                                 -- منظم ملف العمل
  Cont_Id       Number(9) Default 0,                       -- المتعامل
  Freight_Id    Number(1) Default 2,                       -- Freight   0 None, 1 With Freight   ,2 without Freight شحن
  Transport_Id  Number(1) Default 2,                       -- Transport 0 None, 1 With Transport ,2 without Transport نقل
  Clearance_Id  Number(1) Default 2,                       -- Clearance 0 None, 1 With papers, 2 without papers تخليص
  Num           Number(10) Default 0,                      -- رقم
  dDate         Date,                                      -- تاريخ
  VDate         Date,                                      -- تاريخ صلاحية العرض Validity Date
  FolowDate     Date,                                      -- تاريخ المتابعة التالية
  ITerm_Id      Number(5) Default 0,                       -- Inco Term
  PTerm_Id      Number(5) Default 0,                       -- Payment Term
  OCntry_Id     Number(5) Default 0,                       -- المصدر Country البلد
  OCity_Id      Number(5) Default 0,                       -- المصدر City المدينة
  OPort_Id      Number(5) Default 0,                       -- المصدر Port (LFR/RFR) المعبر
  OSPort_Id     Number(5) Default 0,                       -- المصدر Port (OFR) ميناء
  OAPort_Id     Number(5) Default 0,                       -- المصدر Airport (AFR) المطار
  OAddress      Varchar2(250 Char),                        -- العنوان في المصدر
  DCntry_Id     Number(5) Default 0,                       -- المقصد Country البلد
  DCity_Id      Number(5) Default 0,                       -- المقصد City المدينة
  DPort_Id      Number(5) Default 0,                       -- المقصد Port (LFR/RFR) المعبر
  DSPort_Id     Number(5) Default 0,                       -- المقصد Port (OFR) الميناء
  DAPort_Id     Number(5) Default 0,                       -- المقصد Aurport (AFR) المعبر
  DAddress      Varchar2(250 Char),                        -- العنوان في المقصد
  Qnt           Number(25,3) Default 0,                    -- عدد الطرود
  WNet          Number(25,3) Default 0,                    -- الوزن الصافي
  WGros         Number(25,3) Default 0,                    -- الوزن الوزن القائم
  WChrg         Number(25,3) Default 0,                    -- الوزن المحاسب عليه
  Price         Number(25,3) Default 0,                    -- السعر الافرادي
  CAmt          Number(25,3) Default 0,                    -- المبلغ عملة
  Amt           Number(25,3) Default 0,                    -- القيمة
  LDM           Number(25,3) Default 0,                    -- LDM
  CBM           Number(25,3) Default 0,                    -- CBM
  Curn_Id       Number(3) Default 1,                       -- العملة
  Curn_Rate     Number(25,9) Default 1,                    -- سعر الصرف
  ETD           Date,                                      -- Estimated time of departure
  ETA           Date,                                      -- Estimated time of arrival
  vComod        Varchar2(250 Char),                        -- البضاعة
  Ship          Varchar2(250 Char),                        -- الشاحن
  Cons          Varchar2(250 Char),                        -- المشحون إليه
  Quot         Varchar2(250 Char),                        -- Quot/Rate نص العرض
  Status_Id     Number(2) Default 0,                       -- الحالة
  StatusType_Id Number(5) Default 0,                       -- تفصيل الحالة
  StatusRem     Varchar2(250 Char),                        -- شرح الحالة
  Terms         Varchar2(250 Char),                        -- Terms and Conditions الشروط والأحكام
  Cust          Varchar2(250 Char),                        -- اسم الزبون في حال عدم وجوده ضمن قائمة المتعاملين
  CPerson       Varchar2(250 Char),                        -- Contact Person شخص الاتصال
  Rem           Varchar2(250 Char),                        -- ملاحظات
  Ins_User      Number(5), Ins_Date Date,
  Upd_User      Number(5), Upd_Date Date,
  CONSTRAINT    Fre_Quot_PK              Primary Key (Id),
  CONSTRAINT    Fre_Quot_UK              Unique      (Period_Id, Dept_Id, Num),
  CONSTRAINT    Fre_Quot_WPer_FK         Foreign Key (Period_Id    ) References Cpy_Period          (Id),
  CONSTRAINT    Fre_Quot_Dept_FK         Foreign Key (Dept_Id      ) References Cpy_Dept            (Id),
  CONSTRAINT    Fre_Quot_Unit_FK         Foreign Key (Unit_Id      ) References Cpy_Unit            (Id),
  CONSTRAINT    Fre_Quot_Oper_FK         Foreign Key (Oper_Id      ) References Cpy_Oper            (Id),
  CONSTRAINT    Fre_Quot_RFQ_FK          Foreign Key (RFQ_Id       ) References Fre_MRFQ            (Id),
  CONSTRAINT    Fre_Quot_Cont_FK         Foreign Key (Cont_Id      ) References Mng_Cont            (Id),
  CONSTRAINT    Fre_Quot_Status_FK       Foreign Key (Status_Id    ) References Fre_Cod_Approve     (Id),
  CONSTRAINT    Fre_Quot_StatusType_FK   Foreign Key (StatusType_Id) References Fre_Cod_Status_Type (Id),
  CONSTRAINT    Fre_Quot_ITerm_FK        Foreign Key (ITerm_Id     ) References Fre_Cod_Inco_Term   (Id),
  CONSTRAINT    Fre_Quot_PTerm_FK        Foreign Key (PTerm_Id     ) References Fre_Cod_Pay_Term    (Id),
  CONSTRAINT    Fre_Quot_OCntry_FK       Foreign Key (OCntry_Id    ) References Fre_Cod_Cntry       (Id),
  CONSTRAINT    Fre_Quot_OCity_FK        Foreign Key (OCity_Id     ) References Fre_Cod_City        (Id),
  CONSTRAINT    Fre_Quot_OPort_FK        Foreign Key (OPort_Id     ) References Fre_Cod_City        (Id),
  CONSTRAINT    Fre_Quot_OSPort_FK       Foreign Key (OSPort_Id    ) References Fre_Cod_SeaPort     (Id),
  CONSTRAINT    Fre_Quot_OAPort_FK       Foreign Key (OAPort_Id    ) References Fre_Cod_AirPort     (Id),
  CONSTRAINT    Fre_Quot_DCntry_FK       Foreign Key (DCntry_Id    ) References Fre_Cod_Cntry       (Id),
  CONSTRAINT    Fre_Quot_DCity_FK        Foreign Key (DCity_Id     ) References Fre_Cod_City        (Id),
  CONSTRAINT    Fre_Quot_DPort_FK        Foreign Key (DPort_Id     ) References Fre_Cod_City        (Id),
  CONSTRAINT    Fre_Quot_DSPort_FK       Foreign Key (DSPort_Id    ) References Fre_Cod_SeaPort     (Id),
  CONSTRAINT    Fre_Quot_DAPort_FK       Foreign Key (DAPort_Id    ) References Fre_Cod_AirPort     (Id),
  CONSTRAINT    Fre_Quot_Curn_FK         Foreign Key (Curn_Id      ) References Mng_Curn            (Id),
  CONSTRAINT    Fre_Quot_Freight_FK      Foreign Key (Freight_Id   ) References Phs_Cod_YesNo       (Id),
  CONSTRAINT    Fre_Quot_Transport_FK    Foreign Key (Transport_Id ) References Phs_Cod_YesNo       (Id),
  CONSTRAINT    Fre_Quot_Clearance_FK    Foreign Key (Clearance_Id ) References Phs_Cod_YesNo       (Id),
  CONSTRAINT    Fre_Quot_Ins_FK          Foreign Key (Ins_User     ) References Cpy_User            (Id),
  CONSTRAINT    Fre_Quot_Upd_FK          Foreign Key (Upd_User     ) References Cpy_User            (Id)
)
/
Create Synonym Fre_Quot  For Fre_Quotation
/
--Alter Table Fre_Quotation Add CONSTRAINT Fre_MOfr_Contr_FK  Foreign Key (Contr_Id) References Fre_MCntrct(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Quot_Item_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Quot_Items                         -- بنود العرض
( Id          Number(10),                        -- مفتاح رئيسي
  Quot_Id     Number(9),                         -- مفتاح الأب
  Comod_Id    Number(5) Default 0,               -- البضاعة
  Serv_Id     Number(5) Default 0,               -- الخدمة
  Curn_Id     Number(3) Default 1,               -- العملة
  Curn_Rate   Number(25,9) Default 1,            -- سعر الصرف
  nLength     Number(25,3) Default 0,            -- الطول
  nWidth      Number(25,3) Default 0,            -- العرض
  nHeight     Number(25,3) Default 0,            -- الارتفاع
  nVolume     Number(25,3) Default 0,            -- الحجم
  CBM         Number(25,3) Default 0,            -- الوزن الحجمي - الوزن المحاسب عليه
  Qnt         Number(25,3) Default 0,            -- عدد الطرود
  Unit_Id     Number(5)    Default 1,            -- الوحدة
  WNet        Number(25,3) Default 0,            -- الوزن الصافي
  WGros       Number(25,3) Default 0,            -- الوزن القائم
  WChrg       Number(25,3) Default 0,            -- الوزن المحاسب عليه
  Price       Number(25,3) Default 0,            -- إفرادي
  CAmt        Number(25,3) Default 0,            -- المبلغ عملة
  Amt         Number(25,3) Default 0,            -- القيمة
  vComod      Varchar2(250 Char),                -- البضاعة
  TRem        Varchar2(250 Char),                -- ملاحظات
  Ins_User    Number(20), Ins_Date Date,
  Upd_User    Number(20), Upd_Date Date,
  CONSTRAINT  Fre_Quot_Item_PK       Primary Key (Id),
  CONSTRAINT  Fre_Quot_Item_FK       Foreign Key (Quot_Id   ) References Fre_Quot    (Id),
  CONSTRAINT  Fre_Quot_Item_nComd_FK Foreign Key (Comod_Id  ) References Fre_Cod_Comod(Id),
  CONSTRAINT  Fre_Quot_Item_Serv_FK  Foreign Key (Serv_Id   ) References Mng_Serv     (Id),
  CONSTRAINT  Fre_Quot_Item_Curn_FK  Foreign Key (Curn_Id   ) References Mng_Curn     (Id),
  CONSTRAINT  Fre_Quot_Item_Unit_FK  Foreign Key (Unit_Id   ) References Cpy_Cod_Unit (Id),
  CONSTRAINT  Fre_Quot_Item_Ins_FK   Foreign Key (Ins_User  ) References Cpy_User     (Id),
  CONSTRAINT  Fre_Quot_Item_Upd_FK   Foreign Key (Upd_User  ) References Cpy_User     (Id)
)
/
Create Synonym Fre_Quot_Item For Fre_Quot_Items
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Quotation_DBCR_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Quotation_DBCR_Documents                     -- خدمات عرض
( Id          Number(10) NOT NULL,                         -- مفتاح رئيسي
  Quot_Id     Number(9) NOT NULL,                          -- مفتاح العرض
  nOrd        Number(4) Default 0,                         -- مسلسل الإظهار
  Loc_Id      Number(1) Default 0,                         -- Location / 1 Origin / 2 Shipping / 3 Destination
  Cont_Id     Number(9) Default 0,                         -- المتعامل
  Serv_Id     Number(5) Default 0,                         -- الخدمة
  Item_Id     Number(9) Default 0,                         -- المادة
  Unit_Id     Number(5) Default 1,                         -- الوحدة
  Curn_Id     Number(3) Default 1,                         -- العملة
  Curn_Rate   Number(25,9) Default 1,                      -- سعر الصرف
  Qnt         Number(25,3) Default 0,                      -- الكمية
  Price       Number(25,3) Default 0,                      -- إفرادي
  CAmt        Number(25,3) Default 0,                      -- المبلغ عملة
  Amt         Number(25,2) Default 0,                      -- المبلغ محلي
  Rem         Varchar2(250 Char),                          -- البيان
  Ins_User    Number(20),  Ins_Date  Date,
  Upd_User    Number(20),  Upd_Date  Date,
  CONSTRAINT  Fre_Quotation_DBCR_PK       PRIMARY KEY (Id),
  CONSTRAINT  Fre_Quotation_DBCR_Quot_FK  Foreign Key (Quot_Id ) References Fre_Quot   (Id),
  CONSTRAINT  Fre_Quotation_DBCR_Cont_FK  Foreign Key (Cont_Id ) References Mng_Cont    (Id),
  CONSTRAINT  Fre_Quotation_DBCR_Serv_FK  Foreign Key (Serv_Id ) References Mng_Serv    (Id),
  CONSTRAINT  Fre_Quotation_DBCR_Curn_FK  Foreign Key (Curn_Id ) References Mng_Curn    (Id),
  CONSTRAINT  Fre_Quotation_DBCR_Item_FK  Foreign Key (Item_Id ) References Stor_Item   (Id),
  CONSTRAINT  Fre_Quotation_DBCR_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit(Id),
  CONSTRAINT  Fre_Quotation_DBCR_LOC_FK   Foreign Key (Loc_Id  ) References Fre_Cod_Loc (Id),
  CONSTRAINT  Fre_Quotation_DBCR_Ins_FK   Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT  Fre_Quotation_DBCR_Upd_FK   Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Fre_Quotation_DBCR For Fre_Quotation_DBCR_Documents
/
----------------------------------------------------------------------------------------------------
Create Table Fre_Job_Freight                     -- ملفات العمل الموحدة (محلي، دولي، تخليص جمركي)
( Id           Number(10),                       -- مفتاح رئيسي
  
  -- التنظيم والهيكلية
  Dept_Id      Number(5) Default 0,              -- النشاط
  Unit_Id      Number(5) Default 0,              -- القسم
  Oper_Id      Number(5) Default 0,              -- العملية
  Period_Id    Number(5) Default 0,              -- السنة
  Num          Number(10) Default 0,             -- رقم الملف
  dDate        Date Default Sysdate,             -- تاريخ الإنشاء
  Descr        Varchar2(100 Char),               -- وصف ملف العمل

  -- الأطراف والعقود
  Quot_Id      Number(5) Default 0,              -- مفتاح العرض
  Cont_Id      Number(9) Default 0,              -- المتعامل \ الزبون
  Cont_RId     Number(9) Default 0,              -- المتعامل \ المورد
  Contr_Id     Number(5) Default 0,              -- عقد الزبون
  Contr_RId    Number(5) Default 0,              -- عقد المورد
  Driv_Id      Number(5) Default 0,              -- السائق (مربوط بترميز)
  Truk_Id      Number(5) Default 0,              -- المركبة (مربوط بترميز)
  Emp_Id       Number(9) Default 0,              -- المشرف / المسؤول
  Owner_Id     Number(5),                        -- منظم ملف العمل
  DCust        Varchar2(100 Char),               -- اسم الزبون الظاهر على الأوراق

  -- الشروط والموقع الجغرافي
  ITerm_Id     Number(5) Default 0,              -- Inco Term
  PTerm_Id     Number(5) Default 0,              -- Payment Term
  Mode_Id      Number(2) Default 2,              -- وضع التجميع: 0 عادي، 1 تجميع
  OCntry_Id    Number(5) Default 0,              -- بلد المصدر
  OCity_Id     Number(5) Default 0,              -- مدينة المصدر
  OPort_Id     Number(5) Default 0,              -- المعبر المصدر
  OSPort_Id    Number(5) Default 0,              -- الميناء المصدر
  OAPort_Id    Number(5) Default 0,              -- المطار المصدر
  OName        Varchar2(100 Char),               -- اسم المصدر (يدوي)
  OAddress     Varchar2(250 Char),               -- عنوان المصدر
  DCntry_Id    Number(5) Default 0,              -- بلد المقصد
  DCity_Id     Number(5) Default 0,              -- مدينة المقصد
  DPort_Id     Number(5) Default 0,              -- المعبر المقصد
  DSPort_Id    Number(5) Default 0,              -- الميناء المقصد
  DAPort_Id    Number(5) Default 0,              -- المطار المقصد
  DName        Varchar2(100 Char),               -- اسم المقصد (يدوي)
  DAddress     Varchar2(250 Char),               -- عنوان المقصد

  -- البضاعة والأبعاد
  Comod_Id     Number(5) Default 0,              -- البضاعة (ترميز)
  vComd        Varchar2(250 Char),               -- وصف البضاعة (يدوي)
  Ship         Varchar2(250 Char),               -- الشاحن
  Cons         Varchar2(250 Char),               -- المشحون إليه
  Qnt          Number(25,3) Default 0,           -- عدد الطرود
  Price        Number(25,3) Default 0,           -- السعر
  WNet         Number(25,3) Default 0,           -- الوزن الصافي
  WGros        Number(25,3) Default 0,           -- الوزن القائم
  WChrg        Number(25,3) Default 0,           -- الوزن المحاسب عليه
  Volume       Number(25,3) Default 0,           -- الحجم
  Dist         Number(25,3) Default 0,           -- المسافة
  ODist        Number(25,3) Default 0,           -- المسافة الزائدة
  SDM          Number(25,3) Default 0,           -- Supplier Loading Meter
  LDM          Number(25,3) Default 0,           -- LDM
  CBM          Number(25,3) Default 0,           -- CBM
  OverQnt      Number(25,3) Default 0,           -- Overload Quantity
  OPlace       Varchar2(100 Char),               -- Offloading Place
  Pack_Id      Number(5) Default 0,              -- نوع التغليف

  -- النقل والمعدات
  Track_Id     Number(5) Default 0,              -- نوع الشاحنة (دولي)
  TType_Id     Number(5) Default 0,              -- نوع الشاحنة (محلي/جمركي)
  Truck        Varchar2(30 Char),                -- رقم اللوحة
  Driver       Varchar2(100 Char),               -- اسم السائق (يدوي)
  AirLine_Id   Number(5) Default 0,              -- شركة الطيران
  ShipLine_Id  Number(5) Default 0,              -- شركة الشحن البحري
  TripNo       Number(5) Default 1,              -- رقم الرحلة
  VTrip        Varchar2(30 Char),                -- رقم الرحلة النصي
  DTrip        Date,                             -- تاريخ الرحلة
  CLType_Id    Number(2) Default 1,              -- CL Type: 1 FCL, 2 LCL
  TLType_Id    Number(2) Default 1,              -- TL Type: 1 FTL, 2 LTL
  TPNM         Varchar2(30 Char),                -- Track Pallet Number Main
  TPNT         Varchar2(30 Char),                -- Track Pallet Number Trella

  -- المالي والعملات
  Curn_Id      Number(3) Default 1,              -- العملة
  Curn_Rate    Number(25,9) Default 1,           -- سعر الصرف
  Amt          Number(25,3) Default 0,           -- القيمة
  CAmt         Number(25,3) Default 0,           -- القيمة بعملة الأصل
  Comm         Number(25,3) Default 0,           -- العمولة
  CComm        Number(25,3) Default 0,           -- العمولة بعملة الأصل
  DueDate      Date,                             -- تاريخ الاستحقاق
  ODmrge       Number(7,2) Default 0,            -- تأخير المصدر (Demurrage)
  DDmrge       Number(7,2) Default 0,            -- تأخير المقصد (Demurrage)

  -- التواريخ الزمنية
  ETD          Date,                             -- Estimated time of departure
  ETA          Date,                             -- Estimated time of arrival
  ATD          Date,                             -- Actual Time of Departure
  ATA          Date,                             -- Actual Time of Arrival
  ArrODate     Date,                             -- Arrival Date at Origin
  LoadDate     Date,                             -- Loading Date
  DispDate     Date,                             -- Dispatch Date
  ArrDDate     Date,                             -- Arrival Date at Destination
  UDate        Date,                             -- Unloading Date
  DocDate      Date,                             -- Receive Documents Date
  CMRDate      Date,                             -- CMR Date
  SDate        Date,                             -- تاريخ الحالة / الإغلاق
  DelDate      Date,                             -- تاريخ التسليم
  MDate        Date,                             -- تاريخ الوثيقة الرئيسي
  HDate        Date,                             -- تاريخ الوثيقة المحلي
  EDate        Date,                             -- تاريخ الوثيقة express
  FDate        Date,                             -- تاريخ رحلة الطيران
  KDocDate     Date,                             -- تاريخ الوثيقة المرتبطة
  IDocDate     Date,                             -- تاريخ البيان الجمركي دخول
  ODocDate     Date,                             -- تاريخ البيان الجمركي خروج
  TKDocDate    Date,                             -- تاريخ وثيقة النقل الإضافية

  -- الوثائق والمراجع
  MNum         Varchar2(30 Char),                -- رقم الوثيقة الرئيسي
  HNum         Varchar2(30 Char),                -- رقم الوثيقة المحلي
  ENum         Varchar2(30 Char),                -- رقم الوثيقة express
  FNum         Varchar2(30 Char),                -- رقم رحلة الطيران
  nRef         Varchar2(30 Char),                -- Reference Number
  BRef         Varchar2(30 Char),                -- Booking Reference Number
  POrder       Varchar2(30 Char),                -- Pickup Order Number
  Waybill      Varchar2(30 Char),                -- رقم وثيقة النقل
  DelNum       Varchar2(10 Char),                -- رقم التسليم
  KDocType_Id  Number(5) Default 0,              -- نوع الوثيقة المرتبطة
  KDocNum      Varchar2(30 Char),                -- رقم الوثيقة المرتبطة
  IDocType_Id  Number(5) Default 0,              -- نوع وثيقة الدخول
  IDocNum      Varchar2(30 Char),                -- رقم البيان دخول (Declaration)
  ODocType_Id  Number(5) Default 0,              -- نوع وثيقة الخروج
  ODocNum      Varchar2(30 Char),                -- رقم البيان خروج (Declaration)
  TKDocType_Id Number(5) Default 0,              -- نوع وثيقة النقل الإضافية
  TKDocNum     Varchar2(30 Char),                -- رقم وثيقة النقل الإضافية

  -- الحالات والأعلام
  Status_Id    Number(2) Default 0,              -- الحالة العامة
  SRem         Varchar2(250 Char),               -- ملاحظات الحالة
  DStatus_Id   Number(2) Default 2,              -- حالة التسليم
  OpStatus_Id  Number(5) Default 2,              -- حالة العملية
  OPSRem       Varchar2(250 Char),               -- ملاحظات حالة العملية
  PSStatus_Id  Number(10) Default 2,             -- ProfitShare Status
  Cooling_Id   Number(1) Default 2,              -- Cooling Status
  Cancel_Id    Number(1) Default 2,              -- Cancel Status

  -- التسليم والملاحظات
  DelPerson    Varchar2(100 Char),               -- المستلم (موحد من DelName/DPerson)
  DelRem       Varchar2(100 Char),               -- ملاحظات التسليم
  OrigRem      Varchar2(250 Char),               -- ملاحظات التحميل
  DestRem      Varchar2(250 Char),               -- ملاحظات التفريغ
  Rem          Varchar2(250 Char),               -- ملاحظات عامة
  vPath        Varchar2(250 Char),               -- المسار
  OverDist     Varchar2(250 Char),               -- Overdistance Place

  -- الربط والتدقيق
  Rel_Id       Number(9),                        -- مفتاح ملف العمل المرتبط
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,

  CONSTRAINT   Fre_Job_PK               Primary Key (Id),
  CONSTRAINT   Fre_Job_UK               Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT   Fre_Job_Ins_FK           Foreign Key (Ins_User   ) References Cpy_User           (Id),
  CONSTRAINT   Fre_Job_Upd_FK           Foreign Key (Upd_User   ) References Cpy_User           (Id)
)
/
Create Synonym Fre_Job For Fre_Job_Freight
/

/* المفاتيح الخارجية موحدة وشاملة */
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Period_FK    Foreign Key (Period_Id  ) References Cpy_Period         (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Dept_FK      Foreign Key (Dept_Id    ) References Cpy_Dept           (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Unit_FK      Foreign Key (Unit_Id    ) References Cpy_Unit           (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Oper_FK      Foreign Key (Oper_Id    ) References Cpy_Oper           (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Owner_FK     Foreign Key (Owner_Id   ) References Cpy_User           (Id);

Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Quot_FK      Foreign Key (Quot_Id    ) References Fre_Quot           (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Cont_FK      Foreign Key (Cont_Id    ) References Mng_Cont           (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_RCont_FK     Foreign Key (Cont_RId   ) References Mng_Cont           (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Driv_FK      Foreign Key (Driv_Id    ) References Fre_Driv           (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Trk_FK       Foreign Key (Truk_Id    ) References Fre_Truk           (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Emp_FK       Foreign Key (Emp_Id     ) References Emp_Emp            (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Contr_FK     Foreign Key (Contr_Id   ) References Fre_MCntrct        (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_RContr_FK    Foreign Key (Contr_RId  ) References Fre_MCntrct        (Id);

Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_ITerm_FK     Foreign Key (ITerm_Id   ) References Fre_Cod_Inco_Term  (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_PTerm_FK     Foreign Key (PTerm_Id   ) References Fre_Cod_Pay_Term   (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Curn_FK      Foreign Key (Curn_Id    ) References Mng_Curn           (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Mode_FK      Foreign Key (Mode_Id    ) References Phs_Cod_YesNo      (Id);

Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_OCntry_FK    Foreign Key (OCntry_Id  ) References Fre_Cod_Cntry      (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_OCity_FK     Foreign Key (OCity_Id   ) References Fre_Cod_City       (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_OPort_FK     Foreign Key (OPort_Id   ) References Fre_Cod_City       (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_OSPort_FK    Foreign Key (OSPort_Id  ) References Fre_Cod_SeaPort    (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_OAPort_FK    Foreign Key (OAPort_Id  ) References Fre_Cod_AirPort    (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_DCntry_FK    Foreign Key (DCntry_Id  ) References Fre_Cod_Cntry      (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_DCity_FK     Foreign Key (DCity_Id   ) References Fre_Cod_City       (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_DPort_FK     Foreign Key (DPort_Id   ) References Fre_Cod_City       (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_DSPort_FK    Foreign Key (DSPort_Id  ) References Fre_Cod_SeaPort    (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_DAPort_FK    Foreign Key (DAPort_Id  ) References Fre_Cod_AirPort    (Id);

Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_nComd_FK     Foreign Key (Comod_Id   ) References Fre_Cod_Comod      (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Pack_FK      Foreign Key (Pack_Id    ) References Fre_Cod_Pack       (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Track_FK     Foreign Key (Track_Id   ) References Fre_Cod_Track      (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_TType_FK     Foreign Key (TType_Id   ) References Fre_Cod_Truck_Type (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_AirLine_FK   Foreign Key (AirLine_Id ) References Fre_Cod_Airline    (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_ShipLine_FK  Foreign Key (ShipLine_Id) References Fre_Cod_Shipline   (Id);

Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Status_FK    Foreign Key (Status_Id  ) References Fre_Cod_Job_Status (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_OperStat_FK  Foreign Key (OpStatus_Id) References Fre_Cod_Oper_Status(Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_DStatus_FK   Foreign Key (DStatus_Id ) References Phs_Cod_YesNo      (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_PSStatus_FK  Foreign Key (PSStatus_Id) References Phs_Cod_YesNo      (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Cooling_FK   Foreign Key (Cooling_Id ) References Phs_Cod_YesNo      (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_Cancel_FK    Foreign Key (Cancel_Id  ) References Phs_Cod_YesNo      (Id);

Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_KDocType_FK  Foreign Key (KDocType_Id ) References Fre_Cod_KDocType  (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_IDocType_FK  Foreign Key (IDocType_Id ) References Fre_Cod_IDocType  (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_ODocType_FK  Foreign Key (ODocType_Id ) References Fre_Cod_ODocType  (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_TKDocType_FK Foreign Key (TKDocType_Id) References Fre_Cod_KDocType  (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_CLType_FK    Foreign Key (CLType_Id   ) References Fre_Cod_Pack      (Id);
Alter Table Fre_Job_Freight Add CONSTRAINT Fre_Job_TLType_FK    Foreign Key (TLType_Id   ) References Fre_Cod_Truck_Type(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Job_Quot_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Job_Quotation                      -- عروض ملف عمل
( Id           Number(20),                      -- مفتاح رئيسي
  Job_Id       Number(20) Default 0,            -- النشاط
  Quot_Id      Number(20) Default 0,            -- مفتاح العرض
  Cont_Id      Number(20) Default 0,            -- المتعامل\الزبون
  Rem          Varchar2(250 Char),              -- ملاحظات
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT   Fre_Job_Quot_PK      Primary Key (Id),
  CONSTRAINT   Fre_Job_Quot_UK      Unique      (Job_Id, Quot_Id),
  CONSTRAINT   Fre_Job_Quot_Job_FK  Foreign Key (Job_Id  ) References Fre_Job  (Id),
  CONSTRAINT   Fre_Job_Quot_Quot_FK Foreign Key (Quot_Id ) References Fre_Quot(Id),
  CONSTRAINT   Fre_Job_Quot_Cont_FK Foreign Key (Cont_Id ) References Mng_Cont (Id),
  CONSTRAINT   Fre_Job_Quot_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT   Fre_Job_Quot_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Fre_Job_Quot For Fre_Job_Quotation
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Job_Module_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Job_Modules                     -- مقاطع ملف عمل
( Id            Number(20),                      -- مفتاح رئيسي
  Job_Id        Number(20),                      -- مفتاح الأب
  Module_Id     Number(2) Default 0,             -- نوع المقطع 1 جوي / 2 بري / 3 بحري
  nOrd          Number(2) Default 0,             -- الترتيب
  Airline_Id    Number(5) Default 0,             -- airLine
  Roadline_Id   Number(5) Default 0,             -- Train Line
  Shipline_Id   Number(5) Default 0,             -- Shipping Line
  OTCntry_Id    Number(5) Default 0,             -- بلد المصدر للمقطع
  OTCity_Id     Number(5) Default 0,             -- مدينة المصدر للمقطع
  OAPort_Id     Number(5) Default 0,             -- مطار المصدر للمقطع
  ORPort_Id     Number(5) Default 0,             -- معبر المصدر للمقطع
  OSPort_Id     Number(5) Default 0,             -- ميناء المصدر للمقطع
  OTAddress     Varchar2(250 Char),              -- عنوان المصدر للمقطع
  DTCntry_Id    Number(5) Default 0,             -- بلد المقصد للمقطع
  DTCity_Id     Number(5) Default 0,             -- مدينة المقصد للمقطع
  DAPort_Id     Number(5) Default 0,             -- مطار المقصد للمقطع
  DRPort_Id     Number(5) Default 0,             -- معبر المقصد للمقطع
  DSPort_Id     Number(5) Default 0,             -- ميناء المقصد للمقطع
  DTAddress     Varchar2(250 Char),              -- عنوان المقصد للمقطع
  BOLNo         Varchar2(50 Char),               -- Bill of Load
  BOLDate       Date,                            -- تاريخ
  CLType_Id     Number(2) Default 1,             -- CL Type, 1 FCL, 2 LCL
  TLType_Id     Number(2) Default 1,             -- TL Type, 1 FTL, 2 LTL
  TType_Id      Number(2) Default 0,             -- Truck Type
  TPNM          Varchar2(30 Char),               -- Track Palet Number Main
  TPNT          Varchar2(30 Char),               -- Track Palet Number Trella
  Driver        Varchar2(250 Char),              -- اسم السائق
  VTrip         Varchar2(30 Char),               -- Trip Number
  DTrip         Date,                            -- Trips Date
  Ins_User      Number(5), Ins_Date     Date,
  Upd_User      Number(5), Upd_Date     Date,
  CONSTRAINT    Fre_Job_Module_PK           Primary Key (Id),
  CONSTRAINT    Fre_Job_Module_Job_FK       Foreign Key (Job_Id     ) References Fre_Job            (Id),
  CONSTRAINT    Fre_Job_Module_Module_FK    Foreign Key (Module_Id  ) References Fre_Cod_Module_Type(Id),
  CONSTRAINT    Fre_Job_Module_ALine_FK     Foreign Key (Airline_Id ) References Fre_Cod_Airline    (Id),
  CONSTRAINT    Fre_Job_Module_RLine_FK     Foreign Key (Roadline_Id) References Fre_Cod_Roadline   (Id),
  CONSTRAINT    Fre_Job_Module_SLine_FK     Foreign Key (Shipline_Id) References Fre_Cod_Shipline   (Id),
  CONSTRAINT    Fre_Job_Module_OCntry_FK    Foreign Key (OTCntry_Id ) References Fre_Cod_Cntry      (Id),
  CONSTRAINT    Fre_Job_Module_OCity_FK     Foreign Key (OTCity_Id  ) References Fre_Cod_City       (Id),
  CONSTRAINT    Fre_Job_Module_OAPort_FK    Foreign Key (OAPort_Id  ) References Fre_Cod_AirPort    (Id),
  CONSTRAINT    Fre_Job_Module_ORPort_FK    Foreign Key (ORPort_Id  ) References Fre_Cod_City       (Id),
  CONSTRAINT    Fre_Job_Module_OSPort_FK    Foreign Key (OSPort_Id  ) References Fre_Cod_SeaPort    (Id),
  CONSTRAINT    Fre_Job_Module_DCntry_FK    Foreign Key (DTCntry_Id ) References Fre_Cod_Cntry      (Id),
  CONSTRAINT    Fre_Job_Module_DCity_FK     Foreign Key (DTCity_Id  ) References Fre_Cod_City       (Id),
  CONSTRAINT    Fre_Job_Module_DAPort_FK    Foreign Key (DAPort_Id  ) References Fre_Cod_AirPort    (Id),
  CONSTRAINT    Fre_Job_Module_DRPort_FK    Foreign Key (DRPort_Id  ) References Fre_Cod_City       (Id),
  CONSTRAINT    Fre_Job_Module_DSPort_FK    Foreign Key (DSPort_Id  ) References Fre_Cod_SeaPort    (Id),
  CONSTRAINT    Fre_Job_Module_CLType_FK    Foreign Key (CLType_Id  ) References Fre_Cod_CL_Type    (Id),
  CONSTRAINT    Fre_Job_Module_TLType_FK    Foreign Key (TLType_Id  ) References Fre_Cod_TL_Type    (Id),
  CONSTRAINT    Fre_Job_Module_TType_FK     Foreign Key (TType_Id   ) References Fre_Cod_Truck_Type (Id),
  CONSTRAINT    Fre_Job_Module_Ins_FK       Foreign Key (Ins_User   ) References Cpy_User           (Id),
  CONSTRAINT    Fre_Job_Module_Upd_FK       Foreign Key (Upd_User   ) References Cpy_User           (Id)
)
/
Create Synonym Fre_Job_Module For Fre_Job_Modules
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_RJFs_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Related_Job_Files        -- ملفات العمل المرتبطة
( Id         Number(20) NOT NULL,         -- مفتاح رئيسي
  Job_Id     Number(20) Default 0,        -- مفتاح ملف العمل
  Job_RId    Number(20) Default 0,        -- مفتاح ملف العمل
  dDate      Date,                        -- التاريخ و الوقت
  Rem        Varchar2(100 Char),          -- البيان
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_RJFs_PK     PRIMARY KEY (Id),
  CONSTRAINT Fre_RJFs_UK     Unique      (Job_Id, Job_RId),
  CONSTRAINT Fre_RJFs_Job_FK Foreign Key (Job_Id  ) References Fre_Job (Id),
  CONSTRAINT Fre_RJFs_Rel_FK Foreign Key (Job_RId ) References Fre_Job (Id),
  CONSTRAINT Fre_RJFs_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Fre_RJFs_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Fre_RJFs For Fre_Related_Job_Files
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Job_DBCR_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Job_DBCR_Documents              -- الوثائق المدينة\الدائنة التابعة لملف عمل
( Id          Number(20) NOT NULL,               -- مفتاح رئيسي
  Job_Id      Number(10) NOT NULL,               -- مفتاح ملف العمل
  nOrd        Number(4),                         -- مسلسل الإظهار
  Num         Number(10),                        -- الرقم
  dDate       Date,                              -- التاريخ
  Loc_Id      Number(5) Default 0,               -- المكان Location / 1 Origin / 2 Shipping / 3 Destination
  Trt_Id      Number(5) Default 11,              -- Trt Type / 11 Inv / 12 DBT / 21 CRD / 22 EXP
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
  Rem         Varchar2(250 Char),                -- البيان
  IFin_Id     Number(10),                        -- مفتاخ لبند الفاتورة في التدقيق المالي
  DFin_Id     Number(10),                        -- مفتاخ بند الوثيقة المدينة في التدقيق المالي
  CFin_Id     Number(10),                        -- مفتاخ بند الوثيقة الدائنة في التدقيق المالي
  Status_Id   Number(2) Default 2,               -- حالة الموافقة من مدير القسم 0 جديدة \ 1 موافق عليها
  Dept_RId    Number(5) Default 0,               -- النشاط المقابل
  Unit_RId    Number(5) Default 0,               -- القسم المقابل
  Job_RId     Number(10),                        -- مفتاح ملف العمل المقابل
  Ord_Id      Number(10),                        -- مفتاح سلفة العمل
  Waybill     Number(10),                        -- Waybill
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Fre_Job_DBCR_PK        PRIMARY KEY (Id),
  CONSTRAINT  Fre_Job_DBCR_Job_FK    Foreign Key (Job_Id   ) References Fre_Job      (Id),
  CONSTRAINT  Fre_Job_DBCR_LOC_FK    Foreign Key (Loc_Id   ) References Fre_Cod_Loc  (Id),
  CONSTRAINT  Fre_Job_DBCR_Trt_FK    Foreign Key (Trt_Id   ) References Fre_Cod_Trt  (Id),
  CONSTRAINT  Fre_Job_DBCR_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont     (Id),
  CONSTRAINT  Fre_Job_DBCR_Serv_FK   Foreign Key (Serv_Id  ) References Mng_Serv     (Id),
  CONSTRAINT  Fre_Job_DBCR_Unit_FK   Foreign Key (Unit_Id  ) References Cpy_Cod_Unit (Id),
  CONSTRAINT  Fre_Job_DBCR_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn     (Id),
  CONSTRAINT  Fre_Job_DBCR_Status_FK Foreign Key (Status_Id) References Phs_Cod_YesNo(Id),
  CONSTRAINT  Fre_Job_DBCR_RDept_FK  Foreign Key (Dept_RId ) References Cpy_Dept     (Id),
  CONSTRAINT  Fre_Job_DBCR_RUnit_FK  Foreign Key (Unit_RId ) References Cpy_Unit     (Id),
  CONSTRAINT  Fre_Job_DBCR_Ins_FK    Foreign Key (Ins_User ) References Cpy_User     (Id),
  CONSTRAINT  Fre_Job_DBCR_Upd_FK    Foreign Key (Upd_User ) References Cpy_User     (Id)
)
/
Create Synonym Fre_Job_DBCR For Fre_Job_DBCR_Documents
/
Alter Table Fre_Job_DBCR_Documents Add CONSTRAINT Fre_Job_DBCR_ORD_FK Foreign Key (Ord_Id ) References Cash_APOrd(Id);
Alter Table Fre_Job_DBCR_Documents Add CONSTRAINT Fre_Job_DBCR_INV_FK Foreign Key (IFin_Id) References Fin_TInv  (Id);
Alter Table Fre_Job_DBCR_Documents Add CONSTRAINT Fre_Job_DBCR_DBT_FK Foreign Key (DFin_Id) References Fin_TDbt  (Id);
Alter Table Fre_Job_DBCR_Documents Add CONSTRAINT Fre_Job_DBCR_CRD_FK Foreign Key (CFin_Id) References Fin_TCrd  (Id);
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Job_Item_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Job_Items                       -- بنود الشحنات
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
  CONSTRAINT Fre_Job_Item_PK       Primary Key (Id),
  CONSTRAINT Fre_Job_Item_FK       Foreign Key (Job_Id   ) References Fre_Job      (Id),
  CONSTRAINT Fre_Job_Item_Curn_FK  Foreign Key (Curn_Id  ) References Mng_Curn     (Id),
  CONSTRAINT Fre_Job_Item_nComd_FK Foreign Key (Comod_Id ) References Fre_Cod_Comod(Id),
  CONSTRAINT Fre_Job_Item_Unit_FK  Foreign Key (Unit_Id  ) References Cpy_Cod_Unit (Id),
  CONSTRAINT Fre_Job_Item_Ins_FK   Foreign Key (Ins_User ) References Cpy_User     (Id),
  CONSTRAINT Fre_Job_Item_Upd_FK   Foreign Key (Upd_User ) References Cpy_User     (Id)
)
/
Create Synonym Fre_Job_Item For Fre_Job_Items
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cntr_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Job_Containers                  -- ال Containers المرتبطة بملف عمل
( Id         Number(20) NOT NULL,                -- مفتاح رئيسي
  Job_Id     Number(10) NOT NULL,                -- مفتاح ملف العمل
  Num        Varchar2(30 Char),                  -- رقم الحاوية
  Type_Id    Number(10) Default 0,               -- النوع في حال FCL
  Val        Number(25,3) Default 0,             -- قيمة النوع من دليل الأنواع
  Qnt        Number(3) Default 1,                -- الكمية في حال FCL
  TEU        Number(25,3) Default 0,             -- TEU = FCL_Qnt * (FCL_Type Value)
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_Cntr_PK     Primary Key (Id ),
  CONSTRAINT Fre_Cntr_UK     Unique      (Job_Id, Num),
  CONSTRAINT Fre_Cntr_Job_FK Foreign Key (Job_Id  ) References Fre_JOB (Id),
  CONSTRAINT Fre_Cntr_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Fre_Cntr_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Fre_Cntr For Fre_Job_Containers
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_MDoc_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Job_MDocuments                  -- ال Doc's المرتبطة بملف عمل
( Id         Number(20) NOT NULL,                -- مفتاح رئيسي
  Job_Id     Number(10) NOT NULL,                -- مفتاح ملف العمل
  Num        Varchar2(30 Char),                  -- الرقم
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_MDoc_PK     Primary Key (Id),
  CONSTRAINT Fre_MDoc_UK     Unique      (Job_Id, Num),
  CONSTRAINT Fre_MDoc_Job_FK Foreign Key (Job_Id  ) References Fre_JOB (Id),
  CONSTRAINT Fre_MDoc_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Fre_MDoc_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Fre_MDoc For Fre_Job_MDocuments
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_HDoc_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Job_HDocuments                  -- ال Doc's المرتبطة بملف عمل
( Id         Number(20) NOT NULL,                -- مفتاح رئيسي
  Job_Id     Number(10) NOT NULL,                -- مفتاح ملف العمل
  Num        Varchar2(30 Char),                  -- الرقم
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_HDoc_PK     Primary Key (Id  ),
  CONSTRAINT Fre_HDoc_UK     Unique      (Job_Id, Num),
  CONSTRAINT Fre_HDoc_Job_FK Foreign Key (Job_Id  ) References Fre_JOB (Id),
  CONSTRAINT Fre_HDoc_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Fre_HDoc_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Fre_HDoc For Fre_Job_HDocuments
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Ship_Cons_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Job_Shippers_Consignees                    -- ال Shippers المرتبطة بملف عمل
( Id         Number(20) NOT NULL,                -- مفتاح رئيسي
  Job_Id     Number(10) NOT NULL,                -- مفتاح ملف العمل
  Ship_Name  Varchar2(100 Char),                 -- الشاحن
  Cons_Name  Varchar2(100 Char),                 -- المشحون له
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_Ship_Cons_PK     Primary Key (Id),
  CONSTRAINT Fre_Ship_Cons_UK     Unique      (Job_Id, Ship_Name, Cons_Name),
  CONSTRAINT Fre_Ship_Cons_Job_FK Foreign Key (Job_Id  ) References Fre_JOB (Id),
  CONSTRAINT Fre_Ship_Cons_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Fre_Ship_Cons_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Fre_Ship_Cons For Fre_Job_Shippers_Consignees
/
----------------------------------------------------------------------------------------------------
