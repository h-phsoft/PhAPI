-----------------------------------(Id  , P, C, B, U, IsGetLabel, IsVisible, IsBetween, FldType_Id, Menu_Id, Key         , Name                            , LovApi, LovId, LovName, LovTable, LovWhere, DefValue1, DefValue2, Mask, Rem )
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          1,       0, 'MKM_POINTS', 'Each 1 Currency Unit is Points', null  , null , null   , null    , null    , 100      , null     , null, null);

INSERT INTO Phs_Pref
      (Id, Key, Name, Value1          , Value2   , Rem)
SELECT Id, Key, Name, NVL(DefValue1,0), DefValue2, Rem
 FROM Phs_Pref_Struct
WHERE IsPhs=1
  AND UPPER(KEY) NOT IN (SELECT UPPER(KEY) FROM Phs_Pref);

INSERT INTO Cpy_Pref
      (Id, Visible_Id, Key, Name, Value1          , Value2   , Rem)
SELECT Id, IsVisible , Key, Name, NVL(DefValue1,0), DefValue2, Rem
 FROM Phs_Pref_Struct
WHERE IsCpy=1
  AND UPPER(KEY) NOT IN (SELECT UPPER(KEY) FROM Cpy_Pref);
