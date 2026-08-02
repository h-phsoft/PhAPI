----------------------------------------------------------------------------------------------------
Create Sequence DStr_Item_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Items                                    -- دليل المواد
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Num        Varchar2(15 Char) NOT NULL,                   -- رقم المادة
  MNum       Varchar2(15 Char) NOT NULL,                   -- رقم العامة
  Name       VarChar2(100 Char) NOT NULL,                  -- اسم المادة
  Status_Id  Number(1) Default 1,                          -- الحالة
  Unit_Id    Number(5) Default 1,                          -- الوحدة
  Spc1_Id    Number(5) Default 0,                          -- تصنيف 1
  Spc2_Id    Number(5) Default 0,                          -- تصنيف 2
  Spc3_Id    Number(5) Default 0,                          -- تصنيف 3
  Spc4_Id    Number(5) Default 0,                          -- تصنيف 4
  Spc5_Id    Number(5) Default 0,                          -- تصنيف 5
  Rem        VarChar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Str_Item_PK        PRIMARY KEY (Id       ),
  CONSTRAINT Str_Item_Num_UK    Unique      (Num      ),
  CONSTRAINT Str_Item_Name_UK   Unique      (Name     ),
  CONSTRAINT Str_Item_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Str_Item_Unit_FK   Foreign Key (Unit_Id  ) References DStr_Cod_Unit (Id),
  CONSTRAINT Str_Item_Spc1_FK   Foreign Key (Spc1_Id  ) References DStr_Cod_Spc1 (Id),
  CONSTRAINT Str_Item_Spc2_FK   Foreign Key (Spc2_Id  ) References DStr_Cod_Spc2 (Id),
  CONSTRAINT Str_Item_Spc3_FK   Foreign Key (Spc3_Id  ) References DStr_Cod_Spc3 (Id),
  CONSTRAINT Str_Item_Spc4_FK   Foreign Key (Spc4_Id  ) References DStr_Cod_Spc4 (Id),
  CONSTRAINT Str_Item_Spc5_FK   Foreign Key (Spc5_Id  ) References DStr_Cod_Spc5 (Id),
  CONSTRAINT Str_Item_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Str_Item_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym DStr_Item For DStr_Items
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_Store_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Stores                                   -- دليل المخازن
( Id          Number(5),                                   -- مفتاح رئيسي
  Num         Number(5),                                   -- رقم المخزن
  Status_Id   Number(1) Default 1,                         -- الحالة
  Acc_Id      Number(9) NOT NULL,                          -- حساب المخزن
  User_Id     Number(5) NOT NULL,                          -- أمين المستودع
  Name        Varchar2(100 Char),                          -- اسم المخزن
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  DStr_Store_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  DStr_Store_Num_UK    Unique      (Num),
  CONSTRAINT  DStr_Store_Name_UK   Unique      (Name),
  CONSTRAINT  DStr_Store_Acc_Id_FK Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT  DStr_Store_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  DStr_Store_User_FK   Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT  DStr_Store_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  DStr_Store_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym DStr_Store For DStr_Stores
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_StrItem_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Store_Items                              -- دليل مواد مستودع
( Id         Number(5),                                    -- مفتاح رئيسي
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Item_Id    Number(9) NOT NULL,                           -- المادة
  Status_Id  Number(1) Default 1,                          -- الحالة
  Loc1_Id    Number(5) Default 0,                          -- مكان تخزين 1
  Loc2_Id    Number(5) DEfault 0,                          -- مكان تخزين 2
  Loc3_Id    Number(5) Default 0,                          -- مكان تخزين 3
  ReqQnt     Number(17,3) Default 0,                       -- حد الطلب
  MinQnt     Number(17,3) Default 0,                       -- الحد الأدنى
  MaxQnt     Number(17,3) Default 0,                       -- الحد الأعلى
  CQnt1      Number(17,3) Default 0,                       -- رصيد الكمية 1
  CQnt2      Number(17,3) Default 0,                       -- رصيد الكمية 2
  CQnt3      Number(17,3) Default 0,                       -- رصيد الكمية 3
  CAmt3      Number(17,3) Default 0,                       -- رصيد القيمة 3
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_StrItem_PK         PRIMARY KEY (Id),
  CONSTRAINT DStr_StrItem_UK         Unique      (Stor_Id, Item_Id),
  CONSTRAINT DStr_StrItem_Stor_FK    Foreign Key (Stor_Id  ) References DStr_Store    (Id),
  CONSTRAINT DStr_StrItem_Item_FK    Foreign Key (Item_Id  ) References DStr_Item     (Id),
  CONSTRAINT DStr_StrItem_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT DStr_StrItem_Loc1_FK    Foreign Key (Loc1_Id  ) References DStr_Cod_Loc1 (Id),
  CONSTRAINT DStr_StrItem_Loc2_FK    Foreign Key (Loc2_Id  ) References DStr_Cod_Loc2 (Id),
  CONSTRAINT DStr_StrItem_Loc3_FK    Foreign Key (Loc3_Id  ) References DStr_Cod_Loc3 (Id),
  CONSTRAINT DStr_StrItem_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT DStr_StrItem_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym DStr_StrItem For DStr_Store_Items
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_InMst1_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Inbound_Master1                          -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Trt_Id     Number(5) Default 100,                        -- نوع الحركة
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Acc_Id     Number(9) NOT NULL,                           -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Cost_Id    Number(9) NOT NULL,                           -- مركز الكلفة
  MNum       Number(9) NOT NULL,                           -- رقم الوثيقة
  MDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(20),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  RNum       Number(9),                                    -- رقم الوثيقة المرتبطة
  RDate      Date,                                         -- التاريخ المرتبط
  RDocN      Varchar2(20),                                 -- رقم المستند المرتبط
  RDocD      Date,                                         -- تاريخ المستند المرتبط
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT DStr_InMst1_PK        PRIMARY KEY (Id),
  CONSTRAINT DStr_InMst1_UK        Unique      (Period_Id, Stor_Id, MNum),
  CONSTRAINT DStr_InMst1_Period_FK Foreign Key (Period_Id) References Cpy_Period  (Id),
  CONSTRAINT DStr_InMst1_Trt_FK    Foreign Key (Trt_Id   ) References DStr_Cod_Trt(Id),
  CONSTRAINT DStr_InMst1_Stor_FK   Foreign Key (Stor_Id  ) References DStr_Store  (Id),
  CONSTRAINT DStr_InMst1_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc     (Id),
  CONSTRAINT DStr_InMst1_Cost_FK   Foreign Key (Cost_Id  ) References Acc_cost    (Id),
  CONSTRAINT DStr_InMst1_Doc_FK    Foreign Key (Doc_Id   ) References DStr_Cod_Doc(Id),
  CONSTRAINT DStr_InMst1_Ins_FK    Foreign Key (Ins_User ) References Cpy_User    (Id),
  CONSTRAINT DStr_InMst1_Upd_FK    Foreign Key (Upd_User ) References Cpy_User    (Id)
)
/
Create Synonym DStr_InMst1 For DStr_Inbound_Master1
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_InTrn1_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Inbound_Transaction1                     -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Mst_Id     Number(20) NOT NULL,                          -- مفتاح الأب
  Item_Id    Number(20) NOT NULL,                          -- المادة
  Qnt        Number(17,3) DEFAULT 0,                       -- الكمية
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_InTrn1_PK      PRIMARY KEY (Id),
  CONSTRAINT DStr_InTrn1_Mst_FK  Foreign Key (Mst_Id  ) References DStr_InMst1(Id),
  CONSTRAINT DStr_InTrn1_Item_FK Foreign Key (Item_Id ) References DStr_Item  (Id),
  CONSTRAINT DStr_InTrn1_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT DStr_InTrn1_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym DStr_InTrn1 For DStr_Inbound_Transaction1
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_InMst2_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Inbound_Master2                          -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Trt_Id     Number(5) Default 100,                        -- نوع الحركة
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Acc_Id     Number(9) NOT NULL,                           -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Cost_Id    Number(9) NOT NULL,                           -- مركز الكلفة
  MNum       Number(9) NOT NULL,                           -- رقم الوثيقة
  MDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(20),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  RNum       Number(9),                                    -- رقم الوثيقة المرتبطة
  RDate      Date,                                         -- التاريخ المرتبط
  RDocN      Varchar2(20),                                 -- رقم المستند المرتبط
  RDocD      Date,                                         -- تاريخ المستند المرتبط
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT DStr_InMst2_PK        PRIMARY KEY (Id),
  CONSTRAINT DStr_InMst2_UK        Unique      (Period_Id, Stor_Id, MNum),
  CONSTRAINT DStr_InMst2_Period_FK Foreign Key (Period_Id) References Cpy_Period  (Id),
  CONSTRAINT DStr_InMst2_Trt_FK    Foreign Key (Trt_Id   ) References DStr_Cod_Trt(Id),
  CONSTRAINT DStr_InMst2_Stor_FK   Foreign Key (Stor_Id  ) References DStr_Store  (Id),
  CONSTRAINT DStr_InMst2_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc     (Id),
  CONSTRAINT DStr_InMst2_Cost_FK   Foreign Key (Cost_Id  ) References Acc_cost    (Id),
  CONSTRAINT DStr_InMst2_Doc_FK    Foreign Key (Doc_Id   ) References DStr_Cod_Doc(Id),
  CONSTRAINT DStr_InMst2_Ins_FK    Foreign Key (Ins_User ) References Cpy_User    (Id),
  CONSTRAINT DStr_InMst2_Upd_FK    Foreign Key (Upd_User ) References Cpy_User    (Id)
)
/
Create Synonym DStr_InMst2 For DStr_Inbound_Master2
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_InTrn2_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Inbound_Transaction2                     -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Mst_Id     Number(20) NOT NULL,                          -- مفتاح الأب
  Item_Id    Number(20) NOT NULL,                          -- المادة
  Qnt        Number(17,3) DEFAULT 0,                       -- الكمية
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_InTrn2_PK      PRIMARY KEY (Id),
  CONSTRAINT DStr_InTrn2_Mst_FK  Foreign Key (Mst_Id  ) References DStr_InMst1(Id),
  CONSTRAINT DStr_InTrn2_Item_FK Foreign Key (Item_Id ) References DStr_Item  (Id),
  CONSTRAINT DStr_InTrn2_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT DStr_InTrn2_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym DStr_InTrn2 For DStr_Inbound_Transaction2
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_InMst3_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Inbound_Master3                          -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Trt_Id     Number(5) Default 100,                        -- نوع الحركة
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Acc_Id     Number(9) NOT NULL,                           -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Cost_Id    Number(9) NOT NULL,                           -- مركز الكلفة
  MNum       Number(9) NOT NULL,                           -- رقم الوثيقة
  MDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(20),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  RNum       Number(9),                                    -- رقم الوثيقة المرتبطة
  RDate      Date,                                         -- التاريخ المرتبط
  RDocN      Varchar2(20),                                 -- رقم المستند المرتبط
  RDocD      Date,                                         -- تاريخ المستند المرتبط
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT DStr_InMst3_PK        PRIMARY KEY (Id),
  CONSTRAINT DStr_InMst3_UK        Unique      (Period_Id, Stor_Id, MNum),
  CONSTRAINT DStr_InMst3_Period_FK Foreign Key (Period_Id) References Cpy_Period  (Id),
  CONSTRAINT DStr_InMst3_Trt_FK    Foreign Key (Trt_Id   ) References DStr_Cod_Trt(Id),
  CONSTRAINT DStr_InMst3_Stor_FK   Foreign Key (Stor_Id  ) References DStr_Store  (Id),
  CONSTRAINT DStr_InMst3_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc     (Id),
  CONSTRAINT DStr_InMst3_Cost_FK   Foreign Key (Cost_Id  ) References Acc_cost    (Id),
  CONSTRAINT DStr_InMst3_Doc_FK    Foreign Key (Doc_Id   ) References DStr_Cod_Doc(Id),
  CONSTRAINT DStr_InMst3_Ins_FK    Foreign Key (Ins_User ) References Cpy_User    (Id),
  CONSTRAINT DStr_InMst3_Upd_FK    Foreign Key (Upd_User ) References Cpy_User    (Id)
)
/
Create Synonym DStr_InMst3 For DStr_Inbound_Master3
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_InTrn3_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Inbound_Transaction3                     -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Mst_Id     Number(20) NOT NULL,                          -- مفتاح الأب
  Item_Id    Number(20) NOT NULL,                          -- المادة
  Status_Id  Number(1) Default 2,                          -- الحالة إمكانية التعديل 1 يمكن تعديله ببرنامج التدقيق، 2 لا يمكن تعديله
  Qnt        Number(17,3) DEFAULT 0,                       -- الكمية
  Price      Number(17,2) DEFAULT 0,                       -- السعر
  Amt        Number(17,2) DEFAULT 0,                       -- القيمة
  Cst        Number(17,2) DEFAULT 0,                       -- الكلفة
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_InTrn3_PK        PRIMARY KEY (Id),
  CONSTRAINT DStr_InTrn3_Mst_FK    Foreign Key (Mst_Id   ) References DStr_InMst1   (Id),
  CONSTRAINT DStr_InTrn3_Item_FK   Foreign Key (Item_Id  ) References DStr_Item     (Id),
  CONSTRAINT DStr_InTrn3_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT DStr_InTrn3_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT DStr_InTrn3_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym DStr_InTrn3 For DStr_Inbound_Transaction3
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_OuMst1_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Outbound_Master1                         -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Trt_Id     Number(5) Default 200,                        -- نوع الحركة
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Acc_Id     Number(9) NOT NULL,                           -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Cost_Id    Number(9) NOT NULL,                           -- مركز الكلفة
  MNum       Number(9) NOT NULL,                           -- رقم الوثيقة
  MDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(20),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  RNum       Number(9),                                    -- رقم الوثيقة المرتبطة
  RDate      Date,                                         -- التاريخ المرتبط
  RDocN      Varchar2(20),                                 -- رقم المستند المرتبط
  RDocD      Date,                                         -- تاريخ المستند المرتبط
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT DStr_OuMst1_PK        PRIMARY KEY (Id),
  CONSTRAINT DStr_OuMst1_UK        Unique      (Period_Id, Stor_Id, MNum),
  CONSTRAINT DStr_OuMst1_Period_FK Foreign Key (Period_Id) References Cpy_Period  (Id),
  CONSTRAINT DStr_OuMst1_Trt_FK    Foreign Key (Trt_Id   ) References DStr_Cod_Trt(Id),
  CONSTRAINT DStr_OuMst1_Stor_FK   Foreign Key (Stor_Id  ) References DStr_Store  (Id),
  CONSTRAINT DStr_OuMst1_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc     (Id),
  CONSTRAINT DStr_OuMst1_Cost_FK   Foreign Key (Cost_Id  ) References Acc_cost    (Id),
  CONSTRAINT DStr_OuMst1_Doc_FK    Foreign Key (Doc_Id   ) References DStr_Cod_Doc(Id),
  CONSTRAINT DStr_OuMst1_Ins_FK    Foreign Key (Ins_User ) References Cpy_User    (Id),
  CONSTRAINT DStr_OuMst1_Upd_FK    Foreign Key (Upd_User ) References Cpy_User    (Id)
)
/
Create Synonym DStr_OuMst1 For DStr_Outbound_Master1
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_OuTrn1_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Outbound_Transaction1                    -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Mst_Id     Number(20) NOT NULL,                          -- مفتاح الأب
  Item_Id    Number(20) NOT NULL,                          -- المادة
  Qnt        Number(17,3) DEFAULT 0,                       -- الكمية
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_OuTrn1_PK      PRIMARY KEY (Id),
  CONSTRAINT DStr_OuTrn1_Mst_FK  Foreign Key (Mst_Id  ) References DStr_OuMst1(Id),
  CONSTRAINT DStr_OuTrn1_Item_FK Foreign Key (Item_Id ) References DStr_Item  (Id),
  CONSTRAINT DStr_OuTrn1_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT DStr_OuTrn1_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym DStr_OuTrn1 For DStr_Outbound_Transaction1
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_OuMst2_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Outbound_Master2                         -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Trt_Id     Number(5) Default 200,                        -- نوع الحركة
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Acc_Id     Number(9) NOT NULL,                           -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Cost_Id    Number(9) NOT NULL,                           -- مركز الكلفة
  MNum       Number(9) NOT NULL,                           -- رقم الوثيقة
  MDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(20),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  RNum       Number(9),                                    -- رقم الوثيقة المرتبطة
  RDate      Date,                                         -- التاريخ المرتبط
  RDocN      Varchar2(20),                                 -- رقم المستند المرتبط
  RDocD      Date,                                         -- تاريخ المستند المرتبط
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT DStr_OuMst2_PK        PRIMARY KEY (Id),
  CONSTRAINT DStr_OuMst2_UK        Unique      (Period_Id, Stor_Id, MNum),
  CONSTRAINT DStr_OuMst2_Period_FK Foreign Key (Period_Id) References Cpy_Period  (Id),
  CONSTRAINT DStr_OuMst2_Trt_FK    Foreign Key (Trt_Id   ) References DStr_Cod_Trt(Id),
  CONSTRAINT DStr_OuMst2_Stor_FK   Foreign Key (Stor_Id  ) References DStr_Store  (Id),
  CONSTRAINT DStr_OuMst2_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc     (Id),
  CONSTRAINT DStr_OuMst2_Cost_FK   Foreign Key (Cost_Id  ) References Acc_cost    (Id),
  CONSTRAINT DStr_OuMst2_Doc_FK    Foreign Key (Doc_Id   ) References DStr_Cod_Doc(Id),
  CONSTRAINT DStr_OuMst2_Ins_FK    Foreign Key (Ins_User ) References Cpy_User    (Id),
  CONSTRAINT DStr_OuMst2_Upd_FK    Foreign Key (Upd_User ) References Cpy_User    (Id)
)
/
Create Synonym DStr_OuMst2 For DStr_Outbound_Master2
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_OuTrn2_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Outbound_Transaction2                    -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Mst_Id     Number(20) NOT NULL,                          -- مفتاح الأب
  Item_Id    Number(20) NOT NULL,                          -- المادة
  Qnt        Number(17,3) DEFAULT 0,                       -- الكمية
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_OuTrn2_PK      PRIMARY KEY (Id),
  CONSTRAINT DStr_OuTrn2_Mst_FK  Foreign Key (Mst_Id  ) References DStr_OuMst1(Id),
  CONSTRAINT DStr_OuTrn2_Item_FK Foreign Key (Item_Id ) References DStr_Item  (Id),
  CONSTRAINT DStr_OuTrn2_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT DStr_OuTrn2_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym DStr_OuTrn2 For DStr_Outbound_Transaction2
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_OuMst3_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Outbound_Master3                         -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Trt_Id     Number(5) Default 200,                        -- نوع الحركة
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  Acc_Id     Number(9) NOT NULL,                           -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Cost_Id    Number(9) NOT NULL,                           -- مركز الكلفة
  MNum       Number(9) NOT NULL,                           -- رقم الوثيقة
  MDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(20),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  RNum       Number(9),                                    -- رقم الوثيقة المرتبطة
  RDate      Date,                                         -- التاريخ المرتبط
  RDocN      Varchar2(20),                                 -- رقم المستند المرتبط
  RDocD      Date,                                         -- تاريخ المستند المرتبط
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT DStr_OuMst3_PK        PRIMARY KEY (Id),
  CONSTRAINT DStr_OuMst3_UK        Unique      (Period_Id, Stor_Id, MNum),
  CONSTRAINT DStr_OuMst3_Period_FK Foreign Key (Period_Id) References Cpy_Period  (Id),
  CONSTRAINT DStr_OuMst3_Trt_FK    Foreign Key (Trt_Id   ) References DStr_Cod_Trt(Id),
  CONSTRAINT DStr_OuMst3_Stor_FK   Foreign Key (Stor_Id  ) References DStr_Store  (Id),
  CONSTRAINT DStr_OuMst3_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc     (Id),
  CONSTRAINT DStr_OuMst3_Cost_FK   Foreign Key (Cost_Id  ) References Acc_cost    (Id),
  CONSTRAINT DStr_OuMst3_Doc_FK    Foreign Key (Doc_Id   ) References DStr_Cod_Doc(Id),
  CONSTRAINT DStr_OuMst3_Ins_FK    Foreign Key (Ins_User ) References Cpy_User    (Id),
  CONSTRAINT DStr_OuMst3_Upd_FK    Foreign Key (Upd_User ) References Cpy_User    (Id)
)
/
Create Synonym DStr_OuMst3 For DStr_Outbound_Master3
/
----------------------------------------------------------------------------------------------------
Create Sequence DStr_OuTrn3_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table DStr_Outbound_Transaction3                    -- ترويسة حركات الإدخال 
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Mst_Id     Number(20) NOT NULL,                          -- مفتاح الأب
  Item_Id    NUmber(20) NOT NULL,                          -- المادة
  Status_Id  Number(1) Default 2,                          -- الحالة إمكانية التعديل 1 يمكن تعديله ببرنامج التدقيق، 2 لا يمكن تعديله
  Qnt        Number(17,3) DEFAULT 0,                       -- الكمية
  Price      Number(17,2) DEFAULT 0,                       -- السعر
  Amt        Number(17,2) DEFAULT 0,                       -- القيمة
  Cst        Number(17,2) DEFAULT 0,                       -- الكلفة
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT DStr_OuTrn3_PK        PRIMARY KEY (Id),
  CONSTRAINT DStr_OuTrn3_Mst_FK    Foreign Key (Mst_Id   ) References DStr_OuMst1   (Id),
  CONSTRAINT DStr_OuTrn3_Item_FK   Foreign Key (Item_Id  ) References DStr_Item     (Id),
  CONSTRAINT DStr_OuTrn3_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT DStr_OuTrn3_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT DStr_OuTrn3_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym DStr_OuTrn3 For DStr_Outbound_Transaction3
/
