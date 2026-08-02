Create OR Replace View Copy_Department_Units_View AS
 SELECT ALL 
        D.Id     Dept_Id         , 
        DS.Id    Dept_Status_Id  , DS.Name  Dept_Status_Name,
        DUS.Id   Dept_User_Id    , DUS.Name Dept_User_Name  ,
        D.Name   Dept_Name       , D.Rem    Dept_Rem        ,
        U.Id     Unit_Id         ,
        US.Id    Unit_Status_Id  , US.Name  Unit_Status_Name,
        UUS.Id   Unit_User_Id    , UUS.Name Unit_User_Name  ,
        C.Id     Cost_Id         , C.Name   Cost_Name       ,
        U.Name   Unit_Name       , U.Rem    Unit_Rem
   FROM Cpy_Dept       D  ,
        Phs_Cod_Status DS ,
        Cpy_User       DUS,
        Cpy_Unit       U  ,
        Phs_Cod_Status US ,
        Cpy_User       UUS,
        Acc_Cost       C
  WHERE D.Status_Id     =DS.Id
    AND D.User_Id       =DUS.Id
    AND U.Dept_Id       =D.Id
    AND U.Status_Id     =US.Id
    AND U.User_Id       =UUS.Id
    AND NVL(U.Cost_Id,0)=C.Id
/
Create Synonym Cpy_VDept_Unit For Copy_Department_Units_View
/

Create OR Replace View Copy_Dept_Unit_Operations_View AS
 SELECT ALL 
        DU.Dept_Id         , 
        DU.Dept_Status_Id  , DU.Dept_Status_Name,
        DU.Dept_User_Id    , DU.Dept_User_Name  ,
        DU.Dept_Name       , DU.Dept_Rem        ,
        DU.Unit_Id         ,
        DU.Unit_Status_Id  , DU.Unit_Status_Name,
        DU.Unit_User_Id    , DU.Unit_User_Name  ,
        DU.Cost_Id         , DU.Cost_Name       ,
        DU.Unit_Name       , DU.Unit_Rem        ,
        OS.Id                Oper_Status_Id     ,
        OS.Name              Oper_Status_Name   ,
        O.Id                 Oper_Id            ,
        O.Name               Oper_Name          ,
        O.Rem                Oper_Rem
   FROM Cpy_VDept_Unit DU,
        Cpy_Oper       O ,
        Phs_Cod_Status OS
  WHERE O.Unit_Id  =DU.Unit_Id
    AND O.Status_Id=OS.Id
/
Create Synonym Cpy_VDept_Unit_Oper For Copy_Dept_Unit_Operations_View
/

Create OR Replace View Copy_Unit_Receive_Status_View AS
 SELECT ALL 
         RS.Id,
         RPS.Id               RStatus_Id         , RPS.Name             RStatus_Name       ,
         RU.Dept_Id         , RU.Unit_Id         , RU.Dept_Status_Id  , RU.Dept_Status_Name,
         RU.Dept_User_Id    , RU.Dept_User_Name  , RU.Dept_Name       , RU.Dept_Rem        ,
         RU.Unit_Status_Id  , RU.Unit_Status_Name, RU.Unit_User_Id    , RU.Unit_User_Name  ,
         RU.Cost_Id         , RU.Cost_Name       , RU.Unit_Name       , RU.Unit_Rem        ,
         RCS.Id               CStatus_Id         , RCS.Name             CStatus_Name       ,
         RY.Id                Head_Id            , RY.Name              Head_Name          ,
         RYS.Id               Forceclose_Id      , RYS.Name             ForceClose_Name    ,
         RS.Days            , RS.Rem
   FROM  Cpy_Unit_Rec_Status RS ,
         Phs_Cod_Status      RPS,
         Cpy_VDept_Unit      RU ,
         Cpy_Cod_Status      RCS,
         Phs_Cod_YesNo       RY ,
         Phs_Cod_YesNo       RYS
   WHERE RS.Status_Id    =RPS.Id
     AND RS.Unit_Id      =RU.Unit_Id
     AND RS.RStatus_Id   =RCS.Id
     AND RS.Head_Id      =RY.Id
     AND RS.ForceClose_Id=RYS.Id
/
Create Synonym Cpy_VUnit_Rec_Status For Copy_Unit_Receive_Status_View
/

