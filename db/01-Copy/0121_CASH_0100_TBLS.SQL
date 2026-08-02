--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'CASH%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'CASH%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'CASH%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'CASH%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'CASH%' ;
----------------------------------------------------------------------------------------------------
Create Table Cash_Code_Status                         -- جدول ترميز حالة الأمر
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cash_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cash_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Cash_Cod_Status_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cash_Cod_Status_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cash_Cod_Status_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cash_Cod_Status For Cash_Code_Status
/
INSERT INTO Cash_Cod_Status (Id, Name) VALUES (0 , '-');
INSERT INTO Cash_Cod_Status (Id, Name) VALUES (10, 'Approved' );
INSERT INTO Cash_Cod_Status (Id, Name) VALUES (11, 'Executed' );
INSERT INTO Cash_Cod_Status (Id, Name) VALUES (12, 'Certified');
INSERT INTO Cash_Cod_Status (Id, Name) VALUES (13, 'Canceled' );

---------------------------------------------------------------------------------------------------
Create Table Cash_Code_Method                           -- جدول ترميز الطريقة
  ( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
    Status_Id  Number(1) Default 1,                     -- حالة الترميز
    Name       Varchar2(100 Char) NOT NULL,             -- الاسم
    Rem        Varchar2(100 Char),                      -- ملاحظات
    Ins_User   Number(5), Ins_Date     Date,
    Upd_User   Number(5), Upd_Date     Date,
    CONSTRAINT Cash_Cod_Method_PK     PRIMARY KEY (Id  ),
    CONSTRAINT Cash_Cod_Method_UK     UNIQUE      (Name),
    CONSTRAINT Cash_Cod_Method_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
    CONSTRAINT Cash_Cod_Method_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
    CONSTRAINT Cash_Cod_Method_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
  )
/
Create Synonym Cash_Cod_Method For Cash_Code_Method
/
INSERT INTO Cash_Cod_Method (Id, Name) VALUES (0  , '-');

---------------------------------------------------------------------------------------------------
Create Table Cash_Code_Trt                            -- جدول ترميز أنواع الحركات
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cash_Cod_Trt_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cash_Cod_Trt_UK     UNIQUE      (Name),
  CONSTRAINT Cash_Cod_Trt_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cash_Cod_Trt_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cash_Cod_Trt_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cash_Cod_Trt For Cash_Code_Trt
/
INSERT INTO Cash_Cod_Trt (Id, Name, Rem) VALUES (0 , '-'  , '-');
INSERT INTO Cash_Cod_Trt (Id, Name, Rem) VALUES (11, 'CO' , 'Collection');
INSERT INTO Cash_Cod_Trt (Id, Name, Rem) VALUES (12, 'TI' , 'Transfer IN');
INSERT INTO Cash_Cod_Trt (Id, Name, Rem) VALUES (13, 'EI' , 'Exchange IN');
INSERT INTO Cash_Cod_Trt (Id, Name, Rem) VALUES (20, 'APV', 'Addvanced Payment');
INSERT INTO Cash_Cod_Trt (Id, Name, Rem) VALUES (21, 'PO' , 'Payment');
INSERT INTO Cash_Cod_Trt (Id, Name, Rem) VALUES (22, 'TO' , 'Transfer OUT');
INSERT INTO Cash_Cod_Trt (Id, Name, Rem) VALUES (23, 'EO' , 'Exchange OUT');
---------------------------------------------------------------------------------------------------
Create Table Cash_Code_City                           -- جدول ترميز المدن
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cash_Cod_City_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cash_Cod_City_UK     UNIQUE      (Name),
  CONSTRAINT Cash_Cod_City_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cash_Cod_City_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cash_Cod_City_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cash_Cod_City For Cash_Code_City
/
INSERT INTO Cash_Cod_City (Id, Name, Rem) VALUES (0,'-','-');
---------------------------------------------------------------------------------------------------
Create Table Cash_Code_PhnBy                          -- جدول ترميز شركات التحويل
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Cash_Cod_PhnBy_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Cash_Cod_PhnBy_UK     UNIQUE      (Name),
  CONSTRAINT Cash_Cod_PhnBy_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Cash_Cod_PhnBy_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Cash_Cod_PhnBy_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Cash_Cod_PhnBy For Cash_Code_PhnBy
