--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'FUND%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'FUND%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'FUND%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'FUND%' ;
----------------------------------------------------------------------------------------------------
Create Table Fund_Code_Type 				              -- جدول ترميز 
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  CONSTRAINT Fund_Cod_Type_PK PRIMARY KEY (Id  ),
  CONSTRAINT Fund_Cod_Type_UK UNIQUE      (Name)
)
/
Create Synonym Fund_Cod_Type For Fund_Code_Type
/
Insert into Fund_Cod_Type (Id,Name) values (1,'قبض');
Insert into Fund_Cod_Type (Id,Name) values (2,'دفع');
----------------------------------------------------------------------------------------------------
Create Sequence Fund_Dept_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fund_Department                               -- دليل الأقسام
( Id          Number(5),                                   -- مفتاح رئيسي
  Name        Varchar2(100 Char),                          -- الاسم
  Status_Id   Number(1) Default 1,                         -- الحالة
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Fund_Dept_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  Fund_Dept_Uk        Unique      (Name),
  CONSTRAINT  Fund_Dept_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  Fund_Dept_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Fund_Dept_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fund_Dept For Fund_Department
/
Insert into Fund_Dept (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fund_Item_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fund_Items                                    -- دليل البنود
( Id          Number(5),                                   -- مفتاح رئيسي
  Name        Varchar2(100 Char),                          -- الاسم
  Status_Id   Number(1) Default 1,                         -- الحالة
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Fund_Item_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  Fund_Item_Uk        Unique      (Name),
  CONSTRAINT  Fund_Item_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  Fund_Item_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Fund_Item_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fund_Item For Fund_Items
/
Insert into Fund_Item (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fund_Box_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fund_Boxes                                    -- دليل الصناديق
( Id          Number(5),                                   -- مفتاح رئيسي
  Name        Varchar2(100 Char),                          -- الاسم
  Status_Id   Number(1) Default 1,                         -- الحالة
  Cost_Id     Number(9) NOT NULL,                          -- مركز الكلفة
  Acc_Id      Number(9) NOT NULL,                          -- حساب المخزن
  User_Id     Number(5) Default 0 NOT NULL,                -- أمين الصندوق
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Fund_Box_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  Fund_Box_Uk        Unique      (Name),
  CONSTRAINT  Fund_Box_Cost_FK   Foreign Key (Cost_Id  ) References Acc_Cost      (Id),
  CONSTRAINT  Fund_Box_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT  Fund_Box_User_FK   Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT  Fund_Box_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  Fund_Box_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Fund_Box_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fund_Box For Fund_Boxes
/
----------------------------------------------------------------------------------------------------
Create Sequence Fund_Diary_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fund_Diaries                                  -- اليوميات
( Id          Number(5),                                   -- مفتاح رئيسي
  Type_Id     Number(1) Default 2,                         -- نوع الحركة، 1=قبض، 2=دفع
  Box_Id      Number(9) NOT NULL,                          -- الصندوق
  Acc_Id      Number(9) Default 0,                         -- الحساب
  Cost_Id     Number(9) Default 0,                         -- مركز الكفلة
  Item_Id     Number(5) Default 0,                         -- البند
  Dept_Id     Number(5) Default 0,                         -- القسم
  Curn_Id     Number(9) Default 1,                         -- العملة
  nPrints     Number(2) Default 0,                         -- عدد مرات الطباعة
  dDate       Date NOT NULL,                               -- التاريخ
  CAmt        Number(25,3) DEFAULT 0 NOT NULL,             -- المبلغ قطع
  Rate        NUmber(25,7) DEFAULT 1 NOT NULL,             -- سعر الصرف
  Amt         Number(25,3) DEFAULT 0 NOT NULL,             -- المبلغ
  Rem         Varchar2(100),                               -- ملاحظات
  Attach      Varchar2(512),                               -- الملف المرفق
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Fund_Diary_PK      PRIMARY KEY (Id  ),
  CONSTRAINT  Fund_Diary_Box_FK  Foreign Key (Box_Id  ) References Fund_Box     (Id),
  CONSTRAINT  Fund_Diary_Type_FK Foreign Key (Type_Id ) References Fund_Cod_Type(Id),
  CONSTRAINT  Fund_Diary_Cost_FK Foreign Key (Cost_Id ) References Acc_Cost     (Id),
  CONSTRAINT  Fund_Diary_Acc_FK  Foreign Key (Acc_Id  ) References Acc_Acc      (Id),
  CONSTRAINT  Fund_Diary_Dept_FK Foreign Key (Dept_Id ) References Fund_Dept    (Id),
  CONSTRAINT  Fund_Diary_Item_FK Foreign Key (Item_Id ) References Fund_Item    (Id),
  CONSTRAINT  Fund_Diary_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn     (Id),
  CONSTRAINT  Fund_Diary_Ins_FK  Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT  Fund_Diary_Upd_FK  Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fund_Diary For Fund_Diaries
/
----------------------------------------------------------------------------------------------------
