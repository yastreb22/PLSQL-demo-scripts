DECLARE
--
-- Simple unit test framework for COUNT_BETWEEN
-- Generated by Qnxo on July 30, 2005 16:4:6
--
-- Top level block; global variable to determine if this test
-- succeeded for failed.
   g_success            BOOLEAN            DEFAULT TRUE;
   g_collection         DBMS_SQL.varchar2s;
   g_empty_collection   DBMS_SQL.varchar2s;

   PROCEDURE initialize
   IS
   BEGIN
      g_collection (1) := 1;
      g_collection (10) := 1;
      g_collection (11) := 1;
      g_collection (100) := 1;
      g_collection (101) := 1;
      g_collection (1000) := 1;
   END initialize;

   -- General reporting utility
   PROCEDURE report_failure (
      description_in   IN       VARCHAR2
   )
   IS
   BEGIN
      g_success := FALSE;
      DBMS_OUTPUT.put_line ('   Failure on test "' || description_in || '"'
                           );
   END report_failure;

-- For each program, generate a local module to test that program.
-- These are then each called in the executable section of the main block.
   PROCEDURE t_count_between
   IS
      -- Variable for function return value
      l_count_between   BINARY_INTEGER;

      PROCEDURE tc_all_rows
      IS
         l_testname   VARCHAR2 (32767) := 'All rows - start and end null';
      BEGIN
         l_count_between :=
            count_between (collection_in       => g_collection
                          ,start_index_in      => NULL
                          ,end_index_in        => NULL
                          ,inclusive_in        => TRUE
                          );

         IF l_count_between != g_collection.COUNT
         THEN
            report_failure (l_testname);
         END IF;
      END tc_all_rows;

      PROCEDURE tc_start_then_inside_inc
      IS
         l_testname   VARCHAR2 (32767)
                          := 'From start to inner existing row, inclusive';
      BEGIN
         l_count_between :=
            count_between (collection_in       => g_collection
                          ,start_index_in      => g_collection.FIRST
                          ,end_index_in        => 100
                          ,inclusive_in        => TRUE
                          );

         IF l_count_between != 4
         THEN
            report_failure (l_testname);
         END IF;
      END tc_start_then_inside_inc;

      PROCEDURE tc_start_then_inside_exc
      IS
         l_testname   VARCHAR2 (32767)
                          := 'From start to inner existing row, exclusive';
      BEGIN
         l_count_between :=
            count_between (collection_in       => g_collection
                          ,start_index_in      => g_collection.FIRST
                          ,end_index_in        => 100
                          ,inclusive_in        => FALSE
                          );

         IF l_count_between != 2
         THEN
            report_failure (l_testname);
         END IF;
      END tc_start_then_inside_exc;

      PROCEDURE tc_inside_then_end_inc
      IS
         l_testname   VARCHAR2 (32767)
                            := 'From inner existing row to end, inclusive';
      BEGIN
         l_count_between :=
            count_between (collection_in       => g_collection
                          ,start_index_in      => 100
                          ,end_index_in        => g_collection.LAST
                          ,inclusive_in        => TRUE
                          );

         IF l_count_between != 3
         THEN
            report_failure (l_testname);
         END IF;
      END tc_inside_then_end_inc;

      PROCEDURE tc_inside_then_end_exc
      IS
         l_testname   VARCHAR2 (32767)
                            := 'From inner existing row to end, exclusive';
      BEGIN
         l_count_between :=
            count_between (collection_in       => g_collection
                          ,start_index_in      => 100
                          ,end_index_in        => g_collection.LAST
                          ,inclusive_in        => FALSE
                          );

         IF l_count_between != 1
         THEN
            report_failure (l_testname);
         END IF;
      END tc_inside_then_end_exc;

      PROCEDURE tc_all_inside_inc
      IS
         l_testname   VARCHAR2 (32767)
                    := 'Inner start and end, non existing rows, inclusive';
      BEGIN
         l_count_between :=
            count_between (collection_in       => g_collection
                          ,start_index_in      => 10
                          ,end_index_in        => 100
                          ,inclusive_in        => TRUE
                          );

         IF l_count_between != 3
         THEN
            report_failure (l_testname);
         END IF;
      END tc_all_inside_inc;

      PROCEDURE tc_all_inside_exc
      IS
         l_testname   VARCHAR2 (32767)
                    := 'Inner start and end, non existing rows, exclusive';
      BEGIN
         l_count_between :=
            count_between (collection_in       => g_collection
                          ,start_index_in      => 10
                          ,end_index_in        => 100
                          ,inclusive_in        => FALSE
                          );

         IF l_count_between != 1
         THEN
            report_failure (l_testname);
         END IF;
      END tc_all_inside_exc;

      PROCEDURE tc_all_inside_nonex_inc
      IS
         l_testname   VARCHAR2 (32767)
                    := 'Inner start and end, non existing rows, inclusive';
      BEGIN
         l_count_between :=
            count_between (collection_in       => g_collection
                          ,start_index_in      => 2
                          ,end_index_in        => 102
                          ,inclusive_in        => TRUE
                          );

         IF l_count_between != 4
         THEN
            report_failure (l_testname);
         END IF;
      END tc_all_inside_nonex_inc;

      PROCEDURE tc_all_inside_nonex_exc
      IS
         l_testname   VARCHAR2 (32767)
                    := 'Inner start and end, non existing rows, exclusive';
      BEGIN
         l_count_between :=
            count_between (collection_in       => g_collection
                          ,start_index_in      => 2
                          ,end_index_in        => 102
                          ,inclusive_in        => FALSE
                          );

         IF l_count_between != 4
         THEN
            report_failure (l_testname);
         END IF;
      END tc_all_inside_nonex_exc;
      PROCEDURE tc_end_before_start
      IS
         l_testname   VARCHAR2 (32767)
                    := 'End index is smaller than the start index';
      BEGIN
         l_count_between :=
            count_between (collection_in       => g_collection
                          ,start_index_in      => 102
                          ,end_index_in        => 2
                          ,inclusive_in        => FALSE
                          );

         IF l_count_between != 0
         THEN
            report_failure (l_testname);
         END IF;
      END tc_end_before_start;

      PROCEDURE tc_count_empty_collection
      IS
         l_testname   VARCHAR2 (32767) := 'Empty collection';
      BEGIN
         l_count_between :=
                       count_between (collection_in      => g_empty_collection);

         IF l_count_between != 0
         THEN
            report_failure (l_testname);
         END IF;
      END tc_count_empty_collection;
   BEGIN
      DBMS_OUTPUT.put_line ('Testing COUNT_BETWEEN');
      tc_all_rows;
      tc_start_then_inside_inc;
      tc_start_then_inside_exc;
      tc_inside_then_end_inc;
      tc_inside_then_end_exc;
      tc_all_inside_inc;
      tc_all_inside_exc;
      tc_all_inside_nonex_inc;
      tc_all_inside_nonex_exc;
	  tc_end_before_start;
      tc_count_empty_collection;

      DBMS_OUTPUT.put_line ('');
   END t_count_between;
BEGIN
   initialize;
   t_count_between;

   IF g_success
   THEN
      DBMS_OUTPUT.put_line
                         ('Overall test status for COUNT_BETWEEN: SUCCESS');
   ELSE
      DBMS_OUTPUT.put_line
                         ('Overall test status for COUNT_BETWEEN: FAILURE');
   END IF;
END;
/
