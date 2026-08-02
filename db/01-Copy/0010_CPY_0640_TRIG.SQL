Create or Replace Trigger
  Cpy_TAI_Task
  AFTER Insert
  On Cpy_Task
  For Each Row
Declare
Begin
  INSERT INTO Cpy_Task_Status( Id      , Task_Id ,  Proj_Id     , User_Id       , oStatus_Id    , nStatus_Id    , Status_Date, Ins_User     , Ins_Date)
  VALUES ( Cpy_Task_Status_Seq.NEXTVAL , :NEW.Id , :NEW.Proj_Id , :NEW.Ins_User , :NEW.Status_Id, :NEW.Status_Id, SYSDATE    , :NEW.Ins_User, SYSDATE );
End Cpy_TAI_Task;
/

Create or Replace Trigger
  Cpy_TAU_Task
  AFTER UPDATE
  OF Status_Id
  On Cpy_Task 
  For Each Row
Declare
Begin
  INSERT INTO Cpy_Task_Status(Id      , Task_Id, Proj_Id     , User_Id      , oStatus_Id    , nStatus_Id    , Status_Date, Ins_User     , Ins_Date)
  VALUES ( Cpy_Task_Status_Seq.NEXTVAL, :NEW.Id, :NEW.Proj_Id, :NEW.Upd_User, :OLD.Status_Id, :NEW.Status_Id, SYSDATE    , :NEW.Upd_User, SYSDATE );
End Cpy_TAU_Task;
/
