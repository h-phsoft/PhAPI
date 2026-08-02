-----------------------------------(Id  , P, C, B, U, IsGetLabel, IsVisible, IsBetween, FldType_Id, Menu_Id, Key                    , Name                                                                                           , LovApi   , LovId, LovName, LovTable , LovWhere, DefValue1, DefValue2, Mask, Rem )
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          2,    0   , 'Acc_P_Syp'            , 'SYP Profit Account number when commit difference ditribution in collection or payment orders' , 'CC/Acc/', 'ID' , 'Name' , 'ACC_ACC', null    , null     , null     , null, null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          2,    0   , 'Acc_P_Usd'            , 'USD Profit Account number when commit difference ditribution in collection or payment orders' , 'CC/Acc/', 'ID' , 'Name' , 'ACC_ACC', null    , null     , null     , null, null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          2,    0   , 'Acc_P_Eur'            , 'EUR Profit Account number when commit difference ditribution in collection or payment orders' , 'CC/Acc/', 'ID' , 'Name' , 'ACC_ACC', null    , null     , null     , null, null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          2,    0   , 'Acc_L_Syp'            , 'SYP Lost Account number when commit difference ditribution in collection or payment orders'   , 'CC/Acc/', 'ID' , 'Name' , 'ACC_ACC', null    , null     , null     , null, null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          2,    0   , 'Acc_L_Usd'            , 'USD Lost Account number when commit difference ditribution in collection or payment orders'   , 'CC/Acc/', 'ID' , 'Name' , 'ACC_ACC', null    , null     , null     , null, null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          2,    0   , 'Acc_L_Eur'            , 'EUR Lost Account number when commit difference ditribution in collection or payment orders'   , 'CC/Acc/', 'ID' , 'Name' , 'ACC_ACC', null    , null     , null     , null, null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          2,    0   , 'Acc_Exchange_Profit'  , 'Exchabge Profit Account number when commit currency rate vouchers'                            , 'CC/Acc/', 'ID' , 'Name' , 'ACC_ACC', null    , null     , null     , null, null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          2,    0   , 'Acc_Exchange_Lost'    , 'Exchabge Lost Account number when commit currency rate vouchers'                              , 'CC/Acc/', 'ID' , 'Name' , 'ACC_ACC', null    , null     , null     , null, null);
Insert into Phs_Pref_Struct Values (NULL, 1, 1, 0, 0,          0,         1,         0,          3,    0   , 'Acc_Sort_Voucher_Date', 'When Last Sort Vouchers Done'                                                                 , null     , null , null   , null     , null    , null     , null     , null, null);

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
