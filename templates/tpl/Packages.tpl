CREATE OR REPLACE PACKAGE PKG_#{$_table}# IS
  TYPE RESULTADO_CURSOR IS REF CURSOR;

  PROCEDURE SP_BUS_#{$_table}#(#{foreach key=key item=item from=$_fields}#
                              PI_#{$item['input_field']}# IN #{$_table}#.#{$item['field']}#%TYPE,
                              #{/foreach}#
                              PO_CURSOR_RESULTADO OUT RESULTADO_CURSOR,
                              PO_RESULTADO        OUT VARCHAR,
                              PO_ERR_DESC         OUT VARCHAR);
                              
  PROCEDURE SP_ACT_#{$_table}#(#{foreach key=key item=item from=$_fields}#
                              PI_#{$item['input_field']}# IN #{$_table}#.#{$item['field']}#%TYPE,
#{/foreach}#
                              PO_RESULTADO    OUT VARCHAR,
                              PO_ERR_DESC     OUT VARCHAR);
  PROCEDURE SP_INST_#{$_table}#(#{foreach key=key item=item from=$_fields}#
#{if $item['field'] neq $_primary }#
                              PI_#{$item['input_field']}# IN #{$_table}#.#{$item['field']}#%TYPE,
#{/if}#
#{/foreach}#
                              PO_NEW_ID    OUT NUMBER,
                              PO_RESULTADO    OUT VARCHAR,
                              PO_ERR_DESC     OUT VARCHAR);   
  PROCEDURE SP_DEL_#{$_table}#(#{foreach key=key item=item from=$_fields}#
                              PI_#{$item['input_field']}# IN #{$_table}#.#{$item['field']}#%TYPE,
                              #{/foreach}#
                              PO_RESULTADO    OUT VARCHAR,
                              PO_ERR_DESC     OUT VARCHAR);                                
                              
END PKG_#{$_table}#;
/
CREATE OR REPLACE PACKAGE BODY PKG_#{$_table}# IS

  PROCEDURE SP_BUS_#{$_table}#(#{foreach key=key item=item from=$_fields}#
                              PI_#{$item['input_field']}# IN #{$_table}#.#{$item['field']}#%TYPE,
                              #{/foreach}#
                              PO_CURSOR_RESULTADO OUT RESULTADO_CURSOR,
                              PO_RESULTADO        OUT VARCHAR,
                              PO_ERR_DESC         OUT VARCHAR) IS
  BEGIN

    PO_RESULTADO := 0;
    PO_ERR_DESC  := '0';
    BEGIN
#{assign var="count" value=0}#
      OPEN PO_CURSOR_RESULTADO FOR
        SELECT 
#{foreach key=key item=item from=$_fields}#
#{assign var="count" value=$count + 1}#
            #{$item['field']}# AS #{$item['attribute']}##{if $count neq $_count_fields}#,#{/if}#
#{/foreach}#
          FROM #{$_table}#
         WHERE 
