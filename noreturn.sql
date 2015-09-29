ALTER SESSION SET PLSQL_WARNINGS = 'ENABLE:ALL'
/
CREATE OR REPLACE FUNCTION no_return
   RETURN VARCHAR2
AS
BEGIN
   DBMS_OUTPUT.PUT_LINE (
      'Here I am, here I stay');
END no_return;
/

SHOW ERRORS FUNCTION no_return

ALTER PROCEDURE no_return COMPILE PLSQL_WARNINGS = 'ERROR:5005' REUSE SETTINGS
/

ALTER FUNCTION no_return COMPILE;

SHOW ERRORS FUNCTION no_return

CREATE OR REPLACE FUNCTION no_return
   RETURN VARCHAR2
AS
BEGIN
   DBMS_OUTPUT.PUT_LINE (
      'Here I am, here I stay');
END no_return;
/

SHOW ERRORS FUNCTION no_return

CREATE OR REPLACE FUNCTION no_return
   RETURN VARCHAR2
AS
   l_checking BOOLEAN := FALSE;
BEGIN
   IF l_checking
   THEN
      RETURN 'abc';
   ELSE
      DBMS_OUTPUT.put_line ('Here I am, here I stay');
   END IF;
END no_return;
/

SHOW ERRORS FUNCTION no_return