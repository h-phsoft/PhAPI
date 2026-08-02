CREATE OR REPLACE VIEW Trn_Balance_View AS 
 Select All
        Bln.Id    Bln_Id      , Bln.Name  Bln_Name     , Bln.Status_Id Bln_Status_Id,
        T.Id      Bln_Type_Id , T.Name    Bln_Type_Name, T.Rem         Bln_Type_Rem ,
        L.Id      Bln_Loc_Id  , L.Name    Bln_Loc_Name , L.Rem         Bln_Loc_Rem  ,
        Bln.Rem   Bln_Rem
   From Trn_Bln       Bln,
        Trn_Cod_Loc   L  ,
        Trn_Cod_Type  T
  Where Bln.Loc_Id  =L.Id
    And Bln.Type_Id =T.Id
/
Create Synonym Trn_VBln For Trn_Balance_View
/

CREATE OR REPLACE VIEW Trn_Balancing_Master_View AS 
 Select All
        Mst.Id         Mst_Id       ,
        Mst.Num        Mst_Num      , Mst.Pnum        Mst_Pnum       ,
        Mst.Bdate      Mst_Bdate    , Mst.Driver      Mst_Driver     ,
        Mst.Src        Mst_Src      , Mst.Dest        Mst_Dest       ,
        Mst.Commodity  Mst_Commodity, Mst.Rem         Mst_Rem        ,
        Mst.Fee        Mst_Fee      , Mst.WPenalty    Mst_WPenalty   ,
        Mst.APenalty   Mst_APenalty ,        
        Mst.Ins_User   Mst_Ins_User , Mst.Ins_Date    Mst_Ins_Date   ,
        Mst.Upd_User   Mst_Upd_User , Mst.Upd_Date    Mst_Upd_Date   ,
        Bln.Bln_Id   , Bln_Name     , Bln_Status_Id , Bln.Bln_Type_Id,
        Bln_Type_Name, Bln_Type_Rem , Bln.Bln_Loc_Id, Bln_Loc_Name   ,
        Bln_Loc_Rem  , Bln_Rem      ,
        M.Id           Model_Id     , M.Status_Id    Model_Status_Id ,
        M.Name         Model_Name   , M.Axes         Model_Axes      ,
        M.Weight       Model_Weight , M.Rem          Model_Rem       ,
        To_Number(To_Char(Mst.BDate,'YYYY'))         D_Year          ,
        To_Number(To_Char(Mst.BDate,'MM'))           D_Month         ,
        To_Number(To_Char(Mst.BDate,'DD'))           D_DayOfMonth    ,
        To_Number(To_Char(Mst.BDate,'DDD'))          D_DayOfYear     ,
        To_Number(To_Char(Mst.BDate,'D'))            D_DayOfWeek     ,
        To_Char(Mst.BDate,'YYYY-MM')                 D_YearMonth
   From Trn_Bln_Mst   Mst,
        Trn_VBln      Bln,
        Trn_Cod_Model M
  Where Mst.Bln_Id  =Bln.Bln_Id
    And Mst.Model_Id=M.Id
/
Create Synonym Trn_VBlncing_Mst For Trn_Balancing_Master_View
/

CREATE OR REPLACE VIEW Trn_Balancing_View AS 
 Select All
        Mst.Mst_Id           ,
        Mst.Mst_Num          , Mst.Mst_Pnum    , Mst.Mst_Bdate        , Mst.Mst_Driver     ,
        Mst.Mst_Src          , Mst.Mst_Dest    , Mst.Mst_Commodity    , Mst.Mst_Rem        ,
        Mst.Mst_Fee          , Mst.Mst_WPenalty, Mst.Mst_APenalty     ,
        Mst.Mst_Ins_User     , Mst.Mst_Ins_Date, Mst.Mst_Upd_User     , Mst.Mst_Upd_Date   ,
        Mst.Bln_Id           , Mst.Bln_Name    , Mst.Bln_Status_Id    , Mst.Bln_Type_Id    ,
        Mst.Bln_Type_Name    , Mst.Bln_Type_Rem, Mst.Bln_Loc_Id       , Mst.Bln_Loc_Name   ,
        Mst.Bln_Loc_Rem      , Mst.Bln_Rem     , Mst.Model_Id         , Mst.Model_Status_Id,
        Mst.Model_Name       , Mst.Model_Axes  , Mst.Model_Weight     , Mst.Model_Rem      ,
        Mst.D_Year           , Mst.D_Month     , Mst.D_DayOfMonth     , Mst.D_DayOfYear    ,
        Mst.D_DayOfWeek      , Mst.D_YearMonth ,
        Trn.Id                 Trn_Id          , Trn.Axe                Trn_Axe            ,
        NVL(Trn.Weight     ,0) Trn_Weight      , NVL(Trn.Weight1    ,0) Trn_Weight1        ,
        NVL(Trn.Weight2    ,0) Trn_Weight2     , NVL(Trn.OverWeight ,0) Trn_OverWeight     ,
        NVL(Trn.OverWeight1,0) Trn_OverWeight1 , NVL(Trn.OverWeight2,0) Trn_OverWeight2    ,
        Trn.Rem             Trn_Rem
   From Trn_VBlncing_Mst Mst,
        Trn_Bln_Trn      Trn
  Where Trn.Mst_Id(+)=Mst.Mst_Id
