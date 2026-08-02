Create OR Replace Function Check_Period( nPeriod Number := 0, dCDate Date := sysdate, dTDate Date := Sysdate ) Return Number IS
Begin
  Return(PhSecur.Check_Period(nPeriod, dCDate, dTDate));
End Check_Period;
/

Create Or Replace Procedure Reset_Seq(vSynonymName in varchar2) is
  nCurVal   Number;
  nMax      Number;
  nNextVal  Number;
Begin
    execute immediate 'select ' || vSynonymName || '_Seq.nextval from dual' INTO nCurVal;
    execute immediate 'select Max(Id) from ' || vSynonymName INTO nMax;
    For I IN nCurVal..nMax Loop
      execute immediate 'select ' || vSynonymName || '_Seq.nextval from dual' INTO nNextVal;
    End Loop;
End;
/
--Set Pagesize 1000;
--SELECT 'Execute Reset_Seq('''||synonym_name||''');' FROM User_Synonyms ORDER BY synonym_name;
/*
Create Or Replace Function Get_Label(vKey Varchar2) Return Varchar2 Is
    vVal Varchar2(256);
Begin
    Select LValue Into vVal
    From Phs_LBL
    Where Lkey = vKey
      And Lang_Id = Sys_Context('PhCtx', 'Lang_Id');
    Return vVal;
Exception
    When No_Data_Found Then 
        Return '[' || vKey || ']';
End;
/
*/