
Alter Table Copy_SpecialLists Add
( CONSTRAINT CpySList_SPrv_Ins_FK Foreign Key (Ins_User) References Cpy_User    (Id),
  CONSTRAINT CpySList_SPrv_Upd_FK Foreign Key (Upd_User) References Cpy_User    (Id)
)
/
Alter Table Copy_SpecialListsTrn Add
( CONSTRAINT CpyTList_SList_Ins_FK Foreign Key (Ins_User) References Cpy_User (Id),
  CONSTRAINT CpyTList_SList_Upd_FK Foreign Key (Upd_User) References Cpy_User (Id)
)
/
Alter Table Copy_Permission_Groups Add
( CONSTRAINT  CpyPGrp_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT  CpyPGrp_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/

Alter Table Copy_Permision Add
( CONSTRAINT CpyPerm_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT CpyPerm_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/

Alter Table Copy_Permision_Privileges Add
( CONSTRAINT CpyPPrv_Ins_FK  Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT CpyPPrv_Upd_FK  Foreign Key (Upd_User) References Cpy_User(Id)
)
/

Alter Table Copy_Permision_SpecPrivileges Add
( CONSTRAINT CpyPSPrv_Ins_FK    Foreign Key (Ins_User ) References Cpy_User     (Id),
  CONSTRAINT CpyPSPrv_Upd_FK    Foreign Key (Upd_User ) References Cpy_User     (Id)
)
/

Alter Table Copy_Users Add
( CONSTRAINT CpyUser_Ins_FK    Foreign Key (Ins_User ) References Cpy_User      (Id),
  CONSTRAINT CpyUser_Upd_FK    Foreign Key (Upd_User ) References Cpy_User      (Id)
)
/

Alter Table Copy_SpecPermission Add
( CONSTRAINT CpySpecPerm_Ins_FK   Foreign Key (Ins_User) References Cpy_User(Id),
  CONSTRAINT CpySpecPerm_Upd_FK   Foreign Key (Upd_User) References Cpy_User(Id)
)
/
