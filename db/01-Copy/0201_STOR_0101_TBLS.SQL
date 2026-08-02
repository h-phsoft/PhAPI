----------------------------------------------------------------------------------------------------
Create Sequence Stor_Item_Cat_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Item_Category                            -- جدول تصانيف المواد
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Vat        Number(6,2) Default 0,                        -- نسبة VAT
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Image      Varchar2(100 Char),                           -- الصورة
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Item_Cat_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Item_Cat_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Item_Cat_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Item_Cat_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Item_Cat For Stor_Item_Category
/
Insert into Stor_Item_Cat (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Item_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Items                                    -- دليل المواد
( Id         Number(10),                                   -- مفتاح رئيسي
  Num        Varchar2(15 Char) NOT NULL,                   -- رقم المادة
  Part       Varchar2(15 Char),                            -- الرقم لدى المورد
  LName      VarChar2(100 Char) NOT NULL,                  -- اسم المادة
  IName      VarChar2(100 Char) NOT NULL,                  -- اسم المادة
  Status_Id  Number(1) Default 1,                          -- الحالة
  Type_Id    Number(1) Default 1,                          -- النوع
  Method_Id  Number(1) Default 1,                          -- طريقة التعامل
  MCost_Id   Number(1) Default 1,                          -- طريقة التكليف
  Unit_Id    Number(5) Default 1,                          -- الوحدة
  Cat_Id     Number(5) Default 0,                          -- تصنيف المادة
  InSale_Id  Number(1) Default 2 NOT NULL,                 -- هل المادة مشمولة ضمن التنزيلات
  Season_Id  Number(1) Default 2 NOT NULL,                 -- هل المادة ضمن مواد فروع التخفيضات
  Spc1_Id    Number(5) Default 0,   	                     -- تصنيف 1
  Spc2_Id    Number(5) Default 0,                          -- تصنيف 2
  Spc3_Id    Number(5) Default 0,   	                     -- تصنيف 3
  Spc4_Id    Number(5) Default 0,   	                     -- تصنيف 4
  Spc5_Id    Number(5) Default 0,   	                     -- تصنيف 5
  Spc6_Id    Number(5) Default 0,   	                     -- تصنيف 6
  Spc7_Id    Number(5) Default 0,                          -- تصنيف 7
  Spc8_Id    Number(5) Default 0,   	                     -- تصنيف 8
  Spc9_Id    Number(5) Default 0,   	                     -- تصنيف 9
  Spc0_Id    Number(5) Default 0,   	                     -- تصنيف 0
  DWarnty    Number(4) Default 0 NOT NULL,                 -- أيام الضمان
  NofP       Number(4) Default 0 NOT NULL,                 -- عدد مرات التسعير
  Vat        Number(6,2) Default 0,                        -- نسبة VAT
  FQnt       Number(10,3) Default 1 NOT NULL,              -- كمية المعادلة
  Min_Unit   Number(10,3) Default 1 NOT NULL,              -- أصغر جزء
  Box        Number(10,3) Default 1 NOT NULL,              -- سعة الصندوق
  CPrice     Number(10,3) Default 0 NOT NULL,              -- Current Market سعر السوق الحالي المستهلك
  NPrice     Number(10,3) Default 0 NOT NULL,              -- Normal سغر المبيع
  DPrice     Number(10,3) Default 0 NOT NULL,              -- Discount سعر التخفيضات
  SPrice     Number(10,3) Default 0 NOT NULL,              -- Sale سعر المواسم
  WPrice     Number(10,3) Default 0 NOT NULL,              -- Wholesale سعر المبيع جملة
  RPrice     Number(10,3) Default 0 NOT NULL,              -- Retail سعر المبيع مفرق
  HPrice     Number(10,3) Default 0 NOT NULL,              -- HalfWhole سعر المبيع نصف الجملة
  MPrice     Number(10,3) Default 0 NOT NULL,              -- Media السعر في مواقع التواصل الاجتماعي كبار العملاء
  CBoxPrice  Number(10,3) Default 0 NOT NULL,              -- Current Market سعر السوق الحالي المستهلك للصندوق
  NBoxPrice  Number(10,3) Default 0 NOT NULL,              -- Normal سغر المبيع للصندوق
  DBoxPrice  Number(10,3) Default 0 NOT NULL,              -- Discount سعر التخفيضات للصندوق
  SBoxPrice  Number(10,3) Default 0 NOT NULL,              -- Sale سعر المواسم للصندوق
  WBoxPrice  Number(10,3) Default 0 NOT NULL,              -- Wholesale سعر المبيع جملة للصندوق
  RBoxPrice  Number(10,3) Default 0 NOT NULL,              -- Retail سعر المبيع مفرق للصندوق
  HBoxPrice  Number(10,3) Default 0 NOT NULL,              -- HalfWhole سعر المبيع نصف الجملة للصندوق
  MBoxPrice  Number(10,3) Default 0 NOT NULL,              -- Media السعر في مواقع التواصل الاجتماعي كبار العملاء للصندوق
  Image      VarChar2(100 Char),                           -- الصورة
  Descr      VarChar2(1024 Char),                          -- الوصف
  Rem        VarChar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Stor_Item_PK           PRIMARY KEY (Id       ),
  CONSTRAINT Stor_Item_Num_UK       Unique      (Num      ),
  CONSTRAINT Stor_Item_LName_UK     Unique      (LName    ),
  CONSTRAINT Stor_Item_IName_UK     Unique      (IName    ),
  CONSTRAINT Stor_Item_Unit_FK      Foreign Key (Unit_Id  ) References Cpy_Cod_Unit   (Id),
  CONSTRAINT Stor_Item_InSale_FK    Foreign Key (InSale_id) References Phs_Cod_YesNo  (Id),
  CONSTRAINT Stor_Item_Season_FK    Foreign Key (Season_Id) References Phs_Cod_YesNo  (Id),
  CONSTRAINT Stor_Item_Status_FK    Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Stor_Item_Type_FK      Foreign Key (Type_Id  ) References Stor_Cod_Type  (Id),
  CONSTRAINT Stor_Item_Method_FK    Foreign Key (Method_Id) References Stor_Cod_Method(Id),
  CONSTRAINT Stor_Item_MCost_FK     Foreign Key (MCost_Id ) References Stor_Cod_Cost  (Id),
  CONSTRAINT Stor_Item_Cat_FK       Foreign Key (Cat_Id   ) References Stor_Item_Cat  (Id),
  CONSTRAINT Stor_Item_Spc1_FK      Foreign Key (Spc1_Id  ) References Stor_Cod_Spec1 (Id),
  CONSTRAINT Stor_Item_Spc2_FK      Foreign Key (Spc2_Id  ) References Stor_Cod_Spec2 (Id),
  CONSTRAINT Stor_Item_Spc3_FK      Foreign Key (Spc3_Id  ) References Stor_Cod_Spec3 (Id),
  CONSTRAINT Stor_Item_Spc4_FK      Foreign Key (Spc4_Id  ) References Stor_Cod_Spec4 (Id),
  CONSTRAINT Stor_Item_Spc5_FK      Foreign Key (Spc5_Id  ) References Stor_Cod_Spec5 (Id),
  CONSTRAINT Stor_Item_Spc6_FK      Foreign Key (Spc6_Id  ) References Stor_Cod_Spec6 (Id),
  CONSTRAINT Stor_Item_Spc7_FK      Foreign Key (Spc7_Id  ) References Stor_Cod_Spec7 (Id),
  CONSTRAINT Stor_Item_Spc8_FK      Foreign Key (Spc8_Id  ) References Stor_Cod_Spec8 (Id),
  CONSTRAINT Stor_Item_Spc9_FK      Foreign Key (Spc9_Id  ) References Stor_Cod_Spec9 (Id),
  CONSTRAINT Stor_Item_Spc0_FK      Foreign Key (Spc0_Id  ) References Stor_Cod_Spec0 (Id),
  CONSTRAINT Stor_Item_Ins_FK       Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Stor_Item_Upd_FK       Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Stor_Item For Stor_Items
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Item_Class_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Item_Classes                             -- تصانيف المواد
( Id         Number(20),                                   -- مفتاح رئيسي    
  Item_Id    Number(9) NOT NULL,                           -- المادة
  Grp_Id     Number(5) NOT NULL,                           -- المجموعة
  Itm_Id     Number(7) NOT NULL,                           -- البند
  Rem        VarChar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Stor_Item_Class_PK       PRIMARY KEY (Id),
  CONSTRAINT Stor_Item_Class_UK       Unique      (Item_Id, Grp_Id, Itm_Id),
  CONSTRAINT Stor_Item_Class_Item_FK  Foreign Key (Item_Id ) References Stor_Item   (Id),
  CONSTRAINT Stor_Item_Class_Group_FK Foreign Key (Grp_Id  ) References Stor_Cod_Grp(Id),
  CONSTRAINT Stor_Item_Class_CItem_FK Foreign Key (Itm_Id  ) References Stor_Cod_Itm(Id),
  CONSTRAINT Stor_Item_Class_Ins_FK   Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Stor_Item_Class_Upd_FK   Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Stor_Item_Class For Stor_Item_Classes
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Itm_Form_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Item_Formula                             -- دليل تركيب المواد
( Id         Number(20),                                   -- مفتاح رئيسي
  Item_Id    Number(9) NOT NULL,                           -- المادة المركبة
  Item_RId   Number(9) NOT NULL,                           -- المادة الداخلة في التركيب
  Qnt        Number(10,3) Default 0 NOT NULL,              -- الكمية
  Rem        VarChar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Stor_Itm_Form_PK       PRIMARY KEY (Id),
  CONSTRAINT Stor_Itm_Form_Num_UK   Unique      (Item_Id, Item_RId),
  CONSTRAINT Stor_Itm_Form_Item_FK  Foreign Key (Item_Id ) References Stor_Item(Id),
  CONSTRAINT Stor_Itm_Form_RItem_FK Foreign Key (Item_RId) References Stor_Item(Id),
  CONSTRAINT Stor_Itm_Form_Ins_FK   Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Stor_Itm_Form_Upd_FK   Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Stor_Itm_Form For Stor_Item_Formula
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Item_Spec_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Item_Specification                       -- مواصفات المواد
( Id         Number(20),                                   -- مفتاح رئيسي    
  Item_Id    Number(9) NOT NULL,                           -- المادة
  vTitle     Varchar2(100) NOT NULL,                       -- العنوان
  vValue     Varchar2(1024) NOT NULL,                      -- القيمة
  Rem        VarChar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Stor_Item_Spec_PK       PRIMARY KEY (Id),
  CONSTRAINT Stor_Item_Spec_UK       Unique      (Item_Id, vTitle),
  CONSTRAINT Stor_Item_Spec_Item_FK  Foreign Key (Item_Id ) References Stor_Item   (Id),
  CONSTRAINT Stor_Item_Spec_Ins_FK   Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Stor_Item_Spec_Upd_FK   Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Stor_Item_Spec For Stor_Item_Specification
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Store_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Stores                                   -- دليل المخازن
( Id          Number(5),                                   -- مفتاح رئيسي
  LName       Varchar2(100 Char),                          -- اسم المخزن
  IName       Varchar2(100 Char),                          -- اسم المخزن
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Status_Id   Number(1) Default 1,                         -- الحالة
  Cost_Id     Number(9) NOT NULL,                          -- مركز الكلفة
  Acc_Id      Number(9) NOT NULL,                          -- حساب المخزن
  CstAcc_Id   NUMBER(9) DEFAULT 0,                         -- حساب التكلفة
  RevAcc_Id   NUMBER(9) DEFAULT 0,                         -- حساب الإيراد
  PVatAcc_Id  NUMBER(9) DEFAULT 0,                         -- حساب VAT المشتريات
  SVatAcc_Id  NUMBER(9) DEFAULT 0,                         -- حساب VAT المبيعات
  Emp_Id      Number(9) Default 0,                         -- أمين المستودع
  Type_Id     Number(1) Default 2,                         -- نوع المخزن
  Own_Id      Number(1) Default 1,                         -- حالة الملكية 1 ملك الشركة \ 2 إيجار
  Sale_Id     Number(1) Default 2,                         -- هل المستودع مستودع مبيعات أم لا
  SDate       Date,                                        -- تاريخ بداية الوضع بالخدمة أو الإيجار
  EDate       Date,                                        -- تاريخ نهاية الإيجار
  Descr       Varchar2(512 Char),                          -- توصيف المخزن
  Address     Varchar2(512 Char),                          -- عنوان المخزن
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Stor_Store_PK         PRIMARY KEY (Id),
  CONSTRAINT  Stor_Store_LName_UK   Unique      (LName     ),
  CONSTRAINT  Stor_Store_IName_UK   Unique      (IName     ),
  CONSTRAINT  Stor_Store_Cost_FK    Foreign Key (Cost_Id   ) References Acc_Cost      (Id),
  CONSTRAINT  Stor_Store_Acc_FK     Foreign Key (Acc_Id    ) References Acc_Acc       (Id),
  CONSTRAINT  Stor_Store_CstAcc_FK  FOREIGN KEY (CstAcc_Id ) REFERENCES Acc_Acc       (Id),
  CONSTRAINT  Stor_Store_RevAcc_FK  FOREIGN KEY (RevAcc_Id ) REFERENCES Acc_Acc       (Id),
  CONSTRAINT  Stor_Store_PVatAcc_FK FOREIGN KEY (PVatAcc_Id) REFERENCES Acc_Acc       (Id),
  CONSTRAINT  Stor_Store_SVatAcc_FK FOREIGN KEY (SVatAcc_Id) REFERENCES Acc_Acc       (Id),
  CONSTRAINT  Stor_Store_Status_FK  Foreign Key (Status_Id ) References Phs_Cod_Status(Id),
  CONSTRAINT  Stor_Store_Type_FK    Foreign Key (Type_Id   ) References Phs_Cod_Type  (Id),
  CONSTRAINT  Stor_Store_Own_FK     Foreign Key (Own_Id    ) References Stor_Cod_Own  (Id),
  CONSTRAINT  Stor_Store_Sale_FK    Foreign Key (Sale_Id   ) References Phs_Cod_YesNo (Id),
  CONSTRAINT  Stor_Store_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User      (Id),
  CONSTRAINT  Stor_Store_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User      (Id)
)
/
Create Synonym Stor_Store For Stor_Stores
/
--  CONSTRAINT  Stor_Store_Emp_Id_FK    Foreign Key (Emp_Id   ) References Emp_Emp       (Id),
----------------------------------------------------------------------------------------------------
Create Sequence Stor_SMat_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Stores_Materiales                        -- دليل مواد مخزن
( Id           Number(9),                                  -- مفتاح رئيسي
  Stor_Id      Number(5) NOT NULL,                         -- المخزن
  Item_Id      Number(9) NOT NULL,                         -- المادة
  Status_Id    Number(1) Default 1,                        -- الحالة
  Loc1_Id      Number(5) Default 0,                        -- مكان تخزين 1
  Loc2_Id      Number(5) DEfault 0,                        -- مكان تخزين 2
  Loc3_Id      Number(5) Default 0,                        -- مكان تخزين 3
  Vat          Number(6,2) Default 0,                      -- نسبة VAT
  CQnt         Number(25,3) Default 0,                     -- كمية حالية
  BQnt         Number(25,3) Default 0,                     -- كمية محجوزة
  CWQnt        Number(25,3) Default 0,                     -- الوزن الحالي
  CAmt         Number(25,3) Default 0,                     -- قيمة كمية حالية
  CBAmt        Number(25,3) Default 0,                     -- قيمة كمية حالية حسب عملة الأساس
  Req_Limit    Number(25,3) Default 0,                     -- حد الطلب السنوي
  Min_Limit    Number(25,3) Default 0,                     -- الحد الأدنى السنوي
  Max_Limit    Number(25,3) Default 0,                     -- الحد الأعلى السنوي
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT   Stor_SMat_PK         PRIMARY KEY (Id),
  CONSTRAINT   Stor_SMat_UK         Unique      (Stor_Id, Item_Id),
  CONSTRAINT   Stor_SMat_Stor_FK    Foreign Key (Stor_Id  ) References Stor_Store    (Id),
  CONSTRAINT   Stor_SMat_Item_FK    Foreign Key (Item_Id  ) References Stor_Item     (Id),
  CONSTRAINT   Stor_SMat_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT   Stor_SMat_Loc1_FK    Foreign Key (Loc1_Id  ) References Stor_Cod_Loc1 (Id),
  CONSTRAINT   Stor_SMat_Loc2_FK    Foreign Key (Loc2_Id  ) References Stor_Cod_Loc2 (Id),
  CONSTRAINT   Stor_SMat_Loc3_FK    Foreign Key (Loc3_Id  ) References Stor_Cod_Loc3 (Id),
  CONSTRAINT   Stor_SMat_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT   Stor_SMat_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Stor_SMat For Stor_Stores_Materiales
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Acc_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Accounts                                 -- الحسابات الافتراضية
( Id          Number(9),                                   -- مفتاح رئيسي
  TrnTyp_Id   Number(3) NOT NULL,                          -- نوع الحركة
  CstAcc_Id   Number(9) NOT NULL,                          -- حساب الكلفة
  RevAcc_Id   Number(9) NOT NULL,                          -- حساب الإيراد
  ComAcc_Id   Number(9) NOT NULL,                          -- حساب العمولة
  DisAcc_Id   Number(9) NOT NULL,                          -- حساب الحسم
  PVatAcc_Id  NUMBER(9) DEFAULT 0,                         -- حساب VAT المشتريات
  SVatAcc_Id  NUMBER(9) DEFAULT 0,                         -- حساب VAT المبيعات
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Stor_Acc_PK         PRIMARY KEY (Id  ),
  CONSTRAINT  Stor_Acc_UK         Unique      (TrnTyp_Id ),
  CONSTRAINT  Stor_Acc_TrnTyp_FK  Foreign Key (TrnTyp_Id ) References Stor_Cod_TrnTyp(Id),
  CONSTRAINT  Stor_Acc_CstAcc_FK  Foreign Key (CstAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Acc_RevAcc_FK  Foreign Key (RevAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Acc_ComAcc_FK  Foreign Key (ComAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Acc_DisAcc_FK  Foreign Key (DisAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Acc_PVatAcc_FK FOREIGN KEY (PVatAcc_Id) REFERENCES Acc_Acc        (Id),
  CONSTRAINT  Stor_Acc_SVatAcc_FK FOREIGN KEY (SVatAcc_Id) REFERENCES Acc_Acc        (Id),
  CONSTRAINT  Stor_Acc_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT  Stor_Acc_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Stor_Acc For Stor_Accounts
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Str_Acc_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Store_Accounts                           -- حسابات مستودع
( Id          Number(9),                                   -- مفتاح رئيسي
  Stor_Id     Number(5) NOT NULL,                          -- المخزن
  TrnTyp_Id   Number(3) NOT NULL,                          -- نوع الحركة
  CstAcc_Id   Number(9) NOT NULL,                          -- حساب الكلفة
  RevAcc_Id   Number(9) NOT NULL,                          -- حساب الإيراد
  ComAcc_Id   Number(9) NOT NULL,                          -- حساب العمولة
  DisAcc_Id   Number(9) NOT NULL,                          -- حساب الحسم
  PVatAcc_Id  NUMBER(9) DEFAULT 0,                         -- حساب VAT المشتريات
  SVatAcc_Id  NUMBER(9) DEFAULT 0,                         -- حساب VAT المبيعات
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Stor_Str_Acc_PK         PRIMARY KEY (Id  ),
  CONSTRAINT  Stor_Str_Acc_UK         Unique      (Stor_Id, TrnTyp_Id),
  CONSTRAINT  Stor_Str_Acc_Stor_FK    Foreign Key (Stor_Id   ) References Stor_Store     (Id),
  CONSTRAINT  Stor_Str_Acc_TrnTyp_FK  Foreign Key (TrnTyp_Id ) References Stor_Cod_TrnTyp(Id),
  CONSTRAINT  Stor_Str_Acc_CstAcc_FK  Foreign Key (CstAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Str_Acc_RevAcc_FK  Foreign Key (RevAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Str_Acc_ComAcc_FK  Foreign Key (ComAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Str_Acc_DisAcc_FK  Foreign Key (DisAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Str_Acc_PVatAcc_FK FOREIGN KEY (PVatAcc_Id) REFERENCES Acc_Acc        (Id),
  CONSTRAINT  Stor_Str_Acc_SVatAcc_FK FOREIGN KEY (SVatAcc_Id) REFERENCES Acc_Acc        (Id),
  CONSTRAINT  Stor_Str_Acc_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT  Stor_Str_Acc_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Stor_Str_Acc For Stor_Store_Accounts
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cat_Acc_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Categories_Accounts                      -- حسابات التصانيف
( Id          Number(9),                                   -- مفتاح رئيسي
  Cat_Id      Number(5) Default 0,                         -- تصنيف 1
  TrnTyp_Id   Number(3) NOT NULL,                          -- نوع الحركة
  CstAcc_Id   Number(9) NOT NULL,                          -- حساب الكلفة
  RevAcc_Id   Number(9) NOT NULL,                          -- حساب الإيراد
  ComAcc_Id   Number(9) NOT NULL,                          -- حساب العمولة
  DisAcc_Id   Number(9) NOT NULL,                          -- حساب الحسم
  PVatAcc_Id  NUMBER(9) DEFAULT 0,                         -- حساب VAT المشتريات
  SVatAcc_Id  NUMBER(9) DEFAULT 0,                         -- حساب VAT المبيعات
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Stor_Cat_Acc_PK         PRIMARY KEY (Id),
  CONSTRAINT  Stor_Cat_Acc_UK         Unique      (Cat_Id, TrnTyp_Id),
  CONSTRAINT  Stor_Cat_Acc_Cat_FK     Foreign Key (Cat_Id    ) References Stor_Item_Cat  (Id),
  CONSTRAINT  Stor_Cat_Acc_TrnTyp_FK  Foreign Key (TrnTyp_Id ) References Stor_Cod_TrnTyp(Id),
  CONSTRAINT  Stor_Cat_Acc_CstAcc_FK  Foreign Key (CstAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Cat_Acc_RevAcc_FK  Foreign Key (RevAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Cat_Acc_ComAcc_FK  Foreign Key (ComAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Cat_Acc_DisAcc_FK  Foreign Key (DisAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_Cat_Acc_PVatAcc_FK FOREIGN KEY (PVatAcc_Id) REFERENCES Acc_Acc        (Id),
  CONSTRAINT  Stor_Cat_Acc_SVatAcc_FK FOREIGN KEY (SVatAcc_Id) REFERENCES Acc_Acc        (Id),
  CONSTRAINT  Stor_Cat_Acc_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT  Stor_Cat_Acc_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Stor_Cat_Acc For Stor_Categories_Accounts
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_SMat_Acc_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Stores_Materiales_Accounts               -- حسابات مادة في مخزن
( Id          Number(9),                                   -- مفتاح رئيسي
  Stor_Id     Number(5) NOT NULL,                          -- المخزن
  Item_Id     Number(5) NOT NULL,                          -- المخزن
  TrnTyp_Id   Number(3) NOT NULL,                          -- نوع الحركة
  CstAcc_Id   Number(9) NOT NULL,                          -- حساب الكلفة
  RevAcc_Id   Number(9) NOT NULL,                          -- حساب الإيراد
  ComAcc_Id   Number(9) NOT NULL,                          -- حساب العمولة
  DisAcc_Id   Number(9) NOT NULL,                          -- حساب الحسم
  PVatAcc_Id  NUMBER(9) DEFAULT 0,                         -- حساب VAT المشتريات
  SVatAcc_Id  NUMBER(9) DEFAULT 0,                         -- حساب VAT المبيعات
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Stor_SMat_Acc_PK         PRIMARY KEY (Id  ),
  CONSTRAINT  Stor_SMat_Acc_UK         Unique      (Stor_Id, Item_Id, TrnTyp_Id),
  CONSTRAINT  Stor_SMat_Acc_Stor_FK    Foreign Key (Stor_Id   ) References Stor_Store     (Id),
  CONSTRAINT  Stor_SMat_Acc_Item_FK    Foreign Key (Item_Id   ) References Stor_Item      (Id),
  CONSTRAINT  Stor_SMat_Acc_TrnTyp_FK  Foreign Key (TrnTyp_Id ) References Stor_Cod_TrnTyp(Id),
  CONSTRAINT  Stor_SMat_Acc_CstAcc_FK  Foreign Key (CstAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_SMat_Acc_RevAcc_FK  Foreign Key (RevAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_SMat_Acc_ComAcc_FK  Foreign Key (ComAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_SMat_Acc_DisAcc_FK  Foreign Key (DisAcc_Id ) References Acc_Acc        (Id),
  CONSTRAINT  Stor_SMat_Acc_PVatAcc_FK FOREIGN KEY (PVatAcc_Id) REFERENCES Acc_Acc        (Id),
  CONSTRAINT  Stor_SMat_Acc_SVatAcc_FK FOREIGN KEY (SVatAcc_Id) REFERENCES Acc_Acc        (Id),
  CONSTRAINT  Stor_SMat_Acc_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT  Stor_SMat_Acc_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Stor_SMat_Acc For Stor_Stores_Materiales_Accounts
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_ICS_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Item_Classification                      -- دليل الباركود - تصنيف المواد
( Id          Number(30),                                  -- مفتاح رئيسي
  Item_Id     Number(9) NOT NULL,                          -- مفتاح المادة
  Unit_Id     Number(5) Default 0,                         -- الوحدة
  Model_Id    Number(5) Default 0,                         -- الموديل
  Color_Id    Number(5) Default 0,                         -- اللون 
  Size_Id     Number(5) Default 0,                         -- القياس 
  nLength     Number(25,2) Default 0,                      -- الطول
  nWidth      Number(25,2) Default 0,                      -- العرض
  nHeight     Number(25,2) Default 0,                      -- الارتفاع
  Qnt         Number(25,3) Default 0,                      -- الكمية
  BQnt        Number(25,3) Default 0,                      -- كمية محجوزة
  CQnt        Number(25,3) Default 0,                      -- الكمية الحالية
  CCst        Number(25,3) Default 0,                      -- الكلفة الحالية
  CBCst       Number(25,3) Default 0,                      -- الكلفة الحالية بعملة الأساس
  WQnt        Number(25,3) Default 0,                      -- الوزن
  BWQnt       Number(25,3) Default 0,                      -- الوزن المحجوز
  CWQnt       Number(25,3) Default 0,                      -- الوزن الحالي
  CPrice      Number(25,2) Default 0 NOT NULL,             -- Current Market سعر السوق الحالي
  NPrice      Number(25,2) Default 0 NOT NULL,             -- Normal سغر المبيع
  DPrice      Number(25,2) Default 0 NOT NULL,             -- Discount سعر التخفيضات
  SPrice      Number(25,2) Default 0 NOT NULL,             -- Sale سعر المواسم
  WPrice      Number(25,2) Default 0 NOT NULL,             -- Wholesale سعر المبيع جملة
  RPrice      Number(25,2) Default 0 NOT NULL,             -- Retail سعر المبيع مفرق
  HPrice      Number(25,2) Default 0 NOT NULL,             -- HalfWhole سعر المبيع نصف الجملة
  MPrice      Number(25,2) Default 0 NOT NULL,             -- Media السعر في مواقع التواصل الاجتماعي
  Barcode     Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer      Varchar2(50 Char) Default '_',               -- طبخة/مسلسل
  SDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ بداية
  EDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ نهاية
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Stor_ICS_PK       PRIMARY KEY (Id),
  CONSTRAINT  Stor_ICS_UK       UNIQUE      (Barcode),
  CONSTRAINT  Stor_ICS_ICS_UK   UNIQUE      (Item_Id, LotSer, Unit_Id, Model_Id, Size_Id, Color_Id, nLength, nWidth, nHeight),
  CONSTRAINT  Stor_ICS_Item_FK  Foreign Key (Item_Id  ) References Stor_Item     (Id),
  CONSTRAINT  Stor_ICS_Unit_FK  Foreign Key (Unit_Id  ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT  Stor_ICS_Model_FK Foreign Key (Model_Id ) References Stor_Cod_Model(Id),
  CONSTRAINT  Stor_ICS_Color_FK Foreign Key (Color_Id ) References Stor_Cod_Color(Id),
  CONSTRAINT  Stor_ICS_Size_FK  Foreign Key (Size_Id  ) References Stor_Cod_Size (Id),
  CONSTRAINT  Stor_ICS_Ins_FK   Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Stor_ICS_Upd_FK   Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Stor_ICS For Stor_Item_Classification
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_SICS_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Stor_Item_Classification                 -- دليل تصنيف مواد مستودع
( Id          Number(30),                                  -- مفتاح رئيسي
  Stor_Id     Number(5) NOT NULL,                          -- مفتاح المستودع
  Item_Id     Number(9) NOT NULL,                          -- مفتاح المادة
  ICS_Id      Number(30) NOT NULL,                         -- مفتاح الباركود 
  Loc1_Id     Number(5) Default 0,                         -- الموقع 1
  Loc2_Id     Number(5) Default 0,                         -- الموقع 2
  Loc3_Id     Number(5) Default 0,                         -- الموقع 3
  Qnt         Number(25,3) Default 0,                      -- الكمية
  BQnt        Number(25,3) Default 0,                      -- كمية محجوزة
  CQnt        Number(25,3) Default 0,                      -- الكمية الحالية
  CCst        Number(25,3) Default 0,                      -- الكلفة الحالية
  CBCst       Number(25,3) Default 0,                      -- الكلفة الحالية بعملة الأساس
  WQnt        Number(25,3) Default 0,                      -- الوزن
  BWQnt       Number(25,3) Default 0,                      -- الوزن المحجوز
  CWQnt       Number(25,3) Default 0,                      -- الوزن الحالي
  CPrice      Number(25,2) Default 0 NOT NULL,             -- Current Market سعر السوق الحالي
  NPrice      Number(25,2) Default 0 NOT NULL,             -- Normal سغر المبيع
  DPrice      Number(25,2) Default 0 NOT NULL,             -- Discount سعر التخفيضات
  SPrice      Number(25,2) Default 0 NOT NULL,             -- Sale سعر المواسم
  WPrice      Number(25,2) Default 0 NOT NULL,             -- Wholesale سعر المبيع جملة
  RPrice      Number(25,2) Default 0 NOT NULL,             -- Retail سعر المبيع مفرق
  HPrice      Number(25,2) Default 0 NOT NULL,             -- HalfWhole سعر المبيع نصف الجملة
  MPrice      Number(25,2) Default 0 NOT NULL,             -- Media السعر في مواقع التواصل الاجتماعي
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Stor_SICS_PK       PRIMARY KEY (Id  ),
  CONSTRAINT  Stor_SICS_SICS_UK  UNIQUE      (Stor_Id, Item_Id, ICS_Id),
  CONSTRAINT  Stor_SICS_Stor_FK  Foreign Key (Stor_Id ) References Stor_Store   (Id),
  CONSTRAINT  Stor_SICS_Item_FK  Foreign Key (Item_Id ) References Stor_Item    (Id),
  CONSTRAINT  Stor_SICS_ICS_FK   Foreign Key (ICS_Id  ) References Stor_ICS     (Id),
  CONSTRAINT  Stor_SICS_Loc1_FK  Foreign Key (Loc1_Id ) References Stor_Cod_Loc1(Id),
  CONSTRAINT  Stor_SICS_Loc2_FK  Foreign Key (Loc2_Id ) References Stor_Cod_Loc2(Id),
  CONSTRAINT  Stor_SICS_Loc3_FK  Foreign Key (Loc3_Id ) References Stor_Cod_Loc3(Id),
  CONSTRAINT  Stor_SICS_Ins_FK   Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT  Stor_SICS_Upd_FK   Foreign Key (Upd_User) References Cpy_User     (Id)
) 
/
Create Synonym Stor_SICS For Stor_Stor_Item_Classification
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_ActMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Actual_Master                            -- ترويسة الجرد الفعلي
( Id          Number(10) NOT NULL,                         -- مفتاح رئيسي
  Period_Id   Number(4) NOT NULL,                          -- فترة العمل
  Stor_Id     Number(5) NOT NULL,                          -- المخزن
  Doc_Id      Number(5) Default 0 NOT NULL,                -- نوع المستند
  Num         Number(9) NOT NULL,                          -- رقم الوثيقة
  dDate       Date,                                        -- التاريخ
  DocN        Varchar2(15),                                -- رقم المستند
  DocD        Date,                                        -- تاريخ المستند
  Responsible varchar(250),                                -- المسؤول
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Stor_ActMst_PK        PRIMARY KEY (Id),
  CONSTRAINT  Stor_ActMst_UK        Unique      (Period_Id, Stor_Id, Num),
  CONSTRAINT  Stor_ActMst_Period_FK Foreign Key (Period_Id) References Cpy_Period (Id),
  CONSTRAINT  Stor_ActMst_Stor_FK   Foreign Key (Stor_Id  ) References Stor_Store (Id),
  CONSTRAINT  Stor_ActMst_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc(Id),
  CONSTRAINT  Stor_ActMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT  Stor_ActMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Stor_ActMst For Stor_Actual_Master
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_ActTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Actual_Trans                             -- بنود الجرد الفعلي
( Id          Number(20) NOT NULL,                         -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                         -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                          -- المادة
  Unit_Id     Number(5) Default 0,                         -- الوحدة
  Model_Id    Number(5) Default 0,                         -- الموديل
  Color_Id    Number(5) Default 0,                         -- اللون 
  Size_Id     Number(5) Default 0,                         -- القياس 
  Ord         Number(5) Default 0,                         -- مسلسل
  Qnt         Number(25,3) Default 0,                      -- الكمية
  SQnt        Number(25,3) Default 0,                      -- الكمية بوحدة التخزين
  WQnt        Number(25,3) Default 0,                      -- الوزن
  SWQnt       Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  nLength     Number(25,2) Default 0,                      -- الطول
  nWidth      Number(25,2) Default 0,                      -- العرض
  nHeight     Number(25,2) Default 0,                      -- الارتفاع
  Barcode     Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer      Varchar2(50 Char) Default '_',               -- طبخة/مسلسل
  SDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ بداية
  EDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ نهاية
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Stor_ActTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Stor_ActTrn_Mst_FK    Foreign Key (Mst_Id  ) References Stor_ActMst   (Id),
  CONSTRAINT  Stor_ActTrn_Item_FK   Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT  Stor_ActTrn_Unit_FK   Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT  Stor_ActTrn_Model_FK  Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT  Stor_ActTrn_Color_FK  Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT  Stor_ActTrn_Size_FK   Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT  Stor_ActTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT  Stor_ActTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Stor_ActTrn For Stor_Actual_Trans
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_InOrdMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Inbound_Order_Master                     -- ترويسة أوامر الادخال
( Id         Number(10),                                   -- مفتاح رئيسي
  Src_Id     Number(5) Default 0 NOT NULL,                 -- أصل الأمر
  TrnTyp_Id  Number(3) NOT NULL,                           -- نوع الحركة
  Status_Id  Number(1) Default 0 NOT NULL,                 -- الحالة
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Cont_Id    Number(9) NOT NULL,                           -- المتعامل
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Curn_Id    Number(5) Default 1,                          -- العملة
  Curn_Rate  Number(25,8) Default 1,                       -- سعر الصرف
  BCurn_Id   Number(5) Default 1,                          -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                       -- سعر الصرف
  Rel_Id     Number(10),                                   -- مفتاح مرتبط هو مفتاح الوثيقة التي شكلت الأمر مثل أمر تصنيع إدخال منتج أو مشتريات أو مردود مبيعات
  Fin_Id     Number(10),                                   -- مفتاح الورقة المالية
  Num        Number(9) NOT NULL,                           -- رقم الوثيقة
  dDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(15),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Stor_InOrdMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Stor_InOrdMst_UK        Unique      (Period_Id, Stor_Id, TrnTyp_Id, Num),
  CONSTRAINT Stor_InOrdMst_Source_FK Foreign Key (Src_Id   ) References Phs_Cod_Src        (Id),
  CONSTRAINT Stor_InOrdMst_Period_FK Foreign Key (Period_Id) References Cpy_Period         (Id),
  CONSTRAINT Stor_InOrdMst_Stor_FK   Foreign Key (Stor_Id  ) References Stor_Store         (Id),
  CONSTRAINT Stor_InOrdMst_Status_FK Foreign Key (Status_Id) References Stor_Cod_Ord_Status(Id),
  CONSTRAINT Stor_InOrdMst_TrnTyp_FK Foreign Key (TrnTyp_Id) References Stor_Cod_TrnTyp    (Id),
  CONSTRAINT Stor_InOrdMst_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont           (Id),
  CONSTRAINT Stor_InOrdMst_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn           (Id),
  CONSTRAINT Stor_InOrdMst_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn           (Id),
  CONSTRAINT Stor_InOrdMst_Doc_FK    Foreign Key (Doc_Id   ) References Stor_Cod_Doc       (Id),
  CONSTRAINT Stor_InOrdMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT Stor_InOrdMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Stor_InOrdMst For Stor_Inbound_Order_Master
/
Alter Table Stor_Inbound_Order_Master Add CONSTRAINT Stor_InOrdMst_Fin_FK Foreign Key (Fin_Id) References Fin_MCrd(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Stor_InOrdTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Inbound_Order_Trans                      -- بنود أوامر الادخال
( Id          Number(20),                                  -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                         -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                          -- المادة
  Rel_Id      Number(20),                                  -- مفتاح مرتبط
  Unit_Id     Number(5) Default 0,                         -- الوحدة
  Model_Id    Number(5) Default 0,                         -- الموديل
  Color_Id    Number(5) Default 0,                         -- اللون 
  Size_Id     Number(5) Default 0,                         -- القياس 
  Ord         Number(5) Default 0,                         -- مسلسل
  Qnt         Number(25,3) Default 0,                      -- الكمية
  CQnt        Number(25,3) Default 0,                      -- الكمية الحالية
  SQnt        Number(25,3) Default 0,                      -- الكمية بوحدة التخزين
  WQnt        Number(25,3) Default 0,                      -- الوزن
  CWQnt       Number(25,3) Default 0,                      -- الوزن الحالي
  SWQnt       Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price       Number(25,2) Default 0,                      -- افرادي
  CAmt        Number(25,2) Default 0,                      -- القيمة قطع
  Amt         Number(25,2) Default 0,                      -- القيمة
  Cst         Number(25,2) Default 0,                      -- الكلفة
  BAmt        Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  BCst        Number(25,2) Default 0,                      -- الكلفة بعملة الأساس
  Vat_Perc    Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value   Number(25,2) Default 0,                      -- فيمة الVAT
  nLength     Number(25,2) Default 0,                      -- الطول
  nWidth      Number(25,2) Default 0,                      -- العرض
  nHeight     Number(25,2) Default 0,                      -- الارتفاع
  Barcode     Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer      Varchar2(50 Char) Default '_',               -- طبخة/مسلسل
  SDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ بداية
  EDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ نهاية
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Stor_InOrdTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Stor_InOrdTrn_Mst_FK    Foreign Key (Mst_Id  ) References Stor_InOrdMst (Id),
  CONSTRAINT  Stor_InOrdTrn_Item_FK   Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT  Stor_InOrdTrn_Unit_FK   Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT  Stor_InOrdTrn_Model_FK  Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT  Stor_InOrdTrn_Color_FK  Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT  Stor_InOrdTrn_Size_FK   Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT  Stor_InOrdTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT  Stor_InOrdTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Stor_InOrdTrn For Stor_Inbound_Order_Trans
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_OuOrdMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Outbound_Order_Master                    -- ترويسة أوامر الاخراج
( Id         Number(10) NOT NULL,                          -- مفتاح رئيسي
  Src_Id     Number(5) Default 0 NOT NULL,                 -- أصل الأمر
  TrnTyp_Id  Number(3) NOT NULL,                           -- نوع الحركة
  Status_Id  Number(1) Default 0 NOT NULL,                 -- الحالة
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Cont_Id    Number(9) NOT NULL,                           -- المتعامل
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Curn_Id    Number(5) Default 1,                          -- العملة
  Curn_Rate  Number(25,8) Default 1,                       -- سعر الصرف
  BCurn_Id   Number(5) Default 1,                          -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                       -- سعر الصرف
  Rel_Id     Number(10),                                   -- مفتاح مرتبط هو مفتاح الوثيقة التي شكلت الأمر مثل أمر تصنيع مردود منتج أو مردود مشتريات أو مبيعات
  Fin_Id     Number(10),                                   -- مفتاح الورقة المالية
  Num        Number(9) NOT NULL,                           -- رقم الوثيقة
  dDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(15),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Stor_OuOrdMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Stor_OuOrdMst_UK        Unique      (Period_Id, Stor_Id, TrnTyp_Id, Num),
  CONSTRAINT Stor_OuOrdMst_Source_FK Foreign Key (Src_Id   ) References Phs_Cod_Src        (Id),
  CONSTRAINT Stor_OuOrdMst_Period_FK Foreign Key (Period_Id) References Cpy_Period         (Id),
  CONSTRAINT Stor_OuOrdMst_Stor_FK   Foreign Key (Stor_Id  ) References Stor_Store         (Id),
  CONSTRAINT Stor_OuOrdMst_TrnTyp_FK Foreign Key (TrnTyp_Id) References Stor_Cod_TrnTyp    (Id),
  CONSTRAINT Stor_OuOrdMst_Status_FK Foreign Key (Status_Id) References Stor_Cod_Ord_Status(Id),
  CONSTRAINT Stor_OuOrdMst_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont           (Id),
  CONSTRAINT Stor_OuOrdMst_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn           (Id),
  CONSTRAINT Stor_OuOrdMst_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn           (Id),
  CONSTRAINT Stor_OuOrdMst_Doc_FK    Foreign Key (Doc_Id   ) References Stor_Cod_Doc       (Id),
  CONSTRAINT Stor_OuOrdMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT Stor_OuOrdMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Stor_OuOrdMst For Stor_Outbound_Order_Master
/
Alter Table Stor_Outbound_Order_Master Add CONSTRAINT Stor_OuOrdMst_Fin_FK Foreign Key (Fin_Id) References Fin_MDbt(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Stor_OuOrdTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Outbound_Order_Trans                     -- بنود أوامر الإخراج
( Id          Number(20) NOT NULL,                         -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                         -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                          -- المادة
  Rel_Id      Number(20),                                  -- مفتاح مرتبط
  Unit_Id     Number(5) Default 0,                         -- الوحدة
  Model_Id    Number(5) Default 0,                         -- الموديل
  Color_Id    Number(5) Default 0,                         -- اللون 
  Size_Id     Number(5) Default 0,                         -- القياس 
  Ord         Number(5) Default 0,                         -- مسلسل
  Qnt         Number(25,3) Default 0,                      -- الكمية
  CQnt        Number(25,3) Default 0,                      -- الكمية الحالية
  SQnt        Number(25,3) Default 0,                      -- الكمية بوحدة التخزين
  WQnt        Number(25,3) Default 0,                      -- الوزن
  CWQnt       Number(25,3) Default 0,                      -- الوزن الحالي
  SWQnt       Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price       Number(25,2) Default 0,                      -- افرادي
  CAmt        Number(25,2) Default 0,                      -- القيمة قطع
  Amt         Number(25,2) Default 0,                      -- القيمة
  Cst         Number(25,2) Default 0,                      -- الكلفة
  BAmt        Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  BCst        Number(25,2) Default 0,                      -- الكلفة بعملة الأساس
  Vat_Perc    Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value   Number(25,2) Default 0,                      -- فيمة الVAT
  nLength     Number(25,2) Default 0,                      -- الطول
  nWidth      Number(25,2) Default 0,                      -- العرض
  nHeight     Number(25,2) Default 0,                      -- الارتفاع
  Barcode     Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer      Varchar2(50 Char) Default '_',               -- طبخة/مسلسل
  SDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ بداية
  EDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ نهاية
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Stor_OuOrdTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Stor_OuOrdTrn_Mst_FK    Foreign Key (Mst_Id  ) References Stor_OuOrdMst (Id),
  CONSTRAINT  Stor_OuOrdTrn_Item_FK   Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT  Stor_OuOrdTrn_Unit_FK   Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT  Stor_OuOrdTrn_Model_FK  Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT  Stor_OuOrdTrn_Color_FK  Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT  Stor_OuOrdTrn_Size_FK   Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT  Stor_OuOrdTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT  Stor_OuOrdTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Stor_OuOrdTrn For Stor_Outbound_Order_Trans
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_EIMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Execute_Inbound_Master                   -- ترويسة الادخال
( Id         Number(10),                                   -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  TrnTyp_Id  Number(3) Default 105,                        -- نوع الحركة
  Status_Id  Number(1) Default 0 NOT NULL,                 -- الحالة
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Cont_Id    Number(9) NOT NULL,                           -- المتعامل
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Curn_Id    Number(5) Default 1,                          -- العملة
  Curn_Rate  Number(25,8) Default 1,                       -- سعر الصرف
  BCurn_Id   Number(5) Default 1,                          -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                       -- سعر الصرف
  Ord_Id     Number(10),                                   -- مفتاح الأمر
  Fin_Id     Number(10),                                   -- مفتاح الورقة المالية
  Num        Number(9) NOT NULL,                           -- رقم الوثيقة
  dDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(15),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Stor_EIMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Stor_EIMst_UK        Unique      (Period_Id, Stor_Id, TrnTyp_Id, Num),
  CONSTRAINT Stor_EIMst_Period_FK Foreign Key (Period_Id) References Cpy_Period         (Id),
  CONSTRAINT Stor_EIMst_TrnTyp_FK Foreign Key (TrnTyp_Id) References Stor_Cod_TrnTyp    (Id),
  CONSTRAINT Stor_EIMst_Ord_FK    Foreign Key (Ord_Id   ) References Stor_InOrdMst      (Id),
  CONSTRAINT Stor_EIMst_Status_FK Foreign Key (Status_Id) References Stor_Cod_Ord_Status(Id),
  CONSTRAINT Stor_EIMst_Stor_FK   Foreign Key (Stor_Id  ) References Stor_Store         (Id),
  CONSTRAINT Stor_EIMst_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont           (Id),
  CONSTRAINT Stor_EIMst_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn           (Id),
  CONSTRAINT Stor_EIMst_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn           (Id),
  CONSTRAINT Stor_EIMst_Doc_FK    Foreign Key (Doc_Id   ) References Stor_Cod_Doc       (Id),
  CONSTRAINT Stor_EIMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT Stor_EIMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Stor_EIMst For Stor_Execute_Inbound_Master
/
Alter Table Stor_Execute_Inbound_Master Add CONSTRAINT Stor_EIMst_Fin_FK Foreign Key (Fin_Id) References Fin_MCrd(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Stor_EITrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Execute_Inbound_Trans                    -- بنود الادخال
( Id          Number(20),                                  -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                         -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                          -- المادة
  TOrd_Id     Number(20) NOT NULL,                         -- مفتاح بند الأمر
  ICS_Id      Number(30),                                  -- مفتاح الباركود 
  SICS_Id     Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id     Number(5) Default 0,                         -- الوحدة
  Model_Id    Number(5) Default 0,                         -- الموديل
  Color_Id    Number(5) Default 0,                         -- اللون 
  Size_Id     Number(5) Default 0,                         -- القياس 
  Ord         Number(5) Default 0,                         -- مسلسل
  Qnt         Number(25,3) Default 0,                      -- الكمية
  SQnt        Number(25,3) Default 0,                      -- الكمية بوحدة التخزين
  WQnt        Number(25,3) Default 0,                      -- الوزن
  SWQnt       Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price       Number(25,2) Default 0,                      -- افرادي
  CAmt        Number(25,2) Default 0,                      -- القيمة قطع
  Amt         Number(25,2) Default 0,                      -- القيمة
  Cst         Number(25,2) Default 0,                      -- الكلفة
  BAmt        Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  BCst        Number(25,2) Default 0,                      -- الكلفة بعملة الأساس
  Vat_Perc    Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value   Number(25,2) Default 0,                      -- فيمة الVAT
  nLength     Number(25,2) Default 0,                      -- الطول
  nWidth      Number(25,2) Default 0,                      -- العرض
  nHeight     Number(25,2) Default 0,                      -- الارتفاع
  Barcode     Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer      Varchar2(50 Char) Default '_',               -- طبخة/مسلسل
  SDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ بداية
  EDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ نهاية
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Stor_EITrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Stor_EITrn_Mst_FK    Foreign Key (Mst_Id  ) References Stor_EIMst    (Id),
  CONSTRAINT  Stor_EITrn_Ord_FK    Foreign Key (TOrd_Id ) References Stor_InOrdTrn (Id),
  CONSTRAINT  Stor_EITrn_Item_FK   Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT  Stor_EITrn_ICS_FK    Foreign Key (ICS_Id  ) References Stor_ICS      (Id),
  CONSTRAINT  Stor_EITrn_Sics_FK   Foreign Key (Sics_Id ) References Stor_Sics     (Id),
  CONSTRAINT  Stor_EITrn_Unit_FK   Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT  Stor_EITrn_Model_FK  Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT  Stor_EITrn_Color_FK  Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT  Stor_EITrn_Size_FK   Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT  Stor_EITrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT  Stor_EITrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Stor_EITrn For Stor_Execute_Inbound_Trans
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_EOMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Execute_Outbound_Master                  -- ترويسة الاخراج
( Id         Number(10) NOT NULL,                          -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  TrnTyp_Id  Number(3) Default 205,                        -- نوع الحركة
  Status_Id  Number(1) Default 0 NOT NULL,                 -- الحالة
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Cont_Id    Number(9) NOT NULL,                           -- المتعامل
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Curn_Id    Number(5) Default 1,                          -- العملة
  Curn_Rate  Number(25,8) Default 1,                       -- سعر الصرف
  BCurn_Id   Number(5) Default 1,                          -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                       -- سعر الصرف
  Ord_Id     Number(10),                                   -- مفتاح الأمر
  Fin_Id     Number(10),                                   -- مفتاح الورقة المالية
  Num        Number(9) NOT NULL,                           -- رقم الوثيقة
  dDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(15),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Stor_EOMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Stor_EOMst_UK        Unique      (Period_Id, TrnTyp_Id, Stor_Id, Num),
  CONSTRAINT Stor_EOMst_Period_FK Foreign Key (Period_Id) References Cpy_Period         (Id),
  CONSTRAINT Stor_EOMst_TrnTyp_FK Foreign Key (TrnTyp_Id) References Stor_Cod_TrnTyp    (Id),
  CONSTRAINT Stor_EOMst_Ord_FK    Foreign Key (Ord_Id   ) References Stor_OuOrdMst      (Id),
  CONSTRAINT Stor_EOMst_Status_FK Foreign Key (Status_Id) References Stor_Cod_Ord_Status(Id),
  CONSTRAINT Stor_EOMst_Stor_FK   Foreign Key (Stor_Id  ) References Stor_Store         (Id),
  CONSTRAINT Stor_EOMst_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont           (Id),
  CONSTRAINT Stor_EOMst_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn           (Id),
  CONSTRAINT Stor_EOMst_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn           (Id),
  CONSTRAINT Stor_EOMst_Doc_FK    Foreign Key (Doc_Id   ) References Stor_Cod_Doc       (Id),
  CONSTRAINT Stor_EOMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT Stor_EOMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Stor_EOMst For Stor_Execute_Outbound_Master
/
Alter Table Stor_Execute_Outbound_Master Add CONSTRAINT Stor_EOMst_Fin_FK Foreign Key (Fin_Id) References Fin_MDbt(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Stor_EOTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Execute_Outbound_Trans                   -- بنود الإخراج
( Id          Number(20) NOT NULL,                         -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                         -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                          -- المادة
  TOrd_Id     Number(20) NOT NULL,                         -- مفتاح بند الأمر
  ICS_Id      Number(30),                                  -- مفتاح الباركود 
  SICS_Id     Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id     Number(5) Default 0,                         -- الوحدة
  Model_Id    Number(5) Default 0,                         -- الموديل
  Color_Id    Number(5) Default 0,                         -- اللون 
  Size_Id     Number(5) Default 0,                         -- القياس 
  Ord         Number(5) Default 0,                         -- مسلسل
  Qnt         Number(25,3) Default 0,                      -- الكمية
  SQnt        Number(25,3) Default 0,                      -- الكمية بوحدة التخزين
  WQnt        Number(25,3) Default 0,                      -- الوزن
  SWQnt       Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price       Number(25,2) Default 0,                      -- افرادي
  CAmt        Number(25,2) Default 0,                      -- القيمة قطع
  Amt         Number(25,2) Default 0,                      -- القيمة
  Cst         Number(25,2) Default 0,                      -- الكلفة
  BAmt        Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  BCst        Number(25,2) Default 0,                      -- الكلفة بعملة الأساس
  Vat_Perc    Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value   Number(25,2) Default 0,                      -- فيمة الVAT
  nLength     Number(25,2) Default 0,                      -- الطول
  nWidth      Number(25,2) Default 0,                      -- العرض
  nHeight     Number(25,2) Default 0,                      -- الارتفاع
  Barcode     Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer      Varchar2(50 Char) Default '_',               -- طبخة/مسلسل
  SDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ بداية
  EDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ نهاية
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Stor_EOTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Stor_EOTrn_Mst_FK    Foreign Key (Mst_Id  ) References Stor_EOMst    (Id),
  CONSTRAINT  Stor_EOTrn_Ord_FK    Foreign Key (TOrd_Id ) References Stor_OuOrdTrn (Id),
  CONSTRAINT  Stor_EOTrn_Item_FK   Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT  Stor_EOTrn_ICS_FK    Foreign Key (ICS_Id  ) References Stor_ICS      (Id),
  CONSTRAINT  Stor_EOTrn_Sics_FK   Foreign Key (Sics_Id ) References Stor_Sics     (Id),
  CONSTRAINT  Stor_EOTrn_Unit_FK   Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT  Stor_EOTrn_Model_FK  Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT  Stor_EOTrn_Color_FK  Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT  Stor_EOTrn_Size_FK   Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT  Stor_EOTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT  Stor_EOTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Stor_EOTrn For Stor_Execute_Outbound_Trans
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_InMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Inbound_Master                           -- ترويسة الادخال
( Id         Number(10),                                   -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  TrnTyp_Id  Number(3) Default 100,                        -- نوع الحركة
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Cont_Id    Number(9) NOT NULL,                           -- المتعامل
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Curn_Id    Number(5) Default 1,                          -- العملة
  Curn_Rate  Number(25,8) Default 1,                       -- سعر الصرف
  BCurn_Id   Number(5) Default 1,                          -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                       -- سعر الصرف
  Fin_Id     Number(10),                                   -- مفتاح الورقة المالية
  Num        Number(9) NOT NULL,                           -- رقم الوثيقة
  dDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(15),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Stor_InMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Stor_InMst_UK        Unique      (Period_Id, Stor_Id, TrnTyp_Id, Num),
  CONSTRAINT Stor_InMst_Period_FK Foreign Key (Period_Id) References Cpy_Period         (Id),
  CONSTRAINT Stor_InMst_TrnTyp_FK Foreign Key (TrnTyp_Id) References Stor_Cod_TrnTyp    (Id),
  CONSTRAINT Stor_InMst_Stor_FK   Foreign Key (Stor_Id  ) References Stor_Store         (Id),
  CONSTRAINT Stor_InMst_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont           (Id),
  CONSTRAINT Stor_InMst_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn           (Id),
  CONSTRAINT Stor_InMst_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn           (Id),
  CONSTRAINT Stor_InMst_Doc_FK    Foreign Key (Doc_Id   ) References Stor_Cod_Doc       (Id),
  CONSTRAINT Stor_InMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT Stor_InMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Stor_InMst For Stor_Inbound_Master
/
Alter Table Stor_Inbound_Master Add CONSTRAINT Stor_InMst_Fin_FK Foreign Key (Fin_Id) References Fin_MCrd(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Stor_InTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Inbound_Trans                            -- بنود الادخال
( Id          Number(20),                                  -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                         -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                          -- المادة
  ICS_Id      Number(30),                                  -- مفتاح الباركود 
  SICS_Id     Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id     Number(5) Default 0,                         -- الوحدة
  Model_Id    Number(5) Default 0,                         -- الموديل
  Color_Id    Number(5) Default 0,                         -- اللون 
  Size_Id     Number(5) Default 0,                         -- القياس 
  Ord         Number(5) Default 0,                         -- مسلسل
  Qnt         Number(25,3) Default 0,                      -- الكمية
  SQnt        Number(25,3) Default 0,                      -- الكمية بوحدة التخزين
  WQnt        Number(25,3) Default 0,                      -- الوزن
  SWQnt       Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price       Number(25,2) Default 0,                      -- افرادي
  CAmt        Number(25,2) Default 0,                      -- القيمة قطع
  Amt         Number(25,2) Default 0,                      -- القيمة
  Cst         Number(25,2) Default 0,                      -- الكلفة
  BAmt        Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  BCst        Number(25,2) Default 0,                      -- الكلفة بعملة الأساس
  Vat_Perc    Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value   Number(25,2) Default 0,                      -- فيمة الVAT
  nLength     Number(25,2) Default 0,                      -- الطول
  nWidth      Number(25,2) Default 0,                      -- العرض
  nHeight     Number(25,2) Default 0,                      -- الارتفاع
  Barcode     Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer      Varchar2(50 Char) Default '_',               -- طبخة/مسلسل
  SDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ بداية
  EDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ نهاية
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Stor_InTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Stor_InTrn_Mst_FK    Foreign Key (Mst_Id  ) References Stor_InMst    (Id),
  CONSTRAINT  Stor_InTrn_Item_FK   Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT  Stor_InTrn_ICS_FK    Foreign Key (ICS_Id  ) References Stor_ICS      (Id),
  CONSTRAINT  Stor_InTrn_Sics_FK   Foreign Key (Sics_Id ) References Stor_Sics     (Id),
  CONSTRAINT  Stor_InTrn_Unit_FK   Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT  Stor_InTrn_Model_FK  Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT  Stor_InTrn_Color_FK  Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT  Stor_InTrn_Size_FK   Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT  Stor_InTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT  Stor_InTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Stor_InTrn For Stor_Inbound_Trans
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_OuMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Outbound_Master                          -- ترويسة الاخراج
( Id         Number(10) NOT NULL,                          -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  TrnTyp_Id  Number(3) Default 200,                        -- نوع الحركة
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Cont_Id    Number(9) NOT NULL,                           -- المتعامل
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Curn_Id    Number(5) Default 1,                          -- العملة
  Curn_Rate  Number(25,8) Default 1,                       -- سعر الصرف
  BCurn_Id   Number(5) Default 1,                          -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                       -- سعر الصرف
  Ord_Id     Number(10),                                   -- مفتاح الأمر
  Fin_Id     Number(10),                                   -- مفتاح الورقة المالية
  Num        Number(9) NOT NULL,                           -- رقم الوثيقة
  dDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(15),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Stor_OuMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Stor_OuMst_UK        Unique      (Period_Id, Stor_Id, TrnTyp_Id, Num),
  CONSTRAINT Stor_OuMst_Period_FK Foreign Key (Period_Id) References Cpy_Period         (Id),
  CONSTRAINT Stor_OuMst_TrnTyp_FK Foreign Key (TrnTyp_Id) References Stor_Cod_TrnTyp    (Id),
  CONSTRAINT Stor_OuMst_Stor_FK   Foreign Key (Stor_Id  ) References Stor_Store         (Id),
  CONSTRAINT Stor_OuMst_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont           (Id),
  CONSTRAINT Stor_OuMst_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn           (Id),
  CONSTRAINT Stor_OuMst_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn           (Id),
  CONSTRAINT Stor_OuMst_Doc_FK    Foreign Key (Doc_Id   ) References Stor_Cod_Doc       (Id),
  CONSTRAINT Stor_OuMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT Stor_OuMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Stor_OuMst For Stor_Outbound_Master
/
Alter Table Stor_Outbound_Master Add CONSTRAINT Stor_OuMst_Fin_FK Foreign Key (Fin_Id) References Fin_MDbt(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Stor_OuTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Outbound_Trans                           -- بنود الإخراج
( Id          Number(20) NOT NULL,                         -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                         -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                          -- المادة
  ICS_Id      Number(30),                                  -- مفتاح الباركود 
  SICS_Id     Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id     Number(5) Default 0,                         -- الوحدة
  Model_Id    Number(5) Default 0,                         -- الموديل
  Color_Id    Number(5) Default 0,                         -- اللون 
  Size_Id     Number(5) Default 0,                         -- القياس 
  Ord         Number(5) Default 0,                         -- مسلسل
  Qnt         Number(25,3) Default 0,                      -- الكمية
  SQnt        Number(25,3) Default 0,                      -- الكمية بوحدة التخزين
  WQnt        Number(25,3) Default 0,                      -- الوزن
  SWQnt       Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price       Number(25,2) Default 0,                      -- افرادي
  CAmt        Number(25,2) Default 0,                      -- القيمة قطع
  Amt         Number(25,2) Default 0,                      -- القيمة
  Cst         Number(25,2) Default 0,                      -- الكلفة
  BAmt        Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  BCst        Number(25,2) Default 0,                      -- الكلفة بعملة الأساس
  Vat_Perc    Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value   Number(25,2) Default 0,                      -- فيمة الVAT
  nLength     Number(25,2) Default 0,                      -- الطول
  nWidth      Number(25,2) Default 0,                      -- العرض
  nHeight     Number(25,2) Default 0,                      -- الارتفاع
  Barcode     Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer      Varchar2(50 Char) Default '_',               -- طبخة/مسلسل
  SDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ بداية
  EDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ نهاية
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Stor_OuTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Stor_OuTrn_Mst_FK    Foreign Key (Mst_Id  ) References Stor_OuMst    (Id),
  CONSTRAINT  Stor_OuTrn_Item_FK   Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT  Stor_OuTrn_ICS_FK    Foreign Key (ICS_Id  ) References Stor_ICS      (Id),
  CONSTRAINT  Stor_OuTrn_Sics_FK   Foreign Key (Sics_Id ) References Stor_Sics     (Id),
  CONSTRAINT  Stor_OuTrn_Unit_FK   Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT  Stor_OuTrn_Model_FK  Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT  Stor_OuTrn_Color_FK  Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT  Stor_OuTrn_Size_FK   Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT  Stor_OuTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT  Stor_OuTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Stor_OuTrn For Stor_Outbound_Trans
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_TrMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Transfer_Master                          -- ترويسة الترحيل
( Id         Number(10) NOT NULL,                          -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  TrnTypF_Id Number(3) Default 250,                        -- نوع الحركة
  TrnTypT_Id Number(3) Default 150,                        -- نوع الحركة
  StorF_Id   Number(5) NOT NULL,                           -- المخزن المرحل منه
  StorT_Id   Number(5) NOT NULL,                           -- المخزن المرحل إليه
  Fin_Id     Number(10),                                   -- مفتاح الورقة المالية
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Curn_Id    Number(5) Default 1,                          -- العملة
  Curn_Rate  Number(25,8) Default 1,                       -- سعر الصرف
  BCurn_Id   Number(5) Default 1,                          -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                       -- سعر الصرف
  Num        Number(9) NOT NULL,                           -- رقم الوثيقة
  dDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(15),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Stor_TrMst_PK         PRIMARY KEY (Id),
  CONSTRAINT Stor_TrMst_UK         Unique      (Period_Id, StorF_Id, Num),
  CONSTRAINT Stor_TrMst_Period_FK  Foreign Key (Period_Id ) References Cpy_Period     (Id),
  CONSTRAINT Stor_InMst_TrnTypF_FK Foreign Key (TrnTypF_Id) References Stor_Cod_TrnTyp(Id),
  CONSTRAINT Stor_InMst_TrnTypT_FK Foreign Key (TrnTypT_Id) References Stor_Cod_TrnTyp(Id),
  CONSTRAINT Stor_TrMst_StorF_FK   Foreign Key (StorF_Id  ) References Stor_Store     (Id),
  CONSTRAINT Stor_TrMst_StorT_FK   Foreign Key (StorT_Id  ) References Stor_Store     (Id),
  CONSTRAINT Stor_TrMst_Doc_FK     Foreign Key (Doc_Id    ) References Cpy_Cod_Doc    (Id),
  CONSTRAINT Stor_TrMst_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT Stor_TrMst_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Stor_TrMst For Stor_Transfer_Master
/
Alter Table Stor_Transfer_Master Add CONSTRAINT Stor_TrMst_Fin_FK Foreign Key (Fin_Id) References Fin_MDbt(Id);
----------------------------------------------------------------------------------------------------
Create Sequence Stor_TrTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Transfer_Trans                           -- بنود الترحيل
( Id          Number(20) NOT NULL,                         -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                         -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                          -- المادة
  ICS_Id      Number(30),                                  -- مفتاح الباركود 
  Sics_Fid    Number(30),                                  -- مفتاح الباركود في المستودع
  SICS_TId    Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id     Number(5) Default 0,                         -- الوحدة
  Model_Id    Number(5) Default 0,                         -- الموديل
  Color_Id    Number(5) Default 0,                         -- اللون 
  Size_Id     Number(5) Default 0,                         -- القياس 
  Ord         Number(5) Default 0,                         -- مسلسل
  Qnt         Number(25,3) Default 0,                      -- الكمية
  CQnt        Number(25,3) Default 0,                      -- الكمية الحالية
  SQnt        Number(25,3) Default 0,                      -- الكمية بوحدة التخزين
  WQnt        Number(25,3) Default 0,                      -- الوزن
  CWQnt       Number(25,3) Default 0,                      -- الوزن الحالي
  SWQnt       Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price       Number(25,2) Default 0,                      -- افرادي
  CAmt        Number(25,2) Default 0,                      -- القيمة قطع
  Amt         Number(25,2) Default 0,                      -- القيمة
  Cst         Number(25,2) Default 0,                      -- الكلفة
  BAmt        Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  BCst        Number(25,2) Default 0,                      -- الكلفة بعملة الأساس
  Vat_Perc    Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value   Number(25,2) Default 0,                      -- فيمة الVAT
  nLength     Number(25,2) Default 0,                      -- الطول
  nWidth      Number(25,2) Default 0,                      -- العرض
  nHeight     Number(25,2) Default 0,                      -- الارتفاع
  Barcode     Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer      Varchar2(50 Char) Default '_',               -- طبخة/مسلسل
  SDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ بداية
  EDate       Date Default TO_Date('01-01-1900', 'DD-MM-YYYY') NOT NULL,-- تاريخ نهاية
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Stor_TrTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Stor_TrTrn_Mst_FK    Foreign Key (Mst_Id  ) References Stor_TrMst    (Id),
  CONSTRAINT  Stor_TrTrn_Item_FK   Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT  Stor_TrTrn_ICS_FK    Foreign Key (ICS_Id  ) References Stor_ICS      (Id),
  CONSTRAINT  Stor_TrTrn_FSics_FK  Foreign Key (Sics_FId) References Stor_Sics     (Id),
  CONSTRAINT  Stor_TrTrn_TSics_FK  Foreign Key (Sics_TId) References Stor_Sics     (Id),
  CONSTRAINT  Stor_TrTrn_Unit_FK   Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT  Stor_TrTrn_Model_FK  Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT  Stor_TrTrn_Color_FK  Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT  Stor_TrTrn_Size_FK   Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT  Stor_TrTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT  Stor_TrTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Stor_TrTrn For Stor_Transfer_Trans
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_ChLocMst_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Change_Location_Master                   -- ترويسة تعديل موقع مادة في مستودع
( Id         Number(9) Not Null,                           -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Doc_Id     Number(5) Default 0,                          -- المستند
  Docn       Number(15),                                   -- رقم الستند
  Docd       Date,                                         -- تاريخ المستند
  Num        Number(15),                                   -- رقم الوثيقة
  dDate      Date,                                         -- التاريخ
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  Constraint Stor_ChLocMst_PK        Primary Key (Id),
  Constraint Stor_ChLocMst_Uk        Unique      (Period_Id, Stor_Id, Num),
  Constraint Stor_ChLocMst_Period_FK Foreign Key (Period_Id) References Cpy_Period  (Id),
  Constraint Stor_ChLocMst_Stor_FK   Foreign Key (Stor_Id  ) References Stor_Store (Id),
  Constraint Stor_ChLocMst_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc(Id),
  Constraint Stor_ChLocMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  Constraint Stor_ChLocMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Stor_ChLocMst for Stor_Change_Location_Master
/
----------------------------------------------------------------------------------------------------
Create Sequence Stor_ChLocTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Change_Location_Trans                    -- بنود تعديل موقع مادة في مستودع
( Id          Number(20) Not Null,                         -- مفتاح رئيسي
  Mst_Id      Number(9) Not Null,                          -- مفتاح الأب
  Item_Id     Number(9) Not Null,                          -- المادة
  Sics_Id     Number(30),                                  -- مفتاح الباركود في المستودع
  Ord         Number(5) Default 0,                         -- مسلسل
  OLoc1_Id    Number(5) Default 0,                         -- الموقع 1 السابق
  OLoc2_Id    Number(5) Default 0,                         -- الموقع 2 السابق
  OLoc3_Id    Number(5) Default 0,                         -- الموقع 3 السابق
  NLoc1_Id    Number(5) Default 0,                         -- الموقع 1 الجديد
  NLoc2_Id    Number(5) Default 0,                         -- الموقع 2 الجديد
  NLoc3_Id    Number(5) Default 0,                         -- الموقع 3 الجديد
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(20),  Ins_Date    Date,
  Upd_User    Number(20),  Upd_Date    Date,
  Constraint  Stor_ChLocTrn_PK       Primary Key (Id),
  Constraint  Stor_ChLocTrn_Mst_FK   Foreign Key (Mst_Id  ) References Stor_ChLocMst(Id),
  Constraint  Stor_ChLocTrn_Item_FK  Foreign Key (Item_Id ) References Stor_Item    (Id),
  Constraint  Stor_ChLocTrn_Sics_FK  Foreign Key (Sics_Id ) References Stor_Sics    (Id),
  Constraint  Stor_ChLocTrn_OLoc1_FK Foreign Key (oLoc1_Id) References Stor_Cod_Loc1(Id),
  Constraint  Stor_ChLocTrn_OLoc2_FK Foreign Key (oLoc2_Id) References Stor_Cod_Loc2(Id),
  Constraint  Stor_ChLocTrn_OLoc3_FK Foreign Key (oLoc3_Id) References Stor_Cod_Loc3(Id),
  Constraint  Stor_ChLocTrn_NLoc1_FK Foreign Key (nLoc1_Id) References Stor_Cod_Loc1(Id),
  Constraint  Stor_ChLocTrn_NLoc2_FK Foreign Key (nLoc2_Id) References Stor_Cod_Loc2(Id),
  Constraint  Stor_ChLocTrn_NLoc3_FK Foreign Key (nLoc3_Id) References Stor_Cod_Loc3(Id),
  Constraint  Stor_ChLocTrn_Ins_FK   Foreign Key (Ins_User) References Cpy_User     (Id),
  Constraint  Stor_ChLocTrn_Upd_FK   Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Stor_ChLocTrn for Stor_Change_Location_Trans
/