Create OR Replace View Copy_Unit_Forward_Status_View AS
 SELECT ALL 
        RS.Id               R_Id              ,
        RS.RStatus_Id       R_RStatus_Id      , RS.RStatus_Name     R_RStatus_Name    ,
        RS.Dept_Id          R_Dept_Id         , RS.Unit_Id          R_Unit_Id         ,
        RS.Dept_Status_Id   R_Dept_Status_Id  , RS.Dept_Status_Name R_Dept_Status_Name,
        RS.Dept_User_Id     R_Dept_User_Id    , RS.Dept_User_Name   R_Dept_User_Name  ,
        RS.Dept_Name        R_Dept_Name       , RS.Dept_Rem         R_Dept_Rem        ,
        RS.Unit_Status_Id   R_Unit_Status_Id  , RS.Unit_Status_Name R_Unit_Status_Name,
        RS.Unit_User_Id     R_Unit_User_Id    , RS.Unit_User_Name   R_Unit_User_Name  ,
        RS.Cost_Id          R_Cost_Id         , RS.Cost_Name        R_Cost_Name       ,
        RS.Unit_Name        R_Unit_Name       , RS.Unit_Rem         R_Unit_Rem        ,
        RS.CStatus_Id       R_CStatus_Id      , RS.CStatus_Name     R_CStatus_Name    ,
        RS.Head_Id          R_Head_Id         , RS.Head_Name        R_Head_Name       ,
        RS.Forceclose_Id    R_Forceclose_Id   , RS.ForceClose_Name  R_ForceClose_Name ,
        RS.Days             R_Days            , RS.Rem              R_Rem             ,

        FS.Id               F_Id              ,
        FS.RStatus_Id       F_RStatus_Id      , FS.RStatus_Name     F_RStatus_Name    ,
        FS.Dept_Id          F_Dept_Id         , FS.Unit_Id          F_Unit_Id         ,
        FS.Dept_Status_Id   F_Dept_Status_Id  , FS.Dept_Status_Name F_Dept_Status_Name,
        FS.Dept_User_Id     F_Dept_User_Id    , FS.Dept_User_Name   F_Dept_User_Name  ,
        FS.Dept_Name        F_Dept_Name       , FS.Dept_Rem         F_Dept_Rem        ,
        FS.Unit_Status_Id   F_Unit_Status_Id  , FS.Unit_Status_Name F_Unit_Status_Name,
        FS.Unit_User_Id     F_Unit_User_Id    , FS.Unit_User_Name   F_Unit_User_Name  ,
        FS.Cost_Id          F_Cost_Id         , FS.Cost_Name        F_Cost_Name       ,
        FS.Unit_Name        F_Unit_Name       , FS.Unit_Rem         F_Unit_Rem        ,
        FS.CStatus_Id       F_CStatus_Id      , FS.CStatus_Name     F_CStatus_Name    ,
        FS.Head_Id          F_Head_Id         , FS.Head_Name        F_Head_Name       ,
        FS.Forceclose_Id    F_Forceclose_Id   , FS.ForceClose_Name  F_ForceClose_Name ,
        FS.Days             F_Days            , FS.Rem              F_Rem             ,

        S.Id                Status_Id         , S.Name              Status_Name       ,
        CFS.Id            , CFS.Rem             Rem 
   FROM Cpy_VUnit_Rec_Status  RS ,
        Cpy_VUnit_Rec_Status  FS ,
        Cpy_Unit_Frwrd_Status CFS,
        Phs_Cod_Status        S
  WHERE CFS.URStatusR_Id=RS.Id
    AND CFS.URStatusF_Id=FS.Id
    AND CFS.Status_Id   =S.Id
/
Create Synonym Cpy_VUnit_Frwrd_Status For Copy_Unit_Forward_Status_View
/

CREATE OR REPLACE VIEW Copy_Status_Group_View AS
 SELECT ALL 
        M.Id              Mst_Id            , M.Name              Mst_Name          ,
        M.Describ         Mst_Describ       , M.Rem               Mst_Rem           ,
        T.Id              Trn_Id            , T.Rem               Trn_Rem           ,
        S.Id              Rec_Id            , S.RStatus_Id      , S.RStatus_Name    ,
        S.Dept_Id       , S.Unit_Id         , S.Dept_Status_Id  , S.Dept_Status_Name,
        S.Dept_User_Id  , S.Dept_User_Name  , S.Dept_Name       , S.Dept_Rem        ,
        S.Unit_Status_Id, S.Unit_Status_Name, S.Unit_User_Id    , S.Unit_User_Name  ,
        S.Cost_Id       , S.Cost_Name       , S.Unit_Name       , S.Unit_Rem        ,
        S.CStatus_Id    , S.CStatus_Name    ,
        S.Head_Id       , S.Head_Name       ,
        S.Forceclose_Id , S.ForceClose_Name ,
        S.Days          , S.Rem
   FROM Cpy_MStatus_Grp      M,
        Cpy_TStatus_Grp      T,
        Cpy_VUnit_Rec_Status S
  WHERE T.Mst_Id=M.Id
    AND T.Status_Id=S.CStatus_Id
/
Create Synonym Cpy_VStatus_Grp For Copy_Status_Group_View
/
