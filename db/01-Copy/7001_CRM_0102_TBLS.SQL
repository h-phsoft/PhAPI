Create Sequence CRM_Repr_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table CRM_Representatives                 -- دليل مندوبي المبيعات
( Id         Number(5),                          -- مفتاح رئيسي
  Name       Varchar2(100 Char),                 -- الاسم
  User_Id    Number(5),                          -- المستخدم المرتبط
  Status_Id  Number(5) Default 1,                -- الحالة
  Acc_Id     Number(20),                         -- الحساب
  Acc_CId    Number(20),                         -- حساب العمولة
  Comm       Number(7,2) Default 0,              -- نسبة العمولة
  Target     Number(25,3) Default 0,             -- الهدف  الحد الأدنى الذي يجب أن يحققه من الربح الإجمالي من ملفات العمل
  Rem        Varchar2(250 Char),                 -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT CRM_Repr_PK        Primary Key (Id  ),
  CONSTRAINT CRM_Repr_Nam_UK    Unique      (Name),
  CONSTRAINT CRM_Repr_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT CRM_Repr_CAcc_FK   Foreign Key (Acc_CId  ) References Acc_Acc       (Id),
  CONSTRAINT CRM_Repr_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT CRM_Repr_User_FK   Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT CRM_Repr_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT CRM_Repr_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym CRM_Repr For CRM_Representatives
/
Insert Into CRM_Repr(Id, Name) Values(0, '-');
----------------------------------------------------------------------------------------------------
Create Sequence CRM_Cont_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table CRM_Contact                                   -- دليل المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي
  Cont_Id    Number(9),                                    -- مفتاح المتعامل
  Vend_Id    Number(9),                                    -- مفتاح المورد
  Num        Varchar2(15 Char),                            -- الرقم
  Title      Varchar2(50 Char),                            -- Title
  LName      VarChar2(200 Char) NOT NULL,                  -- الاسم محلي
  IName      VarChar2(200 Char),                           -- الاسم الدولي
  Legal_Name VarChar2(200 Char),                           -- الاسم القانوني
  Owner      VarChar2(200 Char),                           -- اسم المالك
  Contact    VarChar2(200 Char),                           -- اسم شخص الاتصال
  Status_Id  Number(5) Default 1,                          -- الحالة
  Repr_Id    Number(9) Default 0,                          -- مندوب المبيعات
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
  CONSTRAINT CRM_Cont_PK         PRIMARY KEY (Id ),
  CONSTRAINT CRM_Cont_Num_UK     Unique      (Num),
  CONSTRAINT CRM_Cont_Name_UK    Unique      (LName    ),
  CONSTRAINT CRM_Cont_Cont_UK    Unique      (Cont_Id  ),
  CONSTRAINT CRM_Cont_Vend_UK    Unique      (Vend_Id  ),
  CONSTRAINT CRM_Cont_Phone_UK   Unique      (Phone    ),
  CONSTRAINT CRM_Cont_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT CRM_Cont_Repr_FK    Foreign Key (Repr_Id  ) References CRM_Repr      (Id),
  CONSTRAINT CRM_Cont_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT CRM_Cont_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym CRM_Cont For CRM_Contact
/
INSERT INTO CRM_Cont (Id, Num, LName) VALUES (0, '-', '-');
----------------------------------------------------------------------------------------------------
Create Sequence CRM_Cont_Class_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table CRM_Contact_Classification                    -- تصنيف المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي    
  Cont_Id    Number(9) NOT NULL,                           -- المتعامل
  Grp_Id     Number(5) NOT NULL,                           -- المجموعة
  Itm_Id     Number(7) NOT NULL,                           -- البند
  Rem        VarChar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT CRM_Cont_Class_PK       PRIMARY KEY (Id),
  CONSTRAINT CRM_Cont_Class_UK       Unique      (Cont_Id, Grp_Id, Itm_Id),
  CONSTRAINT CRM_Cont_Class_Cont_FK  Foreign Key (Cont_Id ) References CRM_Cont   (Id),
  CONSTRAINT CRM_Cont_Class_Group_FK Foreign Key (Grp_Id  ) References CRM_Cod_Grp(Id),
  CONSTRAINT CRM_Cont_Class_Item_FK  Foreign Key (Itm_Id  ) References CRM_Cod_Itm(Id),
  CONSTRAINT CRM_Cont_Class_Ins_FK   Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT CRM_Cont_Class_Upd_FK   Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym CRM_Cont_Class For CRM_Contact_Classification
/
----------------------------------------------------------------------------------------------------
Create Sequence CRM_Cont_Cont_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table CRM_Contact_Contact                           -- جهات اتصال المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي    
  Cont_Id    Number(9) NOT NULL,                           -- المتعامل
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
  CONSTRAINT CRM_Cont_Cont_PK        PRIMARY KEY (Id),
  CONSTRAINT CRM_Cont_Cont_Name_UK   Unique      (Cont_Id, LName),
  CONSTRAINT CRM_Cont_Cont_Cont_FK   Foreign Key (Cont_Id  ) References CRM_Cont      (Id),
  CONSTRAINT CRM_Cont_Cont_Gender_FK Foreign Key (Gender_Id) References Phs_Cod_Gender(Id),
  CONSTRAINT CRM_Cont_Cont_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT CRM_Cont_Cont_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym CRM_Cont_Cont For CRM_Contact_Contact
/
----------------------------------------------------------------------------------------------------
Create Sequence CRM_Cont_Bran_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table CRM_Contact_Branche                           -- فروع المتعاملين
( Id         Number(9),                                    -- مفتاح رئيسي
  Cont_Id    Number(9) NOT NULL,                           -- المتعامل
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
  CONSTRAINT CRM_Cont_Bran_PK      PRIMARY KEY (Id),
  CONSTRAINT CRM_Cont_Bran_Name_UK Unique      (Cont_Id, LName),
  CONSTRAINT CRM_Cont_Bran_Cont_FK Foreign Key (Cont_Id ) References CRM_Cont(Id),
  CONSTRAINT CRM_Cont_Bran_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT CRM_Cont_Bran_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym CRM_Cont_Bran For CRM_Contact_Branche
/
----------------------------------------------------------------------------------------------------
Create Sequence CRM_MRep_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table CRM_Report_Master                   -- تقارير مندوبي المبيعات
( Id           Number(9),                        -- مفتاح رئيسي
  Repr_Id      Number(9) Default 0,              -- المندوب
  Cont_Id      Number(9) Default 0,              -- المتعامل\الزبون
  dDate        Date NOT NULL,                    -- تاريخ
  Type_Id      Number(2) Default 0,              -- نوع التقرير
  Status_Id    Number(5) Default 0,              -- الحالة
  Kind_Id      Number(2) Default 1,              -- النوع 1 تقرير \ 2 فرصة
  Owner_Id     Number(5),                        -- منظم التقرير
  Chance       Number(3) Default 0,              -- نسبة فرصة إتمام الفرصة
  Person       Varchar2(250 Char),               -- اسم شخص الإتصال
  Comp         Varchar2(250 Char),               -- المنافس Competitor
  FDate        Date,                             -- تاريخ المتابعة
  FRem         Varchar2(250 Char),               -- ملاحظات المتابعة
  Report       Varchar2(4000 Char),              -- Event Attended / Campaign
  Descr        Varchar2(4000 Char),              -- Service and Business Details
  Rem          Varchar2(1000 Char),              -- ملاحظات
  Ins_User     Number(5), Ins_Date Date,
  Upd_User     Number(5), Upd_Date Date,
  CONSTRAINT   CRM_MRep_PK           Primary Key (Id),
  CONSTRAINT   CRM_MRep_Repr_FK      Foreign Key (Repr_Id      ) References CRM_Repr         (Id),
  CONSTRAINT   CRM_MRep_Cont_FK      Foreign Key (Cont_Id      ) References CRM_Cont         (Id),
  CONSTRAINT   CRM_MRep_Type_FK      Foreign Key (Type_Id      ) References CRM_Cod_Type     (Id),
  CONSTRAINT   CRM_MRep_Status_FK    Foreign Key (Status_Id    ) References CRM_Cod_Status   (Id),
  CONSTRAINT   CRM_MRep_Kind_FK      Foreign Key (Kind_Id      ) References CRM_Cod_Kind     (Id),
  CONSTRAINT   CRM_MRep_Owner_FK     Foreign Key (Owner_Id     ) References Cpy_User         (Id),
  CONSTRAINT   CRM_MRep_Ins_FK       Foreign Key (Ins_User     ) References Cpy_User         (Id),
  CONSTRAINT   CRM_MRep_Upd_FK       Foreign Key (Upd_User     ) References Cpy_User         (Id)
)
/
Create Synonym CRM_MRep For CRM_Report_Master
/
----------------------------------------------------------------------------------------------------
Create Sequence CRM_TRep_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table CRM_Report_Transaction              -- تقارير مندوبي المبيعات
( Id          Number(9),                         -- مفتاح رئيسي
  Rep_Id      Number(9) NOT NULL,                -- مفتاح الأب
  Offer       Number(10),                        -- Offer Number
  Phase_Id    Number(5) Default 0,               -- Report Phase
  ITerm_Id    Number(5) Default 0,               -- Incoterm
  OCntry_Id   Number(5) Default 0,               -- المصدر بلد
  OCity_Id    Number(5) Default 0,               -- المصدر مدينة
  OPort_Id    Number(5) Default 0,               -- المصدر مرفأ
  OAirport_Id Number(5) Default 0,               -- المصدر مطار
  DCntry_Id   Number(5) Default 0,               -- المقصد بلد
  DCity_Id    Number(5) Default 0,               -- المقصد مدينة
  DPort_Id    Number(5) Default 0,               -- المقصد مرفأ
  DAirport_Id Number(5) Default 0,               -- المقصد مطار
  nLength     Number(25,3) Default 0,            -- الطول
  nWidth      Number(25,3) Default 0,            -- العرض
  nHeight     Number(25,3) Default 0,            -- الارتفاع
  nWeight     Number(25,3) Default 0,            -- الوزن المحاسب عليه
  Curn_Id     Number(20) Default 1,              -- العملة
  TRep_Qnt    Number(25,3) Default 0,            -- الكمية
  TRep_CAmt   Number(25,3) Default 0,            -- الربح الصافي المتوقع
  TRep_nComd  Number(20) Default 0,              -- البضاعة
  Compet      Varchar2(250 Char),                -- المنافس Competitor
  Comdodity   Varchar2(250 Char),                -- نوع البضاعة
  Report      Varchar2(250 Char),                -- Event Attended / Campaign
  TRep_Rem    Varchar2(250 Char),                -- ملاحظات
  Ins_User    Number(5),  Ins_Date    Date,
  Upd_User    Number(5),  Upd_Date    Date,
  CONSTRAINT  CRM_TRep_PK       Primary Key (Id),
  CONSTRAINT  CRM_TRep_Rep_FK   Foreign Key (Rep_Id  ) References CRM_MRep(Id),
  CONSTRAINT  CRM_TRep_Ins_FK   Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT  CRM_TRep_Upd_FK   Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym CRM_TRep For CRM_Report_Transaction
/
