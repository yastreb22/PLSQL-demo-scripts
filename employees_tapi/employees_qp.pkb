CREATE OR REPLACE PACKAGE BODY EMPLOYEES_QP
/*
| Generated by or retrieved from QCGU - DO NOT MODIFY!
| QCGU - "Get it right, do it fast" - www.ToadWorld.com
| QCGU Universal ID: {CE63F2F4-B478-47A2-B142-B1C577AF0C40}
| Created On: October 14, 2011 6:44:28
| Created By: QCGU
*/
IS
   FUNCTION onerow (
      employee_id_in IN EMPLOYEES_TP.EMPLOYEE_ID_t
      )
   RETURN EMPLOYEES_TP.EMPLOYEES_rt
   IS
      onerow_rec EMPLOYEES_TP.EMPLOYEES_rt;
   BEGIN
      SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
        INTO onerow_rec
        FROM EMPLOYEES
       WHERE
             EMPLOYEE_ID = employee_id_in
      ;
      RETURN onerow_rec;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
      WHEN TOO_MANY_ROWS
      THEN
         DECLARE
            l_err_instance_id PLS_INTEGER;
         BEGIN
            q$error_manager.register_error ('MULTIPLE-UNIQUE-ROWS'
               ,err_instance_id_out => l_err_instance_id);
            q$error_manager.add_context (
               err_instance_id_in => l_err_instance_id
              ,NAME_IN => 'TABLE'
              ,value_in => 'EMPLOYEES'
              ,validate_in => FALSE
              );
            q$error_manager.add_context (
               err_instance_id_in => l_err_instance_id
              ,NAME_IN => 'EMPLOYEE_ID'
              ,value_in => 'employee_id_in'
              ,validate_in => FALSE
              );
            q$error_manager.raise_error_instance (
              err_instance_id_in => l_err_instance_id);
         END;
   END onerow;

   FUNCTION row_exists (
      employee_id_in IN EMPLOYEES_TP.EMPLOYEE_ID_t
      )
   RETURN BOOLEAN
   IS
      l_dummy PLS_INTEGER;
   BEGIN
      SELECT 1 INTO l_dummy
        FROM EMPLOYEES
       WHERE
             EMPLOYEE_ID = employee_id_in
      ;
      RETURN TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN RETURN FALSE;
      WHEN TOO_MANY_ROWS THEN RETURN TRUE;
   END row_exists;

   FUNCTION onerow_cv (
      employee_id_in IN EMPLOYEES_TP.EMPLOYEE_ID_t
      )
   RETURN EMPLOYEES_TP.EMPLOYEES_rc
   IS
      retval EMPLOYEES_TP.EMPLOYEES_rc;
   BEGIN
      OPEN retval FOR
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
        FROM EMPLOYEES
       WHERE
             EMPLOYEE_ID = employee_id_in
      ;
      RETURN retval;
   END onerow_cv;

   FUNCTION allrows RETURN EMPLOYEES_TP.EMPLOYEES_tc
   IS
      CURSOR allrows_cur
      IS
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES

           ;
      retval EMPLOYEES_TP.EMPLOYEES_tc;
   BEGIN
      OPEN allrows_cur;
      FETCH allrows_cur BULK COLLECT INTO retval;
      RETURN retval;
   END allrows;

   FUNCTION allrows_cv RETURN EMPLOYEES_TP.EMPLOYEES_rc
   IS
      retval EMPLOYEES_TP.EMPLOYEES_rc;
   BEGIN
      OPEN retval FOR
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES

           ;
      RETURN retval;
   END allrows_cv;

   FUNCTION allrows_by_cv (where_clause_in IN VARCHAR2
      , column_list_in IN VARCHAR2 DEFAULT NULL) RETURN EMPLOYEES_TP.weak_refcur
   IS
      retval EMPLOYEES_TP.weak_refcur;
   BEGIN
      IF where_clause_in IS NULL AND column_list_in IS NULL
      THEN
         retval := allrows_cv;
      ELSIF column_list_in IS NULL
      THEN
         OPEN retval FOR
            'SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES WHERE ' || where_clause_in
             || ' ' || ''
           ;
      ELSE
         OPEN retval FOR
            'SELECT ' || column_list_in ||
             ' FROM EMPLOYEES WHERE ' || where_clause_in
             || ' ' || ''
           ;
      END IF;
      RETURN retval;
   END allrows_by_cv;

   -- Close the specified cursor variable, only if it is open.
   PROCEDURE close_cursor (cursor_variable_in IN EMPLOYEES_TP.EMPLOYEES_rc)
   IS
   BEGIN
      IF cursor_variable_in%ISOPEN
      THEN
         CLOSE cursor_variable_in;
      END IF;
   END close_cursor;

   -- Hide calls to cursor attributes behind interface.
   FUNCTION cursor_is_open (cursor_variable_in IN EMPLOYEES_TP.weak_refcur) RETURN BOOLEAN
   IS
   BEGIN
      RETURN cursor_variable_in%ISOPEN;
   EXCEPTION WHEN OTHERS THEN RETURN FALSE;
   END cursor_is_open;

   FUNCTION row_found (cursor_variable_in IN EMPLOYEES_TP.weak_refcur) RETURN BOOLEAN
   IS
   BEGIN
      RETURN cursor_variable_in%FOUND;
   EXCEPTION WHEN OTHERS THEN RETURN NULL;
   END row_found;

   FUNCTION row_notfound (cursor_variable_in IN EMPLOYEES_TP.weak_refcur) RETURN BOOLEAN
   IS
   BEGIN
      RETURN cursor_variable_in%NOTFOUND;
   EXCEPTION WHEN OTHERS THEN RETURN NULL;
   END row_notfound;

   FUNCTION cursor_rowcount (cursor_variable_in IN EMPLOYEES_TP.weak_refcur) RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN cursor_variable_in%ROWCOUNT;
   EXCEPTION WHEN OTHERS THEN RETURN 0;
   END cursor_rowcount;

   -- Use the LIMIT clause to BULK COLLECT N rows through the cursor variable
   -- The current contents of the collection will be deleted.

   FUNCTION fetch_rows (
      cursor_variable_in IN EMPLOYEES_TP.EMPLOYEES_rc
    , limit_in IN PLS_INTEGER DEFAULT 100
    )
      RETURN EMPLOYEES_TP.EMPLOYEES_tc
   IS
      retval EMPLOYEES_TP.EMPLOYEES_tc;
   BEGIN
      FETCH cursor_variable_in BULK COLLECT INTO
         retval LIMIT limit_in;
      RETURN retval;
   END fetch_rows;

    -- Allrows for specified where clause (using dynamic SQL)
   FUNCTION allrows_by (where_clause_in IN VARCHAR2)
      RETURN EMPLOYEES_TP.EMPLOYEES_tc
   IS
      retval EMPLOYEES_TP.EMPLOYEES_tc;
   BEGIN
      EXECUTE IMMEDIATE
         'SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES WHERE ' || where_clause_in
         BULK COLLECT INTO retval;
      RETURN retval;
   END allrows_by;


   -- Return collection of all rows for primary key column EMPLOYEE_ID
   FUNCTION for_employee_id (
      employee_id_in IN EMPLOYEES_TP.EMPLOYEE_ID_t
      )
      RETURN EMPLOYEES_TP.EMPLOYEES_tc
   IS
      CURSOR allrows_cur
      IS
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
          WHERE EMPLOYEE_ID = for_employee_id.employee_id_in

          ;
      retval EMPLOYEES_TP.EMPLOYEES_tc;
   BEGIN
      OPEN allrows_cur;
      FETCH allrows_cur BULK COLLECT INTO retval;
      RETURN retval;
   END for_employee_id;

   -- Return ref cursor to all rows for primary key column EMPLOYEE_ID
   FUNCTION for_employee_id_cv (
      employee_id_in IN EMPLOYEES_TP.EMPLOYEE_ID_t
      )
      RETURN EMPLOYEES_TP.EMPLOYEES_rc
   IS
      retval EMPLOYEES_TP.EMPLOYEES_rc;
   BEGIN
      OPEN retval FOR
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
          WHERE EMPLOYEE_ID = employee_id_in

             ;
      RETURN retval;
   END for_employee_id_cv;

   FUNCTION in_employee_id_cv (
      list_in IN VARCHAR2
      )
      RETURN EMPLOYEES_TP.weak_refcur
   IS
      l_in_clause VARCHAR2(32767) := NVL (list_in, '1 <> 1');
      retval EMPLOYEES_TP.weak_refcur;
   BEGIN
      OPEN retval FOR
         'SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
          WHERE EMPLOYEE_ID IN (' || l_in_clause || ')
             '
             ;
      RETURN retval;
   EXCEPTION
      WHEN OTHERS
      THEN
         q$error_manager.raise_error ('UNANTICIPATED-ERROR',
         name1_in => 'CONTEXT',
         value1_in => 'Dynamic IN clause query',
         name2_in => 'TABLE_NAME',
         value2_in => 'EMPLOYEES',
         name3_in => 'LIST_STRING',
         value3_in => list_in);
   END in_employee_id_cv;

   FUNCTION or_emp_email_uk (
      email_in IN EMPLOYEES_TP.EMAIL_t
      )
      RETURN EMPLOYEES_TP.EMPLOYEES_rt
   IS
      retval EMPLOYEES_TP.EMPLOYEES_rt;
   BEGIN
      SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
        INTO retval
        FROM EMPLOYEES
       WHERE
            EMAIL = email_in
      ;
      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
      WHEN TOO_MANY_ROWS
      THEN
         DECLARE
            l_err_instance_id PLS_INTEGER;
         BEGIN
            q$error_manager.register_error ('MULTIPLE-UNIQUE-ROWS'
               ,err_instance_id_out => l_err_instance_id);
            q$error_manager.add_context (
               err_instance_id_in => l_err_instance_id
              ,NAME_IN => 'TABLE'
              ,value_in => 'EMPLOYEES'
              ,validate_in => FALSE
              );
            q$error_manager.add_context (
               err_instance_id_in => l_err_instance_id
              ,NAME_IN => 'EMAIL'
              ,value_in => 'email_in'
              ,validate_in => FALSE
              );
            q$error_manager.raise_error_instance (
              err_instance_id_in => l_err_instance_id);
         END;
   END or_emp_email_uk;

   FUNCTION or_emp_email_uk_cv (
      email_in IN EMPLOYEES_TP.EMAIL_t
      )
      RETURN EMPLOYEES_TP.EMPLOYEES_rc
   IS
      retval EMPLOYEES_TP.EMPLOYEES_rc;
   BEGIN
      OPEN retval FOR
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
          WHERE
            EMAIL = email_in
             ;
      RETURN retval;
   END or_emp_email_uk_cv;

   FUNCTION pky_emp_email_uk (
      email_in IN EMPLOYEES_TP.EMAIL_t
      )
      RETURN EMPLOYEES_TP.employee_id_t
   IS
      retval EMPLOYEES_TP.employee_id_t;
   BEGIN
      SELECT EMPLOYEE_ID
        INTO retval
        FROM EMPLOYEES
       WHERE
            EMAIL = email_in
      ;
      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
      WHEN TOO_MANY_ROWS
      THEN
         DECLARE
            l_err_instance_id PLS_INTEGER;
         BEGIN
            q$error_manager.register_error ('MULTIPLE-UNIQUE-ROWS'
               ,err_instance_id_out => l_err_instance_id);
            q$error_manager.add_context (
               err_instance_id_in => l_err_instance_id
              ,NAME_IN => 'TABLE'
              ,value_in => 'EMPLOYEES'
              ,validate_in => FALSE
              );
            q$error_manager.add_context (
               err_instance_id_in => l_err_instance_id
              ,NAME_IN => 'EMAIL'
              ,value_in => 'email_in'
              ,validate_in => FALSE
              );
            q$error_manager.raise_error_instance (
              err_instance_id_in => l_err_instance_id);
         END;
   END pky_emp_email_uk;

   -- Number of rows by EMP_EMAIL_UK
   FUNCTION num_emp_email_uk (
      email_in IN EMPLOYEES_TP.EMAIL_t
      )
      RETURN PLS_INTEGER
   IS
      retval PLS_INTEGER;
   BEGIN
      SELECT COUNT(*)
        INTO retval
        FROM EMPLOYEES
       WHERE
            EMAIL = email_in
      ;
      RETURN retval;
   END num_emp_email_uk;

   FUNCTION ex_emp_email_uk (
      email_in IN EMPLOYEES_TP.EMAIL_t
      )
      RETURN BOOLEAN
   IS
      l_dummy PLS_INTEGER;
   BEGIN
      SELECT 1 INTO l_dummy
        FROM EMPLOYEES
       WHERE
             EMAIL = email_in
      ;
      RETURN TRUE;
   EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;
             WHEN TOO_MANY_ROWS THEN RETURN TRUE;
   END ex_emp_email_uk;


   FUNCTION ar_emp_dept_fk_cv (
      department_id_in IN EMPLOYEES_TP.DEPARTMENT_ID_t
      )
      RETURN EMPLOYEES_TP.EMPLOYEES_rc
   IS
      retval EMPLOYEES_TP.EMPLOYEES_rc;
   BEGIN
      OPEN retval FOR
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
       WHERE
          DEPARTMENT_ID = ar_emp_dept_fk_cv.department_id_in

         ;
      RETURN retval;
   END ar_emp_dept_fk_cv;

   FUNCTION in_emp_dept_fk_cv (
      department_id_in IN VARCHAR2
      )
      RETURN EMPLOYEES_TP.weak_refcur
   IS
      retval EMPLOYEES_TP.weak_refcur;
   BEGIN
      OPEN retval FOR
         'SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
       WHERE
          DEPARTMENT_ID IN (' || department_id_in || ')
             '
         ;
      RETURN retval;
   EXCEPTION
      WHEN OTHERS
      THEN
         q$error_manager.raise_error ('UNANTICIPATED-ERROR',
         name1_in => 'CONTEXT',
         value1_in => 'Dynamic IN clause query',
         name2_in => 'TABLE_NAME',
         value2_in => 'EMPLOYEES',
         name3_in => 'LIST_STRING',
         value3_in => NULL);
   END in_emp_dept_fk_cv;

   FUNCTION ar_emp_dept_fk (
      department_id_in IN EMPLOYEES_TP.DEPARTMENT_ID_t
      )
      RETURN EMPLOYEES_TP.EMPLOYEES_tc
   IS
      CURSOR allrows_cur
      IS
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
          WHERE
             DEPARTMENT_ID = ar_emp_dept_fk.department_id_in

         ;
      retval EMPLOYEES_TP.EMPLOYEES_tc;
   BEGIN
      OPEN allrows_cur;
      FETCH allrows_cur BULK COLLECT INTO retval;
      RETURN retval;
   END ar_emp_dept_fk;

   PROCEDURE ar_emp_dept_fk (
      department_id_in IN EMPLOYEES_TP.DEPARTMENT_ID_t,
      employee_id_out OUT EMPLOYEES_TP.EMPLOYEE_ID_cc,
      first_name_out OUT EMPLOYEES_TP.FIRST_NAME_cc,
      last_name_out OUT EMPLOYEES_TP.LAST_NAME_cc,
      email_out OUT EMPLOYEES_TP.EMAIL_cc,
      phone_number_out OUT EMPLOYEES_TP.PHONE_NUMBER_cc,
      hire_date_out OUT EMPLOYEES_TP.HIRE_DATE_cc,
      job_id_out OUT EMPLOYEES_TP.JOB_ID_cc,
      salary_out OUT EMPLOYEES_TP.SALARY_cc,
      commission_pct_out OUT EMPLOYEES_TP.COMMISSION_PCT_cc,
      manager_id_out OUT EMPLOYEES_TP.MANAGER_ID_cc,
      department_id_out OUT EMPLOYEES_TP.DEPARTMENT_ID_cc
      )
   IS
   BEGIN
      SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
        BULK COLLECT INTO
            employee_id_out,
            first_name_out,
            last_name_out,
            email_out,
            phone_number_out,
            hire_date_out,
            job_id_out,
            salary_out,
            commission_pct_out,
            manager_id_out,
            department_id_out
        FROM EMPLOYEES
       WHERE
             DEPARTMENT_ID = ar_emp_dept_fk.department_id_in

      ;
   END ar_emp_dept_fk;

   -- Number of rows by EMP_DEPT_FK
   FUNCTION num_emp_dept_fk (
      department_id_in IN EMPLOYEES_TP.DEPARTMENT_ID_t
      )
      RETURN PLS_INTEGER
   IS
      retval PLS_INTEGER;
   BEGIN
      SELECT COUNT(*)
        INTO retval
        FROM EMPLOYEES
       WHERE
             DEPARTMENT_ID = department_id_in
      ;
      RETURN retval;
   END num_emp_dept_fk;

   FUNCTION ex_emp_dept_fk (
      department_id_in IN EMPLOYEES_TP.DEPARTMENT_ID_t
      )
      RETURN BOOLEAN
   IS
      l_dummy PLS_INTEGER;
   BEGIN
      SELECT 1 INTO l_dummy
        FROM EMPLOYEES
       WHERE
             DEPARTMENT_ID = department_id_in
      ;
      RETURN TRUE;
   EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;
             WHEN TOO_MANY_ROWS THEN RETURN TRUE;
   END ex_emp_dept_fk;


   FUNCTION ar_emp_job_fk_cv (
      job_id_in IN EMPLOYEES_TP.JOB_ID_t
      )
      RETURN EMPLOYEES_TP.EMPLOYEES_rc
   IS
      retval EMPLOYEES_TP.EMPLOYEES_rc;
   BEGIN
      OPEN retval FOR
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
       WHERE
          JOB_ID = ar_emp_job_fk_cv.job_id_in

         ;
      RETURN retval;
   END ar_emp_job_fk_cv;

   FUNCTION in_emp_job_fk_cv (
      job_id_in IN VARCHAR2
      )
      RETURN EMPLOYEES_TP.weak_refcur
   IS
      retval EMPLOYEES_TP.weak_refcur;
   BEGIN
      OPEN retval FOR
         'SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
       WHERE
          JOB_ID IN (' || job_id_in || ')
             '
         ;
      RETURN retval;
   EXCEPTION
      WHEN OTHERS
      THEN
         q$error_manager.raise_error ('UNANTICIPATED-ERROR',
         name1_in => 'CONTEXT',
         value1_in => 'Dynamic IN clause query',
         name2_in => 'TABLE_NAME',
         value2_in => 'EMPLOYEES',
         name3_in => 'LIST_STRING',
         value3_in => NULL);
   END in_emp_job_fk_cv;

   FUNCTION ar_emp_job_fk (
      job_id_in IN EMPLOYEES_TP.JOB_ID_t
      )
      RETURN EMPLOYEES_TP.EMPLOYEES_tc
   IS
      CURSOR allrows_cur
      IS
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
          WHERE
             JOB_ID = ar_emp_job_fk.job_id_in

         ;
      retval EMPLOYEES_TP.EMPLOYEES_tc;
   BEGIN
      OPEN allrows_cur;
      FETCH allrows_cur BULK COLLECT INTO retval;
      RETURN retval;
   END ar_emp_job_fk;

   PROCEDURE ar_emp_job_fk (
      job_id_in IN EMPLOYEES_TP.JOB_ID_t,
      employee_id_out OUT EMPLOYEES_TP.EMPLOYEE_ID_cc,
      first_name_out OUT EMPLOYEES_TP.FIRST_NAME_cc,
      last_name_out OUT EMPLOYEES_TP.LAST_NAME_cc,
      email_out OUT EMPLOYEES_TP.EMAIL_cc,
      phone_number_out OUT EMPLOYEES_TP.PHONE_NUMBER_cc,
      hire_date_out OUT EMPLOYEES_TP.HIRE_DATE_cc,
      job_id_out OUT EMPLOYEES_TP.JOB_ID_cc,
      salary_out OUT EMPLOYEES_TP.SALARY_cc,
      commission_pct_out OUT EMPLOYEES_TP.COMMISSION_PCT_cc,
      manager_id_out OUT EMPLOYEES_TP.MANAGER_ID_cc,
      department_id_out OUT EMPLOYEES_TP.DEPARTMENT_ID_cc
      )
   IS
   BEGIN
      SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
        BULK COLLECT INTO
            employee_id_out,
            first_name_out,
            last_name_out,
            email_out,
            phone_number_out,
            hire_date_out,
            job_id_out,
            salary_out,
            commission_pct_out,
            manager_id_out,
            department_id_out
        FROM EMPLOYEES
       WHERE
             JOB_ID = ar_emp_job_fk.job_id_in

      ;
   END ar_emp_job_fk;

   -- Number of rows by EMP_JOB_FK
   FUNCTION num_emp_job_fk (
      job_id_in IN EMPLOYEES_TP.JOB_ID_t
      )
      RETURN PLS_INTEGER
   IS
      retval PLS_INTEGER;
   BEGIN
      SELECT COUNT(*)
        INTO retval
        FROM EMPLOYEES
       WHERE
             JOB_ID = job_id_in
      ;
      RETURN retval;
   END num_emp_job_fk;

   FUNCTION ex_emp_job_fk (
      job_id_in IN EMPLOYEES_TP.JOB_ID_t
      )
      RETURN BOOLEAN
   IS
      l_dummy PLS_INTEGER;
   BEGIN
      SELECT 1 INTO l_dummy
        FROM EMPLOYEES
       WHERE
             JOB_ID = job_id_in
      ;
      RETURN TRUE;
   EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;
             WHEN TOO_MANY_ROWS THEN RETURN TRUE;
   END ex_emp_job_fk;


   FUNCTION ar_emp_manager_fk_cv (
      manager_id_in IN EMPLOYEES_TP.MANAGER_ID_t
      )
      RETURN EMPLOYEES_TP.EMPLOYEES_rc
   IS
      retval EMPLOYEES_TP.EMPLOYEES_rc;
   BEGIN
      OPEN retval FOR
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
       WHERE
          MANAGER_ID = ar_emp_manager_fk_cv.manager_id_in

         ;
      RETURN retval;
   END ar_emp_manager_fk_cv;

   FUNCTION in_emp_manager_fk_cv (
      manager_id_in IN VARCHAR2
      )
      RETURN EMPLOYEES_TP.weak_refcur
   IS
      retval EMPLOYEES_TP.weak_refcur;
   BEGIN
      OPEN retval FOR
         'SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
       WHERE
          MANAGER_ID IN (' || manager_id_in || ')
             '
         ;
      RETURN retval;
   EXCEPTION
      WHEN OTHERS
      THEN
         q$error_manager.raise_error ('UNANTICIPATED-ERROR',
         name1_in => 'CONTEXT',
         value1_in => 'Dynamic IN clause query',
         name2_in => 'TABLE_NAME',
         value2_in => 'EMPLOYEES',
         name3_in => 'LIST_STRING',
         value3_in => NULL);
   END in_emp_manager_fk_cv;

   FUNCTION ar_emp_manager_fk (
      manager_id_in IN EMPLOYEES_TP.MANAGER_ID_t
      )
      RETURN EMPLOYEES_TP.EMPLOYEES_tc
   IS
      CURSOR allrows_cur
      IS
         SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
           FROM EMPLOYEES
          WHERE
             MANAGER_ID = ar_emp_manager_fk.manager_id_in

         ;
      retval EMPLOYEES_TP.EMPLOYEES_tc;
   BEGIN
      OPEN allrows_cur;
      FETCH allrows_cur BULK COLLECT INTO retval;
      RETURN retval;
   END ar_emp_manager_fk;

   PROCEDURE ar_emp_manager_fk (
      manager_id_in IN EMPLOYEES_TP.MANAGER_ID_t,
      employee_id_out OUT EMPLOYEES_TP.EMPLOYEE_ID_cc,
      first_name_out OUT EMPLOYEES_TP.FIRST_NAME_cc,
      last_name_out OUT EMPLOYEES_TP.LAST_NAME_cc,
      email_out OUT EMPLOYEES_TP.EMAIL_cc,
      phone_number_out OUT EMPLOYEES_TP.PHONE_NUMBER_cc,
      hire_date_out OUT EMPLOYEES_TP.HIRE_DATE_cc,
      job_id_out OUT EMPLOYEES_TP.JOB_ID_cc,
      salary_out OUT EMPLOYEES_TP.SALARY_cc,
      commission_pct_out OUT EMPLOYEES_TP.COMMISSION_PCT_cc,
      manager_id_out OUT EMPLOYEES_TP.MANAGER_ID_cc,
      department_id_out OUT EMPLOYEES_TP.DEPARTMENT_ID_cc
      )
   IS
   BEGIN
      SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            PHONE_NUMBER,
            HIRE_DATE,
            JOB_ID,
            SALARY,
            COMMISSION_PCT,
            MANAGER_ID,
            DEPARTMENT_ID
        BULK COLLECT INTO
            employee_id_out,
            first_name_out,
            last_name_out,
            email_out,
            phone_number_out,
            hire_date_out,
            job_id_out,
            salary_out,
            commission_pct_out,
            manager_id_out,
            department_id_out
        FROM EMPLOYEES
       WHERE
             MANAGER_ID = ar_emp_manager_fk.manager_id_in

      ;
   END ar_emp_manager_fk;

   -- Number of rows by EMP_MANAGER_FK
   FUNCTION num_emp_manager_fk (
      manager_id_in IN EMPLOYEES_TP.MANAGER_ID_t
      )
      RETURN PLS_INTEGER
   IS
      retval PLS_INTEGER;
   BEGIN
      SELECT COUNT(*)
        INTO retval
        FROM EMPLOYEES
       WHERE
             MANAGER_ID = manager_id_in
      ;
      RETURN retval;
   END num_emp_manager_fk;

   FUNCTION ex_emp_manager_fk (
      manager_id_in IN EMPLOYEES_TP.MANAGER_ID_t
      )
      RETURN BOOLEAN
   IS
      l_dummy PLS_INTEGER;
   BEGIN
      SELECT 1 INTO l_dummy
        FROM EMPLOYEES
       WHERE
             MANAGER_ID = manager_id_in
      ;
      RETURN TRUE;
   EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;
             WHEN TOO_MANY_ROWS THEN RETURN TRUE;
   END ex_emp_manager_fk;


    -- Number of rows in table
   FUNCTION tabcount (
      where_clause_in IN VARCHAR2 := NULL)
      RETURN PLS_INTEGER
   IS
      retval PLS_INTEGER;
   BEGIN
      IF where_clause_in IS NULL
      THEN
         SELECT COUNT(*) INTO retval FROM EMPLOYEES;
      ELSE
         EXECUTE IMMEDIATE
            'SELECT COUNT(*) FROM EMPLOYEES
              WHERE ' || where_clause_in
            INTO retval;
      END IF;
      RETURN retval;
   END tabcount;

   -- Number of rows by primary key
   FUNCTION pkycount (
      employee_id_in IN EMPLOYEES_TP.EMPLOYEE_ID_t
      )
   RETURN PLS_INTEGER
   IS
      retval PLS_INTEGER;
   BEGIN
      SELECT COUNT(*)
        INTO retval
        FROM EMPLOYEES
       WHERE
             EMPLOYEE_ID = employee_id_in
      ;
      RETURN retval;
   END pkycount;

   -- Existence of row in table for this WHERE clause?
   FUNCTION ex_employees (
      where_clause_in IN VARCHAR2 := NULL)
      RETURN BOOLEAN
   IS
      l_dummy PLS_INTEGER;
   BEGIN
      IF where_clause_in IS NULL
      THEN
         SELECT 1 INTO l_dummy FROM EMPLOYEES;
      ELSE
         EXECUTE IMMEDIATE
            'SELECT 1 FROM EMPLOYEES
              WHERE ' || where_clause_in
            INTO l_dummy;
      END IF;
      RETURN TRUE;
   EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;
             WHEN TOO_MANY_ROWS THEN RETURN TRUE;
   END ex_employees;

    -- Existence of rows by primary key
   FUNCTION ex_pky (
      employee_id_in IN EMPLOYEES_TP.EMPLOYEE_ID_t
      )
   RETURN BOOLEAN
   IS
      l_dummy PLS_INTEGER;
   BEGIN
      SELECT 1
        INTO l_dummy
        FROM EMPLOYEES
       WHERE
             EMPLOYEE_ID = employee_id_in
      ;
      RETURN TRUE;
   EXCEPTION WHEN NO_DATA_FOUND THEN RETURN FALSE;
             WHEN TOO_MANY_ROWS THEN RETURN TRUE;
   END ex_pky;

BEGIN
   NULL;
END EMPLOYEES_QP;
/
