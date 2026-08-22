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

-- Oracle TO_CHAR(number, '0000') zero-pads to the width of the format model.
-- The triggers use it to build composite keys, so the padding must be exact.
DROP FUNCTION IF EXISTS To_Char $$
CREATE FUNCTION To_Char(p_val DECIMAL(38,10), p_fmt VARCHAR(64))
RETURNS VARCHAR(128)
DETERMINISTIC
BEGIN
  IF p_fmt IS NULL THEN
    RETURN CAST(p_val AS CHAR);
  END IF;
  -- A model of all zeros/nines is a fixed-width numeric pad.
  IF p_fmt REGEXP '^[09]+$' THEN
    RETURN LPAD(CAST(FLOOR(p_val) AS CHAR), CHAR_LENGTH(p_fmt), '0');
  END IF;
  RETURN CAST(p_val AS CHAR);
END $$

DELIMITER ;
