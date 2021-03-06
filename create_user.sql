SPOOL demo.log

CONNECT Sys/quest AS SYSDBA

DECLARE
   user_does_not_exist exception;
   PRAGMA EXCEPTION_INIT (user_does_not_exist, -01918);

   PROCEDURE create_user (user_in IN VARCHAR2)
   IS
   BEGIN
      BEGIN
         EXECUTE IMMEDIATE 'drop user ' || user_in || ' cascade';
      EXCEPTION
         WHEN user_does_not_exist
         THEN
            NULL;
      END;

      /* Grant required privileges...*/
      EXECUTE IMMEDIATE   'grant Create Session, Resource to '
                       || user_in
                       || ' identified by '
                       || user_in;

      DBMS_OUTPUT.put_line ('User "' || user_in || '" was created.');
   END create_user;
BEGIN
   create_user ('Usr');
   
   /* Any additional grants.... */

   EXECUTE IMMEDIATE 'grant Select on sys.v_$sesstat to Usr';

   EXECUTE IMMEDIATE 'grant Select on sys.v_$statname to Usr';

   EXECUTE IMMEDIATE 'grant Select on sys.v_$session to Usr';
END;
/