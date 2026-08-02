Create OR Replace Function
  Check_DayEntOut_Errors( DayId Number, nErrors IN OUT Number ) Return Number IS
    nErr     Number := 0;
    nCnt     Number := 0;
    dDate    Date;
Begin
  Select Day_Date
    Into dDate
    From Emp_Day
    Where Day_Id=DayId;
  Select Count(*)
    Into nCnt
    From (Select Emp_Id From Emp_VDayEnt Where Day_Id=DayId
          Minus
          Select Emp_Id From Emp_VDayOut Where Day_Id=DayId
         );
  If NVL(nCnt,0)=0 Then
    Select Count(*)
      Into nCnt
      From (Select Emp_Id From Emp_VDayOut Where Day_Id=DayId
            Minus
            Select Emp_Id From Emp_VDayEnt Where Day_Id=DayId
            );
    If NVL(nCnt,0)=0 Then
      Select Count(*)
        Into nCnt
        From (Select Emp_Id, Count(*)
                From Emp_VDEO
                Where Day_Id=DayId
                Having Mod(Count(*),2)<>0
                Group By Emp_Id
              );
      If NVL(nCnt,0)=0 Then
        Select Count(*)
          Into nCnt
          From (Select Emp_Id, Sum(nEnt), Sum(nOut)
                  From (Select Emp_Id, Count(*) nEnt, 0 nOut From Emp_VDayEnt Where Day_Id=DayId Group By Emp_Id
                        UNION ALL
                        Select Emp_Id, 0 nEnt, Count(*) nOut From Emp_VDayOut Where Day_Id=DayId Group By Emp_Id
                       )
                 Having Sum(nEnt)<>Sum(nOut)
                  Group By Emp_Id
               );
        If NVL(nCnt,0)=0 Then
          Select Count(*)
            Into nCnt
            From Emp_VDayEnt
            Where Day_Id=DayId
              And Emp_Id IN (Select Emp_Id From Emp_Vac Where dDate Between Vac_SDate And Vac_EDate);
          If NVL(nCnt,0)=0 Then
            Select Count(*)
              Into nCnt
              From Emp_VDayOut
              Where Day_Id=DayId
                And Emp_Id IN (Select Emp_Id From Emp_Vac Where dDate Between Vac_SDate And Vac_EDate);
            If NVL(nCnt,0)=0 Then
              nErrors := 0;
            Else
              nErrors := nCnt;
              nErr    := 6;
            End If;
          Else
            nErrors := nCnt;
            nErr    := 5;
          End If;
        Else
          nErrors := nCnt;
          nErr    := 4;
        End If;
      Else
        nErrors := nCnt;
        nErr    := 3;
      End If;
    Else
      nErrors := nCnt;
      nErr    := 2;
    End If;
  Else
    nErrors := nCnt;
    nErr    := 1;
  End If;
  Return(nErr);
End Check_DayEntOut_Errors;
/

Create OR Replace Trigger
  Emp_Before_Ins_Att
  Before Insert
  On Emp_Att
  For Each Row
Declare
Begin
  If :New.Att_Id IS NULL Then
    Select EmpId_Seq.nextval Into :New.Att_Id From Dual;
  End If;
End Emp_Before_Ins_Att;
/

Create OR Replace Trigger
  Emp_Before_Ins_Day
  Before Insert
  On Emp_Day
  For Each Row
Declare
Begin
  If :New.Day_Id IS NULL Then
    :New.Day_Id := To_Char(Sysdate,'YYYYDDD');
  End If;
End Emp_Before_Ins_Day;
/

Create OR Replace Trigger
  Emp_Before_Ins_Ent
  Before Insert
  On Emp_Ent
  For Each Row
Declare
Begin
  If :New.Ent_Id IS NULL Then
    Select EmpId_Seq.nextval into :New.Ent_Id From Dual;
  End If;
End Emp_Before_Ins_Ent;
/

Create OR Replace Trigger
  Emp_Before_Ins_Out
  Before Insert
  On Emp_Out
  For Each Row
Declare
Begin
  If :New.Out_Id IS NULL Then
    Select EmpId_Seq.nextval into :New.Out_Id From Dual;
  End If;
End Emp_Before_Ins_Out;
/

Create OR Replace Trigger
  Emp_Before_Ins_FingerPrint
  Before Insert
  On Emp_FngrPrnt
  For Each Row
Declare
Begin
  If :New.Fngr_Id IS NULL Then
    Select EmpId_Seq.NextVal Into :New.Fngr_Id From Dual;
  End If;
  :New.Fngr_Date   := To_Date(SubStr(:New.Fngr_Time,1,10),'YYYY-MM-DD');
  :New.Fngr_Hour   := SubStr(:New.Fngr_Time,12,2);
  :New.Fngr_Minute := SubStr(:New.Fngr_Time,15,2);
End Emp_Before_Ins_FngrPrnt;
/

Create OR Replace Trigger
  Emp_Before_Ins_Acr
  Before Insert
  On Emp_Acr
  For Each Row
Declare
Begin
  If :New.Acr_Id IS NULL Then
    :New.Acr_Id := :New.Acr_Num;
  End If;
End Emp_Before_Ins_Acr;
/

Create OR Replace Trigger
  Emp_Before_Ins_WrkGrp
  Before Insert
  On Emp_WrkGrp
  For Each Row
Declare
Begin
  :New.WGrp_Id := :New.WGrp_Num;
