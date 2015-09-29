CREATE OR REPLACE PACKAGE ut_watch
IS
   PROCEDURE setup;
   PROCEDURE teardown;
 
   -- For each program to test...
   PROCEDURE ACTION1;
   PROCEDURE ACTION2;
   PROCEDURE ACTION3;
   PROCEDURE ACTION4;
   PROCEDURE ACTION5;
   PROCEDURE FINISH;
   PROCEDURE NOUSECS;
   PROCEDURE SHOW;
   PROCEDURE STARTUP;
   PROCEDURE TOPIPE;
   PROCEDURE TOSCREEN;
   PROCEDURE USECS;
   PROCEDURE USING_CS;
END ut_watch;
/