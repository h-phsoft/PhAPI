CREATE OR REPLACE FUNCTION Get_Base_Currency_Id RETURN Number IS
Begin
  Return 2;
END Get_Base_Currency_Id;
/
CREATE OR REPLACE FUNCTION Get_Currency_HRate(dDate Date) RETURN Number IS
  nRate Number := 50;
Begin
  Select Max(Rate)
    Into nRate
    From Mng_CurnHist
    WHERE HDate=(SELECT MAX(HDate) FROM Mng_CurnHist WHERE HDate<=dDate);
  Return nRate;
END Get_Currency_HRate;
/
