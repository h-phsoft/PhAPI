Create or Replace Trigger
  Clnc_TBI_Labor_Receive
  Before Insert
  On Clnc_Labor_Receive
  For Each Row
Declare
Begin
  Select      Clinic_Id,      Doctor_Id,      Patient_Id,      Labor_Id
    Into :New.Clinic_Id, :New.Doctor_Id, :New.Patient_Id, :New.Labor_Id
    From Clnc_Labor_Send
    Where Id=:New.Send_Id;
Exception
  When No_Data_Found Then
    Raise_Application_Error( -20905, 'Undefined Send Transaction' );
End Clnc_TBI_InTrn;
/
