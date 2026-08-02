-- 9001 Management
--DELETE FROM Phs_Dash_Blocks WHERE Menu_Id=9001;
Insert into Phs_Dash_Blocks (ORD , Type_Id, Menu_Id, MCOL, SCOL, METHOD, URL                                     , NAME                            , TITLE                                          , OPTIONS                                                                                    )
values                      (9010, 202    , 9001   , 4   , 3   , 'POST', '/UC/Cpy/UsersView/DashQueryPie'        , 'Users By Permission Groups'    , 'Users By Permission Groups'                   , '{"group":["grpName"],"aggregate":[{"userId":"1"}],"printOptions":{"title":""}}'           );
