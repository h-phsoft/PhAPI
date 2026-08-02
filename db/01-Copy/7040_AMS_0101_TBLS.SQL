Create Sequence Ams_SItem_Status_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Item_Symbol_Status                   -- جدول رموز حالة المادة
( Id             Number(2) NOT NULL,                  -- مفتاح رئيسي
  Status_Id      Number(1) DEFAULT 1,                 -- حالة 
  IsCalculate_Id Number(1) DEFAULT 2 NOT NULL,        -- هل يتم الاحتساب
  IsPass_Id      Number(1) DEFAULT 1 NOT NULL,        -- هل تعتبر ناجح
  Name           Varchar2(100 Char) NOT NULL,              -- الاسم
  Rem            Varchar2(100 Char),                  -- ملاحظات
  Ins_User       Number(5),  Ins_Date    Date,
  Upd_User       Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_SItem_Status_PK              PRIMARY KEY (Id), 
  CONSTRAINT Ams_SItem_Status_UK              UNIQUE      (Name),
  CONSTRAINT Ams_SItem_Status_Status_FK       Foreign Key (Status_Id)      References Phs_Cod_Status (Id),
  CONSTRAINT Ams_SItem_Status_IsCalculate_FK  Foreign Key (IsCalculate_Id) References Phs_Cod_YesNo  (Id),
  CONSTRAINT Ams_SItem_Status_IsPass_FK       Foreign Key (IsPass_Id)      References Phs_Cod_YesNo  (Id),
  CONSTRAINT Ams_SItem_Status_Ins_FK          Foreign Key (Ins_User)       References Cpy_User       (Id),
  CONSTRAINT Ams_SItem_Status_Upd_FK          Foreign Key (Upd_User)       References Cpy_User       (Id)
)
/
Create Synonym Ams_SItem_Status For Ams_Item_Symbol_Status
/

INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(1 , 'N' , 2, 2, '-');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(2 , 'P' , 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(3 , 'F' , 1, 2, 'Fail');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(4 , 'I' , 1, 2, 'Incomplete');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(5 , 'T' , 2, 1, 'Transfer');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(6 , 'Z' , 1, 2, 'Deprived');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(7 , 'W' , 2, 2, 'Withdraw');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(8 , 'A+', 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(9 , 'A' , 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(10, 'A-', 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(11, 'B+', 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(12, 'B' , 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(13, 'B-', 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(14, 'C+', 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(15, 'C' , 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(16, 'C-', 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(17, 'D+', 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(18, 'D' , 1, 1, 'Passed');
INSERT INTO Ams_SItem_Status (Id, Name, IsCalculate_Id, IsPass_Id, Rem) VALUES(19, 'D-', 1, 1, 'Passed');

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Bran_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Branch                          -- جدول الفروع
( Id         Number(2) NOT NULL,                 -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,               -- حالة 
  AR_Name    Varchar2(256 Char) NOT NULL,        -- الاسم
  EN_Name    Varchar2(256 Char) Default NULL,    -- الاسم
  Rem        Varchar2(100 Char),                 -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Bran_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Bran_UK         UNIQUE      (AR_Name),
  CONSTRAINT Ams_Bran_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Bran_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Bran_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Bran For Ams_Branch
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_College_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_College                            -- جدول الكليات
( Id              Number(2) NOT NULL,               -- مفتاح رئيسي
  Branch_Id       Number(2)  Default 1,             -- الفرع 
  Status_Id       Number(1)  Default 1,             -- حالة 
  AR_Name         Varchar2(256 Char) NOT NULL,      -- الاسم
  EN_Name         Varchar2(256 Char) Default NULL,  -- الاسم
  Study_Years     Number(1) DEFAULT 0 NOT NULL ,    -- سنوات الدراسة
  Extension_Years Number(1) DEFAULT 0 NOT NULL ,    -- سنوات التمديد
  Rem             Varchar2(100 Char),               -- ملاحظات
  Ins_User        Number(5),  Ins_Date    Date,
  Upd_User        Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Colge_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Colge_UK         UNIQUE      (AR_Name),
  CONSTRAINT Ams_Colge_Branch_FK  Foreign Key (Branch_Id)  References Ams_Bran       (Id),
  CONSTRAINT Ams_Colge_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Colge_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Colge_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Colge For Ams_College
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Sec_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Section                       -- جدول الاقسام
( Id         Number(5) NOT NULL,               -- مفتاح رئيسي
  College_Id Number(2)  Default 1,             -- الكليات 
  Status_Id  Number(1)  Default 1,             -- حالة 
  AR_Name    Varchar2(256 Char) NOT NULL,      -- الاسم
  EN_Name    Varchar2(256 Char) Default NULL,  -- الاسم
  Rem        Varchar2(100 Char),               -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Sec_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Sec_UK         UNIQUE      (AR_Name),
  CONSTRAINT Ams_Sec_College_FK  Foreign Key (College_Id) References Ams_College     (Id),
  CONSTRAINT Ams_Sec_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Sec_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Sec_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Sec For Ams_Section
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Spec_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Speciality                    -- جدول التخصصات
( Id         Number(5) NOT NULL,               -- مفتاح رئيسي
  Section_Id Number(5)  Default 1,             -- الاقسام 
  Status_Id  Number(1)  Default 1,             -- حالة 
  AR_Name    Varchar2(256 Char) NOT NULL,       -- الاسم
  EN_Name    Varchar2(256 Char) Default NULL,   -- الاسم
  Rem        Varchar2(100 Char),               -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Spec_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Spec_UK         UNIQUE      (AR_Name),
  CONSTRAINT Ams_Spec_Section_FK  Foreign Key (Section_Id) References Ams_Sec     (Id),
  CONSTRAINT Ams_Spec_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Spec_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Spec_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Spec For Ams_Speciality
/
 
------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cert_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Certificate                    -- جدول الشهادات
( Id         Number(3) NOT NULL,                -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,              -- حالة 
  Name       Varchar2(256 Char) NOT NULL,       -- الاسم
  Rem        Varchar2(100 Char),                -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cert_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Cert_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Cert_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cert_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Cert_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Cert For Ams_Certificate
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Dis_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Discount                       -- جدول الخصومات
( Id         Number(3) NOT NULL,                -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,              -- حالة 
  Name       Varchar2(256 Char) NOT NULL,       -- الاسم
  Rem        Varchar2(100 Char),                -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Dis_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Dis_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Dis_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Dis_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Dis_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Dis For Ams_Discount
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Fee_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Fees                           -- جدول الرسوم
( Id         Number(3) NOT NULL,                -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,              -- حالة 
  Name       Varchar2(256 Char) NOT NULL,       -- الاسم
  Rem        Varchar2(100 Char),                -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Fee_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Fee_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Fee_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Fee_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Fee_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Fee For Ams_Fees
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Item_Typ_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Item_Type                      -- جدول انواع المواد
( Id         Number(3) NOT NULL,                -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,              -- حالة 
  Name       Varchar2(256 Char) NOT NULL,       -- الاسم
  Rem        Varchar2(100 Char),                -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Item_Typ_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Item_Typ_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Item_Typ_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Item_Typ_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Item_Typ_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Item_Typ For Ams_Item_Type
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Year_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Years                        -- جدول السنوات
( Id         Number(2) NOT NULL,              -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,            -- حالة 
  Name       Varchar2(256 Char) NOT NULL,     -- الاسم
  Rem        Varchar2(100 Char),              -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Year_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Year_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Year_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Year_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Year_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Year For Ams_Years
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Term_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Terms                          -- جدول الفصول
( Id         Number(1) NOT NULL,                -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,              -- حالة 
  AR_Name    Varchar2(256 Char) NOT NULL,       -- الاسم
  EN_Name    Varchar2(256 Char) Default NULL,   -- الاسم
  Rem        Varchar2(100 Char),                -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Term_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Term_UK         UNIQUE      (AR_Name),
  CONSTRAINT Ams_Term_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Term_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Term_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Term For Ams_Terms
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Item_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Items                        -- جدول المواد
( Id         Number(5) NOT NULL,              -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,            -- حالة 
  Code       Varchar2(256 Char) NOT NULL,     -- الرمز
  AR_Name    Varchar2(256 Char) NOT NULL,     -- الاسم
  EN_Name    Varchar2(256 Char) Default NULL, -- الاسم
  Rem        Varchar2(100 Char),              -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Item_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Item_UK         UNIQUE      (Code),
  CONSTRAINT Ams_Item_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Item_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Item_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Item For Ams_Items
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Teacher_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Teachers                        -- جدول المدرسين
( Id         Number(3)  NOT NULL,                -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,               -- حالة 
  Name       Varchar2(256 Char) NOT NULL,        -- الاسم
  Rem        Varchar2(100 Char),                 -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Teacher_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Teacher_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Teacher_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Teacher_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Teacher_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Teacher For Ams_Teachers
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_AYear_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Academic_Year                   -- جدول السنوات الاكادمية
( Id        Number(3) NOT NULL,                  -- مفتاح رئيسي
  Status_Id Number(1) Default 1,                 -- حالة 
  Name      Varchar2(100 Char) NOT NULL,         -- الاسم
  Rem       Varchar2(100 Char),                  -- ملاحظات
  Ins_User  Number(5),  Ins_Date    Date,
  Upd_User  Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_AYear_PK              PRIMARY KEY (Id), 
  CONSTRAINT Ams_AYear_UK              UNIQUE      (Name),
  CONSTRAINT Ams_AYear_Status_FK       Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_AYear_Ins_FK          Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Ams_AYear_Upd_FK          Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Ams_AYear For Ams_Academic_Year
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_ATerm_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Academic_Term                 -- جدول الفصول الاكادمية
( Id              Number(3) NOT NULL,          -- مفتاح رئيسي
  AYear_Id        Number(3)  NOT NULL,         -- مفتاح الأب
  Term_Id         Number(1)  NOT NULL,         -- الفصل
  Status_Id       Number(1)  Default 1,        -- حالة 
  SDate           Date NOT NULL,	             -- تاريخ البداية
  EDate           Date NOT NULL,	             -- تاريخ النهاية
  RegstrationDate Date,         	             -- تاريخ البداية
  DropDate        Date,         	             -- تاريخ النهاية
  Rem             Varchar2(100 Char),          -- ملاحظات
  Ins_User        Number(5),  Ins_Date    Date,
  Upd_User        Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_ATerm_PK       PRIMARY KEY (Id), 
  CONSTRAINT Ams_ATerm_UK       UNIQUE      (AYear_Id, Term_Id),
  CONSTRAINT Ams_ATerm_AYear_FK Foreign Key (AYear_Id) References Ams_AYear (Id),
  CONSTRAINT Ams_ATerm_Term_FK  Foreign Key (Term_Id ) References Ams_Term  (Id),
  CONSTRAINT Ams_ATerm_Ins_FK   Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT Ams_ATerm_Upd_FK   Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Ams_ATerm For Ams_Academic_Term
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Degree_Lmt_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Degree_Limit                    -- جدول حدود الدرجات
( Id         Number(3)  NOT NULL,                -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,               -- حالة 
  Name       Varchar2(256 Char) NOT NULL,        -- الاسم
  Rem        Varchar2(100 Char),                 -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Degree_Lmt_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Degree_Lmt_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Degree_Lmt_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Degree_Lmt_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Degree_Lmt_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Degree_Lmt For Ams_Degree_Limit
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Degree_Lmt_Trn_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Degree_Limit_Trans                 -- جدول بنود حدود الدرجات
( Id         Number(5) NOT NULL,                    -- مفتاح رئيسي
  Mst_Id     Number(3) NOT NULL,                    -- مفتاح الأب
  Code_Id    Number(11) NOT NULL,                   -- الطالب
  IsPass_Id  Number(1) Default 2,                   -- هل يعتبر ناجح 
  IsCalc_Id  Number(1) Default 2,                   -- هل تحسب ضمن المعدل
  Name       Varchar2(100 Char),                    -- الاسم
  Min        Number(5,2) DEFAULT 0.00 NOT NULL,     -- الدرجة الدنيا 
  Max        Number(5,2) DEFAULT 0.00 NOT NULL,     -- الدرجة العلية 
  Gpa        Number(5,2) DEFAULT 0.00 NOT NULL,     -- المكافئ النقطي
  Rem        Varchar2(100 Char),                    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Degree_Lmt_Trn_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Degree_Lmt_Trn_UK         UNIQUE      (Mst_Id, Code_Id),
  CONSTRAINT Ams_Degree_Lmt_Trn_Mst_FK     Foreign Key (Mst_Id)    References Ams_Degree_Lmt   (Id),
  CONSTRAINT Ams_Degree_Lmt_Trn_Code_FK    Foreign Key (Code_Id)   References Ams_SItem_Status (Id),
  CONSTRAINT Ams_Degree_Lmt_Trn_IsPass_FK  Foreign Key (IsPass_Id) References Phs_Cod_YesNo    (Id),
  CONSTRAINT Ams_Degree_Lmt_Trn_IsCalc_FK  Foreign Key (IsCalc_Id) References Phs_Cod_YesNo    (Id),
  CONSTRAINT Ams_Degree_Lmt_Trn_Ins_FK     Foreign Key (Ins_User)  References Cpy_User         (Id),
  CONSTRAINT Ams_Degree_Lmt_Trn_Upd_FK     Foreign Key (Upd_User)  References Cpy_User         (Id)
)
/
Create Synonym Ams_Degree_Lmt_Trn For Ams_Degree_Limit_Trans
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Exam_Lmt_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Exam_Limit                      -- جدول حدود سقوف الاختبار
( Id         Number(3)  NOT NULL,                -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,               -- حالة 
  Name       Varchar2(256 Char) NOT NULL,        -- الاسم
  Rem        Varchar2(100 Char),                 -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Exam_Lmt_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Exam_Lmt_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Exam_Lmt_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Exam_Lmt_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Exam_Lmt_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Exam_Lmt For Ams_Exam_Limit
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Exam_Lmt_Trn_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Exam_Limit_Trans                      -- جدول بنود حدود سقوف الاختبار
( Id              Number(5) NOT NULL,                  -- مفتاح رئيسي
  Mst_Id          Number(3) NOT NULL,                  -- مفتاح الأب
  Type_Id         Number(11) NOT NULL,                 -- الطالب
  Mark1_Min       Number(6,2) DEFAULT 0.00 NOT NULL,   -- Mark 1 Minimum Required Percentage
  Mark1_Max       Number(6,2) DEFAULT 0.00 NOT NULL,   -- Mark 1 Max Degree
  Mark2_Min       Number(6,2) DEFAULT 0.00 NOT NULL,   -- Mark 2 Minimum Required Percentage
  Mark2_Max       Number(6,2) DEFAULT 0.00 NOT NULL,   -- Mark 2 Max Degree
  Mark3_Min       Number(6,2) DEFAULT 0.00 NOT NULL,   -- Mark 3 Minimum Required Percentag
  Mark3_Max       Number(6,2) DEFAULT 0.00 NOT NULL,   -- Mark 3 Max Degree
  Mark4_Min       Number(6,2) DEFAULT 0.00 NOT NULL,   -- Mark 4 Minimum Required Percentage
  Mark4_Max       Number(6,2) DEFAULT 0.00 NOT NULL,   -- Mark 4 Max Degree
  Mark5_Min       Number(6,2) DEFAULT 0.00 NOT NULL,   -- Mark 5 Minimum Required Percentage
  Mark5_Max       Number(6,2) DEFAULT 0.00 NOT NULL,   -- Mark 5 Max Degree
  Wrk_Min         Number(6,2) DEFAULT 50.00 NOT NULL,  -- Work 1-4 Minimum Required Percentage
  MarkT_Wrk       Number(6,2) DEFAULT 100.00 NOT NULL, -- نسبة درجة الأعمال من المجموع العام
  MarkT_Exm       Number(6,2) DEFAULT 100.00 NOT NULL, -- نسية الامتحان من المجموع العام
  Rem             Varchar2(100 Char),                  -- ملاحظات
  Ins_User        Number(5),  Ins_Date Date,
  Upd_User        Number(5),  Upd_Date Date,
  CONSTRAINT Ams_Exam_Lmt_Trn_PK      PRIMARY KEY (Id), 
  CONSTRAINT Ams_Exam_Lmt_Trn_UK      UNIQUE      (Mst_Id, Type_Id),
  CONSTRAINT Ams_Exam_Lmt_Trn_Mst_FK  Foreign Key (Mst_Id)    References Ams_Exam_Lmt  (Id),
  CONSTRAINT Ams_Exam_Lmt_Trn_Type_FK Foreign Key (Type_Id)   References Ams_Item_Type (Id),
  CONSTRAINT Ams_Exam_Lmt_Trn_Ins_FK  Foreign Key (Ins_User)  References Cpy_User      (Id),
  CONSTRAINT Ams_Exam_Lmt_Trn_Upd_FK  Foreign Key (Upd_User)  References Cpy_User      (Id)
)
/
Create Synonym Ams_Exam_Lmt_Trn For Ams_Exam_Limit_Trans
/ 

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Exam_Lmt_Active_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Exam_Limit_Active                       -- جدول تفعيل سقف الاختبار   
( Id            Number(11) NOT NULL,                     -- مفتاح رئيسي
  ATerm_Id      Number(3) NOT NULL,                      -- الفصل الاكاديمي
  ExamLmt_Id    Number(3) NOT NULL,                      -- سقف الاختبار
  Num           Varchar2(100 Char),                      -- الرفم
  dDate         Date Default sysdate,                    -- التاريخ
  Rem           Varchar2(100 Char),                      -- ملاحظات
  Ins_User      Number(5),  Ins_Date    Date,
  Upd_User      Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Exam_Lmt_Active_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Exam_Lmt_Active_UK         UNIQUE      (Num, ATerm_Id),
  CONSTRAINT Ams_Exam_Lmt_Active_ATerm_FK   Foreign Key (ATerm_Id)    References Ams_ATerm    (Id),
  CONSTRAINT Ams_Exam_Lmt_Active_ExamLmt_FK Foreign Key (ExamLmt_Id ) References Ams_Exam_Lmt (Id),
  CONSTRAINT Ams_Exam_Lmt_Active_Ins_FK     Foreign Key (Ins_User)    References Cpy_User     (Id),
  CONSTRAINT Ams_Exam_Lmt_Active_Upd_FK     Foreign Key (Upd_User)    References Cpy_User     (Id)
)
/
Create Synonym Ams_Exam_Lmt_Active For Ams_Exam_Limit_Active
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_GPA_Lmt_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_GPA_Limit                       -- جدول حدودالعبئ الدراسي
( Id         Number(3)  NOT NULL,                -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,               -- حالة 
  Name       Varchar2(256 Char) NOT NULL,        -- الاسم
  Rem        Varchar2(100 Char),                 -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_GPA_Lmt_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_GPA_Lmt_UK         UNIQUE      (Name),
  CONSTRAINT Ams_GPA_Lmt_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_GPA_Lmt_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_GPA_Lmt_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_GPA_Lmt For Ams_GPA_Limit
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_GPA_Lmt_Trn_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_GPA_Limit_Trans                  -- جدول بنود حدودالعبئ الدراسي
( Id        Number(5) NOT NULL,                   -- مفتاح رئيسي
  Mst_Id    Number(3) NOT NULL,                   -- مفتاح الأب
  Term_Id   Number(1) NOT NULL,                   -- الفصل
  Min_Gpa   Number(5,2) DEFAULT 0.00 NOT NULL,    -- GPA Minimum
  Max_Gpa   Number(5,2) DEFAULT 0.00 NOT NULL,    -- GPA Maximum
  Min_Hour  Number(5,2) DEFAULT 0.00 NOT NULL,    -- Hour Minimum
  Max_Hour  Number(5,2) DEFAULT 0.00 NOT NULL,    -- Hour Maximum
  oMin_Gpa  Number(5,2) DEFAULT 0.00 NOT NULL,    -- Outstanding GPA Minimum
  oMax_Gpa  Number(5,2) DEFAULT 4.00 NOT NULL,    -- Outstanding GPA Maximum
  oMin_Hour Number(5,2) DEFAULT 0.00 NOT NULL,    -- Outstanding Minimum
  oMax_Hour Number(5,2) DEFAULT 0.00 NOT NULL,    -- Outstanding Maximum
  Rem       Varchar2(100 Char),                   -- ملاحظات
  Ins_User  Number(5),  Ins_Date Date,
  Upd_User  Number(5),  Upd_Date Date,
  CONSTRAINT Ams_GPA_Lmt_Trn_PK      PRIMARY KEY (Id), 
  CONSTRAINT Ams_GPA_Lmt_Trn_UK      UNIQUE      (Mst_Id, Term_Id),
  CONSTRAINT Ams_GPA_Lmt_Trn_Mst_FK  Foreign Key (Mst_Id)    References Ams_GPA_Lmt  (Id),
  CONSTRAINT Ams_GPA_Lmt_Trn_Term_FK Foreign Key (Term_Id)   References Ams_Term     (Id),
  CONSTRAINT Ams_GPA_Lmt_Trn_Ins_FK  Foreign Key (Ins_User)  References Cpy_User      (Id),
  CONSTRAINT Ams_GPA_Lmt_Trn_Upd_FK  Foreign Key (Upd_User)  References Cpy_User      (Id)
)
/
Create Synonym Ams_GPA_Lmt_Trn For Ams_GPA_Limit_Trans
/ 

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Grad_Level_Lmt_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Graduation_Level_Limit          -- جدول حدو درجات التخرج
( Id         Number(3)  NOT NULL,                -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,               -- حالة 
  Name       Varchar2(256 Char) NOT NULL,        -- الاسم
  Rem        Varchar2(100 Char),                 -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Grad_Level_Lmt_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Grad_Level_Lmt_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Grad_Level_Lmt_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Grad_Level_Lmt_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Grad_Level_Lmt_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Grad_Level_Lmt For Ams_Graduation_Level_Limit
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Grad_Level_Lmt_Trn_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Graduation_Level_Limit_Trans     -- جدول بنود حدود درجات التخرج
( Id       Number(5) NOT NULL,                    -- مفتاح رئيسي
  Mst_Id   Number(3) NOT NULL,                    -- مفتاح الأب
  Min_Gpa  Number(5,2) DEFAULT 0.00 NOT NULL,     -- Min GPA
  Max_Gpa  Number(5,2) DEFAULT 0.00 NOT NULL,     -- Max GPA
  Name     Varchar2(100 Char),                    -- الاسم
  Rem      Varchar2(100 Char),                    -- ملاحظات
  Ins_User Number(5),  Ins_Date Date,
  Upd_User Number(5),  Upd_Date Date,
  CONSTRAINT Ams_Grad_Level_Lmt_Trn_PK      PRIMARY KEY (Id), 
  CONSTRAINT Ams_Grad_Level_Lmt_Trn_UK      UNIQUE      (Mst_Id,Name),
  CONSTRAINT Ams_Grad_Level_Lmt_Trn_Mst_FK  Foreign Key (Mst_Id)   References Ams_Grad_Level_Lmt (Id),
  CONSTRAINT Ams_Grad_Level_Lmt_Trn_Ins_FK  Foreign Key (Ins_User) References Cpy_User           (Id),
  CONSTRAINT Ams_Grad_Level_Lmt_Trn_Upd_FK  Foreign Key (Upd_User) References Cpy_User           (Id)
)
/
Create Synonym Ams_Grad_Level_Lmt_Trn For Ams_Graduation_Level_Limit_Trans
/ 

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Year_Lmt_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Year_Limit                  -- جدول حدود السنوات الدراسية
( Id         Number(3)  NOT NULL,            -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,           -- حالة 
  Name       Varchar2(256 Char) NOT NULL,    -- الاسم
  Rem        Varchar2(100 Char),             -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Year_Lmt_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Year_Lmt_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Year_Lmt_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Year_Lmt_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Year_Lmt_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Year_Lmt For Ams_Year_Limit
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Year_Lmt_Trn_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Year_Limit_Trans                 -- جدول بنود حدود السنوات الدراسية
( Id       Number(5) NOT NULL,                    -- مفتاح رئيسي
  Mst_Id   Number(3) NOT NULL,                    -- مفتاح الأب
  Year_Id  Number(2) NOT NULL,                    -- مفتاح السنة
  Min      Number(5,2) DEFAULT 0.00 NOT NULL,     -- الحد الأدنى للساعات
  Max      Number(5,2) DEFAULT 0.00 NOT NULL,     -- الحد الاعلى للساعات
  Rem      Varchar2(100 Char),                    -- ملاحظات
  Ins_User Number(5),  Ins_Date Date,
  Upd_User Number(5),  Upd_Date Date,
  CONSTRAINT Ams_Year_Lmt_Trn_PK      PRIMARY KEY (Id), 
  CONSTRAINT Ams_Year_Lmt_Trn_UK      UNIQUE      (Mst_Id,Year_Id),
  CONSTRAINT Ams_Year_Lmt_Trn_Mst_FK  Foreign Key (Mst_Id)   References Ams_Year_Lmt (Id),
  CONSTRAINT Ams_Year_Lmt_Trn_Year_FK Foreign Key (Year_Id)  References Ams_Year     (Id),
  CONSTRAINT Ams_Year_Lmt_Trn_Ins_FK  Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Ams_Year_Lmt_Trn_Upd_FK  Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Ams_Year_Lmt_Trn For Ams_Year_Limit_Trans
/ 

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Price_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Prices                      -- جدول قوائم الاسعار
( Id         Number(3)  NOT NULL,            -- مفتاح رئيسي
  Status_Id  Number(1)  Default 1,           -- حالة 
  Name       Varchar2(256 Char) NOT NULL,    -- الاسم
  Rem        Varchar2(100 Char),             -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Price_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Price_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Price_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Price_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Price_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Price For Ams_Prices
/
 
---------------------------------------------------------------------------------------------------
Create Sequence Ams_Plan_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Study_Plan                              -- جدول الخطط الدراسية
( Id                  Number(3) NOT NULL,                -- مفتاح رئيسي
  Branch_Id           Number(2) Default 1,               -- الفرع 
  ExamLmt_Id          Number(3) NOT NULL,                -- حدود سقوف الاختبار
  Degreelmt_Id        Number(3) NOT NULL,                -- حدود الدرجات 
  Gpalmt_Id           Number(3) NOT NULL,                -- حدود العبىء الدراسي
  Yearlmt_Id          Number(3) NOT NULL,                -- حدود السنوات
  Gradlevellmt_Id     Number(3) NOT NULL,                -- حدود درجات التخرج
  Price_Id            Number(3) NOT NULL,                -- الاسعار
  isNational_Exam_Id  Number(1) Default 1,               -- هل يوجد امتحان وطني
  Status_Id           Number(1) Default 1,               -- حالة 
  AR_Name             Varchar2(256 Char) NOT NULL,       -- الاسم
  EN_Name             Varchar2(256 Char),                -- الاسم
  Total_Hour          Number(3),                         -- عدد الساعات الكلي
  Rem                 Varchar2(100 Char),                -- ملاحظات
  Ins_User            Number(5),  Ins_Date    Date,
  Upd_User            Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Plan_PK               PRIMARY KEY (Id), 
  CONSTRAINT Ams_Plan_UK               UNIQUE      (AR_Name),
  CONSTRAINT Ams_Plan_Branch_FK        Foreign Key (Branch_Id)          References Ams_Bran             (Id),
  CONSTRAINT Ams_Plan_ExamLmt_FK       Foreign Key (ExamLmt_Id)         References Ams_Exam_Lmt         (Id),
  CONSTRAINT Ams_Plan_Degreelmt_FK     Foreign Key (Degreelmt_Id)       References Ams_Degree_Lmt       (Id),
  CONSTRAINT Ams_Plan_Gpalmt_FK        Foreign Key (Gpalmt_Id)          References Ams_GPA_Lmt          (Id),
  CONSTRAINT Ams_Plan_Yearlmt_FK       Foreign Key (Yearlmt_Id)         References Ams_Year_Lmt         (Id),
  CONSTRAINT Ams_Plan_Gradlevellmt_FK  Foreign Key (Gradlevellmt_Id)    References Ams_Grad_Level_Lmt   (Id),
  CONSTRAINT Ams_Plan_Price_FK         Foreign Key (Price_Id)           References Ams_Price            (Id),
  CONSTRAINT Ams_Plan_isNational_FK    Foreign Key (isNational_Exam_Id) References Ams_Cod_NExam_Status (Id),
  CONSTRAINT Ams_Plan_Status_FK        Foreign Key (Status_Id)          References Phs_Cod_Status       (Id),
  CONSTRAINT Ams_Plan_Ins_FK           Foreign Key (Ins_User)           References Cpy_User             (Id),
  CONSTRAINT Ams_Plan_Upd_FK           Foreign Key (Upd_User)           References Cpy_User             (Id)
)
/
Create Synonym Ams_Plan For Ams_Study_Plan
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Plan_Edit_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Study_Plan_Edit                         -- جدول تعديل الخطط الدراسية
( Id                      Number(3)  NOT NULL,           -- مفتاح رئيسي
  Plan_Id                 Number(3) NOT NULL,            -- الخطة الدراسية
  Old_ExamLmt_Id          Number(3) NOT NULL,            -- حدود سقوف الاختبار قديم
  Old_Degreelmt_Id        Number(3) NOT NULL,            -- حدود الدرجات قديم
  Old_Gpalmt_Id           Number(3) NOT NULL,            -- حدود العبىء الدراسي قديم
  Old_Yearlmt_Id          Number(3) NOT NULL,            -- حدود السنوات قديم
  Old_Gradlevellmt_Id     Number(3) NOT NULL,            -- حدود درجات التخرج قديم
  Old_Price_Id            Number(3) NOT NULL,            -- الاسعار قديم
  Old_isNational_Exam_Id  Number(1) Default 1,           -- هل يوجد امتحان وطني قديم
  New_ExamLmt_Id          Number(3) NOT NULL,            -- حدود سقوف الاختبار جديد
  New_Degreelmt_Id        Number(3) NOT NULL,            -- حدود الدرجات جديد
  New_Gpalmt_Id           Number(3) NOT NULL,            -- حدود العبىء الدراسي جديد
  New_Yearlmt_Id          Number(3) NOT NULL,            -- حدود السنوات جديد
  New_Gradlevellmt_Id     Number(3) NOT NULL,            -- حدود درجات التخرج جديد
  New_Price_Id            Number(3) NOT NULL,            -- الاسعار جديد
  New_isNational_Exam_Id  Number(1) Default 1,           -- هل يوجد امتحان وطني جديد
  Status_Id               Number(1) Default 1,           -- حالة 
  Num                     Varchar2(128 Char) NOT NULL,   -- رقم
  dDate                   Date Default sysdate,          -- التاريخ
  Rem                     Varchar2(100 Char),            -- ملاحظات
  Ins_User                Number(5),  Ins_Date    Date,
  Upd_User                Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Plan_Edit_PK                   PRIMARY KEY (Id), 
  CONSTRAINT Ams_Plan_Edit_Old_ExamLmt_FK       Foreign Key (Old_ExamLmt_Id)         References Ams_Exam_Lmt         (Id),
  CONSTRAINT Ams_Plan_Edit_Old_Degreelmt_FK     Foreign Key (Old_Degreelmt_Id)       References Ams_Degree_Lmt       (Id),
  CONSTRAINT Ams_Plan_Edit_Old_Gpalmt_FK        Foreign Key (Old_Gpalmt_Id)          References Ams_GPA_Lmt          (Id),
  CONSTRAINT Ams_Plan_Edit_Old_Yearlmt_FK       Foreign Key (Old_Yearlmt_Id)         References Ams_Year_Lmt         (Id),
  CONSTRAINT Ams_Plan_Edit_Old_Gradlevellmt_FK  Foreign Key (Old_Gradlevellmt_Id)    References Ams_Grad_Level_Lmt   (Id),
  CONSTRAINT Ams_Plan_Edit_Old_Price_FK         Foreign Key (Old_Price_Id)           References Ams_Price            (Id),
  CONSTRAINT Ams_Plan_Edit_Old_isNational_FK    Foreign Key (Old_isNational_Exam_Id) References Ams_Cod_NExam_Status (Id),
  CONSTRAINT Ams_Plan_Edit_New_ExamLmt_FK       Foreign Key (New_ExamLmt_Id)         References Ams_Exam_Lmt         (Id),
  CONSTRAINT Ams_Plan_Edit_New_Degreelmt_FK     Foreign Key (New_Degreelmt_Id)       References Ams_Degree_Lmt       (Id),
  CONSTRAINT Ams_Plan_Edit_New_Gpalmt_FK        Foreign Key (New_Gpalmt_Id)          References Ams_GPA_Lmt          (Id),
  CONSTRAINT Ams_Plan_Edit_New_Yearlmt_FK       Foreign Key (New_Yearlmt_Id)         References Ams_Year_Lmt         (Id),
  CONSTRAINT Ams_Plan_Edit_New_Gradlevellmt_FK  Foreign Key (New_Gradlevellmt_Id)    References Ams_Grad_Level_Lmt   (Id),
  CONSTRAINT Ams_Plan_Edit_New_Price_FK         Foreign Key (New_Price_Id)           References Ams_Price            (Id),
  CONSTRAINT Ams_Plan_Edit_New_isNational_FK    Foreign Key (New_isNational_Exam_Id) References Ams_Cod_NExam_Status (Id),
  CONSTRAINT Ams_Plan_Edit_Status_FK            Foreign Key (Status_Id)              References Phs_Cod_Status       (Id),
  CONSTRAINT Ams_Plan_Edit_Ins_FK               Foreign Key (Ins_User)               References Cpy_User             (Id),
  CONSTRAINT Ams_Plan_Edit_Upd_FK               Foreign Key (Upd_User)               References Cpy_User             (Id)
)
/
Create Synonym Ams_Plan_Edit For Ams_Study_Plan_Edit
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_PItem_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Study_Plan_Item                   -- جدول مواد الخطة الدراسية
( Id            Number(11)  NOT NULL,              -- مفتاح رئيسي
  Plan_Id       Number(3) NOT NULL,                -- الخطة الدراسية
  Colleg_Id     Number(2) DEFAULT 0 NOT NULL,      -- الكلي
  Section_Id    Number(3) DEFAULT 0 NOT NULL,      -- القسم  
  Speciality_Id Number(3) DEFAULT 0 NOT NULL,      -- التخصص
  Item_Type_Id  Number(3) DEFAULT 0 NOT NULL,      -- نوع المادة
  Year_Id       Number(2) DEFAULT 0 NOT NULL,      -- السنة 
  Term_Id       Number(1) DEFAULT 0 NOT NULL,      -- الفصل
  Item_Id       Number(5) DEFAULT 0 NOT NULL,      -- المادة
  Status_Id     Number(1) DEFAULT 1 NOT NULL,      -- الحالة
  Force_Id      Number(1) DEFAULT 1 NOT NULL,      -- اجباري ,اختياري , بند اختيار
  Kind_Id       Number(1) DEFAULT 1 NOT NULL,      -- عادي , تابع لمتطلب
  Choice_Group  Number(4) DEFAULT 0 NOT NULL,      -- ترميز اختياري  
  credit        Number(4,2) DEFAULT 1.00 NOT NULL, -- عدد ساعات المادة
  Min_Req_Hour  Number(3) DEFAULT 0 NOT NULL,      -- الحد الادنى للساعات لختيار المادة,
  Rem           Varchar2(100 Char),                -- ملاحظات
  Ins_User      Number(5),  Ins_Date    Date,
  Upd_User      Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_PItem_PK             PRIMARY KEY (Id), 
  CONSTRAINT Ams_PItem_UK             UNIQUE      (Plan_Id,Colleg_Id,Section_Id,Speciality_Id,Year_Id,Term_Id,Item_Id),
  CONSTRAINT Ams_PItem_Plan_FK        Foreign Key (Plan_Id )      References Ams_Plan           (Id),
  CONSTRAINT Ams_PItem_Colleg_FK      Foreign Key (Colleg_Id)     References Ams_College        (Id),
  CONSTRAINT Ams_PItem_Section_FK     Foreign Key (Section_Id)    References Ams_Sec            (Id),
  CONSTRAINT Ams_PItem_Speciality_FK  Foreign Key (Speciality_Id) References Ams_Spec           (Id),
  CONSTRAINT Ams_PItem_Item_Type_FK   Foreign Key (Item_Type_Id)  References Ams_Item_Typ       (Id),
  CONSTRAINT Ams_PItem_Year_FK        Foreign Key (Year_Id)       References Ams_Year           (Id),
  CONSTRAINT Ams_PItem_Term_FK        Foreign Key (Term_Id)       References Ams_Term           (Id),
  CONSTRAINT Ams_PItem_Item_FK        Foreign Key (Item_Id)       References Ams_Item           (Id), 
  CONSTRAINT Ams_PItem_Force_FK       Foreign Key (Force_Id)      References Ams_Cod_Item_Force (Id),
  CONSTRAINT Ams_PItem_Kind_FK        Foreign Key (Kind_Id)       References Ams_Cod_Item_Kind  (Id),
  CONSTRAINT Ams_PItem_Status_FK      Foreign Key (Status_Id)     References Phs_Cod_Status     (Id),
  CONSTRAINT Ams_PItem_Ins_FK         Foreign Key (Ins_User)      References Cpy_User           (Id),
  CONSTRAINT Ams_PItem_Upd_FK         Foreign Key (Upd_User)      References Cpy_User           (Id)
)
/
Create Synonym Ams_PItem For Ams_Study_Plan_Item
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_PItem_Ord_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Study_Plan_Item_Order             -- جدول المتطلب السابق لمواد الخطة الدراسية
( Id              Number(11)  NOT NULL,            -- مفتاح رئيسي
  PItem_Id        Number(11) NOT NULL,             -- مادة الخطة الدراسية
  OPItem_Id       Number(11) NOT NULL,             -- مادة الخطة الدراسية متطلب
  Rem             Varchar2(100 Char),              -- ملاحظات
  Ins_User        Number(5),  Ins_Date    Date,
  Upd_User        Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_PItem_Ord_PK        PRIMARY KEY (Id), 
  CONSTRAINT Ams_PItem_Ord_UK        UNIQUE      (PItem_Id, OPItem_Id),
  CONSTRAINT Ams_PItem_Ord_PItem_FK  Foreign Key (PItem_Id)  References Ams_PItem (Id),
  CONSTRAINT Ams_PItem_Ord_OPItem_FK Foreign Key (OPItem_Id) References Ams_PItem (Id),
  CONSTRAINT Ams_PItem_Ord_Ins_FK    Foreign Key (Ins_User)  References Cpy_User      (Id),
  CONSTRAINT Ams_PItem_Ord_Upd_FK    Foreign Key (Upd_User)  References Cpy_User      (Id)
)
/
Create Synonym Ams_PItem_Ord For Ams_Study_Plan_Item_Order
/
 
------------------------------------------------------------------------------------------------------
Create Sequence Ams_Stud_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE Ams_Student (                           -- جدول الطلاب
  Id                Number(11) NOT NULL,             -- مفتاح رئيسي
  Nat_Id            Number(3) DEFAULT NULL,          -- الجنسية
  Country_Id        Number(3) DEFAULT NULL,          -- الدولة
  City_Id           Number(3) DEFAULT NULL,          -- المدينة
  Martial_Id        Number(3) DEFAULT NULL,          --FK Martial
  Gender_Id         Number(1) DEFAULT NULL,          --FK Gendeer
  AYear_Id          Number(3) DEFAULT NULL,          --FK Academic Year
  Term_Id           Number(1) DEFAULT NULL,          --FK Term
  Year_Id           Number(2) DEFAULT NULL,          --FK year
  Plan_Id           Number(3) DEFAULT NULL,          --FK Plan
  AStatus_Id        Number(2) DEFAULT NULL,          --FK Academic Status
  Teacher_Id        Number(5) DEFAULT NULL,          --FK Teacher
  Status_Id         Number(1) DEFAULT 1 NOT NULL,    --Status
  Certif_Id         Number(3) DEFAULT NULL,          --FK Certification
  Adjec_Id          Number(1) DEFAULT 1 NOT NULL,    --Student adjective
  Classf_Id         Number(1) DEFAULT 1 NOT NULL,    --Student classification
  NatExam_Status_Id Number(1) DEFAULT 1 NOT NULL,    --Fk, National Exam Status: لايوجد ,ناجح ,غير منجز
  Trn_Grad_Level_Id Number(5) DEFAULT NULL,          --Grad Level
  Grad_ATerm_Id     Number(3) DEFAULT NULL,          --FK Grad Level
  ANum              Varchar2(100 Char) NOT NULL,     --Academic Numebr
  NNum              Varchar2(100 Char) DEFAULT NULL, --ID Number
  Insureuns_Number  Varchar2(128 Char) DEFAULT NULL, --Insurance number
  AR_FName          Varchar2(100 Char) NOT NULL,     --First Name 
  AR_Father         Varchar2(100 Char) NOT NULL,     --Father Name
  AR_Mother         Varchar2(100 Char) NOT NULL,     --Mother Name
  AR_LName          Varchar2(100 Char) NOT NULL,     --Last Name
  En_FName          Varchar2(100 Char) DEFAULT NULL, --First Name English
  En_Father         Varchar2(100 Char) DEFAULT NULL, --Father Name English
  En_Mother         Varchar2(100 Char) DEFAULT NULL, --Mother Name English
  EN_Lname          Varchar2(100 Char) DEFAULT NULL, --Last Name English'
  DOB               Date Default sysdate,            --'Date Of Birth',
  AR_POB            Varchar2(100 Char) DEFAULT NULL, --Birth Place
  EN_POB            Varchar2(100 Char) DEFAULT NULL, --Birth Place English
  Address1          Varchar2(100 Char) DEFAULT NULL, --Address1
  Address2          Varchar2(100 Char) DEFAULT NULL, --Address2
  Email             Varchar2(100 Char) DEFAULT NULL, --Email
  Phone             Varchar2(100 Char) DEFAULT NULL, --Phone Number
  Mobile            Varchar2(100 Char) DEFAULT NULL, --Mobile Number
  HKaied            Varchar2(1024 Char) DEFAULT NULL, --Kaied Header
  PKaied            Varchar2(100 Char) DEFAULT NULL, --Kaied Place
  NKaied            Varchar2(100 Char) DEFAULT NULL, --Kaied Number
  Military          Varchar2(100 Char) DEFAULT NULL, --Military
  Military_Num      Number(11) DEFAULT NULL,
  RDate             Date Default sysdate,            --Registration Date
  Cert_Avg          Number(5,2) DEFAULT NULL,        --Certification Avg
  Cert_Avg_Clear    Number(5,2) DEFAULT NULL,
  Cert_City         Varchar2(100 Char) DEFAULT NULL, --FK Certification  City 
  Cert_Num          Varchar2(100 Char) DEFAULT NULL, --Certification Number
  Cert_Year         Varchar2(100 Char) DEFAULT NULL, --Certification Year
  Cert_Min          Varchar2(100 Char) DEFAULT NULL, --Certification Min
  Cert_Max          Varchar2(100 Char) DEFAULT NULL, --Certification Max
  PassWord          Varchar2(100 Char) DEFAULT NULL, --Student PassWord
  Transfer          Varchar2(256 Char) DEFAULT NULL, --Student Transferred
  sImage            Varchar2(512 Char) DEFAULT NULL, --Image
  NatExam_Mark      Number(5,2) DEFAULT NULL,        --National Exam Mark
  Grad_Ord_Num      Varchar2(100 Char) DEFAULT NULL, --Grad Order Number
  Grad_Ord_Date     Date Default sysdate,            --Grad Order Date
  Grad_Gpa          Number(5,2) DEFAULT NULL,        --Grad GPA
  Grad_Avg          Number(5,2) DEFAULT NULL,        --Grad Avg
  Rem               Varchar2(100 Char),              -- ملاحظات
  Ins_User          Number(5),  Ins_Date    Date,
  Upd_User          Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Stud_PK                 PRIMARY KEY (Id), 
  CONSTRAINT Ams_Stud_UK                 UNIQUE      (ANum),
  CONSTRAINT Ams_Stud_Nat_FK             Foreign Key (Nat_Id)            References Ams_Cod_Nat            (Id),
  CONSTRAINT Ams_Stud_Country_FK         Foreign Key (Country_Id)        References Ams_Cod_City           (Id),
  CONSTRAINT Ams_Stud_City_FK            Foreign Key (City_Id)           References Ams_Cod_Country        (Id),
  CONSTRAINT Ams_Stud_Martial_FK         Foreign Key (Martial_Id)        References Phs_Cod_Marital        (Id),
  CONSTRAINT Ams_Stud_Gender_FK          Foreign Key (Gender_Id)         References Phs_Cod_Gender         (Id),
  CONSTRAINT Ams_Stud_AYear_FK           Foreign Key (AYear_Id)          References Ams_AYear              (Id),
  CONSTRAINT Ams_Stud_Term_FK            Foreign Key (Term_Id)           References Ams_Term               (Id),
  CONSTRAINT Ams_Stud_Year_FK            Foreign Key (Year_Id)           References Ams_Year               (Id),
  CONSTRAINT Ams_Stud_Plan_FK            Foreign Key (Plan_Id)           References Ams_Plan               (Id),
  CONSTRAINT Ams_Stud_AStatus_FK         Foreign Key (AStatus_Id)        References Ams_Cod_AStatus        (Id),
  CONSTRAINT Ams_Stud_Teacher_FK         Foreign Key (Teacher_Id)        References Ams_Teacher            (Id),
  CONSTRAINT Ams_Stud_Status_FK          Foreign Key (Status_Id)         References Phs_Cod_Status         (Id),
  CONSTRAINT Ams_Stud_Cert_FK            Foreign Key (Certif_Id)         References Ams_Cert               (Id), 
  CONSTRAINT Ams_Stud_Adjec_FK           Foreign Key (Adjec_Id)          References Ams_Cert               (Id),          
  CONSTRAINT Ams_Stud_Classf_FK          Foreign Key (Classf_Id)         References Ams_Cert               (Id),         
  CONSTRAINT Ams_Stud_NatExam_Status_FK  Foreign Key (NatExam_Status_Id) References Ams_Cod_NExam_Status   (Id), 
  CONSTRAINT Ams_Stud_Grad_Level_FK      Foreign Key (Trn_Grad_Level_Id) References Ams_Grad_Level_Lmt_Trn (Id),     
  CONSTRAINT Ams_Stud_Grad_ATerm_FK      Foreign Key (Grad_ATerm_Id)     References Ams_ATerm              (Id),
  CONSTRAINT Ams_Stud_Ins_FK             Foreign Key (Ins_User)          References Cpy_User               (Id),
  CONSTRAINT Ams_Stud_Upd_FK             Foreign Key (Upd_User)          References Cpy_User               (Id)     
) 
/
Create Synonym Ams_Stud For Ams_Student
/ 

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Stud_Plan_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Student_Plan                        -- جدول مواد الخطة الدراسية
( Id                 Number(11) NOT NULL,           -- مفتاح رئيسي
  Plan_Id            Number(3) NOT NULL,             -- الخطة الدراسية
  Stud_Id            Number(11) NOT NULL,            -- الطلاب
  Colleg_Id          Number(2) DEFAULT 0 NOT NULL,   -- الكلي
  Section_Id         Number(3) DEFAULT 0 NOT NULL,   -- القسم  
  Speciality_Id      Number(3) DEFAULT 0 NOT NULL,   -- التخصص
  ExamLmt_Id         Number(3) NOT NULL,             -- حدود سقوف الاختبار
  Degreelmt_Id       Number(3) NOT NULL,             -- حدود الدرجات 
  Gpalmt_Id          Number(3) NOT NULL,             -- حدود العبىء الدراسي
  Yearlmt_Id         Number(3) NOT NULL,             -- حدود السنوات
  Gradlevellmt_Id    Number(3) NOT NULL,             -- حدود درجات التخرج
  Price_Id           Number(3) NOT NULL,             -- الاسعار
  isNational_Exam_Id Number(1) Default 1,            -- هل يوجد امتحان وطني
  Rem                Varchar2(100 Char),             -- ملاحظات
  Ins_User           Number(5),  Ins_Date    Date,
  Upd_User           Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Stud_Plan_PK              PRIMARY KEY (Id), 
  CONSTRAINT Ams_Stud_Plan_UK              UNIQUE      (Plan_Id,Stud_Id,Speciality_Id),
  CONSTRAINT Ams_Stud_Plan_Plan_FK         Foreign Key (Plan_Id )           References Ams_Plan             (Id),
  CONSTRAINT Ams_Stud_Plan_Stud_FK         Foreign Key (Stud_Id)            References Ams_Stud             (Id), 
  CONSTRAINT Ams_Stud_Plan_Colleg_FK       Foreign Key (Colleg_Id)          References Ams_College          (Id),
  CONSTRAINT Ams_Stud_Plan_Section_FK      Foreign Key (Section_Id)         References Ams_Sec              (Id),
  CONSTRAINT Ams_Stud_Plan_Speciality_FK   Foreign Key (Speciality_Id)      References Ams_Spec             (Id),
  CONSTRAINT Ams_Stud_Plan_ExamLmt_FK      Foreign Key (ExamLmt_Id)         References Ams_Exam_Lmt         (Id),
  CONSTRAINT Ams_Stud_Plan_Degreelmt_FK    Foreign Key (Degreelmt_Id)       References Ams_Degree_Lmt       (Id),
  CONSTRAINT Ams_Stud_Plan_Gpalmt_FK       Foreign Key (Gpalmt_Id)          References Ams_GPA_Lmt          (Id),
  CONSTRAINT Ams_Stud_Plan_Yearlmt_FK      Foreign Key (Yearlmt_Id)         References Ams_Year_Lmt         (Id),
  CONSTRAINT Ams_Stud_Plan_Gradlevellmt_FK Foreign Key (Gradlevellmt_Id)    References Ams_Grad_Level_Lmt   (Id),
  CONSTRAINT Ams_Stud_Plan_Price_FK        Foreign Key (Price_Id)           References Ams_Price            (Id),
  CONSTRAINT Ams_Stud_Plan_isNational_FK   Foreign Key (isNational_Exam_Id) References Ams_Cod_NExam_Status (Id),
  CONSTRAINT Ams_Stud_Plan_Ins_FK          Foreign Key (Ins_User)           References Cpy_User             (Id),
  CONSTRAINT Ams_Stud_Plan_Upd_FK          Foreign Key (Upd_User)           References Cpy_User             (Id)
)
/
Create Synonym Ams_Stud_Plan For Ams_Student_Plan
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Room_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Rooms                           -- جدول القعات
( Id         Number(5) NOT NULL,                 -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                -- حالة 
  Num        Varchar2(100 Char) NOT NULL,        -- الرقم
  Name       Varchar2(256 Char) NOT NULL,        -- الاسم
  Capacity   Varchar2(3) NOT NULL,               -- السعة
  Location   Varchar2(100 Char),                 -- ملاحظات
  Rem        Varchar2(100 Char),                 -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Room_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Room_UK         UNIQUE      (Num),
  CONSTRAINT Ams_Room_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Room_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_Room_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_Room For Ams_Rooms
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_AClass_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Academic_Class                  -- جدول الشعب الدراسية
( Id         Number(11) NOT NULL,                -- مفتاح رئيسي
  aTerm_Id   Number(3) NOT NULL,                 -- الفصل الاكاديمي
  Teacher_Id Number(11) NOT NULL,                -- المدرس
  Item_Id    Number(5) NOT NULL,                 -- المادة 
  Status_Id  Number(1) Default 1,                -- حالة 
  Name       Varchar2(256 Char) NOT NULL,        -- الاسم
  capacity   Varchar2(3 Char) NOT NULL,          -- السعة
  Rem        Varchar2(100 Char),                 -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_AClass_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_AClass_UK         UNIQUE      (Name, aTerm_Id, Item_Id),
  CONSTRAINT Ams_AClass_aTerm_FK   Foreign Key (aTerm_Id)   References Ams_ATerm      (Id),
  CONSTRAINT Ams_AClass_Teacher_FK Foreign Key (Teacher_Id) References Ams_Teacher    (Id),
  CONSTRAINT Ams_AClass_Item_FK    Foreign Key (Item_Id)    References Ams_Item       (Id),
  CONSTRAINT Ams_AClass_Status_FK  Foreign Key (Status_Id)  References Phs_Cod_Status (Id),
  CONSTRAINT Ams_AClass_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_AClass_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_AClass For Ams_Academic_Class
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_AClass_Day_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Academic_Class_Day           -- جدول أيام الشعب الدراسية
( Id       Number(11) NOT NULL,               -- مفتاح رئيسي
  Mst_Id   Number(11) NOT NULL,               -- مفتاح الأب
  Day_Id   Number(1) NOT NULL,                -- اليوم
  Room_Id  Number(5) DEFAULT 1 NOT NULL,      -- القاعة
  SHour    Number(2) DEFAULT 8 NOT NULL,      -- ساعة البداية 
  SMinute  Number(2) DEFAULT 0 NOT NULL,      -- دقيقة البداية
  EHour    Number(2) DEFAULT 0 NOT NULL,      -- ساعة النهاية
  EMinute  Number(2) DEFAULT 0 NOT NULL,      -- دقيقة النهاية
  Rem      Varchar2(100 Char),                -- ملاحظات
  Ins_User Number(5),  Ins_Date    Date,
  Upd_User Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_AClass_Day_PK       PRIMARY KEY (Id), 
  CONSTRAINT Ams_AClass_Day_UK       UNIQUE      (Mst_Id, Day_Id),
  CONSTRAINT Ams_AClass_Day_Class_FK Foreign Key (Mst_Id)   References Ams_AClass   (Id),
  CONSTRAINT Ams_AClass_Day_Day_FK   Foreign Key (Day_Id)   References Phs_Cod_WDay (Id),
  CONSTRAINT Ams_AClass_Day_Room_FK  Foreign Key (Room_Id)  References Ams_Room     (Id),
  CONSTRAINT Ams_AClass_Day_Ins_FK   Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Ams_AClass_Day_Upd_FK   Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Ams_AClass_Day For Ams_Academic_Class_Day
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_AClass_Attend_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Academic_Class_Attendns        -- جدول حضور الشعب الدراسية
( Id         Number(11) NOT NULL,               -- مفتاح رئيسي
  aClass_Id  Number(11) NOT NULL,               -- الشعبة الدراسية
  dDate      Date Default sysdate,              -- التاريخ
  Rem        Varchar2(100 Char),                -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_AClass_Attend_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_AClass_Attend_UK         UNIQUE      (dDate, aClass_Id),
  CONSTRAINT Ams_AClass_Attend_AClass_FK  Foreign Key (aClass_Id)  References Ams_AClass (Id),
  CONSTRAINT Ams_AClass_Attend_Ins_FK     Foreign Key (Ins_User)   References Cpy_User   (Id),
  CONSTRAINT Ams_AClass_Attend_Upd_FK     Foreign Key (Upd_User)   References Cpy_User   (Id)
)
/
Create Synonym Ams_AClass_Attend For Ams_Academic_Class_Attendns
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_AClass_Attend_Trn_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Academic_Class_Attendns_Trans         -- جدول بنود حضور الشعب الدراسية
( Id         Number(11) NOT NULL,                      -- مفتاح رئيسي
  Mst_Id     Number(11) NOT NULL,                      -- مفتاح الأب
  Stud_Id    Number(11) NOT NULL,                      -- الطالب
  Status_Id  Number(1) Default 1,                      -- حالة 
  Reason     Varchar2(100 Char),                       -- السبب
  Rem        Varchar2(100 Char),                       -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_AClass_Attend_Trn_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_AClass_Attend_Trn_UK         UNIQUE      (Mst_Id, Stud_Id),
  CONSTRAINT Ams_AClass_Attend_Trn_Mst_FK     Foreign Key (Mst_Id)    References Ams_AClass_Attend  (Id),
  CONSTRAINT Ams_AClass_Attend_Trn_Teacher_FK Foreign Key (Stud_Id)   References Ams_Stud           (Id),
  CONSTRAINT Ams_AClass_Attend_Trn_Status_FK  Foreign Key (Status_Id) References Phs_Cod_YesNo      (Id),
  CONSTRAINT Ams_AClass_Attend_Trn_Ins_FK     Foreign Key (Ins_User)  References Cpy_User           (Id),
  CONSTRAINT Ams_AClass_Attend_Trn_Upd_FK     Foreign Key (Upd_User)  References Cpy_User           (Id)
)
/
Create Synonym Ams_AClass_Attend_Trn For Ams_Academic_Class_Attendns_Trans
/
 
------------------------------------------------------------------------------------------------------
Create Sequence Ams_AClass_Dep_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Academic_Class_Deprivation     -- جدول حرمان الشعب الدراسية
( Id         Number(11) NOT NULL,               -- مفتاح رئيسي
  aClass_Id  Number(11) NOT NULL,               -- الشعبة الدراسية
  Num        Varchar2(100 Char),                -- الرفم
  dDate      Date Default sysdate,              -- التاريخ
  Rem        Varchar2(100 Char),                -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_AClass_Dep_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_AClass_Dep_UK         UNIQUE      (Num, aClass_Id),
  CONSTRAINT Ams_AClass_Dep_AClass_FK  Foreign Key (aClass_Id)  References Ams_AClass     (Id),
  CONSTRAINT Ams_AClass_Dep_Ins_FK     Foreign Key (Ins_User)   References Cpy_User       (Id),
  CONSTRAINT Ams_AClass_Dep_Upd_FK     Foreign Key (Upd_User)   References Cpy_User       (Id)
)
/
Create Synonym Ams_AClass_Dep For Ams_Academic_Class_Deprivation
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_AClass_Dep_Trn_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Academic_Class_Deprivation_Trans      -- جدول بنود حرمان الشعب الدراسية
( Id         Number(11) NOT NULL,                       -- مفتاح رئيسي
  Mst_Id     Number(11) NOT NULL,                       -- مفتاح الأب
  Stud_Id    Number(11) NOT NULL,                       -- الطالب
  Reason     Varchar2(100 Char),                        -- السبب
  Rem        Varchar2(100 Char),                        -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_AClass_Dep_Trn_PK      PRIMARY KEY (Id), 
  CONSTRAINT Ams_AClass_Dep_Trn_UK      UNIQUE      (Mst_Id, Stud_Id),
  CONSTRAINT Ams_AClass_Dep_Trn_Mst_FK  Foreign Key (Mst_Id)   References Ams_AClass_Attend  (Id),
  CONSTRAINT Ams_AClass_Dep_Trn_Stud_FK Foreign Key (Stud_Id)  References Ams_Stud           (Id),
  CONSTRAINT Ams_AClass_Dep_Trn_Ins_FK  Foreign Key (Ins_User) References Cpy_User           (Id),
  CONSTRAINT Ams_AClass_Dep_Trn_Upd_FK  Foreign Key (Upd_User) References Cpy_User           (Id)
)
/
Create Synonym Ams_AClass_Dep_Trn For Ams_Academic_Class_Deprivation_Trans
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_AClass_Nomination_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Academic_Class_Nomination      -- جدول الترشيح للامتحان
( Id         Number(11) NOT NULL,               -- مفتاح رئيسي
  aClass_Id  Number(11) NOT NULL,               -- الشعبة الدراسية
  dDate      Date Default sysdate,              -- التاريخ
  Mark4_Min  Number(6,2) DEFAULT 0.00 NOT NULL, -- Mark 4 Minimum Required Percentage
  Rem        Varchar2(100 Char),                -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_AClass_Nomination_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_AClass_Nomination_UK         UNIQUE      (aClass_Id),
  CONSTRAINT Ams_AClass_Nomination_AClass_FK  Foreign Key (aClass_Id)  References Ams_AClass (Id),
  CONSTRAINT Ams_AClass_Nomination_Ins_FK     Foreign Key (Ins_User)   References Cpy_User   (Id),
  CONSTRAINT Ams_AClass_Nomination_Upd_FK     Foreign Key (Upd_User)   References Cpy_User   (Id)
)
/
Create Synonym Ams_AClass_Nomination For Ams_Academic_Class_Nomination
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_AClass_Nomination_Trn_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Academic_Class_Nomination_Trans    -- جدول بنود لترشيح للامتحان
( Id         Number(11) NOT NULL,                   -- مفتاح رئيسي
  Mst_Id     Number(11) NOT NULL,                   -- مفتاح الأب
  Stud_Id    Number(11) NOT NULL,                   -- الطالب
  Status_Id  Number(1)  Default 1,                  -- حالة 
  Mark1      Number(5,2) DEFAULT 0.00 NOT NULL,     -- العلامة 1
  Mark2      Number(5,2) DEFAULT 0.00 NOT NULL,     -- العلامة 2
  Mark3      Number(5,2) DEFAULT 0.00 NOT NULL,     -- العلامة 3
  Mark4      Number(5,2) DEFAULT 0.00 NOT NULL,     -- العلامة 4
  Reason     Varchar2(100 Char),                    -- السبب
  Rem        Varchar2(100 Char),                    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_AClass_Nomination_Trn_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_AClass_Nomination_Trn_UK         UNIQUE      (Mst_Id, Stud_Id),
  CONSTRAINT Ams_AClass_Nomination_Trn_Mst_FK     Foreign Key (Mst_Id)    References Ams_AClass_Attend  (Id),
  CONSTRAINT Ams_AClass_Nomination_Trn_Teacher_FK Foreign Key (Stud_Id)   References Ams_Stud           (Id),
  CONSTRAINT Ams_AClass_Nomination_Trn_Status_FK  Foreign Key (Status_Id) References Phs_Cod_YesNo      (Id),
  CONSTRAINT Ams_AClass_Nomination_Trn_Ins_FK     Foreign Key (Ins_User)  References Cpy_User           (Id),
  CONSTRAINT Ams_AClass_Nomination_Trn_Upd_FK     Foreign Key (Upd_User)  References Cpy_User           (Id)
)
/
Create Synonym Ams_AClass_Nomination_Trn For Ams_Academic_Class_Nomination_Trans
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Stud_Trans_Item_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Student_Transfer_Item          -- جدول المواد المعادلة
( Id        Number(11) NOT NULL,                 -- مفتاح رئيسي
  ATerm_Id  Number(3) NOT NULL,                  -- الفصل الاكاديمي
  Stud_Id   Number(11) NOT NULL,                 -- الطالب 
  PItem_Id  Number(11) NOT NULL,                 -- مادة خطة
  Num       Varchar2(100 Char),                  -- الرفم
  dDate     Date Default sysdate,                -- التاريخ
  Rem       Varchar2(100 Char),                  -- ملاحظات
  Ins_User  Number(5),  Ins_Date    Date,
  Upd_User  Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Stud_Trans_Item_PK           PRIMARY KEY (Id), 
  CONSTRAINT Ams_Stud_Trans_Item_UK           UNIQUE      (Stud_Id, PItem_Id),
  CONSTRAINT Ams_Stud_Trans_Item_Term_FK      Foreign Key (ATerm_Id) References Ams_ATerm   (Id),
  CONSTRAINT Ams_Stud_Trans_Item_Stud_FK      Foreign Key (Stud_Id)  References Ams_Stud    (Id),
  CONSTRAINT Ams_Stud_Trans_Item_Plan_Item_FK Foreign Key (PItem_Id) References Ams_PItem   (Id),
  CONSTRAINT Ams_Stud_Trans_Item_Ins_FK       Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Ams_Stud_Trans_Item_Upd_FK       Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym Ams_Stud_Trans_Item For Ams_Student_Transfer_Item
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Stud_Withdraw_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Student_Withdraw_Item            -- جدول المواد المعادلة
( Id        Number(11) NOT NULL,                  -- مفتاح رئيسي
  ATerm_Id  Number(3) NOT NULL,                   -- الفصل الاكاديمي
  Stud_Id   Number(11) NOT NULL,                  -- الطالب 
  AClass_Id Number(11) NOT NULL,                  -- الصف الدراسي
  Num       Varchar2(100 Char),                   -- الرفم
  dDate     Date Default sysdate,                 -- التاريخ
  Rem       Varchar2(100 Char),                   -- ملاحظات
  Ins_User  Number(5),  Ins_Date    Date,
  Upd_User  Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Stud_Withdraw_PK        PRIMARY KEY (Id), 
  CONSTRAINT Ams_Stud_Withdraw_UK        UNIQUE      (Stud_Id, AClass_Id),
  CONSTRAINT Ams_Stud_Withdraw_Term_FK   Foreign Key (ATerm_Id)  References Ams_ATerm      (Id),
  CONSTRAINT Ams_Stud_Withdraw_Stud_FK   Foreign Key (Stud_Id)   References Ams_Stud       (Id),
  CONSTRAINT Ams_Stud_Withdraw_AClass_FK Foreign Key (AClass_Id) References Ams_AClass_Day (Id),
  CONSTRAINT Ams_Stud_Withdraw_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Stud_Withdraw_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Stud_Withdraw For Ams_Student_Withdraw_Item
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Grad_Ord_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Graduation_Order                 -- جدول قرارات التخرج
( Id            Number(11) NOT NULL,              -- مفتاح رئيسي
  ATerm_Id      Number(3) NOT NULL,               -- الفصل الاكاديمي
  Num           Varchar2(100 Char),               -- الرفم
  dDate         Date Default sysdate,             -- التاريخ
  Rem           Varchar2(100 Char),               -- ملاحظات
  Ins_User      Number(5),  Ins_Date    Date,
  Upd_User      Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Grad_Ord_PK           PRIMARY KEY (Id), 
  CONSTRAINT Ams_Grad_Ord_UK           UNIQUE      (Num, ATerm_Id),
  CONSTRAINT Ams_Grad_Ord_ATerm_FK     Foreign Key (ATerm_Id)     References Ams_ATerm   (Id),
  CONSTRAINT Ams_Grad_Ord_Ins_FK       Foreign Key (Ins_User)     References Cpy_User    (Id),
  CONSTRAINT Ams_Grad_Ord_Upd_FK       Foreign Key (Upd_User)     References Cpy_User    (Id)
)
/
Create Synonym Ams_Grad_Ord For Ams_Graduation_Order
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Grad_Ord_Trn_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Graduation_Order_Trans             -- جدول بنود قرارات التخرج
( Id             Number(5) NOT NULL,                -- مفتاح رئيسي
  Mst_Id         Number(3) NOT NULL,                -- مفتاح الأب
  Stud_Id        Number(11) NOT NULL,               -- الطالب 
  Trn_Level_Id   Number(5) NOT NULL,                -- درجة التخرج 
  Gpa_Percentage Number(5,2) DEFAULT 0.00 NOT NULL, -- النسبة المئوية للمعدل التراكمي
  Gpa            Number(5,2) DEFAULT 0.00 NOT NULL, --  المعدل التراكمي
  Rem            Varchar2(100 Char),                -- ملاحظات
  Ins_User       Number(5),  Ins_Date Date,
  Upd_User       Number(5),  Upd_Date Date,
  CONSTRAINT Ams_Grad_Ord_Trn_PK       PRIMARY KEY (Id), 
  CONSTRAINT Ams_Grad_Ord_Trn_UK       UNIQUE      (Stud_Id),
  CONSTRAINT Ams_Grad_Ord_Trn_Mst_FK   Foreign Key (Mst_Id)       References Ams_Grad_Ord           (Id),
  CONSTRAINT Ams_Grad_Ord_Trn_Stud_FK  Foreign Key (Stud_Id)      References Ams_Stud               (Id),
  CONSTRAINT Ams_Grad_Ord_Trn_Level_FK Foreign Key (Trn_Level_Id) References Ams_Grad_Level_Lmt_Trn (Id),
  CONSTRAINT Ams_Grad_Ord_Trn_Ins_FK   Foreign Key (Ins_User)     References Cpy_User               (Id),
  CONSTRAINT Ams_Grad_Ord_Trn_Upd_FK   Foreign Key (Upd_User)     References Cpy_User               (Id)
)
/
Create Synonym Ams_Grad_Ord_Trn For Ams_Graduation_Order_Trans
/ 

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Ord_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Order                            -- جدول القرارات الإدارية
( Id            Number(11) NOT NULL,              -- مفتاح رئيسي
  ATerm_Id      Number(3) NOT NULL,               -- الفصل الاكاديمي
  Type_Id       Number(3) NOT NULL,               -- نوع القرار
  Num           Varchar2(100 Char),               -- الرفم
  dDate         Date Default sysdate,             -- التاريخ
  Rem           Varchar2(100 Char),               -- ملاحظات
  Ins_User      Number(5),  Ins_Date    Date,
  Upd_User      Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Ord_PK       PRIMARY KEY (Id), 
  CONSTRAINT Ams_Ord_UK       UNIQUE      (Num, ATerm_Id),
  CONSTRAINT Ams_Ord_ATerm_FK Foreign Key (ATerm_Id) References Ams_ATerm          (Id),
  CONSTRAINT Ams_Ord_Type_FK  Foreign Key (Type_Id ) References Ams_Cod_Order_Type (Id),
  CONSTRAINT Ams_Ord_Ins_FK   Foreign Key (Ins_User) References Cpy_User           (Id),
  CONSTRAINT Ams_Ord_Upd_FK   Foreign Key (Upd_User) References Cpy_User           (Id)
)
/
Create Synonym Ams_Ord For Ams_Order
/

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Ord_Trn_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Order_Trans                  -- جدول بنود القرارات الإدارية
( Id         Number(11) NOT NULL,             -- مفتاح رئيسي
  Mst_Id     Number(3) NOT NULL,              -- مفتاح الأب
  Stud_Id    Number(11) NOT NULL,             -- الطالب 
  Descrption Varchar2(256 Char),              -- الوصف
  Rem        Varchar2(100 Char),              -- ملاحظات
  Ins_User   Number(5),  Ins_Date Date,
  Upd_User   Number(5),  Upd_Date Date,
  CONSTRAINT Ams_Ord_Trn_PK      PRIMARY KEY (Id), 
  CONSTRAINT Ams_Ord_Trn_UK      UNIQUE      (Stud_Id),
  CONSTRAINT Ams_Ord_Trn_Mst_FK  Foreign Key (Mst_Id)   References Ams_Ord  (Id),
  CONSTRAINT Ams_Ord_Trn_Stud_FK Foreign Key (Stud_Id)  References Ams_Stud (Id),
  CONSTRAINT Ams_Ord_Trn_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT Ams_Ord_Trn_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym Ams_Ord_Trn For Ams_Order_Trans
/ 

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Stud_Reg_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Student_Registration               -- جدول تسجيل الطلاب
( Id         Number(11) NOT NULL,                   -- مفتاح رئيسي
  ATerm_Id   Number(3) NOT NULL,                    -- الفصل الدراسي
  Stud_Id    Number(11) NOT NULL,                   -- الطالب 
  Price_Id   Number(3) NOT NULL,                    -- الاسعار 
  FStatus_Id Number(11) DEFAULT 1 NOT NULL,         --Finance Status, 1 Not Paid, 2 Paid
  Status_Id  Number(11) DEFAULT 1 NOT NULL,         --Status, 1 New, 2 Finished, 3 Conditional
  Term_Gpa   Number(5,2) DEFAULT 0.00 NOT NULL,     -- المعدل الفصلي
  Total_Gpa  Number(5,2) DEFAULT 0.00 NOT NULL,     -- المعدل التراكمي
  dDate      Date Default sysdate,                  -- التاريخ
  SRem       Varchar2(100 Char),                    -- ملاحظات الطالب
  Rem        Varchar2(100 Char),                    -- ملاحظات
  Ins_User   Number(5),  Ins_Date Date,
  Upd_User   Number(5),  Upd_Date Date,
  CONSTRAINT Ams_Stud_Reg_PK       PRIMARY KEY (Id), 
  CONSTRAINT Ams_Stud_Reg_UK       UNIQUE      (ATerm_Id,Stud_Id),
  CONSTRAINT Ams_Stud_Reg_ATerm_FK Foreign Key (ATerm_Id) References Ams_ATerm (Id),
  CONSTRAINT Ams_Stud_Reg_Stud_FK  Foreign Key (Stud_Id)  References Ams_Stud  (Id),
  CONSTRAINT Ams_Stud_Reg_Price_FK Foreign Key (Price_Id) References Ams_Price (Id),
  CONSTRAINT Ams_Stud_Reg_Ins_FK   Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT Ams_Stud_Reg_Upd_FK   Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym Ams_Stud_Reg For Ams_Student_Registration
/ 

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Stud_Reg_Item_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Student_Registration_Item          -- جدول تسجيل الطلاب
( Id            Number(11) NOT NULL,                -- مفتاح رئيسي
  Mst_Id        Number(11) NOT NULL,                --  مفتاح الأب
  PItem_Id      Number(11) NOT NULL,                -- مادة خطة دراسية 
  AClass_Id     Number(11) NOT NULL,                -- الشعبة الدراسية 
  TrnDegree_Id  Number(3) NOT NULL,                 -- بند حدود الدرجات 
  Mark1         Number(5,2) DEFAULT 0.00 NOT NULL,  -- العلامة 1
  Mark2         Number(5,2) DEFAULT 0.00 NOT NULL,  -- العلامة 2
  Mark3         Number(5,2) DEFAULT 0.00 NOT NULL,  -- العلامة 3
  Mark4         Number(5,2) DEFAULT 0.00 NOT NULL,  -- العلامة 4
  Mark5         Number(5,2) DEFAULT 0.00 NOT NULL,  -- العلامة 5
  Rem           Varchar2(100 Char),                  -- ملاحظات
  Ins_User      Number(5),  Ins_Date Date,
  Upd_User      Number(5),  Upd_Date Date,
  CONSTRAINT Ams_Stud_Reg_Item_PK           PRIMARY KEY (Id), 
  CONSTRAINT Ams_Stud_Reg_Item_UK           UNIQUE      (Mst_Id,PItem_Id),
  CONSTRAINT Ams_Stud_Reg_Item_Reg_FK       Foreign Key (Mst_Id)       References Ams_Stud_Reg       (Id),
  CONSTRAINT Ams_Stud_Reg_Item_Plan_Item_FK Foreign Key (PItem_Id)     References Ams_PItem          (Id),
  CONSTRAINT Ams_Stud_Reg_Item_AClass_FK    Foreign Key (AClass_Id)    References Ams_AClass         (Id),
  CONSTRAINT Ams_Stud_Reg_Item_TrnDegree_FK Foreign Key (TrnDegree_Id) References Ams_Degree_Lmt_Trn (Id),
  CONSTRAINT Ams_Stud_Reg_Item_Ins_FK       Foreign Key (Ins_User)     References Cpy_User           (Id),
  CONSTRAINT Ams_Stud_Reg_Item_Upd_FK       Foreign Key (Upd_User)     References Cpy_User           (Id)
)
/
Create Synonym Ams_Stud_Reg_Item For Ams_Student_Registration_Item
/ 

------------------------------------------------------------------------------------------------------

Create Sequence Ams_Lib_Author_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Library_Authors                           -- جدول المؤلفون
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة 
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Lib_Author_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Lib_Author_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Lib_Author_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Lib_Author_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Lib_Author_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Lib_Author For Ams_Library_Authors
/
------------------------------------------------------------------------------------------------------
Create Sequence Ams_Lib_Category_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Library_Categories                        -- جدول الفئات
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة 
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Lib_Category_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Lib_Category_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Lib_Category_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Lib_Category_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Lib_Category_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Lib_Category For Ams_Library_Categories
/
------------------------------------------------------------------------------------------------------
Create Sequence Ams_Lib_Publisher_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Library_Publishers                   -- جدول الناشرون
( Id        Number(5) NOT NULL,                       -- مفتاح رئيسي
  Status_Id Number(1) Default 1,                      -- حالة  
  Name      Varchar2(200 Char) NOT NULL,              -- الاسم 
  Rem       Varchar2(100 Char),                       -- ملاحظات
  Ins_User  Number(5),  Ins_Date    Date,
  Upd_User  Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Lib_Publisher_PK         PRIMARY KEY (Id), 
  CONSTRAINT Ams_Lib_Publisher_UK         UNIQUE      (Name),
  CONSTRAINT Ams_Lib_Publisher_Status_FK  Foreign Key (Status_Id) References Phs_Cod_Status (Id), 
  CONSTRAINT Ams_Lib_Publisher_Ins_FK     Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT Ams_Lib_Publisher_Upd_FK     Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym Ams_Lib_Publisher For Ams_Library_Publishers
/
------------------------------------------------------------------------------------------------------
Create Sequence Ams_Lib_Document_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Library_Documents                        -- جدول الكتب
( Id           Number(11) NOT NULL,                       -- مفتاح رئيسي
  Status_Id    Number(1) Default 1,                       -- حالة 
  Publisher_Id Number(5) NOT NULL,                        -- Publisher
  Author_Id    Number(5) NOT NULL,                        -- Author
  Type_Id      Number(5) NOT NULL,                        -- Type
  Category_Id  Number(5) NOT NULL,                        -- Category
  IsEbook_Id   Number(1) DEFAULT 2 NOT NULL,              -- Is EBook
  IsHbook_Id   Number(1) DEFAULT 1 NOT NULL,              -- is a Hard copy
  Title        Varchar2(200 Char) NOT NULL,               -- Title
  Qnt          Number(4) DEFAULT 1 NOT NULL,              -- Copies
  cQnt         Number(4) DEFAULT 1 NOT NULL,              -- Available Copies
  Rem          Varchar2(100 Char),                        -- ملاحظات
  Ins_User     Number(5),  Ins_Date    Date,
  Upd_User     Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Lib_Document_PK           PRIMARY KEY (Id), 
  CONSTRAINT Ams_Lib_Document_Status_FK    Foreign Key (Status_Id)    References Phs_Cod_Status    (Id),
  CONSTRAINT Ams_Lib_Document_Publisher_FK Foreign Key (Publisher_Id) References Ams_Lib_Publisher (Id),
  CONSTRAINT Ams_Lib_Document_Author_FK    Foreign Key (Author_Id)    References Ams_Lib_Author    (Id),
  CONSTRAINT Ams_Lib_Document_Type_FK      Foreign Key (Type_id)      References Ams_Lib_Cod_Type  (Id),
  CONSTRAINT Ams_Lib_Document_Category_FK  Foreign Key (Category_Id)  References Ams_Lib_Category  (Id),
  CONSTRAINT Ams_Lib_Document_IsEbook_FK   Foreign Key (IsEbook_Id)   References Phs_Cod_YesNo     (Id),
  CONSTRAINT Ams_Lib_Document_IsHbook_FK   Foreign Key (IsHbook_Id)   References Phs_Cod_YesNo     (Id),
  CONSTRAINT Ams_Lib_Document_Ins_FK       Foreign Key (Ins_User)     References Cpy_User          (Id),
  CONSTRAINT Ams_Lib_Document_Upd_FK       Foreign Key (Upd_User)     References Cpy_User          (Id)
)
/
Create Synonym Ams_Lib_Document For Ams_Library_Documents
/
