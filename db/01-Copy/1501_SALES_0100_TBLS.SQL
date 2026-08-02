--set Pagesize 1000
--select 'Drop table '   || table_name    || ';' from user_tables    where table_name    like 'SAL%';
--select 'Drop Synonym ' || Synonym_name  || ';' from user_Synonyms  where Synonym_name  like 'SAL%';
--select 'Drop Sequence '|| Sequence_name || ';' from user_Sequences where Sequence_name like 'SAL%';
--select 'Drop View '    || View_name     || ';' from user_Views     where View_name     like 'SAL%';
----------------------------------------------------------------------------------------------------
Create Table Sal_Code_Status                               -- جدول ترميز حالة الأمر
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Sal_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Sal_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Sal_Cod_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Sal_Cod_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Sal_Cod_Status For Sal_Code_Status
/
Insert into Sal_Cod_Status (Id,Name) values (0,'-'     );
Insert into Sal_Cod_Status (Id,Name) values (1,'Freez' );
Insert into Sal_Cod_Status (Id,Name) values (2,'Cancel');
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Create Table Sal_Code_Commission                           -- جدول ترميز العمولات
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Sal_Cod_Comm_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Sal_Cod_Comm_UK     UNIQUE      (Name),
  CONSTRAINT Sal_Cod_Comm_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Sal_Cod_Comm_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Sal_Cod_Comm For Sal_Code_Commission
