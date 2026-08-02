/*
Sample for Audit triggers
CREATE OR REPLACE TRIGGER Audit_Acc_Acc AS
  BEFORE INSERT
      OR UPDATE
      OR DELETE
  ON Acc_Account
DECLARE
  vNew     Varchar2(4096 char);
  vOld     Varchar2(4096 char);
BEGIN

  If INSERTING OR UPDATING Then
    INSERT INTO Phs_Audit
          ( Id, nType, User_Id, vNew)
    VALUES( Phs_Audit_Seq.nextval,
            1,
            :NEW.Ins_User,
            '"Id": "'||:NEW.Id||'"';
            ', "Num": "'||:NEW.Num||'"'
            ', "Name": "'||:NEW.Name||'"'
            ', "Type_Id": "'||:NEW.Type_Id||'"'
            ', "Status_Id": "'||:NEW.Status_Id||'"'
            ', "Dbcr_Id": "'||:NEW.Dbcr_Id||'"'
            ', "Close_Id": "'||:NEW.Close_Id||'"'
            ', "Pid": "'||:NEW.Pid||'"'
            ', "Rem": "'||:NEW.Rem||'"'
            ', "Ins_User": "'||:NEW.Ins_User||'"'
            ', "Ins_Date": "'||To_Char(:NEW.Ins_Date, 'DD-MM-YYYY')||'"'
            ', "Upd_User": "'||:NEW.Upd_User||'"'
            ', "Upd_Date": "'||To_Char(:NEW.Upd_Date, 'DD-MM-YYYY')||'"'
          );
  ELSE If UPDATING Then
    INSERT INTO Phs_Audit
          ( Id, nType, User_Id, vNew, vOld)
    VALUES( Phs_Audit_Seq.nextval, 2,
            :NEW.Upd_User,
            '"Id": "'||:NEW.Id||'"';
            ', "Num": "'||:NEW.Num||'"'
            ', "Name": "'||:NEW.Name||'"'
            ', "Type_Id": "'||:NEW.Type_Id||'"'
            ', "Status_Id": "'||:NEW.Status_Id||'"'
            ', "Dbcr_Id": "'||:NEW.Dbcr_Id||'"'
            ', "Close_Id": "'||:NEW.Close_Id||'"'
            ', "Pid": "'||:NEW.Pid||'"'
            ', "Rem": "'||:NEW.Rem||'"'
            ', "Ins_User": "'||:NEW.Ins_User||'"'
            ', "Ins_Date": "'||To_Char(:NEW.Ins_Date, 'DD-MM-YYYY')||'"'
            ', "Upd_User": "'||:NEW.Upd_User||'"'
            ', "Upd_Date": "'||To_Char(:NEW.Upd_Date, 'DD-MM-YYYY')||'"'
            ,
            '"Id": "'||:OLD.Id||'"';
            ', "Num": "'||:OLD.Num||'"'
            ', "Name": "'||:OLD.Name||'"'
            ', "Type_Id": "'||:OLD.Type_Id||'"'
            ', "Status_Id": "'||:OLD.Status_Id||'"'
            ', "Dbcr_Id": "'||:OLD.Dbcr_Id||'"'
            ', "Close_Id": "'||:OLD.Close_Id||'"'
            ', "Pid": "'||:OLD.Pid||'"'
            ', "Rem": "'||:OLD.Rem||'"'
            ', "Ins_User": "'||:OLD.Ins_User||'"'
            ', "Ins_Date": "'||To_Char(:OLD.Ins_Date, 'DD-MM-YYYY')||'"'
            ', "Upd_User": "'||:OLD.Upd_User||'"'
            ', "Upd_Date": "'||To_Char(:OLD.Upd_Date, 'DD-MM-YYYY')||'"'
          );
  ELSE If DELETTING Then
    INSERT INTO Phs_Audit
          ( Id, nType, User_Id, vOld)
    VALUES( Phs_Audit_Seq.nextval, 3,
            :OLD.Upd_User,
            '"Id": "'||:OLD.Id||'"';
            ', "Num": "'||:OLD.Num||'"'
            ', "Name": "'||:OLD.Name||'"'
            ', "Type_Id": "'||:OLD.Type_Id||'"'
            ', "Status_Id": "'||:OLD.Status_Id||'"'
            ', "Dbcr_Id": "'||:OLD.Dbcr_Id||'"'
            ', "Close_Id": "'||:OLD.Close_Id||'"'
            ', "Pid": "'||:OLD.Pid||'"'
            ', "Rem": "'||:OLD.Rem||'"'
            ', "Ins_User": "'||:OLD.Ins_User||'"'
            ', "Ins_Date": "'||To_Char(:OLD.Ins_Date, 'DD-MM-YYYY')||'"'
            ', "Upd_User": "'||:OLD.Upd_User||'"'
            ', "Upd_Date": "'||To_Char(:OLD.Upd_Date, 'DD-MM-YYYY')||'"'
          );
  End If;

END Audit_Acc_Acc;
*/

Create or Replace Trigger
  Acc_TBID_Acc
  Before Insert
  On Acc_Acc
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    SELECT Acc_Acc_Seq.nextval Into :New.Id FROM DUAL;
  End If;
End Acc_TBID_Acc;
/

Create or Replace Trigger
  Acc_TBU_Acc
  Before Update
  Of Type_Id
  On Acc_Acc
  For Each Row
Declare
  nCount     Number := 0;
Begin
  If :New.Type_Id=1 AND :New.Type_Id!=:Old.Type_Id Then
    SELECT Count(*) INTO nCount FROM Acc_Trn WHERE Acc_Id=:New.Id;
    If NVL(nCount,0)>0 Then
      Raise_Application_Error( -20101, 'There is Transactions on the Account Cannot Change Type to Head Account' );
    End If;
  End If;
End Acc_TBU_Acc;
/

Create or Replace Trigger
  Acc_TBU_Cost
  Before Update
  Of Type_Id
  On Acc_Cost
  For Each Row
Declare
  nCount     Number := 0;
Begin
  If :New.Type_Id=1 AND :New.Type_Id!=:Old.Type_Id Then
    SELECT Count(*) INTO nCount FROM Acc_Trn WHERE Cost_Id=:New.Id;
    If NVL(nCount,0)>0 Then
      Raise_Application_Error( -20102, 'There is Transactions on the Center Cannot Change Type to Head Center' );
    End If;
  End If;
End Acc_TBU_Cost;
/
Create or Replace Trigger
  Acc_TBID_Cost
  Before Insert
  On Acc_Cost
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    SELECT Acc_Cost_Seq.nextval Into :New.Id FROM DUAL;
  End If;
End Acc_TBID_Cost;
/
create or replace Trigger
  Acc_TBI_Mst_Init
  Before Insert
  On Acc_Mst
  For Each Row
Declare
Begin
  If :New.PNum IS NULL Then
    :New.PNum := :New.Num;
  End If;
End Acc_TBI_Mst_Init;
/
