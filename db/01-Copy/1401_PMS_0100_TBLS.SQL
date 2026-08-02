--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'PMS%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'PMS%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'PMS%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'PMS%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'PMS%' ;
----------------------------------------------------------------------------------------------------
Create Table PMS_Code_Status                              -- جدول ترميز حالة الطلب
( Id         Number(1) NOT NULL,				                  -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                  -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				          -- الاسم
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PMS_Cod_Status_PK        PRIMARY KEY (Id  ),
  CONSTRAINT PMS_Cod_Status_UK        UNIQUE      (Name),
  CONSTRAINT PMS_Cod_Status_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT PMS_Cod_Status_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PMS_Cod_Status_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PMS_Cod_Status For PMS_Code_Status
/
Insert into PMS_Cod_Status (Id,Name) values (0,'-');
Insert into PMS_Cod_Status (Id,Name) values (1,'جديد');
Insert into PMS_Cod_Status (Id,Name) values (2,'موافقة مدير');
Insert into PMS_Cod_Status (Id,Name) values (3,'موافقة آمر الشراء');
Insert into PMS_Cod_Status (Id,Name) values (4,'مرفوض');
Insert into PMS_Cod_Status (Id,Name) values (5,'ملغى');
Insert into PMS_Cod_Status (Id,Name) values (6,'تم');
----------------------------------------------------------------------------------------------------
Create Sequence PMS_MReq_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table PMS_Request_Mst                              -- جدول ترويسة الطلب
( Id          Number(9) NOT NULL,				                  -- مفتاح رئيسي
  User_Id     Number(5) Default 1,				                -- المستخدم
  Status_Id   Number(1) Default 1,				                -- الحالة
  Status_Date Date,                                       -- تاريخ الحالة
  Num         Number(10) Default 0,                       -- الرقم
  dDate       Date,                                       -- التاريخ
  Rem         Varchar2(100 Char),          				        -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  PMS_MReq_PK        PRIMARY KEY (Id ),
  CONSTRAINT  PMS_MReq_UK        UNIQUE      (Num),
  CONSTRAINT  PMS_MReq_Status_FK Foreign Key (Status_Id) References PMS_Cod_Status(Id),
  CONSTRAINT  PMS_MReq_User_FK   Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT  PMS_MReq_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  PMS_MReq_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PMS_MReq For PMS_Request_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence PMS_TReq_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table PMS_Request_Trn                              -- جدول بنود الطلب
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Qnt        Number(25,3) Default 0,                      -- الكمية
  Price      Number(25,2) Default 0,                      -- السعر المتوقع
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PMS_TReq_PK         PRIMARY KEY (Id  ),
  CONSTRAINT PMS_TReq_UK         UNIQUE      (Mst_Id, Item_Id),
  CONSTRAINT PMS_TReq_Request_FK Foreign Key (Mst_Id  ) References PMS_MReq (Id),
  CONSTRAINT PMS_TReq_Item_FK    Foreign Key (Item_Id ) References Stor_Item(Id),
  CONSTRAINT PMS_TReq_Ins_FK     Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT PMS_TReq_Upd_FK     Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym PMS_TReq For PMS_Request_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence PMS_MPurOrd_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table PMS_Purchase_Order_Mst                       -- جدول ترويسة أمر الشراء
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Req_Id     Number(9) Default 0 NOT NULL,                -- العرض
  User_Id    Number(5) NOT NULL,				                  -- المستخدم
  Cont_Id    Number(5) NOT NULL,				                  -- المتعامل/المورد
  Status_Id  Number(2) Default 1,				                  -- الحالة
  Curn_Id    Number(5) NOT NULL,                          -- العملة
  Num        Number(10) Default 0,                        -- الرقم
  dDate      Date NOT NULL,                               -- التاريخ
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PMS_MPurOrd_PK         PRIMARY KEY (Id),
  CONSTRAINT PMS_MPurOrd_Request_FK Foreign Key (Req_Id   ) References PMS_MReq      (Id),
  CONSTRAINT PMS_MPurOrd_Cont_FK    Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT PMS_MPurOrd_User_FK    Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT PMS_MPurOrd_Status_FK  Foreign Key (Status_Id) References PMS_Cod_Status(Id),
  CONSTRAINT PMS_MPurOrd_Curn_FK    Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT PMS_MPurOrd_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PMS_MPurOrd_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PMS_MPurOrd For PMS_Purchase_Order_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence PMS_TPurOrd_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table PMS_Purchase_Order_Trn                       -- جدول بنود أمر الشراء
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  TReq_Id    Number(9),                                   -- بند العرض
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Qnt        Number(25,3) Default 0,                      -- الكمية
  CQnt       Number(25,3) Default 0,                      -- الكمية المستلمة
  Price      Number(25,2) Default 0,                      -- السعر
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PMS_TPurOrd_PK        PRIMARY KEY (Id  ),
  CONSTRAINT PMS_TPurOrd_UK        UNIQUE      (Mst_Id, TReq_Id),
  CONSTRAINT PMS_TPurOrd_POrd_FK   Foreign Key (Mst_Id   ) References PMS_MPurOrd(Id),
  CONSTRAINT PMS_TPurOrd_TReq_FK   Foreign Key (TReq_Id  ) References PMS_TReq   (Id),
  CONSTRAINT PMS_TPurOrd_Item_FK   Foreign Key (Item_Id  ) References Stor_Item  (Id),
  CONSTRAINT PMS_TPurOrd_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT PMS_TPurOrd_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym PMS_TPurOrd For PMS_Purchase_Order_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence PMS_MDeliv_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table PMS_Delivery_Mst                             -- جدول ترويسة استلام أمر الشراء
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  POrd_Id    Number(9) NOT NULL,                          -- أمر الشراء
  Cont_Id    Number(5) NOT NULL,				                  -- المتعامل/المورد
  Status_Id  Number(2) Default 1,				                  -- الحالة
  Curn_Id    Number(5) NOT NULL,                          -- العملة
  Rate       Number(10,0) Default 0 NOT NULL,             -- سعر الصرف
  Num        Number(10) Default 0,                        -- الرقم
  dDate      Date NOT NULL,                               -- التاريخ
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PMS_MDeliv_PK         PRIMARY KEY (Id),
  CONSTRAINT PMS_MDeliv_POrd_FK    Foreign Key (POrd_Id  ) References PMS_MPurOrd   (Id),
  CONSTRAINT PMS_MDeliv_Cont_FK    Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT PMS_MDeliv_Status_FK  Foreign Key (Status_Id) References PMS_Cod_Status(Id),
  CONSTRAINT PMS_MDeliv_Curn_FK    Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT PMS_MDeliv_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT PMS_MDeliv_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym PMS_MDeliv For PMS_Delivery_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence PMS_TDeliv_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table PMS_Delivery_Trn                             -- جدول بنود استلام أمر الشراء
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  TOrd_Id    Number(9),                                   -- بند الأمر
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Qnt        Number(25,3) Default 0,                      -- الكمية
  Price      Number(25,2) Default 0,                      -- السعر
  CAmt       Number(25,2) Default 0,                      -- القيمة بالعملة
  Amt        Number(25,2) Default 0,                      -- القيمة محلي
  Vat_Perc   Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value  Number(25,2) Default 0,                      -- فيمة الVAT
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT PMS_TDeliv_PK      PRIMARY KEY (Id),
  CONSTRAINT PMS_TDeliv_UK      UNIQUE      (Mst_Id, TOrd_Id),
  CONSTRAINT PMS_TDeliv_PMS_FK  Foreign Key (Mst_Id  ) References PMS_MDeliv (Id),
  CONSTRAINT PMS_TDeliv_TOrd_FK Foreign Key (TOrd_Id ) References PMS_TPurOrd(Id),
  CONSTRAINT PMS_TDeliv_Item_FK Foreign Key (Item_Id ) References Stor_Item  (Id),
  CONSTRAINT PMS_TDeliv_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT PMS_TDeliv_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym PMS_TDeliv For PMS_Delivery_Trn
/
----------------------------------------------------------------------------------------------------
