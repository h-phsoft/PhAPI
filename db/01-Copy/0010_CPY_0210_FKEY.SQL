Alter Table Copy_Code_Unit Add
( CONSTRAINT Cpy_Cod_Unit_Ins_FK Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Cpy_Cod_Unit_Upd_FK Foreign Key (Upd_User) References Cpy_User    (Id)
)
/

Alter Table Copy_Code_Document Add
( CONSTRAINT Cpy_Cod_Doc_Ins_FK Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Cpy_Cod_Doc_Upd_FK Foreign Key (Upd_User) References Cpy_User    (Id)
)
/

Alter Table Copy_Code_PeriodStatus Add
( CONSTRAINT Cpy_Cod_PStatus_Ins_FK Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT Cpy_Cod_PStatus_Upd_FK Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
