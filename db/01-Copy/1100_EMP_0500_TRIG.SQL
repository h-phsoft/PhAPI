Create OR Replace Trigger
  Emp_TBI_Loan
  Before Insert
  On Emp_Loan
  For Each Row
Declare
Begin
  :New.BAmt := :New.TAmt;
  If :New.MAmt>0 Then
    :New.EDate:= ADD_MONTHS(:New.SDate,:New.TAmt/:New.MAmt);
  End If;
End Emp_TBI_Loan;
/

Create OR Replace Trigger
  Emp_TBU_Loan
  Before Update
  On Emp_Loan
  For Each Row
Declare
Begin
  If :Old.TAmt<>:New.TAmt Then
    :New.BAmt := :New.BAmt + (:New.TAmt-:Old.TAmt);
  End If;
  If :Old.MAmt<>:New.MAmt And :New.MAmt>0 Then
    :New.EDate:= ADD_MONTHS(sysdate,:New.BAmt/:New.MAmt);
  End If;
End Emp_TBU_Loan;
/

Create OR Replace Trigger
  Emp_TBI_PLoan
  Before Insert
  On Emp_PLoan
  For Each Row
Declare
Begin
  Update Emp_Loan Set
         BAmt = NVL(BAmt,0) - NVL(:New.Amt,0)
   Where Id=:New.Loan_Id;
End Emp_TBI_PLoan;
/

Create OR Replace Trigger
  Emp_TBU_PLoan
  Before Update
  On Emp_PLoan
  For Each Row
Declare
Begin
  If :Old.Loan_Id<>:New.Loan_Id Then
    Update Emp_Loan Set
           BAmt = NVL(BAmt,0) + NVL(:Old.Amt,0)
     Where Id=:Old.Loan_Id;
    Update Emp_Loan Set
           BAmt = NVL(BAmt,0) - NVL(:New.Amt,0)
     Where Id=:New.Loan_Id;
  ElsIf :Old.Amt<>:New.Amt Then
    Update Emp_Loan Set
           BAmt = NVL(BAmt,0) + NVL(:Old.Amt,0) - NVL(:New.Amt,0)
     Where Id=:New.Loan_Id;
  End If;
End Emp_TBU_PLoan;
/

Create OR Replace Trigger
  Emp_TBD_PLoan
  Before Delete
  On Emp_PLoan
  For Each Row
Declare
Begin
  Update Emp_Loan Set
         BAmt = NVL(BAmt,0) + NVL(:Old.Amt,0)
   Where Id=:Old.Id;
End Emp_TBD_PLoan;
/

Create OR Replace Trigger
  Emp_TBI_ChGrade
  Before Insert
  On Emp_ChGrade
  For Each Row
Declare
  nODegree   Number;
Begin
  SELECT TGrad_Id INTO nODegree FROM Emp_Emp WHERE Id=:New.Emp_Id;
  :New.TGrad_OId := nODegree;
  UPDATE Emp_Emp Set
         TGrad_Id = :New.TGrad_NId,
         GradDays = :New.Days ,
         GradSDate= :New.SDate,
         GradCons = 0,
         GradPuns = 0
   WHERE Id=:New.Emp_Id;
Exception
  When Others Then
    NULL;
End Emp_TBI_TCGrad;
/

Create OR Replace Trigger
  Emp_TBU_ChGrade
  Before Update
  On Emp_ChGrade
  For Each Row
Declare
  nODegree   Number;
Begin
  IF :New.Emp_Id!=:OLD.Emp_Id Then
    UPDATE Emp_Emp Set
           TGrad_Id = :Old.TGrad_OId
     WHERE Id=:Old.Emp_Id;
  End If;
  SELECT TGrad_Id INTO nODegree FROM Emp_Emp WHERE Id=:New.Emp_Id;
  :New.TGrad_OId := nODegree;
  UPDATE Emp_Emp Set
         TGrad_Id = :New.TGrad_NId,
         GradDays = :New.Days ,
         GradSDate= :New.SDate,
         GradCons = 0,
         GradPuns = 0
   WHERE Id=:New.Emp_Id;
Exception
  When Others Then
    NULL;
End Emp_TBU_TCGrad;
/

Create OR Replace Trigger
  Emp_TBD_ChGrade
  Before Delete
  On Emp_ChGrade
  For Each Row
Declare
Begin
  UPDATE Emp_Emp Set
         TGrad_Id = :Old.TGrad_OId
   WHERE Id=:Old.Emp_Id;
Exception
  When Others Then
    NULL;
End Emp_TBD_TCGrad;
/
