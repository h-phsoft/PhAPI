Create Or Replace TRIGGER
  Trn_TBI_ChLOC
  BEFORE INSERT OR UPDATE
  ON TRN_ChLOC
  FOR EACH ROW
DECLARE
BEGIN
  UPDATE TRN_BLN SET
         Loc_Id=:NEW.NLOC_ID
   WHERE Id=:NEW.BLN_ID;
EXCEPTION
  When No_Data_Found THEN
    Raise_Application_Error( -20705, 'Undefined Transaction '||:NEW.BLN_ID );
END Trn_TBI_CHLOC;
/
