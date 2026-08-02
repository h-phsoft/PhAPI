-- Delete From Cpy_UPref;
-- Delete From Cpy_BPref;
-- Delete From Cpy_Pref;
-- Delete From Phs_Pref;
-- Delete From Phs_Pref_Struct;
-----------------------------------(Id  , P, C, B, U, IsGetLabel, IsVisible, IsBetween, FldType_Id, Menu_Id, Key                        , Name                                                                                           , LovApi                , LovId, LovName, LovTable       , LovWhere, DefValue1        , DefValue2, Mask       , Rem )
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 1, 0,          0,         1,         0,          1,    0   , 'Phs_Langcan_Select'       , 'Can User Select Language'                                                                     , 'CC/Phs/'             , 'ID' , 'Name' , 'PHS_COD_YESNO', null    , 1                , null     , null       , null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 1, 0,          0,         1,         0,          1,    0   , 'Phs_Default_Language'     , 'Default System Language'                                                                      , 'CC/Phs/'             , 'ID' , 'Name' , 'PHS_COD_LANG' , null    , 1                , null     , null       , null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          7,    0   , 'Phs_Upload_Directory'     , 'Upload Files Directory'                                                                       , null                  , null , null   , null           , null    , null             , null     , null       , null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          7,    0   , 'Phs_Root_Directory'       , 'Application Root Directiory'                                                                  , null                  , null , null   , null           , null    , null             , null     , null       , null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          7,    0   , 'Phs_App_Serv_Upload_Path' , 'Uploading Path in the application server'                                                     , null                  , null , null   , null           , null    , null             , null     , null       , null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 1, 1,          0,         1,         0,          1,    0   , 'Phs_Theme'                , 'Default Theme'                                                                                , 'CC/Phs/'             , 'ID' , 'Name' , 'PHS_THEME'    , null    , 0                , null     , null       , null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 1, 1,          0,         1,         0,          1,    0   , 'Phs_Mode'                 , 'Default Mode'                                                                                 , 'CC/Phs/'             , 'ID' , 'Name' , 'PHS_MODE'     , null    , 0                , null     , null       , null);

INSERT INTO Phs_Pref
      (Id, Key, Name, Value1          , Value2   , Rem)
SELECT Id, Key, Name, NVL(DefValue1,0), DefValue2, Rem
 FROM Phs_Pref_Struct
WHERE IsPhs=1
  AND UPPER(KEY) NOT IN (SELECT UPPER(KEY) FROM Phs_Pref);
