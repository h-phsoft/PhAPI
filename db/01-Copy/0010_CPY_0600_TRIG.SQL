CREATE OR REPLACE TRIGGER
  Cpy_TBI_Period
  BEFORE INSERT
  ON Cpy_Period
  FOR EACH ROW
DECLARE
BEGIN
  :New.Id  := To_Number(To_Char(:New.SDate,'YYYY'));
  :New.Num := To_Number(To_Char(:New.SDate,'YYYY'));
END Cpy_TBI_Period;
/
