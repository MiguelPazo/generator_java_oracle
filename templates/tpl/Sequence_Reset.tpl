CREATE OR REPLACE PACKAGE PKG_CARGA IS

  -- Author  : MPAZO
  -- Created : 20/02/2015 05:04:55 p.m.
  -- Purpose :

  PROCEDURE SP_RESET_SEQUENCES;
  PROCEDURE SP_DISABLE_CST_FK;
  PROCEDURE SP_ENABLE_CST_FK;

END PKG_CARGA;
/
CREATE OR REPLACE PACKAGE BODY PKG_CARGA IS

  PROCEDURE SP_RESET_SEQUENCES IS
#{foreach key=key item=item from=$_fields}#
    VAR_#{$item['table']}#_SQ NUMBER;
#{/foreach}#
  BEGIN
#{foreach key=key item=item from=$_fields}#
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_#{$item['table']}#_PK';
#{/foreach}#

#{foreach key=key item=item from=$_fields}#
    SELECT NVL(MAX(#{$item['primary']}#),0) + 1 INTO VAR_#{$item['table']}#_SQ FROM #{$item['table']}#;
#{/foreach}#

#{foreach key=key item=item from=$_fields}#
    EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_#{$item['table']}#_PK INCREMENT BY 1 START WITH ' || VAR_#{$item['table']}#_SQ || ' MAXVALUE 999999 NOCACHE NOCYCLE';
#{/foreach}#
  END SP_RESET_SEQUENCES;
END PKG_CARGA;
/
