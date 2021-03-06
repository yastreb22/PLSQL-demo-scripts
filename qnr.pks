CREATE OR REPLACE PACKAGE qnr AUTHID CURRENT_USER
IS
   -- Provide named constants for the type numbers I now know about
   c_table_type       CONSTANT PLS_INTEGER := 2;
   c_view_type        CONSTANT PLS_INTEGER := 4;
   c_synonym_type     CONSTANT PLS_INTEGER := 5;
   c_procedure_type   CONSTANT PLS_INTEGER := 7;
   c_function_type    CONSTANT PLS_INTEGER := 8;
   c_package_type     CONSTANT PLS_INTEGER := 9;
   c_object_type      CONSTANT PLS_INTEGER := 13;

   -- Provide a record type to make it easier to call the program.
   -- Should probably overload NAME_RESOLVE with a record!
   TYPE name_resolve_rt IS RECORD (
      SCHEMA          VARCHAR2 (100)
     ,part1           VARCHAR2 (100)
     ,part2           VARCHAR2 (100)
     ,dblink          VARCHAR2 (100)
     ,part1_type      NUMBER
     ,object_number   NUMBER
   );

   PROCEDURE name_resolve (
      NAME            IN       VARCHAR2
     ,SCHEMA          OUT      VARCHAR2
     ,part1           OUT      VARCHAR2
     ,part2           OUT      VARCHAR2
     ,dblink          OUT      VARCHAR2
     ,part1_type      OUT      NUMBER
     ,object_number   OUT      NUMBER
   );

   FUNCTION name_resolve (NAME IN VARCHAR2)
      RETURN name_resolve_rt;

   PROCEDURE show (NAME_IN IN VARCHAR2);

   PROCEDURE show_synonym (owner_in IN VARCHAR2, NAME_IN IN VARCHAR2);

   PROCEDURE synonym_resolve (
      NAME_IN           IN       VARCHAR2
     ,schema_out        OUT      VARCHAR2
     ,object_name_out   OUT      VARCHAR2
   );

   FUNCTION name_for_type (type_in IN PLS_INTEGER)
      RETURN VARCHAR2;
END qnr;
/