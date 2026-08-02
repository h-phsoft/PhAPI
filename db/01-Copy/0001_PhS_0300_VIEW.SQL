Create OR Replace View Phs_Menus_View AS
Select ALL
       MN.Id    Menu_Id    ,
       MN.Name  Menu_Name  , MN.Image Menu_Image ,
       MN.URL   Menu_URL   , MN.Descr Menu_Descr ,
       ST.Id    Status_Id  , ST.Name  Status_Name
  From Phs_Menu        MN,
       Phs_Cod_Status  ST
 Where MN.Status_Id=ST.Id
/
Create Synonym Phs_VMenu For Phs_Menus_View
/

Create OR Replace View Phs_MIPrograms_View AS
Select ALL
       MN.Menu_Id  ,
       MN.Menu_Name, MN.Menu_Image , MN.Menu_URL   , MN.Menu_Descr   ,
       MN.Status_Id  Menu_Status_Id, MN.Status_Name  Menu_Status_Name,
       PT.Id         Type_Id       , PT.Name         Type_Name       ,
       PT.Status_Id  Type_Status_Id, PT.Icon         Type_Icon       ,
       MP.Id         MPrg_Id       , MP.MPrg_Id      MPrg_PId        ,
       MP.Ord        MPrg_Ord      ,
       MP.Name       MPrg_Name     , MP.URL          MPrg_URL        ,
       MP.ApiURL     MPrg_ApiURL   , MP.Icon         MPrg_Icon       ,
       MP.Params     MPrg_Params   , MP.RelTable     MPrg_RelTable   ,
       ST.Id         MPrg_Status_Id, ST.Name         MPrg_Status_Name
  From Phs_MPrg        MP,
       Phs_VMenu       MN,
       Phs_Cod_PrgType PT,
       Phs_Cod_Status  ST
 Where MP.Menu_Id=MN.Menu_Id
   AND MP.Type_Id=PT.Id
   And MP.Status_Id=ST.Id
/
Create Synonym Phs_VMIPrg For Phs_MIPrograms_View
/

Create OR Replace VIEW Phs_Dashboard_Blocks_View AS
SELECT ALL
       T.Id         Type_Id        , T.Name       Type_Name      , 
       T.Status_Id  Type_Status_Id , T.Rem        Type_Rem       , 
       S.Id         SType_Id       , S.Name       SType_Name     , 
       S.Status_Id  SType_Status_Id, S.Rem        SType_Rem      , 
       B.Id         Block_Id       , B.Name       Block_Name     , 
       B.Ord        Block_Ord      , B.Title      Block_Title    ,
       B.Method     Block_Method   , B.Url        Block_URL      ,
       B.Duration   Block_Duration , B.MCol       Block_MCol     ,
       B.SCol       Block_SCol     , B.Rem        Block_Rem      ,
       B.Menu_Id    Block_menu_Id  , B.Options    Block_Options
  FROM Phs_Dash_Blocks      B,
       Phs_Cod_Dash_Type    T,
       Phs_Cod_Dash_SubType S
 WHERE B.Type_Id=S.Id
   AND S.Mst_Id =T.Id
/
Create Synonym Phs_VDash_Block For Phs_Dashboard_Blocks_View
/
