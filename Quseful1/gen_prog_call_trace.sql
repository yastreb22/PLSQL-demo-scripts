CREATE OR REPLACE PROCEDURE gen_trace_call (
   pkg_or_prog_in VARCHAR2
 , pkg_subprog_in VARCHAR2 DEFAULT NULL
 , nest_tracing_in IN BOOLEAN DEFAULT TRUE
 , tracing_enabled_func_in IN VARCHAR2 DEFAULT 'qd_runtime.trace_enabled'
 , trace_func_in IN VARCHAR2 DEFAULT ' qd_runtime.trace'
)
IS
   CURSOR arg_info_cur (
      prog_in IN VARCHAR2
    , subprog_in IN VARCHAR2 DEFAULT NULL
   )
   IS
      SELECT   NVL (argument_name, 'RETURN_VALUE') argument_name, data_type
             , in_out
          FROM user_arguments
         WHERE (   (package_name = prog_in AND subprog_in IS NULL)
                OR (package_name IS NULL AND object_name = prog_in)
                OR (package_name = prog_in AND object_name = subprog_in)
               )
           AND data_level = 0
      ORDER BY POSITION;

   TYPE arg_info_aat IS TABLE OF arg_info_cur%ROWTYPE
      INDEX BY PLS_INTEGER;

   l_in_args    arg_info_aat;
   l_out_args   arg_info_aat;

   PROCEDURE get_argument_info (
      in_args IN OUT arg_info_aat
    , out_args IN OUT arg_info_aat
   )
   IS
      l_arg_info   arg_info_aat;
   BEGIN
      OPEN arg_info_cur (pkg_or_prog_in, pkg_subprog_in);

      FETCH arg_info_cur
      BULK COLLECT INTO l_arg_info;

      FOR indx IN 1 .. l_arg_info.COUNT
      LOOP
         IF l_arg_info (indx).in_out IN ('IN', 'IN/OUT')
         THEN
            in_args (in_args.COUNT + 1) := l_arg_info (indx);
         END IF;

         IF l_arg_info (indx).in_out IN ('OUT', 'IN/OUT')
         THEN
            out_args (out_args.COUNT + 1) := l_arg_info (indx);
         END IF;
      END LOOP;
   END get_argument_info;

   PROCEDURE gen_trace_proc (
      arg_type_in IN VARCHAR2
    , args_in arg_info_aat
    , comment_in IN VARCHAR2
   )
   IS
      FUNCTION bool_to_char_function (arg_type_in IN VARCHAR2)
         RETURN VARCHAR2
      IS
         l_have_boolean   BOOLEAN DEFAULT FALSE;
      BEGIN
         /* If there is one or more boolean argument, then add
            the to_char converter function and use it. */
         FOR indx IN 1 .. args_in.COUNT
         LOOP
            IF args_in (indx).data_type IN ('BOOLEAN', 'PL/SQL BOOLEAN')
            THEN
               l_have_boolean := TRUE;
            END IF;
         END LOOP;

         IF l_have_boolean
         THEN
            RETURN    'FUNCTION bool_to_char (bool_in in boolean) RETURN VARCHAR2 IS BEGIN '
                   || CHR (10)
                   || 'IF bool_in THEN RETURN ''TRUE''; '
                   || CHR (10)
                   || 'ELSIF NOT bool_in THEN RETURN ''FALSE''; '
                   || CHR (10)
                   || 'ELSE RETURN ''NULL''; END IF; END bool_to_char;';
         ELSE
            RETURN NULL;
         END IF;
      END bool_to_char_function;

      FUNCTION converted (index_in IN PLS_INTEGER, arg_name_in IN VARCHAR2)
         RETURN VARCHAR2
      IS
      BEGIN
         IF args_in (index_in).data_type IN ('BOOLEAN', 'PL/SQL BOOLEAN')
         THEN
            RETURN 'bool_to_char (' || arg_name_in || ')';
         ELSE
            RETURN arg_name_in;
         END IF;
      END converted;
   BEGIN
      IF args_in.COUNT > 0
      THEN
         DBMS_OUTPUT.put_line ('');
         DBMS_OUTPUT.put_line ('   ' || comment_in);
         DBMS_OUTPUT.put_line (   'PROCEDURE trace_'
                               || arg_type_in
                               || '_arguments IS '
                               || bool_to_char_function (arg_type_in)
                               || ' BEGIN '
                               || CHR (10)
                               || '   IF '
                               || tracing_enabled_func_in
                               || ' THEN '
                               || CHR (10)
                               || '      '
                               || trace_func_in
                               || ' ('''
                               || pkg_or_prog_in
                               || CASE
                                     WHEN pkg_subprog_in IS NULL
                                        THEN NULL
                                     ELSE '.' || pkg_subprog_in
                                  END
                               || ''', '
                              );

         FOR indx IN 1 .. args_in.COUNT
         LOOP
            DBMS_OUTPUT.put_line (   CASE
                                        WHEN indx = 1
                                           THEN ''''
                                        ELSE '|| '' - '
                                     END
                                  || args_in (indx).argument_name
                                  || '='' || '
                                  || converted (indx
                                              , args_in (indx).argument_name
                                               )
                                  || CHR (10)
                                  || '      '
                                 );
         END LOOP;

         DBMS_OUTPUT.put_line (   '      );'
                               || CHR (10)
                               || '   END IF;'
                               || CHR (10)
                               || 'END trace_'
                               || arg_type_in
                               || '_arguments;'
                              );
      END IF;
   END gen_trace_proc;
BEGIN
   get_argument_info (l_in_args, l_out_args);
   /* Place procedures in anonymous block for easy formatting. */
   DBMS_OUTPUT.put_line ('DECLARE');
   gen_trace_proc ('IN'
                 , l_in_args
                 , '/* AFTER ENTERING - IN and IN OUT argument tracing */'
                  );
   gen_trace_proc ('OUT'
                 , l_out_args
                 , '/* BEFORE LEAVING - OUT and IN OUT argument tracing */'
                  );
   /* Place procedures in anonymous block for easy formatting. */
   DBMS_OUTPUT.put_line ('BEGIN NULL; END;');
END gen_trace_call;
/