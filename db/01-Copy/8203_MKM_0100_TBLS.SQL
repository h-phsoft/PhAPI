--set Pagesize 1000
--select 'Drop table '   || table_name    || ';' from user_tables    where table_name    like 'MKM%' ;
--select 'Drop Synonym ' || Synonym_name  || ';' from user_Synonyms   where Synonym_name  like 'MKM%' ;
--select 'Drop Sequence '|| Sequence_name || ';' from user_Sequences where Sequence_name like 'MKM%' ;
--select 'Drop View '    || View_name     || ';' from user_Views     where View_name     like 'MKM%' ;
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Cod_Cntry_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Code_Country                             -- جدول البلدان
( Id             Number(5) NOT NULL,                        -- مفتاح رئيسي
  Status_Id      Number(1) Default 1,                        -- حالة الترميز
  Code           Varchar2(3 Char) NOT NULL,                -- الترميز
  Name           Varchar2(250 Char) NOT NULL,              -- الاسم
  Phone          Number(5) NOT NULL,                       -- رمز الهاتف
  Symbol         Varchar2(10 Char),                        -- الرمز
  Capital        Varchar2(100),                            -- Capital العاصمة
  Currency       Varchar2(3),                              -- Currency العملة
  Continent      Varchar2(30),                             -- Continent - القارة
  Continent_Code varchar2(2),                              -- Continent Code - رمز القارة
  Alpha_3        Varchar2(3),                              -- Code 3 - الرمز الثالث
  Rem            Varchar2(100 Char),                       -- ملاحظات
  Ins_User       Number(5), Ins_Date     Date,
  Upd_User       Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Cod_Cntry_PK     PRIMARY KEY (Id  ),
  CONSTRAINT MKM_Cod_Cntry_UK     UNIQUE      (Name),
  CONSTRAINT MKM_Cod_Cntry_FK     Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT MKM_Cod_Cntry_Ins_FK Foreign Key (Ins_User ) References Cpy_User       (Id),
  CONSTRAINT MKM_Cod_Cntry_Upd_FK Foreign Key (Upd_User ) References Cpy_User       (Id)
)
/
Create Synonym MKM_Cod_Cntry For MKM_Code_Country
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Cod_City_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Code_City                                 -- جدول المدن
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                            -- حالة الترميز
  Cntry_Id   Number(5) Default 1,                            -- البلد
  Code       Varchar2(10 Char) NOT NULL,                   -- الترميز
  Name       Varchar2(250 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Cod_City_PK        PRIMARY KEY (Id  ),
  CONSTRAINT MKM_Cod_City_UK        UNIQUE      (Cntry_Id, Code),
  CONSTRAINT MKM_Cod_City_FK        Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT MKM_Cod_City_Cntry_FK  Foreign Key (Cntry_Id ) References MKM_Cod_Cntry (Id),
  CONSTRAINT MKM_Cod_City_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT MKM_Cod_City_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym MKM_Cod_City For MKM_Code_City
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Cod_TStatus_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE MKM_Code_Ticket_Status                        -- ترميز حالات التذاكر
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),         				           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT MKM_Code_TStatus_PK        PRIMARY KEY (Id  ),
  CONSTRAINT MKM_Code_TStatus_UK        UNIQUE      (Name),
  CONSTRAINT MKM_Code_TStatus_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT MKM_Code_TStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT MKM_Code_TStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym MKM_Cod_TStatus For MKM_Code_Ticket_Status
