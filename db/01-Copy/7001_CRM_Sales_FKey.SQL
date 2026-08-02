Alter Table Sal_Sales_Mst  Add CONSTRAINT Sal_MSal_Repr_FK Foreign Key (Repr_Id) References CRM_Repr(Id);
Alter Table Sal_Return_Mst Add CONSTRAINT Sal_MRet_Repr_FK Foreign Key (Repr_Id) References CRM_Repr(Id);
