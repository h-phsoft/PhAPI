--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'BANK%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'BANK%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'BANK%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'BANK%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'BANK%' ;
----------------------------------------------------------------------------------------------------
Create Table Bank_Code_Status                         -- جدول ترميز حالة الأمر
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Bank_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Bank_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Bank_Cod_Status_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Bank_Cod_Status_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Bank_Cod_Status_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Bank_Cod_Status For Bank_Code_Status
/
INSERT INTO Bank_Cod_Status (Id, Name) VALUES (0 , '-');
INSERT INTO Bank_Cod_Status (Id, Name) VALUES (10, 'Approved' );
INSERT INTO Bank_Cod_Status (Id, Name) VALUES (11, 'Executed' );
INSERT INTO Bank_Cod_Status (Id, Name) VALUES (12, 'Certified');
INSERT INTO Bank_Cod_Status (Id, Name) VALUES (13, 'Canceled' );
---------------------------------------------------------------------------------------------------
Create Table Bank_Code_Method                           -- جدول ترميز الطريقة
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Bank_Cod_Method_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Bank_Cod_Method_UK     UNIQUE      (Name),
  CONSTRAINT Bank_Cod_Method_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Bank_Cod_Method_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Bank_Cod_Method_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Bank_Cod_Method For Bank_Code_Method
/
INSERT INTO Bank_Code_Method (Id, Name) VALUES (0  , '-');
---------------------------------------------------------------------------------------------------
Create Table Bank_Code_Trt                            -- جدول ترميز أنواع الحركات
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Bank_Cod_Trt_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Bank_Cod_Trt_UK     UNIQUE      (Name),
  CONSTRAINT Bank_Cod_Trt_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Bank_Cod_Trt_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Bank_Cod_Trt_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Bank_Cod_Trt For Bank_Code_Trt
