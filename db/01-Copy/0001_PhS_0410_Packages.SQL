Create OR Replace Package PhU AS

  Function Tafqeet( nNum Number, vIntegerCurrency Varchar2 := 'ليرة سورية', vDecimalCurrency Varchar2 := 'قرش' ) Return Varchar2;
  Function TafqeetE( nNum Number, vIntegerCurrency Varchar2 := 'Syrian Pound(s)', vDecimalCurrency Varchar2 := 'Cent(s)' ) Return Varchar2;

End PhU;
/
Create or Replace Package Body PhU AS

  Function Digits3_Word( nNum Number ) Return Varchar2 IS
    vReturn     Varchar2(500) := NULL;
    Digit3      Number := 0;
    i1          Number := 0;
    j1          Number := 0;
    k1          Number := 0;
    nInNum      Number := 0;
    vTemp       Varchar2(50) := NULL;
    Type Digit1Array is table of Varchar2(50);
    Type Digit2Array is table of Varchar2(50);
    Type Digit3Array is table of Varchar2(50);
    --
    Digit1Str Digit1Array := Digit1Array('واحد',
                                'إثنان',
                                'ثلاثة',
                                'أربعة',
                                'خمسة',
                                'ستة',
                                'سبعة',
                                'ثمانية',
                                'تسعة',
                                'عشرة',
                                'إحدى عشرة',
                                'إثنا عشر',
                                'ثلاثة عشر',
                                'أربعة عشر',
                                'خمسة عشر',
                                'ستة عشر',
                                'سبعة عشر',
                                'ثمانية عشر',
                                'تسعة عشر'
                               ); 
    Digit2Str Digit2Array := Digit2Array('',
                                'عشرون',
                                'ثلاثون',
                                'أربعون',
                                'خمسون',
                                'ستون',
                                'سبعون',
                                'ثمانون',
                                'تسعون'
                               );
    Digit3Str Digit3Array := Digit3Array('مائة',
                                'مائتان',
                                'ثلاث مائة',
                                'أربع مائة',
                                'خمس مائة',
                                'ست مائة',
                                'سبع مائة',
                                'ثمان مائة',
                                'تسعة مائة'
                               );
  Begin
    nInNum := nNum;
    If nInNum>999 Then
      nInNum := 0;
    End If;
    vTemp  := LPAD( To_Char( nInNum ), 3, 0 );
    Digit3 := To_Number( SubStr( vTemp, 1, 1 ) );
    If Digit3>0 Then
      vReturn := Digit3Str( Digit3 );
    End If;
    i1 := To_Number( SubStr( vTemp, 2, 2 ) );
    j1 := To_Number( SubStr( vTemp, 2, 1 ) );
    k1 := To_Number( SubStr( vTemp, 3, 1 ) );
    If Digit3>0 AND (j1>0 OR k1>0) Then
      vReturn := vReturn||' و';
    End If;
    If i1>0 and i1<20 Then
      vReturn := vReturn||Digit1Str(i1);
    End If;
    If j1>=2 Then
      If k1>0 Then
        vReturn := vReturn||Digit1Str(k1)||' و';
      End If;
      vReturn := vReturn||Digit2Str(j1);
    End If;
    If nInNum=0 Then
      vReturn := 'صفر';
    End If;
    Return vReturn;
  End Digits3_Word;
  --
  Function Tafqeet( nNum Number, vIntegerCurrency Varchar2 := 'ليرة سورية', vDecimalCurrency Varchar2 := 'قرش' ) Return Varchar2 IS
    vReturn   Varchar2(1000);
    nInNum    Number := 0;
    nInteger  Number := 0;
    nDecimal  Number := 0;
    vChar     Varchar2(100);
    vTemp     Number := 0;
    Type    NamesArray is table of Varchar2(500);
    NameStr NamesArray := NamesArray ( '',
                                      'ألف',
                                      'مليون',
                                      'مليار',
                                      'تريليون',
                                      'فريليون',
                                      'سرسليون',
                                      'تسرسليون',
                                      'فيمتون'
                                    );
  Begin
    nInNum   := ABS( nNum );
    nInteger := Trunc( nInNum );
    nDecimal := nInNum - nInteger;
    If nDecimal>0 Then
      nDecimal := nDecimal * 100;
      nDecimal := To_Number( SubStr( To_Char( nDecimal ), 1, 2 ) );
    End If;
    vChar := To_Char( nInteger );
    For I in 1..NameStr.Count Loop
      If vChar is NULL Then
        Exit;
      End If;
      vTemp := To_Number( SubStr( vChar, (Length( vChar )-2), 3) );
      If vTemp>0 Then
        vReturn := Digits3_Word( vTemp )||' '||NameStr( I )||' و'||vReturn;
      End If;
      vChar := SubStr( vChar, 1, ( Length( vChar )-3 ) );
    End Loop;
    vReturn := SubStr( vReturn, 1, ( Length( vReturn )-1 ) );
    vReturn := LTrim(RTrim(vReturn));
    If nNum>=1000 and nNum<2000 Then
      vReturn := SubStr( vReturn, 5, Length( vReturn ) );
    End If;
    If nNum>=2000 and nNum<3000 Then
      vReturn := 'ألفان '||SubStr( vReturn, 11, Length( vReturn ) );
    End If;
    If nNum>=3000 and nNum<=10000 Then
      vReturn := SubStr( vReturn,1,(INSTR( vReturn, 'ألاف')-1) )||
                  'ألاف'||
                 SubStr( vReturn, (INSTR( vReturn, 'ألاف')+3), Length( vReturn ) );
    End If;
    vReturn := LTrim(RTrim(vReturn));
    If nDecimal>0 Then
      vReturn := vReturn||' '||vIntegerCurrency||' و'||Digits3_Word( nDecimal )||' '||vDecimalCurrency;
    Else
      vReturn := vReturn||' '||vIntegerCurrency;
    End If;
    If nInteger>0 OR nDecimal>0 Then
      vReturn := vReturn;
    ElsIf nInteger=0 Then
      vReturn := '===';
    End If;
    Return (' فقط '||LTrim(RTrim(vReturn)));
  End Tafqeet;
  --
  Function Digits3_WordE( nNum Number ) Return Varchar2 IS
    vReturn     Varchar2(500) := NULL;
    Digit3      Number := 0;
    i1          Number := 0;
    j1          Number := 0;
    k1          Number := 0;
    nInNum      Number := 0;
    vTemp       Varchar2(50) := NULL;
    Type Digit1Array is table of Varchar2(50);
    Type Digit2Array is table of Varchar2(50);
    Type Digit3Array is table of Varchar2(50);
    --
    Digit1Str Digit1Array := Digit1Array('One',
                                'Two',
                                'Three',
                                'Four',
                                'Five',
                                'Six',
                                'Seven',
                                'Eight',
                                'Nine',
                                'Ten',
                                'Eleven',
                                'Twelve',
                                'Thirteen',
                                'Fourteen',
                                'Fifteen',
                                'Sixteen',
                                'Seventeen',
                                'Eighteen',
                                'Nineteen'
                               );
    Digit2Str Digit2Array := Digit2Array('One',
                                'Twenty',
                                'Thirty',
                                'Forty',
                                'Fifty',
                                'Sixty',
                                'Seventy',
                                'Eighty',
                                'Ninety'
                               );
    Digit3Str Digit3Array := Digit3Array('one Hundred',
                                'Two Hundred',
                                'Three Hundred',
                                'Four Hundred',
                                'Five Hundred',
                                'Six Hundred',
                                'Seven Hundred',
                                'Eight Hundred',
                                'Nine Hundred'
                               );
  Begin
    nInNum := nNum;
    If nInNum>999 Then
      nInNum := 0;
    End If;
    vTemp  := LPAD( To_Char( nInNum ), 3, 0 );
    Digit3 := To_Number( SubStr( vTemp, 1, 1 ) );
    If Digit3>0 Then
      vReturn := Digit3Str( Digit3 );
    End If;
    i1 := To_Number( SubStr( vTemp, 2, 2 ) );
    j1 := To_Number( SubStr( vTemp, 2, 1 ) );
    k1 := To_Number( SubStr( vTemp, 3, 1 ) );
    If Digit3>0 AND (j1>0 OR k1>0) Then
      vReturn := vReturn||',';
    End If;
    If i1>0 and i1<20 Then
      vReturn := vReturn||Digit1Str(i1);
    End If;
    If j1>=2 Then
      vReturn := vReturn||Digit2Str(j1);
      If k1>0 Then
        vReturn := vReturn||' '||Digit1Str(k1);
      End If;
    End If;
    If nInNum=0 Then
      vReturn := 'Zero';
    End If;
    Return vReturn;
  End Digits3_WordE;
  --
  Function TafqeetE( nNum Number, vIntegerCurrency Varchar2 := 'Syrian Pound(s)', vDecimalCurrency Varchar2 := 'Cent(s)' ) Return Varchar2 IS
    vReturn   Varchar2(1000);
    nInNum    Number := 0;
    nInteger  Number := 0;
    nDecimal  Number := 0;
    vChar     Varchar2(100);
    vTemp     Number := 0;
    Type    NamesArray is table of Varchar2(500);
    NameStr NamesArray := NamesArray ( '',
                                      'Thousand',
                                      'Million',
                                      'Billion',
                                      'Trillion',
                                      'Frillion',
                                      'Sirsillion',
                                      'Tirsillion',
                                      'Fimton'
                                    );
  Begin
    nInNum   := ABS( nNum );
    nInteger := Trunc( nInNum );
    nDecimal := nInNum - nInteger;
    If nDecimal>0 Then
      nDecimal := nDecimal * 100;
      nDecimal := To_Number( SubStr( To_Char( nDecimal ), 1, 2 ) );
    End If;
    vChar := To_Char( nInteger );
    For I in 1..NameStr.Count Loop
      If vChar is NULL Then
        Exit;
      End If;
      vTemp := To_Number( SubStr( vChar, (Length( vChar )-2), 3) );
      If vTemp>0 Then
        vReturn := Digits3_WordE( vTemp )||' '||NameStr( I )||','||vReturn;
      End If;
      vChar := SubStr( vChar, 1, ( Length( vChar )-3 ) );
    End Loop;
    vReturn := SubStr( vReturn, 1, ( Length( vReturn )-1 ) );
    vReturn := LTrim(RTrim(vReturn));
    If nNum>=1000 and nNum<=10000 Then
      vReturn := SubStr( vReturn,1,(INSTR( vReturn, 'Thousand')-1) )||'Thousand'||
                 SubStr( vReturn, (INSTR( vReturn, 'Thousand')+8), Length( vReturn ) );
    End If;
    vReturn := LTrim(RTrim(vReturn));
    If nDecimal>0 Then
      vReturn := vReturn||' '||vIntegerCurrency||' and '||Digits3_WordE( nDecimal )||' '||vDecimalCurrency;
    Else
      vReturn := vReturn||' '||vIntegerCurrency;
    End If;
    If nInteger>0 OR nDecimal>0 Then
      vReturn := vReturn;
    ElsIf nInteger=0 Then
      vReturn := '===';
    End If;
    Return (' only '||LTrim(RTrim(vReturn)));
  End TafqeetE;
  --

End PhU;
/

Create OR Replace Function PhTafqeet( nAmt Number ) Return Varchar2 IS
Begin
  Return(PhU.Tafqeet(nAmt));
End PhTafqeet;
/

Create OR Replace Function PhTafqeetE( nAmt Number, vName Varchar2, vCents Varchar2 ) Return Varchar2 IS
Begin
  Return(PhU.TafqeetE(nAmt,vName,vCents));
End PhTafqeetE;
/
