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

-- Password helpers, ported from the PhSecur package.
--
-- Encode_Pass is not a hash: Oracle's
--   UTL_I18N.STRING_TO_RAW('OneGod165' || password, 'AL32UTF8')
-- renders the UTF-8 bytes as upper-case hex, which is trivially reversible.
-- Reproduced exactly so existing stored values keep matching; replacing it with
-- a real hash is a data migration, not a translation.
--
-- These must exist before the seed data runs: the Cpy_User inserts call
-- Encode_Pass, and without it every user row is silently skipped.
DROP FUNCTION IF EXISTS Encode_Pass $$
CREATE FUNCTION Encode_Pass(p_password TEXT)
RETURNS VARCHAR(512)
DETERMINISTIC
BEGIN
  RETURN UPPER(HEX(CONVERT(CONCAT('OneGod165', IFNULL(p_password, '')) USING utf8mb4)));
END $$

DROP FUNCTION IF EXISTS Compare_Pass $$
CREATE FUNCTION Compare_Pass(p_old TEXT, p_new TEXT)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN IF(Encode_Pass(p_old) = Encode_Pass(p_new), 1, 0);
END $$

-- Returns the user id for a valid logon, or -99 when the credentials do not
-- match, matching what the API's login path expects from the Oracle function.
DROP FUNCTION IF EXISTS Check_Login $$
CREATE FUNCTION Check_Login(p_logon TEXT, p_pass TEXT)
RETURNS DECIMAL(20,0)
READS SQL DATA
BEGIN
  DECLARE v_id DECIMAL(20,0);
  SELECT u.Id INTO v_id
    FROM Cpy_User u
   WHERE LOWER(u.Logon) = LOWER(p_logon)
     AND u.Pass = Encode_Pass(p_pass)
   LIMIT 1;
  RETURN IFNULL(v_id, -99);
END $$

DELIMITER ;
