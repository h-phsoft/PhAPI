----------------------------------------------------------------------------------------------------
Create Table Mng_Code_Contact_Type    				             -- جدول ترميز أنواع المتعاملين
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Mng_Cod_ContType_PK PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_ContType_UK UNIQUE      (Name)
)
/
Create Synonym Mng_Cod_ContType For Mng_Code_Contact_Type
/
Insert into Mng_Cod_ContType (Id,Name) values (0,'Contact'          );
Insert into Mng_Cod_ContType (Id,Name) values (1,'Customer'         );
Insert into Mng_Cod_ContType (Id,Name) values (2,'Supplier'         );
Insert into Mng_Cod_ContType (Id,Name) values (3,'Customer/Supplier');
Insert into Mng_Cod_ContType (Id,Name) values (4,'Account'          );
----------------------------------------------------------------------------------------------------
Create Table Mng_Code_Balance_Mode    				             -- جدول ترميز 
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Mng_Cod_BlncMode_PK PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_BlncMode_UK UNIQUE      (Name)
)
/
Create Synonym Mng_Cod_BlncMode For Mng_Code_Balance_Mode
/
Insert into Mng_Cod_BlncMode (Id,Name) values (1,'Balance'    );
Insert into Mng_Cod_BlncMode (Id,Name) values (2,'Per Invoice');
Insert into Mng_Cod_BlncMode (Id,Name) values (3,'Cash'       );
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cod_Spec1_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Code_Specification1                       -- جدول ترميز التصنيف1
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Mng_Cod_Spec1_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_Spec1_UK        UNIQUE      (Name),
  CONSTRAINT Mng_Cod_Spec1_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Mng_Cod_Spec1_Ins_FK    Foreign Key (Ins_User ) References Cpy_User(Id),
  CONSTRAINT Mng_Cod_Spec1_Upd_FK    Foreign Key (Upd_User ) References Cpy_User(Id)
)
/
Create Synonym Mng_Cod_Spec1 For Mng_Code_Specification1
/
Insert into Mng_Cod_Spec1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cod_Spec2_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Code_Specification2                       -- جدول ترميز التصنيف2
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Mng_Cod_Spec2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_Spec2_UK     UNIQUE      (Name),
  CONSTRAINT Mng_Cod_Spec2_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Mng_Cod_Spec2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Mng_Cod_Spec2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Mng_Cod_Spec2 For Mng_Code_Specification2
/
Insert into Mng_Cod_Spec2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cod_Spec3_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Code_Specification3                       -- جدول ترميز التصنيف3
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Mng_Cod_Spec3_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_Spec3_UK        UNIQUE      (Name),
  CONSTRAINT Mng_Cod_Spec3_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Mng_Cod_Spec3_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Mng_Cod_Spec3_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Mng_Cod_Spec3 For Mng_Code_Specification3
/
Insert into Mng_Cod_Spec3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cod_Spec4_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Code_Specification4                       -- جدول ترميز التصنيف4
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Mng_Cod_Spec4_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_Spec4_UK        UNIQUE      (Name),
  CONSTRAINT Mng_Cod_Spec4_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Mng_Cod_Spec4_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Mng_Cod_Spec4_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Mng_Cod_Spec4 For Mng_Code_Specification4
/
Insert into Mng_Cod_Spec4 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cod_Spec5_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Code_Specification5                       -- جدول ترميز التصنيف5
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Mng_Cod_Spec5_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_Spec5_UK        UNIQUE      (Name),
  CONSTRAINT Mng_Cod_Spec5_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Mng_Cod_Spec5_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Mng_Cod_Spec5_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Mng_Cod_Spec5 For Mng_Code_Specification5
/
Insert into Mng_Cod_Spec5 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cod_Spec6_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Code_Specification6                       -- جدول ترميز التصنيف6
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Mng_Cod_Spec6_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_Spec6_UK        UNIQUE      (Name),
  CONSTRAINT Mng_Cod_Spec6_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Mng_Cod_Spec6_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Mng_Cod_Spec6_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Mng_Cod_Spec6 For Mng_Code_Specification6
/
Insert into Mng_Cod_Spec6 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cod_Spec7_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Code_Specification7                       -- جدول ترميز التصنيف7
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Mng_Cod_Spec7_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_Spec7_UK        UNIQUE      (Name),
  CONSTRAINT Mng_Cod_Spec7_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Mng_Cod_Spec7_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Mng_Cod_Spec7_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Mng_Cod_Spec7 For Mng_Code_Specification7
