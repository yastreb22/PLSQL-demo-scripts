SELECT * FROM SYS.v_$nls_parameters;

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

BEGIN
   p.l (TO_NUMBER ('123,456'));
   p.l (TO_NUMBER ('123.456,98'));
END;
/

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '.,';

BEGIN
   p.l (TO_NUMBER ('123.456'));
END;
/

BEGIN
  /* Or in PL/SQL... */
  DBMS_SESSION.SET_NLS ('NLS_NUMERIC_CHARACTERS', ''',.''');
  p.l (TO_NUMBER ('123,456'));

  DBMS_SESSION.SET_NLS ('NLS_NUMERIC_CHARACTERS', '''.,''');
  p.l (TO_NUMBER ('123.456'));
END;
/
