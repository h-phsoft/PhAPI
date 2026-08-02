--set Pagesize 1000
--select 'Drop table '   || table_name    || ';' from user_tables    where table_name    like 'PUR%' ;
--select 'Drop Synonym ' || Synonym_name  || ';' from user_Synonyms  where Synonym_name  like 'PUR%' ;
--select 'Drop Sequence '|| Sequence_name || ';' from user_Sequences where Sequence_name like 'PUR%' ;
--select 'Drop View '    || View_name     || ';' from user_Views     where View_name     like 'PUR%' ;
----------------------------------------------------------------------------------------------------
Create Table Pur_Code_Status                        -- جدول ترميز حالة الأمر
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Pur_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Pur_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Pur_Cod_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Pur_Cod_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Pur_Cod_Status For Pur_Code_Status
/
Insert into Pur_Cod_Status (Id,Name) values (0,'-'       );
Insert into Pur_Cod_Status (Id,Name) values (1,'Commited');
Insert into Pur_Cod_Status (Id,Name) values (2,'Freez'   );
----------------------------------------------------------------------------------------------------
Create Sequence Pur_MPur_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Pur_Purchase_Mst                             -- جدول ترويسة الشراء
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                          -- فترة العمل
  Status_Id  Number(1) Default 0 NOT NULL,                -- الحالة
  Cont_Id    Number(5) NOT NULL,				                  -- المتعامل/المورد
  Curn_Id    Number(5) NOT NULL,                          -- العملة
  Acc_Id     Number(9) NOT NULL,                          -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                -- نوع المستند
  BCurn_Id   Number(5) Default 1,                         -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                      -- سعر الصرف
  Rel_Id     Number(10),                                  -- مفتاح الأمر المشكل نتيجة تثبيت هذه الحركة
  Fin_Id     Number(10),                                  -- مفتاح الورقة المالية
  Rate       Number(10,0) Default 0 NOT NULL,             -- سعر الصرف
  Num        Number(10) Default 0,                        -- الرقم
  dDate      Date NOT NULL,                               -- التاريخ
  DocN       Varchar2(15),                                -- رقم المستند
  DocD       Date,                                        -- تاريخ المستند
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Pur_MPur_PK        PRIMARY KEY (Id),
  CONSTRAINT Pur_MPur_Period_FK Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT Pur_MPur_Status_FK Foreign Key (Status_Id) References Pur_Cod_Status(Id),
  CONSTRAINT Pur_MPur_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT Pur_MPur_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Pur_MPur_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn      (Id),
  CONSTRAINT Pur_MPur_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT Pur_MPur_Fin_FK    Foreign Key (Fin_Id   ) References Fin_MCrd      (Id),
  CONSTRAINT Pur_MPur_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc   (Id),
  CONSTRAINT Pur_MPur_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Pur_MPur_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Pur_MPur For Pur_Purchase_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Pur_TPur_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Pur_Purchase_Trn                             -- جدول بنود الشراء
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Ord        Number(5) Default 0,                         -- مسلسل
  Qnt        Number(25,3) Default 0,                      -- الكمية
  WQnt       Number(25,3) Default 0,                      -- الوزن
  SWQnt      Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price      Number(25,2) Default 0,                      -- السعر
  CAmt       Number(25,2) Default 0,                      -- القيمة بالعملة
  Amt        Number(25,2) Default 0,                      -- القيمة محلي
  BAmt       Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  Vat_Perc   Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value  Number(25,2) Default 0,                      -- فيمة الVAT
  ICS_Id     Number(30),                                  -- مفتاح الباركود 
  SICS_Id    Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id    Number(5) Default 0,                         -- الوحدة
  Model_Id   Number(5) Default 0,                         -- الموديل
  Color_Id   Number(5) Default 0,                         -- اللون 
  Size_Id    Number(5) Default 0,                         -- القياس 
  nLength    Number(25,2) Default 0,                      -- الطول
  nWidth     Number(25,2) Default 0,                      -- العرض
  nHeight    Number(25,2) Default 0,                      -- الارتفاع
  Barcode    Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer     Varchar2(50 Char),                           -- طبخة/مسلسل
  SDate      Date,                                        -- تاريخ بداية
  EDate      Date,                                        -- تاريخ نهاية
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Pur_TPur_PK       PRIMARY KEY (Id),
  CONSTRAINT Pur_TPur_Pur_FK   Foreign Key (Mst_Id  ) References Pur_MPur      (Id),
  CONSTRAINT Pur_TPur_Item_FK  Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT Pur_TPur_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT Pur_TPur_Model_FK Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT Pur_TPur_Color_FK Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT Pur_TPur_Size_FK  Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT Pur_TPur_Ins_FK   Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Pur_TPur_Upd_FK   Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Pur_TPur For Pur_Purchase_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Pur_MRet_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Pur_Return_Mst                               -- جدول ترويسة المرتجع
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                          -- فترة العمل
  Status_Id  Number(1) Default 0 NOT NULL,                -- الحالة
  Cont_Id    Number(5) NOT NULL,				                  -- المتعامل/المورد
  Curn_Id    Number(5) NOT NULL,                          -- العملة
  Acc_Id     Number(9) NOT NULL,                          -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                -- نوع المستند
  BCurn_Id   Number(5) Default 1,                         -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                      -- سعر الصرف
  Rel_Id     Number(10),                                  -- مفتاح الأمر المشكل نتيجة تثبيت هذه الحركة
  Fin_Id     Number(10),                                  -- مفتاح الورقة المالية
  Rate       Number(10,0) Default 0 NOT NULL,             -- سعر الصرف
  Num        Number(10) Default 0,                        -- الرقم
  dDate      Date NOT NULL,                               -- التاريخ
  DocN       Varchar2(15),                                -- رقم المستند
  DocD       Date,                                        -- تاريخ المستند
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Pur_MRet_PK      PRIMARY KEY (Id),
  CONSTRAINT Pur_MRet_Period_FK Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT Pur_MRet_Status_FK Foreign Key (Status_Id) References Pur_Cod_Status(Id),
  CONSTRAINT Pur_MRet_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT Pur_MRet_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Pur_MRet_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn      (Id),
  CONSTRAINT Pur_MRet_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT Pur_MRet_Fin_FK    Foreign Key (Fin_Id   ) References Fin_MCrd      (Id),
  CONSTRAINT Pur_MRet_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc   (Id),
  CONSTRAINT Pur_MRet_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Pur_MRet_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Pur_MRet For Pur_Return_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Pur_TRet_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Pur_Return_Trn                             -- جدول بنود الشراء
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Ord        Number(5) Default 0,                         -- مسلسل
  Qnt        Number(25,3) Default 0,                      -- الكمية
  WQnt       Number(25,3) Default 0,                      -- الوزن
  SWQnt      Number(25,3) Default 0,                      -- الوزن بوحدة التخزين
  Price      Number(25,2) Default 0,                      -- السعر
  CAmt       Number(25,2) Default 0,                      -- القيمة بالعملة
  Amt        Number(25,2) Default 0,                      -- القيمة محلي
  BAmt       Number(25,2) Default 0,                      -- القيمة بعملة الأساس
  Vat_Perc   Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value  Number(25,2) Default 0,                      -- فيمة الVAT
  ICS_Id     Number(30),                                  -- مفتاح الباركود 
  SICS_Id    Number(30),                                  -- مفتاح الباركود في المستودع
  Unit_Id    Number(5) Default 0,                         -- الوحدة
  Model_Id   Number(5) Default 0,                         -- الموديل
  Color_Id   Number(5) Default 0,                         -- اللون 
  Size_Id    Number(5) Default 0,                         -- القياس 
  nLength    Number(25,2) Default 0,                      -- الطول
  nWidth     Number(25,2) Default 0,                      -- العرض
  nHeight    Number(25,2) Default 0,                      -- الارتفاع
  Barcode    Varchar2(50 Char),                           -- مسطرة الترميز
  LotSer     Varchar2(50 Char),                           -- طبخة/مسلسل
  SDate      Date,                                        -- تاريخ بداية
  EDate      Date,                                        -- تاريخ نهاية
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Pur_TRet_PK       PRIMARY KEY (Id),
  CONSTRAINT Pur_TRet_Pur_FK   Foreign Key (Mst_Id  ) References Pur_MRet      (Id),
  CONSTRAINT Pur_TRet_Item_FK  Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT Pur_TRet_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT Pur_TRet_Model_FK Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT Pur_TRet_Color_FK Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT Pur_TRet_Size_FK  Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT Pur_TRet_Ins_FK   Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Pur_TRet_Upd_FK   Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Pur_TRet For Pur_Return_Trn
/
----------------------------------------------------------------------------------------------------
