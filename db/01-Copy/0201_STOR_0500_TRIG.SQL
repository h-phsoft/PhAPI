Create or Replace Trigger
  Stor_TBID_Item
  Before Insert
  On Stor_Item
  For Each Row
Declare
Begin
  Begin
    If :New.Id IS NULL Then
      Select Stor_Item_Seq.NextVal INTO :New.Id From Dual;
    End If;
  Exception
    When Others Then
      NULL;
  End;
End Stor_TBID_Item;
/

Create or Replace Trigger
  Stor_TBID_Store
  Before Insert
  On Stor_Store
  For Each Row
Declare
Begin
  Begin
    If :New.Id IS NULL Then
      Select Stor_Store_Seq.NextVal INTO :New.Id From Dual;
    End If;
  Exception
    When Others Then
      NULL;
  End;
End Stor_TBID_Store;
/

Create or Replace Trigger
  Stor_TBID_SMat
  Before Insert
  On Stor_SMat
  For Each Row
Declare
Begin
  Begin
    If :New.Id IS NULL Then
      Select Stor_SMat_Seq.NextVal INTO :New.Id From Dual;
    End If;
  Exception
    When Others Then
      NULL;
  End;
End Stor_TBID_SMat;
/

Create or Replace Trigger
  Stor_TBID_ICS
  Before Insert
  On Stor_ICS
  For Each Row
Declare
Begin
  Begin
    If :New.Id IS NULL Then
      Select Stor_ICS_Seq.NextVal INTO :New.Id From Dual;
    End If;
  Exception
    When Others Then
      NULL;
  End;
End Stor_TBID_ICS;
/

Create or Replace Trigger
  Stor_TBID_SICS
  Before Insert
  On Stor_SICS
  For Each Row
Declare
Begin
  Begin
    If :New.Id IS NULL Then
      Select Stor_SICS_Seq.NextVal INTO :New.Id From Dual;
    End If;
  Exception
    When Others Then
      NULL;
  End;
End Stor_TBID_SICS;
/

Create or Replace Trigger
  Stor_TBID_InOrdTrn
  Before Insert
  On Stor_InOrdTrn
  For Each Row
Declare
Begin
  Begin
    If :New.Id IS NULL Then
      Select Stor_InOrdTrn_Seq.NextVal INTO :New.Id From Dual;
    End If;
  Exception
    When Others Then
      NULL;
  End;
End Stor_TBID_InOrdTrn;
/

Create or Replace Trigger
  Stor_TBID_OuOrdTrn
  Before Insert
  On Stor_OuOrdTrn
  For Each Row
Declare
Begin
  Begin
    If :New.Id IS NULL Then
      Select Stor_OuOrdTrn_Seq.NextVal INTO :New.Id From Dual;
    End If;
  Exception
    When Others Then
      NULL;
  End;
End Stor_TBID_OuOrdTrn;
/

Create OR Replace Function
  get_ICS_Id(
     nItemId  Number   := 0,
     vLotSer  Varchar2 := '-',
     nUnitId  Number   := 0,
     nModelId Number   := 0,
     nSizeId  Number   := 0,
     nColorId Number   := 0,
     nLength  Number   := 0,
     nWidth   Number   := 0,
     nHeight  Number   := 0
  ) Return Number IS
  nIcsId Number := 0;
Begin
  Begin
    Select Id
      Into nIcsId
      From Stor_ICS
      WHERE Item_Id =NVL(nItemId  ,0 )
        AND LotSer  =NVL(vLotSer ,'_')
        AND Unit_Id =NVL(nUnitId ,0  )
        AND Model_Id=NVL(nModelId,0  )
        AND Size_Id =NVL(nSizeId ,0  )
        AND Color_Id=NVL(nColorId,0  )
        AND nLength =NVL(nLength ,0  )
        AND nWidth  =NVL(nWidth  ,0  )
        AND nHeight =NVL(nHeight ,0  );
  Exception
    When Others Then
      nIcsId := 0;
  End;
  Return nIcsId;
End get_ICS_Id;
/

Create or Replace Trigger
  Stor_TBU_SMat
  Before Update
  Of CQnt, CAmt
  On Stor_SMat
  For Each Row
Declare
  enableNegative Number := 0;
Begin
  Begin
    SELECT NVL(Value1,0)
      INTO enableNegative
      FROM Cpy_Pref
    WHERE UPPER(Key)=UPPER('Stor.Enable_SMAT_Negative');
  Exception
    When Others Then
      enableNegative := 0;
  End;
  If (enableNegative=1 AND NVL(:New.CQnt,0)<0 And NVL(:New.CQnt,0)<NVL(:Old.CQnt,0)) Then
    Raise_Application_Error( -20701, 'No Qnt. In Store '||:New.Stor_Id||' For The Item '||:New.Item_Id );
  End If;
  If (enableNegative=1 AND NVL(:New.CQnt,0)=0 And NVL(:New.CAmt,0)<>0) Then
    Raise_Application_Error( -20703, 'Item '||:New.Item_Id||' on The Store '||:New.Stor_Id||' Has Amount Without Quantity' );
  End If;
End Stor_TBU_SMat;
/

Create or Replace Trigger
  Stor_TBU_ICS
  Before Update
  Of CQnt, CCst
  On Stor_ICS
  For Each Row
Declare
  enableNegative Number := 0;
Begin
  Begin
    SELECT NVL(Value1,0)
      INTO enableNegative
      FROM Cpy_Pref
    WHERE UPPER(Key)=UPPER('Stor.Enable_ICS_Negative');
  Exception
    When Others Then
      enableNegative := 0;
  End;
  If (enableNegative=1 AND NVL(:New.CQnt,0)<0 And NVL(:New.CQnt,0)<NVL(:Old.CQnt,0)) Then
    Raise_Application_Error( -20701, 'No Qnt.'||' For The Item '||:New.Item_Id);
  End If;
  If (enableNegative=1 AND NVL(:New.CQnt,0)=0 And NVL(:New.CCst,0)<>0) Then
    Raise_Application_Error( -20703, 'Item '||:New.Item_Id||' Has Amount Without Quantity' );
  End If;
End Stor_TBU_ICS;
/

Create or Replace Trigger
  Stor_TBU_SICS
  Before Update
  Of CQnt, CCst
  On Stor_SICS
  For Each Row
Declare
  enableNegative Number := 0;
Begin
  Begin
    SELECT NVL(Value1,0)
      INTO enableNegative
      FROM Cpy_Pref
    WHERE UPPER(Key)=UPPER('Stor.Enable_SICS_Negative');
  Exception
    When Others Then
      enableNegative := 0;
  End;
  If (enableNegative=1 AND NVL(:New.CQnt,0)<0 And NVL(:New.CQnt,0)<NVL(:Old.CQnt,0)) Then
    Raise_Application_Error( -20701, 'No Qnt.'||' For The Item '||:New.Item_Id||' on The Store '||:New.Stor_Id);
  End If;
  If (enableNegative=1 AND NVL(:New.CQnt,0)=0 And NVL(:New.CCst,0)<>0) Then
    Raise_Application_Error( -20703, 'Item '||:New.Item_Id||' on The Store '||:New.Stor_Id||' Has Amount Without Quantity' );
  End If;
End Stor_TBU_SICS;
/
-----------------------------------------------------------------------------------------------------------------------------------------------------
Create or Replace Trigger
  Stor_TBI_InMst
  Before Insert
  On Stor_InMst
  For Each Row
Declare
  nBRate Number := 1;
