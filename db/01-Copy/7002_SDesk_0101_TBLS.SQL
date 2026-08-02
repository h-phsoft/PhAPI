--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'SDESK%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'SDESK%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'SDESK%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'SDESK%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'SDESK%' ;
----------------------------------------------------------------------------------------------------
Create Table SDesk_Code_Conversation_Type                  -- جدول تراميز حالات المحادثة
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cod_Conv_Type_PK     PRIMARY KEY (Id  ),
  CONSTRAINT SDesk_Cod_Conv_Type_UK     UNIQUE      (Name),
  CONSTRAINT SDesk_Cod_Conv_Type_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Cod_Conv_Type_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cod_Conv_Type_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cod_Conv_Type For SDesk_Code_Conversation_Type
/
Insert into SDesk_Cod_Conv_Type (Id,Name) values (1,'Msg');
Insert into SDesk_Cod_Conv_Type (Id,Name) values (2,'Attach');
Insert into SDesk_Cod_Conv_Type (Id,Name) values (3,'Img');
Insert into SDesk_Cod_Conv_Type (Id,Name) values (4,'Change Status');
Insert into SDesk_Cod_Conv_Type (Id,Name) values (5,'Change User');
Insert into SDesk_Cod_Conv_Type (Id,Name) values (6,'Change Sla');

Create Table SDesk_Code_Rating                             -- جدول تراميز درجات التقييم
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cod_Rating_PK     PRIMARY KEY (Id  ),
  CONSTRAINT SDesk_Cod_Rating_UK     UNIQUE      (Name),
  CONSTRAINT SDesk_Cod_Rating_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Cod_Rating_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cod_Rating_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cod_Rating For SDesk_Code_Rating
/
Insert into SDesk_Cod_Rating (Id,Name) values (0,'-'        );
Insert into SDesk_Cod_Rating (Id,Name) values (1,'bad'      );
Insert into SDesk_Cod_Rating (Id,Name) values (2,'not bad'  );
Insert into SDesk_Cod_Rating (Id,Name) values (3,'good'     );
Insert into SDesk_Cod_Rating (Id,Name) values (4,'very good');
Insert into SDesk_Cod_Rating (Id,Name) values (5,'excellent');

Create Table SDesk_Code_Side                               -- جدول تراميز جهة الإرسال في المحادثة
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cod_Side_PK        PRIMARY KEY (Id  ),
  CONSTRAINT SDesk_Cod_Side_UK        UNIQUE      (Name),
  CONSTRAINT SDesk_Cod_Side_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Cod_Side_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cod_Side_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cod_Side For SDesk_Code_Side
/

Insert into SDesk_Cod_Side (Id,Name) values (1,'Customer');
Insert into SDesk_Cod_Side (Id,Name) values (2,'Staff'   );

Create Table SDesk_Code_Unit                               -- جدول ترميز الوحدات الزمنية
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cod_Unit_PK        PRIMARY KEY (Id  ),
  CONSTRAINT SDesk_Cod_Unit_UK        UNIQUE      (Name),
  CONSTRAINT SDesk_Cod_Unit_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Cod_Unit_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cod_Unit_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cod_Unit For SDesk_Code_Unit
/
Insert into SDesk_Cod_Unit (Id,Name) values (1,'Hour');
Insert into SDesk_Cod_Unit (Id,Name) values (2,'Day' );

Create Sequence SDesk_Cod_Auto_Conv_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Code_Auto_Conversation                  -- جدول رميز الرسائل الآلية 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Key        Varchar2(100 Char),                           -- الطلب
  value      Varchar2(1024 Char),                          -- سبب التغيير
  Rem        Varchar2(512 Char),                           -- الملاحظات
  Ins_User   Number(5), Ins_Date     Date,                 -- تاريخ التغيير
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cod_Auto_Conv_PK     PRIMARY KEY (Id),
  CONSTRAINT SDesk_Cod_Auto_Conv_UK     UNIQUE      (Key),
  CONSTRAINT SDesk_Cod_Auto_Conv_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT SDesk_Cod_Auto_Conv_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym SDesk_Cod_Auto_Conv For SDesk_Code_Auto_Conversation
/

