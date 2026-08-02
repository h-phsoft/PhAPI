--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'FIX%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'FIX%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'FIX%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'FIX%' ;
----------------------------------------------------------------------------------------------------
Create Sequence FixId_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;

----------------------------------------------------------------------------------------------------
Create Sequence Fix_TmpLbl_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Fix_Temp_Labels
( Id           Number(20),		                      -- مفتاح الأب 
  Barcode      Varchar2(30 Char),		                -- الباركود
  Fixd_Id      Number(9),  		                      -- مفتاح المادة
  Num          Number(10),  		                    -- رقم المادة
  Name         Varchar2(100 Char),					        -- اسم المادة
  Serial       Varchar2(30 Char),					          -- تسلسل
  Qnt          Number(25,3) Default 1,              -- العدد
  Dummy        Number(1) Default 0
)
/
Create Synonym Fix_TmpLbl For Fix_Temp_Labels
/
----------------------------------------------------------------------------------------------------
Create Sequence Fix_Cod_Spec1_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Code_Specification1                  -- جدول ترميز مواصفات الموجودات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fix_Cod_Spec1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fix_Cod_Spec1_UK     UNIQUE      (Name),
  CONSTRAINT Fix_Cod_Spec1_Ins_FK Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fix_Cod_Spec1_Upd_FK Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fix_Cod_Spec1 For Fix_Code_Specification1
/
Insert into Fix_Cod_Spec1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fix_Cod_Spec2_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Code_Specification2                  -- جدول ترميز مواصفات الموجودات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fix_Cod_Spec2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fix_Cod_Spec2_UK     UNIQUE      (Name),
  CONSTRAINT Fix_Cod_Spec2_Ins_FK Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fix_Cod_Spec2_Upd_FK Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fix_Cod_Spec2 For Fix_Code_Specification2
/
Insert into Fix_Cod_Spec2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fix_Cod_Spec3_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Code_Specification3                  -- جدول ترميز مواصفات الموجودات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fix_Cod_Spec3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fix_Cod_Spec3_UK     UNIQUE      (Name),
  CONSTRAINT Fix_Cod_Spec3_Ins_FK Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fix_Cod_Spec3_Upd_FK Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fix_Cod_Spec3 For Fix_Code_Specification3
/
Insert into Fix_Cod_Spec3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fix_Cod_Spec4_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Code_Specification4                  -- جدول ترميز مواصفات الموجودات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fix_Cod_Spec4_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fix_Cod_Spec4_UK     UNIQUE      (Name),
  CONSTRAINT Fix_Cod_Spec4_Ins_FK Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fix_Cod_Spec4_Upd_FK Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fix_Cod_Spec4 For Fix_Code_Specification4
/
Insert into Fix_Cod_Spec4 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fix_Cod_Spec5_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Code_Specification5                  -- جدول ترميز مواصفات الموجودات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fix_Cod_Spec5_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fix_Cod_Spec5_UK     UNIQUE      (Name),
  CONSTRAINT Fix_Cod_Spec5_Ins_FK Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fix_Cod_Spec5_Upd_FK Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fix_Cod_Spec5 For Fix_Code_Specification5
