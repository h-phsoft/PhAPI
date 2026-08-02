Create OR Replace Package CpySecur AS

  Function Check_Login( UserName Varchar2, Password Varchar2 ) Return Number;
  Procedure ChangeUserPassword( nUserId Number, vOldPassword Varchar2, vNewPassword Varchar2, nRet OUT Number );
  Procedure ResetUserPassword( nUserId Number, vNewPassword Varchar2, nRet OUT Number );

End CpySecur;
/
Create OR Replace Package Body CpySecur AS

  Function Check_Login( UserName Varchar2, Password Varchar2 ) Return Number is
    UserId Number := -99;
  Begin
    Select Id
      Into UserId
      From Cpy_User
     Where Status_Id=1
       And UPPER(Logon)=UPPER(UserName)
       And Pass=PhSecur.Encode_Pass(Password);
    Return(UserId);
  Exception
    When Others Then
      Return(UserId);
  End Check_Login;

  Procedure ChangeUserPassword( nUserId Number, vOldPassword Varchar2, vNewPassword Varchar2, nRet OUT Number ) is
    UserId Number := -99;
  Begin
    nRet := 0;
    Begin
      Select Id
        Into UserId
        From Cpy_User
       Where Id=nUserId
         And Pass=Encode_Pass(vOldPassword);
      Begin
        Update Cpy_User SET Pass=Encode_Pass(vNewPassword) Where Id=nUserId;
        nRet := 1;
      Exception
        When Others Then
          nRet := -2;
      End;
    Exception
      When Others Then
        DBMS_Output.Put_Line(SQLERRM);
        nRet := -1;
    End;
  End ChangeUserPassword;

  Procedure ResetUserPassword( nUserId Number, vNewPassword Varchar2, nRet OUT Number ) is
    UserId Number := -99;
  Begin
    nRet := 0;
    Begin
      Update Cpy_User SET Pass=Encode_Pass(vNewPassword) Where Id=nUserId;
      nRet := 1;
    Exception
      When Others Then
        nRet := -1;
    End;
  End ResetUserPassword;

End CpySecur;
/
Create OR Replace Function Check_Login( vUserName Varchar2, vPassword Varchar2 ) Return Number IS
Begin
  Return CpySecur.Check_Login( vUserName, vPassword );
End Check_Login;
/
Create OR Replace Function ChangeUserPassword( nUserId Number, vOldPassword Varchar2, vNewPassword Varchar2 ) Return Number IS
  nRet  Number := 0;
Begin
  CpySecur.ChangeUserPassword( nUserId, vOldPassword, vNewPassword, nRet );
  Return nRet;
End ChangeUserPassword;
/
Create OR Replace Function ResetUserPassword( nUserId Number, vNewPassword Varchar2 ) Return Number IS
  nRet  Number := 0;
Begin
  CpySecur.ResetUserPassword( nUserId, vNewPassword, nRet );
  Return nRet;
End ResetUserPassword;
/