Create Sequence SDesk_Cod_Tckt_Status_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Code_Ticket_Status                      -- جدول حالات الطلب
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  nDays      Number(3) Default 1,                          -- الأيام التي يجب أن تنتهي بها هذه الحالة
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Color      Varchar2(10 Char),                            -- الترميز العشري للون
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cod_Tckt_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT SDesk_Cod_Tckt_Status_UK     UNIQUE      (Name),
  CONSTRAINT SDesk_Cod_Tckt_Status_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Cod_Tckt_Status_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cod_Tckt_Status_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cod_Tckt_Status For SDesk_Code_Ticket_Status
/

Create Sequence SDesk_Cod_SLA_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Code_SLA                                -- جدول تراميز أولوية الخدمات حسب الاتفاقيات
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Color      Varchar2(10 Char),                            -- الترميز العشري للون
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cod_SLA_PK        PRIMARY KEY (Id  ),
  CONSTRAINT SDesk_Cod_SLA_UK        UNIQUE      (Name),
  CONSTRAINT SDesk_Cod_SLA_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Cod_SLA_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cod_SLA_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cod_SLA For SDesk_Code_SLA
/

Create Sequence SDesk_Serv_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Service                                 -- جدول الخدمات
( Id          Number(5) NOT NULL,                          -- مفتاح رئيسي
  Status_Id   Number(1) Default 1,                         -- حالة الترميز
  Num         Varchar2(15 Char) NOT NULL,                  -- الرقم 
  Name        Varchar2(100 Char) NOT NULL,                 -- الاسم
  Description Varchar2(1024 Char),                         -- الغاية
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Serv_PK        PRIMARY KEY (Id  ),
  CONSTRAINT SDesk_Serv_Num_UK    UNIQUE      (Num ),
  CONSTRAINT SDesk_Serv_Nam_UK    UNIQUE      (Name),
  CONSTRAINT SDesk_Serv_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Serv_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Serv_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Serv For SDesk_Service
/

Create Sequence SDesk_Cat_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Categories                              -- جدول التصانيف الأساسية
( Id          Number(5) NOT NULL,                          -- مفتاح رئيسي
  Status_Id   Number(1) Default 1,                         -- الحالة فعالة/غير فعالة
  Num         Number(5) NOT NULL,                          -- الرقم
  Name        Varchar2(100 Char) NOT NULL,                 -- الاسم
  Description Varchar2(1024 Char),                         -- الوصف 
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cat_PK        PRIMARY KEY (Id  ),
  CONSTRAINT SDesk_Cat_Num_UK    UNIQUE      (Num),
  CONSTRAINT SDesk_Cat_Name_UK   UNIQUE      (Name),
  CONSTRAINT SDesk_Cat_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Cat_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cat_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cat For SDesk_Categories
/

Create Sequence SDesk_SubCat_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_SubCategories                           -- جدول التصانيف الفرعية
( Id          Number(5) NOT NULL,                          -- مفتاح رئيسي
  Cat_Id      Number(5) NOT NULL,                          -- التصنيف الأساسي
  Status_Id   Number(1) Default 1,                         -- حالة الترميز
  Num         Number(5) NOT NULL,                          -- الرقم
  Name        Varchar2(100 Char ) NOT NULL,                -- الاسم
  Description Varchar2(1024 Char),                         -- الوصف 
  Rem         Varchar2(100 Char ),                         -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  SDesk_SubCat_PK        PRIMARY KEY (Id),
  CONSTRAINT  SDesk_SubCat_Num_UK    UNIQUE      (Cat_Id, Num ),
  CONSTRAINT  SDesk_SubCat_Nam_UK    UNIQUE      (Cat_Id, Name),
  CONSTRAINT  SDesk_SubCat_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  SDesk_SubCat_Cat_FK    Foreign Key (Cat_Id   ) References SDesk_Cat     (Id),
  CONSTRAINT  SDesk_SubCat_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  SDesk_SubCat_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_SubCat For SDesk_SubCategories
/

Create Sequence SDesk_Cat_Serv_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Category_Service                        -- جدول تصنيف خدمة
( Id          Number(5) NOT NULL,                          -- مفتاح رئيسي
  Cat_Id      Number(5) NOT NULL,                          -- التصنيف الأساسي
  Serv_Id     Number(5) NOT NULL,                          -- الخدمة
  Status_Id   Number(1) Default 1,                         -- الحالة فعالة/غير فعالة
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cat_Serv_PK        PRIMARY KEY (Id),
  CONSTRAINT SDesk_Cat_Serv_UK        UNIQUE      (Serv_Id, Cat_Id),
  CONSTRAINT SDesk_Cat_Serv_Cat_FK    Foreign Key (Cat_Id   ) References SDesk_Cat     (Id),
  CONSTRAINT SDesk_Cat_Serv_Serv_FK   Foreign Key (Serv_Id  ) References SDesk_Serv    (Id),
  CONSTRAINT SDesk_Cat_Serv_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Cat_Serv_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cat_Serv_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cat_Serv For SDesk_Category_Service
/

Create Sequence SDesk_Cust_Serv_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Customer_Service                        -- جدول  خدمات زبون
( Id           Number(5) NOT NULL,                         -- مفتاح رئيسي
  Serv_Id      Number(5) NOT NULL,                         -- الخدمة
  Cont_Id      Number(9) NOT NULL,                         -- الزبون
  Status_Id    Number(1) Default 1,                        -- حالة
  SDate        Date Default sysdate NOT NULL,              -- تاريخ البداية
  EDate        Date NOT NULL,                              -- تاريخ النهاية
  RenewalDate  Date NOT NULL,                              -- تاريخ التجديد
  Description  Varchar2(1024 Char),                        -- الوصف
  Rem          Varchar2(100 Char),                         -- ملاحظات
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cust_Serv_PK         PRIMARY KEY (Id),
  CONSTRAINT SDesk_Cust_Serv_UK         UNIQUE      (Cont_Id, Serv_Id),
  CONSTRAINT SDesk_Cust_Serv_Serv_FK    Foreign Key (Serv_Id  ) References SDesk_Serv    (Id),
  CONSTRAINT SDesk_Cust_Serv_Cont_Id_FK Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT SDesk_Cust_Serv_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Cust_Serv_Ins_FK     Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cust_Serv_Upd_FK     Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cust_Serv For SDesk_Customer_Service
/

Create Sequence SDesk_Cust_User_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Customer_User                           -- جدول مستخدمين زبائن
( Id          Number(5) NOT NULL,                          -- مفتاح رئيسي
  User_Id     Number(5) NOT NULL,                          -- المستخدم
  Cont_Id     Number(9) NOT NULL,                          -- الزبون
  Status_Id   Number(1) Default 1,                         -- حالة  
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cust_User_User_PK   PRIMARY KEY (Id),
  CONSTRAINT SDesk_Cust_User_UK        UNIQUE      (Cont_Id, User_Id),
  CONSTRAINT SDesk_Cust_User_User_FK   Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cust_User_cont_FK   Foreign Key (Cont_Id  ) References Mng_Cont      (Id),
  CONSTRAINT SDesk_Cust_User_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Cust_User_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cust_User_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cust_User For SDesk_Customer_User
/

Create Sequence SDesk_Cust_SLA_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Customer_SLA                            -- جدول  اتفاقية مستوى الخدمة
( Id           Number(9) NOT NULL,                         -- مفتاح رئيسي
  Cont_Id      Number(9) NOT NULL,                         -- الزبون
  SDate        Date Default sysdate NOT NULL,              -- تاريخ البداية
  EDate        Date NOT NULL,                              -- تاريخ النهاية
  renewalDate  Date NOT NULL,                              -- تاريخ التجديد
  Rem          Varchar2(100 Char),                         -- ملاحظات
  Ins_User     Number(5), Ins_Date     Date,  
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cust_SLA_PK      PRIMARY KEY (Id),
  CONSTRAINT SDesk_Cust_SLA_cont_FK Foreign Key (Cont_Id ) References Mng_Cont(Id),
  CONSTRAINT SDesk_Cust_SLA_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT SDesk_Cust_SLA_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym SDesk_Cust_SLA For SDesk_Customer_SLA
/

Create Sequence SDesk_Cust_SLA_Mtrx_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Customer_SLA_Matrix                     -- جدول  المصفوفة الخاصة بزمن الاستجابة
( Id               Number(9) NOT NULL,                     -- مفتاح رئيسي
  Mst_Id           Number(9) NOT NULL,                     -- اتفاقية الزبون 
  SLA_Id           Number(5) NOT NULL,                     -- درجة الأولوية
  responseUnit_Id  Number(2) Default 1 NOT NULL,           --  الوحدة الزمنية لوقت الاستلام 
  restoreUnit_Id   Number(2) Default 1 NOT NULL,           -- الوحدة الزمنية لوقت الاستعادة 
  resolveUnit_Id   Number(2) Default 1 NOT NULL,           -- الوحدة الزمنية لوقت الحل والرجوع للوضع الطبيعي
  responseTime     Number(3) Default 0,                    --  الوقت الازم للاستجابة الأولى أي الاستلام
  restoreTime      Number(3) Default 0,                    -- work around الوقت اللازم للبدء بحل المشكلة 
  resolveTime      Number(3) Default 0,                    -- الوفت اللازم لإنهاء حل المشكلة وإعادة النظام لوضعه الطبيعي
  Description      Varchar2(4000 Char),                    -- الوصف
  Rem              Varchar2(100 Char),                     -- ملاحظات
  Ins_User         Number(5), Ins_Date     Date,  
  Upd_User         Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cust_SLA_Mtrx_PK          PRIMARY KEY (Id),
  CONSTRAINT SDesk_Cust_SLA_Mtrx_UK          UNIQUE      (Mst_Id, SLA_Id),
  CONSTRAINT SDesk_Cust_SLA_Mtrx_FK          Foreign Key (Mst_Id         ) References SDesk_Cust_SLA(Id),
  CONSTRAINT SDesk_Cust_SLA_Mtrx_SLA_FK      Foreign Key (SLA_Id         ) References SDesk_Cod_SLA (Id),
  CONSTRAINT SDesk_Cust_SLA_Mtrx_RespUnit_FK Foreign Key (responseUnit_Id) References SDesk_Cod_Unit(Id),
  CONSTRAINT SDesk_Cust_SLA_Mtrx_RestUnit_FK Foreign Key (restoreUnit_Id ) References SDesk_Cod_Unit(Id),
  CONSTRAINT SDesk_Cust_SLA_Mtrx_ResoUnitFK  Foreign Key (resolveUnit_Id ) References SDesk_Cod_Unit(Id),
  CONSTRAINT SDesk_Cust_SLA_Mtrx_Ins_FK      Foreign Key (Ins_User       ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cust_SLA_Mtrx_Upd_FK      Foreign Key (Upd_User       ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cust_SLA_Mtrx For SDesk_Customer_SLA_Matrix
/

Create Sequence SDesk_Cust_SLA_Serv_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Customer_SLA_Service                    -- جدول  خدمات اتفاقية زبون
( Id           Number(9) NOT NULL,                         -- مفتاح رئيسي
  Mst_Id       Number(9) NOT NULL,                         -- اتفاقية الزبون 
  Serv_Id      Number(5) NOT NULL,                         -- تاريخ النهاية
  Description  Varchar2(4000 Char),                        -- الوصف
  Rem          Varchar2(100 Char),                         -- ملاحظات
  Ins_User     Number(5), Ins_Date     Date,  
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cust_SLA_Serv_PK      PRIMARY KEY (Id),
  CONSTRAINT SDesk_Cust_SLA_Serv_UK      UNIQUE      (Mst_Id, Serv_Id),
  CONSTRAINT SDesk_Cust_SLA_Serv_Mst_FK  Foreign Key (Mst_Id  ) References SDesk_Cust_SLA(Id),
  CONSTRAINT SDesk_Cust_SLA_Serv_Serv_FK Foreign Key (Serv_Id ) References SDesk_Serv    (Id),
  CONSTRAINT SDesk_Cust_SLA_Serv_Ins_FK  Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT SDesk_Cust_SLA_Serv_Upd_FK  Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Cust_SLA_Serv For SDesk_Customer_SLA_Service
/

Create Sequence SDesk_Staff_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Staff_members                           -- دليل فريق الدعم
( Id          Number(5),                                   -- مفتاح رئيسي
  Status_Id   Number(5) Default 0,                         -- الحالة
  Emp_Id      Number(9) NOT NULL,                          -- الموظف
  User_Id     Number(20),                                  -- المستخدم المرتبط
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Staff_PK        Primary Key (Id),
  CONSTRAINT SDesk_Staff_Nam_UK    Unique      (Emp_Id, User_Id),
  CONSTRAINT SDesk_Staff_Emp_FK    Foreign Key (Emp_Id   ) References Emp_Emp       (Id),
  CONSTRAINT SDesk_Staff_User_FK   Foreign Key (User_Id  ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Staff_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Staff_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Staff_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Staff For SDesk_Staff_members
/

Create Sequence SDesk_Staff_Serv_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Staff_Service                           -- جدول  خدمات موظف
( Id           Number(5) NOT NULL,                         -- مفتاح رئيسي
  Serv_Id      Number(5) NOT NULL,                         -- الخدمة
  Staff_Id     Number(9) NOT NULL,                         -- الموظف  
  Status_Id    Number(1) Default 1,                        -- حالة
  Rem          Varchar2(100 Char),                         -- ملاحظات
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Staff_Serv_PK          PRIMARY KEY (Id),
  CONSTRAINT SDesk_Staff_Serv_UK          UNIQUE      (Staff_Id, Serv_Id),
  CONSTRAINT SDesk_Staff_Serv_Serv_FK     Foreign Key (Serv_Id  ) References SDesk_Serv    (Id),
  CONSTRAINT SDesk_Staff_Serv_customer_FK Foreign Key (Staff_Id ) References SDesk_Staff   (Id),
  CONSTRAINT SDesk_Staff_Serv_Status_FK   Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT SDesk_Staff_Serv_Ins_FK      Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT SDesk_Staff_Serv_Upd_FK      Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym SDesk_Staff_Serv For SDesk_Staff_Service
/

Create Sequence SDesk_Tckt_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Ticket                                  -- جدول الطلبات
( Id          Number(9) NOT NULL,                          -- مفتاح رئيسي
  Cont_Id     Number(9) NOT NULL,                          -- الزبون
  Serv_Id     Number(5) NOT NULL,                          -- الخدمة
  Cat_Id      Number(5) NOT NULL,                          -- التصنيف
  SubCate_Id  Number(5),                                   -- التصنيف الفرعي
  SLA_Id      Number(5) Default 1,                         -- SLA code
  SLA_Date    Date,                                        -- تاريخ اخر تعديل لل sla
  CUser_Id    Number(5) NOT NULL,                          -- موظف الزبون
  RUser_Id    Number(5),                                   -- موظف الدعم  الذي استلم الطلب
  RUser_Date  Date,                                        -- تاريخ استلام موظف الدعم 
  SUser_Id    Number(5),                                   -- الموظف المتابع
  SUser_Date  Date,                                        -- خر تاريخ لاستلام الموظف المتابع
  Status_Id   Number(1) Default 1,                         -- الحالة
  Status_Date Date Default Sysdate,                        -- تاريخ الحالة
  Subject     Varchar2(255 Char) NOT NULL,                 -- العنوان
  Description Varchar2(4000 Char),                         -- المشكلة سبب فتح الطلب
  dDate       Date Default Sysdate,                        -- تاريخ فتح الطلب
  SDate       Date Default Sysdate,                        -- تاريخ قبول الطلب
  EDate       Date,                                        -- تاريخ إنهاء الطلب
  Rem         Varchar2(250 Char),                          -- البيان
  Ins_User    Number(5), Ins_Date Date,
  Upd_User    Number(5), Upd_Date Date,
  CONSTRAINT  SDesk_Tckt_PK         PRIMARY KEY (Id),
  CONSTRAINT  SDesk_Tckt_Cont_FK    FOREIGN KEY (Cont_Id   ) References Mng_Cont             (Id),
  CONSTRAINT  SDesk_Tckt_Serv_FK    Foreign Key (Serv_Id   ) References SDesk_Serv           (Id),
  CONSTRAINT  SDesk_Tckt_Cat_FK     FOREIGN KEY (Cat_Id    ) References SDesk_Cat            (Id),
  CONSTRAINT  SDesk_Tckt_SubCate_FK FOREIGN KEY (SubCate_Id) References SDesk_SubCat         (Id),
  CONSTRAINT  SDesk_Tckt_SLA_FK     FOREIGN KEY (SLA_Id    ) References SDesk_Cod_SLA        (Id),
  CONSTRAINT  SDesk_Tckt_CUser_FK   Foreign Key (CUser_Id  ) References Cpy_User             (Id),
  CONSTRAINT  SDesk_Tckt_RUser_FK   FOREIGN KEY (RUser_Id  ) References Cpy_User             (Id),
  CONSTRAINT  SDesk_Tckt_SUser_FK   FOREIGN KEY (SUser_Id  ) References Cpy_User             (Id),
  CONSTRAINT  SDesk_Tckt_Status_FK  FOREIGN KEY (Status_Id ) References SDesk_Cod_Tckt_Status(Id),
  CONSTRAINT  SDesk_Tckt_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User             (Id),
  CONSTRAINT  SDesk_Tckt_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User             (Id)
)
/
Create Synonym SDesk_Tckt For SDesk_Ticket
/

Create Sequence SDesk_Tckt_Conv_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Ticket_Conversation                     -- جدول  المحادثة
( Id           Number(20) NOT NULL,                        -- مفتاح رئيسي
  Tckt_Id      Number(9) NOT NULL,                         -- الطلب                
  Type_Id      Number(2) Default 0,                        -- نوع بند المحادثة
  User_Id      Number(5) NOT NULL,                         -- المستخدم
  Side_Id      Number(2) NOT NULL,                         -- الجهة التي كتبت الرسالة الزبون /الموظف
  MsgDate      Date Default sysdate,                       -- تاريخ  الإرسال
  RecDate      Date,                                       -- تاريخ الاستقبال
  Msg          Varchar2(4000 Char),                        -- نص الرسالة
  Ins_User     Number(5), Ins_Date     Date,               -- تاريخ الإرسال
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Tckt_Conv_PK      PRIMARY KEY (Id),
  CONSTRAINT SDesk_Tckt_Conv_Tckt_FK Foreign Key (Tckt_Id ) References SDesk_Tckt         (Id),
  CONSTRAINT SDesk_Tckt_Type_FK      Foreign Key (Type_Id ) References SDesk_Cod_Conv_Type(Id),
  CONSTRAINT SDesk_Tckt_Conv_User_FK Foreign Key (User_Id ) References Cpy_User           (Id),
  CONSTRAINT SDesk_Tckt_Conv_Side_FK Foreign Key (Side_Id ) References SDesk_Cod_Side     (Id),
  CONSTRAINT SDesk_Tckt_Conv_Ins_FK  Foreign Key (Ins_User) References Cpy_User           (Id),
  CONSTRAINT SDesk_Tckt_Conv_Upd_FK  Foreign Key (Upd_User) References Cpy_User           (Id)
)  
/
Create Synonym SDesk_Tckt_Conv For SDesk_Ticket_Conversation
/

Create Sequence SDesk_Tckt_SLA_Chng_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Tickets_SLA_Changes                     -- جدول تبدل تغيير أولوية الطلب 
( Id          Number(9) NOT NULL,                          -- مفتاح رئيسي
  Tckt_Id     Number(9) Default 0,                         -- الطلب
  oSLA_Id     Number(5) Default 1,                         -- درجة  الأولوية القديمة
  nSLA_Id     Number(5) Default 1,                         -- درجة الأولوية الجديدة 
  Side_Id     Number(2) NOT NULL,                          -- الجهة التي قامت بالتعديل
  Conv_Id     Number(20),                                  -- المحادثة
  User_Id     Number(5),                                   -- موظف الدعم
  dDate       Date Default Sysdate,                        -- تاريخ  
  Reason      Varchar2(1024 Char),                         -- سبب التغيير
  Rem         Varchar2(512 Char),                          -- الملاحظات
  Ins_User    Number(5), Ins_Date     Date,                -- تاريخ التغيير
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  SDesk_Tckt_SLA_Chng_PK        PRIMARY KEY (Id),
  CONSTRAINT  SDesk_Tckt_SLA_Chng_Ticket_FK Foreign Key (Tckt_Id ) References SDesk_Tckt     (Id),
  CONSTRAINT  SDesk_Tckt_SLA_Chng_Conv_FK   Foreign Key (Conv_Id ) References SDesk_Tckt_Conv(Id),
  CONSTRAINT  SDesk_Tckt_SLA_Chng_oSLA_FK   Foreign Key (oSLA_Id ) References SDesk_Cod_SLA  (Id),
  CONSTRAINT  SDesk_Tckt_SLA_Chng_nSLA_FK   Foreign Key (nSLA_Id ) References SDesk_Cod_SLA  (Id),
  CONSTRAINT  SDesk_Tckt_SLA_Chng_User_FK   Foreign Key (User_Id ) References Cpy_User       (Id),
  CONSTRAINT  SDesk_Tckt_SLA_Chng_Side_FK   Foreign Key (Side_Id ) References SDesk_Cod_Side (Id),
  CONSTRAINT  SDesk_Tckt_SLA_Chng_Ins_FK    Foreign Key (Ins_User) References Cpy_User       (Id),
  CONSTRAINT  SDesk_Tckt_SLA_Chng_Upd_FK    Foreign Key (Upd_User) References Cpy_User       (Id)
)
/
Create Synonym SDesk_Tckt_SLA_Chng For SDesk_Tickets_SLA_Changes
/

Create Sequence SDesk_Tckt_User_Chng_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Tickets_User_Changes                    -- جدول تبدل تغيير أولوية الطلب 
( Id           Number(9) NOT NULL,                         -- مفتاح رئيسي
  Tckt_Id      Number(9) NOT NULL,                         -- الطلب
  Conv_Id      Number(20),                                 -- المحادثة
  oUser_Id     Number(5),                                  -- المستخدم القديم
  nUser_Id     Number(5),                                  -- المستخدم الجديد
  User_Id      Number(5),                                  -- موظف الدعم
  dDate        Date Default Sysdate,                       -- تاريخ  
  reason       Varchar2(1024 Char),                        -- سبب التغيير
  Rem          Varchar2(512 Char),                         -- الملاحظات
  Ins_User     Number(5), Ins_Date     Date,               -- تاريخ التغيير
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT   SDesk_Tckt_User_Chng_PK       PRIMARY KEY (Id),
  CONSTRAINT   SDesk_Tckt_User_Chng_Conv_FK  Foreign Key (Conv_Id ) References SDesk_Tckt_Conv(Id),
  CONSTRAINT   SDesk_Tckt_User_Chng_Tckt_FK  Foreign Key (Tckt_Id ) References SDesk_Tckt     (Id),
  CONSTRAINT   SDesk_Tckt_User_Chng_oUser_FK Foreign Key (oUser_Id) References Cpy_User       (Id),
  CONSTRAINT   SDesk_Tckt_User_Chng_nUser_FK Foreign Key (nUser_Id) References Cpy_User       (Id),
  CONSTRAINT   SDesk_Tckt_User_Chng_User_FK  Foreign Key (User_Id ) References Cpy_User       (Id),
  CONSTRAINT   SDesk_Tckt_User_Chng_Ins_FK   Foreign Key (Ins_User) References Cpy_User       (Id),
  CONSTRAINT   SDesk_Tckt_User_Chng_Upd_FK   Foreign Key (Upd_User) References Cpy_User       (Id)
)
/
Create Synonym SDesk_Tckt_User_Chng For SDesk_Tickets_User_Changes
/

Create Sequence SDesk_Tckt_Chng_Status_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Ticket_Change_Status                    -- جدول تبدل حالات طلب
( Id           Number(9) NOT NULL,                         -- مفتاح رئيسي
  Tckt_Id      Number(5) NOT NULL,                         -- الطلب
  Conv_Id      Number(20),                                 -- المحادثة
  oStatus_Id   Number(5) NOT NULL,                         -- الحالة
  oStatus_Date Date Default Sysdate,                       -- تاريخ الحالة
  oUser_Id     Number(5),                                  -- الموظف 
  nStatus_Id   Number(5) NOT NULL,                         -- الحالة
  nStatus_Date Date Default Sysdate,                       -- تاريخ الحالة
  nUser_Id     Number(5),                                  -- الموظف 
  nDays        Number(3) Default 1,                        -- الأيام التي يجب أن تنتهي بها هذه الحالة
  Rem          Varchar2(512 Char),                         -- الملاحظات
  Ins_User     Number(5), Ins_Date     Date,
  Upd_User     Number(5), Upd_Date     Date,
  CONSTRAINT   SDesk_Tckt_Chng_Status_PK          PRIMARY KEY (Id),
  CONSTRAINT   SDesk_Tckt_Chng_Status_Tckt_FK     Foreign Key (Tckt_Id   ) References SDesk_Tckt           (Id),
  CONSTRAINT   SDesk_Tckt_Chng_Status_oStatus_FK  Foreign Key (oStatus_Id) References SDesk_Cod_Tckt_Status(Id),
  CONSTRAINT   SDesk_Tckt_Chng_Status_oUser_FK    Foreign Key (oUser_Id  ) References Cpy_User             (Id),
  CONSTRAINT   SDesk_Tckt_Chng_Status_nStatus_FK  Foreign Key (nStatus_Id) References SDesk_Cod_Tckt_Status(Id),
  CONSTRAINT   SDesk_Tckt_Chng_Status_nUser_FK    Foreign Key (nUser_Id  ) References Cpy_User             (Id),
  CONSTRAINT   SDesk_Tckt_Chng_Status_Conv_Fk     Foreign Key (Conv_Id   ) References SDesk_Tckt_Conv      (Id),
  CONSTRAINT   SDesk_Tckt_Chng_Status_Ins_FK      Foreign Key (Ins_User  ) References Cpy_User             (Id),
  CONSTRAINT   SDesk_Tckt_Chng_Status_Upd_FK      Foreign Key (Upd_User  ) References Cpy_User             (Id)
)
/
Create Synonym SDesk_Tckt_Chng_Status For SDesk_Ticket_Change_Status
/

Create Sequence SDesk_Attach_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Attached_Files                          -- الملفات المرفقة
( Id         Number(20) NOT NULL,                          -- مفتاح رئيسي
  FDate      Date NOT NULL,                                -- التاريخ و الوقت
  Conv_Id    Number(20) NOT NULL,                          -- المحادثة
  User_Id    Number(5),                                    -- المستخدم
  Ext        Varchar2(50 Char),                            -- امتداد الملف
  OName      Varchar2(100 Char),                           -- الاسم الأصلي
  NName      Varchar2(100 Char),                           -- الاسم الجديد مع المسار
  Rem        Varchar2(250 Char),                           -- البيان
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT SDesk_Attach_PK      PRIMARY KEY (Id),
  CONSTRAINT SDesk_Attach_User_Fk Foreign Key (User_Id ) References Cpy_User       (Id),
  CONSTRAINT SDesk_Attach_Conv_Fk Foreign Key (Conv_Id ) References SDesk_Tckt_Conv(Id),
  CONSTRAINT SDesk_Attach_Ins_FK  Foreign Key (Ins_User) References Cpy_User       (Id),
  CONSTRAINT SDesk_Attach_Upd_FK  Foreign Key (Upd_User) References Cpy_User       (Id)
)
/
Create Synonym SDesk_Attach For SDesk_Attached_Files
/

Create Sequence SDesk_Cust_Rate_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table SDesk_Customer_Rating                         -- جدول  تقييم الزبون للخدمة
( Id         Number(9) NOT NULL,                           -- مفتاح رئيسي
  Tckt_Id    Number(9) Default 0,                          -- الطلب                  
  User_Id    Number(5) NOT NULL,                           -- الزبون
  Rate_Id    Number(2) NOT NULL,                           -- درجة التقييم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT SDesk_Cust_Rate_PK      PRIMARY KEY (Id),
  CONSTRAINT SDesk_Cust_Rate_UK      UNIQUE      (Tckt_Id, Rate_Id),
  CONSTRAINT SDesk_Cust_Rate_Tckt_FK Foreign Key (Tckt_Id ) References SDesk_Tckt      (Id),
  CONSTRAINT SDesk_Cust_Rate_User_FK Foreign Key (User_Id ) References Cpy_User        (Id),
  CONSTRAINT SDesk_Cust_Rate_Rate_FK Foreign Key (Rate_Id ) References SDesk_Cod_Rating(Id),
  CONSTRAINT SDesk_Cust_Rate_Ins_FK  Foreign Key (Ins_User) References Cpy_User        (Id),
  CONSTRAINT SDesk_Cust_Rate_Upd_FK  Foreign Key (Upd_User) References Cpy_User        (Id)
)
/
Create Synonym SDesk_Cust_Rate For SDesk_Customer_Rating
/
