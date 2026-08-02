Create OR Replace Package CpyU AS

  Function Cpy_PrefVal( vKey Varchar2 ) Return Varchar2;
  Function Cpy_BPrefVal( vKey Varchar2, BranId Number ) Return Varchar2;
  Function Cpy_UPrefVal( vKey Varchar2, UserId Number ) Return Varchar2;
  Function Cpy_HPrefVal( vKey Varchar2, UserId Number, BranId Number ) Return Varchar2;

End CpyU;
/
Create OR Replace Package Body CpyU AS

  Function Cpy_PrefVal( vKey Varchar2 ) Return Varchar2 IS
    vRet    Varchar2(100) := NULL;
  Begin
    Select Value1
      Into vRet
      From Cpy_Pref
      Where UPPER(vKey)=UPPER(vKey);
    Return(vRet);
  Exception
    When Others Then
      Return(NULL);
  End Cpy_PrefVal;

  Function Cpy_BPrefVal( vKey Varchar2, BranId Number ) Return Varchar2 IS
    vRet    Varchar2(100) := NULL;
  Begin
    Select Value1
      Into vRet
      From Cpy_BPref
      Where Bran_Id=BranId
        And UPPER(vKey)=UPPER(vKey);
    Return(vRet);
  Exception
    When Others Then
      Return(NULL);
  End Cpy_BPrefVal;

  Function Cpy_UPrefVal( vKey Varchar2, UserId Number ) Return Varchar2 IS
    vRet    Varchar2(100) := NULL;
  Begin
    Select Value1
      Into vRet
      From Cpy_UPref
      Where User_Id=UserId
        And UPPER(vKey)=UPPER(vKey);
    Return(vRet);
  Exception
    When Others Then
      Return(NULL);
  End Cpy_UPrefVal;

  Function Cpy_HPrefVal( vKey Varchar2, UserId Number, BranId Number ) Return Varchar2 IS
    vRet    Varchar2(100) := NULL;
  Begin
    vRet := Cpy_UPrefVal( vKey, UserId );
    If vRet IS NULL Then
      vRet := Cpy_BPrefVal( vKey, BranId );
      If vRet IS NULL Then
        vRet := Cpy_PrefVal( vKey );
      End If;
    End If;
    Return(vRet);
  Exception
    When Others Then
      Return(NULL);
  End Cpy_HPrefVal;

End CpyU;
/
