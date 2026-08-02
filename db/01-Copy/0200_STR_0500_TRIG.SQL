Create or Replace Trigger
  Str_TBID_Item
  Before Insert
  On Str_Item
  For Each Row
Declare
Begin
  Begin
    If :New.Id IS NULL Then
      Select Str_Item_Seq.NextVal INTO :New.Id From Dual;
    End If;
  Exception
    When Others Then
      NULL;
  End;
End Str_TBID_Item;
/

Create or Replace Trigger
  Str_TBID_Store
  Before Insert
  On Str_Store
  For Each Row
Declare
Begin
  Begin
    If :New.Id IS NULL Then
      Select Str_Store_Seq.NextVal INTO :New.Id From Dual;
    End If;
  Exception
    When Others Then
      NULL;
  End;
End Str_TBID_Store;
/

Create or Replace Trigger
  Str_TBID_SMat
  Before Insert
  On Str_SMat
  For Each Row
Declare
Begin
  Begin
    If :New.Id IS NULL Then
      Select Str_SMat_Seq.NextVal INTO :New.Id From Dual;
    End If;
  Exception
    When Others Then
      NULL;
  End;
End Str_TBID_SMat;
/
-------------------------
Create or Replace Trigger
   Str_TBU_SMat
   Before Update
   Of CQnt, CAmt
   On Str_SMat
   For Each Row
Declare
Begin
  If NVL(:New.CQnt,0)<0 And NVL(:New.CQnt,0)<NVL(:Old.CQnt,0) Then
    Raise_Application_Error( -20701, 'No Qnt. In Store '||:New.Stor_Id||' For The Item '||:New.Item_Id );
  End If;
  If NVL(:New.CQnt,0)=0 And NVL(:New.CAmt,0)<>0 Then
    Raise_Application_Error( -20703, 'Item '||:New.Item_Id||' on The Store '||:New.Stor_Id||' Has Amount Without Quantity' );
  End If;
End Str_TBU_SMat;
/

Create or Replace Trigger
  Str_TBI_InTrn
  Before Insert
  On Str_InTrn
  For Each Row
Declare
  nStr     Number;
Begin
  Select Stor_Id
    Into nStr
    From Str_InMst
    Where Id=:New.Mst_Id;
  :New.Cst := NVL(:New.Amt,0);
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)+NVL(:New.Qnt,0),
         CAmt=NVL(CAmt,0)+NVL(:New.Cst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||NVL(nStr,0)||' MstId='||:New.Mst_Id );
End Str_TBI_InTrn;
/

Create or Replace Trigger
  Str_TBU_InTrn
  Before Update
  On Str_InTrn
  For Each Row
Declare
  nStr     Number;
Begin
  Select Stor_Id
    Into nStr
    From Str_InMst
    Where Id=:New.Mst_Id;
  :New.Cst := NVL(:New.Amt,0);
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)+NVL(:New.Qnt,0)-NVL(:Old.Qnt,0),
         CAmt=NVL(CAmt,0)+NVL(:New.Cst,0)-NVL(:Old.Cst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||NVL(nStr,0)||' MstId='||:New.Mst_Id );
End Str_TBU_InTrn;
/

Create or Replace Trigger
  Str_TBD_InTrn
  Before Delete
  On Str_InTrn
  For Each Row
Declare
  nStr    Number;
Begin
  Select Stor_Id
    Into nStr
    From Str_InMst
    Where Id=:Old.Mst_Id;
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)-NVL(:Old.Qnt,0),
         CAmt=NVL(CAmt,0)-NVL(:Old.Cst,0)
   Where Stor_Id=nStr
     And Item_Id=:Old.Item_Id;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:Old.Item_Id||' In Store '||nStr );
End Str_TBD_InTrn;
/

Create or Replace Trigger
  Str_TBI_OuTrn
  Before Insert
  On Str_OuTrn
  For Each Row
Declare
  nStr    Number;
  nCst    Number;
  nQnt    Number;
Begin
  Select Stor_Id
    Into nStr
    From Str_OuMst
    Where Id=:New.Mst_Id;
  nQnt := 0;
  nCst := 0;
  Select NVL(CQnt,0), NVL(CAmt,0)
    Into nQnt, nCst
    From Str_SMat
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  -- Avrage
  If nQnt>0 Then
    nCst := nCst / nQnt;
  End If;
  :New.Cst := nCst * :New.Qnt;
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)-NVL(:New.Qnt,0),
         CAmt=NVL(CAmt,0)-NVL(:New.Cst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nStr);
End Str_TBI_OuTrn;
/

Create or Replace Trigger
  Str_TBU_OuTrn
  Before Update
  Of Qnt
  On Str_OuTrn
  For Each Row
Declare
  nStr    Number;
  nCst    Number;
  nQnt    Number;