Begin
  :New.BCurn_Id := Get_Base_Currency_Id();
  Select Rate
    Into nBRate
    From Mng_Curn
    Where Id=:New.BCurn_Id;
  If nBRate<=0 Then
    nBRate := 1;
  End If;
  :New.BCurn_Rate := nBRate;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Stor_TBI_InMst, Undefined Currency '||:New.BCurn_Id||' InMstId='||:New.Id );
End Stor_TBI_InMst;
/
Create or Replace Trigger
  Stor_TBI_InTrn
  Before Insert
  On Stor_InTrn
  For Each Row
Declare
  nStr     Number;
  nBRate   Number := 0;
  nIcsId   Number;
  nSIcsId  Number;
  bPrices  Boolean := true;
  nCPrice  Number := 0;
  nNPrice  Number := 0;
  nDPrice  Number := 0;
  nSPrice  Number := 0;
  nWPrice  Number := 0;
  nRPrice  Number := 0;
  nHPrice  Number := 0;
  nMPrice  Number := 0;
Begin
  Select Stor_Id, Decode(Sign(NVL(BCurn_Rate,1)), -1,1, 0,1, NVL(BCurn_Rate,1))
    Into nStr   , nBRate
    From Stor_InMst
    Where Id=:New.Mst_Id;
  :New.Cst  := NVL(:New.Amt,0);
  :New.BAmt := Round(NVL(:New.Amt,0) / nBRate, 2);
  :New.BCst := Round(NVL(:New.Amt,0) / nBRate, 2);
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
         CAmt =NVL(CAmt ,0)+NVL(:New.Cst ,0),
         CBAmt=NVL(CBAmt,0)+NVL(:New.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  :New.LotSer   := NVL(:New.LotSer  ,'-');
  :New.Model_Id := NVL(:New.Model_Id,0  );
  :New.Color_Id := NVL(:New.Color_Id,0  );
  :New.Size_Id  := NVL(:New.Size_Id ,0  );
  :New.nLength  := NVL(:New.nLength ,0  );
  :New.nWidth   := NVL(:New.nWidth  ,0  );
  :New.nHeight  := NVL(:New.nHeight ,0  );
  nIcsId := get_ICS_Id(:New.Item_Id, :New.LotSer, :New.Unit_Id, :New.Model_Id, :New.Size_Id, :New.Color_Id, :New.nLength, :New.nWidth, :New.nHeight);
  :New.Ics_Id := nIcsId;
  If NVL(nIcsId,0)>0 Then
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)
       WHERE Id=:New.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  Else
    SELECT  CPrice,  NPrice,  DPrice,  SPrice,  WPrice,  RPrice,  HPrice,  MPrice
      INTO nCPrice, nNPrice, nDPrice, nSPrice, nWPrice, nRPrice, nHPrice, nMPrice
      FROM Stor_Item
     WHERE Id=:New.Item_Id;
    bPrices := false;
    SELECT Stor_ICS_Seq.nextval
      INTO nIcsId
      FROM Dual;
    :New.Ics_Id := nIcsId;
    INSERT INTO Stor_ICS
          ( Id      , Item_Id , Unit_Id , Model_Id, Color_Id, Size_Id , nLength , nWidth  ,
            nHeight , Qnt     , CCst    , CBCst   , CQnt    , WQnt    , CWQnt   , CPrice  ,
            NPrice  , DPrice  , SPrice  , WPrice  , RPrice  , HPrice  , MPrice  , Barcode ,
            LotSer  , SDate   , EDate
          )
    VALUES( nIcsId       , :New.Item_Id , :New.Unit_Id , :New.Model_Id, :New.Color_Id, :New.Size_Id , :New.nLength , :New.nWidth  ,
            :New.nHeight , :New.Qnt     , :New.Cst     , :New.BCst    , :New.Qnt     , :New.WQnt    , :New.WQnt    , nCPrice      ,
            nNPrice      , nDPrice      , nSPrice      , nWPrice      , nRPrice      , nHPrice      , nMPrice      , :New.Barcode ,
            :New.LotSer  , :New.SDate   , :New.EDate
          );
  End If;
  Begin
    SELECT Id
      INTO nSIcsId
      FROM Stor_SICS
     WHERE Stor_Id=nStr
       AND Item_Id=:New.Item_Id
       AND ICS_Id =:New.Ics_Id;
    :New.SICS_Id := nSIcsId;
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)
       WHERE Id=:New.SICS_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  Exception
    When No_Data_Found Then
      If bPrices Then
        SELECT  CPrice,  NPrice,  DPrice,  SPrice,  WPrice,  RPrice,  HPrice,  MPrice
          INTO nCPrice, nNPrice, nDPrice, nSPrice, nWPrice, nRPrice, nHPrice, nMPrice
          FROM Stor_Item
         WHERE Id=:New.Item_Id;
      End If;
      SELECT Stor_SICS_Seq.nextval
        INTO nSIcsId
        FROM Dual;
      :New.SICS_Id := nSIcsId;
      Begin
        INSERT INTO Stor_SICS
              ( Id          , Stor_Id , Item_Id     , ICS_Id     ,
                Qnt         , CCst    , CBCst       , CQnt       , WQnt     , CWQnt    ,
                CPrice      , NPrice  , DPrice      , SPrice     , WPrice   , RPrice   , HPrice , MPrice
              )
        VALUES( :New.SICS_Id, nStr    , :New.Item_Id, :New.ICS_Id,
                :New.Qnt    , :New.Cst, :New.BCst   , :New.Qnt   , :New.WQnt, :New.WQnt,
                nCPrice     , nNPrice , nDPrice     , nSPrice    , nWPrice  , nRPrice  , nHPrice, nMPrice
              );
      Exception
        When Others Then
          NULL;
      End;
  End;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||NVL(nStr,0)||' MstId='||:New.Id );
End Stor_TBI_InTrn;
/
Create or Replace Trigger
  Stor_TBU_InTrn
  Before Update
  On Stor_InTrn
  For Each Row
Declare
  nStr     Number;
  nIcsId   NUmber;
  nSIcsId  Number;
  nBRate   Number := 0;
  bPrices  Boolean := true;
  nCPrice  Number := 0;
  nNPrice  Number := 0;
  nDPrice  Number := 0;
  nSPrice  Number := 0;
  nWPrice  Number := 0;
  nRPrice  Number := 0;
  nHPrice  Number := 0;
  nMPrice  Number := 0;
