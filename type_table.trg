CREATE OR REPLACE TRIGGER TYPE_TABLE_bir
  BEFORE INSERT ON TYPE_TABLE
  FOR EACH ROW
DECLARE
BEGIN
   IF :NEW.ID IS NULL
   THEN
      :NEW.ID := TYPE_TABLE_CP.next_key;
   END IF;
  :new.CREATED_ON := SYSDATE;
  :new.CREATED_BY := USER;
  :new.CHANGED_ON := SYSDATE;
  :new.CHANGED_BY := USER;
END TYPE_TABLE_bir;
/

CREATE OR REPLACE TRIGGER TYPE_TABLE_bur
  BEFORE UPDATE ON TYPE_TABLE
  FOR EACH ROW
DECLARE
BEGIN
  :new.CHANGED_ON := SYSDATE;
  :new.CHANGED_BY := USER;
  :new.CREATED_ON := :old.CREATED_ON;
  :new.CREATED_ON := :old.CREATED_ON;
END TYPE_TABLE_bur;
/
