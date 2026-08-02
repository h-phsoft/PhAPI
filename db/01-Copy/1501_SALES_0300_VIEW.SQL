CREATE OR REPLACE VIEW Sal_Sales_VIEW AS
 SELECT ALL
        Mst.Id       Mst_Id     ,
        Per.Id       Period_Id  , Per.Name    Period_Name,
        Cnt.Id       Cont_Id    , Cnt.Name    Cont_Name  ,
        Acc.Id       Acc_Id     , Acc.Name    Acc_Name   ,
        Doc.Id       Doc_Id     , Doc.Name    Doc_Name   ,
        Crn.Id       Curn_Id    , Crn.Name    Curn_Name  , Mst.Rate        Curn_Rate ,
        BCrn.Id      BCurn_Id   , BCrn.Name   BCurn_Name , Mst.BCurn_Rate  BCurn_Rate,
        Reg.Id       Regn_Id    , Reg.Name    Regn_Name  ,
        Rep.Id       Repr_Id    , Rep.Name    Repr_Name  ,     
        Mst.Cmt_Id , Mst.Cmv    , Mst.Com   , Mst.Ccom   ,
        Mst.BCom   , Mst.Rel_Id , Mst.Fin_Id             ,
        Mst.Num      Mst_Num    , Mst.dDate   Mst_dDate  ,
        Mst.DocN     Mst_DocN   , Mst.DocD    Mst_DocD   ,
        Mst.Rem      Mst_Rem    ,
        To_Number(To_Char(Mst.dDate,'YYYY'))   D_Year           ,
        To_Number(To_Char(Mst.dDate,'MM'))     D_Month          ,
        To_Number(To_Char(Mst.dDate,'DD'))     D_DayOfMonth     ,
        To_Number(To_Char(Mst.dDate,'DDD'))    D_DayOfYear      ,
        To_Number(To_Char(Mst.dDate,'D'))      D_DayOfWeek      ,
        To_Char(Mst.dDate,'YYYY-MM')           D_YearMonth      ,
        Trn.Id       Trn_Id     , Trn.Ord     Trn_Ord    ,
        Trn.Qnt      Trn_Qnt    , Trn.WQnt    Trn_WQnt   ,
        Trn.SWQnt    Trn_SWQnt  , Trn.Price   Trn_Price  ,
        Trn.CAmt     Trn_CAmt   , Trn.Amt     Trn_Amt    ,
        Trn.BAmt     Trn_BAmt   , Trn.ICS_Id, Trn.SICS_Id,
        Itm.Item_Id      , Itm.Item_Num   ,   
        Itm.Item_Part    ,        
        Itm.Item_LName   , Itm.Item_IName ,
        Itm.Item_FName   ,
        Itm.Status_Id    , Itm.Status_Name,
        Itm.Type_Id      , Itm.Type_Name  ,
        Itm.MCost_Id     , Itm.MCost_Name ,
        Itm.Unit_Id        Item_Unit_Id   ,
        Itm.Unit_Name      Item_Unit_Name ,        
        Itm.Cat_Id       , Itm.Cat_Name   ,
        Itm.Spc1_Id      , Itm.Spc1_Name  ,
        Itm.Spc2_Id      , Itm.Spc2_Name  ,
        Itm.Spc3_Id      , Itm.Spc3_Name  ,
        Itm.Spc4_Id      , Itm.Spc4_Name  ,
        Itm.Spc5_Id      , Itm.Spc5_Name  ,
        Itm.Spc6_Id      , Itm.Spc6_Name  ,
        Itm.Spc7_Id      , Itm.Spc7_Name  ,
        Itm.Spc8_Id      , Itm.Spc8_Name  ,
        Itm.Spc9_Id      , Itm.Spc9_Name  ,
        Itm.Spc0_Id      , Itm.Spc0_Name  ,
        Itm.InSale_Id    , Itm.InSale_Name,
        Itm.Season_Id    , Itm.Season_Name,
        Itm.Item_DWarnty , Itm.Item_NofP  ,
        Itm.Item_Min_Unit, Itm.Item_Box   ,
        Itm.Item_CPrice  , Itm.Item_NPrice,
        Itm.Item_DPrice  , Itm.Item_SPrice,
        Itm.Item_WPrice  , Itm.Item_RPrice,
        Itm.Item_HPrice  , Itm.Item_MPrice,Itm.Item_Image,
        Itm.Method_Id    , Itm.Method_Name,
        Itm.Barcode_Id   , Itm.Model_Id    Itm_Model_Id  , 
        Itm.Color_Id       Itm_Color_Id                  ,
        Itm.Size_Id        Itm_Size_Id                   ,        
        Itm.Lot_Id       , Itm.Ser_Id     , Itm.SDate_Id , Itm.EDate_Id ,
        Itm.Length_Id    , Itm.Width_Id   , Itm.Height_Id,
        Unt.Id       Unit_Id    , Unt.Name    Unit_Name  ,
        Mdl.Id       Model_Id   , Mdl.Name    Model_Name ,
        Clr.Id       Color_Id   , Clr.Name    Color_Name ,
        Siz.Id       Size_Id    , Siz.Name    Size_Name  ,
        Trn.nLength  Trn_nLength, Trn.nWidth  Trn_nWidth ,
        Trn.nHeight  Trn_nHeight, Trn.Barcode Trn_Barcode,
        Trn.LotSer   Trn_LotSer , Trn.SDate   Trn_SDate  ,
        Trn.EDate    Trn_EDate  , Trn.Rem     Trn_Rem
   FROM Sal_MSal       Mst ,
        Sal_TSal       Trn ,
        Cpy_Period     Per ,
        Mng_Cont       Cnt ,
        Mng_Regn       Reg ,
        Mng_Curn       Crn ,
        Mng_Curn       BCrn,
        CRM_Repr       Rep ,
        Acc_Acc        Acc ,
        Cpy_Cod_Doc    Doc ,
        Stor_VItem     Itm ,
        Cpy_Cod_Unit   Unt ,
        Stor_Cod_Model Mdl ,
        Stor_Cod_Color Clr ,
        Stor_Cod_Size  Siz
  WHERE Trn.Mst_Id   =Mst.Id
    AND Mst.Period_Id=Per.Id
    AND Mst.Regn_Id  =Reg.Id
    AND Mst.Cont_Id  =Cnt.Id
    AND Mst.Curn_Id  =Crn.Id
    AND Mst.BCurn_Id =BCrn.Id
    AND Mst.Acc_Id   =Acc.Id
    AND Mst.Repr_Id  =Rep.Id
    AND Mst.Doc_Id   =Doc.Id
    AND Trn.Item_Id  =Itm.Item_Id
    AND Trn.Unit_Id  =Unt.Id
    AND Trn.Model_Id =Mdl.Id
    AND Trn.Color_Id =Clr.Id
    AND Trn.Size_Id  =Siz.Id
