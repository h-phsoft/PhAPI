CREATE OR REPLACE VIEW Stor_Number_Of_OverLimit AS
SELECT Sum(Req_Limit) Req_Limit,
       Sum(Min_Limit) Min_Limit,
       Sum(Max_Limit) Max_Limit
FROM (Select Count(*) as Req_Limit, 0 Min_Limit, 0 Max_Limit
        FROM Stor_Vsmat
       WHERE Over_Req_Limit>0
       UNION ALL
      Select 0, Count(*) as Min_Limit,0
        FROM Stor_Vsmat
       WHERE Over_Min_Limit>0
       UNION ALL
      Select 0, 0, Count(*) as Max_Limit
        FROM Stor_Vsmat
       WHERE Over_Max_Limit>0
     )
/
CREATE SYNONYM Stor_Num_OverLimit FOR Stor_Number_Of_OverLimit
/
