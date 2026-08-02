Alter Session Set NLS_DATE_FORMAT = 'DD-MM-YYYY';
-----------------------------------(Id  , P, C, B, U, IsGetLabel, IsVisible, IsBetween, FldType_Id, Menu_Id, Key                 , Name            , LovApi   , LovId, LovName, LovTable , LovWhere, DefValue1, DefValue2, Mask, Rem )
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          2,    0   , 'Fix_Profit_Account', 'Profit Account', 'CC/Acc/', 'ID' , 'Name' , 'ACC_ACC', null    , null     , null     , null, null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          2,    0   , 'Fix_Lost_Account'  , 'Lost Account'  , 'CC/Acc/', 'ID' , 'Name' , 'ACC_ACC', null    , null     , null     , null, null);

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
