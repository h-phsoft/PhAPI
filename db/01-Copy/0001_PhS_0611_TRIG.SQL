Create or Replace Trigger
  Phs_TBID_Pref_Struct
  Before Insert
  On Phs_Pref_Struct
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select Phs_Pref_Struct_Seq.NextVal Into :New.Id From Dual;
  End If;
End Phs_TBID_Pref_Struct;
/

Create or Replace Trigger
  Phs_TBID_Dash_Blocks
  Before Insert
  On Phs_Dash_Blocks
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select Phs_Dash_Blocks_Seq.NextVal Into :New.Id From Dual;
  End If;
End Phs_TBID_Dash_Blocks;
/