/
Create Synonym Sal_VSales For Sal_Sales_VIEW
/

CREATE OR REPLACE VIEW Sal_Return_VIEW AS
 SELECT ALL
        Mst.Id       Mst_Id     ,
        Per.Id       Period_Id  , Per.Name    Period_Name,
        Cnt.Id       Cont_Id    , Cnt.Name    Cont_Name  ,
        Acc.Id       Acc_Id     , Acc.Name    Acc_Name   ,
        Doc.Id       Doc_Id     , Doc.Name    Doc_Name   ,
        Crn.Id       Curn_Id    , Crn.Name    Curn_Name  , Mst.Rate        Curn_Rate ,
        BCrn.Id      BCurn_Id   , BCrn.Name   BCurn_Name , Mst.BCurn_Rate  BCurn_Rate,
        Reg.Id       Regn_Id    , Reg.Name    Regn_Name  ,
        Rep.Id       Repr_Id    , Rep.Name    Repr_Name  ,     
        Mst.Cmt_Id , Mst.Cmv    , Mst.Com   , Mst.Ccom   ,
        Mst.BCom   , Mst.Rel_Id , Mst.Fin_Id             ,
        Mst.Num      Mst_Num    , Mst.dDate   Mst_dDate  ,
        Mst.DocN     Mst_DocN   , Mst.DocD    Mst_DocD   ,
        Mst.Rem      Mst_Rem    ,
        To_Number(To_Char(Mst.dDate,'YYYY'))   D_Year           ,
        To_Number(To_Char(Mst.dDate,'MM'))     D_Month          ,
        To_Number(To_Char(Mst.dDate,'DD'))     D_DayOfMonth     ,
        To_Number(To_Char(Mst.dDate,'DDD'))    D_DayOfYear      ,
        To_Number(To_Char(Mst.dDate,'D'))      D_DayOfWeek      ,
        To_Char(Mst.dDate,'YYYY-MM')           D_YearMonth      ,
        Trn.Id       Trn_Id     , Trn.Ord     Trn_Ord    ,
        Trn.Qnt      Trn_Qnt    , Trn.WQnt    Trn_WQnt   ,
        Trn.SWQnt    Trn_SWQnt  , Trn.Price   Trn_Price  ,
        Trn.CAmt     Trn_CAmt   , Trn.Amt     Trn_Amt    ,
        Trn.BAmt     Trn_BAmt   , Trn.ICS_Id, Trn.SICS_Id,
        Itm.Item_Id             , Itm.Item_Num   ,   
        Itm.Item_Part           ,        
        Itm.Item_LName          , Itm.Item_IName ,
        Itm.Item_FName          ,
        Itm.Status_Id           , Itm.Status_Name,
        Itm.Type_Id             , Itm.Type_Name  ,
        Itm.MCost_Id            , Itm.MCost_Name ,
        Itm.Unit_Id               Item_Unit_Id   ,
        Itm.Unit_Name             Item_Unit_Name ,        
        Itm.Cat_Id              , Itm.Cat_Name   ,
        Itm.Spc1_Id      , Itm.Spc1_Name  ,
        Itm.Spc2_Id      , Itm.Spc2_Name  ,
        Itm.Spc3_Id      , Itm.Spc3_Name  ,
        Itm.Spc4_Id      , Itm.Spc4_Name  ,
        Itm.Spc5_Id      , Itm.Spc5_Name  ,
        Itm.Spc6_Id      , Itm.Spc6_Name  ,
        Itm.Spc7_Id      , Itm.Spc7_Name  ,
        Itm.Spc8_Id      , Itm.Spc8_Name  ,
        Itm.Spc9_Id      , Itm.Spc9_Name  ,
        Itm.Spc0_Id      , Itm.Spc0_Name  ,
        Itm.InSale_Id           , Itm.InSale_Name,
        Itm.Season_Id           , Itm.Season_Name,
        Itm.Item_DWarnty        , Itm.Item_NofP  ,
        Itm.Item_Min_Unit       , Itm.Item_Box   ,
        Itm.Item_CPrice         , Itm.Item_NPrice,
        Itm.Item_DPrice         , Itm.Item_SPrice,
        Itm.Item_WPrice         , Itm.Item_RPrice,
        Itm.Item_HPrice         , Itm.Item_MPrice,Itm.Item_Image,
        Itm.Method_Id           , Itm.Method_Name,
        Itm.Barcode_Id          , Itm.Model_Id    Itm_Model_Id  , 
        Itm.Color_Id              Itm_Color_Id                  ,
        Itm.Size_Id               Itm_Size_Id                   ,        
        Itm.Lot_Id              , Itm.Ser_Id                    ,
        Itm.SDate_Id            , Itm.EDate_Id                  ,
        Itm.Length_Id           , Itm.Width_Id   , Itm.Height_Id,  
        Unt.Id       Unit_Id    , Unt.Name         Unit_Name    ,
        Mdl.Id       Model_Id   , Mdl.Name         Model_Name   ,
        Clr.Id       Color_Id   , Clr.Name         Color_Name   ,
        Siz.Id       Size_Id    , Siz.Name         Size_Name    ,
        Trn.nLength  Trn_nLength, Trn.nWidth       Trn_nWidth   ,
        Trn.nHeight  Trn_nHeight, Trn.Barcode      Trn_Barcode  ,
        Trn.LotSer   Trn_LotSer , Trn.SDate        Trn_SDate    ,
        Trn.EDate    Trn_EDate  , Trn.Rem          Trn_Rem
   FROM Sal_MRet       Mst ,
        Sal_TRet       Trn ,
        Cpy_Period     Per ,
        Mng_Cont       Cnt ,
        Mng_Regn       Reg ,
        Mng_Curn       Crn ,
        Mng_Curn       BCrn,
        CRM_Repr       Rep ,
        Acc_Acc        Acc ,
        Cpy_Cod_Doc    Doc ,
        Stor_VItem     Itm ,
        Cpy_Cod_Unit   Unt ,
        Stor_Cod_Model Mdl ,
        Stor_Cod_Color Clr ,
        Stor_Cod_Size  Siz
  WHERE Trn.Mst_Id   =Mst.Id
    AND Mst.Period_Id=Per.Id
    AND Mst.Regn_Id  =Reg.Id
    AND Mst.Cont_Id  =Cnt.Id
    AND Mst.Curn_Id  =Crn.Id
    AND Mst.BCurn_Id =BCrn.Id
    AND Mst.Acc_Id   =Acc.Id
    AND Mst.Repr_Id  =Rep.Id
    AND Mst.Doc_Id   =Doc.Id
    AND Trn.Item_Id  =Itm.Item_Id
    AND Trn.Unit_Id  =Unt.Id
    AND Trn.Model_Id =Mdl.Id
    AND Trn.Color_Id =Clr.Id
    AND Trn.Size_Id  =Siz.Id
