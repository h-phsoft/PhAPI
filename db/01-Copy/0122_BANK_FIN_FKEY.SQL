Alter Table Fin_Invoice_Mst  Add CONSTRAINT Fin_Inv_Bank_FK  Foreign Key (Bank_Id) References Bank_Acc(Id);
Alter Table Fin_Debit_Mst    Add CONSTRAINT Fin_Dbt_Bank_FK  Foreign Key (Bank_Id) References Bank_Acc(Id);
Alter Table Fin_Credit_Mst   Add CONSTRAINT Fin_Crd_Bank_FK  Foreign Key (Bank_Id) References Bank_Acc(Id);
Alter Table Fin_Expense_Mst  Add CONSTRAINT Fin_Exp_Bank_FK  Foreign Key (Bank_Id) References Bank_Acc(Id);
Alter Table Fin_Reconcile    Add CONSTRAINT Fin_Rec_Bank_FK  Foreign Key (Bank_Id) References Bank_Acc(Id);
Alter Table Fin_Allocate_Mst Add CONSTRAINT Fin_Alc_Bank_FK  Foreign Key (Bank_Id) References Bank_Acc(Id);