/
INSERT INTO Cash_Cod_PhnBy (Id, Name, Rem) VALUES (0,'-','-');
---------------------------------------------------------------------------------------------------
Create Sequence Cash_Cash_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Cash_Cashiers                            -- دليل أمناء الصناديق
( Id         Number(5),                               -- مفتاح رئيسي
  Num        Number(5) NOT NULL,                      -- الرقم
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Cost_Id    Number(8),                               -- مركز الكلفة
  Acc_Id     Number(8),                               -- الحساب
  User_Id    Number(5),                              -- المستخدم المرتبط بالنظام
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Cash_Cash_PK      Primary Key (Id  ),
  CONSTRAINT Cash_Cash_Num_UK  Unique      (Num ),
  CONSTRAINT Cash_Cash_Name_UK Unique      (Name),
  CONSTRAINT Cash_Cash_Cost_FK Foreign Key (Cost_Id ) References Acc_Cost(Id),
  CONSTRAINT Cash_Cash_Acc_FK  Foreign Key (Acc_Id  ) References Acc_Acc (Id),
  CONSTRAINT Cash_Cash_User_FK Foreign Key (User_Id ) References Cpy_User(Id),
  CONSTRAINT Cash_Cash_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Cash_Cash_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Cash_Cash For Cash_Cashiers
/
INSERT INTO Cash_Cash(ID,NUM,NAME,USER_ID) VALUES(0,0,'-',0);
---------------------------------------------------------------------------------------------------
Create Sequence Cash_Box_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Cash_Boxes                               -- دليل الصناديق
( Id          Number(5),                              -- مفتاح رئيسي
  Num         Number(10) NOT NULL,                    -- الرقم
  Name        Varchar2(100 Char) NOT NULL,            -- الاسم
  Status_Id   Number(10) Default 1,                   -- حالة الإستخدام \ 1 فعالة \ 0 غير مستخدمة
  Cash_Id     Number(5) NOT NULL,                     -- أمين الصندوق
--User_Id     Number(5),                              -- المستخدم المرتبط بالنظام
  Cost_Id     Number(9),                              -- مركز الكلفة
  Acc_CId     Number(9),                              -- حساب الفرق
  Acc_OId     Number(9),                              -- الحساب العملة
  Curn_Id     Number(3) Default 1,                    -- العملة
  Rem         Varchar2(100 Char),                     -- ملاحظات
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date, 
  CONSTRAINT  Cash_Box_PK        Primary Key (Id  ),
  CONSTRAINT  Cash_Box_Num_UK    Unique      (Num ),
  CONSTRAINT  Cash_Box_Name_UK   Unique      (Name),
  CONSTRAINT  Cash_Box_Cash_FK   Foreign Key (Cash_Id  ) References Cash_Cash      (Id),
--CONSTRAINT  Cash_Box_User_FK   Foreign Key (User_Id  ) References Cpy_User       (Id),
  CONSTRAINT  Cash_Box_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT  Cash_Box_Cost_FK   Foreign Key (Cost_Id  ) References Acc_Cost       (Id),
  CONSTRAINT  Cash_Box_AccC_FK   Foreign Key (Acc_CId  ) References Acc_Acc        (Id),
  CONSTRAINT  Cash_Box_AccO_FK   Foreign Key (Acc_OId  ) References Acc_Acc        (Id),
  CONSTRAINT  Cahs_Box_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn       (Id),
  CONSTRAINT  Cash_Box_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT  Cash_Box_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Cash_Box For Cash_Boxes
/
---------------------------------------------------------------------------------------------------
Create Sequence Cash_COrd_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_Collection_Order                    -- أوامر القبض
( Id             Number(9),                           -- مفتاح رئيسي
  Trt_Id         Number(5) Default 11,                -- نوع الحركة
  Dept_Id        Number(5) Default 0,                 -- الدائرة
  Unit_Id        Number(5) Default 0,                 -- القسم
  Oper_Id        Number(5) Default 0,                 -- العملية
  Period_Id      Number(4) Default 0,                 -- السنة
  Cont_Id        Number(9) Default 0,                 -- المتعامل
  Serv_Id        Number(5) Default 0,                 -- الخدمة
  Method_Id      Number(5) Default 0,                 -- الطريقة
  CBox_Id        Number(5) Default 0,                 -- الصندوق
  Cash_Id        Number(5) Default 0,                 -- أمين الصندوق
  User_Id        Number(5),                           -- المنظم
  Vhr_Id         Number(9),                           -- مفتاح سند القيد
  Vhr_DId        Number(9),                           -- مفتاح سند قيد التوزيع
  InsDate        Date Default Sysdate,                -- تاريخ التنظيم
  Num            Number(10),                          -- الرقم
  dDate          Date,                                -- التاريخ
  RNum           Number(10),                          -- رقم الإيصال
  RDate          Date,                                -- تاريخ الإيصال
  EDate          Date,                                -- تاريخ التنفيذ المطلوب
  ExecDate       Date,                                -- تاريخ التنفيذ
  Curn_Id        Number(3) Default 1,                 -- العملة
  Curn_Rate      Number(25,9) Default 1,              -- سعر الصرف
  CAmt           Number(25,2) Default 0,              -- المبلغ عملة
  Amt            Number(25,2) Default 0,              -- المبلغ محلي
  ExCAmt         Number(25,2) Default 0,              -- المبلغ المنفذ عملة
  ExAmt          Number(25,2) Default 0,              -- المبلغ المنفذ محلي
  Status_Id      Number(5) Default 0,                 -- الحالة
  Status_Date    Date,                                -- التاريخ
  Status_Descr   Varchar2(100 Char),                  -- الشرح
  DStatus_Id     Number(5) Default 2,                 -- حالة التوزيع
  DCAmt          Number(25,2) Default 0,              -- فرق التوزيع عملة
  DAmt           Number(25,2) Default 0,              -- فرق التوزيع
  Bank_Id        Number(5),                           -- البنك
  City_Id        Number(5) Default 0,                 -- المدينة
  PhnBy_Id       Number(5) Default 0,                 -- شركة التحويل
  Correspondent  Varchar2(100 Char),                  -- المراسل correspondent
  Recipient      Varchar2(200 Char),                  -- المستلم
  Note           Varchar2(250 Char),                  --  ملاحظات التحويل
  DCust          Varchar2(250 Char),                  -- اسم الزبون الذي سيظهر على الإيصال
  Reason         Varchar2(250 Char),                  -- السبب
  Rem            Varchar2(250 Char),                  -- ملاحظات
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT     Cash_COrd_PK         Primary Key (Id),
  CONSTRAINT     Cash_COrd_Num_UK     Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT     Cash_COrd_Trt_FK     Foreign Key (Trt_Id    ) References Cash_Cod_Trt    (Id),
  CONSTRAINT     Cash_COrd_Dept_FK    Foreign Key (Dept_Id   ) References Cpy_Dept        (Id),
  CONSTRAINT     Cash_COrd_Unit_FK    Foreign Key (Unit_Id   ) References Cpy_Unit        (Id),
  CONSTRAINT     Cash_COrd_Oper_FK    Foreign Key (Oper_Id   ) References Cpy_Oper        (Id),
  CONSTRAINT     Cash_COrd_Period_FK  Foreign Key (Period_Id ) References Cpy_Period      (Id),
  CONSTRAINT     Cash_COrd_Status_FK  Foreign Key (Status_Id ) References Cash_Cod_Status (Id),
  CONSTRAINT     Cash_COrd_DStatus_FK Foreign Key (DStatus_Id) References Phs_Cod_YesNo   (Id),
  CONSTRAINT     Cash_COrd_Box_FK     Foreign Key (CBox_Id   ) References Cash_Box        (Id),
  CONSTRAINT     Cash_COrd_Cash_FK    Foreign Key (Cash_Id   ) References Cash_Cash       (Id),
  CONSTRAINT     Cash_COrd_Method_FK  Foreign Key (Method_Id ) References Cash_Cod_Method (Id),
  CONSTRAINT     Cash_COrd_City_FK    Foreign Key (City_Id   ) References Cash_Cod_City   (Id),
  CONSTRAINT     Cash_COrd_PhnBy_FK   Foreign Key (PhnBy_Id  ) References Cash_Cod_PhnBy  (Id),
  CONSTRAINT     Cash_COrd_Cont_FK    Foreign Key (Cont_Id   ) References Mng_Cont        (Id),
  CONSTRAINT     Cash_COrd_Serv_FK    Foreign Key (Serv_Id   ) References Mng_Serv        (Id),
  CONSTRAINT     Cash_COrd_Curn_FK    Foreign Key (Curn_Id   ) References Mng_Curn        (Id),
  CONSTRAINT     Cash_COrd_Vhr_FK     Foreign Key (Vhr_Id    ) References Acc_Mst         (Id),
  CONSTRAINT     Cash_COrd_VhrD_FK    Foreign Key (Vhr_DId   ) References Acc_Mst         (Id),
  CONSTRAINT     Cash_COrd_User_FK    Foreign Key (User_Id   ) References Cpy_User        (Id),
  CONSTRAINT     Cash_COrd_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User        (Id),
  CONSTRAINT     Cash_COrd_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User        (Id)
)
/
Create Synonym Cash_COrd For Cash_Collection_Order
/
--Alter Table Cash_Collection_Order Add CONSTRAINT Cash_COrd_Bank_FK Foreign Key (Bank_Id) References Bank_Acc(Id);

Create Sequence Cash_COrdStatus_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_COrder_Status                       -- جدول تبدل حالات الأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Status_Id  Number(5) Default 0,                     -- الحالة
  dDate      Date,                                    -- التاريخ
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Cash_COrdStatus_PK        Primary Key (Id),
  CONSTRAINT Cash_COrdStatus_FK        Foreign Key (Ord_Id   ) References Cash_COrd      (Id),
  CONSTRAINT Cash_COrdStatus_Status_FK Foreign Key (Status_Id) References Cash_Cod_Status(Id),
  CONSTRAINT Cash_COrdStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Cash_COrdStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Cash_COrdStatus For Cash_COrder_Status
/
Create Sequence Cash_COrdFin_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_COrder_FinDocs                      -- وثائق المالية المرتبطة بالأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Dept_RId   Number(5) Default 0,                     -- الدائرة
  Unit_RId   Number(5) Default 0,                     -- القسم
  Oper_RId   Number(5) Default 0,                     -- العملية
  MDoc_Id    Number(10),                              -- مفتاح الوثيقة
  nOrd       Number(5),                               -- مسلسل الإظهار
  DBCR       Number(5) Default 1,                     -- نوع الوثيقة المالية 1 مدين \ 2 دائن
  Curn_Id    Number(20) Default 1,                    -- العملة
  Curn_Rate  Number(25,9) Default 1,                  -- سعر الصرف
  CAmt       Number(25,3) Default 0,                  -- المبلغ عملة
  Amt        Number(25,2) Default 0,                  -- المبلغ محلي
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Cash_COrdFin_PK      Primary Key (Id),
  CONSTRAINT Cash_COrdFin_FK      Foreign Key (Ord_Id  ) References Cash_COrd(Id),
  CONSTRAINT Cash_COrdFin_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn (Id),
  CONSTRAINT Cash_COrdFin_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Cash_COrdFin_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Cash_COrdFin For Cash_COrder_FinDocs
/
Create Sequence Cash_COrdAPV_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_COrder_APVs                         -- أوام الدفع المسبق - السلف المرتبطة بالأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  APOrd_RId  Number(9),                               -- مفتاح السلفة
  nOrd       Number(5),                               -- مسلسل الإظهار
  Curn_Id    Number(3) Default 1,                     -- العملة
  Curn_Rate  Number(25,9) Default 1,                  -- سعر الصرف
  CAmt       Number(25,3) Default 0,                  -- المبلغ عملة
  Amt        Number(25,2) Default 0,                  -- المبلغ محلي
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(5),  Ins_Date  Date,
  Upd_User   Number(5),  Upd_Date  Date,
  CONSTRAINT Cash_COrdAPV_PK      Primary Key (Id ),
  CONSTRAINT Cash_COrdAPV_FK      Foreign Key (Ord_Id  ) References Cash_COrd(Id),
  CONSTRAINT Cash_COrdAPV_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn (Id),
  CONSTRAINT Cash_COrdAPV_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Cash_COrdAPV_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Cash_COrdAPV For Cash_COrder_APVs
/
---------------------------------------------------------------------------------------------------
Create Sequence Cash_APOrd_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Cash_Advanced_Payment_Order              -- أوامر السلف
( Id             Number(9),                           -- مفتاح رئيسي
  Trt_Id         Number(5) Default 20,                -- نوع الحركة
  Dept_Id        Number(5) Default 0,                 -- الدائرة
  Unit_Id        Number(5) Default 0,                 -- القسم
  Oper_Id        Number(5) Default 0,                 -- العملية
  Period_Id      Number(4) Default 0,                 -- السنة
  Cont_Id        Number(9) Default 0,                 -- المتعامل
  Serv_Id        Number(5) Default 0,                 -- الخدمة
  Method_Id      Number(5) Default 0,                 -- الطريقة
  CBox_Id        Number(5) Default 0,                 -- الصندوق
  Cash_Id        Number(5) Default 0,                 -- أمين الصندوق
  User_Id        Number(5),                           -- المنظم
  Vhr_Id         Number(9),                           -- مفتاح سند القيد
  Vhr_DId        Number(9),                           -- مفتاح سند قيد التوزيع
  InsDate        Date Default Sysdate,                -- تاريخ التنظيم
  Num            Number(10),                          -- الرقم
  dDate          Date,                                -- التاريخ
  RNum           Number(10),                          -- رقم الإيصال
  RDate          Date,                                -- تاريخ الإيصال
  EDate          Date,                                -- تاريخ التنفيذ المطلوب
  ExecDate       Date,                                -- تاريخ التنفيذ
  Curn_Id        Number(3) Default 1,                 -- العملة
  Curn_Rate      Number(25,9) Default 1,              -- سعر الصرف
  CAmt           Number(25,2) Default 0,              -- المبلغ عملة
  Amt            Number(25,2) Default 0,              -- المبلغ محلي
  ExCAmt         Number(25,2) Default 0,              -- المبلغ المنفذ عملة
  ExAmt          Number(25,2) Default 0,              -- المبلغ المنفذ محلي
  Status_Id      Number(5) Default 0,                 -- الحالة
  Status_Date    Date,                                -- التاريخ
  Status_Descr   Varchar2(100 Char),                  -- الشرح
  DStatus_Id     Number(5) Default 2,                 -- حالة التوزيع
  DCAmt          Number(25,2) Default 0,              -- فرق التوزيع عملة
  DAmt           Number(25,2) Default 0,              -- فرق التوزيع
  Bank_Id        Number(5),                           -- البنك
  City_Id        Number(5) Default 0,                 -- المدينة
  PhnBy_Id       Number(5) Default 0,                 -- شركة التحويل
  Correspondent  Varchar2(100 Char),                  -- المراسل correspondent
  Recipient      Varchar2(200 Char),                  -- المستلم
  Note           Varchar2(250 Char),                  --  ملاحظات التحويل
  DCust          Varchar2(250 Char),                  -- اسم الزبون الذي سيظهر على الإيصال
  Reason         Varchar2(250 Char),                  -- السبب
  Rem            Varchar2(250 Char),                  -- ملاحظات
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT     Cash_APOrd_PK         Primary Key (Id),
  CONSTRAINT     Cash_APOrd_Num_UK     Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT     Cash_APOrd_Trt_FK     Foreign Key (Trt_Id    ) References Cash_Cod_Trt   (Id),
  CONSTRAINT     Cash_APOrd_Dept_FK    Foreign Key (Dept_Id   ) References Cpy_Dept       (Id),
  CONSTRAINT     Cash_APOrd_Unit_FK    Foreign Key (Unit_Id   ) References Cpy_Unit       (Id),
  CONSTRAINT     Cash_APOrd_Oper_FK    Foreign Key (Oper_Id   ) References Cpy_Oper       (Id),
  CONSTRAINT     Cash_APOrd_Period_FK  Foreign Key (Period_Id ) References Cpy_Period     (Id),
  CONSTRAINT     Cash_APOrd_Status_FK  Foreign Key (Status_Id ) References Cash_Cod_Status(Id),
  CONSTRAINT     Cash_APOrd_DStatus_FK Foreign Key (DStatus_Id) References Phs_Cod_YesNo  (Id),
  CONSTRAINT     Cash_APOrd_Box_FK     Foreign Key (CBox_Id   ) References Cash_Box       (Id),
  CONSTRAINT     Cash_APOrd_Cash_FK    Foreign Key (Cash_Id   ) References Cash_Cash      (Id),
  CONSTRAINT     Cash_APOrd_Method_FK  Foreign Key (Method_Id ) References Cash_Cod_Method(Id),
  CONSTRAINT     Cash_APOrd_City_FK    Foreign Key (City_Id   ) References Cash_Cod_City  (Id),
  CONSTRAINT     Cash_APOrd_PhnBy_FK   Foreign Key (PhnBy_Id  ) References Cash_Cod_PhnBy (Id),
  CONSTRAINT     Cash_APOrd_Cont_FK    Foreign Key (Cont_Id   ) References Mng_Cont       (Id),
  CONSTRAINT     Cash_APOrd_Serv_FK    Foreign Key (Serv_Id   ) References Mng_Serv       (Id),
  CONSTRAINT     Cash_APOrd_Curn_FK    Foreign Key (Curn_Id   ) References Mng_Curn       (Id),
  CONSTRAINT     Cash_APOrd_Vhr_FK     Foreign Key (Vhr_Id    ) References Acc_Mst        (Id),
  CONSTRAINT     Cash_APOrd_VhrD_FK    Foreign Key (Vhr_DId   ) References Acc_Mst        (Id),
  CONSTRAINT     Cash_APOrd_User_FK    Foreign Key (User_Id   ) References Cpy_User       (Id),
  CONSTRAINT     Cash_APOrd_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT     Cash_APOrd_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Cash_APOrd For Cash_Advanced_Payment_Order
/
--Alter Table Cash_Advanced_Payment_Order Add CONSTRAINT Cash_APOrd_Bank_FK Foreign Key (Bank_Id) References Bank_Acc(Id);

Create Sequence Cash_APOrdStatus_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_APOrder_Status                      -- جدول تبدل حالات الأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Status_Id  Number(5) Default 0,                     -- الحالة
  dDate      Date,                                    -- التاريخ
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Cash_APOrdStatus_PK        Primary Key (Id),
  CONSTRAINT Cash_APOrdStatus_FK        Foreign Key (Ord_Id   ) References Cash_APOrd     (Id),
  CONSTRAINT Cash_APOrdStatus_Status_FK Foreign Key (Status_Id) References Cash_Cod_Status(Id),
  CONSTRAINT Cash_APOrdStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Cash_APOrdStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Cash_APOrdStatus For Cash_APOrder_Status
/
Create Table Cash_APOrder_Jobs                        -- ملفات العمل المرتبطة بالأمر
( Id          Number(20) NOT NULL,                    -- مفتاح رئيسي
  Ord_Id      Number(9) NOT NULL,                     -- مفتاح الأب
  Dept_RId    Number(5) Default 0,                    -- الدائرة
  Unit_RId    Number(5) Default 0,                    -- القسم
  Oper_RId    Number(5) Default 0,                    -- العملية
  Job_Id      Number(20),                             -- مفتاح ملف العمل
  nOrd        Number(3),                              -- مسلسل الإظهار
  Curn_Id     Number(20) Default 1,                   -- العملة
  Curn_Rate   Number(25,9) Default 1,                 -- سعر الصرف
  CAmt        Number(25,3) Default 0,                 -- المبلغ عملة
  Amt         Number(25,2) Default 0,                 -- المبلغ محلي
  Reason      Varchar2(250 Char),                     -- السبب
  Rem         Varchar2(250 Char),                     -- البيان
  Ins_User    Number(20),  Ins_Date  Date,
  Upd_User    Number(20),  Upd_Date  Date,
  CONSTRAINT  Cash_APJob_PK      Primary Key (Id),
  CONSTRAINT  Cash_APJob_FK      Foreign Key (Ord_Id  ) References Cash_APOrd(Id),
  CONSTRAINT  Cash_APJob_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn  (Id),
  CONSTRAINT  Cash_APJob_Ins_FK  Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT  Cash_APJob_Upd_FK  Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Cash_APJobs For Cash_APOrder_Jobs
/
---------------------------------------------------------------------------------------------------
Create Sequence Cash_POrd_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_Payment_Order                       -- أوامر الصرف\الدفع
( Id             Number(9),                           -- مفتاح رئيسي
  Trt_Id         Number(5) Default 21,                -- نوع الحركة
  Dept_Id        Number(5) Default 0,                 -- الدائرة
  Unit_Id        Number(5) Default 0,                 -- القسم
  Oper_Id        Number(5) Default 0,                 -- العملية
  Period_Id      Number(4) Default 0,                 -- السنة
  Cont_Id        Number(9) Default 0,                 -- المتعامل
  Serv_Id        Number(5) Default 0,                 -- الخدمة
  Method_Id      Number(5) Default 0,                 -- الطريقة
  CBox_Id        Number(5) Default 0,                 -- الصندوق
  Cash_Id        Number(5) Default 0,                 -- أمين الصندوق
  User_Id        Number(5),                           -- المنظم
  Vhr_Id         Number(9),                           -- مفتاح سند القيد
  Vhr_DId        Number(9),                           -- مفتاح سند قيد التوزيع
  InsDate        Date Default Sysdate,                -- تاريخ التنظيم
  Num            Number(10),                          -- الرقم
  dDate          Date,                                -- التاريخ
  RNum           Number(10),                          -- رقم الإيصال
  RDate          Date,                                -- تاريخ الإيصال
  EDate          Date,                                -- تاريخ التنفيذ المطلوب
  ExecDate       Date,                                -- تاريخ التنفيذ
  Curn_Id        Number(3) Default 1,                 -- العملة
  Curn_Rate      Number(25,9) Default 1,              -- سعر الصرف
  CAmt           Number(25,2) Default 0,              -- المبلغ عملة
  Amt            Number(25,2) Default 0,              -- المبلغ محلي
  ExCAmt         Number(25,2) Default 0,              -- المبلغ المنفذ عملة
  ExAmt          Number(25,2) Default 0,              -- المبلغ المنفذ محلي
  Status_Id      Number(5) Default 0,                 -- الحالة
  Status_Date    Date,                                -- التاريخ
  Status_Descr   Varchar2(100 Char),                  -- الشرح
  DStatus_Id     Number(5) Default 2,                 -- حالة التوزيع
  DCAmt          Number(25,2) Default 0,              -- فرق التوزيع عملة
  DAmt           Number(25,2) Default 0,              -- فرق التوزيع
  Bank_Id        Number(5),                           -- البنك
  City_Id        Number(5) Default 0,                 -- المدينة
  PhnBy_Id       Number(5) Default 0,                 -- شركة التحويل
  Correspondent  Varchar2(100 Char),                  -- المراسل correspondent
  Recipient      Varchar2(200 Char),                  -- المستلم
  Note           Varchar2(250 Char),                  --  ملاحظات التحويل
  DCust          Varchar2(250 Char),                  -- اسم الزبون الذي سيظهر على الإيصال
  Reason         Varchar2(250 Char),                  -- السبب
  Rem            Varchar2(250 Char),                  -- ملاحظات
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT     Cash_POrd_PK         Primary Key (Id),
  CONSTRAINT     Cash_POrd_Num_UK     Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT     Cash_POrd_Trt_FK     Foreign Key (Trt_Id    ) References Cash_Cod_Trt   (Id),
  CONSTRAINT     Cash_POrd_Dept_FK    Foreign Key (Dept_Id   ) References Cpy_Dept       (Id),
  CONSTRAINT     Cash_POrd_Unit_FK    Foreign Key (Unit_Id   ) References Cpy_Unit       (Id),
  CONSTRAINT     Cash_POrd_Oper_FK    Foreign Key (Oper_Id   ) References Cpy_Oper       (Id),
  CONSTRAINT     Cash_POrd_Period_FK  Foreign Key (Period_Id ) References Cpy_Period     (Id),
  CONSTRAINT     Cash_POrd_Status_FK  Foreign Key (Status_Id ) References Cash_Cod_Status(Id),
  CONSTRAINT     Cash_POrd_DStatus_FK Foreign Key (DStatus_Id) References Phs_Cod_YesNo  (Id),
  CONSTRAINT     Cash_POrd_Box_FK     Foreign Key (CBox_Id   ) References Cash_Box       (Id),
  CONSTRAINT     Cash_POrd_Cash_FK    Foreign Key (Cash_Id   ) References Cash_Cash      (Id),
  CONSTRAINT     Cash_POrd_Method_FK  Foreign Key (Method_Id ) References Cash_Cod_Method(Id),
  CONSTRAINT     Cash_POrd_City_FK    Foreign Key (City_Id   ) References Cash_Cod_City  (Id),
  CONSTRAINT     Cash_POrd_PhnBy_FK   Foreign Key (PhnBy_Id  ) References Cash_Cod_PhnBy (Id),
  CONSTRAINT     Cash_POrd_Cont_FK    Foreign Key (Cont_Id   ) References Mng_Cont       (Id),
  CONSTRAINT     Cash_POrd_Serv_FK    Foreign Key (Serv_Id   ) References Mng_Serv       (Id),
  CONSTRAINT     Cash_POrd_Curn_FK    Foreign Key (Curn_Id   ) References Mng_Curn       (Id),
  CONSTRAINT     Cash_POrd_Vhr_FK     Foreign Key (Vhr_Id    ) References Acc_Mst        (Id),
  CONSTRAINT     Cash_POrd_VhrD_FK    Foreign Key (Vhr_DId   ) References Acc_Mst        (Id),
  CONSTRAINT     Cash_POrd_User_FK    Foreign Key (User_Id   ) References Cpy_User       (Id),
  CONSTRAINT     Cash_POrd_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT     Cash_POrd_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Cash_POrd For Cash_Payment_Order
/
--Alter Table Cash_Payment_Order Add CONSTRAINT Cash_POrd_Bank_FK Foreign Key (Bank_Id) References Bank_Acc(Id);

Create Sequence Cash_POrdStatus_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_POrder_Status                       -- جدول تبدل حالات الأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Status_Id  Number(5) Default 0,                     -- الحالة
  dDate      Date,                                    -- التاريخ
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Cash_POrdStatus_PK        Primary Key (Id),
  CONSTRAINT Cash_POrdStatus_FK        Foreign Key (Ord_Id   ) References Cash_POrd      (Id),
  CONSTRAINT Cash_POrdStatus_Status_FK Foreign Key (Status_Id) References Cash_Cod_Status(Id),
  CONSTRAINT Cash_POrdStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Cash_POrdStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Cash_POrdStatus For Cash_POrder_Status
/
Create Sequence Cash_POrdFin_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_POrder_FinDocs                      -- وثائق المالية المرتبطة بالأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Dept_RId   Number(5) Default 0,                     -- الدائرة
  Unit_RId   Number(5) Default 0,                     -- القسم
  Oper_RId   Number(5) Default 0,                     -- العملية
  MDoc_Id    Number(10),                              -- مفتاح الوثيقة
  nOrd       Number(5),                               -- مسلسل الإظهار
  DBCR       Number(5) Default 1,                     -- نوع الوثيقة المالية 1 مدين \ 2 دائن
  Curn_Id    Number(20) Default 1,                    -- العملة
  Curn_Rate  Number(25,9) Default 1,                  -- سعر الصرف
  CAmt       Number(25,3) Default 0,                  -- المبلغ عملة
  Amt        Number(25,2) Default 0,                  -- المبلغ محلي
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Cash_POrdFin_PK      Primary Key (Id),
  CONSTRAINT Cash_POrdFin_FK      Foreign Key (Ord_Id  ) References Cash_POrd(Id),
  CONSTRAINT Cash_POrdFin_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn (Id),
  CONSTRAINT Cash_POrdFin_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Cash_POrdFin_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Cash_POrdFin For Cash_POrder_FinDocs
/
Create Sequence Cash_POrdAPV_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_POrder_APVs                         -- أوام الدفع المسبق - السلف المرتبطة بالأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  APOrd_RId  Number(9),                               -- مفتاح السلفة
  nOrd       Number(5),                               -- مسلسل الإظهار
  Curn_Id    Number(3) Default 1,                     -- العملة
  Curn_Rate  Number(25,9) Default 1,                  -- سعر الصرف
  CAmt       Number(25,3) Default 0,                  -- المبلغ عملة
  Amt        Number(25,2) Default 0,                  -- المبلغ محلي
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(5),  Ins_Date  Date,
  Upd_User   Number(5),  Upd_Date  Date,
  CONSTRAINT Cash_POrdAPV_PK      Primary Key (Id ),
  CONSTRAINT Cash_POrdAPV_FK      Foreign Key (Ord_Id  ) References Cash_POrd(Id),
  CONSTRAINT Cash_POrdAPV_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn (Id),
  CONSTRAINT Cash_POrdAPV_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Cash_POrdAPV_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Cash_POrdAPV For Cash_POrder_APVs
/
---------------------------------------------------------------------------------------------------
Create Sequence Cash_TOrd_Seq MinValue 100 Start With 100 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_Transfer_Order                      -- أوامر تبديل قطع
( Id             Number(9),                           -- مفتاح رئيسي
  Trt_IId        Number(5) Default 12,                -- نوع الحركة
  Trt_TId        Number(5) Default 22,                -- نوع الحركة
  Dept_Id        Number(5) Default 0,                 -- الدائرة
  Unit_Id        Number(5) Default 0,                 -- القسم
  Oper_Id        Number(5) Default 0,                 -- العملية
  Period_Id      Number(4) Default 0,                 -- السنة
  Cont_Id        Number(9) Default 0,                 -- المتعامل
  Serv_Id        Number(5) Default 0,                 -- الخدمة
  Method_Id      Number(5) Default 0,                 -- الطريقة
  CBox_FId       Number(5) Default 0,                 -- الصندوق من
  CBox_TId       Number(5) Default 0,                 -- الصندوق إلى
  Cash_FId       Number(5) Default 0,                 -- أمين الصندوق من
  Cash_TId       Number(5) Default 0,                 -- أمين الصندوق إلى
  User_Id        Number(5),                           -- المنظم
  Vhr_Id         Number(9),                           -- مفتاح سند القيد
  Vhr_DId        Number(9),                           -- مفتاح سند قيد التوزيع
  InsDate        Date Default Sysdate,                -- تاريخ التنظيم
  Num            Number(10),                          -- الرقم
  dDate          Date,                                -- التاريخ
  RNum           Number(10),                          -- رقم الإيصال
  RDate          Date,                                -- تاريخ الإيصال
  EDate          Date,                                -- تاريخ التنفيذ المطلوب
  ExecDate       Date Default Sysdate,                -- تاريخ التنفيذ
  Curn_FId       Number(3) Default 1,                 -- العملة من
  Curn_FRate     Number(25,9) Default 1,              -- سعر الصرف من
  FCAmt          Number(25,2) Default 0,              -- المبلغ عملة من
  FAmt           Number(25,2) Default 0,              -- المبلغ محلي من
  FExCAmt        Number(25,2) Default 0,              -- المبلغ المنفذ عملة من
  FExAmt         Number(25,2) Default 0,              -- المبلغ المنفذ محلي من
  Curn_TId       Number(3) Default 1,                 -- العملة إلى
  Curn_TRate     Number(25,9) Default 1,              -- سعر الصرف إلى
  TCAmt          Number(25,2) Default 0,              -- المبلغ عملة إلى
  TAmt           Number(25,2) Default 0,              -- المبلغ محلي إلى
  TExCAmt        Number(25,2) Default 0,              -- المبلغ المنفذ عملة إلى
  TExAmt         Number(25,2) Default 0,              -- المبلغ المنفذ محلي إلى
  Status_Id      Number(5) Default 0,                 -- الحالة
  Status_Date    Date,                                -- التاريخ
  Status_Descr   Varchar2(100 Char),                  -- الشرح
  City_Id        Number(5) Default 0,                 -- المدينة
  PhnBy_Id       Number(5) Default 0,                 -- شركة التحويل
  Correspondent  Varchar2(100 Char),                  -- المراسل correspondent
  Recipient      Varchar2(200 Char),                  -- المستلم
  DCust          Varchar2(250 Char),                  -- اسم الزبون الذي سيظهر على الإيصال
  Note           Varchar2(250 Char),                  --  ملاحظات التحويل
  Reason         Varchar2(250 Char),                  -- السبب
  Rem            Varchar2(250 Char),                  -- ملاحظات
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT     Cash_TOrd_PK         Primary Key (Id),
  CONSTRAINT     Cash_TOrd_Num_UK     Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT     Cash_TOrd_FTrt_FK    Foreign Key (Trt_IId   ) References Cash_Cod_Trt   (Id),
  CONSTRAINT     Cash_TOrd_TTrt_FK    Foreign Key (Trt_TId   ) References Cash_Cod_Trt   (Id),
  CONSTRAINT     Cash_TOrd_Dept_FK    Foreign Key (Dept_Id   ) References Cpy_Dept       (Id),
  CONSTRAINT     Cash_TOrd_Unit_FK    Foreign Key (Unit_Id   ) References Cpy_Unit       (Id),
  CONSTRAINT     Cash_TOrd_Oper_FK    Foreign Key (Oper_Id   ) References Cpy_Oper       (Id),
  CONSTRAINT     Cash_TOrd_Period_FK  Foreign Key (Period_Id ) References Cpy_Period     (Id),
  CONSTRAINT     Cash_TOrd_Status_FK  Foreign Key (Status_Id ) References Cash_Cod_Status(Id),
  CONSTRAINT     Cash_TOrd_FBox_FK    Foreign Key (CBox_FId  ) References Cash_Box       (Id),
  CONSTRAINT     Cash_TOrd_TBox_FK    Foreign Key (CBox_TId  ) References Cash_Box       (Id),
  CONSTRAINT     Cash_TOrd_FCash_FK   Foreign Key (Cash_FId  ) References Cash_Cash      (Id),
  CONSTRAINT     Cash_TOrd_TCash_FK   Foreign Key (Cash_TId  ) References Cash_Cash      (Id),
  CONSTRAINT     Cash_TOrd_Method_FK  Foreign Key (Method_Id ) References Cash_Cod_Method(Id),
  CONSTRAINT     Cash_TOrd_City_FK    Foreign Key (City_Id   ) References Cash_Cod_City  (Id),
  CONSTRAINT     Cash_TOrd_PhnBy_FK   Foreign Key (PhnBy_Id  ) References Cash_Cod_PhnBy (Id),
  CONSTRAINT     Cash_TOrd_Cont_FK    Foreign Key (Cont_Id   ) References Mng_Cont       (Id),
  CONSTRAINT     Cash_TOrd_Serv_FK    Foreign Key (Serv_Id   ) References Mng_Serv       (Id),
  CONSTRAINT     Cash_TOrd_CurnF_FK   Foreign Key (Curn_FId  ) References Mng_Curn       (Id),
  CONSTRAINT     Cash_TOrd_CurnT_FK   Foreign Key (Curn_TId  ) References Mng_Curn       (Id),
  CONSTRAINT     Cash_TOrd_Vhr_FK     Foreign Key (Vhr_Id    ) References Acc_Mst        (Id),
  CONSTRAINT     Cash_TOrd_VhrD_FK    Foreign Key (Vhr_DId   ) References Acc_Mst        (Id),
  CONSTRAINT     Cash_TOrd_User_FK    Foreign Key (User_Id   ) References Cpy_User       (Id),
  CONSTRAINT     Cash_TOrd_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT     Cash_TOrd_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Cash_TOrd For Cash_Transfer_Order
/
Create Sequence Cash_TOrdStatus_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Cash_TOrder_Status                       -- جدول تبدل حالات الأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Status_Id  Number(5) Default 0,                     -- الحالة
  dDate      Date,                                    -- التاريخ
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Cash_TOrdStatus_PK        Primary Key (Id),
  CONSTRAINT Cash_TOrdStatus_FK        Foreign Key (Ord_Id   ) References Cash_TOrd      (Id),
  CONSTRAINT Cash_TOrdStatus_Status_FK Foreign Key (Status_Id) References Cash_Cod_Status(Id),
  CONSTRAINT Cash_TOrdStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Cash_TOrdStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Cash_TOrdStatus For Cash_TOrder_Status
/
---------------------------------------------------------------------------------------------------
