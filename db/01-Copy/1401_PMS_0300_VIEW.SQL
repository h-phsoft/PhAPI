CREATE OR REPLACE VIEW PMS_Request_VIEW AS
 SELECT ALL
        Mst.Id    MST_Id   ,
        Usr.Id    User_Id  , Usr.Name   User_Name  ,
        St.Id     Status_Id, St.Name    Status_Name, Mst.Status_Date  Status_Date,
        Mst.Num   MST_Num  , Mst.dDate  MST_Date   , Mst.Rem          MST_Rem    ,
        Trn.Id    Trn_Id   , Itm.Id     Item_Id    , Itm.LName        Item_Name  ,
        Trn.Qnt   Trn_Qnt  , Trn.Price  Trn_PRice  , Trn.Rem          Trn_Rem
   From PMS_MReq       Mst,
        PMS_TReq       Trn,
        PMS_Cod_Status ST ,
        Cpy_User       Usr,
        Stor_Item      Itm
  Where Trn.Mst_Id   =Mst.Id
    AND Mst.User_Id  =Usr.Id
    AND Mst.Status_Id=St.Id
    AND Trn.Item_Id  =Itm.Id
/
Create Synonym PMS_VRequest For PMS_Request_VIEW
/

CREATE OR REPLACE VIEW PMS_Purchase_Order_View AS
 SELECT ALL
        Mst.Id           MST_Id     ,
        Req.Num          Req_Num    , Req.dDate  Req_Date   , Req.Rem   Req_Rem    ,
        Cnt.Id           Cont_Id    , Cnt.Name   Cont_Name  ,
        Usr.Id           User_Id    , Usr.Name   User_Name  ,
        Crn.Id           Curn_Id    , Crn.Name   Curn_Name  ,
        St.Id            Status_Id  , St.Name    Status_Name,
        Mst.Num          MST_Num    , Mst.dDate  MST_Date   ,
        Mst.Rem          MST_Rem    ,
        Trn.Id           Trn_Id     , TReq_Id  ,
        Itm.Id           Item_Id    , Itm.LName  Item_Name  ,
        Trn.Qnt          Trn_Qnt    , Trn.CQnt   Trn_CQnt   ,
        Trn.Price        Trn_PRice  , Trn.Rem    Trn_Rem
   From PMS_MPurOrd    Mst,
        PMS_TPurOrd    Trn,
        PMS_MReq       Req,
        Mng_Cont       Cnt,
        Mng_Curn       Crn,
        PMS_Cod_Status ST ,
        Cpy_User       Usr,
        Stor_Item      Itm
  Where Trn.Mst_Id   =Mst.Id
    AND Mst.Req_Id   =Req.Id
    AND Mst.Cont_Id  =Cnt.Id
    AND Mst.User_Id  =Usr.Id
    AND Mst.Curn_Id  =Crn.Id
    AND Mst.Status_Id=St.Id
    AND Trn.Item_Id  =Itm.Id
/
Create Synonym PMS_VPurOrd For PMS_Purchase_Order_View
/

CREATE OR REPLACE VIEW PMS_Delivery_View AS
 SELECT ALL
        Mst.Id   MST_Id   ,
        Ord.Num  Ord_Num  , Ord.dDate  Ord_Date   , Ord.Rem   Ord_Rem    ,
        Cnt.Id   Cont_Id  , Cnt.Name   Cont_Name  ,
        Crn.Id   Curn_Id  , Crn.Name   Curn_Name  , Mst.Rate  Curn_Rate  ,
        St.Id    Status_Id, St.Name    Status_Name,
        Mst.Num  MST_Num  , Mst.dDate  MST_Date   ,
        Mst.Rem  MST_Rem  ,
        Trn.Id   Trn_Id   , TOrd_Id  ,
        Itm.Id   Item_Id  , Itm.LName  Item_Name  ,
        Trn.Qnt  Trn_Qnt  , Trn.Price  Trn_PRice  ,
        Trn.CAmt Trn_CAmt , Trn.Amt    Trn_Amt    ,
        Trn.Rem  Trn_Rem
   From PMS_MDeliv     Mst,
        PMS_TDeliv     Trn,
        PMS_MPurOrd    Ord,
        Mng_Cont       Cnt,
        Mng_Curn       Crn,
        PMS_Cod_Status ST ,
        Stor_Item      Itm
  Where Trn.Mst_Id   =Mst.Id
    AND Mst.POrd_Id   =Ord.Id
    AND Mst.Cont_Id  =Cnt.Id
    AND Mst.Curn_Id  =Crn.Id
    AND Mst.Status_Id=St.Id
    AND Trn.Item_Id  =Itm.Id
/
Create Synonym PMS_VDelivery For PMS_Delivery_View
/
