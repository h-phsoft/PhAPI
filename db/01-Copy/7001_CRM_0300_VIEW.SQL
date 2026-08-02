CREATE OR REPLACE VIEW CRM_Contact_View AS
 SELECT C.Id   , C.Num    , C.Title, C.LName , C.IName, C.Legal_Name, C.Owner  , C.Contact,
        C.SDate, C.EDate  , C.Phone, C.Mobile, C.Fax  , C.Email     , C.Website, C.Address,
        C.Rem  ,
        S.Id     Status_Id, S.Name   Status_Name,
        R.Id     Repr_Id  , R.Name   Repr_Name
   FROM CRM_Cont       C
   JOIN Phs_Cod_Status S ON C.Status_Id      = S.Id
   JOIN CRM_Repr       R ON NVL(C.Repr_Id,0) = R.Id
/
CREATE SYNONYM CRM_VCont FOR CRM_Contact_View
/

CREATE OR REPLACE VIEW CRM_Contact_Representative_View AS
 SELECT C.Id   , C.Num    , C.Title, C.LName    , C.IName, C.Legal_Name, C.Owner  , C.Contact,
        C.SDate, C.EDate  , C.Phone, C.Mobile   , C.Fax  , C.Email     , C.Website, C.Address,
        C.Rem             ,
        U.Id  Ins_User_Id , U.Name Ins_User_Name     ,
        P.Id  Upd_User_Id , P.Name Upd_User_Name     ,
        To_Number(To_Char(C.Ins_Date,'YYYY'))   Ins_D_Year      , To_Number(To_Char(C.Upd_Date,'YYYY'))   Upd_D_Year      ,
        To_Number(To_Char(C.Ins_Date,'MM'))     Ins_D_Month     , To_Number(To_Char(C.Upd_Date,'MM'))     Upd_D_Month     ,
        To_Number(To_Char(C.Ins_Date,'DD'))     Ins_D_DayOfMonth, To_Number(To_Char(C.Upd_Date,'DD'))     Upd_D_DayOfMonth,
        To_Number(To_Char(C.Ins_Date,'DDD'))    Ins_D_DayOfYear , To_Number(To_Char(C.Upd_Date,'DDD'))    Upd_D_DayOfYear ,
        To_Number(To_Char(C.Ins_Date,'D'))      Ins_D_DayOfWeek , To_Number(To_Char(C.Upd_Date,'DDD'))    Upd_D_DayOfWeek ,
        To_Char(C.Ins_Date,'YYYY-MM')           Ins_D_YearMonth , To_Char(C.Upd_Date,'YYYY-MM')           Upd_D_YearMonth ,
        S.Id     Status_Id, S.Name   Status_Name,
        R.Id     Repr_Id  , R.Name   Repr_Name
   FROM CRM_Cont       C,
        Phs_Cod_Status S,
        CRM_Repr       R,
        Cpy_User       U,
        Cpy_User       P
  Where C.Status_Id       = S.Id
    And NVL(C.Repr_Id ,0) = R.Id
    And NVL(C.Ins_User,0) = U.Id
    And NVL(C.Upd_User,0) = P.Id
/
CREATE SYNONYM CRM_VCont_Repr FOR CRM_Contact_Representative_View
/

CREATE OR REPLACE VIEW CRM_Code_Group_Item_View AS
 SELECT G.Id     AS Grp_Id    , G.Status_Id AS Grp_Status_Id,
        G.Name   AS Grp_Name  , G.FColor    AS Grp_FColor   ,
        G.BColor AS Grp_BColor, G.Rem       AS Grp_Rem      ,
        I.Id     AS Itm_Id    , I.Status_Id AS Itm_Status_Id,
        I.Name   AS Itm_Name  , I.Rem       AS Itm_Rem
   FROM CRM_Cod_Grp G
   JOIN CRM_Cod_Itm I ON I.Grp_Id=G.Id
/
CREATE SYNONYM CRM_VCod_Grp_Itm FOR CRM_Code_Group_Item_View
/

CREATE OR REPLACE VIEW CRM_Contact_Classification_View AS
SELECT C.Id       , C.Num           , C.Title      , C.LName      , C.IName      , C.Legal_Name, C.Owner  , C.Contact,
       C.SDate    , C.EDate         , C.Phone      , C.Mobile     , C.Fax        , C.Email     , C.Website, C.Address,
       C.Rem      , C.Status_Id     , C.Status_Name, C.Repr_Id    , C.Repr_Name  ,
       GI.Grp_Id  , GI.Grp_Status_Id, GI.Grp_Name  , GI.Grp_FColor, GI.Grp_BColor, GI.Grp_Rem,
       GI.Itm_Id  , GI.Itm_Status_Id, GI.Itm_Name  , GI.Itm_Rem   ,
       CC.Id     AS Cont_Class_Id   , CC.Rem      AS Cont_Class_Rem
  FROM CRM_VCont        C
  JOIN CRM_Cont_Class   CC ON C.Id     =CC.Cont_Id
  JOIN CRM_VCod_Grp_Itm GI ON CC.Grp_Id=GI.Grp_Id  AND CC.Itm_Id=GI.Itm_Id
/
CREATE SYNONYM CRM_VCont_Classes FOR CRM_Contact_Classification_View
/

CREATE OR REPLACE VIEW CRM_Report_Master_View AS
 SELECT ALL
        MR.Id              , RE.Id    Rep_Id       , RE.Name Rep_Name      ,
        CO.Id   Contact_Id , CO.LName Contact_Lname, CO.Iname Contact_Iname,
        MR.dDate           , CT.Id    Type_Id      , CT.Name  Type_Name    ,
        CS.Id   Status_Id  , CS.Name  Status_Name  , CK.Id    Kind_Id      ,
        CK.Name Kind_Name  , CU.Id    Owner_Id     , CU.Name  Owner_Name   ,
        Chance             , Person                , Comp                  ,
        FDate              , FRem                  , Report                ,
        Descr              ,
        To_Number(To_Char(MR.dDate,'YYYY'))   D_Year           ,
        To_Number(To_Char(MR.dDate,'MM'))     D_Month          ,
        To_Number(To_Char(MR.dDate,'DD'))     D_DayOfMonth     ,
        To_Number(To_Char(MR.dDate,'DDD'))    D_DayOfYear      ,
        To_Number(To_Char(MR.dDate,'D'))      D_DayOfWeek      ,
        To_Char(MR.dDate,'YYYY-MM')           D_YearMonth
   FROM CRM_MRep       MR,
        CRM_Repr       RE,
        CRM_Cont       CO,
        CRM_Cod_Type   CT,
        CRM_Cod_Status CS,
        CRM_Cod_Kind   CK,
        Cpy_User       CU
  WHERE MR.Repr_Id   =RE.Id
    AND MR.Cont_Id   =CO.Id
    AND MR.Type_Id   =CT.Id
    AND MR.Status_Id =CS.Id
    AND MR.Kind_Id   =CK.Id
    AND MR.Owner_Id  =CU.Id
/
Create Synonym CRM_Rep_Mst_View For CRM_Report_Master_View
/
