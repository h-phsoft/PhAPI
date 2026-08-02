--Alter Table Fin_Invoice_Trn        Drop CONSTRAINT Fin_TInv_Item_FK;
--Alter Table Fin_Debit_Trn          Drop CONSTRAINT Fin_TDbt_Item_FK;
--Alter Table Fin_Credit_Trn         Drop CONSTRAINT Fin_TCrd_Item_FK;
--Alter Table Fin_Expense_Trn        Drop CONSTRAINT Fin_TExp_Item_FK;
--Alter Table PMS_Request_Trn        Drop CONSTRAINT PMS_TReq_Item_FK;
--Alter Table PMS_Purchase_Order_Trn Drop CONSTRAINT PMS_TPurOrd_Item_FK;
--Alter Table PMS_Delivery_Trn       Drop CONSTRAINT PMS_TDeliv_Item_FK;
--Alter Table Por_Request_Trn        Drop CONSTRAINT Por_TReq_Item_FK;
--Alter Table Por_Purchase_Order_Trn Drop CONSTRAINT Por_TPurOrd_Item_FK;
--Alter Table Por_Delivery_Trn       Drop CONSTRAINT Por_TDeliv_Item_FK;
--Alter Table Por_Purchase_Trn       Drop CONSTRAINT Por_TPor_Item_FK;
--Alter Table Pur_Purchase_Trn       Drop CONSTRAINT Pur_TPur_Item_FK ;
--Alter Table Pur_Purchase_Trn       Drop CONSTRAINT Pur_TPur_Model_FK;
--Alter Table Pur_Purchase_Trn       Drop CONSTRAINT Pur_TPur_Color_FK;
--Alter Table Pur_Purchase_Trn       Drop CONSTRAINT Pur_TPur_Size_FK ;
--Alter Table Pur_Return_Trn         Drop CONSTRAINT Pur_TRet_Item_FK ;
--Alter Table Pur_Return_Trn         Drop CONSTRAINT Pur_TRet_Model_FK;
--Alter Table Pur_Return_Trn         Drop CONSTRAINT Pur_TRet_Color_FK;
--Alter Table Pur_Return_Trn         Drop CONSTRAINT Pur_TRet_Size_FK ;
--Alter Table Sal_Price_Items        Drop CONSTRAINT Sal_Price_Item_Item_FK;
--set Pagesize 1000
--select 'Drop table '   || table_name                          || ';' from user_tables    where table_name    like 'STOR%' ;
--select 'Drop Synonym ' || Synonym_name                        || ';' from user_Synonyms  where Synonym_name  like 'STOR%' ;
--select 'Drop Sequence '|| Sequence_name                       || ';' from user_Sequences where Sequence_name like 'STOR%' ;
--select 'Drop View '    || View_name                           || ';' from user_Views     where View_name     like 'STOR%' ;
--select 'Drop Trigger ' || Trigger_name                        || ';' from user_Triggers  where Trigger_name  like 'STOR%' ;
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Unit_Seq MinValue 100 Start With 100 MaxValue 99999 INCREMENT BY 100 CACHE 2;
Create Table Stor_Code_Unit           				        -- جدول ترميز الوحدات
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),      Ins_Date Date,
  Upd_User   Number(5),      Upd_Date Date,
  CONSTRAINT Stor_Cod_Unit_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Unit_UK        UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Unit_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Stor_Cod_Unit_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Stor_Cod_Unit_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Stor_Cod_Unit For Stor_Code_Unit
