package #{$_package_dao}#.iface;

import java.util.ArrayList;
import #{$_package_domain}#.#{$_class}#;

/**
 *
 * @author Miguel Rodrigo Pazo Sánchez (http://miguelpazo.com/)
 */
public interface I#{$_class}#Dao {
    
    Integer insert(#{$_class}# o#{$_class}#);
    
    boolean update(#{$_class}# o#{$_class}#);
    
    boolean delete(#{$_class}# o#{$_class}#);
    
    ArrayList<#{$_class}#> fetchAll(#{$_class}# o#{$_class}#);
    
}