/
Insert into Mng_Cod_Spec7 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cod_Spec8_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Code_Specification8                       -- جدول ترميز التصنيف8
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Mng_Cod_Spec8_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_Spec8_UK        UNIQUE      (Name),
  CONSTRAINT Mng_Cod_Spec8_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Mng_Cod_Spec8_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Mng_Cod_Spec8_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Mng_Cod_Spec8 For Mng_Code_Specification8
/
Insert into Mng_Cod_Spec8 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cod_Spec9_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Code_Specification9                       -- جدول ترميز التصنيف9
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Mng_Cod_Spec9_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_Spec9_UK        UNIQUE      (Name),
  CONSTRAINT Mng_Cod_Spec9_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Mng_Cod_Spec9_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Mng_Cod_Spec9_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Mng_Cod_Spec9 For Mng_Code_Specification9
/
Insert into Mng_Cod_Spec9 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cod_Spec10_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Code_Specification0                       -- جدول ترميز التصنيف10
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Mng_Cod_Spec0_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cod_Spec0_UK        UNIQUE      (Name),
  CONSTRAINT Mng_Cod_Spec0_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Mng_Cod_Spec0_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Mng_Cod_Spec0_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Mng_Cod_Spec0 For Mng_Code_Specification0
/
Insert into Mng_Cod_Spec0 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Mng_Cont_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Contact                                   -- دليل المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي
  Num        Varchar2(15 Char),                            -- الرقم
  Title      Varchar2(15 Char),                            -- Titel
  Name       VarChar2(200 Char) NOT NULL,                  -- الاسم
  LName      VarChar2(200 Char),                           -- الاسم القانوني
  Owner      VarChar2(200 Char),                           -- اسم المالك
  Contact    VarChar2(200 Char),                           -- اسم شخص الاتصال
  Cust_Id    Number(9),                                    -- مفتاح الزبون
  Vend_Id    Number(9),                                    -- مفتاح المورد
  Status_Id  Number(5) Default 1,                          -- الحالة
  BlnMod_Id  Number(1) Default 1,                          -- نوع الرصيد
  Type_Id    Number(1) Default 0,                          -- نوع المتعامل
  Spc1_Id    Number(5) Default 0,                          -- التصنيف 1
  Spc2_Id    Number(5) Default 0,                          -- التصنيف 2
  Spc3_Id    Number(5) Default 0,                          -- التصنيف 3
  Spc4_Id    Number(5) Default 0,                          -- التصنيف 4
  Spc5_Id    Number(5) Default 0,                          -- التصنيف 5
  Spc6_Id    Number(5) Default 0,                          -- التصنيف 6
  Spc7_Id    Number(5) Default 0,                          -- التصنيف 7
  Spc8_Id    Number(5) Default 0,                          -- التصنيف 8
  Spc9_Id    Number(5) Default 0,                          -- التصنيف 9
  Spc0_Id    Number(5) Default 0,                          -- التصنيف 10
  dLmt       Number(3) Default -1,                         -- أيام الدين
  nLmt       Number(25,2) Default -1,                      -- حد الدين
  Repr_Id    Number(9),                                    -- مندوب المبيعات
  Cost_Id    Number(9),                                    -- مركز الكلفة
  AccDbt_Id  Number(9),                                    -- الحساب المدين
  AccCrd_Id  Number(9),                                    -- الحساب الدائن
  Phone      VarChar2(50 Char),                            -- الهاتف
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
  CONSTRAINT Mng_Cont_PK         PRIMARY KEY (Id  ),
  CONSTRAINT Mng_Cont_Num_UK     Unique      (Num ),
  CONSTRAINT Mng_Cont_Name_UK    Unique      (Name),
  CONSTRAINT Mng_Cont_Mobile_UK  Unique      (Mobile ),
  CONSTRAINT Mng_Cont_Cust_UK    Unique      (Cust_Id),
  CONSTRAINT Mng_Cont_Vend_UK    Unique      (Vend_Id),
  CONSTRAINT Mng_Cont_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status  (Id),
  CONSTRAINT Mng_Cont_BlnMod_FK  Foreign Key (BlnMod_Id) References Mng_Cod_BlncMode(Id),
  CONSTRAINT Mng_Cont_Type_FK    Foreign Key (Type_Id  ) References Mng_Cod_ContType(Id),
  CONSTRAINT Mng_Cont_Spc1_FK    Foreign Key (Spc1_Id  ) References Mng_Cod_Spec1   (Id),
  CONSTRAINT Mng_Cont_Spc2_FK    Foreign Key (Spc2_Id  ) References Mng_Cod_Spec2   (Id),
  CONSTRAINT Mng_Cont_Spc3_FK    Foreign Key (Spc3_Id  ) References Mng_Cod_Spec3   (Id),
  CONSTRAINT Mng_Cont_Spc4_FK    Foreign Key (Spc4_Id  ) References Mng_Cod_Spec4   (Id),
  CONSTRAINT Mng_Cont_Spc5_FK    Foreign Key (Spc5_Id  ) References Mng_Cod_Spec5   (Id),
  CONSTRAINT Mng_Cont_Spc6_FK    Foreign Key (Spc6_Id  ) References Mng_Cod_Spec6   (Id),
  CONSTRAINT Mng_Cont_Spc7_FK    Foreign Key (Spc7_Id  ) References Mng_Cod_Spec7   (Id),
  CONSTRAINT Mng_Cont_Spc8_FK    Foreign Key (Spc8_Id  ) References Mng_Cod_Spec8   (Id),
  CONSTRAINT Mng_Cont_Spc9_FK    Foreign Key (Spc9_Id  ) References Mng_Cod_Spec9   (Id),
  CONSTRAINT Mng_Cont_Spc0_FK    Foreign Key (Spc0_Id  ) References Mng_Cod_Spec0   (Id),
  CONSTRAINT Mng_Cont_Ins_FK     Foreign Key (Ins_User ) References Cpy_User        (Id),
  CONSTRAINT Mng_Cont_Upd_FK     Foreign Key (Upd_User ) References Cpy_User        (Id)
)
/
Create Synonym Mng_Cont For Mng_Contact
/
--ALTER TABLE Mng_Contact ADD CONSTRAINT Mng_Cont_Cost_FK   Foreign Key (Cost_Id  ) References Acc_Cost(Id);
--ALTER TABLE Mng_Contact ADD CONSTRAINT Mng_Cont_AccDbt_FK Foreign Key (AccDbt_Id) References Acc_Acc (Id);
--ALTER TABLE Mng_Contact ADD CONSTRAINT Mng_Cont_AccCrd_FK Foreign Key (AccCrd_Id) References Acc_Acc (Id);
--ALTER TABLE Mng_Contact ADD CONSTRAINT Mng_Cont_Repr_FK Foreign Key (Repr_Id) References CRM_Repr(Id);
INSERT INTO Mng_Cont (Id, Num, Name, dLmt, nLmt) VALUES (0, '-', '-', 0, 0);

