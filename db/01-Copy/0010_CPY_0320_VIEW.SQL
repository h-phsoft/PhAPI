Create Or Replace View Copy_Periods_View As
Select ALL
       W.Id        Period_Id   , W.Num       Period_Num ,
       W.Name      Period_Name , W.Rem       Period_Rem ,
       C.Id        Status_Id   , C.Name      Status_Name,
       W.SDate     Period_SDate, W.EDate     Period_EDate,
       W.Ins_User, W.Ins_Date  , W.Upd_User, W.Upd_Date
  From Cpy_Period      W,
       Cpy_Cod_PStatus C
 Where W.Status_Id=C.Id
/
Create Synonym Cpy_VPeriod For Copy_Periods_View
/

Create Or Replace View Copy_Branche_View As
Select ALL
       B.Id     Bran_Id  , B.Num    Bran_Num   , B.Name Bran_Name,
       B.Id     Status_Id, ST.Name  Status_Name, B.Rem  Bran_Rem ,
       B.Day1 ,
       B.Day2 ,
       B.Day3 ,
       B.Day4 ,
       B.Day5 ,
       B.Day6 ,
       B.Day7 ,
       Curn_Id,
       Cost_Id,
       Ins_User   , Ins_Date, Upd_User   , Upd_Date
  From Cpy_Bran       B ,
       Phs_Cod_Status ST
  Where B.Status_Id=ST.Id
/
Create Synonym Cpy_VMBran For Copy_Branche_View
/
