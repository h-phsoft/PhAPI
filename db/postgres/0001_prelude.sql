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
