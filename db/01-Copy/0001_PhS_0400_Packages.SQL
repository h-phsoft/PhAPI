Create OR Replace Package PhSecur AS

  Function Encode_Pass( vPass Varchar2 ) Return Varchar2;
  Function Check_Period( nPeriod Number := 0, dCDate Date := sysdate, dTDate Date := Sysdate ) Return Number;

End PhSecur;
/
Create OR Replace Package Body PhSecur AS

  Function Encode_Pass( vPass Varchar2 ) Return Varchar2 IS
    vSecret       Varchar2(32) := 'OneGod165';
    vEncrypted    Varchar2(128);
  Begin
    --SELECT DBMS_OBFUSCATION_TOOLKIT.md5(input => UTL_I18N.STRING_TO_RAW (vSecret||vPass, 'AL32UTF8')) -- Oracle 11g or Less
    SELECT UTL_I18N.STRING_TO_RAW (vSecret||vPass, 'AL32UTF8')                                        -- Oracle 12c Or Greater
      INTO vEncrypted
      FROM dual;
    Return(vEncrypted);
  End Encode_Pass;
  
  Function Check_Period( nPeriod Number := 0, dCDate Date := sysdate, dTDate Date := Sysdate ) Return Number IS
    bRet   Boolean := False;
    nRet   Number  := 0;
    nTmp1  Number  := 0;
    nTmp2  Number  := 0;
  Begin
    If nPeriod>=0 Then
      bRet := (dTDate-dCDate)<=nPeriod;
    Else
      If nPeriod=-1 Then
        nTmp1 := To_Number(To_Char(dTDate,'YYYY'));
        nTmp2 := To_Number(To_Char(dCDate,'YYYY'));
      ElsIf nPeriod=-2 Then
        nTmp1 := To_Number(To_Char(dTDate,'MM'));
        nTmp2 := To_Number(To_Char(dCDate,'MM'));
      ElsIf nPeriod=-3 Then
        nTmp1 := To_Number(To_Char(dTDate,'WW'));
        nTmp2 := To_Number(To_Char(dCDate,'WW'));
      End If;
      If nTmp1=nTmp2 Then
        bRet := True;
      End If;
    End If;
    If bRet Then
      nRet := 1;
    End If;
    Return(nRet);
  End Check_Period;

End PhSecur;
/
Create OR Replace Function Encode_Pass( vPassword Varchar2 ) Return Varchar2 IS
Begin
  Return PhSecur.Encode_Pass( vPassword );
End Encode_Pass;
/
Create OR Replace Function Compare_Pass( vOldPassword Varchar2, vNewPassword Varchar2 ) Return Number IS
  nRet   Number := 0;
Begin
  If PhSecur.Encode_Pass( vOldPassword )=PhSecur.Encode_Pass( vNewPassword ) Then
    nRet := 1;
  End If;
  Return nRet;
End Compare_Pass;
/
