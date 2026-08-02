
Create Table Sal_Sample_Master    -- ترويسة النماذج والهدايا
( Imst_Id     Number(10),    -- مفتاح رئيسي
  Imst_Year   Number(4),    -- السنة
  Imst_Typ    Number(4) Default 0,  -- أصل الوثيقة
  Bran_Id     Number(10),    -- الفرع
  Imst_Num    Number(15),    -- رقم الوثيقة
  Imst_Date   Date,      -- التاريخ
  Imst_Doc    Number(5),    -- نوع المستند
  Imst_Docn   VarChar2(10 Char),    -- رقم المستند
  Imst_Docd   Date,      -- تاريخ المستند
  Imst_Commit Number(1) Default 1,  -- حالة التثبيت
  Perm_Grp    Number(2) Default 99,  -- مجموعة العمل
  Perm_Lvl    Number(2) Default 9,  -- المستوى
  GACC_ID     NUMBER(10),               -- الحساب  
  Cost_ID     NUMBER(10),               -- مركز الكلفة
  Cont_Id     Number(10) NOT NULL,  -- الزبون
  Curn_Id     Number(5) Default 1,  -- العملة
  Curn_Rate   Number(17,9),    -- سعر الصرف
  Pric_Num    Number(5) Default 1,  -- نوع سعر البيع
  Regn_Id     Number(10),    -- المنطقة
  Repr_Id     Number(10),    -- المندوب
  Imst_Cmt    Number(5) Default -1,  -- نوع العمولة
  Imst_Cmv    Number(17,3),    -- نسبة العمولة
  Imst_Com    Number(17,3),    -- العمولة
  Imst_CCom   Number(17,3),    -- العمولة قطع
  Imst_Rem    VarChar2(100 Char),    -- ملاحظات
  GMst_Id     Number(10),    -- سند القيد
  Ins_User    Number(20), Ins_Date   Date,
  Upd_User    Number(20), Upd_Date   Date,
  CONSTRAINT  Sal_SamMst_PK      PRIMARY KEY (Imst_Id ),
  CONSTRAINT  Sal_SamMst_UK      Unique      (Bran_Id,Imst_Year,Imst_Num),
  CONSTRAINT  Sal_SamMst_Year_FK Foreign Key (Imst_Year) References Cpy_Year (Year_Year),
  CONSTRAINT  Sal_SamMst_Bran_FK Foreign Key (Bran_Id  ) References Cpy_Bran (Bran_Id  ),
  CONSTRAINT  Sal_SamMst_Cust_FK Foreign Key (Cont_Id  ) References Mng_Cont (Cont_Id  ),
  CONSTRAINT  Sal_SamMst_Repr_FK Foreign Key (Repr_Id  ) References CRM_Repr (Repr_Id  ),
  CONSTRAINT  Sal_SamMst_Regn_FK Foreign Key (Regn_Id  ) References Mng_Regn (Regn_Id  ),
  CONSTRAINT  Sal_SamMst_Gacc_FK Foreign Key (Gacc_Id  ) References Acc_Acc  (Gacc_Id  ),
  CONSTRAINT  Sal_SamMst_Cost_FK Foreign Key (Cost_Id  ) References Acc_Cost (Cost_Id  ),
  CONSTRAINT  Sal_SamMst_Curn_FK Foreign Key (Curn_Id  ) References Mng_Curn (Curn_Id  ),
  CONSTRAINT  Sal_SamMst_GMst_FK Foreign Key (GMst_Id  ) References Acc_Mst  (GMst_Id  ),
  CONSTRAINT  Sal_SamMst_Ins_FK  Foreign Key (Ins_User ) References Cpy_User (User_Id  ),
  CONSTRAINT  Sal_SamMst_Upd_FK  Foreign Key (Upd_User ) References Cpy_User (User_Id  )
)
/
Create Synonym Sal_samMst For Sal_Sample_Master
/

