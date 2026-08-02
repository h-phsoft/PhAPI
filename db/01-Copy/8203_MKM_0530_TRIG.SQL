Create or Replace Trigger
  MKM_TBIU_Member
  Before Insert OR UPDATE
  On MKM_Member
  For Each Row
Declare
Begin
  If NVL(:New.Points,0)<0 Then
    Raise_Application_Error( -20802, 'Negative Points');
  End If;
End MKM_TBIU_Member;
/

CREATE OR REPLACE TRIGGER MKM_TBI_Sales_Item
  BEFORE INSERT ON MKM_Sales_Items
  FOR EACH ROW
DECLARE
  dDate   DATE   := SYSDATE;
  nCatId  NUMBER := 0;
  nUserId NUMBER;
BEGIN
  SELECT Mdate, User_Id
    INTO dDate, nUserId
    FROM MKM_Sale
   WHERE Id = :NEW.Sales_Id;
  BEGIN
    SELECT Prod_Id
      INTO :NEW.Prod_Id
      FROM MKM_Prod_Serial
     WHERE Serial = :NEW.Serial;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20803, 'Unregistered Serial Number');
  END;
  SELECT Cat_Id
    INTO nCatId
    FROM MKM_Product
   WHERE Id = :NEW.Prod_Id;
  SELECT SPoints, Wdays
    INTO :NEW.Points, :NEW.Wdays
    FROM MKM_Cat
   WHERE Id = nCatId;
  :NEW.Edate := dDate + :NEW.Wdays;
  UPDATE MKM_Member 
     SET Points = NVL(Points, 0) + :NEW.Points
   WHERE User_Id = nUserId;
END MKM_TBI_Sales_Item;
/

Create or Replace Trigger
  MKM_TBD_Sales_Item
  Before Delete
  On MKM_Sales_Item
  For Each Row
Declare
  nUserId  Number;
Begin
  Select User_Id
    Into nUserId
    From MKM_Sale
   Where Id=:Old.Sales_Id;
  UPDATE MKM_Member SET Points=NVL(Points,0)-:Old.Points
   WHERE User_Id=nUserId;
Exception
  When Others Then
    NULL;
End MKM_TBD_Sales_Item;
/

Create or Replace Trigger
  MKM_TBI_Inst_Item
  Before Insert
  On MKM_Inst_Items
  For Each Row
Declare
  nSaleId  Number;
  nCatId   Number := 0;
  nUserId  Number;
Begin
  Begin
    Select Sales_Id
      Into nSaleId
      From MKM_Sales_Item
      Where Serial=:New.Serial;
  Exception
    When No_Data_Found Then
      nSaleId := null;
    When Others Then
      nSaleId := null;
  End;
  If nSaleId IS Not NULL Then
    Select User_Id
      Into nUserId
      From MKM_MInstallment
      WHere Id=:New.Inst_Id;
    Select Prod_Id
      Into :New.Prod_Id
      From MKM_Prod_Serial
     Where Serial=:New.Serial;
    Select Cat_Id
      Into nCatId
      FROM MKM_Product
     Where Id=:New.Prod_Id;
    Select IPoints
      Into :New.Points
      FROM MKM_Cat
     Where Id=nCatId;
    UPDATE MKM_Member SET Points=NVL(Points,0)+:New.Points
     WHERE User_Id=nUserId;
  Else
    Raise_Application_Error( -20801, 'Unsold Serial Number');
  End If;
Exception
  When Others Then
    NULL;
End MKM_TBI_Inst_Item;
/
Create or Replace Trigger
  MKM_TBD_Inst_Item
  Before Delete
  On MKM_Inst_Items
  For Each Row
Declare
  nUserId  Number;
Begin
  Select User_Id
    Into nUserId
    From MKM_MInstallment
    WHere Id=:Old.Inst_Id;
  UPDATE MKM_Member SET Points=NVL(Points,0)+:Old.Points
   WHERE User_Id=nUserId;
Exception
  When Others Then
    NULL;
End MKM_TBD_Inst_Item;
/

Create or Replace Trigger TBI_MKM_Sale
Before Insert On MKM_Sale
For Each Row
Declare
  nId Number;
Begin
  Begin
    Select Id Into nId From Mng_Cont Where Mobile = :New.Mobile;
  Exception
    When No_Data_Found Then
      Insert Into Mng_Cont (Name, Address, Mobile) 
      Values (:New.Customer, :New.Address, :New.Mobile);
  End;
Exception
  When Others Then
    NULL;
End TBI_MKM_Sale;
/