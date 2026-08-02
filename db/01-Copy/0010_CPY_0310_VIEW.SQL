Create OR Replace View Copy_Menu_View AS
Select ALL
        MU.Id Menu_Id  , MU.Name Menu_Name  ,
        ST.Id Status_Id, ST.Name Status_Name
  From Phs_Menu       MU,
       Phs_Cod_Status ST
  Where ST.Id=MU.Status_Id
/
Create Synonym Cpy_VMenu For Copy_Menu_View
/

Create OR Replace View Copy_SpecialLists_View AS
Select ALL
        L.Id       SList_Id    , L.Name    SList_Name, L.Rem        SList_Rem     ,
        SP.Id      SPrv_Id     , SP.Name   SPrv_Name , SP.Status_Id SPrv_Status_Id, SP.Rem   SPrv_Rem  ,
        SP.Related SPrv_Related, SP.Field  SPrv_Field, SP.Pkg       SPrv_Pkg      , SP.model SPrv_model,
        Ins_User , Ins_Date    , Upd_User, Upd_Date
  From Cpy_SList     L,
       Phs_SpecPriv SP
  Where L.SPrv_Id=SP.Id
/
Create Synonym Cpy_VSList For Copy_SpecialLists_View
/

Create OR Replace View Copy_SpecialLists_Full_View AS
Select ALL
        S.SList_Id    , S.SList_Name, S.SList_Rem     ,
        S.SPrv_Id     , S.SPrv_Name , S.SPrv_Status_Id, S.SPrv_Rem  ,
        S.SPrv_Related, S.SPrv_Field, S.SPrv_Pkg      , S.SPrv_model,
        S.Ins_User      MIns_User   , S.Ins_Date        MIns_Date   ,
        S.Upd_User      MUpd_User   , S.Upd_Date        MUpd_Date   ,
        T.Id          , T.Rel_Id    , T.Rem           ,
        T.Ins_User      TIns_User   , T.Ins_Date        TIns_Date   ,
        T.Upd_User      TUpd_User   , T.Upd_Date        TUpd_Date
  From Cpy_VSList S,
       Cpy_TList  T
 Where T.SList_Id=S.SList_Id
/
Create Synonym Cpy_VFSList For Copy_SpecialLists_Full_View
/

Create OR Replace View Copy_Group_Permissions_View AS
Select ALL
       PG.Id Grp_Id     , PG.Name Grp_Name   , PG.PStatus_Id      Grp_WPer           , PG.Rem Grp_Rem,
       MP.Menu_Id       , MP.Menu_Name       , MP.Menu_Status_Id, MP.Menu_Status_Name,
       MP.MPrg_Id       , MP.MPrg_PId        , MP.MPrg_Ord      , MP.MPrg_Name       ,
       MP.MPrg_Status_Id, MP.MPrg_Status_Name,
       MP.MPrg_URL      ,
       PM.Id Perm_Id    , PM.OK Perm_OK
  From Cpy_PGrp   PG,
       Cpy_Perm   PM,
       Phs_VMIPrg MP
 Where PM.PGrp_Id=PG.Id
   And PM.MPrg_Id=MP.MPrg_Id
/
Create Synonym Cpy_VGPerm For Copy_Group_Permissions_View
/

Create OR Replace View Copy_Permision_Privileges_View AS
Select ALL
       PG.Grp_Id   , PG.Grp_Name , PG.Grp_WPer        , PG.Grp_Rem    ,
       PG.Menu_Id  , PG.Menu_Name, PG.MPrg_Id         , PG.MPrg_Ord   ,
       PG.MPrg_Name, PG.MPrg_URL , PG.MPrg_Status_Name, 
       PG.Perm_Id  , PG.Perm_OK  ,
       PP.Id         PPrv_Id     , PP.Prv_Id          , PP.OK PPrv_OK
  From Cpy_VGPerm   PG,
       Cpy_PermPriv PP
 Where PP.Perm_Id=PG.Perm_Id
/
Create Synonym Cpy_VGPPriv For Copy_Permision_Privileges_View
/

Create OR Replace View Copy_Permision_SpecPrivs_View AS
Select ALL
       PG.Grp_Id   , PG.Grp_Name   , PG.Grp_WPer        , PG.Grp_Rem     ,
       PG.Menu_Id  , PG.Menu_Name  , PG.MPrg_Id         , PG.MPrg_Ord    ,
       PG.MPrg_Name, PG.MPrg_URL   , PG.MPrg_Status_Name, 
       PG.Perm_Id  , PG.Perm_OK    ,
       PP.Id         PSPrv_Id      , PP.Status_Id         PSPrv_Status_Id,
       PP.SList_Id   SList_Id      ,
       SP.Id         SPrv_Id       , SP.Name              SPrv_Name      ,
       SP.Status_Id  SPrv_Status_Id, SP.Rem               SPrv_Rem       ,
       SP.Related    SPrv_Related  , SP.Field             SPrv_Field     ,
       SP.Pkg        SPrv_Pkg      , SP.model             SPrv_model
  From Cpy_VGPerm    PG,
       Cpy_PermSPriv PP,
       Phs_SpecPriv  SP
 Where PP.Perm_Id=PG.Perm_Id
   And PP.SPrv_Id=SP.Id
/
Create Synonym Cpy_VGPSPriv For Copy_Permision_SpecPrivs_View
/

Create Or Replace View Copy_Users_View As
Select ALL
       PG.Id       Grp_Id          , PG.Name     Grp_Name        ,
       PS.Id       Grp_PStatus_Id  , PS.Name     Grp_PStatus_Name,
       PST.Id      Grp_Status_Id   , PST.Name    Grp_Status_Name ,
       PG.Rem      Grp_Rem         ,
       U.Id        User_Id         , U.Name      User_Name       ,
       U.Picture   User_Picture    , U.Logon     User_Logon      ,
       U.Pass      User_Pass       , U.Rem       User_Rem        ,
       UG.Id       UGrp_Id         , UG.Name     UGrp_Name       ,
       USX.Id      Gender_Id       , USX.Name    Gender_Name     ,
       UST.Id      Status_Id       , UST.Name    Status_Name     ,
       U.Ins_User, U.Ins_Date      , U.Upd_User, U.Upd_Date      ,
       U.Verified_Id
  FROM Cpy_PGrp        PG ,
       Cpy_Cod_PStatus PS ,
       Phs_Cod_Status  PST,
       Cpy_User        U  ,
       Phs_Cod_UGrp   UG  ,
       Phs_Cod_Gender USX ,
       Phs_Cod_Status UST
 WHERE PG.PStatus_Id=PS.Id
   AND PG.Status_Id =PST.Id
   AND U.PGrp_Id    =PG.Id
   AND U.UGrp_Id    =UG.Id
   AND U.Gender_Id  =USX.Id
   AND U.Status_Id  =UST.Id
/
Create Synonym Cpy_VUser For Copy_Users_View
/

Create Or Replace View Cpy_VUser_Notif_Pref As
SELECT 
    n.Id AS Notif_Id,
    n.Code AS Notif_Code,
    n.IName AS Notif_IName,
    n.LName AS Notif_LName,
    us.Id AS User_Id,
    NVL(u.Status_Id, 1) AS Status_Id,
    s.Name AS Status_Key,
    u.Id AS Pref_Id
FROM Copy_Cod_Notif n
CROSS JOIN Cpy_User us
LEFT JOIN Copy_User_Notification_Pref u ON n.Id = u.Notif_Id AND u.User_Id = us.Id
LEFT JOIN Phs_Cod_Status s ON NVL(u.Status_Id, 1) = s.Id
/