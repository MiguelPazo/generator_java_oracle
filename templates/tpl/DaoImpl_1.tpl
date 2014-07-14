package #{$_package_dao}#.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleResultSet;
import oracle.jdbc.OracleTypes;
import #{$_package_domain}#.#{$_class}#;
import #{$_package_dao}#.iface.I#{$_class}#Dao;

/**
 *
 * @author Miguel Pazo
 */
public class #{$_class}#Dao implements I#{$_class}#Dao {
    
    @Override
    public Integer insert(#{$_class}# o#{$_class}#){
        Integer newID = 0;
        OracleCallableStatement cmd = null;
        
        try {
            return 1;
        } catch (Exception e) {
            throw e;
        }
    }
    
    @Override
    public void update(#{$_class}# o#{$_class}#){
        try {
            
        } catch (Exception e) {
            throw e;
        }
    }
    
    @Override
    public void delete(#{$_class}# o#{$_class}#){
        try {
            
        } catch (Exception e) {
            throw e;
        }
    }
    
    @Override
    public ArrayList<#{$_class}#> fetchAll(#{$_class}# o#{$_class}#){
        try {
            ArrayList<#{$_class}#> lst#{$_class}# = new ArrayList<#{$_class}#>();
            return lst#{$_class}#;
        } catch (Exception e) {
            throw e;
        }
    }
    
}
