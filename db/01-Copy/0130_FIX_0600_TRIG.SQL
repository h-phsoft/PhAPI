CREATE OR REPLACE TRIGGER
  Fix_TBID_Fixed
  BEFORE INSERT
  ON Fix_Fixed
  FOR EACH ROW
DECLARE
BEGIN
  BEGIN
    If :NEW.Id IS NULL THEN
      SELECT Fix_Fixed_Seq.NEXTVAL INTO :NEW.Id FROM Dual;
    END If;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
END Fix_TBID_Fixed;
/

CREATE OR REPLACE TRIGGER
  Fix_TBI_InTrn
  BEFORE INSERT
  ON Fix_InTrn
  FOR EACH ROW
DECLARE
BEGIN
  :New.CQnt := :New.Qnt;
  If NVL(:NEW.CQnt,0)<0 THEN
    Raise_Application_Error( -20701, 'No Qnt. For The Item '||:NEW.Fixd_Id );
  END If;
  If NVL(:NEW.CQnt,0)=0 AND NVL(:NEW.CAmt,0)<>0 THEN
    Raise_Application_Error( -20703, 'Fixd '||:NEW.Fixd_Id||' Has Amount Without Quantity' );
  END If;
END Fix_TBI_InTrn;
/

CREATE OR REPLACE TRIGGER
  Fix_TBU_InTrn
  BEFORE UPDATE
  OF CQnt, CAmt
  ON Fix_InTrn
  FOR EACH ROW
DECLARE
BEGIN
  If NVL(:NEW.CQnt,0)<0 AND NVL(:NEW.CQnt,0)<NVL(:Old.CQnt,0) THEN
    Raise_Application_Error( -20701, 'No Qnt. For The Item '||:NEW.Fixd_Id );
  END If;
  If NVL(:NEW.CQnt,0)=0 AND NVL(:NEW.CAmt,0)<>0 THEN
    Raise_Application_Error( -20703, 'Fixd '||:NEW.Fixd_Id||' Has Amount Without Quantity' );
  END If;
END Fix_TBU_InTrn;
/

CREATE OR REPLACE TRIGGER
  Fix_TBI_OuTrn
  BEFORE INSERT
  ON Fix_OuTrn
  FOR EACH ROW
DECLARE
  nPrice    Number := 0;
BEGIN
  SELECT Price
    INTO nPrice
    FROM Fix_InTrn
    WHERE Id=:NEW.Trn_Id;
  :NEW.UCst := NVL(nPrice,0);
  :NEW.Cst  := NVL(:NEW.UCst,0) * NVL(:NEW.Qnt,0);
  UPDATE Fix_InTrn SET
         CQnt=NVL(CQnt,0)-NVL(:NEW.Qnt,0),
         CAmt=NVL(CAmt,0)-NVL(:NEW.Cst,0)
   WHERE Id=:NEW.Trn_Id;
EXCEPTION
  When No_Data_Found THEN
    Raise_Application_Error( -20705, 'Undefined Transaction '||:NEW.Trn_Id );
END Fix_TBI_OuTrn;
/

CREATE OR REPLACE TRIGGER
  Fix_TBU_OuTrn
  BEFORE UPDATE
  OF Qnt
  ON Fix_OuTrn
  FOR EACH ROW
DECLARE
  nPrice    Number := 0;
BEGIN
  SELECT Price
    INTO nPrice
    FROM Fix_InTrn
    WHERE Id=:NEW.Trn_Id;
  :NEW.UCst := NVL(nPrice,0);
  :NEW.Cst  := NVL(:NEW.UCst,0) * NVL(:NEW.Qnt,0);
  UPDATE Fix_InTrn SET
         CQnt=NVL(CQnt,0)+NVL(:OLD.Qnt,0)-NVL(:NEW.Qnt,0),
         CAmt=NVL(CAmt,0)+NVL(:OLD.Cst,0)-NVL(:NEW.Cst,0)
   WHERE Id=:NEW.Trn_Id;
EXCEPTION
  WHEN No_Data_Found THEN
    Raise_Application_Error( -20705, 'Undefined Transaction '||:NEW.Trn_Id );
END Fix_TBU_OuTrn;
/

CREATE OR REPLACE TRIGGER
  Fix_TBD_OuTrn
  BEFORE DELETE
  ON Fix_OuTrn
  FOR EACH ROW
DECLARE
BEGIN
  UPDATE Fix_InTrn SET
         CQnt=NVL(CQnt,0)+NVL(:OLD.Qnt,0),
         CAmt=NVL(CAmt,0)+NVL(:OLD.Cst,0)
   WHERE Id=:OLD.Trn_Id;
EXCEPTION
  WHEN No_Data_Found THEN
    Raise_Application_Error( -20705, 'Undefined Transaction '||:OLD.Trn_Id );
END Fix_TBD_OuTrn;
/
-----------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER
  Fix_TBI_LocTrn
  BEFORE INSERT
  ON Fix_LocTrn
  FOR EACH ROW
DECLARE
BEGIN
  UPDATE Fix_Intrn SET
         Loc1_Id=:NEW.Loc1_Id,
         Loc2_Id=:NEW.Loc2_Id,
         Loc3_Id=:NEW.Loc3_Id
   WHERE Id=:NEW.FTRN_ID;
EXCEPTION
  When No_Data_Found THEN
    Raise_Application_Error( -20705, 'Undefined Transaction '||:NEW.FTRN_ID );
END Fix_TBI_LocTrn;
/

CREATE OR REPLACE TRIGGER
  Fix_TBI_Spctrn
  BEFORE INSERT
  ON Fix_Spctrn
  FOR EACH ROW
DECLARE
BEGIN
  UPDATE Fix_Intrn SET
         SPC1_ID  = :NEW.SPC1_ID,
         SPC2_ID  = :NEW.SPC2_ID,
         SPC3_ID  = :NEW.SPC3_ID,
         SPC4_ID  = :NEW.SPC4_ID,
         SPC5_ID  = :NEW.SPC5_ID,
         SPC6     = :NEW.SPC6,
         STATUS_ID= :NEW.STATUS_ID
   WHERE Id = :NEW.FTRN_ID;
EXCEPTION
  When No_Data_Found THEN
    Raise_Application_Error( -20705, 'Undefined Transaction '||:NEW.FTRN_ID );
END Fix_TBI_Spctrn;
/