Begin
  Select Stor_Id, Decode(Sign(NVL(BCurn_Rate,1)), -1,1, 0,1, NVL(BCurn_Rate,1))
    Into nStr   , nBRate
    From Stor_InMst
    Where Id=:New.Mst_Id;
  :New.Cst  := NVL(:New.Amt,0);
  :New.BAmt := Round(NVL(:New.Amt,0) / nBRate, 2);
  :New.BCst := Round(NVL(:New.Amt,0) / nBRate, 2);
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0)-NVL(:Old.Qnt ,0),
         CAmt =NVL(CAmt ,0)+NVL(:New.Cst ,0)-NVL(:Old.Cst ,0),
         CBAmt=NVL(CBAmt,0)+NVL(:New.BCst,0)-NVL(:Old.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  :New.LotSer   := NVL(:New.LotSer  ,'-');
  :New.Model_Id := NVL(:New.Model_Id,0  );
  :New.Color_Id := NVL(:New.Color_Id,0  );
  :New.Size_Id  := NVL(:New.Size_Id ,0  );
  :New.nLength  := NVL(:New.nLength ,0  );
  :New.nWidth   := NVL(:New.nWidth  ,0  );
  :New.nHeight  := NVL(:New.nHeight ,0  );
  IF :New.Item_Id             !=    :Old.Item_Id
     OR NVL(:New.Unit_Id ,0  )!=NVL(:Old.Unit_Id ,0  )
     OR NVL(:New.Model_Id,0  )!=NVL(:Old.Model_Id,0  )
     OR NVL(:New.Color_Id,0  )!=NVL(:Old.Color_Id,0  )
     OR NVL(:New.Size_Id ,0  )!=NVL(:Old.Size_Id ,0  )
     OR NVL(:New.nLength ,0  )!=NVL(:Old.nLength ,0  )
     OR NVL(:New.nWidth  ,0  )!=NVL(:Old.nWidth  ,0  )
     OR NVL(:New.nHeight ,0  )!=NVL(:Old.nHeight ,0  )
     OR NVL(:New.Barcode ,'_')!=NVL(:Old.Barcode ,'_')
     OR NVL(:New.LotSer  ,'_')!=NVL(:Old.LotSer  ,'_')
     OR NVL(:New.SDate   ,TO_Date('01-01-1900', 'DD-MM-YYYY'))!=NVL(:Old.SDate,TO_Date('01-01-1900', 'DD-MM-YYYY'))
     OR NVL(:New.EDate   ,TO_Date('01-01-1900', 'DD-MM-YYYY'))!=NVL(:Old.EDate,TO_Date('01-01-1900', 'DD-MM-YYYY')) THEN
    IF :Old.Ics_Id IS NOT NULL Then
      Begin
        UPDATE Stor_ICS SET
               CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
               CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
               CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
               CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
         WHERE Id=:Old.Ics_Id;
      Exception
        When OTHERS Then
          NULL;
      End;
    End IF;
    nIcsId := get_ICS_Id(:New.Item_Id, :New.LotSer , :New.Unit_Id, :New.Model_Id, :New.Size_Id, :New.Color_Id, :New.nLength, :New.nWidth, :New.nHeight);
    IF nIcsId>0 Then
      :New.Ics_Id := nIcsId;
      Begin
        UPDATE Stor_ICS SET
               CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
               CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0),
               CCst =NVL(CCst ,0)+NVL(:New.Cst ,0),
               CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)
         WHERE Id=:New.Ics_Id;
      Exception
        When OTHERS Then
          NULL;
      End;
    Else
      Begin
        SELECT  CPrice,  NPrice,  DPrice,  SPrice,  WPrice,  RPrice,  HPrice,  MPrice
          INTO nCPrice, nNPrice, nDPrice, nSPrice, nWPrice, nRPrice, nHPrice, nMPrice
          FROM Stor_Item
         WHERE Id=:New.Item_Id;
        bPrices := false;
        SELECT Stor_ICS_Seq.nextval
          INTO nIcsId
          FROM Dual;
        :New.Ics_Id := nIcsId;
        INSERT INTO Stor_ICS
              ( Id      , Item_Id , Unit_Id , Model_Id, Color_Id, Size_Id , nLength , nWidth  ,
                nHeight , Qnt     , CCst    , CBCst   , CQnt    , WQnt    , CWQnt   , CPrice  ,
                NPrice  , DPrice  , SPrice  , WPrice  , RPrice  , HPrice  , MPrice  , Barcode ,
                LotSer  , SDate   , EDate
              )
        VALUES(
                nIcsId       , :New.Item_Id , :New.Unit_Id , :New.Model_Id, :New.Color_Id, :New.Size_Id , :New.nLength , :New.nWidth  ,
                :New.nHeight , :New.Qnt     , :New.Cst     , :New.BCst    , :New.Qnt     , :New.WQnt    , :New.WQnt    , nCPrice      ,
                nNPrice      , nDPrice      , nSPrice      , nWPrice      , nRPrice      , nHPrice      , nMPrice      , :New.Barcode ,
                :New.LotSer  , :New.SDate   , :New.EDate
              );
      Exception
        When OTHERS Then
          NULL;
      End;
    End If;
    IF :Old.SIcs_Id IS NOT NULL Then
      Begin
        UPDATE Stor_SICS SET
               CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
               CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
               CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
               CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
         WHERE Id=:Old.SIcs_Id;
      Exception
        When OTHERS Then
          NULL;
      End;
    End IF;
    Begin
      SELECT Id
        INTO nSIcsId
        FROM Stor_SICS
       WHERE Stor_Id=nStr
         AND Item_Id=:New.Item_Id
         AND ICS_Id =:New.Ics_Id;
      :New.SIcs_Id := nSIcsId;
      Begin
        UPDATE Stor_SICS SET
               CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
               CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0),
               CCst =NVL(CCst ,0)+NVL(:New.Cst ,0),
               CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)
         WHERE Id=:New.SIcs_Id;
      Exception
        When OTHERS Then
          NULL;
      End;
    Exception
      When No_Data_Found Then
        If bPrices Then
          SELECT  CPrice,  NPrice,  DPrice,  SPrice,  WPrice,  RPrice,  HPrice,  MPrice
            INTO nCPrice, nNPrice, nDPrice, nSPrice, nWPrice, nRPrice, nHPrice, nMPrice
            FROM Stor_Item
           WHERE Id=:New.Item_Id;
        End If;
        INSERT INTO Stor_SICS
              ( Id          , Stor_Id , Item_Id     , ICS_Id     ,
                Qnt         , CCst    , CBCst       , CQnt       , WQnt     , CWQnt    ,
                CPrice      , NPrice  , DPrice      , SPrice     , WPrice   , RPrice   , HPrice , MPrice
              )
        VALUES( :New.SIcs_Id, nStr    , :New.Item_Id, :New.ICS_Id,
                :New.Qnt    , :New.Cst, :New.BCst   , :New.Qnt   , :New.WQnt, :New.WQnt,
                nCPrice     , nNPrice , nDPrice     , nSPrice    , nWPrice  , nRPrice  , nHPrice, nMPrice
              );
    End;
  ELSE
    IF :New.Ics_Id IS NOT NULL Then
      Begin
        UPDATE Stor_ICS SET
               CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0)-NVL(:Old.Qnt ,0),
               CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0)-NVL(:Old.WQnt,0),
               CCst =NVL(CCst ,0)+NVL(:New.Cst ,0)-NVL(:Old.Cst ,0),
               CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)-NVL(:Old.BCst,0)
         WHERE Id=:New.Ics_Id;
      Exception
        When OTHERS Then
          NULL;
      End;
    End IF;
    IF :New.SIcs_Id IS NOT NULL Then
      Begin
        UPDATE Stor_SICS SET
               CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0)-NVL(:Old.Qnt ,0),
               CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0)-NVL(:Old.WQnt,0),
               CCst =NVL(CCst ,0)+NVL(:New.Cst ,0)-NVL(:Old.Cst ,0),
               CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)-NVL(:Old.BCst,0)
         WHERE Id=:New.SIcs_Id;
      Exception
        When OTHERS Then
          NULL;
      End;
    End IF;
  End IF;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||NVL(nStr,0)||' MstId='||:New.Id );
End Stor_TBU_InTrn;
/
Create or Replace Trigger
  Stor_TBD_InTrn
  Before Delete
  On Stor_InTrn
  For Each Row
Declare
  nStr    Number;
Begin
  Select Stor_Id
    Into nStr
    From Stor_InMst
    Where Id=:Old.Mst_Id;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
         CAmt =NVL(CAmt ,0)-NVL(:Old.Cst ,0),
         CBAmt=NVL(CBAmt,0)-NVL(:Old.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:Old.Item_Id;
  IF :Old.Ics_Id IS NOT NULL Then
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
       WHERE Id=:Old.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
  IF :Old.SIcs_Id IS NOT NULL Then
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
       WHERE Id=:Old.SIcs_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:Old.Item_Id||' In Store '||nStr );
End Stor_TBD_InTrn;
/
-----------------------------------------------------------------------------------------------------------------------------------------------------
Create or Replace Trigger
  Stor_TBI_OuMst
  Before Insert
  On Stor_OuMst
  For Each Row