/
Create Synonym Trn_VBlncing For Trn_Balancing_View
/

CREATE OR REPLACE VIEW Trn_Total_Balancing_View AS 
 Select All
        Mst_Id             ,
        Mst_Num            , Mst_Pnum       , Mst_Bdate     , Mst_Driver     ,
        Mst_Src            , Mst_Dest       , Mst_Commodity , Mst_Rem        ,
        Mst_Fee            , Mst_WPenalty   , Mst_APenalty  ,
        Mst_Ins_User       , Mst_Ins_Date   , Mst_Upd_User  , Mst_Upd_Date   ,
        Bln_Id             , Bln_Name       , Bln_Status_Id , Bln_Type_Id    ,
        Bln_Type_Name      , Bln_Type_Rem   , Bln_Loc_Id    , Bln_Loc_Name   ,
        Bln_Loc_Rem        , Bln_Rem        , Model_Id      , Model_Status_Id,
        Model_Name         , Model_Axes     , Model_Weight  , Model_Rem      ,
        D_Year             , D_Month        , D_DayOfMonth  , D_DayOfYear    ,
        D_DayOfWeek        , D_YearMonth    ,
        SUM(Trn_Weight     ) Trn_Weight     ,
        SUM(Trn_Weight1    ) Trn_Weight1    ,
        SUM(Trn_Weight2    ) Trn_Weight2    ,
        SUM(Trn_OverWeight ) Trn_OverWeight ,
        SUM(Trn_OverWeight1) Trn_OverWeight1,
        SUM(Trn_OverWeight2) Trn_OverWeight2
   From Trn_VBlncing
  Group BY Mst_Id             ,
           Mst_Num            , Mst_Pnum       , Mst_Bdate     , Mst_Driver     ,
           Mst_Src            , Mst_Dest       , Mst_Commodity , Mst_Rem        ,
           Mst_Fee            , Mst_WPenalty   , Mst_APenalty  ,
           Mst_Ins_User       , Mst_Ins_Date   , Mst_Upd_User  , Mst_Upd_Date   ,
           Bln_Id             , Bln_Name       , Bln_Status_Id , Bln_Type_Id    ,
           Bln_Type_Name      , Bln_Type_Rem   , Bln_Loc_Id    , Bln_Loc_Name   ,
           Bln_Loc_Rem        , Bln_Rem        , Model_Id      , Model_Status_Id,
           Model_Name         , Model_Axes     , Model_Weight  , Model_Rem      ,
           D_Year             , D_Month        , D_DayOfMonth  , D_DayOfYear    ,
           D_DayOfWeek        , D_YearMonth
/
Create Synonym Trn_VTBlncing For Trn_Total_Balancing_View
/

