-- ---------------------------------------------------------------------------
-- PostgreSQL compatibility prelude. Run this once, before any other script.
-- ---------------------------------------------------------------------------

-- gen_random_uuid() is built in from PostgreSQL 13; pgcrypto provides it before.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Identifiers in these scripts are unquoted mixed case, which PostgreSQL folds
-- to lower case consistently on both definition and reference, so no quoting is
-- applied during translation.

-- Oracle sequences are kept as native PostgreSQL sequences, so the triggers
-- that populate key columns are carried over rather than replaced. Every
-- sequence is normalised to START WITH 1 / INCREMENT BY 1, so any Oracle
-- stepping (PhsId_Seq stepped by 100) is intentionally not reproduced.
--
-- Seed data inserts explicit ids without advancing the sequences. Run
-- 9998_resync_sequences.sql after loading it, or the first generated id will
-- collide with an existing row.

-- Oracle TO_NUMBER(x) takes one argument; PostgreSQL's requires a format model.
CREATE OR REPLACE FUNCTION To_Number_Compat(p_val TEXT)
RETURNS NUMERIC AS $$
  SELECT p_val::NUMERIC;
$$ LANGUAGE sql IMMUTABLE;

-- Password helpers, ported from the PhSecur package.
--
-- Encode_Pass is not a hash: Oracle's
--   UTL_I18N.STRING_TO_RAW('OneGod165' || password, 'AL32UTF8')
-- renders the UTF-8 bytes as upper-case hex, which is trivially reversible.
-- It is reproduced exactly so existing stored values keep matching; replacing
-- it with a real hash is a data migration, not a translation.
CREATE OR REPLACE FUNCTION Encode_Pass(p_password TEXT)
RETURNS TEXT AS $$
  SELECT upper(encode(convert_to('OneGod165' || coalesce(p_password, ''), 'UTF8'), 'hex'));
$$ LANGUAGE sql IMMUTABLE;

CREATE OR REPLACE FUNCTION Compare_Pass(p_old TEXT, p_new TEXT)
RETURNS INTEGER AS $$
  SELECT CASE WHEN Encode_Pass(p_old) = Encode_Pass(p_new) THEN 1 ELSE 0 END;
$$ LANGUAGE sql IMMUTABLE;

-- Returns the user id for a valid logon, or -99 when the credentials do not
-- match, matching what the API's login path expects from the Oracle function.
CREATE OR REPLACE FUNCTION Check_Login(p_logon TEXT, p_pass TEXT)
RETURNS NUMERIC AS $$
  SELECT COALESCE(
    (SELECT u.id
       FROM Cpy_User u
      WHERE lower(u.logon) = lower(p_logon)
        AND u.pass = Encode_Pass(p_pass)
      LIMIT 1),
    -99
  );
$$ LANGUAGE sql STABLE;
