DROP   CONTEXT PhCTX;
CREATE CONTEXT PhCTX USING PhContext ACCESSED GLOBALLY;

Create OR Replace Package PhContext AS
  Procedure Set_Lang(nLangId IN NUMBER);
  Procedure Set_User(nUserId IN NUMBER);
  Procedure Set_Period(nPeriodId IN NUMBER);
End PhContext;
/
Create OR Replace Package Body PhContext AS
  Procedure Set_Lang(nLangId IN NUMBER) IS
  Begin
    IF nLangId NOT IN (1, 2) THEN
      RAISE_APPLICATION_ERROR(-20001, 'Invalid LANG_Id');
    END IF;
    DBMS_SESSION.SET_CONTEXT('PhCTX', 'LANG_ID', nLangId);
  END;

  Procedure set_User(nUserId IN NUMBER) IS
  Begin
    DBMS_SESSION.SET_CONTEXT('PhCTX', 'USER_ID', nUserId);
  End;

  Procedure set_Period(nPeriodId IN NUMBER) IS
  Begin
    DBMS_SESSION.SET_CONTEXT('PhCTX', 'PERIOD_ID', nPeriodId);
  End;
End PhContext;
/
CREATE PUBLIC SYNONYM PhContext FOR C##erpAdmin.PhContext;

GRANT EXECUTE ON PhContext TO C##erpCopy;
Grant EXECUTE ON PhContext To C##erpDemo;
Grant EXECUTE ON PhContext To C##erpClinic;
Grant EXECUTE ON PhContext To C##erpNSCC;
Grant EXECUTE ON PhContext To C##NSCC;
Grant EXECUTE ON PhContext To C##erpUN;
Grant EXECUTE ON PhContext To C##UN;
Grant EXECUTE ON PhContext To C##erpEpona;
Grant EXECUTE ON PhContext To C##erpNIG;
Grant EXECUTE ON PhContext To C##erpELcom;
Grant EXECUTE ON PhContext To C##erpFarkad;
Grant EXECUTE ON PhContext To C##erpHashemia;
Grant EXECUTE ON PhContext To C##erpLRGC;
Grant EXECUTE ON PhContext To C##erpiCloud;
Grant EXECUTE ON PhContext To C##erpOLEK;
Grant EXECUTE ON PhContext To C##erpTrans;
Grant EXECUTE ON PhContext To C##erpDEC;
Grant EXECUTE ON PhContext To C##erpDECB;
Grant EXECUTE ON PhContext To C##erpAlTaqi;
Grant EXECUTE ON PhContext To C##erpAlmasa;
Grant EXECUTE ON PhContext To C##erpSabbagh;