Create Sequence Mng_Cont_Cont_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Contact_Contact                           -- جهات اتصال المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي    
  Cont_Id    Number(9),                                    -- المتعامل
  Gender_Id  Number(5),                                    -- الجنس
  Name       VarChar2(200 Char),                           -- الاسم
  Position   VarChar2(100 Char),                           -- المنصب
  Title      Varchar2(20 Char),                            -- الصفة  
  Phone      VarChar2(50 Char),                            -- الهاتف
  Mobile     VarChar2(50 Char),                            -- الموبايل
  Fax        VarChar2(50 Char),                            -- الفاكس
  Email      VarChar2(50 Char),                            -- البريد الالكتروني
  Rem        VarChar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Mng_Cont_Cont_PK        PRIMARY KEY (Id),
  CONSTRAINT Mng_Cont_Cont_Name_UK   Unique      (Cont_Id, Name),
  CONSTRAINT Mng_Cont_Cont_Cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT Mng_Cont_Cont_Gender_FK Foreign Key (Gender_Id) References Phs_Cod_Gender(Id),
  CONSTRAINT Mng_Cont_Cont_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Mnf_Cont_Cont_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Mng_Cont_Cont For Mng_Contact_Contact
/

Create Sequence Mng_Cont_Bran_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Contact_Branche                           -- فروع المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي
  Cont_Id    Number(9),                                    -- المتعامل
  Name       VarChar2(100 Char),                           -- الاسم
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
  CONSTRAINT Mng_Cont_Bran_PK      PRIMARY KEY (Id),
  CONSTRAINT Mng_Cont_Bran_Name_UK Unique      (Cont_Id, Name),
  CONSTRAINT Mng_Cont_Bran_Cont_FK Foreign Key (Cont_Id ) References Mng_Cont(Id),
  CONSTRAINT Mng_Cont_Bran_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Mng_Cont_Bran_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Mng_Cont_Bran For Mng_Contact_Branche
/
