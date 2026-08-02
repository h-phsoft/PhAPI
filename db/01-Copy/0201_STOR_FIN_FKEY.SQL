Alter Table Fin_Invoice_Trn  Add CONSTRAINT Fin_TInv_Item_FK  Foreign Key (Item_Id) References Stor_Item(Id);
Alter Table Fin_Debit_Trn    Add CONSTRAINT Fin_TDbt_Item_FK  Foreign Key (Item_Id) References Stor_Item(Id);
Alter Table Fin_Credit_Trn   Add CONSTRAINT Fin_TCrd_Item_FK  Foreign Key (Item_Id) References Stor_Item(Id);
Alter Table Fin_Expense_Trn  Add CONSTRAINT Fin_TExp_Item_FK  Foreign Key (Item_Id) References Stor_Item(Id);