Declare
  nBRate Number := 1;
Begin
  :New.BCurn_Id := Get_Base_Currency_Id();
  Select Rate
    Into nBRate
    From Mng_Curn
    Where Id=:New.BCurn_Id;
  If nBRate<=0 Then
    nBRate := 1;
  End If;
  :New.BCurn_Rate := nBRate;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Stor_TBI_OuMst, Undefined Currency '||:New.BCurn_Id||' OuMstId='||:New.Id );
End Stor_TBI_OuMst;
/
Create or Replace Trigger
  Stor_TBI_OuTrn
  Before Insert
  On Stor_OuTrn
  For Each Row
Declare
  nStr     Number;
  nIcsId   Number;
  nCst     Number;
  nBCst    Number;
  nQnt     Number;
  nBRate   Number := 0;
Begin
  Select Stor_Id, Decode(Sign(NVL(BCurn_Rate,1)), -1,1, 0,1, NVL(BCurn_Rate,1))
    Into nStr   , nBRate
    From Stor_OuMst
    Where Id=:New.Mst_Id;
  nQnt := 0;
  nCst := 0;
  Select NVL(CQnt,0), NVL(CAmt,0), NVL(CBAmt,0)
    Into nQnt, nCst, nBCst
    From Stor_SMat
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  If nQnt>0 Then
    nCst  := nCst  / nQnt;
    nBCst := nBCst / nQnt;
  End If;
  :New.BAmt := Round(NVL(:New.Amt,0) / nBRate, 2);
  :New.Cst  := nCst  * :New.Qnt;
  :New.BCst := nBCst * :New.Qnt;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
         CAmt =NVL(CAmt ,0)-NVL(:New.Cst ,0),
         CBAmt=NVL(CBAmt,0)-NVL(:New.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  :New.LotSer   := NVL(:New.LotSer  ,'-');
  :New.Model_Id := NVL(:New.Model_Id,0  );
  :New.Color_Id := NVL(:New.Color_Id,0  );
  :New.Size_Id  := NVL(:New.Size_Id ,0  );
  :New.nLength  := NVL(:New.nLength ,0  );
  :New.nWidth   := NVL(:New.nWidth  ,0  );
  :New.nHeight  := NVL(:New.nHeight ,0  );
  nIcsId := get_ICS_Id(:New.Item_Id, :New.LotSer , :New.Unit_Id, :New.Model_Id, :New.Size_Id, :New.Color_Id, :New.nLength, :New.nWidth, :New.nHeight);
  IF nIcsId>0 Then
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
       WHERE Id=:New.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  End If;
  Begin
    UPDATE Stor_SICS SET
           CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
           CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
           CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
           CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
     WHERE Id=:New.SIcs_Id;
  Exception
    When OTHERS Then
      NULL;
  End;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nStr);
End Stor_TBI_OuTrn;
/
Create or Replace Trigger
  Stor_TBU_OuTrn
  Before Update
  Of Qnt, Cst
  On Stor_OuTrn
  For Each Row
Declare
  nStr    Number;
  nCst    Number;
  nBCst   Number;
  nQnt    Number;
  nBRate  Number := 0;
Begin
  Select Stor_Id, Decode(Sign(NVL(BCurn_Rate,1)), -1,1, 0,1, NVL(BCurn_Rate,1))
    Into nStr   , nBRate
    From Stor_OuMst
    Where Id=:New.Mst_Id;
  nQnt := 0;
  nCst := 0;
  Select NVL(CQnt,0), NVL(CAmt,0), NVL(CBAmt,0)
    Into     nQnt   ,     nCst   ,     nBCst
    From Stor_SMat
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  If nQnt>0 Then
    nCst  := nCst  / nQnt;
    nBCst := nBCst / nQnt;
  End If;
  :New.BAmt := Round(NVL(:New.Amt,0) / nBRate, 2);
  :New.BCst := nBCst * :New.Qnt;
  :New.Cst  := nCst  * :New.Qnt;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0)+NVL(:Old.Qnt ,0),
         CAmt =NVL(CAmt ,0)-NVL(:New.Cst ,0)+NVL(:Old.Cst ,0),
         CBAmt=NVL(CBAmt,0)-NVL(:New.BCst,0)+NVL(:Old.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  IF :New.Ics_Id!=:Old.Ics_Id Then
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
       WHERE Id=:Old.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
       WHERE Id=:New.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  Else
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0)+NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0)+NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0)+NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)+NVL(:Old.BCst,0)
       WHERE Id=:New.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
  IF :New.SIcs_Id!=:Old.SIcs_Id Then
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
       WHERE Id=:Old.SIcs_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
       WHERE Id=:New.SIcs_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  Else
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0)+NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0)+NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0)+NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)+NVL(:Old.BCst,0)
       WHERE Id=:New.SIcs_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nStr);
End Stor_TBU_OuTrn;
/

Create or Replace Trigger
  Stor_TBD_OuTrn
  Before Delete
  On Stor_OuTrn
  For Each Row
Declare
  nStr    Number;
Begin
  Select Stor_Id
    Into nStr
    From Stor_OuMst
    Where Id=:Old.Mst_Id;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
         CAmt =NVL(CAmt ,0)+NVL(:Old.Cst ,0),
         CBAmt=NVL(CBAmt,0)+NVL(:Old.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:OLD.Item_Id;
  Begin
    UPDATE Stor_ICS SET
           CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
           CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
           CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
           CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
     WHERE Id=:Old.Ics_Id;
  Exception
    When OTHERS Then
      NULL;
  End;
  Begin
    UPDATE Stor_SICS SET
           CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
           CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
           CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
           CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
     WHERE Id=:Old.SIcs_Id;
  Exception
    When OTHERS Then
      NULL;
  End;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:Old.Item_Id||' In Store '||nStr );
End Stor_TBD_OuTrn;
/
-----------------------------------------------------------------------------------------------------------------------------------------------------
Create or Replace Trigger
  Stor_TBI_EIMst
  Before Insert
  On Stor_EIMst
  For Each Row
Declare
  nBRate Number := 1;
Begin
  :New.BCurn_Id := Get_Base_Currency_Id();
  Select Rate
    Into nBRate
    From Mng_Curn
    Where Id=:New.BCurn_Id;
  If nBRate<=0 Then
    nBRate := 1;
  End If;
  :New.BCurn_Rate := nBRate;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Stor_TBI_EIMst, Undefined Currency '||:New.BCurn_Id||' EIMstId='||:New.Id );
End Stor_TBI_EIMst;
/
Create or Replace Trigger
  Stor_TBI_EITrn
  Before Insert
  On Stor_EITrn
  For Each Row
Declare
  nStr     Number;
  nBRate   Number := 0;
  nIcsId   Number;
  nSIcsId  Number;
  bPrices  Boolean := true;
  nCPrice  Number := 0;
  nNPrice  Number := 0;
  nDPrice  Number := 0;
  nSPrice  Number := 0;
  nWPrice  Number := 0;
  nRPrice  Number := 0;
  nHPrice  Number := 0;
  nMPrice  Number := 0;
