--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'FRE%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'FRE%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'FRE%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'FRE%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'FRE%' ;
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_KDocType_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_KDocType                         -- جدول ترميز أنواع الوثيقة المرتبطة
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_KDocType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_KDocType_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_KDocType_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_KDocType_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_KDocType_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_KDocType For Fre_Code_KDocType
/
INSERT INTO Fre_Cod_KDocType (Id, Name) VALUES (0, '-');  
---------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_IDocType_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_IDocType                         -- جدول ترميز نوع الوثيقة المرتبطة IN Transport Mode
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_IDocType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_IDocType_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_IDocType_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_IDocType_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_IDocType_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_IDocType For Fre_Code_IDocType
/
INSERT INTO Fre_Cod_IDocType (Id, Name) VALUES (0, '-');
---------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_ODocType_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_ODocType                         -- جدول ترميز نوع الوثيقة المرتبطة IN Transport Mode
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_ODocType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_ODocType_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_ODocType_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_ODocType_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_ODocType_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_ODocType For Fre_Code_ODocType
/
INSERT INTO Fre_Cod_ODocType (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Track_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Track                           -- جدول ترميز Track Palet Number Main
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Track_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Track_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Track_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_Track_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_Track_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_Track For Fre_Code_Track
/
INSERT INTO Fre_Cod_Track (Id, Name) VALUES (0, '-');
---------------------------------------------------------------------------------------------------
Create Table Fre_Code_Operations_Status    				         -- جدول ترميز حالات العمليات
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Fre_Cod_Oper_Status_PK PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Oper_Status_UK UNIQUE      (Name)
)
/
Create Synonym Fre_Cod_Oper_Status For Fre_Code_Operations_Status
/
Insert into Fre_Cod_Oper_Status (Id,Name) values (1,'Yes');
Insert into Fre_Cod_Oper_Status (Id,Name) values (2,'No');
---------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_TLType_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_TLType                          -- جدول ترميز TL
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_TLType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_TLType_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_TLType_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_TLType_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_TLType_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_TLType For Fre_Code_TLType
/
INSERT INTO Fre_Cod_TLType (Id, Name) VALUES (0, '-');
---------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_CLType_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_CLType                          -- جدول ترميز CL
( Id         Number(5) NOT NULL,                      -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                     -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,             -- الاسم
  Rem        Varchar2(100 Char),                      -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_CLType_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_CLType_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_CLType_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_CLType_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_CLType_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_CLType For Fre_Code_CLType
/
INSERT INTO Fre_Cod_CLType (Id, Name) VALUES (0, '-');
---------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Shipline_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Shiplines                            -- جدول خطوط النقل
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(250 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Shipline_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Shipline_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Shipline_FK     Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Shipline_Ins_FK Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Shipline_Upd_FK Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Shipline For Fre_Code_Shiplines
/
Insert Into Fre_Cod_Shipline (Id,Name) Values(0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Airline_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Airlines                             -- جدول شركات الطيران
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(250 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Airline_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Airline_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Airline_FK     Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Airline_Ins_FK Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Airline_Upd_FK Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Airline For Fre_Code_Airlines
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Roadline_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Roadlines                            -- جدول خطوط النقل البري
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(250 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Roadline_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Roadline_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Roadline_FK     Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Roadline_Ins_FK Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Roadline_Upd_FK Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Roadline For Fre_Code_Roadlines
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Cntry_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Country                                  -- جدول البلدان
( Id             Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id      Number(1) Default 1,                          -- حالة الترميز
  Code           Varchar2(3 Char) NOT NULL,                    -- الترميز
  Name           Varchar2(250 Char) NOT NULL,                  -- الاسم
  Phone          Number(5) NOT NULL,                           -- رمز الهاتف
  Symbol         Varchar2(10 Char),                            -- الرمز
  Capital        Varchar2(100),                                -- Capital العاصمة
  Currency       Varchar2(3),                                  -- Currency العملة
  Continent      Varchar2(30),                                 -- Continent - القارة
  Continent_Code varchar2(2),                                  -- Continent Code - رمز القارة
  Alpha_3        Varchar2(3),                                  -- Code 3 - الرمز الثالث
  Rem            Varchar2(100 Char),                           -- ملاحظات
  Ins_User       Number(5), Ins_Date     Date,
  Upd_User       Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Cntry_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Cntry_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Cntry_FK     Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Cntry_Ins_FK Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Cntry_Upd_FK Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Cntry For Fre_Code_Country
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_AirPort_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_AirPorts                             -- جدول المطارات
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Cntry_Id   Number(5) Default 1,                          -- البلد
  Code       Varchar2(10 Char) NOT NULL,                   -- الترميز
  Name       Varchar2(250 Char) NOT NULL,                  -- الاسم
  RCode      Varchar2(10 Char),                            -- الترميز المقابل
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_AirPort_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_AirPort_UK        UNIQUE      (Cntry_Id, Code),
  CONSTRAINT Fre_Cod_AirPort_FK        Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_AirPort_Cntry_FK  Foreign Key (Cntry_Id ) References Fre_Cod_Cntry (Id),
  CONSTRAINT Fre_Cod_AirPort_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_AirPort_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_AirPort For Fre_Code_AirPorts
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_City_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_City                                 -- جدول المدن
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Cntry_Id   Number(5) Default 1,                          -- البلد
  Code       Varchar2(10 Char) NOT NULL,                   -- الترميز
  Name       Varchar2(250 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_City_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_City_UK        UNIQUE      (Cntry_Id, Code),
  CONSTRAINT Fre_Cod_City_FK        Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_City_Cntry_FK  Foreign Key (Cntry_Id ) References Fre_Cod_Cntry (Id),
  CONSTRAINT Fre_Cod_City_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_City_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_City For Fre_Code_City
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Lang_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Language                             -- جدول اللغات
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Cntry_Id   Number(5) Default 1,                          -- البلديز
  Code       Varchar2(5 Char) NOT NULL,                    -- الرمز
  Name       Varchar2(250 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Lang_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Lang_UK        UNIQUE      (Cntry_Id, Code),
  CONSTRAINT Fre_Cod_Lang_FK        Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_Lang_Cntry_FK  Foreign Key (Cntry_Id ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_Lang_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_Lang For Fre_Code_Language
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Nat_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Nationality                          -- جدول الجنسيات
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Cntry_Id   Number(5) Default 1,                          -- البلد
  Code       Varchar2(10 Char) NOT NULL,                   -- الترميز
  Code3      Varchar2(10 Char) NOT NULL,                   -- الترميز
  Name       Varchar2(250 Char) NOT NULL,                  -- الاسم
  Cntry_Name Varchar2(250 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Nat_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Nat_UK        UNIQUE      (Cntry_Id, Code),
  CONSTRAINT Fre_Cod_Nat_FK        Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_Nat_Cntry_FK  Foreign Key (Cntry_Id ) References Fre_Cod_Cntry (Id),
  CONSTRAINT Fre_Cod_Nat_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_Nat_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_Nat For Fre_Code_Nationality
/
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_SeaPort_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Seaports                             -- جدول الموانئ
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Cntry_Id   Number(5) Default 1,                          -- البلد
  Code       Varchar2(10 Char) NOT NULL,                   -- الترميز
  Name       Varchar2(250 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_SeaPort_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_SeaPort_UK        UNIQUE      (Cntry_Id, Code),
  CONSTRAINT Fre_Cod_SeaPort_FK        Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_SeaPort_Cntry_FK  Foreign Key (Cntry_Id ) References Fre_Cod_Cntry (Id),
  CONSTRAINT Fre_Cod_SeaPort_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_SeaPort_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_SeaPort For Fre_Code_Seaports
/
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_Module_Type 		                     -- جدول ترميز حالة تفسير نوع الحالة
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Fre_Cod_Module_Type_PK PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Module_Type_UK UNIQUE      (Name)
)
/
Create Synonym Fre_Cod_Module_Type For Fre_Code_Module_Type
/
Insert into Fre_Cod_Module_Type (Id,Name) values (0,'-');
Insert into Fre_Cod_Module_Type (Id,Name) values (1,'جوي');
Insert into Fre_Cod_Module_Type (Id,Name) values (2,'بري');
Insert into Fre_Cod_Module_Type (Id,Name) values (3,'بحري');
----------------------------------------------------------------------------------------------------
Create Table Fre_code_contract_Kind                        -- أنواع بنود العقود
( Id         Number(2) NOT NULL,                           -- PK
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Fre_Cod_Contract_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Contract_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Contract_FK     Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Contract_Ins_FK Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Contract_Upd_FK Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Contr_Kind For Fre_code_contract_Kind
/
Insert into Fre_Cod_Contr_Kind (Id,Name) values (0,'-'          );
Insert into Fre_Cod_Contr_Kind (Id,Name) values (1,'Shipping'   );
Insert into Fre_Cod_Contr_Kind (Id,Name) values (2,'Demurrage'  );
Insert into Fre_Cod_Contr_Kind (Id,Name) values (3,'Cancelation');
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_Container_Load_Type                  -- جدول نوع تعبئة الحاوية
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_CL_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_CL_Type_UK        UNIQUE      (Name),
  CONSTRAINT Fre_Cod_CL_Type_FK        Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_CL_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_CL_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_CL_Type For Fre_Code_Container_Load_Type
/
Insert into Fre_Cod_CL_Type (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_Truck_Load_Type                      -- جدول نوع تعبئة السيارات
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_TL_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_TL_Type_UK        UNIQUE      (Name),
  CONSTRAINT Fre_Cod_TL_Type_FK        Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_TL_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_TL_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_TL_Type For Fre_Code_Truck_Load_Type
/
Insert into Fre_Cod_TL_Type (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_Truck_Type                           -- جدول أنواع السيارات
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Truck_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Truck_Type_UK        UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Truck_Type_FK        Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Truck_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Truck_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Truck_Type For Fre_Code_Truck_Type
/
Insert into Fre_Cod_Truck_Type (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_Type                                 -- جدول أنواع بنود العقود
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Type_UK        UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Type_FK        Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Type_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Type_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Type For Fre_Code_Type
/
Insert into Fre_Cod_Type (Id,Name) values (1,'Demurrage'          ); -- غرامة التأخير
Insert into Fre_Cod_Type (Id,Name) values (2,'Load'               ); -- التحميل
Insert into Fre_Cod_Type (Id,Name) values (3,'Offload'            ); -- التفريغ
Insert into Fre_Cod_Type (Id,Name) values (4,'Overload'           ); -- الحمل الزائد
Insert into Fre_Cod_Type (Id,Name) values (5,'Cooling'            ); -- التبريد
Insert into Fre_Cod_Type (Id,Name) values (6,'Cancel'             ); -- الإلغاء
Insert into Fre_Cod_Type (Id,Name) values (7,'Additional Distance'); -- مسافة زائدة
Insert into Fre_Cod_Type (Id,Name) values (8,'Transport'          ); -- النقل
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_Kind                                 -- جدول أنواع السائقين
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Kind_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Kind_UK        UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Kind_FK        Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Kind_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Kind_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Kind  For Fre_Code_Kind
/
Insert into Fre_Cod_Kind (Id,Name) values (1,'Driver'   );
Insert into Fre_Cod_Kind (Id,Name) values (2,'Assistant');
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_List                                 -- جدول القوائم
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_List_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_List_UK        UNIQUE      (Name),
  CONSTRAINT Fre_Cod_List_FK        Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_List_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_List_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_List  For Fre_Code_List
/
Insert into Fre_Cod_List (Id,Name) values (0,'Normal'    );
Insert into Fre_Cod_List (Id,Name) values (1,'White List');
Insert into Fre_Cod_List (Id,Name) values (2,'Black List');
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_Location                             -- جدول ترميز مكان التنفيذ
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Loc_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Loc_UK        UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Loc_FK        Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Loc_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Loc_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Loc  For Fre_Code_Location
/
Insert into Fre_Cod_Loc (Id,Name) values (1,'Origin');
Insert into Fre_Cod_Loc (Id,Name) values (2,'Shipping');
Insert into Fre_Cod_Loc (Id,Name) values (3,'Destination');
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Inco_Term_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Inco_Term                            -- جدول أنواع Inco Terms
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Inco_Term_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Inco_Term_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Inco_Term_FK     Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Inco_Term_Ins_FK Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Inco_Term_Upd_FK Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Inco_Term For Fre_Code_Inco_Term
/
Insert into Fre_Cod_Inco_Term (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Pay_Term_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Payment_Term                         -- جدول أنواع Payment Terms
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Pay_Term_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Pay_Term_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Pay_Term_FK     Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Pay_Term_Ins_FK Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Pay_Term_Upd_FK Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Pay_Term For Fre_Code_Payment_Term
/
Insert into Fre_Cod_Pay_Term (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Comod_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Commodity                            -- جدول أنواع البضائع
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Comod_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Comod_UK        UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Comod_FK        Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Comod_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Comod_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Comod For Fre_Code_Commodity
/
Insert into Fre_Cod_Comod (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Pack_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Pack                                 -- جدول أنواع التغليف
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Pack_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Pack_UK        UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Pack_FK        Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Fre_Cod_Pack_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Fre_Cod_Pack_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Fre_Cod_Pack For Fre_Code_Pack
/
Insert into Fre_Cod_Pack (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_Job_Status 		                       -- جدول ترميز حالة ملف العمل
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Fre_Cod_Job_Status_PK PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Job_Status_UK UNIQUE      (Name)
)
/
Create Synonym Fre_Cod_Job_Status For Fre_Code_Job_Status
/
Insert into Fre_Cod_Job_Status (Id,Name) values (1,'In Process');
Insert into Fre_Cod_Job_Status (Id,Name) values (2,'Ready For Finance');
Insert into Fre_Cod_Job_Status (Id,Name) values (3,'Closed');
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_Approve_Status 		                   -- جدول ترميز حالة الموافقة
( Id         Number(2) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Fre_Cod_Approve_PK PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Approve_UK UNIQUE      (Name)
)
/
Create Synonym Fre_Cod_Approve For Fre_Code_Approve_Status
/
Insert into Fre_Cod_Approve (Id,Name) values (0,'New');
Insert into Fre_Cod_Approve (Id,Name) values (1,'Approved');
Insert into Fre_Cod_Approve (Id,Name) values (2,'Rejected');
----------------------------------------------------------------------------------------------------
Create Sequence Fre_Cod_Status_Type_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Code_Status_Type 		                     -- جدول ترميز حالة تفسير نوع الحالة
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  CONSTRAINT Fre_Cod_Status_Type_PK PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Status_Type_UK UNIQUE      (Name)
)
/
Create Synonym Fre_Cod_Status_Type For Fre_Code_Status_Type
/
Insert into Fre_Cod_Status_Type (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Table Fre_Code_Trt                                  -- جدول ترميز أنواع الحركات
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Fre_Cod_Trt_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Fre_Cod_Trt_UK     UNIQUE      (Name),
  CONSTRAINT Fre_Cod_Trt_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Fre_Cod_Trt_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Fre_Cod_Trt_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Fre_Cod_Trt For Fre_Code_Trt
/
INSERT INTO Fre_Cod_Trt (Id, Name, Rem) VALUES (0 , '-'   , '-');
INSERT INTO Fre_Cod_Trt (Id, Name, Rem) VALUES (11, 'Inv' , 'Invoice');
INSERT INTO Fre_Cod_Trt (Id, Name, Rem) VALUES (12, 'Dbt' , 'Debit Note');
INSERT INTO Fre_Cod_Trt (Id, Name, Rem) VALUES (21, 'Crd' , 'Credit Note');
INSERT INTO Fre_Cod_Trt (Id, Name, Rem) VALUES (22, 'Exp' , 'Expense Note');
