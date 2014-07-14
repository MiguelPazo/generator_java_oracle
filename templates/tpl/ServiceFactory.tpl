package #{$_package_service}#;

import #{$_package_service}#.iface.*;
import #{$_package_service}#.impl.*;

/**
 *
 * @author Miguel Pazo
 */
public class FactoryService {
#{foreach key=key item=item from=$_class}#

    public I#{$item}#Service get#{$item}#Service() {
        return new #{$item}#Service();
    }    
#{/foreach}#    
}
