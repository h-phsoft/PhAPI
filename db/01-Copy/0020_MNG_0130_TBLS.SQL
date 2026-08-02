--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'MNG%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'MNG%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'MNG%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'MNG%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'MNG%' ;
----------------------------------------------------------------------------------------------------
Create Sequence MngId_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;

Create Sequence Mng_Curn_Seq MinValue 1 Start With 1 MaxValue 999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Currency				                           -- دليل العملات
( Id          Number(3) NOT NULL,                          -- مفتاح رئيسي
  Num         Varchar2(5 Char),				                     -- الرقم
  Name        Varchar2(100 Char) NOT NULL,			           -- اسم العملة
  Code        Varchar2(5 Char) NOT NULL,				           -- رمز العملة
  Rate        Number(10,3),				                         -- سعر الصرف لليرة
  Status_Id   Number(1) Default 1,  			                 -- حالة الإستخدام \ 1 فعالة \ 0 غير مستخدمة
  HDate       Date Default sysdate,					               -- التاريخ
  Rem         Varchar2(250 Char),			                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  Mng_Curn_PK        PRIMARY KEY (Id  ),
  CONSTRAINT  Mng_Curn_NUM_UK    UNIQUE      (Num ),
  CONSTRAINT  Mng_Curn_NAM_UK    UNIQUE      (Name),
  CONSTRAINT  Mng_Curn_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  Mng_Curn_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Mng_Curn_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Mng_Curn For Mng_Currency
/

Create Sequence Mng_CurnHist_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Mng_Currency_History			                     -- تبدل أسعار العملات
( Id          Number(10) NOT NULL,				                 -- مفتاح رئيسي
  HDate       Date NOT NULL,					                     -- التاريخ
  Curn_Id     Number(3) NOT NULL,				                   -- مفتاح العملة
  Rate        Number(10,3) Default 1,			                 -- سعر الصرف لليرة السوق
  nMin        Number(10,3) Default 1,			                 -- سعر الصرف لليرة الأدنى مركزي
  nMax        Number(10,3) Default 1,			                 -- سعر الصرف لليرة الأعلى مركزي
  Rem         Varchar2(250 Char),			                     -- ملاحظات
  Ins_User    Number(5), Ins_Date Date,
  CONSTRAINT  Mng_CHist_PK      PRIMARY KEY (Id),
  CONSTRAINT  Mng_CHist_Curn_FK Foreign Key (Curn_Id ) References Mng_Curn(Id),
  CONSTRAINT  Mng_CHist_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id)
)
/
Create Synonym Mng_CurnHist For Mng_Currency_History
/
