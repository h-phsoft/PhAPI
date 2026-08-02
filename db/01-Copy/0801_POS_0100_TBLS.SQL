--set pagesize 1000
--select 'Drop table '   || table_name    || ';' from user_tables    where table_name    like 'POS%' ;
--select 'Drop Synonym ' || Synonym_name  || ';' from user_Synonyms  where Synonym_name  like 'POS%' ;
--select 'Drop Sequence '|| Sequence_name || ';' from user_Sequences where Sequence_name like 'POS%' ;
--select 'Drop View '    || View_name     || ';' from user_Views     where View_name     like 'POS%' ;
----------------------------------------------------------------------------------------------------
Create Sequence Pos_MDOrd_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Pos_Deleted_Order_Master                      -- جدول الأوامر المحذوفة
( Id         Number(9) NOT NULL,                          -- مفتاح رئيسي
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  User_Id    Number(5) NOT NULL,                           -- المستخدم الذي أضاف الأمر
  Num        Number(9) NOT NULL,                           -- رقم الوثيقة
  dDate      Date NOT NULL,                                -- التاريخ
  Disc       Number(10,2) Default 0,                       -- الحسم
  User_DId   Number(5) NOT NULL,                           -- المستخدم الذي حذف الأمر
  Reason     Varchar2(100 Char),                           -- السبب
  Deleted_At Date Default Sysdate,                         -- تاريخ ووقت الحذف
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Pos_MDOrd_PK       PRIMARY KEY (Id  ),
  CONSTRAINT Pos_MDOrd_Stor_FK  Foreign Key (Stor_Id ) References Stor_Store(Id),
  CONSTRAINT Pos_MDOrd_User_FK  Foreign Key (User_Id ) References Cpy_User  (Id),
  CONSTRAINT Pos_MDOrd_DUser_FK Foreign Key (User_DId) References Cpy_User  (Id),
  CONSTRAINT Pos_MDOrd_Ins_FK   Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT Pos_MDOrd_Upd_FK   Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Pos_MDOrd For Pos_Deleted_Order_Master
/
----------------------------------------------------------------------------------------------------
Create Sequence Pos_TDOrd_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Pos_Deleted_Order_Trans
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  Mst_Id     Number(10) NOT NULL,                          -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,                           -- المادة
  Qnt        Number(25,3) Default 0,                       -- الكمية
  Price      Number(25,2) Default 0,                       -- افرادي
  Amt        Number(25,2) Default 0,                       -- القيمة
  Disc       Number(10,2) Default 0,                       -- الحسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Pos_TDOrd_PK      PRIMARY KEY (Id  ),
  CONSTRAINT Pos_TDOrd_Mst_FK  Foreign Key (Mst_Id  ) References Pos_MDOrd(Id),
  CONSTRAINT Pos_TDOrd_Item_FK Foreign Key (Item_Id ) References Stor_Item(Id),
  CONSTRAINT Pos_TDOrd_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Pos_TDOrd_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Pos_TDOrd For Pos_Deleted_Order_Trans
/
----------------------------------------------------------------------------------------------------
Create Sequence Pos_MOrd_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Pos_Order_Master                              -- أمر المبيع
( Id         Number(9) NOT NULL,                          -- مفتاح رئيسي
  Stor_Id    Number(5) NOT NULL,                           -- المخزن
  User_Id    Number(5) NOT NULL,                           -- المستخدم الذي أضاف الأمر
  Num        Number(9) NOT NULL,                           -- رقم الوثيقة
  dDate      Date NOT NULL,                                -- التاريخ
  Disc       Number(10,2) Default 0,                       -- الحسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Pos_MOrd_PK      PRIMARY KEY (Id  ),
  CONSTRAINT Pos_MOrd_UK      UNIQUE      (Num),
  CONSTRAINT Pos_MOrd_Stor_FK Foreign Key (Stor_Id ) References Stor_Store(Id),
  CONSTRAINT Pos_MOrd_User_FK Foreign Key (User_Id ) References Cpy_User  (Id),
  CONSTRAINT Pos_MOrd_Ins_FK  Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT Pos_MOrd_Upd_FK  Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Pos_MOrd For Pos_Order_Master
/
----------------------------------------------------------------------------------------------------
Create Sequence Pos_TOrd_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Pos_Order_Trans
( Id         Number(20) NOT NULL,                           -- مفتاح رئيسي
  Mst_Id     Number(9) NOT NULL,                          -- مفتاح الأب
  Item_Id    Number(9) NOT NULL,                           -- المادة
  Qnt        Number(25,3) Default 0,                       -- الكمية
  Price      Number(25,2) Default 0,                       -- افرادي
  Amt        Number(25,2) Default 0,                       -- القيمة
  Disc       Number(10,2) Default 0,                       -- الحسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Pos_TOrd_PK      PRIMARY KEY (Id  ),
  CONSTRAINT Pos_TOrd_Mst_FK  Foreign Key (Mst_Id  ) References Pos_MOrd (Id),
  CONSTRAINT Pos_TOrd_Item_FK Foreign Key (Item_Id ) References Stor_Item(Id),
  CONSTRAINT Pos_TOrd_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Pos_TOrd_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Pos_TOrd For Pos_Order_Trans
/