Begin
  Select Stor_Id, Decode(Sign(NVL(BCurn_Rate,1)), -1,1, 0,1, NVL(BCurn_Rate,1))
    Into nStr   , nBRate
    From Stor_EIMst
    Where Id=:New.Mst_Id;
  :New.Cst  := NVL(:New.Amt,0);
  :New.BAmt := NVL(:New.Amt,0) * nBRate;
  :New.BCst := NVL(:New.Amt,0) * nBRate;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
         CAmt =NVL(CAmt ,0)+NVL(:New.Cst ,0),
         CBAmt=NVL(CBAmt,0)+NVL(:New.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  If :New.TOrd_Id IS NOT NULL Then
    Update Stor_InOrdTrn Set
           CQnt=NVL(CQnt,0)+NVL(:New.Qnt,0)
     Where Id=:New.TOrd_Id;
  End If;
  Begin
    Select Id
      Into nIcsId
      From Stor_ICS
      WHERE Item_Id =    :New.Item_Id
        AND LotSer  =NVL(:New.LotSer  ,'_')
        AND Unit_Id =NVL(:New.Unit_Id ,0  )
        AND Model_Id=NVL(:New.Model_Id,0  )
        AND Size_Id =NVL(:New.Size_Id ,0  )
        AND Color_Id=NVL(:New.Color_Id,0  )
        AND nLength =NVL(:New.nLength ,0  )
        AND nWidth  =NVL(:New.nWidth  ,0  )
        AND nHeight =NVL(:New.nHeight ,0  )
        AND SDate   =NVL(:New.SDate,TO_Date('01-01-1900', 'DD-MM-YYYY'))
        AND EDate   =NVL(:New.EDate,TO_Date('01-01-1900', 'DD-MM-YYYY'));
    :New.Ics_Id := nIcsId;
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)
       WHERE Id=:New.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  Exception
    When No_Data_Found Then
      Begin
        SELECT  CPrice,  NPrice,  DPrice,  SPrice,  WPrice,  RPrice,  HPrice,  MPrice
          INTO nCPrice, nNPrice, nDPrice, nSPrice, nWPrice, nRPrice, nHPrice, nMPrice
          FROM Stor_Item
         WHERE Id=:New.Item_Id;
        bPrices := false;
        SELECT Stor_ICS_Seq.nextval
          INTO nIcsId
          FROM Dual;
        :New.Ics_Id := nIcsId;
        INSERT INTO Stor_ICS
              ( Id      , Item_Id , Unit_Id , Model_Id, Color_Id, Size_Id , nLength , nWidth  ,
                nHeight , Qnt     , CCst    , CBCst   , CQnt    , WQnt    , CWQnt   , CPrice  ,
                NPrice  , DPrice  , SPrice  , WPrice  , RPrice  , HPrice  , MPrice  , Barcode ,
                LotSer  , SDate   , EDate
              )
        VALUES(
                nIcsId       , :New.Item_Id , :New.Unit_Id , :New.Model_Id, :New.Color_Id, :New.Size_Id , :New.nLength , :New.nWidth  ,
                :New.nHeight , :New.Qnt     , :New.Cst     , :New.BCst    , :New.Qnt     , :New.WQnt    , :New.WQnt    , nCPrice      ,
                nNPrice      , nDPrice      , nSPrice      , nWPrice      , nRPrice      , nHPrice      , nMPrice      , :New.Barcode ,
                :New.LotSer  , :New.SDate   , :New.EDate
              );
      Exception
        When OTHERS Then
          NULL;
      End;
  End;
  Begin
    SELECT Id
      INTO nSIcsId
      FROM Stor_SICS
     WHERE Stor_Id=nStr
       AND Item_Id=:New.Item_Id
       AND ICS_Id =:New.Ics_Id;
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)
       WHERE Id=nSIcsId;
    Exception
      When OTHERS Then
        NULL;
    End;
  Exception
    When No_Data_Found Then
      If bPrices Then
        SELECT  CPrice,  NPrice,  DPrice,  SPrice,  WPrice,  RPrice,  HPrice,  MPrice
          INTO nCPrice, nNPrice, nDPrice, nSPrice, nWPrice, nRPrice, nHPrice, nMPrice
          FROM Stor_Item
         WHERE Id=:New.Item_Id;
      End If;
      INSERT INTO Stor_SICS
            ( Id      , Stor_Id , Item_Id     , ICS_Id     ,
              Qnt     , CCst    , CBCst       , CQnt       , WQnt     , CWQnt    ,
              CPrice  , NPrice  , DPrice      , SPrice     , WPrice   , RPrice   , HPrice , MPrice
            )
      VALUES(
              nSIcsId , nStr    , :New.Item_Id, :New.ICS_Id,
              :New.Qnt, :New.Cst, :New.BCst   , :New.Qnt   , :New.WQnt, :New.WQnt,
              nCPrice , nNPrice , nDPrice     , nSPrice    , nWPrice  , nRPrice  , nHPrice, nMPrice
            );
  End;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||NVL(nStr,0)||' MstId='||:New.Id );
End Stor_TBI_EITrn;
/
Create or Replace Trigger
  Stor_TBU_EITrn
  Before Update
  On Stor_EITrn
  For Each Row
Declare
  nStr     Number;
  nIcsId   NUmber;
  nSIcsId  Number;
  nBRate   Number := 0;
  bPrices  Boolean := true;
  nCPrice  Number := 0;
  nNPrice  Number := 0;
  nDPrice  Number := 0;
  nSPrice  Number := 0;
  nWPrice  Number := 0;
  nRPrice  Number := 0;
  nHPrice  Number := 0;
  nMPrice  Number := 0;
