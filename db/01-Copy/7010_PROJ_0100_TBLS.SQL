--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'PROJ%' ;
--select 'Drop Synonym ' || synonym_name                        || ';' from user_synonyms  where synonym_name  like 'PROJ%' ;
--select 'Drop Sequence '|| sequence_name                       || ';' from user_sequences where sequence_name like 'PROJ%' ;
----------------------------------------------------------------------------------------------------
Create Table Proj_Fin_Code_Type                                 -- جدول ترميز نوع البند
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Fin_Cod_Type_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Fin_Cod_Type_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Fin_Cod_Type_Fk     Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Proj_Fin_Cod_Type_Ins_FK Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Proj_Fin_Cod_Type_Upd_FK Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Proj_Fin_Cod_Type For Proj_Fin_Code_Type
/
INSERT INTO Proj_Fin_Cod_Type (Id, Name) VALUES (-1, 'Subtract');
INSERT INTO Proj_Fin_Cod_Type (Id, Name) VALUES (1 , 'Add'     );
---------------------------------------------------------------------------------------------------
Create Table Proj_Fin_Code_Status                               -- جدول ترميز 
( Id         Number(1) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),          				         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Fin_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Fin_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Fin_Cod_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User      (Id),
  CONSTRAINT Proj_Fin_Cod_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User      (Id)
)
/
Create Synonym Proj_Fin_Cod_Status For Proj_Fin_Code_Status
/
Insert into Proj_Fin_Cod_Status (Id,Name) values (0,'Draft');
Insert into Proj_Fin_Cod_Status (Id,Name) values (1,'Final');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Priority_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Priority                            -- جدول ترميز 
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Priority_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Priority_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Priority_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Priority_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Priority For Proj_Code_Priority
/
Insert into Proj_Cod_Priority (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Status_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Status                              -- جدول ترميز الحالات
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Status_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Status For Proj_Code_Status
/
Insert into Proj_Cod_Status (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Type_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Types                               -- ترميز أنواع القضايا
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Types_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Types_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Types_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Types_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Type For Proj_Code_Types
/
Insert into Proj_Code_Types (Id, Name) VALUES (0, '-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Cust_Cat_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Customers_Cat                       -- ترميز أنواع الزبائن
( Id         Number(5) NOT NULL,
  Status_Id  Number(1) Default 1,
  Name       Varchar2(100 Char) NOT NULL,
  Rem        Varchar2(100 Char),
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Cust_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Cust_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Cust_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Cust_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Cust_Cat For Proj_Code_Customers_Cat
/
Insert into Proj_Cod_Cust_Cat (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Member_Class1_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Member_Class1                      
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Member_Class1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Member_Class1_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Member_Class1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Member_Class1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Member_Class1 For Proj_Code_Member_Class1
/
Insert into Proj_Cod_Member_Class1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Member_Class2_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Member_Class2                      
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Member_Class2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Member_Class2_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Member_Class2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Member_Class2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Member_Class2 For Proj_Code_Member_Class2
/
Insert into Proj_Cod_Member_Class2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Member_Class3_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Member_Class3                      
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Member_Class3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Member_Class3_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Member_Class3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Member_Class3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Member_Class3 For Proj_Code_Member_Class3
/
Insert into Proj_Cod_Member_Class3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Proj_Class1_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Project_Class1                      
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Proj_Class1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Proj_Class1_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Proj_Class1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Proj_Class1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Proj_Class1 For Proj_Code_Project_Class1
/
Insert into Proj_Cod_Proj_Class1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Proj_Class2_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Project_Class2                      
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Proj_Class2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Proj_Class2_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Proj_Class2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Proj_Class2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Proj_Class2 For Proj_Code_Project_Class2
/
Insert into Proj_Cod_Proj_Class2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Proj_Class3_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Project_Class3                      
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Proj_Class3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Proj_Class3_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Proj_Class3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Proj_Class3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Proj_Class3 For Proj_Code_Project_Class3
/
Insert into Proj_Cod_Proj_Class3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Cust_Class1_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Customer_Class1                      
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Cust_Class1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Cust_Class1_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Cust_Class1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Cust_Class1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Cust_Class1 For Proj_Code_Customer_Class1
/
Insert into Proj_Cod_Cust_Class1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Cust_Class2_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Customer_Class2                      
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Cust_Class2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Cust_Class2_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Cust_Class2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Cust_Class2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Cust_Class2 For Proj_Code_Customer_Class2
/
Insert into Proj_Cod_Cust_Class2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cod_Cust_Class3_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Code_Customer_Class3                      
( Id         Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1,                          
  Name       Varchar2(100 Char) NOT NULL,                  
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cod_Cust_Class3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cod_Cust_Class3_UK     UNIQUE      (Name),
  CONSTRAINT Proj_Cod_Cust_Class3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Proj_Cod_Cust_Class3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Proj_Cod_Cust_Class3 For Proj_Code_Customer_Class3
/
Insert into Proj_Cod_Cust_Class3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Team_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Team_Members                             -- فريق العمل
( Id         Number(5) NOT NULL,                           -- PK
  User_Id    Number(5) NOT NULL,                           -- المستخدم
  Status_Id  Number(1) Default 1 NOT NULL,                 -- الحالة
  Class1_Id  Number(5) Default 0 NOT NULL,                 -- تصنيف 1
  Class2_Id  Number(5) Default 0 NOT NULL,                 -- تصنيف 2
  Class3_Id  Number(5) Default 0 NOT NULL,                 -- تصنيف 3
  HPrice     Number(25,2) Default 0 NOT NULL,              -- الأجر بالساعة
  Curn_Id    Number(3) Default 1 NOT NULL,                 -- عملة الأجر
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Image      Varchar2(512 Char),                           -- الصورة
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Team_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Team_UK        UNIQUE      (Name),
  CONSTRAINT Proj_Team_User_FK   Foreign Key (User_Id  ) References Cpy_User              (Id),
  CONSTRAINT Proj_Team_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status        (Id),
  CONSTRAINT Proj_Team_Class1_FK Foreign Key (Class1_Id) References Proj_Cod_Member_Class1(Id),
  CONSTRAINT Proj_Team_Class2_FK Foreign Key (Class2_Id) References Proj_Cod_Member_Class2(Id),
  CONSTRAINT Proj_Team_Class3_FK Foreign Key (Class3_Id) References Proj_Cod_Member_Class3(Id),
  CONSTRAINT Proj_Team_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn             (Id),
  CONSTRAINT Proj_Team_Ins_FK    Foreign Key (Ins_User ) References Cpy_User              (Id),
  CONSTRAINT Proj_Team_Upd_FK    Foreign Key (Upd_User ) References Cpy_User              (Id)
)
/
Create Synonym Proj_Team For Proj_Team_Members
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Cust_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Customers                                -- الزبائن
( Id         Number(5) NOT NULL,                           -- pk
  Status_Id  Number(1) Default 1 NOT NULL,                 -- الحالة
  Cat_Id     Number(5) Default 1 NOT NULL,                 -- الفئة
  Class1_Id  Number(5) Default 0 NOT NULL,                 -- تصنيف 1
  Class2_Id  Number(5) Default 0 NOT NULL,                 -- تصنيف 2
  Class3_Id  Number(5) Default 0 NOT NULL,                 -- تصنيف 3
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Image      Varchar2(512 Char),                           -- الصورة
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Cust_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Cust_UK        UNIQUE      (Name),
  CONSTRAINT Proj_Cust_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status         (Id),
  CONSTRAINT Proj_Cust_Cat_FK    Foreign Key (Cat_Id)    References Proj_Code_Customers_Cat(Id),
  CONSTRAINT Proj_Cust_Class1_FK Foreign Key (Class1_Id) References Proj_Cod_Cust_Class1   (Id),
  CONSTRAINT Proj_Cust_Class2_FK Foreign Key (Class2_Id) References Proj_Cod_Cust_Class2   (Id),
  CONSTRAINT Proj_Cust_Class3_FK Foreign Key (Class3_Id) References Proj_Cod_Cust_Class3   (Id),
  CONSTRAINT Proj_Cust_Ins_FK    Foreign Key (Ins_User ) References Cpy_User               (Id),
  CONSTRAINT Proj_Cust_Upd_FK    Foreign Key (Upd_User ) References Cpy_User               (Id)
)
/
Create Synonym Proj_Cust For Proj_Customers
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Proj_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project                                   -- المشاريع
( Id          Number(9) NOT NULL,                           -- PK
  Cust_Id     Number(5) Default 0 NOT NULL,                 -- الزبون
  Type_Id     Number(5) Default 0 NOT NULL,                 -- نوع القضية
  Status_Id   Number(5) Default 1 NOT NULL,                 -- حالة القضية
  Priority_Id NUmber(5) Default 0 NOT NULL,                 -- Priority
  Member_Id   Number(5) Default 0 NOT NULL,                 -- معرف الفريق
  Class1_Id   Number(5) Default 0 NOT NULL,                 -- تصنيف 1
  Class2_Id   Number(5) Default 0 NOT NULL,                 -- تصنيف 2
  Class3_Id   Number(5) Default 0 NOT NULL,                 -- تصنيف 3
  Curn_Id     Number(3) Default 1 NOT NULL,                 -- العملة
  Progress    Number(3) DEFAULT 0 NOT NULL,                 -- نسبة الإنجاز
  Name        Varchar2(100 Char) NOT NULL,                  -- الاسم
  SDate       Date NOT NULL,                                -- تاريخ البداية
  EDate       Date,                                         -- تاريخ النهاية
  ASDate      Date,                                         -- Start Date
  AEDate      Date,                                         -- End Date
  Rem         Varchar2(100 Char),                           -- ملاحظات
  Descr       Varchar2(4000 Char),                         
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Proj_Proj_PK          PRIMARY KEY (Id  ),
  CONSTRAINT  Proj_Proj_UK          UNIQUE      (Name),
  CONSTRAINT  Proj_Proj_Cust_FK     Foreign Key (Cust_Id    ) References Proj_Cust           (Id),
  CONSTRAINT  Proj_Proj_Type_FK     Foreign Key (Type_Id    ) References Proj_Cod_Type       (Id),
  CONSTRAINT  Proj_Proj_Status_FK   Foreign Key (Status_Id  ) References Proj_Cod_Status     (Id),
  CONSTRAINT  Proj_Proj_Priority_FK Foreign Key (Priority_Id) References Proj_Cod_Priority   (Id),
  CONSTRAINT  Proj_Proj_Member_FK   Foreign Key (Member_Id  ) References Proj_Team           (Id),
  CONSTRAINT  Proj_Proj_Class1_FK   Foreign Key (Class1_Id  ) References Proj_Cod_Proj_Class1(Id),
  CONSTRAINT  Proj_Proj_Class2_FK   Foreign Key (Class2_Id  ) References Proj_Cod_Proj_Class2(Id),
  CONSTRAINT  Proj_Proj_Class3_FK   Foreign Key (Class3_Id  ) References Proj_Cod_Proj_Class3(Id),
  CONSTRAINT  Proj_Proj_Curn_FK     Foreign Key (Curn_Id    ) References Mng_Curn            (Id),
  CONSTRAINT  Proj_Proj_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User            (Id),
  CONSTRAINT  Proj_Proj_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User            (Id)
)
/
Create Synonym Proj_Proj For Proj_Project
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Proj_Team_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project_Team                             
( Id         Number(9) NOT NULL,                           
  Proj_Id    Number(9) NOT NULL,                           
  Team_Id    Number(5) NOT NULL,                           
  Status_Id  Number(1) Default 1 NOT NULL,                 
  Title      Varchar2(100 Char) Default 'Member' NOT NULL, 
  Rem        Varchar2(100 Char),                           
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Proj_Team_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Proj_Proj_Team_UK        UNIQUE      (Proj_Id, Team_Id),
  CONSTRAINT Proj_Proj_Team_Proj_FK   Foreign Key (Proj_Id  ) References Proj_Proj     (Id),
  CONSTRAINT Proj_Proj_Team_Team_FK   Foreign Key (Team_Id  ) References Proj_Team     (Id),
  CONSTRAINT Proj_Proj_Team_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Proj_Proj_Team_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Proj_Proj_Team_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Proj_Proj_Team For Proj_Project_Team
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_MWItem_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
Create Table Proj_WorkItem_Mst                             -- جدول مجموعة الأعمال
( Id         Number(9) NOT NULL,                           -- PK
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Status_Id  Number(1) Default 1 NOT NULL,                 -- الحالة
  Rem        Varchar2(250 Char),                           -- ملحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_MWItem_PK        Primary Key (Id),
  CONSTRAINT Proj_MWItem_Status_FK Foreign Key (Status_Id ) References Phs_Cod_Status(Id),
  CONSTRAINT Proj_MWItem_Ins_FK    Foreign Key (Ins_User  ) References Cpy_User      (Id),
  CONSTRAINT Proj_MWItem_Upd_FK    Foreign Key (Upd_User  ) References Cpy_User      (Id)
)
/
Create Synonym Proj_MWItem For Proj_WorkItem_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_TWItem_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_TWItem_Trn                               -- بنود أعمال
( Id          Number(20) NOT NULL,                         -- PK
  Mst_Id      Number(9) NOT NULL,                          -- مفتاح الأب
  nOrd        Number(3) NOT NULL,                          -- الترتيب
  Status_Id   Number(1) Default 1 NOT NULL,                -- الحالة
  Billable_Id Number(1) Default 1 NOT NULL,                -- هل يتم فوترة الزبون بها
  Name        Varchar2(100 Char) NOT NULL,                 -- الاسم
  Rem         Varchar2(250 Char),                          -- ملاحظات
  Ins_User    Number(5),  Ins_Date  Date,
  Upd_User    Number(5),  Upd_Date  Date,
  CONSTRAINT  Proj_TWItem_PK          Primary Key (Id),
  CONSTRAINT  Proj_TWItem_Mst_FK      Foreign Key (Mst_Id     ) References Proj_MWItem   (Id),
  CONSTRAINT  Proj_TWItem_Status_FK   Foreign Key (Status_Id  ) References Phs_Cod_Status(Id),
  CONSTRAINT  Proj_TWItem_Billable_FK Foreign Key (Billable_Id) References Phs_Cod_YesNo (Id),
  CONSTRAINT  Proj_TWItem_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User      (Id),
  CONSTRAINT  Proj_TWItem_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User      (Id)
)
/
Create Synonym Proj_TWItem For Proj_TWItem_Trn
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Proj_TSheet_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project_Timesheet                        -- أعمال مشروع
( Id         Number(9) NOT NULL,                           -- PK
  Proj_Id    Number(9) NOT NULL,                           -- المشروع
  Team_Id    Number(5) NOT NULL,                           -- عضو المشروع
  MWItem_Id  Number(9) NOT NULL,                           -- مجموعة الأعمال
  TWItem_Id  Number(5) NOT NULL,                           -- بنود الأعمال
  DDate      Date Default Sysdate NOT NULL,                -- التاريخ
  Hours      Number(5,2) Default 0 NOT NULL,               -- عدد الساعات
  SPrice     Number(25,2) Default 0 NOT NULL,              -- سعر البيع
  CPrice     Number(25,2) Default 0 NOT NULL,              -- سعر التكلفة
  SCurn_Id    Number(3) Default 1 NOT NULL,                -- العملة
  SCurn_Rate  Number(25,9) Default 1,                      -- سعر الصرف
  CCurn_Id    Number(3) Default 1 NOT NULL,                -- العملة
  CCurn_Rate  Number(25,9) Default 1,                      -- سعر الصرف
  CAmt       Number(25,2) Default 0 NOT NULL,              -- القيمة قطع = Hours * SPrice 
  Amt        Number(25,2) Default 0 NOT NULL,              -- القيمة = Hours * SPrice * SCurn_Rate
  CCst       Number(25,2) Default 0 NOT NULL,              -- الكلفة قطع = Hours * CPrice 
  Cst        Number(25,2) Default 0 NOT NULL,              -- الكلفة = Hours * CPrice * CCurn_Rate
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Proj_TSheet_PK           PRIMARY KEY (Id),
  CONSTRAINT Proj_Proj_TSheet_Proj_FK      Foreign Key (Proj_Id  ) References Proj_Proj  (Id),
  CONSTRAINT Proj_Proj_TSheet_Team_Id_FK   Foreign Key (Team_Id  ) References Proj_Team  (Id),
  CONSTRAINT Proj_Proj_TSheet_MWItem_Id_FK Foreign Key (MWItem_Id) References Proj_MWItem(Id),
  CONSTRAINT Proj_Proj_TSheet_TWItem_FK    Foreign Key (TWItem_Id) References Proj_TWItem(Id),
  CONSTRAINT Proj_Proj_TSheet_SCurn_FK     Foreign Key (SCurn_Id ) References Mng_Curn   (Id),
  CONSTRAINT Proj_Proj_TSheet_CCurn_FK     Foreign Key (CCurn_Id ) References Mng_Curn   (Id),
  CONSTRAINT Proj_Proj_TSheet_Ins_FK       Foreign Key (Ins_User ) References Cpy_User   (Id),
  CONSTRAINT Proj_Proj_TSheet_Upd_FK       Foreign Key (Upd_User ) References Cpy_User   (Id)
)
/
Create Synonym Proj_Proj_TSheet For Proj_Project_Timesheet
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_Proj_Expense_Seq MinValue 1 Start With 1 MaxValue 999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Proj_Project_Expense                          -- مصاريف مشروع
( Id          Number(9) NOT NULL,                          -- PK
  Proj_Id     Number(9) NOT NULL,                          -- المشروع
  Serv_Id     Number(9) NOT NULL,                          -- الخدمة
  Curn_Id     Number(3) Default 1 NOT NULL,                -- العملة
  Curn_Rate   Number(15,7) Default 1 NOT NULL,             -- سعر الصرف
  DDate       Date NOT NULL,                               -- التاريخ
  Qnt         Number(25,3) Default 0 NOT NULL,             -- الكمية
  Price       Number(25,2) Default 0 NOT NULL,             -- السعر
  CAmt        Number(25,2) Default 0 NOT NULL,             -- القيمة قطع = Qnt * Price * Curn_Rate
  Amt         Number(25,2) Default 0 NOT NULL,             -- القيمة = Qnt * Price
  Billable_Id Number(1) Default 1 NOT NULL,                -- هل يتم فوترة الزبون بها
  Billed_Id   Number(1) Default 0 NOT NULL,                -- هل تم فوترتها؟
  Rem         Varchar2(100 Char),                          -- ملاحظات
  Ins_User    Number(5), Ins_Date     Date,
  Upd_User    Number(5), Upd_Date     Date,
  CONSTRAINT  Proj_Proj_Expense_PK          PRIMARY KEY (Id),
  CONSTRAINT  Proj_Proj_Expense_Proj_FK     Foreign Key (Proj_Id    ) References Proj_Proj    (Id),
  CONSTRAINT  Proj_Proj_Expense_Serv_FK     Foreign Key (Serv_Id    ) References Mng_Serv     (Id),
  CONSTRAINT  Proj_Proj_Expense_Curn_FK     Foreign Key (Curn_Id    ) References Mng_Curn     (Id),
  CONSTRAINT  Proj_Proj_Expense_Billable_FK Foreign Key (Billable_Id) References Phs_Cod_YesNo(Id),
  CONSTRAINT  Proj_Proj_Expense_Billed_FK   Foreign Key (Billed_Id  ) References Phs_Cod_YesNo(Id),
  CONSTRAINT  Proj_Proj_Expense_Ins_FK      Foreign Key (Ins_User   ) References Cpy_User     (Id),
  CONSTRAINT  Proj_Proj_Expense_Upd_FK      Foreign Key (Upd_User   ) References Cpy_User     (Id)
)
/
Create Synonym Proj_Proj_Expense For Proj_Project_Expense
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_MInv_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Invoice_Mst                               -- فواتير القضية
( Id         Number(9),                                    -- PK
  Period_Id  Number(4) Default 0,                          -- الفترة المالية
  Status_Id  Number(5) Default 0,                          -- حالة الفاتورة
  Cust_Id    Number(5) Default 0,                          -- الزبون (يؤخذ من القضية عادة)
  Num        Number(10) Default 0,                         -- الرقم
  dDate      Date Default Sysdate,                         -- التاريخ
  DueDate    Date,                                         -- تاريخ الاستحقاق
  Paid_Id    Number(1) Default 0 NOT NULL,                 -- حالة الدفع
  Paid_Amt   Number(25,2) Default 0 NOT NULL,              -- المبلغ المدفوع
  Paid_Date  Date,                                         -- تاريخ التسديد
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT Proj_Inv_PK        Primary Key (Id),
  CONSTRAINT Proj_Inv_UK        Unique      (Period_Id, Num),
  CONSTRAINT Proj_Inv_WPer_FK   Foreign Key (Period_Id) References Cpy_Period         (Id),
  CONSTRAINT Proj_Inv_Cont_FK   Foreign Key (Cust_Id  ) References Proj_Cust          (Id),
  CONSTRAINT Proj_Inv_Status_FK Foreign Key (Status_Id) References Proj_Fin_Cod_Status(Id),
  CONSTRAINT Proj_Inv_Paid_FK   Foreign Key (Paid_Id  ) References Phs_Cod_YesNo      (Id), 
  CONSTRAINT Proj_Inv_Ins_FK    Foreign Key (Ins_User ) References Cpy_User           (Id),
  CONSTRAINT Proj_Inv_Upd_FK    Foreign Key (Upd_User ) References Cpy_User           (Id)
)
/
Create Synonym Proj_MInv For Proj_Invoice_Mst
/
----------------------------------------------------------------------------------------------------
Create Sequence Proj_TInv_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Proj_Invoice_Trn                               -- بنود فاتورة القضية
( Id           Number(20) NOT NULL,                        -- PK
  Mst_Id       Number(9) NOT NULL,                         -- الفاتورة
  Proj_Id      Number(9) NOT NULL,                         -- المشروع
  TSheet_Id    Number(9),                                  -- العمل المنفذ على المشروع
  Type_Id      Number(5) Default 1,                        -- النوع + أو -
  Unit_Id      Number(5) Default 0,                        -- الوحدة
  nOrd         Number(3) Default 0,                        -- الترتيب
  Curn_Id      Number(3) Default 1,                        -- العملة
  Curn_Rate    Number(25,9) Default 1,                     -- سعر الصرف
  Qnt          Number(25,3) Default 0 NOT NULL,            -- الكمية
  Price        Number(25,2) Default 0,                     -- السعر
  CAmt         Number(25,2) Default 0,                     -- القيمة قطع = Qnt * Price * Curn_Rate
  Amt          Number(25,2) Default 0,                     -- القيمة = Qnt * Price
  Rem          Varchar2(250 Char),                         -- ملاحظات
  Ins_User     Number(5),  Ins_Date  Date,
  Upd_User     Number(5),  Upd_Date  Date,
  CONSTRAINT Proj_TInv_PK        Primary Key (Id),
  CONSTRAINT Proj_TInv_MInv_FK   Foreign Key (Mst_Id   ) References Proj_MInv        (Id),
  CONSTRAINT Proj_TInv_Proj_FK   Foreign Key (Proj_Id  ) References Proj_Proj        (Id),
  CONSTRAINT Proj_TInv_TSheet_FK Foreign Key (TSheet_Id) References Proj_Proj_TSheet (Id), 
  CONSTRAINT Proj_TInv_Curn_FK   Foreign Key (Curn_Id  ) References Mng_Curn         (Id),
  CONSTRAINT Proj_TInv_Type_FK   Foreign Key (Type_Id  ) References Proj_Fin_Cod_Type(Id),
  CONSTRAINT Proj_TInv_Unit_FK   Foreign Key (Unit_Id  ) References Cpy_Unit         (Id),
  CONSTRAINT Proj_TInv_Ins_FK    Foreign Key (Ins_User ) References Cpy_User         (Id),
  CONSTRAINT Proj_TInv_Upd_FK    Foreign Key (Upd_User ) References Cpy_User         (Id)
)
/
Create Synonym Proj_TInv For Proj_Invoice_Trn
/