#{assign var="count" value=0}#
#{foreach key=key item=item from=$_fields}#
#{assign var="count" value=$count + 1}#
#{if $item['typeAttribute'] neq 'DateTime'}#
#{if $item['typeAttribute'] eq 'String'}#
            #{if $count neq 1}#AND#{/if}# NVL (#{$item['field']}#, '0') = CASE
                            WHEN PI_#{$item['input_field']}# IS NULL THEN
                                NVL(#{$item['field']}#,'0')
                            WHEN PI_#{$item['input_field']}# = '0' THEN
                                NVL(#{$item['field']}#,'0')
                            ELSE
                                PI_#{$item['input_field']}# 
                            END
#{else}##{if $count neq 1}#AND#{/if}# NVL (#{$item['field']}#, 0) = CASE
                            WHEN PI_#{$item['input_field']}# IS NULL THEN
                                NVL(#{$item['field']}#,0)
                            WHEN PI_#{$item['input_field']}# = 0 THEN
                                NVL(#{$item['field']}#,0)
                            ELSE
                                PI_#{$item['input_field']}# 
                            END#{/if}##{/if}##{if $count eq $_count_fields}#;#{/if}#
                            
#{/foreach}#
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESULTADO := SQLCODE;
        PO_ERR_DESC  := SUBSTR(SQLERRM, 1, 100);
    END;
  END SP_BUS_#{$_table}#;

  PROCEDURE SP_ACT_#{$_table}#(#{foreach key=key item=item from=$_fields}#
                              PI_#{$item['input_field']}# IN #{$_table}#.#{$item['field']}#%TYPE,
#{/foreach}#
                              PO_RESULTADO    OUT VARCHAR,
                              PO_ERR_DESC     OUT VARCHAR) IS
  BEGIN

    PO_RESULTADO := 0;
    PO_ERR_DESC  := '0';
    BEGIN

      UPDATE #{$_table}#
         SET 
#{assign var="count" value=0}#   
#{foreach key=key item=item from=$_fields}#
#{assign var="count" value=$count + 1}#
#{if $item['field'] != $_primary }#
            #{$item['field']}# = PI_#{$item['input_field']}##{if $count neq $_count_fields}#,#{/if}#
#{/if}#
#{/foreach}#
       WHERE #{$_primary}# = PI_#{$_primary|substr:2}#;

    EXCEPTION
      WHEN OTHERS THEN
        PO_RESULTADO := SQLCODE;
        PO_ERR_DESC  := SUBSTR(SQLERRM, 1, 100);
    END;
  END SP_ACT_#{$_table}#;
                              
PROCEDURE SP_INST_#{$_table}#(#{foreach key=key item=item from=$_fields}#
#{if $item['field'] neq $_primary }#
                              PI_#{$item['input_field']}# IN #{$_table}#.#{$item['field']}#%TYPE,
#{/if}#
#{/foreach}#
                              PO_NEW_ID    OUT NUMBER,
                              PO_RESULTADO    OUT VARCHAR,
                              PO_ERR_DESC     OUT VARCHAR) IS
    PI_#{$_primary|substr:2}# NUMBER;
    STR_QUERY        VARCHAR2(200);
    STR_QUERY_HEAD   VARCHAR2(100);
    STR_QUERY_VALUES VARCHAR2(100);
  BEGIN
    BEGIN
        PI_#{$_primary|substr:2}#    := SEQ_#{$_table}#_PK.NEXTVAL;
        STR_QUERY_HEAD   := STR_QUERY_HEAD || '#{$_primary}#, ';
        STR_QUERY_VALUES := STR_QUERY_VALUES || PI_#{$_primary|substr:2}# || ', ';
#{foreach key=key item=item from=$_fields}#

#{if $item['field'] neq $_primary }#
        IF PI_#{$item['input_field']}# IS NOT NULL THEN
          STR_QUERY_HEAD   := STR_QUERY_HEAD || '#{$item['field']}#, ';
#{if $item['typeAttribute'] eq 'String'}#
          STR_QUERY_VALUES := STR_QUERY_VALUES || '''' || PI_#{$item['input_field']}# || ''', ';
#{else}#
          STR_QUERY_VALUES := STR_QUERY_VALUES || PI_#{$item['input_field']}# || ', ';
#{/if}#
        END IF;        
#{/if}#
#{/foreach}#

        STR_QUERY_HEAD   := SUBSTR(STR_QUERY_HEAD, 0, LENGTH(STR_QUERY_HEAD) - 2);
        STR_QUERY_VALUES := SUBSTR(STR_QUERY_VALUES, 0, LENGTH(STR_QUERY_VALUES) - 2);
        STR_QUERY        := 'INSERT INTO #{$_table}#(' || STR_QUERY_HEAD || ') VALUES (' || STR_QUERY_VALUES || ')';

        EXECUTE IMMEDIATE STR_QUERY;
        PO_NEW_ID := PI_#{$_primary|substr:2}#;
    
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESULTADO := SQLCODE;
        PO_ERR_DESC  := SUBSTR(SQLERRM, 1, 100);
    END;
  END SP_INST_#{$_table}#;
                              
  PROCEDURE SP_DEL_#{$_table}#(#{foreach key=key item=item from=$_fields}#
                              PI_#{$item['input_field']}# IN #{$_table}#.#{$item['field']}#%TYPE,
                              #{/foreach}#
                              PO_RESULTADO    OUT VARCHAR,
                              PO_ERR_DESC     OUT VARCHAR) IS
  BEGIN
    BEGIN
      DELETE FROM #{$_table}#
       WHERE 
#{assign var="count" value=0}#
#{foreach key=key item=item from=$_fields}#
#{assign var="count" value=$count + 1}#
#{if $item['typeAttribute'] neq 'DateTime'}#
#{if $item['typeAttribute'] eq 'String'}#
            #{if $count neq 1}#AND#{/if}# NVL (#{$item['field']}#, '0') = CASE
                            WHEN PI_#{$item['input_field']}# IS NULL THEN
                                NVL(#{$item['field']}#,'0')
                            WHEN PI_#{$item['input_field']}# = '0' THEN
                                NVL(#{$item['field']}#,'0')
                            ELSE
                                PI_#{$item['input_field']}# 
                            END
#{else}##{if $count neq 1}#AND#{/if}# NVL (#{$item['field']}#, 0) = CASE
                            WHEN PI_#{$item['input_field']}# IS NULL THEN
                                NVL(#{$item['field']}#,0)
                            WHEN PI_#{$item['input_field']}# = 0 THEN
                                NVL(#{$item['field']}#,0)
                            ELSE
                                PI_#{$item['input_field']}# 
                            END#{/if}##{/if}##{if $count eq $_count_fields}#;#{/if}#
                            
#{/foreach}#  
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESULTADO := SQLCODE;
        PO_ERR_DESC  := SUBSTR(SQLERRM, 1, 100);
    END;
  END SP_DEL_#{$_table}#;
  
END PKG_#{$_table}#;
/
