--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'CLNC%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'CLNC%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'CLNC%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'CLNC%' ;
--select 'Drop '         || OBJECT_TYPE   || ' ' || Object_name || ';' from user_Objects   where Object_name   like 'CLNC%' ;
----------------------------------------------------------------------------------------------------
CREATE TABLE Clnc_WorkTimes                                                                        -- جدول ساعات الدوام
( Id         Number(3) NOT NULL,                                                                   -- PK
  nHour      Number(3) DEfault 0 NOT NULL,                                                         -- Hour
  nMinute    Number(3) DEfault 0 NOT NULL,                                                         -- Minute
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Clnc_WorkTime_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_WorkTime_Ins_FK Foreign Key (Ins_User ) References Cpy_User(Id),
  CONSTRAINT Clnc_WorkTime_Upd_FK Foreign Key (Upd_User ) References Cpy_User(Id)
)
/
Create Synonym Clnc_WorkTime For Clnc_WorkTimes
/
----------------------------------------------------------------------------------------------------
CREATE TABLE Clnc_Code_Vat                                                                         -- جدول ترميز الVAT
( Id         Number(1) NOT NULL,				                                                           -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				                                                   -- الاسم
  Rem        Varchar2(100 Char),          				                                                 -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Clnc_Cod_Vat_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_Cod_Vat_UK     UNIQUE      (Name),
  CONSTRAINT Clnc_Cod_Vat_Ins_FK Foreign Key (Ins_User ) References Cpy_User(Id),
  CONSTRAINT Clnc_Cod_Vat_Upd_FK Foreign Key (Upd_User ) References Cpy_User(Id)
)
/
Create Synonym Clnc_Cod_Vat For Clnc_Code_Vat
/
Insert into Clnc_Cod_Vat (Id,Name) values (0,'-'      );
Insert into Clnc_Cod_Vat (Id,Name) values (1,'Percent');
Insert into Clnc_Cod_Vat (Id,Name) values (2,'Amount' );
----------------------------------------------------------------------------------------------------
CREATE TABLE Clnc_Code_Discount                                                                    -- جدول ترميز الحسم
( Id         Number(1) NOT NULL,				                                                           -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				                                                   -- الاسم
  Rem        Varchar2(100 Char),          				                                                 -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Clnc_Cod_Disc_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_Cod_Disc_UK     UNIQUE      (Name),
  CONSTRAINT Clnc_Cod_Disc_Ins_FK Foreign Key (Ins_User ) References Cpy_User(Id),
  CONSTRAINT Clnc_Cod_Disc_Upd_FK Foreign Key (Upd_User ) References Cpy_User(Id)
)
/
Create Synonym Clnc_Cod_Disc For Clnc_Code_Discount
/
Insert into Clnc_Cod_Disc (Id,Name) values (0,'-'      );
Insert into Clnc_Cod_Disc (Id,Name) values (1,'Percent');
Insert into Clnc_Cod_Disc (Id,Name) values (2,'Amount' );
----------------------------------------------------------------------------------------------------
CREATE TABLE Clnc_Payment_Type                                                                     -- جدول طرق الدفع
( Id         Number(1) NOT NULL,				                                                           -- مفتاح رئيسي
  Name       Varchar2(100 Char) NOT NULL,				                                                   -- الاسم
  Rem        Varchar2(100 Char),          				                                                 -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Clnc_Pay_Type_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_Pay_Type_UK     UNIQUE      (Name),
  CONSTRAINT Clnc_Pay_Type_Ins_FK Foreign Key (Ins_User ) References Cpy_User(Id),
  CONSTRAINT Clnc_Pay_Type_Upd_FK Foreign Key (Upd_User ) References Cpy_User(Id)
)
/
Create Synonym Clnc_Pay_Type For Clnc_Payment_Type
/
Insert into Clnc_Pay_Type (Id,Name) values (0,'-'   );
Insert into Clnc_Pay_Type (Id,Name) values (1,'Cash');
----------------------------------------------------------------------------------------------------
CREATE TABLE Clnc_Appointment_Status                                                               -- جدول حالات المواعيد
( Id         Number(2) NOT NULL,                                                                   -- PK
  Name       Varchar2(100 Char) NOT NULL,                                                          -- Name
  BG         Varchar2(10 Char) DEFAULT '#CCC' NOT NULL,                                            -- Title Background Color
  FG         Varchar2(10 Char) DEFAULT '#000' NOT NULL,                                            -- Title Text Color
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_App_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_App_Status_UK     UNIQUE      (Name),
  CONSTRAINT Clnc_App_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Clnc_App_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Clnc_App_Status For Clnc_Appointment_Status
/
Insert into Clnc_App_Status (Id,Name,BG,FG) values (0,'New','#CCC','#000');
Insert into Clnc_App_Status (Id,Name,BG,FG) values (1,'Waiting','#CCC','#000');
Insert into Clnc_App_Status (Id,Name,BG,FG) values (2,'Progress','#CCC','#000');
Insert into Clnc_App_Status (Id,Name,BG,FG) values (3,'Done','#CCC','#000');
Insert into Clnc_App_Status (Id,Name,BG,FG) values (4,'Late','#CCC','#000');
Insert into Clnc_App_Status (Id,Name,BG,FG) values (5,'No Show','#CCC','#000');
----------------------------------------------------------------------------------------------------
CREATE TABLE Clnc_Treatment_Status                                                                 -- جدول حالات المعالجة
( Id         Number(2) NOT NULL,                                                                   -- PK
  Name       Varchar2(100 Char) NOT NULL,                                                          -- Name
  BG         Varchar2(10 Char) DEFAULT '#CCC' NOT NULL,                                            -- Title Background Color
  FG         Varchar2(10 Char) DEFAULT '#000' NOT NULL,                                            -- Title Text Color
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Treat_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_Treat_Status_UK     UNIQUE      (Name),
  CONSTRAINT Clnc_Treat_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Clnc_Treat_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Clnc_Treat_Status For Clnc_Treatment_Status
/
Insert into Clnc_Treat_Status (Id,Name,BG,FG) values (0,'New','#CCC','#000');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_List_Seq MINVALUE 1 START WITH 1 MAXVALUE 999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Lists                                                                            -- جدول قوائم المرضى
( Id         Number(5) NOT NULL,                                                                   -- PK
  Name       Varchar2(100 Char) NOT NULL,                                                          -- Name
  Color      Varchar2(10 Char) DEFAULT '#FFFFFF00' NOT NULL,                                       -- Color
  Rem        Varchar2(100 Char),          				                                                 -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_List_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_List_UK     UNIQUE      (Name),
  CONSTRAINT Clnc_List_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Clnc_List_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Clnc_List For Clnc_Lists
/
Insert into Clnc_List (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Cod_Shift_Seq MINVALUE 1 START WITH 1 MAXVALUE 999 INCREMENT BY 1 CACHE 2;
Create Table Clnc_Code_Shift                                                                       -- جدول ترميز الورديات
( Id         Number(3) NOT NULL,				                                                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                                                           -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				                                                   -- الاسم
  Rem        Varchar2(100 Char),          				                                                 -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Clnc_Cod_Shift_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_Cod_Shift_UK        UNIQUE      (Name),
  CONSTRAINT Clnc_Cod_Shift_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Clnc_Cod_Shift_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Clnc_Cod_Shift_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Clnc_Cod_Shift For Clnc_Code_Shift
/
Insert into Clnc_Cod_Shift (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Cod_Nat_Seq MINVALUE 1 START WITH 1 MAXVALUE 999 INCREMENT BY 1 CACHE 2;
Create Table Clnc_Code_Nationality                                                                 -- جدول ترميز الجنسيات
( Id         Number(3) NOT NULL,				                                                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                                                           -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				                                                   -- الاسم
  Rem        Varchar2(100 Char),          				                                                 -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Clnc_Cod_Nat_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_Cod_Nat_UK        UNIQUE      (Name),
  CONSTRAINT Clnc_Cod_Nat_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Clnc_Cod_Nat_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Clnc_Cod_Nat_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Clnc_Cod_Nat For Clnc_Code_Nationality
/
Insert into Clnc_Cod_Nat (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Special_Seq MINVALUE 1 START WITH 1 MAXVALUE 999 INCREMENT BY 1 CACHE 2;
Create Table Clnc_Specials                                                                         -- جدول الاختصاصات
( Id         Number(3) NOT NULL,				                                                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                                                           -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				                                                   -- الاسم
  Rem        Varchar2(100 Char),          				                                                 -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Clnc_Special_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_Special_UK        UNIQUE      (Name),
  CONSTRAINT Clnc_Special_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Clnc_Special_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Clnc_Special_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Clnc_Special For Clnc_Specials
/
Insert into Clnc_Special (Id,Name) values (0,'ALL');
Insert into Clnc_Special (Id,Name) values (1,'Dental');
Insert into Clnc_Special (Id,Name) values (2,'Ophthalmology');
Insert into Clnc_Special (Id,Name) values (3,'Laser');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Cat_Seq MINVALUE 1 START WITH 1 MAXVALUE 999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Category                                                                         -- جدزل فئات الإجراءات
( Id         Number(3) NOT NULL,                                                                   -- PK
  Status_Id  Number(1) Default 1,				                                                           -- حالة الترميز
  Special_Id Number(5) DEFAULT 0 NOT NULL,                                                         -- Speciality
  Name       Varchar2(100 Char) NOT NULL,				                                                   -- الاسم
  Rem        Varchar2(100 Char),          				                                                 -- ملاحظات
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Cat_PK         PRIMARY KEY (Id), 
  CONSTRAINT Clnc_Cat_UK         UNIQUE      (Name), 
  CONSTRAINT Clnc_Cat_Status_FK  Foreign Key (Status_Id ) References Phs_Cod_Status(Id),
  CONSTRAINT Clnc_Cat_Special_FK Foreign Key (Special_Id) References Clnc_Special  (Id),
  CONSTRAINT Clnc_Cat_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User      (Id),
  CONSTRAINT Clnc_Cat_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User      (Id)
)
/
Create Synonym Clnc_Cat For Clnc_Category
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Proc_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Procedures                                                                       -- جدول الإجراءات
( Id       Number(5) NOT NULL,                                                                     -- PK
  Cat_Id   Number(3) NOT NULL,                                                                     -- Category
  Vat_Id   Number(3) DEFAULT 0 NOT NULL,                                                           -- Vat Type
  Code     Varchar2(10 Char) NOT NULL,                                                             -- Code
  Name     Varchar2(100 Char) NOT NULL,                                                            -- Name
  Price    Number(25,3) DEFAULT 0 NOT NULL,                                                        -- Price
  Vat      Number(25,3) DEFAULT 0 NOT NULL,                                                        -- Vat Percent/Amount
  Ins_User Number(5), Ins_Date   Date,
  Upd_User Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Proc_PK     PRIMARY KEY (Id),
  CONSTRAINT Clnc_Proc_UK     UNIQUE      (Code),
  CONSTRAINT Clnc_Proc_Cat_FK Foreign Key (Cat_Id)   References Clnc_Cat    (Id),
  CONSTRAINT Clnc_Proc_Vat_FK Foreign Key (Vat_Id)   References Clnc_Cod_Vat(Id),
  CONSTRAINT Clnc_Proc_Ins_FK Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Clnc_Proc_Upd_FK Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Clnc_Proc For Clnc_Procedures
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_App_Type_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Appointment_Type                                                                 -- جدول أنواع المواعيد
( Id         Number(5) NOT NULL,                                                                   -- PK
  Capacity   Number(3) DEFAULT 0 NOT NULL,                                                         -- Capacity
  Minutes    Number(3) DEFAULT 15 NOT NULL,                                                        -- Appointment Minutes
  Name       Varchar2(100 Char) NOT NULL,                                                          -- Name
  Title_BG   Varchar2(10 Char) DEFAULT '#CCC' NOT NULL,                                            -- Title Background Color
  Title_FG   Varchar2(10 Char) DEFAULT '#000' NOT NULL,                                            -- Title Text Color
  Patient_FG Varchar2(10 Char) DEFAULT '#777' NOT NULL,                                            -- Patient Name Text Color
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_App_Type_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_App_Type_UK     UNIQUE      (Name),
  CONSTRAINT Clnc_App_Type_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Clnc_App_Type_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Clnc_App_Type For Clnc_Appointment_Type
/
Insert into Clnc_App_Type (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Clinic_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Clinics                                                                          -- جدول العيادات
( Id         Number(5) NOT NULL,                                                                   -- PK
  Status_id  Number(3) DEFAULT 1 NOT NULL,                                                         -- Status
  Name       Varchar2(100 Char) NOT NULL,                                                          -- Name
  Email      Varchar2(75  Char),                                                                   -- Email
  Phone1     Varchar2(30  Char),                                                                   -- Phone 1
  Phone2     Varchar2(30  Char),                                                                   -- Phone 2
  Phone3     Varchar2(30  Char),                                                                   -- Phone 3
  Address    Varchar2(256 Char),                                                                   -- Address
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Clinic_PK         PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_Clinic_UK         UNIQUE      (Name),
  CONSTRAINT Clnc_Clinic_Status_FK  Foreign Key (Status_id) References Phs_Cod_Status(Id),
  CONSTRAINT Clnc_Clinic_Ins_FK     Foreign Key (Ins_User)  References Cpy_User      (Id),
  CONSTRAINT Clnc_Clinic_Upd_FK     Foreign Key (Upd_User)  References Cpy_User      (Id)
)
/
Create Synonym Clnc_Clinic For Clnc_Clinics
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_User_Clinic_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_User_Clinics                                                                     -- جدول عيادات مستحدم
( Id         Number(9) NOT NULL,                                                                   -- PK
  User_Id    Number(5) NOT NULL,                                                                   -- User
  Clinic_Id  Number(5) NOT NULL,                                                                   -- Clinic
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_User_Clinic_PK        PRIMARY KEY (Id),
  CONSTRAINT Clnc_User_Clinic_UK        UNIQUE      (User_Id, Clinic_Id),
  CONSTRAINT Clnc_User_Clinic_User_FK   Foreign Key (User_Id  ) References Cpy_User   (Id),
  CONSTRAINT Clnc_User_Clinic_Clinic_FK Foreign Key (Clinic_Id) References Clnc_Clinic(Id),
  CONSTRAINT Clnc_User_Clinic_Ins_FK    Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT Clnc_User_Clinic_Upd_FK    Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Clnc_User_Clinic For Clnc_User_Clinics
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Doctor_Seq MINVALUE 1 START WITH 1 MAXVALUE 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Doctors                                                                          -- جدول الأطباء
( Id          Number(5) NOT NULL,                                                                  -- PK
  Name        Varchar2(100 Char) NOT NULL,                                                         -- Name
  DoB         date NOT NULL,                                                                       -- Birthdate
  Status_id   Number(3) DEFAULT 1 NOT NULL,                                                         -- Status
  Gender_Id   Number(3) DEFAULT 1 NOT NULL,                                                        -- Gender
  Martial_Id  Number(3) DEFAULT 1 NOT NULL,                                                        -- Martial Status
  IdType_Id   Number(3) DEFAULT 1 NOT NULL,                                                        -- Id Type
  Nat_Id      Number(3) DEFAULT 0 NOT NULL,                                                        -- Nationality
  Special_Id  Number(5) DEFAULT 0 NOT NULL,                                                        -- Speciality
  User_id     Number(5) NOT NULL,                                                                  -- Related User
  IdNum       Varchar2(30 Char),                                                                   -- Id Number
  NatNum      Varchar2(25 Char),                                                                   -- National Id
  Mobile      Varchar2(100 Char) NOT NULL,                                                         -- Mobile
  Phone1      Varchar2(25 Char),                                                                   -- Phone 1
  Phone2      Varchar2(25 Char),                                                                   -- Phone 2
  Email       Varchar2(75 Char),                                                                   -- Email
  Langs       Varchar2(100 Char),                                                                  -- Languages Known
  Descr       Varchar2(100 Char),                                                                  -- Description
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Doctor_PK         PRIMARY KEY (Id    ),
  CONSTRAINT Clnc_Doctor_Mobile_UK  UNIQUE      (Mobile),
  CONSTRAINT Clnc_Doctor_Status_FK  Foreign Key (Status_id ) References Phs_Cod_Status (Id),
  CONSTRAINT Clnc_Doctor_Gender_FK  Foreign Key (Gender_Id ) References Phs_Cod_Gender (Id),
  CONSTRAINT Clnc_Doctor_IdType_FK  Foreign Key (IdType_Id ) References Phs_Cod_IdType (Id),
  CONSTRAINT Clnc_Doctor_Martial_FK Foreign Key (Martial_Id) References Phs_Cod_Marital(Id),
  CONSTRAINT Clnc_Doctor_Nat_FK     Foreign Key (Nat_id    ) References Clnc_Cod_Nat   (Id),
  CONSTRAINT Clnc_Doctor_Special_FK Foreign Key (Special_Id) References Clnc_Special   (Id),
  CONSTRAINT Clnc_Doctor_User_FK    Foreign Key (User_id   ) References Cpy_User       (Id),
  CONSTRAINT Clnc_Doctor_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT Clnc_Doctor_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Clnc_Doctor For Clnc_Doctors
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Labor_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Laboratory                                                                       -- جدول المخابر
( Id          Number(9) NOT NULL,                                                                  -- PK
  Name        Varchar2(100 Char) NOT NULL,                                                         -- Name
  Mobile      Varchar2(100 Char),                                                                  -- Mobile
  Phone1      Varchar2(25 Char),                                                                   -- Phone 1
  Phone2      Varchar2(25 Char),                                                                   -- Phone 2
  Email       Varchar2(75 Char),                                                                   -- Email
  Company     Varchar2(100 Char),                                                                  -- Company Name
  Langs       Varchar2(100 Char),                                                                  -- Languages Known
  Descr       Varchar2(100 Char),                                                                  -- Description
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Labor_PK         PRIMARY KEY (Id  ),
  CONSTRAINT Clnc_Labor_Mobile_UK  UNIQUE      (Name),
  CONSTRAINT Clnc_Labor_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User(Id),
  CONSTRAINT Clnc_Labor_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User(Id)
)
/
Create Synonym Clnc_Labor For Clnc_Laboratory
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Patient_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Patients                                                                         -- جدول المرضى
( Id          Number(9) NOT NULL,                                                                  -- PK
  Clinic_Id   Number(5) NOT NULL,                                                                  -- Patient Clinic
  Name        Varchar2(100 Char) NOT NULL,                                                         -- Name
  DoB         date NOT NULL,                                                                       -- Birthdate
  Gender_Id   Number(3) DEFAULT 1 NOT NULL,                                                        -- Gender
  Martial_Id  Number(3) DEFAULT 1 NOT NULL,                                                        -- Martial Status
  IdType_Id   Number(3) DEFAULT 1 NOT NULL,                                                        -- Id Type
  Nat_Id      Number(3) DEFAULT 0 NOT NULL,                                                        -- Nationality
  List_Id     Number(5) DEFAULT 0 NOT NULL,                                                        -- List
  IdNum       Varchar2(30 Char),                                                                   -- Id Number
  NatNum      Varchar2(25 Char),                                                                   -- National Id
  Mobile      Varchar2(100 Char) NOT NULL,                                                         -- Mobile
  Phone1      Varchar2(25 Char),                                                                   -- Phone 1
  Phone2      Varchar2(25 Char),                                                                   -- Phone 2
  Email       Varchar2(75 Char),                                                                   -- Email
  Company     Varchar2(100 Char),                                                                  -- Company Name
  Langs       Varchar2(100 Char),                                                                  -- Languages Known
  Descr       Varchar2(100 Char),                                                                  -- Description
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Patient_PK         PRIMARY KEY (Id    ),
  CONSTRAINT Clnc_Patient_Mobile_UK  UNIQUE      (Mobile),
  CONSTRAINT Clnc_Patient_Clinic_FK  Foreign Key (Clinic_Id ) References Clnc_Clinic    (Id),
  CONSTRAINT Clnc_Patient_Gender_FK  Foreign Key (Gender_Id ) References Phs_Cod_Gender (Id),
  CONSTRAINT Clnc_Patient_IdType_FK  Foreign Key (IdType_Id ) References Phs_Cod_IdType (Id),
  CONSTRAINT Clnc_Patient_Martial_FK Foreign Key (Martial_Id) References Phs_Cod_Marital(Id),
  CONSTRAINT Clnc_Patient_Nat_FK     Foreign Key (Nat_id    ) References Clnc_Cod_Nat   (Id),
  CONSTRAINT Clnc_Patient_List_FK    Foreign Key (List_id   ) References Clnc_List      (Id),
  CONSTRAINT Clnc_Patient_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT Clnc_Patient_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Clnc_Patient For Clnc_Patients
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Pat_Note_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Patient_Note                                                                     -- جدول ملاحظات الأطباء للمرضى
( Id         Number(9) NOT NULL,                                                                   -- PK
  Patient_Id Number(9) NOT NULL,                                                                   -- Patient
  Doctor_Id  Number(9) NOT NULL,                                                                   -- Doctor
  dDate      Date DEFAULT SYSDATE NOT NULL,                                                        -- Date Time
  Note       Varchar2(512 Char) NOT NULL,                                                          -- Note
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Pat_Note_PK         PRIMARY KEY (Id), 
  CONSTRAINT Clnc_Pat_Note_Doctor_FK  Foreign Key (Doctor_Id ) References clnc_Doctor (Id),
  CONSTRAINT Clnc_Pat_Note_Patient_FK Foreign Key (Patient_Id) References Clnc_Patient(Id),
  CONSTRAINT Clnc_Pat_Note_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User    (Id),
  CONSTRAINT Clnc_Pat_Note_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User    (Id)
)
/
Create Synonym Clnc_Pat_Note For Clnc_Patient_Note
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_App_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Appointment                                                                      -- جدول المواعيد
( Id          Number(9) NOT NULL,                                                                  -- PK
  Clinic_Id   Number(5) NOT NULL,                                                                  -- Clinic
  Special_Id  Number(3) DEFAULT 0 NOT NULL,                                                        -- Speciality
  Status_Id   Number(2) DEFAULT 10 NOT NULL,                                                       -- Status
  Type_Id     Number(3) NOT NULL,                                                                  -- Type
  Doctor_Id   Number(3) NOT NULL,                                                                  -- Doctor
  Patient_Id  Number(9) NOT NULL,                                                                  -- Patient
  dDate       Date NOT NULL,                                                                       -- Date
  nHour       Number(3) DEFAULT 0 NOT NULL,                                                        -- Appointment Hour
  nMinute     Number(3) DEFAULT 0 NOT NULL,                                                        -- Appointment Minute
  Minutes     Number(9) DEFAULT 15 NOT NULL,                                                       -- Appointment Minutes
  Amt         Number(25,3) DEFAULT 0 NOT NULL,                                                     -- Payment Amount
  Descr       Varchar2(512 Char),                                                                  -- Description
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Clnc_App_PK         PRIMARY KEY (Id),
  CONSTRAINT  Clnc_App_UK         UNIQUE      (Doctor_Id, dDate, nHour, nMinute),
  CONSTRAINT  Clnc_App_Clinic_FK  Foreign Key (Clinic_Id ) References Clnc_Clinic    (Id),
  CONSTRAINT  Clnc_App_Doctor_FK  Foreign Key (Doctor_Id ) References Clnc_Doctor    (Id),
  CONSTRAINT  Clnc_App_Patient_FK Foreign Key (Patient_Id) References Clnc_Patient   (Id),
  CONSTRAINT  Clnc_App_Status_FK  Foreign Key (Status_Id ) References Clnc_App_Status(Id),
  CONSTRAINT  Clnc_App_Type_FK    Foreign Key (Type_Id   ) References Clnc_App_Type  (Id),
  CONSTRAINT  Clnc_App_Special_FK Foreign Key (Special_Id) References Clnc_Special   (Id),
  CONSTRAINT  Clnc_App_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT  Clnc_App_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Clnc_App For Clnc_Appointment
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_App_Change_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Appointment_Change                                                               -- جدول تبدل حالات موعد
( Id         Number(9) NOT NULL,                                                                   -- PK
  App_Id     Number(9) NOT NULL,                                                                   -- Appointment
  Status_Id  Number(3) NOT NULL,                                                                   -- Status
  dDate      Date DEFAULT SYSDATE NOT NULL,                                                        -- Date
  Reason     Varchar2(256 Char),                                                                   -- Reason
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date, 
  CONSTRAINT  Clnc_App_Change_PK        PRIMARY KEY (Id),
  CONSTRAINT  Clnc_App_Change_App_FK    Foreign Key (App_Id   ) References Clnc_App       (Id),
  CONSTRAINT  Clnc_App_Change_Status_FK Foreign Key (Status_Id) References Clnc_App_Status(Id),
  CONSTRAINT  Clnc_App_Change_Ins_FK    Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT  Clnc_App_Change_Upd_FK    Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Clnc_App_Change For Clnc_Appointment_Change
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Invoice_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Invoices                                                                         -- جدول الفواتير
( Id              Number(9) NOT NULL,                                                              -- PK
  Clinic_Id       Number(5) NOT NULL,                                                              -- Clinic
  Patient_Id      Number(9) NOT NULL,                                                              -- Patient
  Num             Number(9) NOT NULL,                                                              -- Number
  dDate           Date DEFAULT SYSDATE NOT NULL,                                                   -- Date
  Disc_Id         Number(2) DEFAULT 0 NOT NULL,                                                    -- Discount Type
  Disc_Val        Number(25,3) DEFAULT 0 NOT NULL,                                                 -- Discount Percent/Amount
  Disc_Amt        Number(25,3) DEFAULT 0 NOT NULL,                                                 -- Discount Amount
  Disc_Reason     Varchar2(100 Char),                                                              -- Discount Reason
  Ins_User        Number(5), Ins_Date   Date,
  Upd_User        Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Invoice_PK         PRIMARY KEY (Id),
  CONSTRAINT Clnc_Invoice_Clinic_FK  Foreign Key (Clinic_Id ) References Clnc_Clinic  (Id),
  CONSTRAINT Clnc_Invoice_Patient_FK Foreign Key (Patient_Id) References Clnc_Patient (Id),
  CONSTRAINT Clnc_Invoice_Disc_FK    Foreign Key (Disc_Id   ) References Clnc_Cod_Disc(Id),
  CONSTRAINT Clnc_Invoice_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User     (Id),
  CONSTRAINT Clnc_Invoice_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User     (Id)
) 
/
Create Synonym Clnc_Invoice For Clnc_Invoices
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Treat_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Treatment                                                                        -- جدول المعالجة
( Id         Number(9) NOT NULL,                                                                   -- PK
  Clinic_Id  Number(5) NOT NULL,                                                                   -- Clinic
  Doctor_Id  Number(5) NOT NULL,                                                                   -- Doctor
  Patient_Id Number(9) NOT NULL,                                                                   -- Patient
  Inv_Id     Number(9),                                                                            -- Invoice
  Status_Id  Number(3) DEFAULT 1 NOT NULL,                                                         -- Status
  dDate      Date DEFAULT SYSDATE NOT NULL,                                                        -- Date
  Descr      Varchar2(512 Char),                                                                   -- Description 
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Treat_PK         PRIMARY KEY (Id), 
  CONSTRAINT Clnc_Treat_Clinic_FK  Foreign Key (Clinic_Id ) References Clnc_Clinic      (Id),
  CONSTRAINT Clnc_Treat_Doctor_FK  Foreign Key (Doctor_Id ) References Clnc_Doctor      (Id),
  CONSTRAINT Clnc_Treat_Patient_FK Foreign Key (Patient_Id) References Clnc_Patient     (Id),
  CONSTRAINT Clnc_Treat_Invoice_FK Foreign Key (Inv_Id    ) References Clnc_Invoice     (Id),
  CONSTRAINT Clnc_Treat_Status_FK  Foreign Key (Status_Id ) References Clnc_Treat_Status(Id),
  CONSTRAINT Clnc_Treat_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User         (Id),
  CONSTRAINT Clnc_Treat_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User         (Id)
)
/
Create Synonym Clnc_Treat For Clnc_Treatment
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Treat_Proc_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Treatment_Procedures                                                             -- جدول إجراءات معالجة
( Id          Number(9) NOT NULL,                                                                  -- PK
  Treat_Id    Number(9) NOT NULL,                                                                  -- Treatment
  Proc_Id     Number(9) NOT NULL,                                                                  -- Procedure
  Vat_Id      Number(3) DEFAULT 0 NOT NULL,                                                        -- Vat Type
  Qnt         Number(25,3) DEFAULT 1 NOT NULL,                                                     -- Quantity
  Price       Number(25,3) DEFAULT 0 NOT NULL,                                                     -- Price
  Discount    Number(25,3) DEFAULT 0 NOT NULL,                                                     -- Discount
  Amt         Number(25,3) DEFAULT 0 NOT NULL,                                                     -- Amount
  Vat_Value   Number(25,3) DEFAULT 0 NOT NULL,                                                     -- Vat Percent/Amount Type
  Vat_Amt     Number(25,3) DEFAULT 0 NOT NULL,                                                     -- Vat Amount
  dDate       Date DEFAULT SYSDATE NOT NULL,                                                       -- Date
  Descr       Varchar2(256 Char),                                                                  -- Description
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Clnc_Treat_Proc_PK        PRIMARY KEY (Id), 
  CONSTRAINT  Clnc_Treat_Proc_Treat_FK  Foreign Key (Treat_Id) References Clnc_Treat  (Id),
  CONSTRAINT  Clnc_Treat_Proc_Doctor_FK Foreign Key (Proc_Id ) References Clnc_Proc   (Id),
  CONSTRAINT  Clnc_Treat_Proc_Vat_FK    Foreign Key (Vat_Id  ) References Clnc_Cod_Vat(Id),  
  CONSTRAINT  Clnc_Treat_Proc_Ins_FK    Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT  Clnc_Treat_Proc_Upd_FK    Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Clnc_Treat_Proc For Clnc_Treatment_Procedures
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Invoice_Treat_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Invoice_Treatments                                                               -- جدول فاتورة معالجة
( Id          Number(9) NOT NULL,                                                                  -- PK
  Inv_Id      Number(9) NOT NULL,                                                                  -- Invoices
  Treat_Id    Number(9) NOT NULL,                                                                  -- Treatment
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Clnc_Invoice_Treat_PK         PRIMARY KEY (Id), 
  CONSTRAINT  Clnc_Invoice_Treat_Invoice_FK Foreign Key (Inv_Id  ) References Clnc_Invoice (Id),  
  CONSTRAINT  Clnc_Invoice_Treat_Treat_FK   Foreign Key (Treat_Id) References Clnc_Treat   (Id),
  CONSTRAINT  Clnc_Invoice_Treat_Ins_FK     Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT  Clnc_Invoice_Treat_Upd_FK     Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Clnc_Invoice_Treat For Clnc_Invoice_Treatments
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Disc_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Discounts                                                                   -- جدول الحسميات
( Id          Number(9) NOT NULL,                                                                  -- PK
  Clinic_Id   Number(9) NOT NULL,                                                                  -- Clinic
  Patient_Id  Number(9) NOT NULL,                                                                  -- Patient
  dDate       date NOT NULL,                                                                       -- Date
  Amt         Number(25,3) DEFAULT 0 NOT NULL,                                                     -- Amount
  Descr       Varchar2(256 Char),                                                                  -- Description
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Clnc_Disc_PK         PRIMARY KEY (Id),
  CONSTRAINT  Clnc_Disc_Clinic_FK  Foreign Key (Clinic_Id ) References Clnc_Clinic (Id),
  CONSTRAINT  Clnc_Disc_Patient_FK Foreign Key (Patient_Id) References Clnc_Patient(Id),
  CONSTRAINT  Clnc_Disc_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User    (Id),
  CONSTRAINT  Clnc_Disc_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User    (Id)
)
/
Create Synonym Clnc_Disc For Clnc_Discounts
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Pay_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Payment                                                                          -- جدول دفعات الزبائن
( Id          Number(9) NOT NULL,                                                                  -- PK
  Clinic_Id   Number(9) NOT NULL,                                                                  -- Clinic
  Patient_Id  Number(9) NOT NULL,                                                                  -- Patient
  Type_Id     Number(3) DEFAULT 1 NOT NULL,                                                        -- Payment Method
  dDate       date NOT NULL,                                                                       -- Date
  Amt         Number(25,3) DEFAULT 0 NOT NULL,                                                     -- Amount
  Descr       Varchar2(256 Char),                                                                  -- Description
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Pay_PK         PRIMARY KEY (Id), 
  CONSTRAINT Clnc_Pay_Clinic_FK  Foreign Key (Clinic_Id ) References Clnc_Clinic  (Id),
  CONSTRAINT Clnc_Pay_Patient_FK Foreign Key (Patient_Id) References Clnc_Patient (Id),
  CONSTRAINT Clnc_Pay_Doctor_FK  Foreign Key (Type_id   ) References Clnc_Pay_Type(Id),
  CONSTRAINT Clnc_Pay_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User     (Id),
  CONSTRAINT Clnc_Pay_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User     (Id)
)
/
Create Synonym Clnc_Pay For Clnc_Payment
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Refund_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Refunds                                                                     -- جدول مرتجع التسديد لمريض
( Id          Number(9) NOT NULL,                                                                  -- PK
  Clinic_Id   Number(9) NOT NULL,                                                                  -- Clinic
  Patient_Id  Number(9) NOT NULL,                                                                  -- Patient
  dDate       date NOT NULL,                                                                       -- Date
  Amt         Number(25,3) DEFAULT 0 NOT NULL,                                                     -- Amount
  Descr       Varchar2(256 Char),                                                                  -- Description
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Refund_PK          PRIMARY KEY (Id), 
  CONSTRAINT Clnc_Refund_Clinic_FK   Foreign Key (Clinic_Id)  References Clnc_Clinic (Id),
  CONSTRAINT Clnc_Refundt_Patient_FK Foreign Key (Patient_Id) References Clnc_Patient(Id),
  CONSTRAINT Clnc_Refund_Ins_FK      Foreign Key (Ins_User)   References Cpy_User    (Id),
  CONSTRAINT Clnc_Refund_Upd_FK      Foreign Key (Upd_User)   References Cpy_User    (Id)
) 
/
Create Synonym Clnc_Refund For Clnc_Refunds
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Labor_Send_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Laboratory_Send                                                                  -- جدول إرسال العينات للمخبر
( Id         Number(9) NOT NULL,                                                                   -- PK
  Clinic_Id  Number(5) NOT NULL,                                                                   -- Clinic
  Doctor_Id  Number(5) NOT NULL,                                                                   -- Doctor
  Patient_Id Number(9) NOT NULL,                                                                   -- Patient
  Labor_Id   Number(9) NOT NULL,                                                                   -- Laboratory
  dDate      Date DEFAULT SYSDATE NOT NULL,                                                        -- Date
  Qnt        Number(25,3) DEFAULT 1 NOT NULL,                                                      -- Quantity
  CQnt       Number(25,3) DEFAULT 1 NOT NULL,                                                      -- Current Quantity
  Descr      Varchar2(512 Char),                                                                   -- Description 
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Labor_Send_PK         PRIMARY KEY (Id), 
  CONSTRAINT Clnc_Labor_Send_Clinic_FK  Foreign Key (Clinic_Id ) References Clnc_Clinic (Id),
  CONSTRAINT Clnc_Labor_Send_Doctor_FK  Foreign Key (Doctor_Id ) References clnc_Doctor (Id),
  CONSTRAINT Clnc_Labor_Send_Patient_FK Foreign Key (Patient_Id) References Clnc_Patient(Id),
  CONSTRAINT Clnc_Labor_Send_Labor_FK   Foreign Key (Labor_Id  ) References Clnc_Labor  (Id),
  CONSTRAINT Clnc_Labor_Send_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User    (Id),
  CONSTRAINT Clnc_Labor_Send_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User    (Id)
)
/
Create Synonym Clnc_Labor_Send For Clnc_Laboratory_Send
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Labor_Receive_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Laboratory_Receive                                                               -- جدول استلام العينات من المخبر
( Id         Number(9) NOT NULL,                                                                   -- PK
  Clinic_Id  Number(5) NOT NULL,                                                                   -- Clinic
  Doctor_Id  Number(5) NOT NULL,                                                                   -- Doctor
  Patient_Id Number(9) NOT NULL,                                                                   -- Patient
  Labor_Id   Number(9) NOT NULL,                                                                   -- Laboratory
  Send_Id    Number(9) NOT NULL,                                                                   -- Related Send Id
  dDate      Date DEFAULT SYSDATE NOT NULL,                                                        -- Date
  Qnt        Number(25,3) DEFAULT 1 NOT NULL,                                                      -- Quantity
  Descr      Varchar2(512 Char),                                                                   -- Description 
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Labor_Receive_PK         PRIMARY KEY (Id), 
  CONSTRAINT Clnc_Labor_Receive_Clinic_FK  Foreign Key (Clinic_Id ) References Clnc_Clinic    (Id),
  CONSTRAINT Clnc_Labor_Receive_Doctor_FK  Foreign Key (Doctor_Id ) References clnc_Doctor    (Id),
  CONSTRAINT Clnc_Labor_Receive_Patient_FK Foreign Key (Patient_Id) References Clnc_Patient   (Id),
  CONSTRAINT Clnc_Labor_Receive_Labor_FK   Foreign Key (Labor_Id  ) References Clnc_Labor     (Id),
  CONSTRAINT Clnc_Labor_Receive_Send_FK    Foreign Key (Send_Id   ) References Clnc_Labor_Send(Id),
  CONSTRAINT Clnc_Labor_Receive_Ins_FK     Foreign Key (Ins_User  ) References Cpy_User       (Id),
  CONSTRAINT Clnc_Labor_Receive_Upd_FK     Foreign Key (Upd_User  ) References Cpy_User       (Id)
)
/
Create Synonym Clnc_Labor_Receive For Clnc_Laboratory_Receive
/














----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Offer_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Offers                                                                           -- العروض
( Id          Number(9) NOT NULL,                                                                  -- PK
  Name        Varchar2(100 Char) NOT NULL,                                                         -- Name
  Status_Id   Number(3) DEFAULT 2 NOT NULL,                                                        -- Status
  SDate       date NOT NULL,                                                                       -- Start Date
  EDate       date NOT NULL,                                                                       -- End Date
  Descr       Varchar2(512 Char),                                                                  -- Description
  Ins_User    Number(5), Ins_Date   Date,
  Upd_User    Number(5), Upd_Date   Date,
  CONSTRAINT  Clnc_Offer_PK        PRIMARY KEY (Id),
  CONSTRAINT  Clnc_Offer_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT  Clnc_Offer_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT  Clnc_Offer_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Clnc_Offer For Clnc_Offers
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Offer_Clnc_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Offer_Clinic                                                                     -- عيادات عرض
( Id         Number(9) NOT NULL,                                                                   -- PK
  offer_id   Number(9) NOT NULL,                                                                   -- Offer
  Clinic_Id  Number(9) NOT NULL,                                                                   -- Clinic
  Descr      Varchar2(512 Char),                                                                   -- Description
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Offer_Clnc_PK        PRIMARY KEY (Id),
  CONSTRAINT Clnc_Offer_Clnc_Offer_FK  Foreign Key (offer_id)  References Clnc_Offer (Id),
  CONSTRAINT Clnc_Offer_Clnc_Clinic_FK Foreign Key (Clinic_Id) References Clnc_Clinic(Id),
  CONSTRAINT Clnc_Offer_Clnc_Ins_FK    Foreign Key (Ins_User)  References Cpy_User   (Id),
  CONSTRAINT Clnc_Offer_Clnc_Upd_FK    Foreign Key (Upd_User)  References Cpy_User   (Id)
) 
/
Create Synonym Clnc_Offer_Clnc For Clnc_Offer_Clinic
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_Offer_Proc_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_Offer_Procedure                                                                  -- جدول إجراءات عرض
( Id         Number(9) NOT NULL,                                                                   -- PK
  Offer_Id   Number(9) NOT NULL,                                                                   -- Offer
  Proc_Id    Number(9) NOT NULL,                                                                   -- Procedure
  Price      Number(25,3) DEFAULT 0 NOT NULL,                                                      -- Offer Price
  Descr      Varchar2(512 Char),                                                                   -- Description
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_Offer_Proc_PK           PRIMARY KEY (Id),
  CONSTRAINT Clnc_Offer_Proc_Offer_FK     Foreign Key (Offer_Id) References Clnc_Offer(Id),
  CONSTRAINT Clnc_Offer_Proc_Procedure_FK Foreign Key (Proc_Id ) References Clnc_Proc (Id),
  CONSTRAINT Clnc_Offer_Proc_Ins_FK       Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT Clnc_Offer_Proc_Upd_FK       Foreign Key (Upd_User) References Cpy_User  (Id)
) 
/
Create Synonym Clnc_Offer_Proc For Clnc_Offer_Procedure
/
----------------------------------------------------------------------------------------------------
CREATE SEQUENCE Clnc_User_Shift_Seq MINVALUE 1 START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Clnc_User_Shifts                                                                      -- جدول دوام مستحدم
( Id         Number(9) NOT NULL,                                                                   -- PK
  User_Id    Number(5) NOT NULL,                                                                   -- User
  dDate      Date,                                                                                 -- Date
  Shift_Id   Number(3) DEFAULT 0 NOT NULL,                                                         -- Type
  STime      Number(5) NOT NULL,                                                                   -- Start Time
  ETime      Number(5) NOT NULL,                                                                   -- End Time
  Ins_User   Number(5), Ins_Date   Date,
  Upd_User   Number(5), Upd_Date   Date,
  CONSTRAINT Clnc_User_Shift_PK        PRIMARY KEY (Id),
  CONSTRAINT Clnc_User_Shift_UK        UNIQUE      (dDate, User_Id, Shift_Id),
  CONSTRAINT Clnc_User_Shift_User_FK   Foreign Key (User_Id ) References Cpy_User      (Id),
  CONSTRAINT Clnc_User_Shift_Shift_FK  Foreign Key (Shift_Id) References Clnc_Cod_Shift(Id),
  CONSTRAINT Clnc_User_Shift_Ins_FK    Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Clnc_User_Shift_Upd_FK    Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Clnc_User_Shift For Clnc_User_Shifts
/
