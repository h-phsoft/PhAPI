Create or Replace Trigger
  Mng_TBID_Curn
  Before Insert
  On Mng_Curn
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select Mng_Curn_Seq.NextVal, Sysdate
      Into :New.Id, :New.HDate
      From Dual;
  End If;
End Mng_TBID_Curn;
/

Create or Replace Trigger
  Mng_TBID_CurnHist
  Before Insert
  On Mng_CurnHist
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select Mng_CurnHist_Seq.NextVal
      Into :New.Id
      From Dual;
  End If;
  UPDATE Mng_Curn Set Rate=:New.Rate, HDate=:New.HDate, Upd_Date=sysdate, Upd_User=:New.Ins_User WHERE Id=:New.Curn_Id;
End Mng_TBID_CurnHist;
/