/
Insert into Stor_Cod_Unit (Id,Name) values (0,'Piece');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Unit_Form_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Unit_Formula                             -- نسب التحويل بين الوحدات
( Id         Number(5),                                    -- مفتاح رئيسي
  FUnit_Id   Number(5) Default 0,                          -- كل واحد من هذه الوحد
  TUnit_Id   Number(5) Default 0,                          -- يساوي من هذه الوحدة
  Perc       Number(25,3) Default 1,                       -- النسبة
  Rem        Varchar2(250 Char),                           -- ملاحظات
  Ins_User   Number(5), Ins_Date Date,
  Upd_User   Number(5), Upd_Date Date,
  CONSTRAINT Stor_Unit_Form_PK       PRIMARY KEY (Id),
  CONSTRAINT Stor_Unit_Form_FUnit_FK Foreign Key (FUnit_Id) References Stor_Cod_Unit(Id),
  CONSTRAINT Stor_Unit_Form_TUnit_FK Foreign Key (TUnit_Id) References Stor_Cod_Unit(Id),
  CONSTRAINT Stor_Unit_Form_Ins_FK   Foreign Key (Ins_User) References Cpy_User     (Id),
  CONSTRAINT Stor_Unit_Form_Upd_FK   Foreign Key (Upd_User) References Cpy_User     (Id)
)
/
Create Synonym Stor_Unit_Form For Stor_Unit_Formula
/
----------------------------------------------------------------------------------------------------
Create Table Stor_Code_Order_Status                        -- جدول ترميز حالة الأمر
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Ord_Status_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Ord_Status_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Ord_Status_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Ord_Status_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Ord_Status For Stor_Code_Order_Status
/
Insert into Stor_Cod_Ord_Status (Id,Name) values (0,'-'       );
Insert into Stor_Cod_Ord_Status (Id,Name) values (1,'Commited');
Insert into Stor_Cod_Ord_Status (Id,Name) values (2,'Freez'   );
Insert into Stor_Cod_Ord_Status (Id,Name) values (3,'Cancel'  );
----------------------------------------------------------------------------------------------------
Create Table Stor_Code_Type                                -- جدول ترميز نوع المادة
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Type_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Type_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Type_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Type_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Type For Stor_Code_Type
/
Insert into Stor_Cod_Type (Id,Name) values (1,'Normal'      );
Insert into Stor_Cod_Type (Id,Name) values (2,'Product'     );
Insert into Stor_Cod_Type (Id,Name) values (3,'Raw Material');
Insert into Stor_Cod_Type (Id,Name) values (4,'Semi-Produt' );
----------------------------------------------------------------------------------------------------
Create Table Stor_Code_Method                              -- جدول ترميز طريقة التعامل مع المادة
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Barcode_Id Number(1) Default 1,                          -- حالة الباركود
  Model_Id   Number(1) Default 1,                          -- حالة الموديل
  Size_Id    Number(1) Default 1,                          -- حالة القياس
  Color_Id   Number(1) Default 1,                          -- حالة اللون
  Lot_Id     Number(1) Default 1,                          -- حالة الطبخة
  Ser_Id     Number(1) Default 1,                          -- حالة التسلسلي
  SDate_Id   Number(1) Default 1,                          -- حالة ت البداية
  EDate_Id   Number(1) Default 1,                          -- حالة ت النهاية
  Length_Id  Number(1) Default 1,                          -- حالة الطول
  Width_Id   Number(1) Default 1,                          -- حالة العرض
  Height_Id  Number(1) Default 1,                          -- حالة الالارتفاع
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Method_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Method_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Barcode_FK    Foreign Key (Barcode_Id) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_Model_FK      Foreign Key (Model_Id  ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_Size_FK       Foreign Key (Size_Id   ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_Color_FK      Foreign Key (Color_Id  ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_Lot_FK        Foreign Key (Lot_Id    ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_Ser_FK        Foreign Key (Ser_Id    ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_SDate_FK      Foreign Key (SDate_Id  ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_EDate_FK      Foreign Key (EDate_Id  ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_Length_FK     Foreign Key (Length_Id ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_Width_FK      Foreign Key (Width_Id  ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_Height_FK     Foreign Key (Height_Id ) References Phs_Cod_YesNo(Id),
  CONSTRAINT Stor_Cod_Method_Ins_FK Foreign Key (Ins_User  ) References Cpy_User     (Id),
  CONSTRAINT Stor_Cod_Method_Upd_FK Foreign Key (Upd_User  ) References Cpy_User     (Id)
)
/
Create Synonym Stor_Cod_Method For Stor_Code_Method
/
Insert into Stor_Cod_Method (Id,Name, Barcode_Id, Model_Id, Size_Id, Color_Id, Lot_Id, Ser_Id, SDate_Id, EDate_Id, Length_Id, Width_Id, Height_Id) values (1,'Normal', 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1);
Insert into Stor_Cod_Method (Id,Name, Barcode_Id, Model_Id, Size_Id, Color_Id, Lot_Id, Ser_Id, SDate_Id, EDate_Id, Length_Id, Width_Id, Height_Id) values (2,'FIFO'  , 1, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2);
Insert into Stor_Cod_Method (Id,Name, Barcode_Id, Model_Id, Size_Id, Color_Id, Lot_Id, Ser_Id, SDate_Id, EDate_Id, Length_Id, Width_Id, Height_Id) values (3,'LIFO'  , 1, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2);
Insert into Stor_Cod_Method (Id,Name, Barcode_Id, Model_Id, Size_Id, Color_Id, Lot_Id, Ser_Id, SDate_Id, EDate_Id, Length_Id, Width_Id, Height_Id) values (4,'Serial', 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1);
Insert into Stor_Cod_Method (Id,Name, Barcode_Id, Model_Id, Size_Id, Color_Id, Lot_Id, Ser_Id, SDate_Id, EDate_Id, Length_Id, Width_Id, Height_Id) values (5,'LOT'   , 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1);
Insert into Stor_Cod_Method (Id,Name, Barcode_Id, Model_Id, Size_Id, Color_Id, Lot_Id, Ser_Id, SDate_Id, EDate_Id, Length_Id, Width_Id, Height_Id) values (6,'Manual', 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1);
----------------------------------------------------------------------------------------------------
Create Table Stor_Code_Cost                                -- جدول ترميز طريقة تكليف المادة
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Cost_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Cost_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Cost_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Cost_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Cost For Stor_Code_Cost
/
Insert into Stor_Cod_Cost (Id,Name) values (1,'Average'  );
Insert into Stor_Cod_Cost (Id,Name) values (2,'By Method');
----------------------------------------------------------------------------------------------------
Create Table Stor_Code_Own                                 -- جدول ترميز ملكية المستودع
( Id         Number(1) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Own_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Own_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Own_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Own_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Own For Stor_Code_Own
/
Insert into Stor_Cod_Own (Id,Name) values (1,'Own');
Insert into Stor_Cod_Own (Id,Name) values (2,'Rent');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Model_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Model                               -- جدول ترميز الموديلات
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Model_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Model_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Model_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Model_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Model For Stor_Code_Model
/
Insert into Stor_Cod_Model (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Color_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Color                               -- جدول الألوان
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Color_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Color_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Color_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Color_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Color For Stor_Code_Color
/
Insert into Stor_Cod_Color (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Size_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Size                                -- جدول ترميز القياسات
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Size_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Size_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Size_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Size_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Size For Stor_Code_Size
/
Insert into Stor_Cod_Size (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Doc_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Document                            -- جدول ترميز نوع المستند
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Doc_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Doc_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Doc_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Doc_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Doc For Stor_Code_Document
/
Insert into Stor_Cod_Doc (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Table Stor_Code_Transaction_Type                    -- جدول ترميز أنواع الحركات
( Id         Number(3) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_TrnTyp_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_TrnTyp_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_TrnTyp_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_TrnTyp_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_TrnTyp For Stor_Code_Transaction_Type
/
Insert into Stor_Cod_TrnTyp (Id,Name) values (100, 'Inbound'                       );
Insert into Stor_Cod_TrnTyp (Id,Name) values (105, 'Inbound Execute Order'         );
Insert into Stor_Cod_TrnTyp (Id,Name) values (110, 'Inbound Purchase'              );
Insert into Stor_Cod_TrnTyp (Id,Name) values (120, 'Inbound Purchase Order'        );
Insert into Stor_Cod_TrnTyp (Id,Name) values (130, 'Inbound Production'            );
Insert into Stor_Cod_TrnTyp (Id,Name) values (140, 'Inbound Correction'            );
Insert into Stor_Cod_TrnTyp (Id,Name) values (150, 'Inbound Transfer'              );
Insert into Stor_Cod_TrnTyp (Id,Name) values (160, 'Inbound Change Value'          );
Insert into Stor_Cod_TrnTyp (Id,Name) values (200, 'Outbound'                      );
Insert into Stor_Cod_TrnTyp (Id,Name) values (205, 'Outbound Execute Order'        );
Insert into Stor_Cod_TrnTyp (Id,Name) values (210, 'Outbound Sales'                );
Insert into Stor_Cod_TrnTyp (Id,Name) values (215, 'Outbound Sales Order'          );
Insert into Stor_Cod_TrnTyp (Id,Name) values (220, 'Outbound Samples'              );
Insert into Stor_Cod_TrnTyp (Id,Name) values (240, 'Outbound Correction'           );
Insert into Stor_Cod_TrnTyp (Id,Name) values (250, 'Outbound Transfer'             );
Insert into Stor_Cod_TrnTyp (Id,Name) values (260, 'Outbound Change Value'         );
Insert into Stor_Cod_TrnTyp (Id,Name) values (300, 'Inbound Return Outbound'       );
Insert into Stor_Cod_TrnTyp (Id,Name) values (310, 'Inbound Return Sales'          );
Insert into Stor_Cod_TrnTyp (Id,Name) values (315, 'Inbound Return Sales Order'    );
Insert into Stor_Cod_TrnTyp (Id,Name) values (320, 'Inbound Return Samples'        );
Insert into Stor_Cod_TrnTyp (Id,Name) values (400, 'Outbound Return Inbound'       );
Insert into Stor_Cod_TrnTyp (Id,Name) values (410, 'Outbound Return Purchase'      );
Insert into Stor_Cod_TrnTyp (Id,Name) values (420, 'Outbound Return Purchase Order');
Insert into Stor_Cod_TrnTyp (Id,Name) values (430, 'Outbound Return Production'    );
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Grp_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Group                               -- جدول ترميز فئات التصنيف
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  FColor     Varchar2(100 Char),                           -- لون النص
  BColor     Varchar2(100 Char),                           -- لون الخلفية
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Grp_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Grp_UK        UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Grp_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Stor_Cod_Grp_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Stor_Cod_Grp_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Stor_Cod_Grp For Stor_Code_Group
/
Insert into Stor_Cod_Grp (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Itm_Seq MinValue 1 Start With 1 MaxValue 9999999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Item                                -- جدول ترميز بنود التصنيف
( Id         Number(7) NOT NULL,                           -- مفتاح رئيسي
  Grp_Id     Number(5) Default 1,                          -- مجموعة الترميز
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Itm_PK        PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Itm_UK        UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Itm_Group_Fk  Foreign Key (Grp_Id   ) References Stor_Cod_Grp  (Id),
  CONSTRAINT Stor_Cod_Itm_Status_Fk Foreign Key (Status_Id) References Phs_Cod_Status(Id),
  CONSTRAINT Stor_Cod_Itm_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT Stor_Cod_Itm_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/
Create Synonym Stor_Cod_Itm For Stor_Code_Item
/
Insert into Stor_Cod_Itm (Id,Grp_Id,Name) values (0,0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Spec1_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Specification1                  -- جدول ترميز التصنيف 1
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Spec1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Spec1_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Spec1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Spec1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Spec1 For Stor_Code_Specification1
/
Insert into Stor_Cod_Spec1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Spec2_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Specification2                  -- جدول ترميز التصنيف 2
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Spec2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Spec2_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Spec2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Spec2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Spec2 For Stor_Code_Specification2
/
Insert into Stor_Cod_Spec2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Spec3_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Specification3                  -- جدول ترميز التصنيف 3
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Spec3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Spec3_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Spec3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Spec3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Spec3 For Stor_Code_Specification3
/
Insert into Stor_Cod_Spec3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Spec4_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Specification4                  -- جدول ترميز التصنيف 4
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Spec4_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Spec4_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Spec4_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Spec4_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Spec4 For Stor_Code_Specification4
/
Insert into Stor_Cod_Spec4 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Spec5_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Specification5                  -- جدول ترميز التصنيف 5
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Spec5_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Spec5_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Spec5_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Spec5_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Spec5 For Stor_Code_Specification5
/
Insert into Stor_Cod_Spec5 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Spec6_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Specification6                  -- جدول ترميز التصنيف 6
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Spec6_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Spec6_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Spec6_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Spec6_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Spec6 For Stor_Code_Specification6
/
Insert into Stor_Cod_Spec6 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Spec7_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Specification7                  -- جدول ترميز التصنيف 7
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Spec7_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Spec7_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Spec7_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Spec7_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Spec7 For Stor_Code_Specification7
/
Insert into Stor_Cod_Spec7 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Spec8_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Specification8                  -- جدول ترميز التصنيف 8
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Spec8_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Spec8_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Spec8_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Spec8_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Spec8 For Stor_Code_Specification8
/
Insert into Stor_Cod_Spec8 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Spec9_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Specification9                  -- جدول ترميز التصنيف 9
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Spec9_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Spec9_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Spec9_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Spec9_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Spec9 For Stor_Code_Specification9
/
Insert into Stor_Cod_Spec9 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Spec0_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Specification0                  -- جدول ترميز التصنيف 0
( Id         Number(5) NOT NULL,				              -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,				              -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,				      -- الاسم
  Rem        Varchar2(100 Char),          				    -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Spec0_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Spec0_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Spec0_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Spec0_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Spec0 For Stor_Code_Specification0
/
Insert into Stor_Cod_Spec0 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Loc1_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Location1                           -- جدول ترميز الموقع 1
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Loc1_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Loc1_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Loc1_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Loc1_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Loc1 For Stor_Code_Location1
/
Insert into Stor_Cod_Loc1 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Loc2_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Location2                           -- جدول ترميز الموقع 2
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Loc2_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Loc2_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Loc2_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Loc2_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Loc2 For Stor_Code_Location2
/
Insert into Stor_Cod_Loc2 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
Create Sequence Stor_Cod_Loc3_Seq MinValue 1 Start With 1 MaxValue 99999 INCREMENT BY 1 CACHE 2;
Create Table Stor_Code_Location3                           -- جدول ترميز الموقع 3
( Id         Number(5) NOT NULL,                           -- مفتاح رئيسي
  Status_Id  Number(1) Default 1,                          -- حالة الترميز
  Name       Varchar2(100 Char) NOT NULL,                  -- الاسم
  Rem        Varchar2(100 Char),                           -- ملاحظات
  Ins_User   Number(5),  Ins_Date    Date,
  Upd_User   Number(5),  Upd_Date    Date,
  CONSTRAINT Stor_Cod_Loc3_PK     PRIMARY KEY (Id  ),
  CONSTRAINT Stor_Cod_Loc3_UK     UNIQUE      (Name),
  CONSTRAINT Stor_Cod_Loc3_Ins_FK Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT Stor_Cod_Loc3_Upd_FK Foreign Key (Upd_User) References Cpy_User(Id)
)
/
Create Synonym Stor_Cod_Loc3 For Stor_Code_Location3
/
Insert into Stor_Cod_Loc3 (Id,Name) values (0,'-');
----------------------------------------------------------------------------------------------------
