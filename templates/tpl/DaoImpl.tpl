package #{$_package_dao}#.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleResultSet;
import oracle.jdbc.OracleTypes;
import #{$_package_dao}#.common.util.DBUtil;
import #{$_package_dao}#.common.util.ParameterDirection;
import #{$_package_dao}#.common.util.ParameterOracle;
import #{$_package_dao}#.iface.I#{$_class}#Dao;
import #{$_package_domain}#.#{$_class}#;

/**
 *
 * @author Miguel Pazo
 */
public class #{$_class}#Dao extends DBUtil implements I#{$_class}#Dao{
    
    @Override
    public Integer insert(#{$_class}# o#{$_class}#){
        Integer newID = 0;
        OracleCallableStatement cmd = null;
        
        try {                        
            // name of procedure
            String sp = "{call PKG_#{$_table}#.SP_INST_#{$_table}#(#{$_iInsert}#,?,?,?)}";
            // list of parameters
            List<ParameterOracle> oLis = new ArrayList<>();
            // fill parameters
            oLis = insertParameters(o#{$_class}#);
            // execute procedure
            runSP(oLis, ConexionDao.getOracleConnection(), cmd, sp);

            newID =  getOutputParameter("PO_NEW_ID").getParameterInt();
                    
        } catch (SQLException e) {            
            Logger.getLogger(#{$_class}#Dao.class.getName()).log(Level.SEVERE, null, e);
        }
        
        return newID;
    }
    
    @Override
    public void update(#{$_class}# o#{$_class}#){
        OracleCallableStatement cmd = null;
        
        try {
            // name of procedure
            String sp = "{call PKG_#{$_table}#.SP_ACT_#{$_table}#(#{$_iOthers}#,?,?)}";
            // list of parameters
            List<ParameterOracle> oLis = new ArrayList<>();
            // fill parameters
            oLis = updateParameters(o#{$_class}#);
            // execute procedure
            runSP(oLis, ConexionDao.getOracleConnection(), cmd, sp);
        
        } catch (SQLException e) {
            Logger.getLogger(#{$_class}#Dao.class.getName()).log(Level.SEVERE, null, e);
        }
    }
    
    @Override
    public void delete(#{$_class}# o#{$_class}#){
        OracleCallableStatement cmd = null;
        
        try {
            // name of procedure
            String sp = "{call PKG_#{$_table}#.SP_DEL_#{$_table}#(#{$_iOthers}#,?,?)}";
            // list of parameters
            List<ParameterOracle> oLis = new ArrayList<>();
            // fill parameters
            oLis = deleteParameters(o#{$_class}#);            
             // execute procedure
            runSP(oLis, ConexionDao.getOracleConnection(), cmd, sp);
            
        } catch (SQLException e) {
            Logger.getLogger(#{$_class}#Dao.class.getName()).log(Level.SEVERE, null, e);
        }
    }
    
    @Override
    public ArrayList<#{$_class}#> fetchAll(#{$_class}# o#{$_class}#){
        ArrayList<#{$_class}#> lst#{$_class}# = new ArrayList<>();
        OracleCallableStatement cmd = null;
        OracleResultSet resultSet = null; 
        
        try {
            // name of procedure
            String sp = "{call PKG_#{$_table}#.SP_BUS_#{$_table}#(#{$_iOthers}#,?,?,?)}";
            // list of parameters
            List<ParameterOracle> oLis = new ArrayList<>();
            // fill parameters
            oLis = listParameters(o#{$_class}#);
            // execute procedure
            runSearch(oLis, ConexionDao.getOracleConnection(), cmd, sp);
            
            resultSet = getOutputParameter("PO_CURSOR_RESULTADO").getParameterResultSet();
            
            while (resultSet.next()) {
                #{$_class}# new#{$_class}# = new #{$_class}#();
                
#{foreach key=key item=item from=$_fields}#
#{if $item['typeAttribute'] eq 'DateTime'}#
                new#{$_class}#.set#{$item['attribute']|ucfirst}#(resultSet.getDate("#{$item['attribute']}#"));
#{else if $item['typeAttribute'] eq 'String'}#
                new#{$_class}#.set#{$item['attribute']|ucfirst}#(resultSet.getString("#{$item['attribute']}#"));
#{else if $item['typeAttribute'] eq 'Numeric'}#
                new#{$_class}#.set#{$item['attribute']|ucfirst}#(resultSet.getInt("#{$item['attribute']}#"));
#{/if}#
#{/foreach}#
                
                lst#{$_class}#.add(new#{$_class}#);
            }
            
            resultSet.close();
            
        } catch (SQLException e) {
            Logger.getLogger(#{$_class}#Dao.class.getName()).log(Level.SEVERE, null, e);
        }
        
        return lst#{$_class}#;
    }
    
    private List<ParameterOracle> listParameters(#{$_class}# o#{$_class}#) {
        List<ParameterOracle> oListParam = new ArrayList<>();
        
#{foreach key=key item=item from=$_fields}#
        oListParam.add(new ParameterOracle("PI_#{$item['input_field']}#", o#{$_class}#.get#{$item['attribute']|ucfirst}#(), OracleTypes.#{$item['oracleType']}#, ParameterDirection.Input));
#{/foreach}#
        
        oListParam.add(new ParameterOracle("PO_CURSOR_RESULTADO", null, OracleTypes.CURSOR, ParameterDirection.Output));
        oListParam.add(new ParameterOracle("PO_RESULTADO", "", OracleTypes.VARCHAR, ParameterDirection.Output));
        oListParam.add(new ParameterOracle("PO_ERR_DESC", "", OracleTypes.VARCHAR, ParameterDirection.Output));
        
        return oListParam;
    }
   
    private List<ParameterOracle> insertParameters(#{$_class}# o#{$_class}#){
        List<ParameterOracle> oListParam = new ArrayList<>();
        
#{foreach key=key item=item from=$_fields}#
#{if $item['field'] neq $_primary }#
        oListParam.add(new ParameterOracle("PI_#{$item['input_field']}#", o#{$_class}#.get#{$item['attribute']|ucfirst}#(), OracleTypes.#{$item['oracleType']}#, ParameterDirection.Input));
#{/if}#
#{/foreach}#
        
        oListParam.add(new ParameterOracle("PO_NEW_ID", 0, OracleTypes.NUMBER, ParameterDirection.Output));
        oListParam.add(new ParameterOracle("PO_RESULTADO", "", OracleTypes.VARCHAR, ParameterDirection.Output));
        oListParam.add(new ParameterOracle("PO_ERR_DESC", "", OracleTypes.VARCHAR, ParameterDirection.Output));
                
        return oListParam;
    }
    
    private List<ParameterOracle> updateParameters(#{$_class}# o#{$_class}#) {
        List<ParameterOracle> oListParam = new ArrayList<>();
            
#{foreach key=key item=item from=$_fields}#
        oListParam.add(new ParameterOracle("PI_#{$item['input_field']}#", o#{$_class}#.get#{$item['attribute']|ucfirst}#(), OracleTypes.#{$item['oracleType']}#, ParameterDirection.Input));
#{/foreach}#              
        
        oListParam.add(new ParameterOracle("PO_RESULTADO", "", OracleTypes.VARCHAR, ParameterDirection.Output));
        oListParam.add(new ParameterOracle("PO_ERR_DESC", "", OracleTypes.VARCHAR, ParameterDirection.Output));
        
        return oListParam;
    }
    
    private List<ParameterOracle> deleteParameters(#{$_class}# o#{$_class}#) {
        List<ParameterOracle> oListParam = new ArrayList<>();

#{foreach key=key item=item from=$_fields}#
        oListParam.add(new ParameterOracle("PI_#{$item['input_field']}#", o#{$_class}#.get#{$item['attribute']|ucfirst}#(), OracleTypes.#{$item['oracleType']}#, ParameterDirection.Input));
#{/foreach}#
        
        oListParam.add(new ParameterOracle("PO_RESULTADO", "", OracleTypes.VARCHAR, ParameterDirection.Output));
        oListParam.add(new ParameterOracle("PO_ERR_DESC", "", OracleTypes.VARCHAR, ParameterDirection.Output));
        
        return oListParam;
    }
    
}
