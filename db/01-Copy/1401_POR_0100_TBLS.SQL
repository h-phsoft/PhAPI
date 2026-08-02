--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'POR%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'POR%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'POR%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'POR%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'POR%' ;
----------------------------------------------------------------------------------------------------
Create Table Por_Code_Status                              -- جدول ترميز حالة الطلب
( Id         Number(1) NOT NULL,				                  -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                  -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				          -- الاسم
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Por_Cod_Status_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Por_Cod_Status_UK        UNIQUE      (Name),
  CONSTRAINT Por_Cod_Status_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Por_Cod_Status_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Por_Cod_Status_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Por_Cod_Status For Por_Code_Status
/
Insert into Por_Cod_Status (Id,Name) values (0,'-');
Insert into Por_Cod_Status (Id,Name) values (1,'جديد');
Insert into Por_Cod_Status (Id,Name) values (2,'موافقة مدير');
Insert into Por_Cod_Status (Id,Name) values (3,'موافقة آمر الشراء');
Insert into Por_Cod_Status (Id,Name) values (4,'مرفوض');
Insert into Por_Cod_Status (Id,Name) values (5,'ملغى');
Insert into Por_Cod_Status (Id,Name) values (6,'تم');
----------------------------------------------------------------------------------------------------
Create Sequence Por_MReq_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Por_Request_Mst                              -- جدول ترويسة الطلب
( Id          Number(9) NOT NULL,				                  -- مفتاح رئيسي
  User_Id     Number(5) Default 1,				                -- المستخدم
  Status_Id   Number(1) Default 1,				                -- الحالة
  Status_Date Date,                                       -- تاريخ الحالة
  Num         Number(10) Default 0,                       -- الرقم
  dDate       Date,                                       -- التاريخ
  Rem         Varchar2(100 Char),          				        -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Por_MReq_PK        PRIMARY KEY (Id ),
  CONSTRAINT  Por_MReq_UK        UNIQUE      (Num),
  CONSTRAINT  Por_MReq_Status_FK Foreign Key (Status_Id) References Por_Cod_Status(Id),
  CONSTRAINT  Por_MReq_User_FK   Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT  Por_MReq_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Por_MReq_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Por_MReq For Por_Request_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Por_TReq_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Por_Request_Trn                              -- جدول بنود الطلب
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Qnt        Number(25,3) Default 0,                      -- الكمية
  Price      Number(25,2) Default 0,                      -- السعر المتوقع
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Por_TReq_PK         PRIMARY KEY (Id  ),
  CONSTRAINT Por_TReq_UK         UNIQUE      (Mst_Id, Item_Id),
  CONSTRAINT Por_TReq_Request_FK Foreign Key (Mst_Id  ) References Por_MReq (Id),
  CONSTRAINT Por_TReq_Item_FK    Foreign Key (Item_Id ) References Stor_Item(Id),
  CONSTRAINT Por_TReq_Ins_FK     Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Por_TReq_Upd_FK     Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Por_TReq For Por_Request_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Por_MPurOrd_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Por_Purchase_Order_Mst                       -- جدول ترويسة أمر الشراء
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
  CONSTRAINT Por_MPurOrd_PK         PRIMARY KEY (Id),
  CONSTRAINT Por_MPurOrd_Request_FK Foreign Key (Req_Id   ) References Por_MReq      (Id),
  CONSTRAINT Por_MPurOrd_Cont_FK    Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT Por_MPurOrd_User_FK    Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT Por_MPurOrd_Status_FK  Foreign Key (Status_Id) References Por_Cod_Status(Id),
  CONSTRAINT Por_MPurOrd_Curn_FK    Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Por_MPurOrd_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Por_MPurOrd_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Por_MPurOrd For Por_Purchase_Order_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Por_TPurOrd_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Por_Purchase_Order_Trn                       -- جدول بنود أمر الشراء
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
  TReq_Id    Number(9),                                   -- بند العرض
  Item_Id    Number(9) NOT NULL,				                  -- المادة
  Qnt        Number(25,3) Default 0,                      -- الكمية
  CQnt       Number(25,3) Default 0,                      -- الكمية المستلمة
  Price      Number(25,2) Default 0,                      -- السعر
  Vat_Perc   Number(6,2) Default 0,                       -- نسبة الVAT
  Vat_Value  Number(25,2) Default 0,                      -- فيمة الVAT
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Por_TPurOrd_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Por_TPurOrd_UK        UNIQUE      (Mst_Id, TReq_Id),
  CONSTRAINT Por_TPurOrd_POrd_FK   Foreign Key (Mst_Id   ) References Por_MPurOrd(Id),
  CONSTRAINT Por_TPurOrd_TReq_FK   Foreign Key (TReq_Id  ) References Por_TReq   (Id),
  CONSTRAINT Por_TPurOrd_Item_FK   Foreign Key (Item_Id  ) References Stor_Item  (Id),
  CONSTRAINT Por_TPurOrd_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT Por_TPurOrd_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Por_TPurOrd For Por_Purchase_Order_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Por_MDeliv_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Por_Delivery_Mst                             -- جدول ترويسة استلام أمر الشراء
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
  CONSTRAINT Por_MDeliv_PK         PRIMARY KEY (Id),
  CONSTRAINT Por_MDeliv_POrd_FK    Foreign Key (POrd_Id  ) References Por_MPurOrd   (Id),
  CONSTRAINT Por_MDeliv_Cont_FK    Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT Por_MDeliv_Status_FK  Foreign Key (Status_Id) References Por_Cod_Status(Id),
  CONSTRAINT Por_MDeliv_Curn_FK    Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Por_MDeliv_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Por_MDeliv_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Por_MDeliv For Por_Delivery_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Por_TDeliv_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Por_Delivery_Trn                             -- جدول بنود استلام أمر الشراء
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
  CONSTRAINT Por_TDeliv_PK      PRIMARY KEY (Id),
  CONSTRAINT Por_TDeliv_UK      UNIQUE      (Mst_Id, TOrd_Id),
  CONSTRAINT Por_TDeliv_Por_FK  Foreign Key (Mst_Id  ) References Por_MDeliv (Id),
  CONSTRAINT Por_TDeliv_TOrd_FK Foreign Key (TOrd_Id ) References Por_TPurOrd(Id),
  CONSTRAINT Por_TDeliv_Item_FK Foreign Key (Item_Id ) References Stor_Item  (Id),
  CONSTRAINT Por_TDeliv_Ins_FK  Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT Por_TDeliv_Upd_FK  Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym Por_TDeliv For Por_Delivery_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Por_MPor_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Por_Purchase_Mst                             -- جدول ترويسة الشراء
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Cont_Id    Number(5) NOT NULL,				                  -- المتعامل/المورد
  Status_Id  Number(2) Default 1,				                  -- الحالة
  Curn_Id    Number(5) NOT NULL,                          -- العملة
  Rate       Number(10,0) Default 0 NOT NULL,             -- سعر الصرف
  Num        Number(10) Default 0,                        -- الرقم
  dDate      Date NOT NULL,                               -- التاريخ
  Rem        Varchar2(100 Char),          				        -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Por_MPor_PK         PRIMARY KEY (Id),
  CONSTRAINT Por_MPor_Cont_FK    Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT Por_MPor_Status_FK  Foreign Key (Status_Id) References Por_Cod_Status(Id),
  CONSTRAINT Por_MPor_Curn_FK    Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT Por_MPor_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Por_MPor_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Por_MPur For Por_Purchase_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Por_TPor_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Por_Purchase_Trn                             -- جدول بنود الشراء
( Id         Number(9) NOT NULL,				                  -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,				                  -- مفتاح الأب
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
  CONSTRAINT Por_TPor_PK      PRIMARY KEY (Id),
  CONSTRAINT Por_TPor_Por_FK  Foreign Key (Mst_Id  ) References Por_MPur (Id),
  CONSTRAINT Por_TPor_Item_FK Foreign Key (Item_Id ) References Stor_Item(Id),
  CONSTRAINT Por_TPor_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Por_TPor_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Por_TPur For Por_Purchase_Trn
/
----------------------------------------------------------------------------------------------------