/
INSERT INTO Bank_Cod_Trt (Id, Name, Rem) VALUES (0 , '-'  , '-'       );
INSERT INTO Bank_Cod_Trt (Id, Name, Rem) VALUES (11, 'CO' , 'Collect' );
INSERT INTO Bank_Cod_Trt (Id, Name, Rem) VALUES (12, 'WO' , 'Deposit' );
INSERT INTO Bank_Cod_Trt (Id, Name, Rem) VALUES (21, 'PO' , 'Payment' );
INSERT INTO Bank_Cod_Trt (Id, Name, Rem) VALUES (22, 'DO' , 'Withdraw');
INSERT INTO Bank_Cod_Trt (Id, Name, Rem) VALUES (30, 'TIO', 'Transfer');
INSERT INTO Bank_Cod_Trt (Id, Name, Rem) VALUES (40, 'TOO', 'Transfer');
---------------------------------------------------------------------------------------------------
Create Sequence Bank_Acc_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Bank_Accounts                            -- دليل المصارف
( Id            Number(5),                            -- مفتاح رئيسي
  Code          Varchar2(15 Char),                     -- الرمز
  Name          Varchar2(100 Char),                   -- الاسم
  Status_Id     Number(1) Default 1,                  -- حالة الإستخدام \ 1 فعالة \ 0 غير مستخدمة
  Cost_Id       Number(9),                            -- مركز الكلفة
  Acc_Id        Number(9),                            -- الحساب
  Acc_CId       Number(9),                            -- حساب العمولة Commission
  Curn_Id       Number(3) Default 1,                 -- العملة
  AccNum        Varchar2(100 Char),                   -- رقم الحساب في البنك
  AccName       Varchar2(200 Char),                   -- اسم الحساب في البنك
  BName         Varchar2(100 Char),                   -- اسم البنك
  BAddress      Varchar2(200 Char),                   -- عنوان البنك أو الفرع
  BSwift        Varchar2(100 Char),                   -- سويفت
  BFax          Varchar2(50 Char),                    -- فاكس
  Rem           Varchar2(250 Char),                   -- ملاحظات
  Note          Varchar2(2000 Char),                  -- ملاحظات
  Ins_User      Number(20), Ins_Date Date,
  Upd_User      Number(20), Upd_Date Date,
  CONSTRAINT    Bank_Acc_PK        Primary Key (Id  ),
  CONSTRAINT    Bank_Acc_Cod_UK    Unique      (Code),
  CONSTRAINT    Bank_Acc_Nam_UK    Unique      (Name),
  CONSTRAINT    Bank_Acc_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT    Bank_Acc_Cost_FK   Foreign Key (Cost_Id  ) References Acc_Cost      (Id),
  CONSTRAINT    Bank_Acc_Acc_FK    Foreign Key (Acc_Id   ) References Acc_Acc       (Id),
  CONSTRAINT    Bank_Acc_CAcc_FK   Foreign Key (Acc_CId  ) References Acc_Acc       (Id),
  CONSTRAINT    Bank_Acc_Curn_FK    Foreign Key(Curn_Id ) References Mng_Curn      (Id),
  CONSTRAINT    Bank_Acc_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT    Bank_Acc_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Bank_Acc For Bank_Accounts
/
---------------------------------------------------------------------------------------------------
Create Sequence Bank_COrd_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Bank_Collect_Order                       -- أوامر القبض
( Id             Number(9),                           -- مفتاح رئيسي
  Trt_Id         Number(5) Default 11,                -- نوع الحركة
  Dept_Id        Number(5) Default 0,                 -- الدائرة
  Unit_Id        Number(5) Default 0,                 -- القسم
  Oper_Id        Number(5) Default 0,                 -- العملية
  Period_Id      Number(4) Default 0,                 -- السنة
  Cont_Id        Number(9) Default 0,                 -- المتعامل
  Serv_Id        Number(5) Default 0,                 -- الخدمة
  Method_Id      Number(5) Default 0,                 -- الطريقة
  User_Id        Number(5),                           -- المنظم
  Vhr_Id         Number(9),                           -- مفتاح سند القيد
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
  CCom           Number(25,2) Default 0,              -- العمولة عملة
  Com            Number(25,2) Default 0,              -- العمولة محلي
  ExCCom         Number(25,2) Default 0,              -- العمولة فعلي عملة
  ExCom          Number(25,2) Default 0,              -- العمولة فعلي محلي
  Status_Id      Number(5) Default 0,                 -- الحالة
  Status_Date    Date,                                -- التاريخ
  Status_Descr   Varchar2(100 Char),                  -- الشرح
  MNum           Varchar2(30 Char),                   -- رقم الشيك\التحويل المصرفي\الحوالة الهاتفية\التحويل
  MDate          Date,                                -- تاريخ الشيك\التحويل المصرفي\الحوالة الهاتفية\التحويل
  Bank_Id        Number(5),                           -- البنك
  City_Id        Number(5) Default 0,                 -- المدينة
  PhnBy          Number(5) Default 0,                 -- شركة التحويل
  Correspondent  Varchar2(100 Char),                  -- المراسل correspondent
  Recipient      Varchar2(200 Char),                  -- المستلم
  TStatus_Id     Number(1) Default 2,                 -- مؤشر تنفيذ التحويل
  TDate          Date,                                -- تاريخ و وقت إنشاء ورقة التحويل
  TNote          Varchar2(250 Char),                  --  ملاحظات التحويل
  DCust          Varchar2(250 Char),                  -- اسم الزبون الذي سيظهر على الإيصال
  Reason         Varchar2(250 Char),                  -- السبب
  Rem            Varchar2(250 Char),                  -- ملاحظات
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT     Bank_COrd_PK         Primary Key (Id),
  CONSTRAINT     Bank_COrd_Num_UK     Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT     Bank_COrd_Dept_FK    Foreign Key (Dept_Id  ) References Cpy_Dept       (Id),
  CONSTRAINT     Bank_COrd_Unit_FK    Foreign Key (Unit_Id  ) References Cpy_Unit       (Id),
  CONSTRAINT     Bank_COrd_Oper_FK    Foreign Key (Oper_Id  ) References Cpy_Oper       (Id),
  CONSTRAINT     Bank_COrd_Period_FK  Foreign Key (Period_Id) References Cpy_Period     (Id),
  CONSTRAINT     Bank_COrd_Trt_FK     Foreign Key (Trt_Id   ) References Bank_Cod_Trt   (Id),
  CONSTRAINT     Bank_COrd_Status_FK  Foreign Key (Status_Id) References Bank_Cod_Status(Id),
  CONSTRAINT     Bank_COrd_Cont_FK    Foreign Key (Cont_Id  ) References Mng_Cont       (Id),
  CONSTRAINT     Bank_COrd_Serv_FK    Foreign Key (Serv_Id  ) References Mng_Serv       (Id),
  CONSTRAINT     Bank_COrd_Curn_FK    Foreign Key (Curn_Id  ) References Mng_Curn       (Id),
  CONSTRAINT     Bank_COrd_Vhr_FK     Foreign Key (Vhr_Id   ) References Acc_Mst        (Id),
  CONSTRAINT     Bank_COrd_Bank_FK    Foreign Key (Bank_Id  ) References Bank_Acc       (Id),
  CONSTRAINT     Bank_COrd_User_FK    Foreign Key (User_Id  ) References Cpy_User       (Id),
  CONSTRAINT     Bank_COrd_Ins_FK     Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT     Bank_COrd_Upd_FK     Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Bank_COrd For Bank_Collect_Order
/
Create Sequence Bank_COrdStatus_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Bank_COrder_Status                       -- جدول تبدل حالات الأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Status_Id  Number(5) Default 0,                     -- الحالة
  dDate      Date,                                    -- التاريخ
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Bank_COrdStatus_PK        Primary Key (Id),
  CONSTRAINT Bank_COrdStatus_FK        Foreign Key (Ord_Id   ) References Bank_COrd      (Id),
  CONSTRAINT Bank_COrdStatus_Status_FK Foreign Key (Status_Id) References Bank_Cod_Status(Id),
  CONSTRAINT Bank_COrdStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Bank_COrdStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Bank_COrdStatus For Bank_COrder_Status
/
---------------------------------------------------------------------------------------------------
Create Sequence Bank_DOrd_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Bank_Deposit_Order                       -- أوامر الإيداع في البنك
( Id             Number(9),                           -- مفتاح رئيسي
  Trt_Id         Number(5) Default 12,                -- نوع الحركة
  Dept_Id        Number(5) Default 0,                 -- الدائرة
  Unit_Id        Number(5) Default 0,                 -- القسم
  Oper_Id        Number(5) Default 0,                 -- العملية
  Period_Id      Number(4) Default 0,                 -- السنة
  Cont_Id        Number(9) Default 0,                 -- المتعامل
  Serv_Id        Number(5) Default 0,                 -- الخدمة
  Method_Id      Number(5) Default 0,                 -- الطريقة
  User_Id        Number(5),                           -- المنظم
  Vhr_Id         Number(9),                           -- مفتاح سند القيد
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
  CCom           Number(25,2) Default 0,              -- العمولة عملة
  Com            Number(25,2) Default 0,              -- العمولة محلي
  ExCCom         Number(25,2) Default 0,              -- العمولة فعلي عملة
  ExCom          Number(25,2) Default 0,              -- العمولة فعلي محلي
  Status_Id      Number(5) Default 0,                 -- الحالة
  Status_Date    Date,                                -- التاريخ
  Status_Descr   Varchar2(100 Char),                  -- الشرح
  MNum           Varchar2(30 Char),                   -- رقم الشيك\التحويل المصرفي\الحوالة الهاتفية\التحويل
  MDate          Date,                                -- تاريخ الشيك\التحويل المصرفي\الحوالة الهاتفية\التحويل
  Bank_Id        Number(5),                           -- البنك
  City_Id        Number(5) Default 0,                 -- المدينة
  PhnBy          Number(5) Default 0,                 -- شركة التحويل
  Correspondent  Varchar2(100 Char),                  -- المراسل correspondent
  Recipient      Varchar2(200 Char),                  -- المستلم
  TStatus_Id     Number(1) Default 2,                 -- مؤشر تنفيذ التحويل
  TDate          Date,                                -- تاريخ و وقت إنشاء ورقة التحويل
  TNote          Varchar2(250 Char),                  --  ملاحظات التحويل
  DCust          Varchar2(250 Char),                  -- اسم الزبون الذي سيظهر على الإيصال
  Reason         Varchar2(250 Char),                  -- السبب
  Rem            Varchar2(250 Char),                  -- ملاحظات
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT     Bank_DOrd_PK         Primary Key (Id),
  CONSTRAINT     Bank_DOrd_Num_UK     Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT     Bank_DOrd_Dept_FK    Foreign Key (Dept_Id  ) References Cpy_Dept       (Id),
  CONSTRAINT     Bank_DOrd_Unit_FK    Foreign Key (Unit_Id  ) References Cpy_Unit       (Id),
  CONSTRAINT     Bank_DOrd_Oper_FK    Foreign Key (Oper_Id  ) References Cpy_Oper       (Id),
  CONSTRAINT     Bank_DOrd_Period_FK  Foreign Key (Period_Id) References Cpy_Period     (Id),
  CONSTRAINT     Bank_DOrd_Trt_FK     Foreign Key (Trt_Id   ) References Bank_Cod_Trt   (Id),
  CONSTRAINT     Bank_DOrd_Status_FK  Foreign Key (Status_Id) References Bank_Cod_Status(Id),
  CONSTRAINT     Bank_DOrd_Cont_FK    Foreign Key (Cont_Id  ) References Mng_Cont       (Id),
  CONSTRAINT     Bank_DOrd_Serv_FK    Foreign Key (Serv_Id  ) References Mng_Serv       (Id),
  CONSTRAINT     Bank_DOrd_Curn_FK    Foreign Key (Curn_Id  ) References Mng_Curn       (Id),
  CONSTRAINT     Bank_DOrd_Vhr_FK     Foreign Key (Vhr_Id   ) References Acc_Mst        (Id),
  CONSTRAINT     Bank_DOrd_Bank_FK    Foreign Key (Bank_Id  ) References Bank_Acc       (Id),
  CONSTRAINT     Bank_DOrd_User_FK    Foreign Key (User_Id  ) References Cpy_User       (Id),
  CONSTRAINT     Bank_DOrd_Ins_FK     Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT     Bank_DOrd_Upd_FK     Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Bank_DOrd For Bank_Deposit_Order
/
Create Sequence Bank_DOrdStatus_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Bank_DOrder_Status                       -- جدول تبدل حالات الأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Status_Id  Number(5) Default 0,                     -- الحالة
  dDate      Date,                                    -- التاريخ
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Bank_DOrdStatus_PK        Primary Key (Id),
  CONSTRAINT Bank_DOrdStatus_FK        Foreign Key (Ord_Id   ) References Bank_DOrd      (Id),
  CONSTRAINT Bank_DOrdStatus_Status_FK Foreign Key (Status_Id) References Bank_Cod_Status(Id),
  CONSTRAINT Bank_DOrdStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Bank_DOrdStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Bank_DOrdStatus For Bank_DOrder_Status
/
---------------------------------------------------------------------------------------------------
Create Sequence Bank_POrd_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Bank_Payment_Order                      -- أوامر السحب من البنك
( Id             Number(9),                           -- مفتاح رئيسي
  Trt_Id         Number(5) Default 21,                -- نوع الحركة
  Dept_Id        Number(5) Default 0,                 -- الدائرة
  Unit_Id        Number(5) Default 0,                 -- القسم
  Oper_Id        Number(5) Default 0,                 -- العملية
  Period_Id      Number(4) Default 0,                 -- السنة
  Cont_Id        Number(9) Default 0,                 -- المتعامل
  Serv_Id        Number(5) Default 0,                 -- الخدمة
  Method_Id      Number(5) Default 0,                 -- الطريقة
  User_Id        Number(5),                           -- المنظم
  Vhr_Id         Number(9),                           -- مفتاح سند القيد
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
  CCom           Number(25,2) Default 0,              -- العمولة عملة
  Com            Number(25,2) Default 0,              -- العمولة محلي
  ExCCom         Number(25,2) Default 0,              -- العمولة فعلي عملة
  ExCom          Number(25,2) Default 0,              -- العمولة فعلي محلي
  Status_Id      Number(5) Default 0,                 -- الحالة
  Status_Date    Date,                                -- التاريخ
  Status_Descr   Varchar2(100 Char),                  -- الشرح
  MNum           Varchar2(30 Char),                   -- رقم الشيك\التحويل المصرفي\الحوالة الهاتفية\التحويل
  MDate          Date,                                -- تاريخ الشيك\التحويل المصرفي\الحوالة الهاتفية\التحويل
  Bank_Id        Number(5),                           -- البنك
  City_Id        Number(5) Default 0,                 -- المدينة
  PhnBy          Number(5) Default 0,                 -- شركة التحويل
  Correspondent  Varchar2(100 Char),                  -- المراسل correspondent
  Recipient      Varchar2(200 Char),                  -- المستلم
  TStatus_Id     Number(1) Default 2,                 -- مؤشر تنفيذ التحويل
  TDate          Date,                                -- تاريخ و وقت إنشاء ورقة التحويل
  TNote          Varchar2(250 Char),                  --  ملاحظات التحويل
  DCust          Varchar2(250 Char),                  -- اسم الزبون الذي سيظهر على الإيصال
  Reason         Varchar2(250 Char),                  -- السبب
  Rem            Varchar2(250 Char),                  -- ملاحظات
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT     Bank_POrd_PK         Primary Key (Id),
  CONSTRAINT     Bank_POrd_Num_UK     Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT     Bank_POrd_Dept_FK    Foreign Key (Dept_Id  ) References Cpy_Dept       (Id),
  CONSTRAINT     Bank_POrd_Unit_FK    Foreign Key (Unit_Id  ) References Cpy_Unit       (Id),
  CONSTRAINT     Bank_POrd_Oper_FK    Foreign Key (Oper_Id  ) References Cpy_Oper       (Id),
  CONSTRAINT     Bank_POrd_Period_FK  Foreign Key (Period_Id) References Cpy_Period     (Id),
  CONSTRAINT     Bank_POrd_Trt_FK     Foreign Key (Trt_Id   ) References Bank_Cod_Trt   (Id),
  CONSTRAINT     Bank_POrd_Status_FK  Foreign Key (Status_Id) References Bank_Cod_Status(Id),
  CONSTRAINT     Bank_POrd_Cont_FK    Foreign Key (Cont_Id  ) References Mng_Cont       (Id),
  CONSTRAINT     Bank_POrd_Serv_FK    Foreign Key (Serv_Id  ) References Mng_Serv       (Id),
  CONSTRAINT     Bank_POrd_Curn_FK    Foreign Key (Curn_Id  ) References Mng_Curn       (Id),
  CONSTRAINT     Bank_POrd_Vhr_FK     Foreign Key (Vhr_Id   ) References Acc_Mst        (Id),
  CONSTRAINT     Bank_POrd_Bank_FK    Foreign Key (Bank_Id  ) References Bank_Acc       (Id),
  CONSTRAINT     Bank_POrd_User_FK    Foreign Key (User_Id  ) References Cpy_User       (Id),
  CONSTRAINT     Bank_POrd_Ins_FK     Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT     Bank_POrd_Upd_FK     Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Bank_POrd For Bank_Payment_Order
/
Create Sequence Bank_POrdStatus_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Bank_POrder_Status                       -- جدول تبدل حالات الأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Status_Id  Number(5) Default 0,                     -- الحالة
  dDate      Date,                                    -- التاريخ
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Bank_POrdStatus_PK        Primary Key (Id),
  CONSTRAINT Bank_POrdStatus_FK        Foreign Key (Ord_Id   ) References Bank_POrd      (Id),
  CONSTRAINT Bank_POrdStatus_Status_FK Foreign Key (Status_Id) References Bank_Cod_Status(Id),
  CONSTRAINT Bank_POrdStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Bank_POrdStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Bank_POrdStatus For Bank_POrder_Status
/
---------------------------------------------------------------------------------------------------
Create Sequence Bank_WOrd_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Bank_Withdraw_Order                      -- أوامر السحب من البنك
( Id             Number(9),                           -- مفتاح رئيسي
  Trt_Id         Number(5) Default 22,                -- نوع الحركة
  Dept_Id        Number(5) Default 0,                 -- الدائرة
  Unit_Id        Number(5) Default 0,                 -- القسم
  Oper_Id        Number(5) Default 0,                 -- العملية
  Period_Id      Number(4) Default 0,                 -- السنة
  Cont_Id        Number(9) Default 0,                 -- المتعامل
  Serv_Id        Number(5) Default 0,                 -- الخدمة
  Method_Id      Number(5) Default 0,                 -- الطريقة
  User_Id        Number(5),                           -- المنظم
  Vhr_Id         Number(9),                           -- مفتاح سند القيد
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
  CCom           Number(25,2) Default 0,              -- العمولة عملة
  Com            Number(25,2) Default 0,              -- العمولة محلي
  ExCCom         Number(25,2) Default 0,              -- العمولة فعلي عملة
  ExCom          Number(25,2) Default 0,              -- العمولة فعلي محلي
  Status_Id      Number(5) Default 0,                 -- الحالة
  Status_Date    Date,                                -- التاريخ
  Status_Descr   Varchar2(100 Char),                  -- الشرح
  MNum           Varchar2(30 Char),                   -- رقم الشيك\التحويل المصرفي\الحوالة الهاتفية\التحويل
  MDate          Date,                                -- تاريخ الشيك\التحويل المصرفي\الحوالة الهاتفية\التحويل
  Bank_Id        Number(5),                           -- البنك
  City_Id        Number(5) Default 0,                 -- المدينة
  PhnBy          Number(5) Default 0,                 -- شركة التحويل
  Correspondent  Varchar2(100 Char),                  -- المراسل correspondent
  Recipient      Varchar2(200 Char),                  -- المستلم
  TStatus_Id     Number(1) Default 2,                 -- مؤشر تنفيذ التحويل
  TDate          Date,                                -- تاريخ و وقت إنشاء ورقة التحويل
  TNote          Varchar2(250 Char),                  --  ملاحظات التحويل
  DCust          Varchar2(250 Char),                  -- اسم الزبون الذي سيظهر على الإيصال
  Reason         Varchar2(250 Char),                  -- السبب
  Rem            Varchar2(250 Char),                  -- ملاحظات
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT     Bank_WOrd_PK         Primary Key (Id),
  CONSTRAINT     Bank_WOrd_Num_UK     Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT     Bank_WOrd_Dept_FK    Foreign Key (Dept_Id  ) References Cpy_Dept       (Id),
  CONSTRAINT     Bank_WOrd_Unit_FK    Foreign Key (Unit_Id  ) References Cpy_Unit       (Id),
  CONSTRAINT     Bank_WOrd_Oper_FK    Foreign Key (Oper_Id  ) References Cpy_Oper       (Id),
  CONSTRAINT     Bank_WOrd_Period_FK  Foreign Key (Period_Id) References Cpy_Period     (Id),
  CONSTRAINT     Bank_WOrd_Trt_FK     Foreign Key (Trt_Id   ) References Bank_Cod_Trt   (Id),
  CONSTRAINT     Bank_WOrd_Status_FK  Foreign Key (Status_Id) References Bank_Cod_Status(Id),
  CONSTRAINT     Bank_WOrd_Cont_FK    Foreign Key (Cont_Id  ) References Mng_Cont       (Id),
  CONSTRAINT     Bank_WOrd_Serv_FK    Foreign Key (Serv_Id  ) References Mng_Serv       (Id),
  CONSTRAINT     Bank_WOrd_Curn_FK    Foreign Key (Curn_Id  ) References Mng_Curn       (Id),
  CONSTRAINT     Bank_WOrd_Vhr_FK     Foreign Key (Vhr_Id   ) References Acc_Mst        (Id),
  CONSTRAINT     Bank_WOrd_Bank_FK    Foreign Key (Bank_Id  ) References Bank_Acc       (Id),
  CONSTRAINT     Bank_WOrd_User_FK    Foreign Key (User_Id  ) References Cpy_User       (Id),
  CONSTRAINT     Bank_WOrd_Ins_FK     Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT     Bank_WOrd_Upd_FK     Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Bank_WOrd For Bank_Withdraw_Order
/
Create Sequence Bank_WOrdStatus_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Bank_WOrder_Status                       -- جدول تبدل حالات الأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Status_Id  Number(5) Default 0,                     -- الحالة
  dDate      Date,                                    -- التاريخ
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Bank_WOrdStatus_PK        Primary Key (Id),
  CONSTRAINT Bank_WOrdStatus_FK        Foreign Key (Ord_Id   ) References Bank_WOrd      (Id),
  CONSTRAINT Bank_WOrdStatus_Status_FK Foreign Key (Status_Id) References Bank_Cod_Status(Id),
  CONSTRAINT Bank_WOrdStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Bank_WOrdStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Bank_WOrdStatus For Bank_WOrder_Status
/
---------------------------------------------------------------------------------------------------
Create Sequence Bank_TOrd_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Bank_Transfer_Order                      -- أوامر تحويل بين البنوك
( Id             Number(9),                           -- مفتاح رئيسي
  Trt_IId        Number(5) Default 30,                -- نوع الحركة
  Trt_OId        Number(5) Default 40,                -- نوع الحركة
  Dept_Id        Number(5) Default 0,                 -- الدائرة
  Unit_Id        Number(5) Default 0,                 -- القسم
  Oper_Id        Number(5) Default 0,                 -- العملية
  Period_Id      Number(4) Default 0,                 -- السنة
  Cont_Id        Number(9) Default 0,                 -- المتعامل
  Serv_Id        Number(5) Default 0,                 -- الخدمة
  Method_Id      Number(5) Default 0,                 -- الطريقة
  User_Id        Number(5),                           -- المنظم
  Vhr_Id         Number(9),                           -- مفتاح سند القيد
  InsDate        Date Default Sysdate,                -- تاريخ التنظيم
  Num            Number(10),                          -- الرقم
  dDate          Date,                                -- التاريخ
  RNum           Number(10),                          -- رقم الإيصال
  RDate          Date,                                -- تاريخ الإيصال
  EDate          Date,                                -- تاريخ التنفيذ المطلوب
  ExecDate       Date,                                -- تاريخ التنفيذ
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
  FCCom          Number(25,2) Default 0,              -- العمولة عملة من
  FCom           Number(25,2) Default 0,              -- العمولة محلي من
  TCCom          Number(25,2) Default 0,              -- العمولة عملة الى
  TCom           Number(25,2) Default 0,              -- العمولة محلي الى
  ExFCCom        Number(25,2) Default 0,              -- العمولة فعلي عملة من
  ExFCom         Number(25,2) Default 0,              -- العمولة فعلي محلي من
  ExTCCom        Number(25,2) Default 0,              -- العمولة فعلي عملة الى
  ExTCom         Number(25,2) Default 0,              -- العمولة فعلي محلي الى
  Status_Id      Number(5) Default 0,                 -- الحالة
  Status_Date    Date,                                -- التاريخ
  Status_Descr   Varchar2(100 Char),                  -- الشرح
  MNum           Varchar2(30 Char),                   -- رقم الشيك\التحويل المصرفي\الحوالة الهاتفية\التحويل
  MDate          Date,                                -- تاريخ الشيك\التحويل المصرفي\الحوالة الهاتفية\التحويل
  Bank_FId       Number(5),                           -- البنك
  Bank_TId       Number(5),                           -- البنك
  City_Id        Number(5) Default 0,                 -- المدينة
  PhnBy          Number(5) Default 0,                 -- شركة التحويل
  Correspondent  Varchar2(100 Char),                  -- المراسل correspondent
  Recipient      Varchar2(200 Char),                  -- المستلم
  TStatus_Id     Number(1) Default 2,                 -- مؤشر تنفيذ التحويل
  TDate          Date,                                -- تاريخ و وقت إنشاء ورقة التحويل
  TNote          Varchar2(250 Char),                  --  ملاحظات التحويل
  DCust          Varchar2(250 Char),                  -- اسم الزبون الذي سيظهر على الإيصال
  Reason         Varchar2(250 Char),                  -- السبب
  Rem            Varchar2(250 Char),                  -- ملاحظات
  Ins_User       Number(5), Ins_Date   Date,
  Upd_User       Number(5), Upd_Date   Date,
  CONSTRAINT     Bank_TOrd_PK         Primary Key (Id),
  CONSTRAINT     Bank_TOrd_Num_UK     Unique      (Dept_Id, Unit_Id, Period_Id, Num),
  CONSTRAINT     Bank_TOrd_Dept_FK    Foreign Key (Dept_Id   ) References Cpy_Dept       (Id),
  CONSTRAINT     Bank_TOrd_Unit_FK    Foreign Key (Unit_Id   ) References Cpy_Unit       (Id),
  CONSTRAINT     Bank_TOrd_Oper_FK    Foreign Key (Oper_Id   ) References Cpy_Oper       (Id),
  CONSTRAINT     Bank_TOrd_Period_FK  Foreign Key (Period_Id ) References Cpy_Period     (Id),
  CONSTRAINT     Bank_TOrd_TrtI_FK    Foreign Key (Trt_IId   ) References Bank_Cod_Trt   (Id),
  CONSTRAINT     Bank_TOrd_TrtO_FK    Foreign Key (Trt_OId   ) References Bank_Cod_Trt   (Id),
  CONSTRAINT     Bank_TOrd_Status_FK  Foreign Key (Status_Id ) References Bank_Cod_Status(Id),
  CONSTRAINT     Bank_TOrd_Cont_FK    Foreign Key (Cont_Id   ) References Mng_Cont       (Id),
  CONSTRAINT     Bank_TOrd_Serv_FK    Foreign Key (Serv_Id   ) References Mng_Serv       (Id),
  CONSTRAINT     Bank_TOrd_TStatus_FK Foreign Key (TStatus_Id) References Phs_Cod_YesNo  (Id),
  CONSTRAINT     Bank_TOrd_FCurn_FK   Foreign Key (Curn_FId  ) References Mng_Curn       (Id),
  CONSTRAINT     Bank_TOrd_TCurn_FK   Foreign Key (Curn_TId  ) References Mng_Curn       (Id),
  CONSTRAINT     Bank_TOrd_Vhr_FK     Foreign Key (Vhr_Id    ) References Acc_Mst        (Id),
  CONSTRAINT     Bank_TOrd_BankF_FK   Foreign Key (Bank_FId  ) References Bank_Acc       (Id),
  CONSTRAINT     Bank_TOrd_BankT_FK   Foreign Key (Bank_TId  ) References Bank_Acc       (Id),
  CONSTRAINT     Bank_TOrd_User_FK    Foreign Key (User_Id   ) References Cpy_User       (Id),
  CONSTRAINT     Bank_TOrd_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT     Bank_TOrd_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Bank_TOrd For Bank_Transfer_Order
/
Create Sequence Bank_TOrdStatus_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Bank_TOrder_Status                       -- جدول تبدل حالات الأمر
( Id         Number(20) NOT NULL,                     -- مفتاح رئيسي
  Ord_Id     Number(9) NOT NULL,                      -- مفتاح الأب
  Status_Id  Number(5) Default 0,                     -- الحالة
  dDate      Date,                                    -- التاريخ
  Rem        Varchar2(250 Char),                      -- البيان
  Ins_User   Number(20),  Ins_Date  Date,
  Upd_User   Number(20),  Upd_Date  Date,
  CONSTRAINT Bank_TOrdStatus_PK        Primary Key (Id),
  CONSTRAINT Bank_TOrdStatus_FK        Foreign Key (Ord_Id   ) References Bank_TOrd      (Id),
  CONSTRAINT Bank_TOrdStatus_Status_FK Foreign Key (Status_Id) References Bank_Cod_Status(Id),
  CONSTRAINT Bank_TOrdStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Bank_TOrdStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Bank_TOrdStatus For Bank_TOrder_Status
/
