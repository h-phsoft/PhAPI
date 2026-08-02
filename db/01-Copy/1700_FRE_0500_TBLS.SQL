Create Sequence Fre_HAWB_Seq MinValue 1 Start With 1 MaxValue 99999999999999999999 INCREMENT BY 1 CACHE 2;
Create Table Fre_Hous_Airwabill                -- HAWB
( Id            Number(20),                    -- مفتاح رئيسي
  Dept_Id       Number(20) Default 0,          -- النشاط
  Unit_Id       Number(20) Default 0,          -- القسم
  Type_Code     Varchar2(2 Char),              -- Type
  Num           Number(10) Default 0,          -- Doc No.
  dDate         Date Default Sysdate,          -- Flight/Day
  DExec         Date Default Sysdate,          -- Exec Date
  DHLNo         Varchar2(30 Char),             -- DHL GF Tariff
  DHLGNo        Varchar2(30 Char),             -- DHL Global Forwarding Number
  Orig_Id       Number(20) Default 0,          -- المصدر
  OPort_Id      Number(20) Default 0,          -- المصدر
  OName         Varchar2(100 Char),            -- اسم المصدر في حال عدم وجوده ضمن التراميز
  Dest_Id       Number(20) Default 0,          -- المقصد
  DPort_Id      Number(20) Default 0,          -- المقصد
  DName         Varchar2(100 Char),            -- اسم المقصد في حال عدم وجوده ضمن التراميز
  Comod_Id      Number(20) Default 0,          -- البضاعة
  vComd         Varchar2(250 Char),            -- البضاعة
  ShipAcc       Varchar2(30 Char),             -- Shipper Account No.
  ShipNo        Varchar2(30 Char),             -- Shipper Reference
  ShipNad       Varchar2(500 Char),            -- Shipper Name and Address
  ConsAcc       Varchar2(30 Char),             -- Consignee Account No.
  ConsNo        Varchar2(30 Char),             -- Consignee Order No.
  ConsNad       Varchar2(500 Char),            -- Consignee Name and Address
  ConsNote      Varchar2(500 Char),            -- Consignee Notify
  SOIO          Varchar2(30 Char),             -- Signature of Issuing Office
  ExecOn        Varchar2(30 Char),             -- Executed on
  Att           Varchar2(30 Char),             -- At
  QDesc         Varchar2(1000 Char),           -- Quantity Description and Marks
  ITerm_Id      Number(5) Default 0,           -- Inco Term
  PTerm_Id      Number(5) Default 0,           -- Payment Term
  Ins_User      Number(5), Ins_Date     Date,
  Upd_User      Number(5), Upd_Date     Date,
  CONSTRAINT    Fre_HAWB_PK       Primary Key (Id),
  CONSTRAINT    Fre_HAWB_UK       Unique      (Dept_Id, Unit_Id, Num),
  CONSTRAINT    Fre_HAWB_Dept_FK  Foreign Key (Dept_Id ) References Cpy_Dept         (Id),
  CONSTRAINT    Fre_HAWB_Unit_FK  Foreign Key (Unit_Id ) References Cpy_Unit         (Id),
  CONSTRAINT    Fre_HAWB_ITerm_FK Foreign Key (ITerm_Id) References Fre_Cod_Inco_Term(Id),
  CONSTRAINT    Fre_HAWB_PTerm_FK Foreign Key (PTerm_Id) References Fre_Cod_Pay_Term (Id),
  CONSTRAINT    Fre_HAWB_Orig_FK  Foreign Key (Orig_Id ) References Fre_Cod_Cntry    (Id),
  CONSTRAINT    Fre_HAWB_OPort_FK Foreign Key (OPort_Id) References Fre_Cod_City     (Id),
  CONSTRAINT    Fre_HAWB_Dest_FK  Foreign Key (Dest_Id ) References Fre_Cod_Cntry    (Id),
  CONSTRAINT    Fre_HAWB_DPort_FK Foreign Key (DPort_Id) References Fre_Cod_City     (Id),
  CONSTRAINT    Fre_HAWB_Loc_FK   Foreign Key (Comod_Id) References Fre_Cod_Comod    (Id),
  CONSTRAINT    Fre_HAWB_Ins_FK   Foreign Key (Ins_User) References Cpy_User         (Id),
  CONSTRAINT    Fre_HAWB_Upd_FK   Foreign Key (Upd_User) References Cpy_User         (Id)
)
/
Create Synonym Fre_HAWB For Fre_Hous_Airwabill
/
