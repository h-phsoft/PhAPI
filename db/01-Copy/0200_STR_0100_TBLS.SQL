--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'STR%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'STR%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'STR%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'STR%' ;
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Item_Type 				              -- جدول ترميز 
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  CONSTRAINT Phs_Cod_ItemType_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_ItemType_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_ItemType For Phs_Code_Item_Type
/
Insert into Phs_Cod_ItemType (Id,Name) values (1,'Normal');
Insert into Phs_Cod_ItemType (Id,Name) values (2,'Product');
Insert into Phs_Cod_ItemType (Id,Name) values (3,'Raw Material');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Item_Method    				          -- جدول ترميز 
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  CONSTRAINT Phs_Cod_ItemMethod_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_ItemMethod_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_ItemMethod For Phs_Code_Item_Method
/
Insert into Phs_Cod_ItemMethod (Id,Name) values (1,'Normal');
Insert into Phs_Cod_ItemMethod (Id,Name) values (2,'FIFO');
Insert into Phs_Cod_ItemMethod (Id,Name) values (3,'LIFO');
Insert into Phs_Cod_ItemMethod (Id,Name) values (4,'Serial');
Insert into Phs_Cod_ItemMethod (Id,Name) values (5,'LOT');
Insert into Phs_Cod_ItemMethod (Id,Name) values (6,'Manual');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Cost_Method    				          -- جدول ترميز 
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  CONSTRAINT Phs_Cod_CostMethod_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_CostMethod_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_CostMethod For Phs_Code_Cost_Method
/
Insert into Phs_Cod_CostMethod (Id,Name) values (1,'Average');
Insert into Phs_Cod_CostMethod (Id,Name) values (2,'By Method');
----------------------------------------------------------------------------------------------------
Create Table Phs_Code_Own_Status    				          -- جدول ترميز 
( Id         Number(1) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  CONSTRAINT Phs_Cod_OwnStatus_PK PRIMARY KEY (Id  ),
  CONSTRAINT Phs_Cod_OwnStatus_UK UNIQUE      (Name)
)
/
Create Synonym Phs_Cod_OwnStatus For Phs_Code_Own_Status
/
Insert into Phs_Cod_OwnStatus (Id,Name) values (1,'Own');
Insert into Phs_Cod_OwnStatus (Id,Name) values (2,'Rent');
----------------------------------------------------------------------------------------------------
Create Sequence Str_Cod_Doc_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Str_Code_Document                        -- جدول ترميز نوع المستند
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Str_Cod_Doc_PK      PRIMARY KEY (Id  ),
  CONSTRAINT Str_Cod_Doc_UK      UNIQUE      (Name),
  CONSTRAINT Str_Cod_Doc_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Str_Cod_Doc_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Str_Cod_Doc For Str_Code_Document