Begin
  Select Stor_Id, Decode(Sign(NVL(BCurn_Rate,1)), -1,1, 0,1, NVL(BCurn_Rate,1))
    Into nStr   , nBRate
    From Stor_EIMst
    Where Id=:New.Mst_Id;
  :New.Cst  := NVL(:New.Amt,0);
  :New.BAmt := NVL(:New.Amt,0) * nBRate;
  :New.BCst := NVL(:New.Amt,0) * nBRate;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0)-NVL(:Old.Qnt ,0),
         CAmt =NVL(CAmt ,0)+NVL(:New.Cst ,0)-NVL(:Old.Cst ,0),
         CBAmt=NVL(CBAmt,0)+NVL(:New.BCst,0)-NVL(:Old.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  If :New.TOrd_Id IS NOT NULL Then
    Update Stor_InOrdTrn Set
           CQnt=NVL(CQnt,0)+NVL(:New.Qnt,0)-NVL(:Old.Qnt,0)
     Where Id=:New.TOrd_Id;
  End If;
  IF :New.Item_Id          !=:Old.Item_Id 
     OR NVL(:New.Unit_Id ,0  )!=NVL(:Old.Unit_Id ,0  )
     OR NVL(:New.Model_Id,0  )!=NVL(:Old.Model_Id,0  )
     OR NVL(:New.Color_Id,0  )!=NVL(:Old.Color_Id,0  )
     OR NVL(:New.Size_Id ,0  )!=NVL(:Old.Size_Id ,0  )
     OR NVL(:New.nLength ,0  )!=NVL(:Old.nLength ,0  )
     OR NVL(:New.nWidth  ,0  )!=NVL(:Old.nWidth  ,0  )
     OR NVL(:New.nHeight ,0  )!=NVL(:Old.nHeight ,0  )
     OR NVL(:New.Barcode ,'_')!=NVL(:Old.Barcode ,'_')
     OR NVL(:New.LotSer  ,'_')!=NVL(:Old.LotSer  ,'_')
     OR NVL(:New.SDate   ,TO_Date('01-01-1900', 'DD-MM-YYYY'))!=NVL(:Old.SDate,TO_Date('01-01-1900', 'DD-MM-YYYY'))
     OR NVL(:New.EDate   ,TO_Date('01-01-1900', 'DD-MM-YYYY'))!=NVL(:Old.EDate,TO_Date('01-01-1900', 'DD-MM-YYYY')) THEN
    Begin
      Select Id
        Into nIcsId
        From Stor_ICS
        WHERE Item_Id =    :New.Item_Id
          AND LotSer  =NVL(:New.LotSer  ,'_')
          AND Unit_Id =NVL(:New.Unit_Id ,0  )
          AND Model_Id=NVL(:New.Model_Id,0  )
          AND Size_Id =NVL(:New.Size_Id ,0  )
          AND Color_Id=NVL(:New.Color_Id,0  )
          AND nLength =NVL(:New.nLength ,0  )
          AND nWidth  =NVL(:New.nWidth  ,0  )
          AND nHeight =NVL(:New.nHeight ,0  )
          AND SDate   =NVL(:New.SDate,TO_Date('01-01-1900', 'DD-MM-YYYY'))
          AND EDate   =NVL(:New.EDate,TO_Date('01-01-1900', 'DD-MM-YYYY'));
      IF :Old.Ics_Id IS NOT NULL Then
        Begin
          UPDATE Stor_ICS SET
                 CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
                 CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
                 CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
                 CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
           WHERE Id=:Old.Ics_Id;
        Exception
          When OTHERS Then
            NULL;
        End;
      End IF;
      :New.Ics_Id := nIcsId;
      IF :New.Ics_Id IS NOT NULL Then
        Begin
          UPDATE Stor_ICS SET
                 CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
                 CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0),
                 CCst =NVL(CCst ,0)+NVL(:New.Cst ,0),
                 CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)
           WHERE Id=:New.Ics_Id;
        Exception
          When OTHERS Then
            NULL;
        End;
      End IF;
    Exception
      When No_Data_Found Then
        IF :Old.Ics_Id IS NOT NULL Then
          Begin
            UPDATE Stor_ICS SET
                   CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
                   CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
                   CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
                   CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
             WHERE Id=:Old.Ics_Id;
          Exception
            When OTHERS Then
              NULL;
          End;
        End IF;
        Begin
          SELECT  CPrice,  NPrice,  DPrice,  SPrice,  WPrice,  RPrice,  HPrice,  MPrice
            INTO nCPrice, nNPrice, nDPrice, nSPrice, nWPrice, nRPrice, nHPrice, nMPrice
            FROM Stor_Item
           WHERE Id=:New.Item_Id;
          bPrices := false;
          SELECT Stor_ICS_Seq.nextval
            INTO nIcsId
            FROM Dual;
          :New.Ics_Id := nIcsId;
          INSERT INTO Stor_ICS
                ( Id      , Item_Id , Unit_Id , Model_Id, Color_Id, Size_Id , nLength , nWidth  ,
                  nHeight , Qnt     , CCst    , CBCst   , CQnt    , WQnt    , CWQnt   , CPrice  ,
                  NPrice  , DPrice  , SPrice  , WPrice  , RPrice  , HPrice  , MPrice  , Barcode ,
                  LotSer  , SDate   , EDate
                )
          VALUES(
                  nIcsId       , :New.Item_Id , :New.Unit_Id , :New.Model_Id, :New.Color_Id, :New.Size_Id , :New.nLength , :New.nWidth  ,
                  :New.nHeight , :New.Qnt     , :New.Cst     , :New.BCst    , :New.Qnt     , :New.WQnt    , :New.WQnt    , nCPrice      ,
                  nNPrice      , nDPrice      , nSPrice      , nWPrice      , nRPrice      , nHPrice      , nMPrice      , :New.Barcode ,
                  :New.LotSer  , :New.SDate   , :New.EDate
                );
        Exception
          When OTHERS Then
            NULL;
        End;
    End;
    Begin
      SELECT Id
        INTO nSIcsId
        FROM Stor_SICS
       WHERE Stor_Id=nStr
         AND Item_Id=:New.Item_Id
         AND ICS_Id =:New.Ics_Id;
      Begin
        UPDATE Stor_SICS SET
               CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
               CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0),
               CCst =NVL(CCst ,0)+NVL(:New.Cst ,0),
               CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)
         WHERE Id=nSIcsId;
      Exception
        When OTHERS Then
          NULL;
      End;
    Exception
      When No_Data_Found Then
        IF :Old.SIcs_Id IS NOT NULL Then
          Begin
            UPDATE Stor_SICS SET
                   CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
                   CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
                   CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
                   CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
             WHERE Id=:Old.SIcs_Id;
          Exception
            When OTHERS Then
              NULL;
          End;
        End IF;
        If bPrices Then
          SELECT  CPrice,  NPrice,  DPrice,  SPrice,  WPrice,  RPrice,  HPrice,  MPrice
            INTO nCPrice, nNPrice, nDPrice, nSPrice, nWPrice, nRPrice, nHPrice, nMPrice
            FROM Stor_Item
           WHERE Id=:New.Item_Id;
        End If;
      INSERT INTO Stor_SICS
            ( Id      , Stor_Id , Item_Id     , ICS_Id     ,
              Qnt     , CCst    , CBCst       , CQnt       , WQnt     , CWQnt    ,
              CPrice  , NPrice  , DPrice      , SPrice     , WPrice   , RPrice   , HPrice , MPrice
            )
      VALUES(
              nSIcsId , nStr    , :New.Item_Id, :New.ICS_Id,
              :New.Qnt, :New.Cst, :New.BCst   , :New.Qnt   , :New.WQnt, :New.WQnt,
              nCPrice , nNPrice , nDPrice     , nSPrice    , nWPrice  , nRPrice  , nHPrice, nMPrice
            );
    End;
  ELSE
    IF :New.Ics_Id IS NOT NULL Then
      Begin
        UPDATE Stor_ICS SET
               CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0)-NVL(:Old.Qnt ,0),
               CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0)-NVL(:Old.WQnt,0),
               CCst =NVL(CCst ,0)+NVL(:New.Cst ,0)-NVL(:Old.Cst ,0),
               CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)-NVL(:Old.BCst,0)
         WHERE Id=:New.Ics_Id;
      Exception
        When OTHERS Then
          NULL;
      End;
    End IF;
    IF :New.SIcs_Id IS NOT NULL Then
      Begin
        UPDATE Stor_SICS SET
               CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0)-NVL(:Old.Qnt ,0),
               CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0)-NVL(:Old.WQnt,0),
               CCst =NVL(CCst ,0)+NVL(:New.Cst ,0)-NVL(:Old.Cst ,0),
               CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)-NVL(:Old.BCst,0)
         WHERE Id=:New.SIcs_Id;
      Exception
        When OTHERS Then
          NULL;
      End;
    End IF;
  End IF;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||NVL(nStr,0)||' MstId='||:New.Id );
End Stor_TBU_EITrn;
/
Create or Replace Trigger
  Stor_TBD_EITrn
  Before Delete
  On Stor_EITrn
  For Each Row
Declare
  nStr    Number;
Begin
  Select Stor_Id
    Into nStr
    From Stor_EIMst
    Where Id=:Old.Mst_Id;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
         CAmt =NVL(CAmt ,0)-NVL(:Old.Cst ,0),
         CBAmt=NVL(CBAmt,0)-NVL(:Old.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:Old.Item_Id;
  If :Old.TOrd_Id IS NOT NULL Then
    Update Stor_InOrdTrn Set
           CQnt=NVL(CQnt,0)-NVL(:Old.Qnt,0)
     Where Id=:Old.TOrd_Id;
  End If;
  IF :Old.Ics_Id IS NOT NULL Then
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
       WHERE Id=:Old.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
  IF :Old.SIcs_Id IS NOT NULL Then
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
       WHERE Id=:Old.SIcs_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:Old.Item_Id||' In Store '||nStr );
End Stor_TBD_EITrn;
/
-----------------------------------------------------------------------------------------------------------------------------------------------------
Create or Replace Trigger
  Stor_TBI_EOMst
  Before Insert
  On Stor_EOMst
  For Each Row
Declare
  nBRate Number := 1;