End Emp_Before_Ins_WrkGrp;
/

Create OR Replace Trigger
  Emp_Before_Ins_Emp
  Before Insert
  On Emp_Emp
  For Each Row
Declare
Begin
  :New.Emp_Id := :New.Emp_Num;
End Emp_Before_Ins_Emp;
/

Create OR Replace Trigger
  Emp_Before_Ins_Loan
  Before Insert
  On Emp_Loan
  For Each Row
Declare
Begin
  :New.Loan_BAmt := :New.Loan_TAmt;
  :New.Loan_EDate:= ADD_MONTHS(:New.Loan_SDate,:New.Loan_TAmt/:New.Loan_MAmt);
End Emp_Before_Ins_Loan;
/

Create OR Replace Trigger
  Emp_Before_Upd_Loan
  Before Update
  On Emp_Loan
  For Each Row
Declare
Begin
  If :Old.Loan_TAmt<>:New.Loan_TAmt Then
    :New.Loan_BAmt := :New.Loan_BAmt + (:New.Loan_TAmt-:Old.Loan_TAmt);
  End If;
  If :Old.Loan_MAmt<>:New.Loan_MAmt Then
    :New.Loan_EDate:= ADD_MONTHS(sysdate,:New.Loan_BAmt/:New.Loan_MAmt);
  End If;
End Emp_Before_Upd_Loan;
/

Create OR Replace Trigger
  Emp_Before_Ins_PLoan
  Before Insert
  On Emp_PLoan
  For Each Row
Declare
Begin
  Update Emp_Loan Set
         Loan_BAmt = NVL(Loan_BAmt,0) - NVL(:New.PLoan_Amt,0)
   Where Loan_Id=:New.Loan_Id;
End Emp_Before_Ins_PLoan;
/

Create OR Replace Trigger
  Emp_Before_Upd_PLoan
  Before Update
  On Emp_PLoan
  For Each Row
Declare
Begin
  If :Old.Loan_Id<>:New.Loan_Id Then
    Update Emp_Loan Set
           Loan_BAmt = NVL(Loan_BAmt,0) + NVL(:Old.PLoan_Amt,0)
     Where Loan_Id=:Old.Loan_Id;
    Update Emp_Loan Set
           Loan_BAmt = NVL(Loan_BAmt,0) - NVL(:New.PLoan_Amt,0)
     Where Loan_Id=:New.Loan_Id;
  ElsIf :Old.PLoan_Amt<>:New.PLoan_Amt Then
    Update Emp_Loan Set
           Loan_BAmt = NVL(Loan_BAmt,0) + NVL(:Old.PLoan_Amt,0) - NVL(:New.PLoan_Amt,0)
     Where Loan_Id=:New.Loan_Id;
  End If;
End Emp_Before_Upd_PLoan;
/

Create OR Replace Trigger
  Emp_Before_Del_PLoan
  Before Delete
  On Emp_PLoan
  For Each Row
Declare
Begin
  Update Emp_Loan Set
         Loan_BAmt = NVL(Loan_BAmt,0) + NVL(:Old.PLoan_Amt,0)
   Where Loan_Id=:Old.Loan_Id;
End Emp_Before_Del_PLoan;
/

Create OR Replace Trigger
  Emp_Before_Ins_TCGrad
  Before Insert
  On Emp_TCGrad
  For Each Row
Declare
  nODegree   Number;
Begin
  SELECT TGrad_Id INTO nODegree FROM Emp_Emp WHERE Emp_Id=:New.Emp_Id;
  :New.TGrad_OId := nODegree;
  UPDATE Emp_Emp Set
         TGrad_Id     = :New.TGrad_NId  ,
         Emp_GradDays = :New.TGrad_Days ,
         Emp_GradSDate= :New.TGrad_SDate,
         Emp_GradCons = 0,
         Emp_GradPuns = 0
   WHERE Emp_Id=:New.Emp_Id;
Exception
  When Others Then
    NULL;
End Emp_Before_Ins_TCGrad;
/

Create OR Replace Trigger
  Emp_Before_Upd_TCGrad
  Before Update
  On Emp_TCGrad
  For Each Row
Declare
  nODegree   Number;
Begin
  IF :New.Emp_Id!=:OLD.Emp_Id Then
    UPDATE Emp_Emp Set
           TGrad_Id = :Old.TGrad_OId
     WHERE Emp_Id=:Old.Emp_Id;
  End If;
  SELECT TGrad_Id INTO nODegree FROM Emp_Emp WHERE Emp_Id=:New.Emp_Id;
  :New.TGrad_OId := nODegree;
  UPDATE Emp_Emp Set
         TGrad_Id     = :New.TGrad_NId  ,
         Emp_GradDays = :New.TGrad_Days ,
         Emp_GradSDate= :New.TGrad_SDate,
         Emp_GradCons = 0,
         Emp_GradPuns = 0
   WHERE Emp_Id=:New.Emp_Id;
Exception
  When Others Then
    NULL;
End Emp_Before_Upd_TCGrad;
/

Create OR Replace Trigger
  Emp_Before_Del_TCGrad
  Before Delete
  On Emp_TCGrad
  For Each Row
Declare
Begin
  UPDATE Emp_Emp Set
         TGrad_Id = :Old.TGrad_OId
   WHERE Emp_Id=:Old.Emp_Id;
Exception
  When Others Then
    NULL;
End Emp_Before_Del_TCGrad;
/
