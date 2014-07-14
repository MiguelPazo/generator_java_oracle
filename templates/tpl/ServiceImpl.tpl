package #{$_package_service}#.impl;

import java.util.ArrayList;
import #{$_package_domain}#.#{$_class}#;
import #{$_package_service}#.iface.I#{$_class}#Service;
import #{$_package_dao}#.FactoryDao;

/**
 *
 * @author Miguel Pazo
 */
public class #{$_class}#Service implements I#{$_class}#Service {
    
    FactoryDao oFactor = new FactoryDao();

    @Override
    public Integer insert(#{$_class}# o#{$_class}#){
        Integer newID = 0;

        try {
            // open conection
            oFactor.getConexionDao().ConexionOpen();
            // execute command
            newID = oFactor.get#{$_class}#Dao().insert(o#{$_class}#);
        } catch (Exception e) {
            throw e;
        } finally {
            // close conection
            oFactor.getConexionDao().ConexionClose();
        }

        return newID;
    }
    
    @Override
    public void update(#{$_class}# o#{$_class}#){
        try {
            // open conection
            oFactor.getConexionDao().ConexionOpen();
            // execute command
            oFactor.get#{$_class}#Dao().update(o#{$_class}#);
        } catch (Exception e) {
            throw e;
        } finally {
            // close conection
            oFactor.getConexionDao().ConexionClose();
        }
    }
    
    @Override
    public void delete(#{$_class}# o#{$_class}#){
        try {
            // open conection
            oFactor.getConexionDao().ConexionOpen();
            // execute command
            oFactor.get#{$_class}#Dao().delete(o#{$_class}#);
        } catch (Exception e) {
            throw e;
        } finally {
            // close conection
            oFactor.getConexionDao().ConexionClose();
        }
    }
    
    @Override
    public ArrayList<#{$_class}#> fetchAll(#{$_class}# o#{$_class}#){
        ArrayList<#{$_class}#> oLista = new ArrayList<>();
        
        try {
            // open conection
            oFactor.getConexionDao().ConexionOpen();
            // listar los datos
            oLista = oFactor.get#{$_class}#Dao().fetchAll(o#{$_class}#);
        } catch (Exception e) {
            throw e;
        } finally {
            // close conection
            oFactor.getConexionDao().ConexionClose();
        }

        return oLista;
    }
    
}
