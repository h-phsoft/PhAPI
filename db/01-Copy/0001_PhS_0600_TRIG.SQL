Create or Replace Trigger
  Phs_TBID_MPrg
  Before Insert
  On Phs_MPrg
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    :New.Id := '1'||To_Number(LTRim(To_Char(:New.Menu_Id,'0000'))||
                              LTRim(To_Char(:New.Ord    ,'0000')));
  End If;
End Phs_TBID_MPrg;
/
