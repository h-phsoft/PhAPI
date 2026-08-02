----------------------------------------------------------------------------------------------------
Create Sequence Fre_MInqry_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_MInqueries                                -- الطلبات
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
  CONSTRAINT Fre_MInqry_PK              Primary Key (Id   ),
  CONSTRAINT Fre_MInqry_UK              Unique      (Period_Id, Num),
  CONSTRAINT Fre_MInqry_Period_FK       Foreign Key (Period_Id   ) References Cpy_Period       (Id),
  CONSTRAINT Fre_MInqry_Dept_FK         Foreign Key (Dept_Id     ) References Cpy_Dept         (Id),
  CONSTRAINT Fre_MInqry_Unit_FK         Foreign Key (Unit_Id     ) References Cpy_Unit         (Id),
  CONSTRAINT Fre_MInqry_Oper_FK         Foreign Key (Oper_Id     ) References Cpy_Oper         (Id),
  CONSTRAINT Fre_MInqry_Cont_FK         Foreign Key (Cont_Id     ) References Mng_Cont         (Id),
  CONSTRAINT Fre_MInqry_User_FK         Foreign Key (User_Id     ) References Cpy_User         (Id),
  CONSTRAINT Fre_MInqry_Freight_FK      Foreign Key (Freight_Id  ) References Phs_Cod_YesNo    (Id),
  CONSTRAINT Fre_MInqry_Transport_FK    Foreign Key (Transport_Id) References Phs_Cod_YesNo    (Id),
  CONSTRAINT Fre_MInqry_Clearance_FK    Foreign Key (Clearance_Id) References Phs_Cod_YesNo    (Id),
  CONSTRAINT Fre_MInqry_ITerm_FK        Foreign Key (ITerm_Id    ) References Fre_Cod_Inco_Term(Id),
  CONSTRAINT Fre_MInqry_PTerm_FK        Foreign Key (PTerm_Id    ) References Fre_Cod_Pay_Term (Id),
  CONSTRAINT Fre_MInqry_Orig_FK         Foreign Key (OCntry_Id   ) References Fre_Cod_Cntry    (Id),
  CONSTRAINT Fre_MInqry_OCity_FK        Foreign Key (OCity_Id    ) References Fre_Cod_City     (Id),
  CONSTRAINT Fre_MInqry_OPort_FK        Foreign Key (OPort_Id    ) References Fre_Cod_City     (Id),
  CONSTRAINT Fre_MInqry_OSPort_FK       Foreign Key (OSPort_Id   ) References Fre_Cod_SeaPort  (Id),
  CONSTRAINT Fre_MInqry_OAPort_FK       Foreign Key (OAPort_Id   ) References Fre_Cod_AirPort  (Id),
  CONSTRAINT Fre_MInqry_Dest_FK         Foreign Key (DCntry_Id   ) References Fre_Cod_Cntry    (Id),
  CONSTRAINT Fre_MInqry_DCity_FK        Foreign Key (DCity_Id    ) References Fre_Cod_City     (Id),
  CONSTRAINT Fre_MInqry_DPort_FK        Foreign Key (DPort_Id    ) References Fre_Cod_City     (Id),
  CONSTRAINT Fre_MInqry_DSPort_FK       Foreign Key (DSPort_Id   ) References Fre_Cod_SeaPort  (Id),
  CONSTRAINT Fre_MInqry_DAPort_FK       Foreign Key (DAPort_Id   ) References Fre_Cod_AirPort  (Id),
  CONSTRAINT Fre_MInqry_Ins_FK          Foreign Key (Ins_User    ) References Cpy_User         (Id),
  CONSTRAINT Fre_MInqry_Upd_FK          Foreign Key (Upd_User    ) References Cpy_User         (Id)
)
/
Create Synonym Fre_MInqry For Fre_MInqueries
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_TInqry_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_TInqueries                                -- بنود الطلبات
( Id         Number(9),                                    -- مفتاح رئيسي
  Inqry_Id   Number(9),                                    -- مفتاح الأب
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
  CONSTRAINT Fre_TInqry_PK       Primary Key (Id  ),
  CONSTRAINT Fre_TInqry_FK       Foreign Key (Inqry_Id) References Fre_MInqry   (Id),
  CONSTRAINT Fre_TInqry_nComd_FK Foreign Key (Comod_Id) References Fre_Cod_Comod(Id),
  CONSTRAINT Fre_TInqry_Curn_FK  Foreign Key (Curn_Id ) References Mng_Curn     (Id),
  CONSTRAINT Fre_TInqry_Ins_FK   Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fre_TInqry_Upd_FK   Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fre_TInqry For Fre_TInqueries
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_PInqry_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_PInqueries                                -- خطط الطلبات
( Id          Number(9) NOT NULL,                          -- مفتاح رئيسي
  Inqry_Id    Number(9) NOT NULL,                          -- الطلب
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
  CONSTRAINT  Fre_PInqry_PK       Primary Key (Id  ) ,
  CONSTRAINT  Fre_PInqry_Inqry_FK Foreign Key (Inqry_Id ) References Fre_MInqry        (Id),
  CONSTRAINT  Fre_PInqry_Orig_FK  Foreign Key (OCntry_Id) References Fre_Cod_Cntry     (Id),
  CONSTRAINT  Fre_PInqry_Dest_FK  Foreign Key (DCntry_Id) References Fre_Cod_Cntry     (Id),
  CONSTRAINT  Fre_PInqry_OCity_FK Foreign Key (OCity_Id ) References Fre_Cod_City      (Id),
  CONSTRAINT  Fre_PInqry_DCity_FK Foreign Key (DCity_Id ) References Fre_Cod_City      (Id),
  CONSTRAINT  Fre_PInqry_Driv_FK  Foreign Key (Driv_Id  ) References Fre_Driv          (Id),
  CONSTRAINT  Fre_PInqry_Truk_FK  Foreign Key (Truk_Id  ) References Fre_Truk          (Id),
  CONSTRAINT  Fre_PInqry_Track_FK Foreign Key (TTYpe_Id ) References Fre_Cod_Truck_Type(Id),
  CONSTRAINT  Fre_PInqry_Pack_FK  Foreign Key (Pack_Id  ) References Fre_Cod_Pack      (Id),
  CONSTRAINT  Fre_PInqry_Comd_FK  Foreign Key (Comod_Id ) References Fre_Cod_Comod     (Id),
  CONSTRAINT  Fre_PInqry_Ins_FK   Foreign Key (Ins_User ) References Cpy_User          (Id),
  CONSTRAINT  Fre_PInqry_Upd_FK   Foreign Key (Upd_User ) References Cpy_User          (Id)
)
/
Create Synonym Fre_PInqry For Fre_PInqueries
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_IDBCR_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Inqry_DBCR                                -- خدمات عرض
( Id          Number(10) NOT NULL,                         -- مفتاح رئيسي
  Inqry_Id    Number(9) NOT NULL,                          -- مفتاح العرض
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
  CONSTRAINT  Fre_IDBCR_PK       PRIMARY KEY (Id),
  CONSTRAINT  Fre_IDBCR_Inqry_FK Foreign Key (Inqry_Id) References Fre_MInqry  (Id),
  CONSTRAINT  Fre_IDBCR_Cont_FK  Foreign Key (Cont_Id ) References Mng_Cont    (Id),
  CONSTRAINT  Fre_IDBCR_Serv_FK  Foreign Key (Serv_Id ) References Mng_Serv    (Id),
  CONSTRAINT  Fre_IDBCR_Curn_FK  Foreign Key (Curn_Id ) References Mng_Curn    (Id),
  CONSTRAINT  Fre_IDBCR_Item_FK  Foreign Key (Item_Id ) References Stor_Item   (Id),
  CONSTRAINT  Fre_IDBCR_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit(Id),
  CONSTRAINT  Fre_IDBCR_LOC_FK   Foreign Key (Loc_Id  ) References Fre_Cod_Loc (Id),
  CONSTRAINT  Fre_IDBCR_Ins_FK   Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT  Fre_IDBCR_Upd_FK   Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Fre_IDBCR For Fre_Inqry_DBCR
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_MOffer_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_MOffers                                   -- العروض
( Id            Number(9) NOT NULL,                        -- مفتاح رئيسي
  Period_Id     Number(4) Default 0,                       -- السنة
  Dept_Id       Number(5) Default 0,                       -- النشاط
  Unit_Id       Number(5) Default 0,                       -- القسم
  Oper_Id       Number(5) Default 0,                       -- العملية
  Contr_Id      Number(5),                                 -- العقد
  Inqry_Id      Number(9),                                 -- الطلب
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
  Offer         Varchar2(250 Char),                        -- Offer/Rate نص العرض
  Status_Id     Number(2) Default 0,                       -- الحالة
  StatusType_Id Number(5) Default 0,                       -- تفصيل الحالة
  StatusRem     Varchar2(250 Char),                        -- شرح الحالة
  Terms         Varchar2(250 Char),                        -- Terms and Conditions الشروط والأحكام
  Cust          Varchar2(250 Char),                        -- اسم الزبون في حال عدم وجوده ضمن قائمة المتعاملين
  CPerson       Varchar2(250 Char),                        -- Contact Person شخص الاتصال
  Rem           Varchar2(250 Char),                        -- ملاحظات
  Ins_User      Number(5), Ins_Date Date,
  Upd_User      Number(5), Upd_Date Date,
  CONSTRAINT    Fre_MOffer_PK              Primary Key (Id),
  CONSTRAINT    Fre_MOffer_UK              Unique      (Period_Id, Dept_Id, Num),
  CONSTRAINT    Fre_MOffer_WPer_FK         Foreign Key (Period_Id    ) References Cpy_Period          (Id),
  CONSTRAINT    Fre_MOffer_Dept_FK         Foreign Key (Dept_Id      ) References Cpy_Dept            (Id),
  CONSTRAINT    Fre_MOffer_Unit_FK         Foreign Key (Unit_Id      ) References Cpy_Unit            (Id),
  CONSTRAINT    Fre_MOffer_Oper_FK         Foreign Key (Oper_Id      ) References Cpy_Oper            (Id),
  CONSTRAINT    Fre_MOffer_Inqry_FK        Foreign Key (Inqry_Id     ) References Fre_MInqry          (Id),
  CONSTRAINT    Fre_MOffer_Cont_FK         Foreign Key (Cont_Id      ) References Mng_Cont            (Id),
  CONSTRAINT    Fre_MOffer_Status_FK       Foreign Key (Status_Id    ) References Fre_Cod_Approve     (Id),
  CONSTRAINT    Fre_MOffer_StatusType_FK   Foreign Key (StatusType_Id) References Fre_Cod_Status_Type (Id),
  CONSTRAINT    Fre_MOffer_ITerm_FK        Foreign Key (ITerm_Id     ) References Fre_Cod_Inco_Term   (Id),
  CONSTRAINT    Fre_MOffer_PTerm_FK        Foreign Key (PTerm_Id     ) References Fre_Cod_Pay_Term    (Id),
  CONSTRAINT    Fre_MOffer_OCntry_FK       Foreign Key (OCntry_Id    ) References Fre_Cod_Cntry       (Id),
  CONSTRAINT    Fre_MOffer_OCity_FK        Foreign Key (OCity_Id     ) References Fre_Cod_City        (Id),
  CONSTRAINT    Fre_MOffer_OPort_FK        Foreign Key (OPort_Id     ) References Fre_Cod_City        (Id),
  CONSTRAINT    Fre_MOffer_OSPort_FK       Foreign Key (OSPort_Id    ) References Fre_Cod_SeaPort     (Id),
  CONSTRAINT    Fre_MOffer_OAPort_FK       Foreign Key (OAPort_Id    ) References Fre_Cod_AirPort     (Id),
  CONSTRAINT    Fre_MOffer_DCntry_FK       Foreign Key (DCntry_Id    ) References Fre_Cod_Cntry       (Id),
  CONSTRAINT    Fre_MOffer_DCity_FK        Foreign Key (DCity_Id     ) References Fre_Cod_City        (Id),
  CONSTRAINT    Fre_MOffer_DPort_FK        Foreign Key (DPort_Id     ) References Fre_Cod_City        (Id),
  CONSTRAINT    Fre_MOffer_DSPort_FK       Foreign Key (DSPort_Id    ) References Fre_Cod_SeaPort     (Id),
  CONSTRAINT    Fre_MOffer_DAPort_FK       Foreign Key (DAPort_Id    ) References Fre_Cod_AirPort     (Id),
  CONSTRAINT    Fre_MOffer_Curn_FK         Foreign Key (Curn_Id      ) References Mng_Curn            (Id),
  CONSTRAINT    Fre_MOffer_Freight_FK      Foreign Key (Freight_Id   ) References Phs_Cod_YesNo       (Id),
  CONSTRAINT    Fre_MOffer_Transport_FK    Foreign Key (Transport_Id ) References Phs_Cod_YesNo       (Id),
  CONSTRAINT    Fre_MOffer_Clearance_FK    Foreign Key (Clearance_Id ) References Phs_Cod_YesNo       (Id),
  CONSTRAINT    Fre_MOffer_Ins_FK          Foreign Key (Ins_User     ) References Cpy_User            (Id),
  CONSTRAINT    Fre_MOffer_Upd_FK          Foreign Key (Upd_User     ) References Cpy_User            (Id)
)
/
Create Synonym Fre_MOffer For Fre_MOffers
/

--Alter Table Fre_MOffers Add CONSTRAINT Fre_MOfr_Contr_FK  Foreign Key (Contr_Id) References Fre_MCntrct(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Fre_TOffer_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_TOffers                         -- بنود العرض
( Id          Number(10),                        -- مفتاح رئيسي
  Ofer_Id     Number(9),                         -- مفتاح الأب
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
  CONSTRAINT  Fre_TOfr_PK       Primary Key (Id),
  CONSTRAINT  Fre_TOfr_FK       Foreign Key (Ofer_Id   ) References Fre_MOffer   (Id),
  CONSTRAINT  Fre_TOfr_nComd_FK Foreign Key (Comod_Id  ) References Fre_Cod_Comod(Id),
  CONSTRAINT  Fre_TOfr_Serv_FK  Foreign Key (Serv_Id   ) References Mng_Serv     (Id),
  CONSTRAINT  Fre_TOfr_Curn_FK  Foreign Key (Curn_Id   ) References Mng_Curn     (Id),
  CONSTRAINT  Fre_TOfr_Unit_FK  Foreign Key (Unit_Id   ) References Cpy_Cod_Unit (Id),
  CONSTRAINT  Fre_TOfr_Ins_FK   Foreign Key (Ins_User  ) References Cpy_User     (Id),
  CONSTRAINT  Fre_TOfr_Upd_FK   Foreign Key (Upd_User  ) References Cpy_User     (Id)
)
/
Create Synonym Fre_TOffer For Fre_TOffers
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_ODBCR_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Offer_DBCR                                -- خدمات عرض
( Id          Number(10) NOT NULL,                         -- مفتاح رئيسي
  Ofer_Id     Number(9) NOT NULL,                          -- مفتاح العرض
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
  CONSTRAINT  Fre_ODBCR_PK       PRIMARY KEY (Id),
  CONSTRAINT  Fre_ODBCR_Ofer_FK  Foreign Key (Ofer_Id ) References Fre_MOffer  (Id),
  CONSTRAINT  Fre_ODBCR_Cont_FK  Foreign Key (Cont_Id ) References Mng_Cont    (Id),
  CONSTRAINT  Fre_ODBCR_Serv_FK  Foreign Key (Serv_Id ) References Mng_Serv    (Id),
  CONSTRAINT  Fre_ODBCR_Curn_FK  Foreign Key (Curn_Id ) References Mng_Curn    (Id),
  CONSTRAINT  Fre_ODBCR_Item_FK  Foreign Key (Item_Id ) References Stor_Item   (Id),
  CONSTRAINT  Fre_ODBCR_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit(Id),
  CONSTRAINT  Fre_ODBCR_LOC_FK   Foreign Key (Loc_Id  ) References Fre_Cod_Loc (Id),
  CONSTRAINT  Fre_ODBCR_Ins_FK   Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT  Fre_ODBCR_Upd_FK   Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Fre_ODBCR For Fre_Offer_DBCR
/
----------------------------------------------------------------------------------------------------
