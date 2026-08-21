----------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Fund_Box_View AS
 SELECT cb.Id Box_Id   , cb.Name Box_Name   , cb.Rem   Box_Rem    ,
        ac.Id Acc_Id   , ac.Num  Acc_Num    , ac.Name  Acc_Name   , ac.Rem Acc_Rem,        us.Id User_Id  , us.Name User_Name  , us.Logon User_Logon ,        st.Id Status_Id, st.Name Status_Name, st.Rem   Status_Rem   FROM Fund_Box       cb,
        Cpy_User       us,
        Acc_Acc        ac,
        Phs_Cod_Status st
  WHERE cb.User_Id  =us.Id
    AND cb.Acc_Id   =ac.Id
    AND cb.Status_Id=st.Id
/
Create Synonym Fund_VBox For Fund_Box_View
/
----------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW Fund_Diary_View AS
 SELECT ac.Id        Acc_Id       , ac.Num     Acc_Num    ,        ac.Name      Acc_Name     , ac.Rem     Acc_Rem    ,        cn.Id        Cost_Id      , cn.Num     Cost_Num   ,        cn.Name      Cost_Name    , cc.Id      Curn_Id    ,        cc.Name      Curn_Name    , cc.Rate    Curn_Rate  ,        cc.Code      Curn_Code    ,        it.Id        Item_Id      , it.Name    Item_Name  ,
        dp.Id        Dept_Id      , dp.Name    Dept_Name  ,
        ct.Id        Type_Id      , ct.Name    Type_Name  ,        cb.Id        Box_Id       , cb.User_Id Box_User_Id,        cb.Acc_Id    Box_Acc_Id   , cb.Cost_Id Box_Cost_Id,        cb.Status_Id Box_Status_Id, cb.Name    Box_Name   ,        cb.Rem       Box_Rem      , aa.Id      Id         ,        aa.nPrints   Prints       , aa.dDate   dDate      ,        aa.CAmt      CAmt         , aa.Rate    Rate       ,        aa.Amt       Amt          , aa.Rem     Rem        ,        aa.Attach    Attach       ,
        Decode(NVL(aa.Type_Id,1), 1,aa.CAmt, 0) CollectC  ,
        Decode(NVL(aa.Type_Id,1), 2,aa.CAmt, 0) PaymentC  ,
        Decode(NVL(aa.Type_Id,1), 1,aa.Amt , 0) Collect   ,
        Decode(NVL(aa.Type_Id,1), 2,aa.Amt , 0) Payment   ,
        Decode(NVL(aa.Type_Id,1), 1,aa.CAmt, 0) CrdC      ,
        Decode(NVL(aa.Type_Id,1), 2,aa.CAmt, 0) DebC      ,
        Decode(NVL(aa.Type_Id,1), 1,aa.Amt , 0) Crd       ,
        Decode(NVL(aa.Type_Id,1), 2,aa.Amt , 0) Deb
   FROM Fund_Cod_Type ct,
        Mng_Curn      cc,
        Fund_Box      cb,
        Acc_Acc       ac,
        Acc_Cost      cn,
        Fund_Item     it,
        Fund_Dept     dp,
        Fund_Diary    aa
  WHERE aa.Type_Id=ct.Id
    AND aa.Curn_Id=cc.Id
    AND aa.Box_Id =cb.Id
    AND aa.Acc_Id =ac.Id
    AND aa.Cost_Id=cn.Id
    AND aa.Item_Id=it.Id
    AND aa.Dept_Id=dp.Id
/
Create Synonym Fund_VDiary For Fund_Diary_View
/
