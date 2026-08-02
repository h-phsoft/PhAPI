CREATE OR REPLACE VIEW PED_Test_Question_View AS
SELECT
       q.Id          AS Question_Id,
       t.Name        AS Test_Name,
       q.QText       AS Question_Text,
       q.IsCatA, q.IsCatB, q.IsCatC, q.IsCatD, q.IsCatE,
       q.IsCatF, q.IsCatG, q.IsCatH, q.IsCatI, q.IsCatJ,
       q.IsCatK, q.IsCatL, q.IsCatM, q.IsCatN,
       q.Rem         AS Question_Remark,
       q.Ins_Date
  FROM PED_Test_Question q
  JOIN PED_Test t ON q.Test_Id = t.Id
/
CREATE SYNONYM PED_VTest_Question FOR PED_Test_Question_View;
/

CREATE OR REPLACE VIEW PED_Test_Categories_View AS
SELECT
       t.Name   AS Test_Name,
       c.Name   AS Category_Name,
       c.Symbol AS Category_Symbol,
       tc.Rem   AS Link_Remark
  FROM PED_Test_Cats tc
  JOIN PED_Test t ON tc.Test_Id = t.Id
  JOIN PED_Cats c ON tc.Cat_Id = c.Id;
/
CREATE SYNONYM PED_VTest_Cats FOR PED_Test_Categories_View;
/

CREATE OR REPLACE VIEW PED_Test_Key_View AS
SELECT
       tk.Id,
       t.Name        AS Test_Name,
       g.Name        AS Gender_Name,
       tk.Age_From,
       tk.Age_To,
       tk.Degree,
       tk.ACat_From, tk.ACat_To,
       tk.BCat_From, tk.BCat_To,
       tk.CCat_From, tk.CCat_To,
       tk.DCat_From, tk.DCat_To,
       tk.ECat_From, tk.ECat_To,
       tk.FCat_From, tk.FCat_To,
       tk.GCat_From, tk.GCat_To,
       tk.HCat_From, tk.HCat_To,
       tk.ICat_From, tk.ICat_To,
       tk.JCat_From, tk.JCat_To,
       tk.KCat_From, tk.KCat_To,
       tk.LCat_From, tk.LCat_To,
       tk.MCat_From, tk.MCat_To,
       tk.NCat_From, tk.NCat_To,
       tk.Rem
  FROM PED_Test_Key tk
  JOIN PED_Test t ON tk.Test_Id = t.Id
  JOIN Phs_Cod_Gender g ON tk.Gender_Id = g.Id;
/
CREATE SYNONYM PED_VTest_Key FOR PED_Test_Key_View;
/

CREATE OR REPLACE VIEW PED_Test__View AS
SELECT
       t.Name        AS Test_Name,
       t.Version,
       COUNT(q.Id)   AS Total_Questions
  FROM PED_Test t
  LEFT JOIN PED_Test_Question q ON t.Id = q.Test_Id
 GROUP BY t.Id, t.Name, t.Version;
/
CREATE SYNONYM PED_VTest FOR PED_Test__View;
/

CREATE OR REPLACE VIEW PED_Categories_View AS
SELECT Id, Name, Symbol, Rem
  FROM PED_Cats;
/
CREATE SYNONYM PED_VCats FOR PED_Categories_View;
/

CREATE OR REPLACE VIEW PED_Test_Question_Summary_View AS
SELECT
       t.Name AS Test_Name,
       SUM(q.IsCatA) AS Count_CatA,
       SUM(q.IsCatB) AS Count_CatB,
       SUM(q.IsCatC) AS Count_CatC,
       SUM(q.IsCatD) AS Count_CatD,
       SUM(q.IsCatE) AS Count_CatE,
       SUM(q.IsCatF) AS Count_CatF,
       SUM(q.IsCatG) AS Count_CatG,
       SUM(q.IsCatH) AS Count_CatH,
       SUM(q.IsCatI) AS Count_CatI,
       SUM(q.IsCatJ) AS Count_CatJ,
       SUM(q.IsCatK) AS Count_CatK,
       SUM(q.IsCatL) AS Count_CatL,
       SUM(q.IsCatM) AS Count_CatM,
       SUM(q.IsCatN) AS Count_CatN,
       COUNT(*) AS Total_Questions
  FROM PED_Test_Question q
  JOIN PED_Test t ON q.Test_Id = t.Id
 GROUP BY t.Id, t.Name;
/
CREATE SYNONYM PED_VTest_Question_Summary FOR PED_Test_Question_Summary_View;
/

