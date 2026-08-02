Create or Replace Trigger
  Phs_TBID_Pref
  Before Insert
  On Phs_Pref
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select PhsId_Seq.NextVal Into :New.Id From Dual;
  End If;
End Phs_TBID_Pref;
/