Create Table Sal_Sample_Trans    -- بنود النماذج والهدايا
( Itrn_Id    Number(10),    -- مفتاح رئيسي
  Imst_Id    Number(10),    -- مفتاح الأب
  Itrn_Ord   Number(5),      -- مسلسل
  Stor_Id    Number(5),      -- المخزن
  Item_Id    Number(10),    -- المادة
  Itrn_Size  Number(5) Default 0,  -- القياس
  Itrn_Color Number(5) Default 0,  -- اللون
  Itrn_Qnt   Number(17,3),    -- الكمية
  Itrn_SQnt  Number(17,3),    -- الكمية بوحدة التخزين
  Itrn_Unt   Number(5),      -- الوحدة
  Itrn_Perc  Number(10,5) Default 1,  -- نسبة الوحدة إلى وحدة التخزين
  Itrn_UPric Number(17,3),    -- سعر الوحدة
  Itrn_Amt   Number(17,3),    -- المبلغ
  Itrn_CAmt  Number(17,3),    -- المبلغ قطع
  Itrn_Cst   Number(17,3),    -- الكلفة
  Itrn_CCst  Number(17,3),    -- الكلفة قطع
  Itrn_QDis  Number(17,3),    -- كمية الحسم/الهدية
  Itrn_SQDis Number(17,3),    -- كمية الحسم/الهدية بوحدة التخزين
  Itrn_CDis  Number(17,3),    -- كلفة الحسم/الهدايا
  Itrn_CCDis Number(17,3),    -- كلفة الحسم قطع/ الهدايا
  Itrn_ADis  Number(17,3),    -- قيمة الحسم
  Itrn_ACDis Number(17,3),    -- قيمة الحسم قطع
  Itrn_AAdd  Number(17,3),    -- القيمة المضافة
  Itrn_ACAdd Number(17,3),    -- القيمة المضافة قطع
  Itrn_Rem   VarChar2(100 Char),    -- ملاحظات
  Ins_User   Number(20),  Ins_Date    Date,
  Upd_User   Number(20),  Upd_Date    Date,
  CONSTRAINT Sal_SamTrn_PK      PRIMARY KEY (Itrn_Id ),
  CONSTRAINT Sal_SamTrn_UK      Unique      (Imst_Id,Itrn_ord),
  CONSTRAINT Sal_SamTrn_Imst_FK Foreign Key (Imst_Id ) References Sal_SamMst(Imst_Id),
  CONSTRAINT Sal_SamTrn_Stor_FK Foreign Key (Stor_Id ) References Stor_Store(Stor_Id),
  CONSTRAINT Sal_SamTrn_Item_FK Foreign Key (Item_Id ) References Stor_Item (Item_Id),
  CONSTRAINT Sal_SamTrn_Ins_FK  Foreign Key (Ins_User) References Cpy_User  (User_Id),
  CONSTRAINT Sal_SamTrn_Upd_FK  Foreign Key (Upd_User) References Cpy_User  (User_Id)
)
/
Create Synonym Sal_SamTrn For Sal_Sample_Trans
/

Create Table Sal_RetSample_Master  -- ترويسة مردود هدايا وعينات
( Imst_Id     Number(10),    -- مفتاح رئيسي
  Imst_Num    Number(15),    -- رقم الوثيقة
  Imst_Year   Number(4),    -- السنة
  Bran_Id     Number(10),    -- الفرع
  Imst_Typ    Number(4) Default 0,  -- أصل الوثيقة
  Imst_Date   Date,      -- التاريخ
  Imst_Doc    Number(5),    -- نوع المستند
  Imst_Docn   VarChar2(10 Char),    -- رقم المستند
  Imst_Docd   Date,      -- تاريخ المستند
  Imst_Commit Number(1) Default 1,  -- حالة التثبيت
  Perm_Grp    Number(2) Default 99,  -- مجموعة العمل
  Perm_Lvl    Number(2) Default 9,  -- المستوى
  GACC_ID     NUMBER(10),               -- الحساب  
  Cost_ID     NUMBER(10),               -- مركز الكلفة
  Cont_Id     Number(10) NOT NULL,  -- الزبون
  Curn_Id     Number(5) Default 1,  -- عملة الزبون
  Curn_Rate   Number(17,9),    -- سعر الصرف
  Pric_Type   Number(5) Default 1,  -- نوع سعر البيع
  Imst_Amt    Number(17,3),    -- القيمة محلية
  Imst_CAmt   Number(17,3),    -- القيمة عملة
  Regn_Id     Number(10),    -- المنطقة
  Repr_Id     Number(10),    -- المندوب
  Imst_Cmt    Number(5) Default -1,  -- نوع العمولة
  Imst_Cmv    Number(17,3),    -- نسبة العمولة
  Imst_Com    Number(17,3),    -- العمولة
  Imst_CCom   Number(17,3),    -- العمولة قطع
  GMst_Id     Number(10),    -- سند القيد
  Imst_Rem    VarChar2(100 Char),    -- ملاحظات
  Ins_User    Number(20), Ins_Date   Date,
  Upd_User    Number(20), Upd_Date   Date,
  CONSTRAINT  Sal_RetSMst_PK      PRIMARY KEY (Imst_Id ),
  CONSTRAINT  Sal_RetSMst_UK      Unique      (Bran_Id,Imst_Year,Imst_Num),
  CONSTRAINT  Sal_RetSMst_Year_FK Foreign Key (Imst_Year) References Cpy_Year (Year_Year),
  CONSTRAINT  Sal_RetSMst_Bran_FK Foreign Key (Bran_Id  ) References Cpy_Bran (Bran_Id  ),
  CONSTRAINT  Sal_RetSMst_Cust_FK Foreign Key (Cont_Id  ) References Mng_Cont (Cont_Id  ),
  CONSTRAINT  Sal_RetSMst_Repr_FK Foreign Key (Repr_Id  ) References CRM_Repr (Repr_Id  ),
  CONSTRAINT  Sal_RetSMst_Gacc_FK Foreign Key (Gacc_Id  ) References Acc_Acc  (Gacc_Id  ),
  CONSTRAINT  Sal_RetSMst_Cost_FK Foreign Key (Cost_Id  ) References Acc_Cost (Cost_Id  ),
  CONSTRAINT  Sal_RetSMst_Regn_FK Foreign Key (Regn_Id  ) References Mng_Regn (Regn_Id  ),
  CONSTRAINT  Sal_RetSMst_GMst_FK Foreign Key (GMst_Id  ) References Acc_Mst  (GMst_Id  ),
  CONSTRAINT  Sal_RetSMst_Curn_FK Foreign Key (Curn_Id  ) References Mng_Curn (Curn_Id  ),
  CONSTRAINT  Sal_RetSMst_Ins_FK  Foreign Key (Ins_User ) References Cpy_User (User_Id  ),
  CONSTRAINT  Sal_RetSMst_Upd_FK  Foreign Key (Upd_User ) References Cpy_User (User_Id  )
)
/
Create Synonym Sal_RetSMst For Sal_RetSample_Master
/

