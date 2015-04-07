#{foreach key=key item=item from=$_fields}#
DROP SEQUENCE SEQ_#{$item}#_PK;
#{/foreach}#

#{foreach key=key item=item from=$_fields}#
CREATE SEQUENCE SEQ_#{$item}#_PK
INCREMENT BY 1
START WITH 1
MAXVALUE 999999
NOCACHE
NOCYCLE;
#{/foreach}#