Alter profile DEFAULT limit PASSWORD_REUSE_TIME unlimited;
Alter profile DEFAULT limit PASSWORD_LIFE_TIME  unlimited;

Create TableSpace TBS_Phs
       DataFile 'Phs_DB.ora' Size 4096M Reuse
       Autoextend on next 512M;

SELECT 'Create Sequence '||INITCAP(synonym_name)||'_seq MinValue 100 Start With 100 MaxValue '||rpad('9', DATA_PRECISION, '9')||' INCREMENT BY 100 CACHE 2;'
  FROM user_synonyms    s,
       user_tab_columns c
 WHERE s.table_name=c.table_name
   AND c.column_name='ID';

-- Oracle 12C and newest -- 
--alter session set "_ORACLE_SCRIPT"=true;

--DROP User C##erpAdmin CASCADE;
Create User C##erpAdmin Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpAdmin;

--DROP User C##erpDemo CASCADE;
Create User C##erpDemo Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpDemo;
Grant EXECUTE ON PhContext To C##erpDemo;

--DROP User C##erpClinic CASCADE;
Create User C##erpClinic Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpClinic;
Grant EXECUTE ON PhContext To C##erpClinic;

--DROP User C##erpNSCC CASCADE;
Create User C##erpNSCC Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpNSCC;
Grant EXECUTE ON PhContext To C##erpNSCC;

--DROP User C##NSCC CASCADE;
Create User C##NSCC Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##NSCC;
Grant EXECUTE ON PhContext To C##NSCC;

--DROP User C##erpUN CASCADE;
Create User C##erpUN Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpUN;
Grant EXECUTE ON PhContext To C##erpUN;

--DROP User C##UN CASCADE;
Create User C##UN Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##UN;
Grant EXECUTE ON PhContext To C##UN;

--DROP User C##erpEpona CASCADE;
Create User C##erpEpona Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpEpona;
Grant EXECUTE ON PhContext To C##erpEpona;

--DROP User C##erpNIG CASCADE;
Create User C##erpNIG Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpNIG;
Grant EXECUTE ON PhContext To C##erpNIG;

--DROP User C##erpELcom CASCADE;
Create User C##erpELcom Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpELcom;
Grant EXECUTE ON PhContext To C##erpELcom;

--DROP User C##erpFarkad CASCADE;
Create User C##erpFarkad Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpFarkad;
Grant EXECUTE ON PhContext To C##erpFarkad;

--DROP User C##erpHashemia CASCADE;
Create User C##erpHashemia Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpHashemia;
Grant EXECUTE ON PhContext To C##erpHashemia;

--DROP User C##erpLRGC CASCADE;
Create User C##erpLRGC Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpLRGC;
Grant EXECUTE ON PhContext To C##erpLRGC;

--DROP User C##erpiCloud CASCADE;
Create User C##erpiCloud Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpiCloud;
Grant EXECUTE ON PhContext To C##erpiCloud;

--DROP User C##erpOLEK CASCADE;
Create User C##erpOLEK Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpOLEK;
Grant EXECUTE ON PhContext To C##erpOLEK;

--DROP User C##erpTrans CASCADE;
Create User C##erpTrans Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpTrans;
Grant EXECUTE ON PhContext To C##erpTrans;

--DROP User C##erpDEC CASCADE;
Create User C##erpDEC Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpDEC;
Grant EXECUTE ON PhContext To C##erpDEC;

--DROP User C##erpDECB CASCADE;
Create User C##erpDECB Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpDECB;
Grant EXECUTE ON PhContext To C##erpDECB;

--DROP User C##erpAlTaqi CASCADE;
Create User C##erpAlTaqi Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpAlTaqi;
Grant EXECUTE ON PhContext To C##erpAlTaqi;

--DROP User C##erpAlmasa CASCADE;
Create User C##erpAlmasa Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpAlmasa;
Grant EXECUTE ON PhContext To C##erpAlmasa;

--DROP User C##erpSabbagh CASCADE;
Create User C##erpSabbagh Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpSabbagh;
Grant EXECUTE ON PhContext To C##erpSabbagh;

--DROP User C##erpAlmasa CASCADE;
Create User C##erpAlmasa Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpAlmasa;
Grant EXECUTE ON PhContext To C##erpAlmasa;

--DROP User C##erpEdulearn CASCADE;
Create User C##erpEdulearn Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpEdulearn;
Grant EXECUTE ON PhContext To C##erpEdulearn;

--DROP User C##erpMidani CASCADE;
Create User C##erpMidani Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpMidani;
Grant EXECUTE ON PhContext To C##erpMidani;

--DROP User C##erpMKM CASCADE;
Create User C##erpMKM Identified By PhPass Default Tablespace Users;
Grant DBA, Connect, Resource To C##erpMKM;
Grant EXECUTE ON PhContext To C##erpMKM;
------------------------------------------------------------------------------------------------------------------------------------------------------------------
GRANT READ ON DIRECTORY    TO C##erpCopy;