Create Table Sal_RetSample_Trans  -- بنود مردود هدايا وعينات
( Itrn_Id     Number(10),    -- مفتاح رئيسي
  Imst_Id     Number(10),    -- مفتاح الأب
  Itrn_Ord    Number(5),    -- مسلسل
  Stor_Id     Number(5),    -- المخزن
  Item_Id     Number(10),    -- المادة
  Itrn_Size   Number(5) Default 0,  -- القياس
  Itrn_Color  Number(5) Default 0,  -- اللون
  Itrn_Qnt    Number(17,3),    -- الكمية
  Itrn_SQnt   Number(17,3),    -- الكمية بوحدة التخزين
  Itrn_Unt    Number(5),    -- الوحدة
  Itrn_Perc   Number(10,5) Default 1,  -- نسبة الوحدة إلى وحدة التخزين
  Itrn_UPric  Number(17,3),    -- سعر الوحدة
  Itrn_Amt    Number(17,3),    -- المبلغ
  Itrn_CAmt   Number(17,3),    -- المبلغ قطع
  Itrn_Cst    Number(17,3),    -- الكلفة
  Itrn_CCst   Number(17,3),    -- الكلفة قطع
  Itrn_QDis   Number(17,3),    -- كمية الحسم/الهدية
  Itrn_SQDis  Number(17,3),    -- كمية الحسم/الهدية بوحدة التخزين
  Itrn_CDis   Number(17,3),    -- كلفة الحسم/الهدايا
  Itrn_CCDis  Number(17,3),    -- كلفة الحسم قطع/ الهدايا
  Itrn_ADis   Number(17,3),    -- قيمة الحسم
  Itrn_ACDis  Number(17,3),    -- قيمة الحسم قطع
  Itrn_AAdd   Number(17,3),    -- القيمة المضافة
  Itrn_ACAdd  Number(17,3),    -- القيمة المضافة قطع
  Itrn_Rem    VarChar2(100 Char),    -- ملاحظات
  Ins_User    Number(20),  Ins_Date    Date,
  Upd_User    Number(20),  Upd_Date    Date,
  CONSTRAINT  Sal_RetSTrn_PK      PRIMARY KEY (Itrn_Id ),
  CONSTRAINT  Sal_RetSTrn_UK      Unique      (Imst_Id,Itrn_ord),
  CONSTRAINT  Sal_RetSTrn_Imst_FK Foreign Key (Imst_Id ) References Sal_RetSMst(Imst_Id),
  CONSTRAINT  Sal_RetSTrn_Item_FK Foreign Key (Item_Id ) References Stor_Item  (Item_Id),
  CONSTRAINT  Sal_RetSTrn_Ins_FK  Foreign Key (Ins_User) References Cpoy_User  (User_Id),
  CONSTRAINT  Sal_RetSTrn_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (User_Id)
)
/
Create Synonym Sal_RetSTrn For Sal_RetSample_Trans
/