/
Insert into Sal_Cod_Comm (Id,Name) values (0,'-'     );
Insert into Sal_Cod_Comm (Id,Name) values (1,'Amount' );
Insert into Sal_Cod_Comm (Id,Name) values (2,'Percent');
----------------------------------------------------------------------------------------------------
Create Table Sal_Code_Price_Type   		                     -- جدول ترميز أنواع الأسعار
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Sal_Cod_Price_Type_PK PRIMARY KEY (Id  ),
  CONSTRAINT Sal_Cod_Price_Type_UK UNIQUE      (Name)
)
/
Create Synonym Sal_Cod_Price_Type For Sal_Code_Price_Type
/
Insert into Sal_Cod_Price_Type (Id,Name) values (0,'Amount' );
Insert into Sal_Cod_Price_Type (Id,Name) values (1,'Percent');
----------------------------------------------------------------------------------------------------
Create Sequence Sal_Price_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Sal_Price_List                                -- جدول قوائم الأسعار
( Id         Number(5) NOT NULL,                           -- الرقم
  dDate      Date NOT NULL,                                -- تاريخ
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(20), Ins_Date   Date,
  Upd_User   Number(20), Upd_Date   Date,
  CONSTRAINT Sal_Price_PK      PRIMARY KEY (Id),
  CONSTRAINT Sal_Price_Uk      Unique      (Name),
  CONSTRAINT Sal_Price_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Sal_Price_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Sal_Price For Sal_Price_List
/
Create Sequence Sal_Price_Item_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Sal_Price_Items                               -- جدول أسعار المواد
( Id          Number(10) NOT NULL,                         -- مفتاح رئيسي
  Price_Id    Number(5) NOT NULL,                          -- مفتاح الأب
  Item_Id     Number(10) NOT NULL,                         -- المادة
  Type_Id     Number(1) Default 0,                         -- طبيعة السعر
  Amt         Number(17,3),                                -- السعر
  Ins_User    Number(20), Ins_Date   Date,
  Upd_User    Number(20), Upd_Date   Date,
  CONSTRAINT  Sal_Price_Item_PK      PRIMARY KEY (Id),
  CONSTRAINT  Sal_Price_Item_Uk      Unique      (Price_Id, Item_Id),
  CONSTRAINT  Sal_Price_Item_IPrc_FK Foreign Key (Price_Id) References Sal_Price         (Id),
  CONSTRAINT  Sal_Price_Item_Item_FK Foreign Key (Item_Id ) References Stor_Item         (Id),
  CONSTRAINT  Sal_Price_Item_Type_FK Foreign Key (Type_Id ) References Sal_Cod_Price_Type(Id),
  CONSTRAINT  Sal_Price_Item_Ins_FK  Foreign Key (Ins_User) References Cpy_User          (Id),
  CONSTRAINT  Sal_Price_Item_Upd_FK  Foreign Key (Upd_User) References Cpy_User          (Id)
)
/
Create Synonym Sal_Price_Item For Sal_Price_Items
/
----------------------------------------------------------------------------------------------------
Create Sequence Sal_MSal_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Sal_Sales_Mst                                 -- ترويسة وثائق المبيعات
( Id         Number(9) NOT NULL,				                   -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Status_Id  Number(1) Default 0 NOT NULL,                 -- الحالة
  Rel_Id     Number(10),                                   -- مفتاح الأمر المشكل نتيجة تثبيت هذه الحركة
  Fin_Id     Number(10),                                   -- مفتاح الورقة المالية
  Cont_Id    Number(5) NOT NULL,				                   -- المتعامل/المورد
  Curn_Id    Number(5) NOT NULL,                           -- العملة
  Acc_Id     Number(9) NOT NULL,                           -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  BCurn_Id   Number(5) Default 1,                          -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                       -- سعر الصرف
  Regn_Id    Number(5),                                    -- المنطقة
  Repr_Id    Number(5),                                    -- المندوب
  Cmt_Id     Number(1) Default 1,                          -- نوع العمولة
  Cmv        Number(17,3),                                 -- نسبة العمولة
  Com        Number(17,3),                                 -- العمولة
  BCom       Number(17,3),                                 -- العمولة الأساس
  Ccom       Number(17,3),                                 -- العمولة قطع
  Rate       Number(10,0) Default 0 NOT NULL,              -- سعر الصرف
  Num        Number(10) Default 0,                         -- الرقم
  dDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(15),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Sal_MSal_PK        PRIMARY KEY (Id),
  CONSTRAINT Sal_MSal_Period_FK Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT Sal_MSal_Status_FK Foreign Key (Status_Id) References Sal_Cod_Status(Id),
  CONSTRAINT Sal_MSal_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT Sal_MSal_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Sal_MSal_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn      (Id),
  CONSTRAINT Sal_MSal_Regn_FK   Foreign Key (Regn_Id  ) References Mng_Regn      (Id),
  CONSTRAINT Sal_MSal_Cmt_FK    Foreign Key (Cmt_Id   ) References Sal_Cod_Comm  (Id),
  CONSTRAINT Sal_MSal_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT Sal_MSal_Fin_FK    Foreign Key (Fin_Id   ) References Fin_MCrd      (Id),
  CONSTRAINT Sal_MSal_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc   (Id),
  CONSTRAINT Sal_MSal_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Sal_MSal_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Sal_MSal For Sal_Sales_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Sal_TSal_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Sal_Sales_Trn                                 -- بنود وثائق المبيعات
( Id         Number(9) NOT NULL,				                   -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                   -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,				                   -- المادة
  Ord        Number(5) Default 0,                          -- مسلسل
  Qnt        Number(25,3) Default 0,                       -- الكمية
  WQnt       Number(25,3) Default 0,                       -- الوزن
  SWQnt      Number(25,3) Default 0,                       -- الوزن بوحدة التخزين
  Price      Number(25,2) Default 0,                       -- السعر
  CAmt       Number(25,2) Default 0,                       -- القيمة بالعملة
  Amt        Number(25,2) Default 0,                       -- القيمة محلي
  BAmt       Number(25,2) Default 0,                       -- القيمة بعملة الأساس
  Vat_Perc   Number(6,2) Default 0,                        -- نسبة الVAT
  Vat_Value  Number(25,2) Default 0,                       -- فيمة الVAT
  ICS_Id     Number(30),                                   -- مفتاح الباركود 
  SICS_Id    Number(30),                                   -- مفتاح الباركود في المستودع
  Unit_Id    Number(5) Default 0,                          -- الوحدة
  Model_Id   Number(5) Default 0,                          -- الموديل
  Color_Id   Number(5) Default 0,                          -- اللون 
  Size_Id    Number(5) Default 0,                          -- القياس 
  nLength    Number(25,2) Default 0,                       -- الطول
  nWidth     Number(25,2) Default 0,                       -- العرض
  nHeight    Number(25,2) Default 0,                       -- الارتفاع
  Barcode    Varchar2(50 Char),                            -- مسطرة الترميز
  LotSer     Varchar2(50 Char),                            -- طبخة/مسلسل
  SDate      Date,                                         -- تاريخ بداية
  EDate      Date,                                         -- تاريخ نهاية
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Sal_TSal_PK       PRIMARY KEY (Id),
  CONSTRAINT Sal_TSal_Pur_FK   Foreign Key (Mst_Id  ) References Sal_MSal      (Id),
  CONSTRAINT Sal_TSal_Item_FK  Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT Sal_TSal_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT Sal_TSal_Model_FK Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT Sal_TSal_Color_FK Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT Sal_TSal_Size_FK  Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT Sal_TSal_Ins_FK   Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Sal_TSal_Upd_FK   Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Sal_TSal For Sal_Sales_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Sal_MRet_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Sal_Return_Mst                                -- ترويسة مردود مبيعات
( Id         Number(9) NOT NULL,				                   -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                           -- فترة العمل
  Status_Id  Number(1) Default 0 NOT NULL,                 -- الحالة
  Cont_Id    Number(5) NOT NULL,				                   -- المتعامل/المورد
  Curn_Id    Number(5) NOT NULL,                           -- العملة
  Acc_Id     Number(9) NOT NULL,                           -- الحساب
  Doc_Id     Number(5) Default 0 NOT NULL,                 -- نوع المستند
  Regn_Id    Number(5),                                    -- المنطقة
  Repr_Id    Number(5),                                    -- المندوب
  Cmt_Id     Number(1) Default 1,                          -- نوع العمولة
  Cmv        Number(17,3),                                 -- نسبة العمولة
  Com        Number(17,3),                                 -- العمولة
  BCom       Number(17,3),                                 -- العمولة الأساس
  CCom       Number(17,3),                                 -- العمولة قطع
  BCurn_Id   Number(5) Default 1,                          -- عملة الأساس
  BCurn_Rate Number(25,8) Default 1,                       -- سعر الصرف
  Rel_Id     Number(10),                                   -- مفتاح الأمر المشكل نتيجة تثبيت هذه الحركة
  Fin_Id     Number(10),                                   -- مفتاح الورقة المالية
  Rate       Number(10,0) Default 0 NOT NULL,              -- سعر الصرف
  Num        Number(10) Default 0,                         -- الرقم
  dDate      Date NOT NULL,                                -- التاريخ
  DocN       Varchar2(15),                                 -- رقم المستند
  DocD       Date,                                         -- تاريخ المستند
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Sal_MRet_PK      PRIMARY KEY (Id),
  CONSTRAINT Sal_MRet_Period_FK Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT Sal_MRet_Status_FK Foreign Key (Status_Id) References Sal_Cod_Status(Id),
  CONSTRAINT Sal_MRet_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT Sal_MRet_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Sal_MRet_BCurn_FK  Foreign Key (BCurn_Id ) References Mng_Curn      (Id),
  CONSTRAINT Sal_MRet_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT Sal_MRet_Fin_FK    Foreign Key (Fin_Id   ) References Fin_MCrd      (Id),
  CONSTRAINT Sal_MRet_Doc_FK    Foreign Key (Doc_Id   ) References Cpy_Cod_Doc   (Id),
  CONSTRAINT Sal_MRet_Regn_FK   Foreign Key (Regn_Id  ) References Mng_Regn      (Id),
  CONSTRAINT Sal_MRet_Cmt_FK    Foreign Key (Cmt_Id   ) References Sal_Cod_Comm  (Id),
  CONSTRAINT Sal_MRet_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Sal_MRet_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Sal_MRet For Sal_Return_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Sal_TRet_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Sal_Return_Trn                                -- بنود مردود مبيعات
( Id         Number(9) NOT NULL,				                   -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                   -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,				                   -- المادة
  Ord        Number(5) Default 0,                          -- مسلسل
  Qnt        Number(25,3) Default 0,                       -- الكمية
  WQnt       Number(25,3) Default 0,                       -- الوزن
  SWQnt      Number(25,3) Default 0,                       -- الوزن بوحدة التخزين
  Price      Number(25,2) Default 0,                       -- السعر
  CAmt       Number(25,2) Default 0,                       -- القيمة بالعملة
  Amt        Number(25,2) Default 0,                       -- القيمة محلي
  BAmt       Number(25,2) Default 0,                       -- القيمة بعملة الأساس
  Vat_Perc   Number(6,2) Default 0,                        -- نسبة الVAT
  Vat_Value  Number(25,2) Default 0,                       -- فيمة الVAT
  ICS_Id     Number(30),                                   -- مفتاح الباركود 
  SICS_Id    Number(30),                                   -- مفتاح الباركود في المستودع
  Unit_Id    Number(5) Default 0,                          -- الوحدة
  Model_Id   Number(5) Default 0,                          -- الموديل
  Color_Id   Number(5) Default 0,                          -- اللون 
  Size_Id    Number(5) Default 0,                          -- القياس 
  nLength    Number(25,2) Default 0,                       -- الطول
  nWidth     Number(25,2) Default 0,                       -- العرض
  nHeight    Number(25,2) Default 0,                       -- الارتفاع
  Barcode    Varchar2(50 Char),                            -- مسطرة الترميز
  LotSer     Varchar2(50 Char),                            -- طبخة/مسلسل
  SDate      Date,                                         -- تاريخ بداية
  EDate      Date,                                         -- تاريخ نهاية
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT SAL_TRet_PK       PRIMARY KEY (Id),
  CONSTRAINT SAL_TRet_Pur_FK   Foreign Key (Mst_Id  ) References Sal_MRet      (Id),
  CONSTRAINT SAL_TRet_Item_FK  Foreign Key (Item_Id ) References Stor_Item     (Id),
  CONSTRAINT SAL_TRet_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT SAL_TRet_Model_FK Foreign Key (Model_Id) References Stor_Cod_Model(Id),
  CONSTRAINT SAL_TRet_Color_FK Foreign Key (Color_Id) References Stor_Cod_Color(Id),
  CONSTRAINT SAL_TRet_Size_FK  Foreign Key (Size_Id ) References Stor_Cod_Size (Id),
  CONSTRAINT SAL_TRet_Ins_FK   Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT SAL_TRet_Upd_FK   Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Sal_TRet For Sal_Return_Trn
/