/
Create Synonym Sal_VReturn For Sal_Return_VIEW
/

CREATE OR REPLACE VIEW Sal_ALL_Sales_VIEW AS
 SELECT ALL
        Mst_Id      , 1  Trt     , Period_Id  , Period_Name, Cont_Id    , Cont_Name   , Acc_Id        , Acc_Name     ,
        Doc_Id      , Doc_Name   , Curn_Id    , Curn_Name  , Curn_Rate  , BCurn_Id    , BCurn_Name    , BCurn_Rate   ,
        Rel_Id      , Fin_Id     , Mst_Num    , Mst_dDate  , Mst_DocN   , Mst_DocD    , Mst_Rem       , 
        To_Number(To_Char(Mst_dDate,'YYYY'))   D_Year      ,
        To_Number(To_Char(Mst_dDate,'MM'))     D_Month     ,
        To_Number(To_Char(Mst_dDate,'DD'))     D_DayOfMonth,
        To_Number(To_Char(Mst_dDate,'DDD'))    D_DayOfYear ,
        To_Number(To_Char(Mst_dDate,'D'))      D_DayOfWeek ,
        To_Char(Mst_dDate,'YYYY-MM')           D_YearMonth ,                             
        Regn_Id     , Regn_Name  , Repr_Id    , Repr_Name  , Cmt_Id     , Cmv         , Com         , Ccom            ,
        BCom        ,        
        Trn_Id      , Item_Id    , Item_Num   , Item_Part  , Item_LName , Item_IName   , Item_FName    , Status_Id    ,
        Status_Name , Type_Id    , Type_Name  , MCost_Id   , MCost_Name , Item_Unit_Id , Item_Unit_Name, Cat_Id       ,
        Cat_Name    ,
        Spc1_Id     , Spc1_Name  , Spc2_Id    , Spc2_Name  , Spc3_Id     , Spc3_Name   , Spc4_Id    , Spc4_Name  ,
        Spc5_Id     , Spc5_Name  , Spc6_Id    , Spc6_Name  , Spc7_Id     , Spc7_Name   , Spc8_Id    , Spc8_Name  ,
        Spc9_Id     , Spc9_Name  , Spc0_Id    , Spc0_Name  ,
        InSale_Id   , InSale_Name, Season_Id  , Season_Name, Item_DWarnty, Item_NofP   , Item_Min_Unit ,
        Item_Box    , Item_CPrice, Item_NPrice, Item_DPrice, Item_SPrice , Item_WPrice , Item_RPrice   , Item_HPrice  ,
        Item_MPrice , Item_Image , Method_Id  , Method_Name, Barcode_Id  , Itm_Model_Id, Itm_Color_Id  , Itm_Size_Id  ,
        Lot_Id      , Ser_Id     , SDate_Id   , EDate_Id   , Length_Id   , Width_Id    , Height_Id     ,
        Trn_Ord     , ICS_Id     , SICS_Id    , Unit_Id    , Unit_Name   ,
        Model_Id    , Model_Name , Color_Id   , Color_Name , Size_Id     , Size_Name   , Trn_nLength   , Trn_nWidth   ,
        Trn_nHeight , Trn_Barcode, Trn_LotSer , Trn_SDate  , Trn_EDate   , Trn_Rem     ,
        Trn_Qnt     ,
        Trn_WQnt    ,
        Trn_SWQnt   ,
        Trn_Price   ,
        Trn_CAmt    ,
        Trn_Amt     ,
        Trn_BAmt
   FROM Sal_VSales
 UNION
 SELECT ALL
        Mst_Id      , -1  Trt    , Period_Id  , Period_Name, Cont_Id    , Cont_Name   , Acc_Id        , Acc_Name  ,
        Doc_Id      , Doc_Name   , Curn_Id    , Curn_Name  , Curn_Rate  , BCurn_Id    , BCurn_Name    , BCurn_Rate,
        Rel_Id      , Fin_Id     , Mst_Num    , Mst_dDate  , Mst_DocN   , Mst_DocD    , Mst_Rem       ,
        To_Number(To_Char(Mst_dDate,'YYYY'))   D_Year      ,
        To_Number(To_Char(Mst_dDate,'MM'))     D_Month     ,
        To_Number(To_Char(Mst_dDate,'DD'))     D_DayOfMonth,
        To_Number(To_Char(Mst_dDate,'DDD'))    D_DayOfYear ,
        To_Number(To_Char(Mst_dDate,'D'))      D_DayOfWeek ,
        To_Char(Mst_dDate,'YYYY-MM')           D_YearMonth ,
        Regn_Id      , Regn_Name  , Repr_Id    , Repr_Name  , Cmt_Id     , Cmv          , -1*Com Com    , -1*Ccom Ccom,
        -1*BCom Bcom ,        
        Trn_Id       ,Item_Id     , Item_Num   , Item_Part  , Item_LName , Item_IName   , Item_FName    , Status_Id    ,
        Status_Name  , Type_Id    , Type_Name  , MCost_Id   , MCost_Name , Item_Unit_Id , Item_Unit_Name, Cat_Id       ,
        Cat_Name     ,
        Spc1_Id      , Spc1_Name  , Spc2_Id    , Spc2_Name  , Spc3_Id     , Spc3_Name   , Spc4_Id    , Spc4_Name  ,
        Spc5_Id      , Spc5_Name  , Spc6_Id    , Spc6_Name  , Spc7_Id     , Spc7_Name   , Spc8_Id    , Spc8_Name  ,
        Spc9_Id      , Spc9_Name  , Spc0_Id    , Spc0_Name  ,
        InSale_Id    , InSale_Name, Season_Id  , Season_Name, Item_DWarnty, Item_NofP   , Item_Min_Unit ,
        Item_Box     , Item_CPrice, Item_NPrice, Item_DPrice, Item_SPrice , Item_WPrice , Item_RPrice   , Item_HPrice  ,
        Item_MPrice  , Item_Image , Method_Id  , Method_Name, Barcode_Id  , Itm_Model_Id, Itm_Color_Id  , Itm_Size_Id  ,
        Lot_Id       , Ser_Id     , SDate_Id   , EDate_Id   , Length_Id   , Width_Id    , Height_Id     ,        
        Trn_Ord      , ICS_Id     , SICS_Id    , Unit_Id    , Unit_Name   ,
        Model_Id     , Model_Name , Color_Id   , Color_Name , Size_Id     , Size_Name   , Trn_nLength, Trn_nWidth ,
        Trn_nHeight  , Trn_Barcode, Trn_LotSer , Trn_SDate  , Trn_EDate   , Trn_Rem     ,
        -1*Trn_Qnt    Trn_Qnt    ,
        -1*Trn_WQnt   Trn_WQnt   ,
        -1*Trn_SWQnt  Trn_SWQnt  ,
        -1*Trn_Price  Trn_Price  ,
        -1*Trn_CAmt   Trn_CAmt   ,
        -1*Trn_Amt    Trn_Amt    ,
        -1*Trn_BAmt   Trn_BAmt
   FROM Sal_VReturn
/
Create Synonym Sal_VAllSales For Sal_ALL_Sales_VIEW
/