Begin
  :New.BCurn_Id := Get_Base_Currency_Id();
  Select Rate
    Into nBRate
    From Mng_Curn
    Where Id=:New.BCurn_Id;
  If nBRate<=0 Then
    nBRate := 1;
  End If;
  :New.BCurn_Rate := nBRate;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Stor_TBI_EOMst, Undefined Currency '||:New.BCurn_Id||' EOMstId='||:New.Id );
End Stor_TBI_EOMst;
/
Create or Replace Trigger
  Stor_TBI_EOTrn
  Before Insert
  On Stor_EOTrn
  For Each Row
Declare
  nStr     Number;
  nCst     Number;
  nBCst    Number;
  nQnt     Number;
  nBRate   Number := 0;
Begin
  Select Stor_Id, BCurn_Rate
    Into nStr   , nBRate
    From Stor_EOMst
    Where Id=:New.Mst_Id;
  nQnt := 0;
  nCst := 0;
  Select NVL(CQnt,0), NVL(CAmt,0), NVL(CBAmt,0)
    Into nQnt, nCst, nBCst
    From Stor_SMat
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  If nQnt>0 Then
    nCst  := nCst  / nQnt;
    nBCst := nBCst / nQnt;
  End If;
  :New.BAmt := Round(NVL(:New.Amt,0) / nBRate, 2);
  :New.Cst  := nCst  * :New.Qnt;
  :New.BCst := nBCst * :New.Qnt;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
         CAmt =NVL(CAmt ,0)-NVL(:New.Cst ,0),
         CBAmt=NVL(CBAmt,0)-NVL(:New.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  If :New.TOrd_Id IS NOT NULL Then
    Update Stor_OuOrdTrn Set
           CQnt=NVL(CQnt,0)+NVL(:New.Qnt,0)
     Where Id=:New.TOrd_Id;
  End If;
  Begin
    UPDATE Stor_ICS SET
           CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
           CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
           CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
           CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
     WHERE Id=:New.Ics_Id;
  Exception
    When OTHERS Then
      NULL;
  End;
  Begin
    UPDATE Stor_SICS SET
           CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
           CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
           CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
           CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
     WHERE Id=:New.SIcs_Id;
  Exception
    When OTHERS Then
      NULL;
  End;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nStr);
End Stor_TBI_EOTrn;
/
Create or Replace Trigger
  Stor_TBU_EOTrn
  Before Update
  Of Qnt, Cst
  On Stor_EOTrn
  For Each Row
Declare
  nStr    Number;
  nCst    Number;
  nBCst   Number;
  nQnt    Number;
  nBRate  Number := 0;
Begin
  Select Stor_Id, Decode(Sign(NVL(BCurn_Rate,1)), -1,1, 0,1, NVL(BCurn_Rate,1))
    Into nStr   , nBRate
    From Stor_EOMst
    Where Id=:New.Mst_Id;
  nQnt := 0;
  nCst := 0;
  Select NVL(CQnt,0), NVL(CAmt,0), NVL(CBAmt,0)
    Into     nQnt   ,     nCst   ,     nBCst
    From Stor_SMat
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  If nQnt>0 Then
    nCst  := nCst  / nQnt;
    nBCst := nBCst / nQnt;
  End If;
  :New.BAmt := Round(NVL(:New.Amt,0) / nBRate, 2);
  :New.Cst  := nCst * :New.Qnt;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0)+NVL(:Old.Qnt ,0),
         CAmt =NVL(CAmt ,0)-NVL(:New.Cst ,0)+NVL(:Old.Cst ,0),
         CBAmt=NVL(CBAmt,0)-NVL(:New.BCst,0)+NVL(:Old.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  If :New.TOrd_Id IS NOT NULL Then
    Update Stor_OuOrdTrn Set
           CQnt=NVL(CQnt,0)+NVL(:New.Qnt,0)-NVL(:Old.Qnt,0)
     Where Id=:New.TOrd_Id;
  End If;
  IF :New.Ics_Id!=:Old.Ics_Id Then
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
       WHERE Id=:Old.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
       WHERE Id=:New.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  Else
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0)+NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0)+NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0)+NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)+NVL(:Old.BCst,0)
       WHERE Id=:New.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
  IF :New.SIcs_Id!=:Old.SIcs_Id Then
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
       WHERE Id=:Old.SIcs_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
       WHERE Id=:New.SIcs_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  Else
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0)+NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0)+NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0)+NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)+NVL(:Old.BCst,0)
       WHERE Id=:New.SIcs_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nStr);
End Stor_TBU_EOTrn;
/
Create or Replace Trigger
  Stor_TBD_EOTrn
  Before Delete
  On Stor_EOTrn
  For Each Row
Declare
  nStr    Number;
Begin
  Select Stor_Id
    Into nStr
    From Stor_EOMst
    Where Id=:Old.Mst_Id;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
         CAmt =NVL(CAmt ,0)+NVL(:Old.Cst ,0),
         CBAmt=NVL(CBAmt,0)+NVL(:Old.BCst,0)
   Where Stor_Id=nStr
     And Item_Id=:OLD.Item_Id;
  If :Old.TOrd_Id IS NOT NULL Then
    Update Stor_OuOrdTrn Set
           CQnt=NVL(CQnt,0)-NVL(:Old.Qnt,0)
     Where Id=:Old.TOrd_Id;
  End If;
  Begin
    UPDATE Stor_ICS SET
           CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
           CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
           CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
           CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
     WHERE Id=:Old.Ics_Id;
  Exception
    When OTHERS Then
      NULL;
  End;
  Begin
    UPDATE Stor_SICS SET
           CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
           CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
           CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
           CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
     WHERE Id=:Old.SIcs_Id;
  Exception
    When OTHERS Then
      NULL;
  End;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:Old.Item_Id||' In Store '||nStr );
End Stor_TBD_EOTrn;
/
-----------------------------------------------------------------------------------------------------------------------------------------------------
Create or Replace Trigger
  Stor_TBI_TrMst
  Before Insert
  On Stor_TrMst
  For Each Row
Declare
  nBRate Number := 1;
Begin
  :New.BCurn_Id := Get_Base_Currency_Id();
  Select Rate
    Into nBRate
    From Mng_Curn
    Where Id=:New.BCurn_Id;
  If nBRate<=0 Then
    nBRate := 1;
  End If;
  :New.BCurn_Rate := nBRate;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Stor_TBI_TrMst, Undefined Currency '||:New.BCurn_Id||' TrMstId='||:New.Id );
End Stor_TBI_TrMst;
/
Create or Replace Trigger
  Stor_TBI_TrTrn
  Before Insert
  On Stor_TrTrn
  For Each Row
Declare
  nFStr    Number;
  nTStr    Number;
  nCst     Number;
  nBCst    Number;
  nQnt     Number;
  nBRate   Number := 0;
