CREATE TYPE info_ot AS OBJECT (
   info         VARCHAR2 (100)
  ,entered_on   DATE
);
/

CREATE TYPE notes_nt AS TABLE OF info_ot;
/

CREATE TYPE account_ot AS OBJECT (
   NAME    VARCHAR2 (100)
  ,notes   notes_nt
);
/

CREATE TYPE caseload_nt AS TABLE OF account_ot;
/

DECLARE
   -- Instantiate an object initialized with info = "Steven".
   my_info1           info_ot     := info_ot ('Buy item #1288', SYSDATE);
   -- Instantiate an object initialized with info = "Bryn".
   my_info2           info_ot   := info_ot ('Sell item #764', SYSDATE - 5);
   -- Instantiate an nested table initialized with the two objects defined above.
   my_weekend_notes   notes_nt    := notes_nt (my_info1, my_info2);
   -- Initialize my nested table of nested tables, but leave it empty.
   my_caseload        caseload_nt := caseload_nt ();
BEGIN
   -- Place the nested table containing two objects into the first index of
   -- the multi-level collection.
   my_caseload.EXTEND;
   my_caseload (1) := account_ot ('Acme Inc.', my_weekend_notes);
   /*
      Now use dot notation twice to "drill down" to the info attribute of the
      two objects found within the notes collection.
   */
   DBMS_OUTPUT.put_line (my_caseload (1).notes (1).info);
   DBMS_OUTPUT.put_line (my_caseload (1).notes (2).info);
   /*
      Now let's get rid of all that hard-coding.
      Suppose that I wanted to see the info value for the first and last
      rows defined in the notes attribute of the first row of my_caseload.
   */
   DBMS_OUTPUT.put_line
      (my_caseload (my_caseload.FIRST).notes
                                (my_caseload (my_caseload.FIRST).notes.FIRST
                                ).info
      );
   DBMS_OUTPUT.put_line
      (my_caseload (my_caseload.FIRST).notes
                                 (my_caseload (my_caseload.FIRST).notes.LAST
                                 ).info
      );
END;
/

CREATE OR REPLACE PACKAGE caseload_pkg
IS
   FUNCTION first_account (caseload_in IN caseload_nt)
      RETURN account_ot;
END caseload_pkg;
/

CREATE OR REPLACE PACKAGE BODY caseload_pkg
IS
   FUNCTION first_account (caseload_in IN caseload_nt)
      RETURN account_ot
   IS
   BEGIN
      RETURN caseload_in (caseload_in.FIRST);
   END first_account;
END caseload_pkg;
/