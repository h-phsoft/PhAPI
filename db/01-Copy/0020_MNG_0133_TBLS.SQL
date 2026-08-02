----------------------------------------------------------------------------------------------------
Create Sequence MNG_Cod_Grp_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table MNG_Code_Group                                -- جدول ترميز فئات التصنيف
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  FColor     Varchar2(100 Char),                           -- لون النص
  BColor     Varchar2(100 Char),                           -- لون الخلفية
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT MNG_Cod_Grp_PK        PRIMARY KEY (Id  ),
  CONSTRAINT MNG_Cod_Grp_UK        UNIQUE      (Name),
  CONSTRAINT MNG_Cod_Grp_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT MNG_Cod_Grp_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT MNG_Cod_Grp_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym MNG_Cod_Grp For MNG_Code_Group
/
Insert into MNG_Cod_Grp (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence MNG_Cod_Itm_Seq MinValue 1 Start With 1 MaxValue 9999999 INCREMENT BY 1 CACHE 2;
Create Table MNG_Code_Item                                 -- جدول ترميز بنود التصنيف
( Id         Number(7) NOT NULL,                           -- مفتاح رئيسي
  Grp_Id     Number(5) Default 1,                          -- مجموعة الترميز
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT MNG_Cod_Itm_PK        PRIMARY KEY (Id  ),
  CONSTRAINT MNG_Cod_Itm_UK        UNIQUE      (Name),
  CONSTRAINT MNG_Cod_Itm_Group_Fk  Foreign Key (Grp_Id   ) References MNG_Cod_Grp   (Id),
  CONSTRAINT MNG_Cod_Itm_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT MNG_Cod_Itm_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT MNG_Cod_Itm_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym MNG_Cod_Itm For MNG_Code_Item
/
Insert into MNG_Cod_Itm (Id,Grp_Id,Name) values (0,0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence MNG_Supp_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table MNG_Supplier                                   -- دليل المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي
  Cont_Id    Number(9),                                    -- مفتاح المتعامل
  Num        Varchar2(15 Char),                            -- الرقم
  Title      Varchar2(50 Char),                            -- Title
  LName      VarChar2(200 Char) NOT NULL,                  -- الاسم محلي
  IName      VarChar2(200 Char),                           -- الاسم الدولي
  Owner      VarChar2(200 Char),                           -- اسم المالك
  Contact    VarChar2(200 Char),                           -- اسم شخص الاتصال
  Status_Id  Number(5) Default 1,                          -- الحالة
  SDate      Date,                                         -- تاريخ بداية الإسناد للمندوب
  EDate      Date,                                         -- تاريخ نهاية الإسناد للمندوب
  Phone      VarChar2(50 Char),                            -- الهاتف
  Phone1     VarChar2(50 Char),                            -- 1الهاتف
  Mobile     VarChar2(50 Char),                            -- الموبايل
  Fax        VarChar2(50 Char),                            -- الفاكس
  POBox      VarChar2(50 Char),                            -- صندوق البريد
  PCode      VarChar2(50 Char),                            -- الرمز البريدي
  Email      VarChar2(50 Char),                            -- البريد الالكتروني
  Website    VarChar2(50 Char),                            -- الموقع الالكتروني
  Address    VarChar2(200 Char),                           -- العنوان
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MNG_Supp_PK         PRIMARY KEY (Id ),
  CONSTRAINT MNG_Supp_Num_UK     Unique      (Num),
  CONSTRAINT MNG_Supp_Name_UK    Unique      (LName    ),
  CONSTRAINT MNG_Supp_Cont_UK    Unique      (Cont_Id  ),
  CONSTRAINT MNG_Supp_Phone_UK   Unique      (Phone    ),
  CONSTRAINT MNG_Supp_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT MNG_Supp_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT MNG_Supp_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym MNG_Supp For MNG_Supplier
/
INSERT INTO MNG_Supp (Id, Num, LName) VALUES (0, '-', '-');
----------------------------------------------------------------------------------------------------
Create Sequence MNG_Supp_Class_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table MNG_Supplier_Classification                    -- تصنيف المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي    
  Supp_Id    Number(9) NOT NULL,                           -- المتعامل
  Grp_Id     Number(5) NOT NULL,                           -- المجموعة
  Itm_Id     Number(7) NOT NULL,                           -- البند
  Rem        VarChar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MNG_Supp_Class_PK       PRIMARY KEY (Id),
  CONSTRAINT MNG_Supp_Class_UK       Unique      (Supp_Id, Grp_Id, Itm_Id),
  CONSTRAINT MNG_Supp_Class_Cont_FK  Foreign Key (Supp_Id ) References MNG_Supp   (Id),
  CONSTRAINT MNG_Supp_Class_Group_FK Foreign Key (Grp_Id  ) References MNG_Cod_Grp(Id),
  CONSTRAINT MNG_Supp_Class_Item_FK  Foreign Key (Itm_Id  ) References MNG_Cod_Itm(Id),
  CONSTRAINT MNG_Supp_Class_Ins_FK   Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT MNG_Supp_Class_Upd_FK   Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym MNG_Supp_Class For MNG_Supplier_Classification
/
----------------------------------------------------------------------------------------------------
Create Sequence MNG_Supp_Cont_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table MNG_Supplier_Contact                           -- جهات اتصال المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي    
  Supp_Id    Number(9) NOT NULL,                           -- المتعامل
  Gender_Id  Number(5) Default 1,                          -- الجنس
  LName      VarChar2(200 Char),                           -- الاسم محلي
  IName      VarChar2(200 Char),                           -- الاسم العالمي
  Position   VarChar2(100 Char),                           -- المنصب
  Title      Varchar2(50 Char),                            -- الصفة  
  Phone      VarChar2(50 Char),                            -- الهاتف
  Mobile     VarChar2(50 Char),                            -- الموبايل
  Fax        VarChar2(50 Char),                            -- الفاكس
  Email      VarChar2(50 Char),                            -- البريد الالكتروني
  Rem        VarChar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MNG_Supp_Cont_PK        PRIMARY KEY (Id),
  CONSTRAINT MNG_Supp_Cont_Name_UK   Unique      (Supp_Id, LName),
  CONSTRAINT MNG_Supp_Cont_Cont_FK   Foreign Key (Supp_Id  ) References MNG_Supp      (Id),
  CONSTRAINT MNG_Supp_Cont_Gender_FK Foreign Key (Gender_Id) References Phs_Cod_Gender(Id),
  CONSTRAINT MNG_Supp_Cont_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT MNG_Supp_Cont_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym MNG_Supp_Cont For MNG_Supplier_Contact
/
----------------------------------------------------------------------------------------------------
Create Sequence MNG_Supp_Bran_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table MNG_Supplier_Branche                           -- فروع المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي
  Supp_Id    Number(9) NOT NULL,                           -- المتعامل
  LName      VarChar2(100 Char),                           -- الاسم محلي
  IName      VarChar2(100 Char),                           -- الاسم العالمي
  Phone      VarChar2(50 Char),                            -- الهاتف
  Mobile     VarChar2(50 Char),                            -- الموبايل
  Fax        VarChar2(50 Char),                            -- الفاكس
  POBox      VarChar2(50 Char),                            -- صندوق البريد
  PCode      VarChar2(50 Char),                            -- الرمز البريدي
  Email      VarChar2(50 Char),                            -- البريد الالكتروني
  Address    VarChar2(200 Char),                           -- العنوان
  Rem        VarChar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MNG_Supp_Bran_PK      PRIMARY KEY (Id),
  CONSTRAINT MNG_Supp_Bran_Name_UK Unique      (Supp_Id, LName),
  CONSTRAINT MNG_Supp_Bran_Cont_FK Foreign Key (Supp_Id ) References MNG_Supp(Id),
  CONSTRAINT MNG_Supp_Bran_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT MNG_Supp_Bran_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym MNG_Supp_Bran For MNG_Supplier_Branche
/
