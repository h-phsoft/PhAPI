-- Foreign keys for phsoftme_erp_admin, lifted out of their CREATE TABLE.
-- The Oracle scripts are not in dependency order, so declaring these
-- inline made table creation depend on file order. Run this last.
-- 7 constraints.

\connect phsoftme_erp_admin

ALTER TABLE Phs_Front ADD CONSTRAINT    PhsFront_Status_FK Foreign Key (status_Id) References Phs_Status(Id);
ALTER TABLE Phs_Cst ADD CONSTRAINT    PhsCst_Status_FK Foreign Key (status_Id) References Phs_Status(Id);
ALTER TABLE Phs_Cpy ADD CONSTRAINT    PhsCpy_Cst_FK    Foreign Key (Cst_Id   ) References Phs_Cst   (Id);
ALTER TABLE Phs_Cpy ADD CONSTRAINT    PhsCpy_Status_FK Foreign Key (status_Id) References Phs_Status(Id);
ALTER TABLE Phs_CpyFront ADD CONSTRAINT    PhsCpyFront_Cpy_FK    Foreign Key (Cpy_Id   ) References Phs_Cpy   (Id);
ALTER TABLE Phs_CpyFront ADD CONSTRAINT    PhsCpyFront_Front_FK  Foreign Key (Front_Id ) References Phs_Front (Id);
ALTER TABLE Phs_CpyFront ADD CONSTRAINT    PhsCpyFront_Status_FK Foreign Key (status_Id) References Phs_Status(Id);
