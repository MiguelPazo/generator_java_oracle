package #{$_package_domain}#;
#{if $_containDate}#
import java.util.Date;
#{/if}#

/**
 *
 * @author Miguel Rodrigo Pazo Sánchez (http://miguelpazo.com/)
 */ 
public class #{$_className}# {

#{foreach key=key item=item from=$_fields}#
#{if $item['typeAttribute'] eq 'DateTime'}#
    private Date _#{$item['attribute']}#;
#{else if $item['typeAttribute'] eq 'Numeric'}#
    private int _#{$item['attribute']}#;
#{else}#
    private String _#{$item['attribute']}#;
#{/if}#
#{/foreach}#

#{foreach key=key item=item from=$_fields}#
#{if $item['typeAttribute'] eq 'DateTime'}#
    public Date get#{$item['attribute']|ucfirst}#() {
        return _#{$item['attribute']}#;
    }
#{else if $item['typeAttribute'] eq 'Numeric'}#
    public int get#{$item['attribute']|ucfirst}#() {
        return _#{$item['attribute']}#;
    }
#{else}#
    public String get#{$item['attribute']|ucfirst}#() {
        return _#{$item['attribute']}#;
    }
#{/if}#

#{/foreach}#
#{foreach key=key item=item from=$_fields}#
#{if $item['typeAttribute'] eq 'DateTime'}#
    public void set#{$item['attribute']|ucfirst}#(Date #{$item['attribute']}#) {
        this._#{$item['attribute']}# = #{$item['attribute']}#;
    }
#{else if $item['typeAttribute'] eq 'Numeric'}#
    public void set#{$item['attribute']|ucfirst}#(int #{$item['attribute']}#) {
        this._#{$item['attribute']}# = #{$item['attribute']}#;
    }
#{else}#
    public void set#{$item['attribute']|ucfirst}#(String #{$item['attribute']}#) {
        this._#{$item['attribute']}# = #{$item['attribute']}#;
    }
#{/if}#

#{/foreach}#
#{assign var="toString" value=""}#
#{foreach key=key item=item from=$_fields}#
#{assign var="toString" value=$toString|cat:" + "|cat:'"'|cat:", _"|cat: $item['attribute']|cat: " = "|cat:'" + this._'|cat: $item['attribute']}#
#{/foreach}#
    @Override
    public String toString() {
        return "#{$_className}# {" + "#{$toString|substr:6}# + '}';
    }
    
}
