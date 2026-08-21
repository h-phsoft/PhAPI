-- Run this first, as a superuser, against any existing database.
-- CREATE DATABASE cannot run inside a transaction block.

SELECT 'CREATE DATABASE phsoftme_erp_admin ENCODING ''UTF8'' TEMPLATE template0'
  WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'phsoftme_erp_admin')\gexec

SELECT 'CREATE DATABASE phsoftme_erp_demo ENCODING ''UTF8'' TEMPLATE template0'
  WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'phsoftme_erp_demo')\gexec