Begin
  Select Stor_Id
    Into nStr
    From Str_OuMst
    Where Id=:New.Mst_Id;
  nQnt := 0;
  nCst := 0;
  Select NVL(CQnt,0), NVL(CAmt,0)
    Into nQnt, nCst
    From Str_SMat
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
  -- Avrage
  If nQnt>0 Then
    nCst := nCst / nQnt;
  End If;
  :New.Cst := nCst * :New.Qnt;
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)-NVL(:New.Qnt,0)+NVL(:Old.Qnt,0),
         CAmt=NVL(CAmt,0)-NVL(:New.Cst,0)+NVL(:Old.Cst,0)
   Where Stor_Id=nStr
     And Item_Id=:New.Item_Id;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nStr);
End Str_TBU_OuTrn;
/

Create or Replace Trigger
  Str_TBD_OuTrn
  Before Delete
  On Str_OuTrn
  For Each Row
Declare
  nStr    Number;
Begin
  Select Stor_Id
    Into nStr
    From Str_OuMst
    Where Id=:Old.Mst_Id;
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)+NVL(:Old.Qnt,0),
         CAmt=NVL(CAmt,0)+NVL(:Old.Cst,0)
   Where Stor_Id=nStr
     And Item_Id=:OLD.Item_Id;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:Old.Item_Id||' In Store '||nStr );
End Str_TBD_OuTrn;
/

Create or Replace Trigger
  Str_TBI_TrTrn
  Before Insert
  On Str_TrTrn
  For Each Row
Declare
  nFStr   Number;
  nTStr   Number;
  nCst    Number;
  nQnt    Number;
Begin
  Select StorF_Id, StorT_Id
    Into nFStr   , nTStr
    From Str_TrMst
    Where Id=:New.Mst_Id;
  nQnt := 0;
  nCst := 0;
  Select NVL(CQnt,0), NVL(CAmt,0)
    Into nQnt, nCst
    From Str_SMat
   Where Stor_Id=nFStr
     And Item_Id=:New.Item_Id;
  -- Avrage
  If nQnt>0 Then
    nCst := nCst / nQnt;
  End If;
  :New.Cst := nCst * :New.Qnt;
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)-NVL(:New.Qnt,0),
         CAmt=NVL(CAmt,0)-NVL(:New.Cst,0)
   Where Stor_Id=nFStr
     And Item_Id=:New.Item_Id;
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)+NVL(:New.Qnt,0),
         CAmt=NVL(CAmt,0)+NVL(:New.Cst,0)
   Where Stor_Id=nTStr
     And Item_Id=:New.Item_Id;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nFStr||' OR Store '||nTStr);
End Str_TBI_TrTrn;
/

Create or Replace Trigger
  Str_TBU_TrTrn
  Before Update
  Of Qnt, Cst
  On Str_TrTrn
  For Each Row
Declare
  nFStr   Number;
  nTStr   Number;
  nCst    Number;
  nQnt    Number;
Begin
  Select StorF_Id, StorT_Id
    Into nFStr   , nTStr
    From Str_TrMst
    Where Id=:New.Mst_Id;
  nQnt := 0;
  nCst := 0;
  Select NVL(CQnt,0), NVL(CAmt,0)
    Into nQnt, nCst
    From Str_SMat
   Where Stor_Id=nFStr
     And Item_Id=:New.Item_Id;
  -- Avrage
  If nQnt>0 Then
    nCst := nCst / nQnt;
  End If;
  :New.Cst := nCst * :New.Qnt;
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)-NVL(:New.Qnt,0)+NVL(:Old.Qnt,0),
         CAmt=NVL(CAmt,0)-NVL(:New.Cst,0)+NVL(:Old.Cst,0)
   Where Stor_Id=nFStr
     And Item_Id=:New.Item_Id;
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)+NVL(:New.Qnt,0)-NVL(:Old.Qnt,0),
         CAmt=NVL(CAmt,0)+NVL(:New.Cst,0)-NVL(:Old.Cst,0)
   Where Stor_Id=nTStr
     And Item_Id=:New.Item_Id;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nFStr||' OR Store '||nTStr);
End Str_TBU_TrTrn;
/

Create or Replace Trigger
  Str_TBD_TrTrn
  Before Delete
  On Str_TrTrn
  For Each Row
Declare
  nFStr   Number;
  nTStr   Number;
Begin
  Select StorF_Id, StorT_Id
    Into nFStr   , nTStr
    From Str_TrMst
    Where Id=:Old.Mst_Id;
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)+NVL(:Old.Qnt,0),
         CAmt=NVL(CAmt,0)+NVL(:Old.Cst,0)
   Where Stor_Id=nFStr
     And Item_Id=:OLD.Item_Id;
  Update Str_SMat Set
         CQnt=NVL(CQnt,0)-NVL(:Old.Qnt,0),
         CAmt=NVL(CAmt,0)-NVL(:Old.Cst,0)
   Where Stor_Id=nTStr
     And Item_Id=:OLD.Item_Id;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20705, 'Undefined Item '||:New.Item_Id||' In Store '||nFStr||' OR Store '||nTStr);
End Str_TBD_TrTrn;
/