/
INSERT INTO MKM_Cod_TStatus (Id, Name) VALUES (1, 'جديد');
INSERT INTO MKM_Cod_TStatus (Id, Name) VALUES (2, 'تم الإصلاح');
INSERT INTO MKM_Cod_TStatus (Id, Name) VALUES (3, 'لا يمكن إصلاحه');
INSERT INTO MKM_Cod_TStatus (Id, Name) VALUES (4, 'مستلم');
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Cod_ReqStatus_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE MKM_Code_Request_Status
( Id        Number(5) NOT NULL,
  Status_Id Number(1) Default 1,
  Name      Varchar2(100 Char) NOT NULL,
  Rem       Varchar2(100 Char),
  Ins_User  Number(5), Ins_Date Date,
  Upd_User  Number(5), Upd_Date Date,
  CONSTRAINT MKM_Cod_ReqStatus_PK PRIMARY KEY (Id),
  CONSTRAINT MKM_Cod_ReqStatus_UK UNIQUE (Name),
  CONSTRAINT MKM_Code_ReqStatus_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT MKM_Code_ReqStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT MKM_Code_ReqStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym MKM_Cod_ReqStatus For MKM_Code_Request_Status
/
INSERT INTO MKM_Cod_ReqStatus (Id, Name) VALUES (1, 'قيد المتابعة');
INSERT INTO MKM_Cod_ReqStatus (Id, Name) VALUES (2, 'تم القبول');
INSERT INTO MKM_Cod_ReqStatus (Id, Name) VALUES (3, 'تم الرفض');
COMMIT;
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Cod_IStatus_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
CREATE TABLE MKM_Code_Installment_Status                   -- ترميز حالات التركيبات
( Id         Number(5) NOT NULL,				                   -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				                   -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				           -- الاسم
  Rem        Varchar2(100 Char),         				           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT MKM_Code_IStatus_PK        PRIMARY KEY (Id  ),
  CONSTRAINT MKM_Code_IStatus_UK        UNIQUE      (Name),
  CONSTRAINT MKM_Code_IStatus_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT MKM_Code_IStatus_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT MKM_Code_IStatus_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym MKM_Cod_IStatus For MKM_Code_Installment_Status
/
INSERT INTO MKM_Cod_IStatus (Id, Name) VALUES (0, '-');
INSERT INTO MKM_Cod_IStatus (Id, Name) VALUES (1, 'Status 1');
INSERT INTO MKM_Cod_IStatus (Id, Name) VALUES (2, 'Status 2');
INSERT INTO MKM_Cod_IStatus (Id, Name) VALUES (3, 'Status 3');
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Brand_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Brands                                  -- جدول الماركات
( Id         Number(5) NOT NULL,                        -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                        -- حالة الترميز
  Name1      Varchar2(100 Char) NOT NULL,                -- الاسم الأول
  Name2      Varchar2(100 Char) NOT NULL,                -- الاسم الثاني
  Image      Varchar2(512 Char),                         -- الشعار
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Brand_PK        PRIMARY KEY (Id),
  CONSTRAINT MKM_Brand_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT MKM_Brand_Ins_FK    Foreign Key (Ins_User ) References Cpy_User        (Id),
  CONSTRAINT MKM_Brand_Upd_FK    Foreign Key (Upd_User ) References Cpy_User        (Id)
)
/
Create Synonym MKM_Brand For MKM_Brands
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Cat_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Categories                              -- جدول الفئات
( Id         Number(5) NOT NULL,                        -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                        -- حالة الترميز
  Ord        Number(5) Default 0,                        -- الترتيب
  Wdays      Number(5) Default 365,                      -- أيام الضمان
  SPoints    Number(10) Default 0,                       -- نقاط البيع
  IPoints    Number(10) Default 0,                       -- نقاط التركيب
  TPoints    Number(10) Default 0,                       -- تقاط الصيانة
  Name1      Varchar2(100 Char) NOT NULL,                -- الاسم الأول
  Name2      Varchar2(100 Char) NOT NULL,                -- الاسم الثاني
  Descrip    Varchar2(2048 Char),                        -- الوصف
  Image      Varchar2(512 Char),                         -- الصورة
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Cat_PK        PRIMARY KEY (Id),
  CONSTRAINT MKM_Cat_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status (Id),
  CONSTRAINT MKM_Cat_Ins_FK    Foreign Key (Ins_User ) References Cpy_User        (Id),
  CONSTRAINT MKM_Cat_Upd_FK    Foreign Key (Upd_User ) References Cpy_User        (Id)
)
/
Create Synonym MKM_Cat For MKM_Categories
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Product_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Products                                 -- جدول المنتجات
( Id         Number(10) NOT NULL,                        -- مفتاح رئيسي
  Mnum       Number(10) Default 0,                       -- الرقم
  Brand_Id   Number(5) Default 0,                        -- الماركة
  Status_Id  Number(1) Default 1,                        -- الحالة
  Cat_Id     Number(5) Default 0,                        -- الفئة
  Name1      Varchar2(256 Char) NOT NULL,                -- الاسم الأول
  Name2      Varchar2(256 Char) NOT NULL,                -- الاسم الثاني
  Qnt        Number(10,2) Default 0,                     -- الكمية
  Price      Number(10,2) Default 0,                     -- السعر العادي
  Cprice     Number(10,2) Default 0,                     -- السعر الحالي
  Desc1      Varchar2(2048 Char),                        -- الوصف 1
  Desc2      Varchar2(2048 Char),                        -- الوصف 2
  Desc3      Varchar2(2048 Char),                        -- الوصف 3
  Desc4      Varchar2(2048 Char),                        -- الوصف 4
  Desc5      Varchar2(2048 Char),                        -- الوصف 5
  Image      Varchar2(512 Char),                         -- الصورة
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Product_PK         PRIMARY KEY (Id),
  CONSTRAINT MKM_Product_Brand_FK   Foreign Key (Brand_Id ) References MKM_Brand        (Id),
  CONSTRAINT MKM_Product_Cat_FK     Foreign Key (Cat_Id   ) References MKM_Cat          (Id),
  CONSTRAINT MKM_Product_Status_FK Foreign Key (Status_Id) References Phs_Cod_Status  (Id),
  CONSTRAINT MKM_Product_Ins_FK     Foreign Key (Ins_User ) References Cpy_User         (Id),
  CONSTRAINT MKM_Product_Upd_FK     Foreign Key (Upd_User ) References Cpy_User         (Id)
)
/
Create Synonym MKM_Product For MKM_Products
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Prod_Spec_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Prod_Specification                       -- مواصفات المواد
( Id         Number(20),                                 -- مفتاح رئيسي    
  Prod_Id    Number(9) NOT NULL,                         -- المادة
  vTitle     Varchar2(100) NOT NULL,                     -- العنوان
  vValue     Varchar2(1024) NOT NULL,                    -- القيمة
  Rem        VarChar2(250 Char),                         -- ملاحظات
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Prod_Spec_PK        PRIMARY KEY (Id),
  CONSTRAINT MKM_Prod_Spec_UK        Unique      (Prod_Id, vTitle),
  CONSTRAINT MKM_Prod_Spec_Prod_FK  Foreign Key (Prod_Id ) References MKM_Product(Id),
  CONSTRAINT MKM_Prod_Spec_Ins_FK   Foreign Key (Ins_User) References Cpy_User   (Id),
  CONSTRAINT MKM_Prod_Spec_Upd_FK   Foreign Key (Upd_User) References Cpy_User   (Id)
)
/
Create Synonym MKM_Prod_Spec For MKM_Prod_Specification
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Prod_Serial_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Prod_Serials                             -- جدول الأرقام التسلسلية
( Id         Number(10) NOT NULL,                        -- مفتاح رئيسي
  Prod_Id    Number(10) NOT NULL,                        -- المنتج
  Serial     Varchar2(100 Char) NOT NULL,                -- الرقم التسلسلي
  Qnt        Number(10,2) Default 1,                     -- الكمية
  Cqnt       Number(10,2) Default 1,                     -- الكمية الحالية
  Created_At Date Default Sysdate,                         -- تاريخ الإنشاء
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Prod_Serial_PK       PRIMARY KEY (Id),
  CONSTRAINT MKM_Prod_Serial_UK       UNIQUE      (Serial  ),
  CONSTRAINT MKM_Prod_Serial_Prod_FK  Foreign Key (Prod_Id ) References MKM_Product (Id),
  CONSTRAINT MKM_Prod_Serial_Ins_FK   Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT MKM_Prod_Serial_Upd_FK   Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym MKM_Prod_Serial For MKM_Prod_Serials
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Sale_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Sales                                    -- جدول المبيعات
( Id         Number(10) NOT NULL,                        -- مفتاح رئيسي
  Bran_Id    Number(3) Default 0,                        -- الفرع
  User_Id    Number(5),                                  -- المستخدم
  Mdate      Date Default Sysdate,                       -- التاريخ
  Customer   Varchar2(250 Char) NOT NULL,                -- اسم الزبون
  Address    Varchar2(256 Char),                         -- عنوان الزبون
  Mobile     Varchar2(50 Char),                          -- رقم الموبايل
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Sale_PK      PRIMARY KEY (Id),
  CONSTRAINT MKM_Sale_User_FK Foreign Key (User_Id ) References Cpy_User (Id),
  CONSTRAINT MKM_Sale_Ins_FK  Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT MKM_Sale_Upd_FK  Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym MKM_Sale For MKM_Sales
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Sales_Item_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Sales_Items                              -- جدول تفاصيل المبيعات
( Id         Number(10) NOT NULL,                        -- مفتاح رئيسي
  Sales_Id   Number(10) NOT NULL,                        -- عملية البيع
  Prod_Id    Number(10) NOT NULL,                        -- المنتج
  Serial     Varchar2(50 Char) NOT NULL,                 -- الرقم التسلسلي
  Points     Number(10) Default 0,                       -- النقاط
  Wdays      Number(5) Default 0,                        -- أيام الضمان
  Edate      Date,                                       -- تاريخ الانتهاء
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Sales_Item_PK        PRIMARY KEY (Id),
  CONSTRAINT MKM_Sales_Item_Sales_FK  Foreign Key (Sales_Id) References MKM_Sale    (Id),
  CONSTRAINT MKM_Sales_Item_Prod_FK   Foreign Key (Prod_Id ) References MKM_Product (Id),
  CONSTRAINT MKM_Sales_Item_Ins_FK    Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT MKM_Sales_Item_Upd_FK    Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym MKM_Sales_Item For MKM_Sales_Items
/
Create Index MKM_Idx_Sales_Item_Serial ON MKM_Sales_Items (Serial);
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Sale_Upd_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Sales_Update                                 -- جدول طلبات تعديل المبيعات
( Id         Number(10) NOT NULL,                                -- مفتاح رئيسي
  Sale_Id    Number(10) NOT NULL,                                -- مفتاح عملية البيع
  User_Id    Number(5) NOT NULL,                                 -- المستخدم
  rStatus    Number(5) Default 1,                                -- حالة الطلب
  Bran_Id    Number(3) Default 0,                                -- الفرع
  Mdate      Date Default Sysdate,                               -- التاريخ
  Customer   Varchar2(250 Char) NOT NULL,                        -- اسم الزبون
  address    Varchar2(256 Char),                                 -- عنوان الزبون
  mobile     Varchar2(50 Char),                                  -- رقم الموبايل
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Sale_Upd_PK         PRIMARY KEY (Id),
  CONSTRAINT MKM_Sale_Upd_User_FK    Foreign Key (User_Id) References Cpy_User (Id),
  CONSTRAINT MKM_Sale_Upd_RStatus_FK Foreign Key (rStatus) References MKM_Code_Request_Status(Id),
  CONSTRAINT MKM_Sale_Upd_Ins_FK     Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT MKM_Sale_Upd_Upd_FK     Foreign Key (Upd_User) References Cpy_User (Id)
);
/
Create Synonym MKM_Sale_Upd For MKM_Sales_Update
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Sales_Item_Upd_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Sales_Items_Update                       -- جدول تفاصيل طلبات تعديل المبيعات
( Id         Number(10) NOT NULL,                          -- مفتاح رئيسي
  Sales_Id   Number(10) NOT NULL,                          -- عملية البيع
  Prod_Id    Number(10) NOT NULL,                          -- المنتج
  Serial     Varchar2(50 Char) NOT NULL,                   -- الرقم التسلسلي
  Points     Number(10) Default 0,                         -- النقاط
  Wdays      Number(5) Default 0,                          -- أيام الضمان
  Edate      Date,                                         -- تاريخ الانتهاء
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Sales_Item_Upd_PK        PRIMARY KEY (Id),
  CONSTRAINT MKM_Sales_Item_Upd_Sales_FK Foreign Key (Sales_Id) References MKM_Sale_Upd (Id),
  CONSTRAINT MKM_Sales_Item_Upd_Prod_FK  Foreign Key (Prod_Id ) References MKM_Product  (Id),
  CONSTRAINT MKM_Sales_Item_Upd_Ins_FK   Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT MKM_Sales_Item_Upd_Upd_FK   Foreign Key (Upd_User) References Cpy_User     (Id)
);
/
Create Synonym MKM_Sales_Item_Upd For MKM_Sales_Items_Update
/
Create Index MKM_Idx_Sales_Item_Upd_Serial ON MKM_Sales_Items_Update (Serial);
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Sale_Del_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Sales_Delete                                -- جدول طلبات حذف المبيعات
( Id        Number(10) NOT NULL,                                -- مفتاح رئيسي
  Sale_Id   Number(10) NOT NULL,                                -- مفتاح عملية البيع الأصلية
  User_Id   Number(5) NOT NULL,                                 -- المستخدم
  rStatus   Number(5) Default 1,                                -- حالة الطلب
  Bran_Id   Number(3) Default 0,                                -- الفرع
  Mdate     Date Default Sysdate,                               -- التاريخ
  Customer  Varchar2(250 Char) NOT NULL,                        -- اسم الزبون
  address   Varchar2(256 Char),                                 -- عنوان الزبون
  mobile    Varchar2(50 Char),                                  -- رقم الموبايل
  Ins_User  Number(5), Ins_Date Date,                           -- المستخدم وتاريخ الإدخال
  Upd_User  Number(5), Upd_Date Date,                           -- المستخدم وتاريخ التعديل
  CONSTRAINT MKM_Sale_Del_PK         PRIMARY KEY (Id),
  CONSTRAINT MKM_Sale_Del_User_FK    Foreign Key (User_Id) References Cpy_User (Id),
  CONSTRAINT MKM_Sale_Del_RStatus_FK Foreign Key (rStatus) References MKM_Code_Request_Status(Id),
  CONSTRAINT MKM_Sale_Del_Ins_FK     Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT MKM_Sale_Del_Upd_FK     Foreign Key (Upd_User) References Cpy_User (Id)
);
/
Create Synonym MKM_Sale_Del For MKM_Sales_Delete
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Sales_Item_Del_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Sales_Items_Delete                               -- جدول تفاصيل طلبات حذف المبيعات
( Id        Number(10) NOT NULL,                                -- مفتاح رئيسي
  Sales_Id  Number(10) NOT NULL,                                -- مفتاح طلب الحذف الرئيسي
  Prod_Id   Number(10) NOT NULL,                                -- المنتج
  Serial    Varchar2(50 Char) NOT NULL,                         -- الرقم التسلسلي
  Points    Number(10) Default 0,                               -- النقاط
  Wdays     Number(5) Default 0,                                -- أيام الضمان
  Edate     Date,                                               -- تاريخ الانتهاء
  Ins_User  Number(5), Ins_Date Date,                           -- المستخدم وتاريخ الإدخال
  Upd_User  Number(5), Upd_Date Date,                           -- المستخدم وتاريخ التعديل
  CONSTRAINT MKM_Sales_Item_Del_PK PRIMARY KEY (Id),
  CONSTRAINT MKM_Sales_Item_Del_Sales_FK Foreign Key (Sales_Id) References MKM_Sale_Del (Id),
  CONSTRAINT MKM_Sales_Item_Del_Prod_FK  Foreign Key (Prod_Id ) References MKM_Product  (Id),
  CONSTRAINT MKM_Sales_Item_Del_Ins_FK   Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT MKM_Sales_Item_Del_Upd_FK   Foreign Key (Upd_User) References Cpy_User    (Id)
);
Create Synonym MKM_Sales_Item_Del For MKM_Sales_Items_Delete
/
Create Index MKM_Idx_Sales_Item_Del_Serial ON MKM_Sales_Items_Delete (Serial);
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Ticket_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Tickets                                     -- جدول تذاكر الدعم
( Id             Number(10) NOT NULL,                         -- مفتاح رئيسي
  Sale_Id        Number(10) NOT NULL,                         -- عملية البيع
  Prod_Id        Number(10) NOT NULL,                         -- المنتج
  Serial         Varchar2(50 Char) NOT NULL,                    -- الرقم التسلسلي
  Points         Number(10) Default 0,                        -- النقاط
  Status_Id      Number(1) Default 1,                         -- الحالة
  User_Id        Number(5),                                   -- المستخدم
  Tdate          Date Default Sysdate,                        -- تاريخ التذكرة
  Udate          Date Default Sysdate,                        -- تاريخ التحديث
  Ticket_Text    Varchar2(2048 Char) NOT NULL,                -- الوصف
  Support_Text   Varchar2(2048 Char),                         -- وصف الدعم
  Ins_User       Number(5), Ins_Date     Date,
  Upd_User       Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Ticket_PK        PRIMARY KEY (Id),
  CONSTRAINT MKM_Ticket_Sale_FK   Foreign Key (Sale_Id  ) References MKM_Sale        (Id),
  CONSTRAINT MKM_Ticket_Prod_FK   Foreign Key (Prod_Id  ) References MKM_Product    (Id),
  CONSTRAINT MKM_Ticket_Status_FK Foreign Key (Status_Id) References MKM_Cod_TStatus(Id),
  CONSTRAINT MKM_Ticket_User_FK   Foreign Key (User_Id  ) References Cpy_User        (Id),
  CONSTRAINT MKM_Ticket_Ins_FK    Foreign Key (Ins_User ) References Cpy_User        (Id),
  CONSTRAINT MKM_Ticket_Upd_FK    Foreign Key (Upd_User ) References Cpy_User        (Id)
)
/
Create Synonym MKM_Ticket For MKM_Tickets
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Member_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE MKM_Members                                   -- دليل الأعضاء
( Id         Number(10) NOT NULL,                         -- مفتاح رئيسي
  UGrp_id    Number(1) Default 2 NOT NULL,                  -- الفئة
  Status_id  Number(1) Default 2 NOT NULL,                  -- الحالة
  Country_id Number(5) NOT NULL,                            -- البلد
  City_id    Number(5) NOT NULL,                            -- المدينة
  Points     Number(10) Default 0,                          -- مجموع النقاط
  nLong      Number(20,10) Default 0,                       -- خط الطول
  nLat       Number(20,10) Default 0,                       -- خط العرض
  Mobile     Varchar2(20 Char) NOT NULL,                    -- رقم الموبايل
  FName      Varchar2(100 Char) NOT NULL,                   -- الاسم الأول
  LName      Varchar2(100 Char) NOT NULL,                   -- الأسم الأخير
  Email      Varchar2(75 Char),                             -- بريد الكتروني
  Name       Varchar2(200 Char),                            -- اسم المنشأة
  Address    Varchar2(512 Char),                            -- العنوان
  Rem        Varchar2(100 Char),              				      -- ملاحظات
  User_Id    Number(5) Default -9 NOT NULL,                 -- المستخدم المرتبط
  Upd_User   Number(5), Upd_Date Date,
  Ins_User   Number(5), Ins_Date Date,
  CONSTRAINT MKM_Member_PK          PRIMARY KEY (Id        ),
  CONSTRAINT MKM_Member_UK          UNIQUE      (Mobile    ),
  CONSTRAINT MKM_Member_UGrp_FK     Foreign Key (UGrp_Id   ) References Phs_Cod_UGrp      (Id),
  CONSTRAINT MKM_Member_Country_FK Foreign Key (Country_Id) References MKM_Cod_Cntry     (Id),
  CONSTRAINT MKM_Member_City_FK     Foreign Key (City_Id   ) References MKM_Cod_City      (Id),
  CONSTRAINT MKM_Member_Status_FK  Foreign Key (Status_Id ) References Phs_Cod_Status    (Id),
  CONSTRAINT MKM_Member_User_FK     Foreign Key (User_Id   ) References Cpy_User          (Id),
  CONSTRAINT MKM_Member_Ins_FK      Foreign Key (Ins_User  ) References Cpy_User          (Id),
  CONSTRAINT MKM_Member_Upd_FK      Foreign Key (Upd_User  ) References Cpy_User          (Id)
)
/
Create Synonym MKM_Member For MKM_Members
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_MInstallment_Seq MinValue 1 Start With 1 MaxValue 999999999999999999999999999999 INCREMENT BY 1 CACHE 2;
CREATE TABLE MKM_Member_Installments                       -- التركيبات
( Id         Number(30) NOT NULL,                         -- مفتاح رئيسي
  User_Id    Number(5) NOT NULL,                            -- المستخدم
  Status_Id  Number(2) Default 0 NOT NULL,                  -- الحالة
  dDate      Date Default Sysdate,                          -- التاريخ
  Mobile     Varchar2(20 Char) NOT NULL,				          	-- الموبايل
  Name       Varchar2(200 Char),                            -- اسم الزبون
  Address    Varchar2(512 Char),                            -- العنوان
  Rem        Varchar2(100 Char),              				-- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT MKM_MInstallment_PK          PRIMARY KEY (Id),
  CONSTRAINT MKM_MInstallment_Member_FK   Foreign Key (User_Id   ) References Cpy_User        (Id),
  CONSTRAINT MKM_MInstallment_Status_FK   Foreign Key (Status_Id ) References MKM_Cod_IStatus(Id),
  CONSTRAINT MKM_MInstallment_Ins_FK      Foreign Key (Ins_User  ) References Cpy_User        (Id),
  CONSTRAINT MKM_MInstallment_Upd_FK      Foreign Key (Upd_User  ) References Cpy_User        (Id)
)
/
Create Synonym MKM_MInstallment For MKM_Member_Installments
/
-----------------------------------------------------------------------------------------------------
Create Sequence MKM_Inst_Items_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Installments_Items                        -- تفاصيل التركيبات
( Id         Number(10) NOT NULL,                         -- مفتاح رئيسي
  Inst_Id    Number(10) NOT NULL,                         -- عملية البيع
  Prod_Id    Number(10) NOT NULL,                         -- المنتج
  Serial     Varchar2(50 Char) NOT NULL,                    -- الرقم التسلسلي
  Points     Number(10) Default 0,                        -- النقاط
  Ins_User   Number(5), Ins_Date     Date,
  Upd_User   Number(5), Upd_Date     Date,
  CONSTRAINT MKM_Install_Item_PK        PRIMARY KEY (Id),
  CONSTRAINT MKM_Install_Item_Sales_FK  Foreign Key (Inst_Id) References MKM_MInstallment    (Id),
  CONSTRAINT MKM_Install_Item_Prod_FK   Foreign Key (Prod_Id ) References MKM_Product (Id),
  CONSTRAINT MKM_Install_Item_Ins_FK    Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT MKM_Install_Item_Upd_FK    Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Create Synonym MKM_Inst_Items For MKM_Installments_Items
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Inst_Upd_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Installments_Update                                  -- جدول طلبات تعديل التركيبات
( Id         Number(30) NOT NULL,                                -- مفتاح رئيسي
  Inst_Id    Number(30) NOT NULL,                                -- مفتاح التركيب الأصلي
  User_Id    Number(5) NOT NULL,                                 -- المستخدم
  rStatus    Number(5) Default 1,                                -- حالة الطلب
  dDate      Date Default Sysdate,                               -- التاريخ
  Mobile     Varchar2(20 Char) NOT NULL,                         -- الموبايل
  Name       Varchar2(200 Char),                                 -- اسم الزبون
  Address    Varchar2(512 Char),                                 -- العنوان
  Rem        Varchar2(100 Char),                                 -- ملاحظات
  Image      Varchar2(500 Char),                                 -- صورة التركيب
  Ins_User   Number(5), Ins_Date Date,                           -- المستخدم وتاريخ الإدخال
  Upd_User   Number(5), Upd_Date Date,                           -- المستخدم وتاريخ التعديل
  CONSTRAINT MKM_Inst_Upd_PK           PRIMARY KEY (Id),
  CONSTRAINT MKM_Inst_Upd_User_FK    Foreign Key (User_Id) References Cpy_User (Id),
  CONSTRAINT MKM_Inst_Upd_RStatus_FK Foreign Key (rStatus) References MKM_Code_Request_Status(Id),
  CONSTRAINT MKM_Inst_Upd_Ins_FK     Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT MKM_Inst_Upd_Upd_FK     Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym MKM_Inst_Upd For MKM_Installments_Update
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Inst_Item_Upd_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Installments_Items_Update                 -- جدول تفاصيل طلبات تعديل التركيبات
( Id         Number(10) NOT NULL,                          -- مفتاح رئيسي
  Inst_Id    Number(30) NOT NULL,                          -- مفتاح طلب التعديل الرئيسي
  Prod_Id    Number(10) NOT NULL,                          -- المنتج
  Serial     Varchar2(50 Char) NOT NULL,                   -- الرقم التسلسلي
  Points     Number(10) Default 0,                         -- النقاط
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT MKM_Inst_Item_Upd_PK PRIMARY KEY (Id),
  CONSTRAINT MKM_Inst_Item_Upd_Inst_FK Foreign Key (Inst_Id) References MKM_Inst_Upd (Id),
  CONSTRAINT MKM_Inst_Item_Upd_Prod_FK Foreign Key (Prod_Id) References MKM_Product (Id),
  CONSTRAINT MKM_Inst_Item_Upd_Ins_FK  Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT MKM_Inst_Item_Upd_Upd_FK  Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym MKM_Inst_Item_Upd For MKM_Installments_Items_Update
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Inst_Del_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Installments_Delete                                  -- جدول طلبات حذف التركيبات
( Id         Number(30) NOT NULL,                                -- مفتاح رئيسي
  Inst_Id    Number(30) NOT NULL,                                -- مفتاح التركيب الأصلي
  User_Id    Number(5) NOT NULL,                                 -- المستخدم
  rStatus    Number(5) Default 1,                                -- حالة الطلب
  dDate      Date Default Sysdate,                               -- التاريخ
  Mobile     Varchar2(20 Char) NOT NULL,                         -- الموبايل
  Name       Varchar2(200 Char),                                 -- اسم الزبون
  Address    Varchar2(512 Char),                                 -- العنوان
  Rem        Varchar2(100 Char),                                 -- ملاحظات
  Image      Varchar2(500 Char),                                 -- صورة التركيب
  Ins_User   Number(5), Ins_Date Date,                           -- المستخدم وتاريخ الإدخال
  Upd_User   Number(5), Upd_Date Date,                           -- المستخدم وتاريخ التعديل
  CONSTRAINT MKM_Inst_Del_PK           PRIMARY KEY (Id),
  CONSTRAINT MKM_Inst_Del_User_FK    Foreign Key (User_Id) References Cpy_User (Id),
  CONSTRAINT MKM_Inst_Del_RStatus_FK Foreign Key (rStatus) References MKM_Code_Request_Status(Id),
  CONSTRAINT MKM_Inst_Del_Ins_FK     Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT MKM_Inst_Del_Upd_FK     Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Create Synonym MKM_Inst_Del For MKM_Installments_Delete
/
----------------------------------------------------------------------------------------------------
Create Sequence MKM_Inst_Item_Del_Seq MinValue 1 Start With 1 MaxValue 9999999999 INCREMENT BY 1 CACHE 2;
Create Table MKM_Installments_Items_Delete                 -- جدول تفاصيل طلبات حذف التركيبات
( Id         Number(10) NOT NULL,                                -- مفتاح رئيسي
  Inst_Id    Number(30) NOT NULL,                                -- مفتاح طلب الحذف الرئيسي
  Prod_Id    Number(10) NOT NULL,                                -- المنتج
  Serial     Varchar2(50 Char) NOT NULL,                         -- الرقم التسلسلي
  Points     Number(10) Default 0,                               -- النقاط
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT MKM_Inst_Item_Del_PK PRIMARY KEY (Id),
  CONSTRAINT MKM_Inst_Item_Del_Inst_FK Foreign Key (Inst_Id) References MKM_Inst_Del (Id),
  CONSTRAINT MKM_Inst_Item_Del_Prod_FK Foreign Key (Prod_Id) References MKM_Product (Id),
  CONSTRAINT MKM_Inst_Item_Del_Ins_FK  Foreign Key (Ins_User) References Cpy_User  (Id),
  CONSTRAINT MKM_Inst_Item_Del_Upd_FK  Foreign Key (Upd_User) References Cpy_User  (Id)
)
/
Create Synonym MKM_Inst_Item_Del For MKM_Installments_Items_Delete
/