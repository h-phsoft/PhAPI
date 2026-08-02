Create OR Replace Procedure Cpy_Refresh_PGrp_Progs( nPGrpId Number, nOK Number := 0 ) IS
  nPermId      Number;
Begin
  For I IN ( Select Id
              From Phs_MPrg
              Where Menu_Id IN (Select Menu_Id From Phs_Menu Where Status_Id=1   )
                And Id  NOT IN (Select MPrg_Id From Cpy_Perm Where PGrp_Id=nPGrpId)
              Order By MPrg_Id, Menu_Id, Ord
            ) Loop
    Select Cpy_Perm_Seq.NextVal Into nPermId From Dual;
    Insert Into Cpy_Perm
          ( Id     , PGrp_Id, MPrg_Id, Ok  )
    Values( nPermId, nPGrpId, I.Id   , nOk );
    For J IN (Select Prv_Id
                From Phs_MPrgPriv
                Where MPrg_Id=I.Id
              ) Loop
      Insert Into Cpy_PermPriv
            ( Id                      , Perm_Id, Prv_Id  , Ok  )
      Values( Cpy_PermPriv_Seq.nextval, nPermId, J.Prv_Id, nOK );
    End Loop;
    For J IN (Select SPrv_Id
                From Phs_MPrgSPriv
                Where MPrg_Id=I.Id
              ) Loop
      Insert Into Cpy_PermSPriv
            ( Id                       , Perm_Id, SPrv_Id  , SList_Id, Status_Id )
      Values( Cpy_PermSPriv_Seq.nextval, nPermId, J.SPrv_Id, 0       , nOK       );
    End Loop;
  End Loop;
End Cpy_Refresh_PGrp_Progs;
/

Create OR Replace Procedure Cpy_Refresh_PGrp_Privs( nPGrpId Number, nOK Number := 0 ) IS
Begin
  For I IN (Select Id, MPrg_Id
              From Cpy_Perm
              Where PGrp_Id=nPGrpId
            ) Loop
    For J IN (Select Prv_Id
                From Phs_MPrgPriv
                Where MPrg_Id=I.MPrg_Id
                  And Prv_Id NOT IN (Select Prv_Id
                                      From Cpy_PermPriv
                                      Where Perm_Id=I.Id
                                    )
              ) Loop
      Insert Into Cpy_PermPriv
            ( Id                      , Perm_Id, Prv_Id  , OK  )
      Values( Cpy_PermPriv_Seq.nextval, I.Id   , J.Prv_Id, nOK );
    End Loop;
  End Loop;
End Cpy_Refresh_PGrp_Privs;
/

Create OR Replace Procedure Cpy_Refresh_PGrp_SPrivs( nPGrpId Number, nOK Number := 2 ) IS

Begin
  For I IN (Select Id, MPrg_Id
              From Cpy_Perm
              Where PGrp_Id=nPGrpId
            ) Loop
    For J IN (Select SPrv_Id
                From Phs_MPrgSPriv
                Where MPrg_Id=I.MPrg_Id
                  And SPrv_Id NOT IN (Select SPrv_Id
                                        From Cpy_PermSPriv
                                        Where Perm_Id=I.Id
                                      )
              ) Loop
      Insert Into Cpy_PermSPriv
            ( Id                       , Perm_Id, SPrv_Id  , SList_Id, Status_Id )
      Values( Cpy_PermSPriv_Seq.nextval, I.Id   , J.SPrv_Id, 0       , nOK       );
    End Loop;
  End Loop;
End Cpy_Refresh_PGrp_SPrivs;
/

Create OR Replace Procedure Cpy_Refresh_PGrp( nPGrpId Number, nOK Number := 0 ) IS
Begin
  Cpy_Refresh_PGrp_Progs(nPGrpId, nOk);
  Cpy_Refresh_PGrp_Privs(nPGrpId, nOk);
  Cpy_Refresh_PGrp_SPrivs(nPGrpId, nOk);
End Cpy_Refresh_PGrp;
/

Create OR Replace Procedure Cpy_Refresh_PGrps( nOK Number := 0 ) IS
Begin
  For I IN ( Select Id
              From Cpy_PGrp
            ) Loop
    Cpy_Refresh_PGrp(I.Id, nOk);
  End Loop;
End Cpy_Refresh_PGrps;
/