/
Insert into Fix_Cod_Spec5 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fix_Cod_Status_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Code_Status                          -- جدول ترميز الحالة الفنية للموجودات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fix_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fix_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Fix_Cod_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fix_Cod_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fix_Cod_Status For Fix_Code_Status
/
Insert into Fix_Cod_Status (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fix_Cod_Loc1_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Code_Location1                       -- جدول ترميز موقع الموجودات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fix_Cod_Loc1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fix_Cod_Loc1_UK     UNIQUE      (Name),
  CONSTRAINT Fix_Cod_Loc1_Ins_FK Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fix_Cod_Loc1_Upd_FK Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fix_Cod_Loc1 For Fix_Code_Location1
/
Insert into Fix_Cod_Loc1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fix_Cod_Loc2_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Code_Location2                       -- جدول ترميز موقع الموجودات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fix_Cod_Loc2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fix_Cod_Loc2_UK     UNIQUE      (Name),
  CONSTRAINT Fix_Cod_Loc2_Ins_FK Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fix_Cod_Loc2_Upd_FK Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fix_Cod_Loc2 For Fix_Code_Location2
/
Insert into Fix_Cod_Loc2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fix_Cod_Loc3_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Code_Location3                       -- جدول ترميز موقع الموجودات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fix_Cod_Loc3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fix_Cod_Loc3_UK     UNIQUE      (Name),
  CONSTRAINT Fix_Cod_Loc3_Ins_FK Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fix_Cod_Loc3_Upd_FK Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fix_Cod_Loc3 For Fix_Code_Location3
/
Insert into Fix_Cod_Loc3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fix_Fixed_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Fixeds_Items					    -- دليل الموجودات الثابتة
( Id         Number(9),					          -- مفتاح رئيسي
  Num        Varchar2(25 Char),					  -- رقم المادة
  Spc1_Id    Number(5) Default 0,				  -- تصنيف 1
  Spc2_Id    Number(5) Default 0,				  -- تصنيف 2
  Spc3_Id    Number(5) Default 0,				  -- تصنيف 3
  Spc4_Id    Number(5) Default 0,				  -- تصنيف 4
  Spc5_Id    Number(5) Default 0,				  -- تصنيف 4
  Perc       Number(6,2) Default 1,				-- نسبة الإهتلاك
  Unit_Id    Number(5) NOT NULL,				  -- الوحدة
  Acc_Id     Number(9) Default 0,         -- حساب مصروف الاهتلاك
  Acc_DId    Number(9) Default 0,         -- حساب الإهتلاك
  Acc_RId    Number(9) Default 0,         -- حساب مخصص الإهتلاك
  Acc_FId    Number(9) Default 0,         -- حساب الأصل الثابت
  Name       Varchar2(100 Char),					-- اسم المادة
  Rem        Varchar2(100 Char),					-- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fix_Fixd_PK        PRIMARY KEY (Id),
  CONSTRAINT Fix_Fixd_Num_Uk    Unique      (Num),
  CONSTRAINT Fix_Fixd_Name_Uk   Unique      (Name),
  CONSTRAINT Fix_Fixd_Spc1_FK   Foreign Key (Spc1_Id ) References Fix_Cod_Spec1(Id),
  CONSTRAINT Fix_Fixd_Spc2_FK   Foreign Key (Spc2_Id ) References Fix_Cod_Spec2(Id),
  CONSTRAINT Fix_Fixd_Spc3_FK   Foreign Key (Spc3_Id ) References Fix_Cod_Spec3(Id),
  CONSTRAINT Fix_Fixd_Spc4_FK   Foreign Key (Spc4_Id ) References Fix_Cod_Spec4(Id),
  CONSTRAINT Fix_Fixd_Spc5_FK   Foreign Key (Spc5_Id ) References Fix_Cod_Spec5(Id),
  CONSTRAINT Fix_Fixd_Unit_FK   Foreign Key (Unit_Id ) References Cpy_Cod_Unit (Id),
  CONSTRAINT Fix_Fixd_Acc_FK    Foreign Key (Acc_Id  ) References Acc_Acc      (Id),
  CONSTRAINT Fix_Fixd_Acc_D_FK  Foreign Key (Acc_RId ) References Acc_Acc      (Id),
  CONSTRAINT Fix_Fixd_Acc_R_FK  Foreign Key (Acc_DId ) References Acc_Acc      (Id),
  CONSTRAINT Fix_Fixd_Acc_F_FK  Foreign Key (Acc_FId ) References Acc_Acc      (Id),
  CONSTRAINT Fix_Fixd_Ins_FK    Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Fix_Fixd_Upd_FK    Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Fix_Fixed For Fix_Fixeds_Items
/

Create Sequence Fix_InMst_Seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Input_Master					    -- ترويسة حركات الإدخال
( Id          Number(10),					        -- مفتاح رئيسي
  Num         Number(9),					        -- رقم الوثيقة
  Period_Id   Number(4),					        -- السنة
  Vhr_Id      Number(10),						      -- مفتاح الوثيقة المالية
  MDoc_Id     Number(10),						      -- مفتاح الوثيقة المالية
  Commit_Id   Number(1) Default 1,				-- حالة التثبيت
  Acc_Id      Number(9),         				  -- الحساب
  dDate       Date Default Sysdate,				-- تاريخ
  Rem         Varchar2(100 Char),					-- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Fix_InMst_PK        PRIMARY KEY (Id),
  CONSTRAINT  Fix_InMst_UK        Unique      (Period_Id,Num),
  CONSTRAINT  Fix_InMst_WPer_FK   Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT  Fix_InMst_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT  Fix_InMst_AccMst_FK Foreign Key (Vhr_Id   ) References Acc_Mst       (Id),
  CONSTRAINT  Fix_InMst_Commit_FK Foreign Key (Commit_Id) References Phs_Cod_Commit(Id),
  CONSTRAINT  Fix_InMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Fix_InMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fix_InMst For Fix_Input_Master
/
Create Sequence Fix_InTrn_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Input_Trans					      -- بنود حركات الإدخال
( Id          Number(20),					          -- مفتاح رئيسي
  Mst_Id      Number(10),					          -- مفتاح الأب
  Fixd_Id     Number(9),					          -- المادة
  Curn_Id     Number(5),         				    -- العملة
  Curn_Rate   Number(25,9) Default 1,       -- سعر الصرف
  Ord         Number(5),						        -- مسلسل
  SDate       Date Default Sysdate,				  -- تاريخ بداية اهتلاك
  EDate       Date Default Sysdate,				  -- تاريخ نهاية اهتلاك
  Qnt         Number(25,3) Default 0,				-- الكمية
  CQnt        Number(25,3) Default 0,				-- الكمية الحالية
  SQnt        Number(25,3) Default 0,				-- الكمية ضمن المجموعة
  SCQnt       Number(25,3) Default 0,				-- الكمية الحالية ضمن المجموعة
  Price       Number(25,3) Default 0,				-- سعر الوحدة
  Amt         Number(25,3) Default 0,				-- المبلغ
  CAmt        Number(25,3) Default 0,				-- المبلغ قطع
  Perc        Number(6,2) Default 0,				-- نسبة الإهتلاك
  FTot        Number(25,3) Default 0,				-- مجمع سابق
  FAmt        Number(25,3) Default 0,				-- اهتلاك حالي
  RTot        Number(25,3) Default 0,				-- احتياطي سابق
  RAmt        Number(25,3) Default 0,				-- احتياطي حالي
  Loc1_Id     Number(5) Default 0,				  -- الموقع 1
  Loc2_Id     Number(5) Default 0,				  -- الموقع 2
  Loc3_Id     Number(5) Default 0,				  -- الموقع 3
  Status_Id   Number(5) Default 0,				  -- الحالة الفنية
  Spc1_Id     Number(5) Default 0,				  -- تخصيص 1
  Spc2_Id     Number(5) Default 0,				  -- تخصيص 2
  Spc3_Id     Number(5) Default 0,				  -- تخصيص 3
  Spc4_Id     Number(5) Default 0,				  -- تخصيص 4
  Spc5_Id     Number(5) Default 0,				  -- تخصيص 5
  Spc6        Varchar2(200 Char),					  -- تخصيص 6
  Rem         Varchar2(100 Char),					  -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  Fix_InTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT  Fix_InTrn_Mst_FK    Foreign Key (Mst_Id   ) References Fix_InMst     (Id),
  CONSTRAINT  Fix_InTrn_Fixd_FK   Foreign Key (Fixd_Id  ) References Fix_Fixed     (Id),
  CONSTRAINT  Fix_InTrn_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn      (Id),
  CONSTRAINT  Fix_InTrn_Loc1_FK   Foreign Key (Loc1_Id  ) References Fix_Cod_Loc1  (Id),
  CONSTRAINT  Fix_InTrn_Loc2_FK   Foreign Key (Loc2_Id  ) References Fix_Cod_Loc2  (Id),
  CONSTRAINT  Fix_InTrn_Loc3_FK   Foreign Key (Loc3_Id  ) References Fix_Cod_Loc3  (Id),
  CONSTRAINT  Fix_InTrn_Status_FK Foreign Key (Status_Id) References Fix_Cod_Status(Id),
  CONSTRAINT  Fix_InTrn_Spc1_FK   Foreign Key (Spc1_Id  ) References Fix_Cod_Spec1 (Id),
  CONSTRAINT  Fix_InTrn_Spc2_FK   Foreign Key (Spc2_Id  ) References Fix_Cod_Spec2 (Id),
  CONSTRAINT  Fix_InTrn_Spc3_FK   Foreign Key (Spc3_Id  ) References Fix_Cod_Spec3 (Id),
  CONSTRAINT  Fix_InTrn_Spc4_FK   Foreign Key (Spc4_Id  ) References Fix_Cod_Spec4 (Id),
  CONSTRAINT  Fix_InTrn_Spc5_FK   Foreign Key (Spc5_Id  ) References Fix_Cod_Spec5 (Id),
  CONSTRAINT  Fix_InTrn_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Fix_InTrn_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fix_InTrn For Fix_Input_Trans
/

Create Sequence Fix_OuMst_Seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Output_Master					  -- ترويسة حركات الإخراج
( Id          Number(10),					        -- مفتاح رئيسي
  Num         Number(9),					        -- رقم الوثيقة
  Period_Id   Number(4),					        -- السنة
  MDoc_Id     Number(10),						      -- مفتاح الوثيقة المالية
  Vhr_Id      Number(10),						      -- مفتاح الوثيقة المالية
  Commit_Id   Number(1) Default 1,				-- حالة التثبيت
  Acc_Id      Number(9),         				  -- الحساب
  dDate       Date Default Sysdate,				-- تاريخ
  Rem         Varchar2(100 Char),					-- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Fix_OuMst_PK        PRIMARY KEY (Id),
  CONSTRAINT  Fix_OuMst_UK        Unique      (Period_Id,Num),
  CONSTRAINT  Fix_OuMst_WPer_FK   Foreign Key (Period_Id) References Cpy_Period    (Id),
  CONSTRAINT  Fix_OuMst_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT  Fix_OuMst_AccMst_FK Foreign Key (Vhr_Id   ) References Acc_Mst       (Id),
  CONSTRAINT  Fix_OuMst_Commit_FK Foreign Key (Commit_Id) References Phs_Cod_Commit(Id),
  CONSTRAINT  Fix_OuMst_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Fix_OuMst_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fix_OuMst For Fix_Output_Master
/
Create Sequence Fix_OuTrn_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Output_Trans					      -- بنود حركات الإخراج
( Id         Number(20),					          -- مفتاح رئيسي
  Mst_Id     Number(10),					          -- مفتاح الأب
  Ord        Number(5),						          -- مسلسل
  Cost_Id    Number(9),        				      -- مركز الكلفة  
  Fixd_Id    Number(9),					            -- المادة
  Trn_Id     Number(20),					          -- مفتاح بند حركة الإدخال
  Curn_Id    Number(5),         				    -- العملة
  Curn_Rate  Number(25,9) Default 1,        -- سعر الصرف
  Qnt        Number(25,3) Default 0,				-- الكمية
  Price      Number(25,3) Default 0,				-- سعر الوحدة
  Amt        Number(25,3) Default 0,				-- المبلغ
  CAmt       Number(25,3) Default 0,				-- المبلغ قطع
  UCst       Number(25,3) Default 0,				-- تكلفة الوحدة
  Cst        Number(25,3) Default 0,				-- الكلفة
  CCst       Number(25,3) Default 0,				-- الكلفة قطع
  Perc       Number(6,2) Default 1,				  -- نسبة الإهتلاك
  FTot       Number(25,3) Default 0,				-- مجمع سابق
  FAmt       Number(25,3) Default 0,				-- اهتلاك حالي
  RTot       Number(25,3) Default 0,				-- احتياطي سابق
  RAmt       Number(25,3) Default 0,				-- احتياطي حالي
  Rem        Varchar2(100 Char),					  -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Fix_OuTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT Fix_OuTrn_FMst_FK   Foreign Key (Mst_Id  ) References Fix_OuMst(Id),
  CONSTRAINT Fix_OuTrn_Cost_FK   Foreign Key (Cost_Id ) References Acc_Cost (Id),
  CONSTRAINT Fix_OuTrn_Fixd_FK   Foreign Key (Fixd_Id ) References Fix_Fixed(Id),
  CONSTRAINT Fix_OuTrn_FInTrn_FK Foreign Key (Trn_Id  ) References Fix_InTrn(Id),
  CONSTRAINT Fix_OuTrn_Curn_FK   Foreign Key (Curn_Id ) References Mng_Curn (Id),
  CONSTRAINT Fix_OuTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Fix_OuTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Fix_OuTrn For Fix_Output_Trans
/

Create Sequence Fix_ResMst_Seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Responsibility_Master		-- ترويسة حركات العهدة
( Id          Number(10),					        -- مفتاح رئيسي
  Num         Number(9),					        -- رقم الوثيقة
  Period_Id   Number(4),					        -- السنة
  Emp_Id      Number(9),					        -- الموظف مستلم العهدة
  Commit_Id   Number(1) Default 1,				-- حالة التثبيت
  dDate       Date Default Sysdate,				-- تاريخ
  Rem         Varchar2(100 Char),					-- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Fix_ResMst_PK      PRIMARY KEY (Id),
  CONSTRAINT  Fix_ResMst_UK      Unique      (Period_Id,Num),
  CONSTRAINT  Fix_ResMst_WPer_FK Foreign Key (Period_Id) References Cpy_Period(Id),
  CONSTRAINT  Fix_ResMst_Ins_FK  Foreign Key (Ins_User ) References Cpy_User  (Id),
  CONSTRAINT  Fix_ResMst_Upd_FK  Foreign Key (Upd_User ) References Cpy_User  (Id)
)
/
Create Synonym Fix_ResMst For Fix_Responsibility_Master
/
Create Sequence Fix_ResTrn_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Responsibility_Trans				-- بنود حركات العهدة
( Id         Number(20),					          -- مفتاح رئيسي
  Mst_Id     Number(10),					          -- مفتاح الأب
  Ord        Number(5),						          -- مسلسل
  Fixd_Id    Number(9),					            -- المادة
  FTrn_Id    Number(20),					          -- مفتاح بند حركة الإدخال
  Qnt        Number(25,3) Default 0,				-- الكمية
  Rem        Varchar2(100 Char),					  -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Fix_ResTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT Fix_ResTrn_FMst_FK   Foreign Key (Mst_Id  ) References Fix_ResMst(Id),
  CONSTRAINT Fix_ResTrn_FInTrn_FK Foreign Key (FTrn_Id ) References Fix_InTrn (Id),
  CONSTRAINT Fix_ResTrn_Fixd_FK   Foreign Key (Fixd_Id ) References Fix_Fixed (Id),
  CONSTRAINT Fix_ResTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT Fix_ResTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Fix_ResTrn For Fix_Responsibility_Trans
/

Create Sequence Fix_LocMst_Seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Location_Master		      -- ترويسة حركات الموقع
( Id          Number(10),					        -- مفتاح رئيسي
  Num         Number(9),					        -- رقم الوثيقة
  Period_Id   Number(4),					        -- السنة
  dDate       Date Default Sysdate,				-- تاريخ
  Rem         Varchar2(100 Char),					-- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Fix_LocMst_PK      PRIMARY KEY (Id),
  CONSTRAINT  Fix_LocMst_UK      Unique      (Period_Id,Num),
  CONSTRAINT  Fix_LocMst_WPer_FK Foreign Key (Period_Id) References Cpy_Period(Id),
  CONSTRAINT  Fix_LocMst_Ins_FK  Foreign Key (Ins_User ) References Cpy_User  (Id),
  CONSTRAINT  Fix_LocMst_Upd_FK  Foreign Key (Upd_User ) References Cpy_User  (Id)
)
/
Create Synonym Fix_LocMst For Fix_Location_Master
/
Create Sequence Fix_LocTrn_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Location_Trans				      -- بنود حركات الموقع
( Id         Number(20),					          -- مفتاح رئيسي
  FMst_Id    Number(10),					          -- مفتاح الأب
  Ord        Number(5),						          -- مسلسل
  Fixd_Id    Number(9),					          -- المادة
  FTrn_Id    Number(20),					          -- مفتاح بند حركة الإدخال
  oLoc1_Id   Number(5) Default 0,				  -- الموقع 1
  oLoc2_Id   Number(5) Default 0,				  -- الموقع 2
  oLoc3_Id   Number(5) Default 0,				  -- الموقع 3
  Loc1_Id    Number(5) Default 0,				  -- الموقع 1
  Loc2_Id    Number(5) Default 0,				  -- الموقع 2
  Loc3_Id    Number(5) Default 0,				  -- الموقع 3
  Rem        Varchar2(100 Char),					-- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Fix_LocTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT Fix_LocTrn_FMst_FK   Foreign Key (FMst_Id ) References Fix_LocMst  (Id),
  CONSTRAINT Fix_LocTrn_FInTrn_FK Foreign Key (FTrn_Id ) References Fix_InTrn   (Id),
  CONSTRAINT Fix_LocTrn_Fixd_FK   Foreign Key (Fixd_Id ) References Fix_Fixed   (Id),
  CONSTRAINT Fix_LocTrn_oLoc1_FK  Foreign Key (oLoc1_Id) References Fix_Cod_Loc1(Id),
  CONSTRAINT Fix_LocTrn_oLoc2_FK  Foreign Key (oLoc2_Id) References Fix_Cod_Loc2(Id),
  CONSTRAINT Fix_LocTrn_oLoc3_FK  Foreign Key (oLoc3_Id) References Fix_Cod_Loc3(Id),
  CONSTRAINT Fix_LocTrn_Loc1_FK   Foreign Key (Loc1_Id ) References Fix_Cod_Loc1(Id),
  CONSTRAINT Fix_LocTrn_Loc2_FK   Foreign Key (Loc2_Id ) References Fix_Cod_Loc2(Id),
  CONSTRAINT Fix_LocTrn_Loc3_FK   Foreign Key (Loc3_Id ) References Fix_Cod_Loc3(Id),
  CONSTRAINT Fix_LocTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Fix_LocTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Fix_LocTrn For Fix_Location_Trans
/

Create Sequence Fix_SpcMst_Seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Specification_Master		  -- ترويسة حركات المواصفات
( Id          Number(10),					        -- مفتاح رئيسي
  Num         Number(9),					        -- رقم الوثيقة
  Period_Id   Number(4),					        -- السنة
  dDate       Date Default Sysdate,				-- تاريخ
  Rem         Varchar2(100 Char),					-- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Fix_SpcMst_PK      PRIMARY KEY (Id),
  CONSTRAINT  Fix_SpcMst_UK      Unique      (Period_Id,Num),
  CONSTRAINT  Fix_SpcMst_WPer_FK Foreign Key (Period_Id) References Cpy_Period(Id),
  CONSTRAINT  Fix_SpcMst_Ins_FK  Foreign Key (Ins_User ) References Cpy_User  (Id),
  CONSTRAINT  Fix_SpcMst_Upd_FK  Foreign Key (Upd_User ) References Cpy_User  (Id)
)
/
Create Synonym Fix_SpcMst For Fix_Specification_Master
/
Create Sequence Fix_SpcTrn_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Specification_Trans				    -- بنود حركات تعديل المواصفات
( Id           Number(20),					            -- مفتاح رئيسي
  FMst_Id      Number(10),					            -- مفتاح الأب
  Ord          Number(5),						            -- مسلسل
  Fixd_Id      Number(9),					            -- المادة
  FTrn_Id      Number(20),					            -- مفتاح بند حركة الإدخال
  OSpc1_Id     Number(5) Default 0,				    -- تخصيص 1
  OSpc2_Id     Number(5) Default 0,				    -- تخصيص 2
  OSpc3_Id     Number(5) Default 0,				    -- تخصيص 3
  OSpc4_Id     Number(5) Default 0,				    -- تخصيص 4
  OSpc5_Id     Number(5) Default 0,				    -- تخصيص 5
  OStatus_Id   Number(5) Default 0,				    -- الحالة الفنية
  OSpc6        Varchar2(200 Char),					  -- تخصيص 6
  Spc1_Id      Number(5) Default 0,				    -- تخصيص 1
  Spc2_Id      Number(5) Default 0,				    -- تخصيص 2
  Spc3_Id      Number(5) Default 0,				    -- تخصيص 3
  Spc4_Id      Number(5) Default 0,				    -- تخصيص 4
  Spc5_Id      Number(5) Default 0,				    -- تخصيص 5
  Status_Id    Number(5) Default 0,				    -- الحالة الفنية
  Spc6         Varchar2(200 Char),					  -- تخصيص 6
  Rem          Varchar2(100 Char),					  -- ملاحظات
  Ins_User     Number(20),  Ins_Date    Date,
  Upd_User     Number(20),  Upd_Date    Date,
  CONSTRAINT   Fix_SpcTrn_PK         PRIMARY KEY (Id),
  CONSTRAINT   Fix_SpcTrn_FMst_FK    Foreign Key (FMst_Id   ) References Fix_SpcMst    (Id),
  CONSTRAINT   Fix_SpcTrn_FInTrn_FK  Foreign Key (FTrn_Id   ) References Fix_InTrn     (Id),
  CONSTRAINT   Fix_SpcTrn_Fixd_FK    Foreign Key (Fixd_Id   ) References Fix_Fixed     (Id),
  CONSTRAINT   Fix_SpcTrn_oSpc1_FK   Foreign Key (oSpc1_Id  ) References Fix_Cod_Spec1 (Id),
  CONSTRAINT   Fix_SpcTrn_oSpc2_FK   Foreign Key (oSpc2_Id  ) References Fix_Cod_Spec2 (Id),
  CONSTRAINT   Fix_SpcTrn_oSpc3_FK   Foreign Key (oSpc3_Id  ) References Fix_Cod_Spec3 (Id),
  CONSTRAINT   Fix_SpcTrn_oSpc4_FK   Foreign Key (oSpc4_Id  ) References Fix_Cod_Spec4 (Id),
  CONSTRAINT   Fix_SpcTrn_oSpc5_FK   Foreign Key (oSpc5_Id  ) References Fix_Cod_Spec5 (Id),
  CONSTRAINT   Fix_SpcTrn_oStatus_FK Foreign Key (oStatus_Id) References Fix_Cod_Status(Id),
  CONSTRAINT   Fix_SpcTrn_Spc1_FK    Foreign Key (Spc1_Id   ) References Fix_Cod_Spec1 (Id),
  CONSTRAINT   Fix_SpcTrn_Spc2_FK    Foreign Key (Spc2_Id   ) References Fix_Cod_Spec2 (Id),
  CONSTRAINT   Fix_SpcTrn_Spc3_FK    Foreign Key (Spc3_Id   ) References Fix_Cod_Spec3 (Id),
  CONSTRAINT   Fix_SpcTrn_Spc4_FK    Foreign Key (Spc4_Id   ) References Fix_Cod_Spec4 (Id),
  CONSTRAINT   Fix_SpcTrn_Spc5_FK    Foreign Key (Spc5_Id   ) References Fix_Cod_Spec5 (Id),
  CONSTRAINT   Fix_SpcTrn_Status_FK  Foreign Key (Status_Id ) References Fix_Cod_Status(Id),
  CONSTRAINT   Fix_SpcTrn_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User      (Id),
  CONSTRAINT   Fix_SpcTrn_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User      (Id)
)
/
Create Synonym Fix_SpcTrn For Fix_Specification_Trans
/

Create Sequence Fix_ActMst_Seq MinValue 100 Start With 100 MaxValue 9999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Actual_Master		        -- ترويسة حركات الجرد
( Id          Number(10),					        -- مفتاح رئيسي
  Num         Number(9),					        -- رقم الوثيقة
  Period_Id   Number(4),					        -- السنة
  Status_Id   Number(5) Default 1,				-- حالة التثبيت
  dDate       Date Default Sysdate,				-- تاريخ
  Rem         Varchar2(100 Char),					-- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Fix_ActMst_PK      PRIMARY KEY (Id),
  CONSTRAINT  Fix_ActMst_UK      Unique      (Period_Id,Num),
  CONSTRAINT  Fix_ActMst_WPer_FK Foreign Key (Period_Id) References Cpy_Period(Id),
  CONSTRAINT  Fix_ActMst_Ins_FK  Foreign Key (Ins_User ) References Cpy_User  (Id),
  CONSTRAINT  Fix_ActMst_Upd_FK  Foreign Key (Upd_User ) References Cpy_User  (Id)
)
/
Create Synonym Fix_ActMst For Fix_Actual_Master
/
Create Sequence Fix_ActTrn_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Actual_Trans				        -- بنود حركات الجرد
( Id         Number(20),					          -- مفتاح رئيسي
  FMst_Id    Number(10),					          -- مفتاح الأب
  Ord        Number(5),						          -- مسلسل
  Fixd_Id    Number(9),					            -- المادة
  FTrn_Id    Number(9),					            -- مفتاح بند حركة الإدخال
  Qnt        Number(25,3) Default 1,				-- الكمية
  Rem        Varchar2(100 Char),					  -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Fix_ActTrn_PK        PRIMARY KEY (Id),
  CONSTRAINT Fix_ActTrn_FMst_FK   Foreign Key (FMst_Id ) References Fix_ActMst(Id),
  CONSTRAINT Fix_ActTrn_FInTrn_FK Foreign Key (FTrn_Id ) References Fix_InTrn (Id),
  CONSTRAINT Fix_ActTrn_Fixd_FK   Foreign Key (Fixd_Id ) References Fix_Fixed (Id),
  CONSTRAINT Fix_ActTrn_Ins_FK    Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT Fix_ActTrn_Upd_FK    Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Fix_ActTrn For Fix_Actual_Trans
/

Create Sequence Fix_Cmt_Seq MinValue 1 Start With 1 MaxValue 9999999999 Increment by 1 Cache 2
/
Create Table Fix_Total_Commit					        -- جدول حالات تثبيت الاهتلااكات
( Id          Number(10),					            -- مفتاح رئيسي
  Year        Number(4),				              -- السنة
  Month       Number(2),				              -- الشهر
  Status_Id   Number(5) Default 0,				    -- الحالة
  Rel_Id      Number(20),					            -- مفتاح الوثيقة المثبتة
  Rem         Varchar2(100 Char),					    -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Fix_Cmt_PK      PRIMARY KEY (Id),
  CONSTRAINT  Fix_Cmt_UK      Unique      (Year,Month),
  CONSTRAINT  Fix_Cmt_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT  Fix_Cmt_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Fix_Cmt For Fix_Total_Commit
/
Create Sequence Fix_Tot_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Fix_Total_Fixed					      -- جدول تجميعات الإهتلاك للسنوات المالية
( Id         Number(20),					          -- مفتاح رئيسي
  FYear      Number(4),				              -- السنة
  FMonth     Number(2),				              -- الشهر
  FTrn_Id    Number(20),					          -- بند الادخال
  Fixd_Id    Number(9),					            -- المادة
  Vhr_Id     Number(10),						        -- مفتاح الوثيقة المالية
  Curn_Id    Number(5),         				    -- العملة
  Curn_Rate  Number(25,9) Default 1,        -- سعر الصرف
  Qnt        Number(25,3) Default 0,				-- الكمية
  CQnt       Number(25,3) Default 0,				-- الكمية الحالية
  Price      Number(25,3) Default 0,				-- سعر الوحدة
  Amt        Number(25,3) Default 0,				-- المبلغ
  CAmt       Number(25,3) Default 0,				-- المبلغ قطع
  Perc       Number(6,2) Default 1,				  -- نسبة الإهتلاك
  FTot       Number(25,3) Default 0,				-- مجمع سابق
  FAmt       Number(25,3) Default 0,				-- اهتلاك حالي
  RTot       Number(25,3) Default 0,				-- احتياطي سابق
  RAmt       Number(25,3) Default 0,				-- احتياطي حالي
  Ins_User   Number(20), Ins_Date   Date,
  Upd_User   Number(20), Upd_Date   Date,
  CONSTRAINT Fix_Tot_PK        PRIMARY KEY (Id ),
  CONSTRAINT Fix_Tot_UK        Unique      (FYear,FMonth,FTrn_Id),
  CONSTRAINT Fix_Tot_ITrn_FK   Foreign Key (FTrn_Id ) References Fix_InTrn(Id),
  CONSTRAINT Fix_Tot_Fixd_FK   Foreign Key (Fixd_Id ) References Fix_Fixed(Id),
  CONSTRAINT Fix_Tot_AccMst_FK Foreign Key (Vhr_Id  ) References Acc_Mst  (Id),
  CONSTRAINT Fix_Tot_Curn_FK   Foreign Key (Curn_Id ) References Mng_Curn (Id),
  CONSTRAINT Fix_Tot_Ins_FK    Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Fix_Tot_Upd_FK    Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Fix_Tot For Fix_Total_Fixed
/
Create INDEX Fix_Tot_Year_IDX  ON Fix_Total_Fixed(FYear)
/
Create INDEX Fix_Tot_Month_IDX ON Fix_Total_Fixed(FMonth)
/
Create INDEX Fix_Tot_Fixd_IDX  ON Fix_Total_Fixed(Fixd_Id)
/
Create INDEX Fix_Tot_FTrn_IDX  ON Fix_Total_Fixed(FTrn_Id)
/

Create Sequence Fix_Temp_Seq MinValue 1 Start With 1 MaxValue 9999999999 Increment by 1 Cache 2
/
Create Table Fix_Temp_Total_Fixed				    -- جدول تجميعات الإهتلاك
( Id         Number(20),					          -- مفتاح رئيسي
  FTrn_IId   Number(20),					          -- بند الادخال
  FTrn_OId   Number(20),					          -- بند الافتتاحي
  dDate      Date,						              -- التاريخ
  Cost_Id    Number(9),					            -- مركز الكلفة
  Acc_Id     Number(9),					            -- الحساب
  Fixd_Id    Number(9),					            -- المادة
  Qnt        Number(25,3) Default 0,				-- الكمية
  CQnt       Number(25,3) Default 0,				-- الكمية الحالية
  Price      Number(25,3) Default 0,				-- سعر الوحدة
  Amt        Number(25,3) Default 0,				-- المبلغ
  Perc       Number(6,2) Default 1,				  -- نسبة الإهتلاك
  FTot       Number(25,3) Default 0,				-- مجمع سابق
  FAmt       Number(25,3) Default 0,				-- اهتلاك حالي
  RTot       Number(25,3) Default 0,				-- احتياطي سابق
  RAmt       Number(25,3) Default 0,				-- احتياطي حالي
  nDummy     Number(1) Default 0
)
/
Create Synonym Fix_Temp	For Fix_Temp_Total_Fixed
/
