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
    private Date #{$item['attribute']}#;
#{else if $item['typeAttribute'] eq 'Numeric'}#
    private int #{$item['attribute']}#;
#{else}#
    private String #{$item['attribute']}#;
#{/if}#
#{/foreach}#

#{foreach key=key item=item from=$_fields}#
#{if $item['typeAttribute'] eq 'DateTime'}#
    public Date get#{$item['attribute']|ucfirst}#() {
        return #{$item['attribute']}#;
    }
#{else if $item['typeAttribute'] eq 'Numeric'}#
    public int get#{$item['attribute']|ucfirst}#() {
        return #{$item['attribute']}#;
    }
#{else}#
    public String get#{$item['attribute']|ucfirst}#() {
        if (this.#{$item['attribute']}# == null) {
            return "";
        } else {
            return #{$item['attribute']}#;
        }
    }
#{/if}#

#{/foreach}#
#{foreach key=key item=item from=$_fields}#
#{if $item['typeAttribute'] eq 'DateTime'}#
    public void set#{$item['attribute']|ucfirst}#(Date #{$item['attribute']}#) {
        this.#{$item['attribute']}# = #{$item['attribute']}#;
    }
#{else if $item['typeAttribute'] eq 'Numeric'}#
    public void set#{$item['attribute']|ucfirst}#(int #{$item['attribute']}#) {
        this.#{$item['attribute']}# = #{$item['attribute']}#;
    }
#{else}#
    public void set#{$item['attribute']|ucfirst}#(String #{$item['attribute']}#) {
        this.#{$item['attribute']}# = #{$item['attribute']}#;
    }
#{/if}#

#{/foreach}#
#{if $_containDate}#
    public void resetDates() {
#{foreach key=key item=item from=$_fields}#
#{if $item['typeAttribute'] eq 'DateTime'}#
        this.#{$item['attribute']}# = null;
#{/if}#
#{/foreach}#
    }
    
#{/if}#
#{assign var="toString" value=""}#
#{foreach key=key item=item from=$_fields}#
#{assign var="toString" value=$toString|cat:" + "|cat:'"'|cat:", "|cat: $item['attribute']|cat: " = "|cat:'" + this.'|cat: $item['attribute']}#
#{/foreach}#
    @Override
    public String toString() {
        return "#{$_className}# {" + "#{$toString|substr:6}# + '}';
    }
    
}
