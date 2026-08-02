Create Or Replace View Copy_Department_Unit_View As
 SELECT ALL
        D.Id                  Dept_Id       ,
        D.Status_Id           Dept_Status_Id,
        D.User_Id             Dept_User_Id  ,
        D.Name                Dept_Name     ,
        D.Rem                 Dept_Rem      ,
        U.Id                  Unit_Id       ,
        U.Status_Id           Unit_Status_Id,
        U.User_Id             Unit_User_Id  ,
        U.Name                Unit_Name     ,
        U.Rem                 Unit_Rem      ,
        U.Cost_Id             Unit_Cost_Id  ,
        D.Name||' - '||U.Name Unot_FName
   FROM Cpy_Dept D,
        Cpy_Unit U
  WHERE U.Dept_Id=D.Id;
/
Create Synonym Cpy_VDept_Unit For Copy_Department_Unit_View
/

Create Or Replace View Copy_Department_Unit_Operations_View As
 SELECT ALL
        D.Id                  Dept_Id       ,
        D.Status_Id           Dept_Status_Id,
        D.User_Id             Dept_User_Id  ,
        D.Name                Dept_Name     ,
        D.Rem                 Dept_Rem      ,
        U.Id                  Unit_Id       ,
        U.Status_Id           Unit_Status_Id,
        U.User_Id             Unit_User_Id  ,
        U.Name                Unit_Name     ,
        U.Rem                 Unit_Rem      ,
        U.Cost_Id             Unit_Cost_Id  ,
        D.Name||' - '||U.Name Unit_FName    ,
        O.Id                  Oper_Id       ,
        O.Status_Id           Oper_Status_Id,
        O.Name                Oper_Name     ,
        O.Rem                 Oper_Rem      ,
        D.Name||' - '||U.Name||' - '||O.Name Oper_FName
   FROM Cpy_Dept D,
        Cpy_Unit U,
        Cpy_Oper O
  WHERE U.Dept_Id=D.Id
    AND O.Unit_Id=U.Id
/
Create Synonym Cpy_VDept_Unit_Oper For Copy_Department_Unit_Operations_View
/
