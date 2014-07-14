package #{$_package_dao}#;

import #{$_package_dao}#.iface.*;
import #{$_package_dao}#.impl.*;

/**
 *
 * @author Miguel Pazo
 */
public class FactoryDao {

    public IConexionDao getConexionDao(){
        return ConexionDao.Instance();
    }
#{foreach key=key item=item from=$_class}#

    public I#{$item}#Dao get#{$item}#Dao() {
        return new #{$item}#Dao();
    }    
#{/foreach}#    
}
