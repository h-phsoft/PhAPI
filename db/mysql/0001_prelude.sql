-- ---------------------------------------------------------------------------
-- MySQL compatibility prelude. Run this once, before any other script.
-- ---------------------------------------------------------------------------

-- Oracle's || is concatenation; MySQL treats it as logical OR unless told
-- otherwise. Every session running these scripts needs this mode.
SET SESSION sql_mode = CONCAT(@@sql_mode, ',PIPES_AS_CONCAT');

-- Oracle sequences are not carried over: key columns are AUTO_INCREMENT
-- instead, and the triggers that existed only to call a sequence are dropped.
-- Seed data inserts explicit ids, which AUTO_INCREMENT accepts and which raise
-- the counter automatically, so no resynchronisation step is needed.

DELIMITER $$

-- Oracle TO_NUMBER(x) takes a single argument; MySQL has no direct equivalent.
DROP FUNCTION IF EXISTS Cast_To_Number $$
CREATE FUNCTION Cast_To_Number(p_val TEXT)
RETURNS DECIMAL(38,10)
DETERMINISTIC
BEGIN
  RETURN CAST(p_val AS DECIMAL(38,10));
END $$

DELIMITER ;