/
Insert into Str_Cod_Doc (Id,Name) values (0,'-'          );
----------------------------------------------------------------------------------------------------
Create Sequence Str_Cod_TrnTyp_Seq MinValue 1 Start With 1 MaxValue 999 INCREMENT BY 1 CACHE 2;
Create Table Str_Code_Transaction_Type                -- جدول ترميز أنواع الحركات
( Id         Number(3) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Str_Cod_TrnTyp_PK      PRIMARY KEY (Id  ),
  CONSTRAINT Str_Cod_TrnTyp_UK      UNIQUE      (Name),
  CONSTRAINT Str_Cod_TrnTyp_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Str_Cod_TrnTyp_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Str_Cod_TrnTyp For Str_Code_Transaction_Type
/
Insert into Str_Cod_TrnTyp (Id,Name) values (100,'Inbound'          );
Insert into Str_Cod_TrnTyp (Id,Name) values (150,'Transfer Inbound' );
Insert into Str_Cod_TrnTyp (Id,Name) values (200,'Outbound'         );
Insert into Str_Cod_TrnTyp (Id,Name) values (250,'Transfer OutBound');
Insert into Str_Cod_TrnTyp (Id,Name) values (300,'Transfer'         );
----------------------------------------------------------------------------------------------------
Create Sequence Str_Cod_Spec1_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Str_Code_Specification1                  -- جدول ترميز التصنيف 1
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Str_Cod_Spec1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Str_Cod_Spec1_UK     UNIQUE      (Name),
  CONSTRAINT Str_Cod_Spec1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Str_Cod_Spec1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Str_Cod_Spec1 For Str_Code_Specification1
/
Insert into Str_Cod_Spec1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Str_Cod_Spec2_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Str_Code_Specification2                  -- جدول ترميز التصنيف 2
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Str_Cod_Spec2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Str_Cod_Spec2_UK     UNIQUE      (Name),
  CONSTRAINT Str_Cod_Spec2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Str_Cod_Spec2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Str_Cod_Spec2 For Str_Code_Specification2
/
Insert into Str_Cod_Spec2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Str_Cod_Spec3_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Str_Code_Specification3                  -- جدول ترميز التصنيف 3
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Str_Cod_Spec3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Str_Cod_Spec3_UK     UNIQUE      (Name),
  CONSTRAINT Str_Cod_Spec3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Str_Cod_Spec3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Str_Cod_Spec3 For Str_Code_Specification3
/
Insert into Str_Cod_Spec3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Str_Cod_Spec4_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Str_Code_Specification4                  -- جدول ترميز التصنيف 4
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Str_Cod_Spec4_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Str_Cod_Spec4_UK     UNIQUE      (Name),
  CONSTRAINT Str_Cod_Spec4_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Str_Cod_Spec4_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Str_Cod_Spec4 For Str_Code_Specification4
/
Insert into Str_Cod_Spec4 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Str_Cod_Spec5_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Str_Code_Specification5                  -- جدول ترميز التصنيف 5
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Str_Cod_Spec5_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Str_Cod_Spec5_UK     UNIQUE      (Name),
  CONSTRAINT Str_Cod_Spec5_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Str_Cod_Spec5_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Str_Cod_Spec5 For Str_Code_Specification5
/
Insert into Str_Cod_Spec5 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Str_Cod_Loc1_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Str_Code_Location1                       -- جدول ترميز الموقع 1
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Str_Cod_Loc1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Str_Cod_Loc1_UK     UNIQUE      (Name),
  CONSTRAINT Str_Cod_Loc1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Str_Cod_Loc1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Str_Cod_Loc1 For Str_Code_Location1
/
Insert into Str_Cod_Loc1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Str_Cod_Loc2_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Str_Code_Location2                       -- جدول ترميز الموقع 2
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Str_Cod_Loc2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Str_Cod_Loc2_UK     UNIQUE      (Name),
  CONSTRAINT Str_Cod_Loc2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Str_Cod_Loc2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Str_Cod_Loc2 For Str_Code_Location2
/
Insert into Str_Cod_Loc2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Str_Cod_Loc3_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Str_Code_Location3                       -- جدول ترميز الموقع 3
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Str_Cod_Loc3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Str_Cod_Loc3_UK     UNIQUE      (Name),
  CONSTRAINT Str_Cod_Loc3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Str_Cod_Loc3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Str_Cod_Loc3 For Str_Code_Location3
/
Insert into Str_Cod_Loc3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Str_Item_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Items		                            -- دليل المواد
( Id         Number(9),                               -- مفتاح رئيسي
  Num        Varchar2(15 Char) NOT NULL,			        -- رقم المادة
  Name       VarChar2(100 Char) NOT NULL,		          -- اسم المادة
  Status_Id  Number(1) Default 1,				              -- الحالة
  Unit_Id    Number(5) Default 1,   	                -- الوحدة
  Spc1_Id    Number(5) Default 1,   	                -- تصنيف 1
  Spc2_Id    Number(5) Default 1,                     -- تصنيف 2
  Spc3_Id    Number(5) Default 1,   	                -- تصنيف 3
  Spc4_Id    Number(5) Default 1,   	                -- تصنيف 4
  Spc5_Id    Number(5) Default 1,   	                -- تصنيف 5
  Rem        VarChar2(100 Char),			                -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Str_Item_PK        PRIMARY KEY (Id       ),
  CONSTRAINT Str_Item_Num_Uk    Unique      (Num      ),
  CONSTRAINT Str_Item_Name_Uk   Unique      (Name     ),
  CONSTRAINT Str_Item_Unit_FK   Foreign Key (Unit_Id  ) References Cpy_Cod_Unit  (Id),
  CONSTRAINT Str_Item_Spc1_FK   Foreign Key (Spc1_Id  ) References Str_Cod_Spec1 (Id),
  CONSTRAINT Str_Item_Spc2_FK   Foreign Key (Spc2_Id  ) References Str_Cod_Spec2 (Id),
  CONSTRAINT Str_Item_Spc3_FK   Foreign Key (Spc3_Id  ) References Str_Cod_Spec3 (Id),
  CONSTRAINT Str_Item_Spc4_FK   Foreign Key (Spc4_Id  ) References Str_Cod_Spec4 (Id),
  CONSTRAINT Str_Item_Spc5_FK   Foreign Key (Spc5_Id  ) References Str_Cod_Spec5 (Id),
  CONSTRAINT Str_Item_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Str_Item_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Str_Item_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Str_Item For Str_Items
/

Create Sequence Str_Store_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Str_Stores		                            -- دليل المخازن
( Id          Number(5),			                        -- مفتاح رئيسي
  Name        Varchar2(100 Char),		                  -- اسم المخزن
  Rem         Varchar2(100 Char),		                  -- ملاحظات
  Status_Id   Number(1) Default 1,				            -- الحالة
  Cost_Id     Number(9) NOT NULL,       			        -- مركز الكلفة
  Acc_Id      Number(9) NOT NULL,       			        -- حساب المخزن
  CstAcc_Id   NUMBER(9) DEFAULT 0,                    -- حساب التكلفة
  RevAcc_Id   NUMBER(9) DEFAULT 0,                    -- حساب الإيراد
  Emp_Id      Number(9) Default 0 NOT NULL,           -- أمين المستودع
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Str_Store_PK           PRIMARY KEY (Id  ),
  CONSTRAINT  Str_Store_Uk           Unique      (Name),
  CONSTRAINT  Str_Store_Cost_Id_FK   Foreign Key (Cost_Id  ) References Acc_Cost      (Id),
  CONSTRAINT  Str_Store_Acc_Id_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT  Str_Store_CstAcc_Id_FK FOREIGN KEY (CstAcc_Id) REFERENCES Acc_Acc       (Id),
  CONSTRAINT  Str_Store_RevAcc_Id_FK FOREIGN KEY (RevAcc_Id) REFERENCES Acc_Acc       (Id),
  CONSTRAINT  Str_Store_Status_FK    Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  Str_Store_Ins_FK       Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Str_Store_Upd_FK       Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Str_Store For Str_Stores
/

Create Sequence Str_DefAcc_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Default_Accounts		                  -- دليل الحسابات الافتراضية
( Id          Number(9),			                        -- مفتاح رئيسي
  Stor_Id     Number(5) NOT NULL,			                -- المخزن
  TrnTyp_Id   Number(3) NOT NULL,                     -- نوع الحركة
  CstAcc_Id   Number(9) NOT NULL,                     -- حساب الكلفة
  RevAcc_Id   Number(9) NOT NULL,                     -- حساب الإيراد
  Rem         Varchar2(100 Char),		                  -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Str_DefAcc_PK            PRIMARY KEY (Id  ),
  CONSTRAINT  Str_DefAcc_Uk            Unique      (Stor_Id, TrnTyp_Id),
  CONSTRAINT  Str_DefAcc_Stor_FK       Foreign Key (Stor_Id  ) References Str_Store     (Id),
  CONSTRAINT  Str_DefAcc_TrnTyp_FK     Foreign Key (TrnTyp_Id) References Str_Cod_TrnTyp(Id),
  CONSTRAINT  Str_DefAcc_CstAcc_Id_FK  Foreign Key (CstAcc_Id) References Acc_Acc       (Id),
  CONSTRAINT  Str_DefAcc_RevAcc_Id_FK  Foreign Key (RevAcc_Id) References Acc_Acc       (Id),
  CONSTRAINT  Str_DefAcc_Ins_FK        Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Str_DefAcc_Upd_FK        Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Str_DefAcc For Str_Default_Accounts
/

Create Sequence Str_SMat_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Stores_Materiales                    -- دليل مواد مخزن
( Id           Number(9),			                        -- مفتاح رئيسي
  Stor_Id      Number(5) NOT NULL,		                -- المخزن
  Item_Id      Number(9) NOT NULL,		                -- المادة
  Loc1_Id      Number(5) Default 0,			              -- مكان تخزين 1
  Loc2_Id      Number(5) DEfault 0,			              -- مكان تخزين 2
  Loc3_Id      Number(5) Default 0,			              -- مكان تخزين 3
  Status_Id    Number(1) Default 1,				            -- الحالة
  Req_Limit    Number(25,3) Default 0,			          -- حد الطلب السنوي
  Min_Limit    Number(25,3) Default 0,			          -- الحد الأدنى السنوي
  Max_Limit    Number(25,3) Default 0,			          -- الحد الأعلى السنوي
  CQnt         Number(25,3) Default 0,			          -- كمية حالية
  CAmt         Number(13,3) Default 0,			          -- قيمة كمية حالية
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT   Str_SMat_PK         PRIMARY KEY (Id),
  CONSTRAINT   Str_SMat_Uk         Unique      (Stor_Id,Item_Id),
  CONSTRAINT   Str_SMat_Stor_FK    Foreign Key (Stor_Id  ) References Str_Store     (Id),
  CONSTRAINT   Str_SMat_Item_FK    Foreign Key (Item_Id  ) References Str_Item      (Id),
  CONSTRAINT   Str_SMat_Loc1_FK    Foreign Key (Loc1_Id  ) References Str_Cod_Loc1  (Id),
  CONSTRAINT   Str_SMat_Loc2_FK    Foreign Key (Loc2_Id  ) References Str_Cod_Loc2  (Id),
  CONSTRAINT   Str_SMat_Loc3_FK    Foreign Key (Loc3_Id  ) References Str_Cod_Loc3  (Id),
  CONSTRAINT   Str_SMat_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT   Str_SMat_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT   Str_SMat_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Str_SMat For Str_Stores_Materiales
/

Create Sequence Str_InMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Input_Master		                      -- ترويسة الادخال
( Id         Number(10),        	                    -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                      -- فترة العمل
  Stor_Id    Number(5) NOT NULL,                      -- المخزن
  Acc_Id     Number(9) NOT NULL,                      -- الحساب
  Vhr_Id     Number(10),                              -- مفتاح سند القيد
  Doc_Id     Number(5) Default 0 NOT NULL,            -- نوع المستند
  Num        Number(9) NOT NULL,	                    -- رقم الوثيقة
  dDate      Date,						                        -- التاريخ
  DocN       Varchar2(15),		                        -- رقم المستند
  DocD       Date,						                        -- تاريخ المستند
  Rem        Varchar2(250 Char),			                -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Str_InMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Str_InMst_UK        Unique      (Period_Id, Stor_Id, Num),
  CONSTRAINT Str_InMst_Period_FK Foreign Key (Period_Id) References Cpy_Period (Id),
  CONSTRAINT Str_InMst_Stor_FK   Foreign Key (Stor_Id  ) References Str_Store  (Id),
  CONSTRAINT Str_InMst_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc    (Id),
  CONSTRAINT Str_InMst_Vhr_FK    Foreign Key (Vhr_Id   ) References Acc_Mst    (Id),
  CONSTRAINT Str_InMst_Doc_FK    Foreign Key (Doc_Id   ) References Str_Cod_Doc(Id),
  CONSTRAINT Str_InMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT Str_InMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Str_InMst For Str_Input_Master
/

Create Sequence Str_InTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Input_Trans			                    -- بنود الادخال
( Id          Number(20),                             -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                    -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                     -- المادة
  Ord         Number(5) Default 0,						        -- مسلسل
  Qnt         Number(25,3) Default 0,	                -- الكمية
  Price       Number(25,3) Default 0,	                -- الاافرادي
  Cst         Number(25,3) Default 0,	                -- الكلفة
  Amt         Number(25,3) Default 0,	                -- القيمة
  Rem         Varchar2(250 Char),			                -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Str_InTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Str_InTrn_Mst_FK    Foreign Key (Mst_Id  ) References Str_InMst (Id),
  CONSTRAINT  Str_InTrn_Item_FK   Foreign Key (Item_Id ) References Str_Item  (Id),
  CONSTRAINT  Str_InTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT  Str_InTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Str_InTrn For Str_Input_Trans
/

Create Sequence Str_OuMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Output_Master		                    -- ترويسة الاخراج
( Id         Number(10) NOT NULL,	                    -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                      -- فترة العمل
  Stor_Id    Number(5) NOT NULL,                      -- المخزن
  Acc_Id     Number(9) NOT NULL,                      -- الحساب
  Vhr_Id     Number(10),                              -- مفتاح سند القيد
  Doc_Id     Number(5) Default 0 NOT NULL,            -- نوع المستند
  Num        Number(9) NOT NULL,	                    -- رقم الوثيقة
  dDate      Date,						                        -- التاريخ
  DocN       Varchar2(15),		                        -- رقم المستند
  DocD       Date,						                        -- تاريخ المستند
  Rem        Varchar2(250 Char),			                -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Str_OuMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Str_OuMst_UK        Unique      (Period_Id, Stor_Id, Num),
  CONSTRAINT Str_OuMst_Period_FK Foreign Key (Period_Id) References Cpy_Period (Id),
  CONSTRAINT Str_OuMst_Stor_FK   Foreign Key (Stor_Id  ) References Str_Store  (Id),
  CONSTRAINT Str_OuMst_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc    (Id),
  CONSTRAINT Str_OuMst_Vhr_FK    Foreign Key (Vhr_Id   ) References Acc_Mst    (Id),
  CONSTRAINT Str_OuMst_Doc_FK    Foreign Key (Doc_Id   ) References Str_Cod_Doc(Id),
  CONSTRAINT Str_OuMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT Str_OuMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Str_OuMst For Str_Output_Master
/

Create Sequence Str_OuTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Output_Trans			                    -- بنود الإخراج
( Id          Number(20) NOT NULL,                    -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                    -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                     -- المادة
  Ord         Number(5) Default 0,						        -- مسلسل
  Qnt         Number(25,3) Default 0,	                -- الكمية
  Price       Number(25,3) Default 0,	                -- الاافرادي
  Cst         Number(25,3) Default 0,	                -- الكلفة
  Amt         Number(25,3) Default 0,	                -- القيمة
  Rem         Varchar2(250 Char),			                -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Str_OuTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Str_OuTrn_Mst_FK    Foreign Key (Mst_Id  ) References Str_OuMst (Id),
  CONSTRAINT  Str_OuTrn_Item_FK   Foreign Key (Item_Id ) References Str_Item  (Id),
  CONSTRAINT  Str_OuTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT  Str_OuTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Str_OuTrn For Str_Output_Trans
/

Create Sequence Str_TrMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Transfer_Master		                  -- ترويسة الترحيل
( Id         Number(10) NOT NULL,	                    -- مفتاح رئيسي
  Period_Id  Number(4) NOT NULL,                      -- فترة العمل
  StorF_Id   Number(5) NOT NULL,                      -- المخزن المرحل منه
  StorT_Id   Number(5) NOT NULL,                      -- المخزن المرحل إليه
  Vhr_Id     Number(10),                              -- مفتاح سند القيد
  Doc_Id     Number(5) Default 0 NOT NULL,            -- نوع المستند
  Num        Number(9) NOT NULL,	                    -- رقم الوثيقة
  dDate      Date,						                        -- التاريخ
  DocN       Varchar2(15),		                        -- رقم المستند
  DocD       Date,						                        -- تاريخ المستند
  Rem        Varchar2(250 Char),			                -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Str_TrMst_PK        PRIMARY KEY (Id),
  CONSTRAINT Str_TrMst_UK        Unique      (Period_Id, StorF_Id, Num),
  CONSTRAINT Str_TrMst_WPer_FK   Foreign Key (Period_Id) References Cpy_Period (Id),
  CONSTRAINT Str_TrMst_StorF_FK  Foreign Key (StorF_Id ) References Str_Store  (Id),
  CONSTRAINT Str_TrMst_StorT_FK  Foreign Key (StorT_Id ) References Str_Store  (Id),
  CONSTRAINT Str_TrMst_Vhr_FK    Foreign Key (Vhr_Id   ) References Acc_Mst    (Id),
  CONSTRAINT Str_TrMst_Doc_FK    Foreign Key (Doc_Id   ) References Str_Cod_Doc(Id),
  CONSTRAINT Str_TrMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT Str_TrMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Str_TrMst For Str_Transfer_Master
/

Create Sequence Str_TrTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Transfer_Trans			                  -- بنود الترحيل
( Id          Number(20) NOT NULL,                    -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                    -- مفتاح الأب
  SMat_FId    Number(9) NOT NULL,                     -- المادة في المستودع من
  SMat_TId    Number(9) NOT NULL,                     -- المادة في المستودع إلى
  Item_Id     Number(9) NOT NULL,                     -- المادة
  Ord         Number(5) Default 0,						        -- مسلسل
  Qnt         Number(25,3) Default 0,	                -- الكمية
  Price       Number(25,3) Default 0,	                -- الاافرادي
  Cst         Number(25,3) Default 0,	                -- الكلفة
  Amt         Number(25,3) Default 0,	                -- القيمة
  Rem         Varchar2(250 Char),			                -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Str_TrTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Str_TrTrn_Mst_FK    Foreign Key (Mst_Id  ) References Str_TrMst (Id),
  CONSTRAINT  Str_TrTrn_Item_FK   Foreign Key (Item_Id ) References Str_Item  (Id),
  CONSTRAINT  Str_TrTrn_SMatF_FK  Foreign Key (SMat_FId) References Str_SMat  (Id),
  CONSTRAINT  Str_TrTrn_SMatT_FK  Foreign Key (SMat_TId) References Str_SMat  (Id),
  CONSTRAINT  Str_TrTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT  Str_TrTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Str_TrTrn For Str_Transfer_Trans
/

Create Sequence Str_ActMst_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Actual_Master		                    -- ترويسة الجرد الفعلي
( Id          Number(10) NOT NULL,	                  -- مفتاح رئيسي
  Period_Id   Number(4) NOT NULL,                     -- فترة العمل
  Stor_Id     Number(5) NOT NULL,                     -- المخزن
  Doc_Id      Number(5) Default 0 NOT NULL,           -- نوع المستند
  Num         Number(9) NOT NULL,                     -- رقم الوثيقة
  dDate       Date,						                        -- التاريخ
  DocN        Varchar2(15),		                        -- رقم المستند
  DocD        Date,						                        -- تاريخ المستند
  responsible varchar(250),                           -- المسؤول
  Rem         Varchar2(250 Char),			                -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Str_ActMst_PK        PRIMARY KEY (Id),
  CONSTRAINT  Str_ActMst_UK        Unique      (Period_Id, Stor_Id, Num),
  CONSTRAINT  Str_ActMst_WPer_FK   Foreign Key (Period_Id) References Cpy_Period (Id),
  CONSTRAINT  Str_ActMst_Stor_FK   Foreign Key (Stor_Id  ) References Str_Store  (Id),
  CONSTRAINT  Str_ActMst_Doc_FK    Foreign Key (Doc_Id   ) References Str_Cod_Doc(Id),
  CONSTRAINT  Str_ActMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT  Str_ActMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Str_ActMst For Str_Actual_Master
/

Create Sequence Str_ActTrn_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Str_Actual_Trans			                    -- بنود الجرد الفعلي
( Id          Number(20) NOT NULL,                    -- مفتاح رئيسي
  Mst_Id      Number(10) NOT NULL,                    -- مفتاح الأب
  Item_Id     Number(9) NOT NULL,                     -- المادة
  Ord         Number(5) Default 0,						        -- مسلسل
  Qnt         Number(25,3) Default 0,	                -- الكمية
  Rem         Varchar2(250 Char),			                -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Str_ActTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Str_ActTrn_Mst_FK    Foreign Key (Mst_Id  ) References Str_ActMst(Id),
  CONSTRAINT  Str_ActTrn_Item_FK   Foreign Key (Item_Id ) References Str_Item  (Id),
  CONSTRAINT  Str_ActTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT  Str_ActTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Str_ActTrn For Str_Actual_Trans
/