Begin
  Select StorF_Id, StorT_Id, Decode(Sign(NVL(BCurn_Rate,1)), -1,1, 0,1, NVL(BCurn_Rate,1))
    Into nFStr   , nTStr   , nBRate
    From Stor_TrMst
    Where Id=:New.Mst_Id;
  nQnt := 0;
  nCst := 0;
  Select NVL(CQnt,0), NVL(CAmt,0), NVL(CBAmt,0)
    Into nQnt, nCst, nBCst
    From Stor_SMat
   Where Stor_Id=nFStr
     And Item_Id=:New.Item_Id;
  If nQnt>0 Then
    nCst  := nCst  / nQnt;
    nBCst := nBCst / nQnt;
  End If;
  :New.BAmt := Round(NVL(:New.Amt,0) / nBRate, 2);
  :New.Cst  := nCst  * :New.Qnt;
  :New.BCst := nBCst * :New.Qnt;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
         CAmt =NVL(CAmt ,0)-NVL(:New.Cst ,0),
         CBAmt=NVL(CBAmt,0)-NVL(:New.BCst,0)
   Where Stor_Id=nFStr
     And Item_Id=:New.Item_Id;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
         CAmt =NVL(CAmt ,0)+NVL(:New.Cst ,0),
         CBAmt=NVL(CBAmt,0)+NVL(:New.BCst,0)
   Where Stor_Id=nTStr
     And Item_Id=:New.Item_Id;
  Begin
    UPDATE Stor_SICS SET
           CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
           CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
           CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
           CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
     WHERE Id=:New.SIcs_FId;
  Exception
    When OTHERS Then
      NULL;
  End;
  Begin
    UPDATE Stor_SICS SET
           CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
           CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0),
           CCst =NVL(CCst ,0)+NVL(:New.Cst ,0),
           CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)
     WHERE Id=:New.SIcs_TId;
  Exception
    When OTHERS Then
      NULL;
  End;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nFStr||', Store '||nTStr);
End Stor_TBI_TrTrn;
/
Create or Replace Trigger
  Stor_TBU_TrTrn
  Before Update
  Of Qnt, Cst
  On Stor_TrTrn
  For Each Row
Declare
  nFStr   Number;
  nTStr   Number;
  nCst    Number;
  nBCst   Number;
  nQnt    Number;
  nBRate  Number := 0;
Begin
  Select StorF_Id, StorT_Id, Decode(Sign(NVL(BCurn_Rate,1)), -1,1, 0,1, NVL(BCurn_Rate,1))
    Into nFStr   , nTStr   , nBRate
    From Stor_TrMst
    Where Id=:New.Mst_Id;
  nQnt := 0;
  nCst := 0;
  Select NVL(CQnt,0), NVL(CAmt,0), NVL(CBAmt,0)
    Into     nQnt   ,     nCst   ,     nBCst
    From Stor_SMat
   Where Stor_Id=nFStr
     And Item_Id=:New.Item_Id;
  If nQnt>0 Then
    nCst  := nCst  / nQnt;
    nBCst := nBCst / nQnt;
  End If;
  :New.BAmt := Round(NVL(:New.Amt,0) / nBRate, 2);
  :New.Cst := nCst * :New.Qnt;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)-(NVL(:New.Qnt ,0)+NVL(:Old.Qnt ,0)),
         CAmt =NVL(CAmt ,0)-(NVL(:New.Cst ,0)+NVL(:Old.Cst ,0)),
         CBAmt=NVL(CBAmt,0)-(NVL(:New.BCst,0)+NVL(:Old.BCst,0))
   Where Stor_Id=nFStr
     And Item_Id=:New.Item_Id;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)+(NVL(:New.Qnt ,0)+NVL(:Old.Qnt ,0)),
         CAmt =NVL(CAmt ,0)+(NVL(:New.Cst ,0)+NVL(:Old.Cst ,0)),
         CBAmt=NVL(CBAmt,0)+(NVL(:New.BCst,0)+NVL(:Old.BCst,0))
   Where Stor_Id=nTStr
     And Item_Id=:New.Item_Id;
  IF :New.Ics_Id!=:Old.Ics_Id Then
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
       WHERE Id=:Old.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
    Begin
      UPDATE Stor_ICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
       WHERE Id=:New.Ics_Id;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
  IF :New.SIcs_FId!=:Old.SIcs_FId Then
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
       WHERE Id=:Old.SIcs_FId;
    Exception
      When OTHERS Then
        NULL;
    End;
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)-NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:New.BCst,0)
       WHERE Id=:New.SIcs_FId;
    Exception
      When OTHERS Then
        NULL;
    End;
  Else
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)-(NVL(:New.Qnt ,0)+NVL(:Old.Qnt ,0)),
             CWQnt=NVL(CWQnt,0)-(NVL(:New.WQnt,0)+NVL(:Old.WQnt,0)),
             CCst =NVL(CCst ,0)-(NVL(:New.Cst ,0)+NVL(:Old.Cst ,0)),
             CBCst=NVL(CBCst,0)-(NVL(:New.BCst,0)+NVL(:Old.BCst,0))
       WHERE Id=:New.SIcs_FId;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
  IF :New.SIcs_TId!=:Old.SIcs_TId Then
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
             CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
             CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
             CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
       WHERE Id=:Old.SIcs_TId;
    Exception
      When OTHERS Then
        NULL;
    End;
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)+NVL(:New.Qnt ,0),
             CWQnt=NVL(CWQnt,0)+NVL(:New.WQnt,0),
             CCst =NVL(CCst ,0)+NVL(:New.Cst ,0),
             CBCst=NVL(CBCst,0)+NVL(:New.BCst,0)
       WHERE Id=:New.SIcs_TId;
    Exception
      When OTHERS Then
        NULL;
    End;
  Else
    Begin
      UPDATE Stor_SICS SET
             CQnt =NVL(CQnt ,0)+(NVL(:New.Qnt ,0)+NVL(:Old.Qnt ,0)),
             CWQnt=NVL(CWQnt,0)+(NVL(:New.WQnt,0)+NVL(:Old.WQnt,0)),
             CCst =NVL(CCst ,0)+(NVL(:New.Cst ,0)+NVL(:Old.Cst ,0)),
             CBCst=NVL(CBCst,0)+(NVL(:New.BCst,0)+NVL(:Old.BCst,0))
       WHERE Id=:New.SIcs_TId;
    Exception
      When OTHERS Then
        NULL;
    End;
  End IF;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nFStr||', Store '||nTStr);
End Stor_TBU_TrTrn;
/
Create or Replace Trigger
  Stor_TBD_TrTrn
  Before Delete
  On Stor_TrTrn
  For Each Row
Declare
  nFStr    Number;
  nTStr    Number;
Begin
  Select StorF_Id, StorT_Id
    Into nTStr   , nTStr
    From Stor_TrMst
    Where Id=:Old.Mst_Id;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
         CAmt =NVL(CAmt ,0)+NVL(:Old.Cst ,0),
         CBAmt=NVL(CBAmt,0)+NVL(:Old.BCst,0)
   Where Stor_Id=nFStr
     And Item_Id=:OLD.Item_Id;
  Update Stor_SMat Set
         CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
         CAmt =NVL(CAmt ,0)-NVL(:Old.Cst ,0),
         CBAmt=NVL(CBAmt,0)-NVL(:Old.BCst,0)
   Where Stor_Id=nTStr
     And Item_Id=:OLD.Item_Id;
  Begin
    UPDATE Stor_SICS SET
           CQnt =NVL(CQnt ,0)+NVL(:Old.Qnt ,0),
           CWQnt=NVL(CWQnt,0)+NVL(:Old.WQnt,0),
           CCst =NVL(CCst ,0)+NVL(:Old.Cst ,0),
           CBCst=NVL(CBCst,0)+NVL(:Old.BCst,0)
     WHERE Id=:Old.SIcs_FId;
  Exception
    When OTHERS Then
      NULL;
  End;
  Begin
    UPDATE Stor_SICS SET
           CQnt =NVL(CQnt ,0)-NVL(:Old.Qnt ,0),
           CWQnt=NVL(CWQnt,0)-NVL(:Old.WQnt,0),
           CCst =NVL(CCst ,0)-NVL(:Old.Cst ,0),
           CBCst=NVL(CBCst,0)-NVL(:Old.BCst,0)
     WHERE Id=:Old.SIcs_TId;
  Exception
    When OTHERS Then
      NULL;
  End;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:Old.Item_Id||' In Store '||nFStr||', Store '||nTStr);
End Stor_TBD_TrTrn;
/
