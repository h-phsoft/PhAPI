Create or Replace Trigger
  Cpy_TBID_Cod_Unit
  Before Insert
  On Cpy_Cod_Unit
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select Cpy_Cod_Unit_Seq.NextVal
      Into :New.Id
      From Dual;
  End If;
End Cpy_TBID_Cod_Unit;
/
Create or Replace Trigger
  Cpy_TBID_Cod_Doc
  Before Insert
  On Cpy_Cod_Doc
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select Cpy_Cod_Doc_Seq.NextVal
      Into :New.Id
      From Dual;
  End If;
End Cpy_TBID_Cod_Doc;
/
Create or Replace Trigger
  Cpy_TBID_Perm
  Before Insert
  On Cpy_Perm
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select Cpy_Perm_Seq.NextVal
      Into :New.Id
      From Dual;
  End If;
End Cpy_TBID_Perm;
/

Create or Replace Trigger
  Cpy_TBID_PermPriv
  Before Insert
  On Cpy_PermPriv
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select Cpy_PermPriv_Seq.NextVal
      Into :New.Id
      From Dual;
  End If;
End Cpy_TBID_PermPriv;
/

Create or Replace Trigger
  Cpy_TBID_User
  Before Insert
  On Cpy_User
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select Cpy_User_Seq.NextVal
      Into :New.Id
      From Dual;
  End If;
End Cpy_TBID_User;
/
