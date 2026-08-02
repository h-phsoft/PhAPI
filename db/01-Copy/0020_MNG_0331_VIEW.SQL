CREATE OR REPLACE VIEW MNG_Supplier_View AS
 SELECT C.Id   , C.Num    , C.Title, C.LName , C.IName, C.Owner, C.Contact,
        C.SDate, C.EDate  , C.Phone, C.Mobile, C.Fax  , C.Email, C.Website, C.Address,
        C.Rem  ,
        S.Id     Status_Id, S.Name   Status_Name
   FROM MNG_Supp       C
   JOIN Phs_Cod_Status S ON C.Status_Id      = S.Id
/
CREATE SYNONYM MNG_VSupp FOR MNG_Supplier_View
/

CREATE OR REPLACE VIEW MNG_Code_Group_Item_View AS
 SELECT G.Id     AS Grp_Id    , G.Status_Id AS Grp_Status_Id,
        G.Name   AS Grp_Name  , G.FColor    AS Grp_FColor   ,
        G.BColor AS Grp_BColor, G.Rem       AS Grp_Rem      ,
        I.Id     AS Itm_Id    , I.Status_Id AS Itm_Status_Id,
        I.Name   AS Itm_Name  , I.Rem       AS Itm_Rem
   FROM MNG_Cod_Grp G
   JOIN MNG_Cod_Itm I ON I.Grp_Id=G.Id
/
CREATE SYNONYM MNG_VCod_Grp_Itm FOR MNG_Code_Group_Item_View
/

CREATE OR REPLACE VIEW MNG_Supplier_Classification_View AS
SELECT C.Id       , C.Num           , C.Title      , C.LName      , C.IName      , C.Owner   , C.Contact,
       C.SDate    , C.EDate         , C.Phone      , C.Mobile     , C.Fax        , C.Email   , C.Website, C.Address,
       C.Rem      , C.Status_Id     , C.Status_Name,
       GI.Grp_Id  , GI.Grp_Status_Id, GI.Grp_Name  , GI.Grp_FColor, GI.Grp_BColor, GI.Grp_Rem,
       GI.Itm_Id  , GI.Itm_Status_Id, GI.Itm_Name  , GI.Itm_Rem   ,
       CC.Id     AS Cont_Class_Id   , CC.Rem      AS Cont_Class_Rem
  FROM MNG_VSupp        C
  JOIN MNG_Supp_Class   CC ON C.Id     =CC.Supp_Id
  JOIN MNG_VCod_Grp_Itm GI ON CC.Grp_Id=GI.Grp_Id  AND CC.Itm_Id=GI.Itm_Id
/
CREATE SYNONYM MNG_VSupp_Classes FOR MNG_Supplier_Classification_View
/
