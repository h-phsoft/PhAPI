--set Pagesize 1000
--select 'Drop Table '   || table_name    ||                       ';' from user_tables    where Table_name    like 'AMS%' ;
--select 'Drop Synonym ' || Synonym_name  ||                       ';' from user_Synonyms  where Synonym_name  like 'AMS%' ;
--select 'Drop Sequence '|| Sequence_name ||                       ';' from user_Sequences where Sequence_name like 'AMS%' ;
--select 'Drop View '    || View_name     ||                       ';' from user_Views     where View_name     like 'AMS%' ;
----------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Nat_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Nationality                          -- جدول ترميز الجنسيات
( Id         Number(3) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Nat_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Nat_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Nat_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Nat_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Nat_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Nat For Ams_Code_Nationality;
/

Insert into Ams_Cod_nat (Id, Name, Rem) values (1, 'عربي سوري', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (2, 'فلسطيني', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (3, 'فلسطيني - مقيم', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (4, 'عراقي', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (5, 'أردني', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (6, 'يمني', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (7, 'مصري', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (8, 'لبناني', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (9, 'صربي', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (10, 'سعودي', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (11, 'اجنبي', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (12, 'غير محدد', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (13, 'مغربي', NULL);
Insert into Ams_Cod_nat (Id, Name, Rem) values (14, 'عربي سوري - مكتوم', NULL);

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Order_Type_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Order_Type                          -- جدول ترميز انواع القرارات الإدارية
( Id         Number(3) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات / الحالة الاكادمية للطالب
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Order_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Order_Type_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Order_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Order_Type_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Order_Type_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Order_Type For Ams_Code_Order_Type;
/

Insert into Ams_Cod_Order_Type (Id, Name, Rem) values (0, '-', NULL);
Insert into Ams_Cod_Order_Type (Id, Name, Rem) values (1, 'إعادة انتساب', '1');
Insert into Ams_Cod_Order_Type (Id, Name, Rem) values (2, 'فصل', '5');
Insert into Ams_Cod_Order_Type (Id, Name, Rem) values (3, 'ايقاف تسجيل', '8');
Insert into Ams_Cod_Order_Type (Id, Name, Rem) values (4, 'قيد مرقن', '6');

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_AStatus_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Academic_Status                      -- جدول ترميز الحالات الاكادمية
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_AStatus_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_AStatus_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_AStatus_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_AStatus_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_AStatus_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_AStatus For Ams_Code_Academic_Status;
/

Insert into Ams_Cod_AStatus (Id, Name, Rem) values (0, '-', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (1, 'مستمر', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (2, 'غير مستمر', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (3, 'منسحب', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (4, 'متخرج', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (5, 'مفصول', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (6, 'قيد مرقن', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (7, 'فصل مؤقت', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (8, 'ايقاف تسجيل', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (9, 'مؤجل', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (10, 'منتقل', NULL);
Insert into Ams_Cod_AStatus (Id, Name, Rem) values (11, 'قيد التخرج', NULL);

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Mark_Type_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Mark_Type                            -- جدول ترميز انواع العلامات
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Mark_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Mark_Type_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Mark_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Mark_Type_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Mark_Type_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Mark_Type For Ams_Code_Mark_Type;
/
 
Insert into Ams_Cod_Mark_Type (Id, Name, Rem) values (1, '1st Exam', NULL);
Insert into Ams_Cod_Mark_Type (Id, Name, Rem) values (2, '2nd Exam', NULL);
Insert into Ams_Cod_Mark_Type (Id, Name, Rem) values (3, '3rd Exam', NULL);
Insert into Ams_Cod_Mark_Type (Id, Name, Rem) values (4, 'Work Degree', NULL);
Insert into Ams_Cod_Mark_Type (Id, Name, Rem) values (5, 'Final Exam', NULL);

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Fee_Type_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Fee_Type                             -- جدول ترميز انواع الرسوم
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Fee_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Fee_Type_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Fee_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Fee_Type_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Fee_Type_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Fee_Type For Ams_Code_Fee_Type;
/
 
Insert into Ams_Cod_Fee_Type (Id, Name, Rem) values (1, 'Fee', NULL);
Insert into Ams_Cod_Fee_Type (Id, Name, Rem) values (2, 'Discount', NULL);

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Collection_Type_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Fee_Collection_Type                  -- جدول عدد مرات تحصيل الرسوم   
( Id         Number(2) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Collection_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Collection_Type_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Collection_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Collection_Type_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Collection_Type_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Collection_Type For Ams_Code_Fee_Collection_Type;
/
  
Insert into Ams_Cod_Collection_Type (Id, Name, Rem) values (1, 'One Time', NULL);
Insert into Ams_Cod_Collection_Type (Id, Name, Rem) values (2, 'Per Year', NULL);
Insert into Ams_Cod_Collection_Type (Id, Name, Rem) values (3, 'Per Term', NULL);
Insert into Ams_Cod_Collection_Type (Id, Name, Rem) values (4, 'Per Item', NULL);
Insert into Ams_Cod_Collection_Type (Id, Name, Rem) values (5, 'Per 1st Term', NULL);
Insert into Ams_Cod_Collection_Type (Id, Name, Rem) values (6, 'Per 2nd Term', NULL);
Insert into Ams_Cod_Collection_Type (Id, Name, Rem) values (7, 'Per 3rd Term', NULL);

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Item_Force_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Item_Force                           -- جدول انواع المواد   
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Item_Force_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Item_Force_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Item_Force_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Item_Force_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Item_Force_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Item_Force For Ams_Code_Item_Force;
/
  
Insert into Ams_Cod_Item_Force (Id, Name, Rem) values (1, 'اجباري', NULL);
Insert into Ams_Cod_Item_Force (Id, Name, Rem) values (2, 'اختياري', NULL); 
Insert into Ams_Cod_Item_Force (Id, Name, Rem) values (3, 'بند اختياري', NULL); 

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Item_Kind_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Item_Kind                            -- جدول انواع المواد   
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Item_Kind_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Item_Kind_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Item_Kind_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Item_Kind_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Item_Kind_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Item_Kind For Ams_Code_Item_Kind;
/
  
Insert into Ams_Cod_Item_Kind (Id, Name, Rem) values (1, 'عادي', NULL);
Insert into Ams_Cod_Item_Kind (Id, Name, Rem) values (2, 'تابع لمتطلب', NULL); 

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Item_Order_Type_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Item_Order_Type                      -- جدول انواع المواد   
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Item_Order_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Item_Order_Type_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Item_Order_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Item_Order_Type_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Item_Order_Type_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Item_Order_Type For Ams_Code_Item_Order_Type;
/
  
Insert into Ams_Cod_Item_Order_Type (Id, Name, Rem) values (1, 'عادي', NULL);
Insert into Ams_Cod_Item_Order_Type (Id, Name, Rem) values (2, 'تابع لمتطلب', NULL);  

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_NExam_Status_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_National_Exam_Status                 -- جدول حالة الامتحان الوطني   
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_NExam_Status_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_NExam_Status_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_NExam_Status_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_NExam_Status_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_NExam_Status_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_NExam_Status For Ams_Code_National_Exam_Status;
/
  
Insert into Ams_Cod_NExam_Status (Id, Name, Rem) values (1, 'لايوجد', NULL);
Insert into Ams_Cod_NExam_Status (Id, Name, Rem) values (2, 'غير منجز', NULL);
Insert into Ams_Cod_NExam_Status (Id, Name, Rem) values (3, 'ناجح', NULL);

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Stud_Classif_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Student_Classification               -- جدول تصنيف الطلاب   
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Stud_Classif_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Stud_Classif_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Stud_Classif_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Stud_Classif_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Stud_Classif_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Stud_Classif For Ams_Code_Student_Classification;
/
  
Insert into Ams_Cod_Stud_Classif (Id, Name, Rem) values (1, 'سوري مقيم', NULL);
Insert into Ams_Cod_Stud_Classif (Id, Name, Rem) values (2, 'سوري غير مقيم', NULL);
Insert into Ams_Cod_Stud_Classif (Id, Name, Rem) values (3, 'عرب و اجانب', NULL);

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Stud_Adjc_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Student_Adjective                -- جدول صفة الطلاب   
( Id         Number(1) NOT NULL,                       -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                      -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,              -- الاسم
  Rem        Varchar2(100 Char),                       -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Stud_Adjc_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Stud_Adjc_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Stud_Adjc_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Stud_Adjc_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Stud_Adjc_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Stud_Adjc For Ams_Code_Student_Adjective;
/
  
Insert into Ams_Cod_Stud_Adjc (Id, Name, Rem) values (1, 'منتظم', '');
Insert into Ams_Cod_Stud_Adjc (Id, Name, Rem) values (2, 'منح وزارة التعليم', '');
Insert into Ams_Cod_Stud_Adjc (Id, Name, Rem) values (3, 'تحويل مماثل', NULL);
Insert into Ams_Cod_Stud_Adjc (Id, Name, Rem) values (4, 'تغيير قيد', NULL);
Insert into Ams_Cod_Stud_Adjc (Id, Name, Rem) values (5, 'اجازة - معهد', '');

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_City_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_City                         -- جدول المدن   
( Id         Number(3) NOT NULL,                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                  -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,          -- الاسم
  Rem        Varchar2(100 Char),                   -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_City_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_City_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_City_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_City_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_City_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_City For Ams_Code_City;
/
  
Insert into Ams_Cod_City (Id, Name, Rem) values (1, 'دمشق', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (2, 'حمص', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (3, 'حلب', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (4, 'الرقة', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (5, 'الحسكة', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (7, 'حمص*', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (8, 'حلب*', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (9, 'الرقة*', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (11, 'حماه', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (12, 'دير الزور', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (13, 'ادلب', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (14, 'منبج', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (15, 'الباب', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (16, 'اعزاز', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (18, 'طرطوس', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (19, 'اللاذقية', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (20, 'عفرين', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (21, 'خان شيخون', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (22, 'بغداد', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (23, 'الموصل', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (24, 'مسندم', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (25, 'الدار البيضاء', NULL);
Insert into Ams_Cod_City (Id, Name, Rem) values (26, 'تدمر', NULL);

------------------------------------------------------------------------------------------------------
Create Sequence Ams_Cod_Country_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Code_Country                      -- جدول الدول   
( Id         Number(3) NOT NULL,                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                  -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,          -- الاسم
  Rem        Varchar2(100 Char),                   -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Cod_Country_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Cod_Country_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Cod_Country_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Cod_Country_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Cod_Country_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Cod_Country For Ams_Code_Country;
/

Insert into Ams_Cod_Country (Id, Name, Rem) values (1, 'الجمهورية العربية السورية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (2, 'العراقية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (3, 'جمهورية مصر العربية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (4, 'المملكة العربية السعودية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (9, 'سلطنة عمان', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (10, 'المملكة المغربية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (11, 'جمهورية الصومال', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (12, 'الالمانية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (13, 'اليمنية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (14, 'اللبنانية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (15, 'التركية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (16, 'الاردنية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (17, 'قطرية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (18, 'بحرينية', NULL);
Insert into Ams_Cod_Country (Id, Name, Rem) values (19, 'اماراتية', NULL);




------------------------------------------------------------------------------------------------------
Create Sequence Ams_Lib_Cod_Type_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table Ams_Library_Code_Type                         -- جدول انواع الكتب
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Ams_Lib_Cod_Type_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Ams_Lib_Cod_Type_UK        UNIQUE      (Name),
  CONSTRAINT Ams_Lib_Cod_Type_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT Ams_Lib_Cod_Type_Ins_FK    Foreign Key (Ins_User)  References Cpy_User       (Id),
  CONSTRAINT Ams_Lib_Cod_Type_Upd_FK    Foreign Key (Upd_User)  References Cpy_User       (Id)
)
/
Create Synonym Ams_Lib_Cod_Type For Ams_Library_Code_Type;
/
------------------------------------------------------------------------------------------------------
