Create Sequence Phs_LogId_Seq      MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Phs_Logs       				                  -- سجل العمليات
( Id          Number(20) NOT NULL,			              -- مفتاح رئيسي
  vType       Varchar2(50 Char),			                -- النوع
  vText       Varchar2(1024 Char),				            -- النص
  vUser       Varchar2(100 Char),				              -- المستخدم
  vIP         Varchar2(20 Char),				              -- العنوان
  vHost       Varchar2(64 Char),				              -- الموقع
  vPort       Varchar2(6 Char),				                -- البوابة
  vRem        Varchar2(250 Char),			                -- ملاحظات
  dDate       Date Default sysdate,                   -- التاريخ والوقت
  CONSTRAINT PhsLog_PK     PRIMARY KEY (Id)
)
/
Create Synonym Phs_Log For Phs_Logs
/
Create or Replace Trigger
  TBID_Phs_Log
  Before Insert
  On Phs_Log
  For Each Row
Declare
Begin
  If :New.Id IS NULL Then
    Select Phs_LogId_Seq.NextVal
      Into :New.Id
      From Dual;
  End If;
End TBID_Phs_Log;
/

Create OR Replace Procedure Phs_AddLog (
  vText Varchar2,
  vType Varchar2 := 'INFO',
  vUser Varchar2 := '',
  vIP   Varchar2 := '',
  vHost Varchar2 := '',
  vPort Varchar2 := '',
  vRem  Varchar2 := '') IS
Begin
  INSERT INTO Phs_Log
        (Id                   , vType, vText, vUser, vIP, vHost, vPort, vRem)
  VALUES(Phs_LogId_Seq.NextVal, vType, vText, vUser, vIP, vHost, vPort, vRem);
End Phs_AddLog;
/
---------------------------------------------------------------------------------------------------
Create Sequence Phs_Audit_Seq MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Phs_Audits       				                -- سجل العمليات
( Id          Number(20) NOT NULL,			              -- مفتاح رئيسي
  nType       Number(1) Default 1,			              -- النوع 1=إضافة, 2=تعديل, 3=حذف
  vTable      Varchar2(50 Char),				              -- الجدول
  User_Id     Number(5) Default 0,                    -- المستخدم
  dDate       Date Default sysdate,                   -- التاريخ والوقت
  vNew        Varchar2(4000 Char),				            -- القيم الجديدة
  vOld        Varchar2(4000 Char),				            -- القيم القديمة
  CONSTRAINT PhsAudit_PK PRIMARY KEY (Id)
)
/
Create Synonym Phs_Audit For Phs_Audits
/
---------------------------------------------------------------------------------------------------
Create Sequence Phs_Log_Exc_Seq      MinValue 100 Start With 100 MaxValue 99999999999999999999 INCREMENT BY 100 CACHE 2;
Create Table Phs_Log_Exceptions			                  -- سجل العمليات
( Id          Number(20) NOT NULL,			              -- مفتاح رئيسي
  Type_Id     Number(20),                             -- نوع الخطأ
  vMEssage    Varchar2(1024 Char),				            -- النص
  vFunction   Varchar2(128 Char),				              -- الإجراء
  vCode       Varchar2(100 Char),				              -- الرمز
  dDate       Date Default sysdate,                   -- التاريخ والوقت
  CONSTRAINT Phs_Log_Exc_PK PRIMARY KEY (Id)
)
/
Create Synonym Phs_Log_Exc For Phs_Log_Exceptions
/
