SELECT DISTINCT name
  FROM USER_SOURCE
 WHERE INSTR (UPPER (text), 'EXCEPTION_INIT') > 0
/