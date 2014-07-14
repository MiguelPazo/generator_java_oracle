package #{$_package_service}#.iface;

import java.util.ArrayList;
import #{$_package_domain}#.#{$_class}#;

/**
 *
 * @author Miguel Pazo
 */
public interface I#{$_class}#Service {
    
    Integer insert(#{$_class}# o#{$_class}#);
    
    void update(#{$_class}# o#{$_class}#);
    
    void delete(#{$_class}# o#{$_class}#);
    
    ArrayList<#{$_class}#> fetchAll(#{$_class}# o#{$_class}#);
    
}