CREATE OR REPLACE VIEW Trn_Balancing_Pay_View AS 
 Select All 
        Mst.Mst_Id        ,
        Mst.Mst_Num       , Mst.Mst_Pnum        , Mst.Mst_Bdate     ,
        Mst.Mst_Driver    , Mst.Mst_Src         , Mst.Mst_Dest      ,
        Mst.Mst_Commodity , Mst.Mst_Rem         , Mst.Mst_Ins_User  , Mst.Mst_Ins_Date    ,
        Mst.Mst_Upd_User  , Mst.Mst_Upd_Date    , Mst.Bln_Id        ,
        Mst.Bln_Name      , Mst.Bln_Status_Id   , Mst.Bln_Type_Id   , Mst.Bln_Type_Name   ,
        Mst.Bln_Type_Rem  ,
        Mst.Bln_Loc_Id    , Mst.Bln_Loc_Name    , Mst.Bln_Loc_Rem   , Mst.Bln_Rem         ,
        Mst.Model_Id      , Mst.Model_Status_Id , Mst.Model_Name    , Mst.Model_Axes      ,
        Mst.Model_Weight  , Mst.Model_Rem       , D_Year            , D_Month             ,
        D_DayOfMonth      , D_DayOfYear         , D_DayOfWeek       , D_YearMonth         ,
        P.Id                Pay_Id              ,
        P.Amt               Pay_Amt             ,
        P.Rem               Pay_Rem             ,
        Pp.Id               Penalty_id          ,        Pp.Name        Penalty_name     ,
        Pp.Status_Id        Penalty_statusid    ,        Pp.Type_Id     Penalty_typeid   ,
        Pp.For_Id           Penalty_forid       ,        Pp.Amt         Penalty_amt      ,
        Pp.Rem              Penalty_rem         ,
        Pf.Id               Fee_Id              ,        Pf.Name        Fee_Name         ,
        Pf.Status_Id        Fee_Statusid        ,        Pf.Type_Id     Fee_Typeid       ,
        Pf.For_Id           Fee_Forid           ,        Pf.Amt         Fee_Amt          ,
        Pf.Rem              Fee_Rem             ,
        Ptyp.Id             Ptype_Id            ,        Ptyp.Name      Ptype_Name       ,
        Ptyp.Rem            Ptype_Rem           ,
        Pamt.Id             Pamt_Type_id        ,        Pamt.Name      Pamt_Type_name   ,
        Pamt.Rem            Pamt_Type_rem       ,        Famt.Id        Famt_Type_id     ,
        Famt.Name           Famt_Type_name      ,        Famt.Rem       Famt_Type_rem    ,
        Pfor.Id             Penalty_For_Id      ,        Pfor.Name      Penalty_For_Name ,
        Pfor.Rem            Penalty_For_Rem     ,
        Ffor.Id             Fee_For_Id          ,        Ffor.Name      Fee_For_Name     ,
        Ffor.Rem            Fee_For_Rem
   From Trn_VBlncing_Mst Mst ,
        Trn_Bln_Penalty  P   ,
        Trn_Penalties    PP  ,
        Trn_Fees         PF  ,
        Trn_Cod_Ptype    pTyp,
        Trn_Cod_For      Pfor,
        Trn_Cod_For      Ffor,
        Phs_Cod_Amttype  Pamt,
        Phs_Cod_Amttype  Famt
  Where Mst.Mst_Id  = P.Mst_Id 
    And P.Penalty_Id= pp.Id
    And P.fee_Id    = pf.Id
    And P.PType_Id  = pTyp.Id
    And PP.Type_Id  = Pamt.Id
    And Pf.Type_Id  = Famt.Id
    And PP.For_Id   = Pfor.Id
    And Pf.For_Id   = Ffor.Id
/
CREATE OR REPLACE VIEW Trn_Balancing_Pay_View AS 
 Select All
        Mst_Id       ,
        Mst_Num      , Mst_Pnum       , Mst_Bdate    , Mst_Driver  ,
        Mst_Src      , Mst_Dest       , Mst_Commodity, Mst_Rem     ,
        Mst_Ins_User , Mst_Ins_Date   , Mst_Upd_User , Mst_Upd_Date,
        Bln_Id       , Bln_Name       , Bln_Status_Id, Bln_Type_Id ,
        Bln_Type_Name, Bln_Type_Rem   , Bln_Loc_Id   , Bln_Loc_Name,
        Bln_Loc_Rem  , Bln_Rem        ,
        Model_Id     , Model_Status_Id, Model_Name   , Model_Axes  ,
        Model_Weight , Model_Rem      ,
        D_Year       , D_Month        , D_DayOfMonth , D_DayOfYear ,
        D_DayOfWeek  , D_YearMonth    ,
        Mst_Fee      , Mst_WPenalty   , Mst_APenalty
   From Trn_VBlncing_Mst
/
Create Synonym Trn_vPay For Trn_Balancing_Pay_View
/

CREATE OR REPLACE VIEW Trn_Leaky_Cars_View AS 
 Select All
        B.Bln_Id      , B.Bln_Name       , B.Bln_Status_Id,
        B.Bln_Type_Id , B.Bln_Type_Name  , B.Bln_Type_Rem ,
        B.Bln_Loc_Id  , B.Bln_Loc_Name   , B.Bln_Loc_Rem  ,
        B.Bln_Rem     ,
        C.Id            LCar_Id          ,
        C.PNum          LCar_PNum        ,
        C.dDate         LCar_Date        ,
        To_Number(To_Char(C.dDate,'YYYY')) D_Year         ,
        To_Number(To_Char(C.dDate,'MM'))   D_Month        ,
        To_Number(To_Char(C.dDate,'DD'))   D_DayOfMonth   ,
        To_Number(To_Char(C.dDate,'DDD'))  D_DayOfYear    ,
        To_Number(To_Char(C.dDate,'D'))    D_DayOfWeek    ,
        To_Char(C.dDate,'YYYY-MM')         D_YearMonth    ,
        C.Rem           LCar_Rem
   From Trn_VBln     B,
        Trn_Leak_Car C
  Where C.Bln_Id=B.Bln_Id
/
Create Synonym Trn_VLeak_Car For Trn_Leaky_Cars_View
/
