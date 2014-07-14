package #{$_package_dao}#.common.util;

import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleConnection;
import oracle.jdbc.OracleTypes;

/**
 *
 * @author Miguel Pazo
 */
public class DBUtil {

    // list of output parameters
    public List<OutParameter> outParameters = new ArrayList<>();    
    
    /// <summary>
    /// Execute procedures INSERT / UPDATE / DELETE
    /// </summary>
    /// <param name="poLst"></param>
    /// <param name="cn"></param>
    /// <param name="cmd"></param>
    /// <param name="sql"></param>
    public void runSP(List<ParameterOracle> poLst, OracleConnection cn, 
                      OracleCallableStatement cmd, String sql) throws SQLException{
        // control de errores
        try {
            // asignar la conexion al comando
            cmd = (OracleCallableStatement) cn.prepareCall(sql);
            
            // recorrer los parametros
            for (ParameterOracle oParam : poLst) {
                // adicionar los parametros
                addParameter(cmd, oParam);
            }
            
            // ejecutar procedimiento
            cmd.execute();
            
            String estado = "0";
            String mensaje = "";
            
            // recorrer los parametros de salida
            for (OutParameter outParam : outParameters) {
                // obtener valor de parametro
                getOutputParameter(cmd, outParam);
                
                // obtener el Resultado del error
                if (outParam.getNomParam().equals("PO_RESULTADO"))
                    estado = outParam.getValParam().toString();
                // obtener el número de error
                if (outParam.getNomParam().equals("PO_ERR_DESC"))
                    mensaje = outParam.getValParam().toString();                    
            }
            
            if (!estado.equals("0") && !estado.equals(""))
                throw new SQLException(mensaje, "original");
            
        } catch (SQLException e) {
            throw e;    
        } finally {
            cmd.close();
        }
    }
    
    /// <summary>
    /// execute procedure SEARCH
    /// </summary>
    /// <param name="poLst"></param>
    /// <param name="cn"></param>
    /// <param name="cmd"></param>
    /// <param name="sql"></param
    public void runSearch(List<ParameterOracle> poLst, OracleConnection cn,
                                     OracleCallableStatement cmd, String sql) throws SQLException {        
        // control de errores
        try {
            // asignar la conexion al comando
            cmd = (OracleCallableStatement) cn.prepareCall(sql);
            
            // recorrer los parametros
            for (ParameterOracle oParam : poLst) {
                // adicionar los parametros
                addParameter(cmd, oParam);
            }
            
            // ejecutar procedimiento
            cmd.execute();
            
            String estado = "0";
            String mensaje = "";
            
            // recorrer los parametros de salida
            for (OutParameter outParam : outParameters) {
                // obtener valor de parametro
                getOutputParameter(cmd, outParam);
                
                // obtener el Resultado del error
                if (outParam.getNomParam().equals("PO_RESULTADO"))
                    estado = outParam.getValParam().toString();
                // obtener el número de error
                if (outParam.getNomParam().equals("PO_ERR_DESC"))
                    mensaje = outParam.getValParam().toString();                    
            }
            
            if (!estado.equals("0") && !estado.equals(""))
                throw new SQLException(mensaje, "original");
            
            
        } catch (SQLException e) {
            throw e;        
        } finally {
            cmd.close();
        }
    }
    
    /// <summary>
    /// get output parameter
    /// </summary>
    /// <param name="pNomParam"></param>
    public OutParameter getOutputParameter(String pNomParam) {
        // obtener parametro de salida
        OutParameter outParameterAux = null;
        
        Iterator<OutParameter> outParametersIterator = outParameters.iterator();

        while (outParametersIterator.hasNext()){
            outParameterAux = outParametersIterator.next();
            if (outParameterAux.getNomParam().equals(pNomParam))
                break;                                                
            outParameterAux = null;
        }       
        
        return outParameterAux;
    }
    
    /// <summary>
    /// add paramters to procedure
    /// </summary>
    /// <param name="cmd"></param>
    /// <param name="oParam"></param>
    private void addParameter(OracleCallableStatement cmd, ParameterOracle oParam) throws SQLException {
        
        // Establecer Parametros de entrada
        if (oParam.getDireccion() == ParameterDirection.Input) {
            if (oParam.getValParam() == null) {
                cmd.setNull(oParam.getNomParam(), oParam.getTipoDat());
            } else {
                switch (oParam.getTipoDat()) {
                    case OracleTypes.CHAR: case OracleTypes.VARCHAR:
                        //String valueString = (oParam.getValParam() == null) ? oParam.getValParam().toString() : null;
                        //String valueString = oParam.getValParam().toString();
                        cmd.setString(oParam.getNomParam(), oParam.getValParam().toString());                    
                        break;
                    case OracleTypes.NUMBER:
                        //Integer valueInt = (oParam.getValParam() == null) ? (int)oParam.getValParam() : null;
                        //int valueInt = (int)oParam.getValParam();
                        cmd.setInt(oParam.getNomParam(), (int)oParam.getValParam());                                        
                        break;
                    case OracleTypes.DATE:
                        //Date valueDate = (oParam.getValParam() == null) ? (Date)oParam.getValParam() : null;
                        //Date valueDate = (Date)oParam.getValParam();
                        cmd.setDate(oParam.getNomParam(), (Date)oParam.getValParam());
                        break;
                }
            }
        }
        
        // Establecer Parametros de salida
        if (oParam.getDireccion() == ParameterDirection.Output) {
            cmd.registerOutParameter(oParam.getNomParam(), oParam.getTipoDat());
            outParameters.add(new OutParameter(oParam.getNomParam(), oParam.getTipoDat(), null));
        }
    }

    /// <summary>
    /// Get output values
    /// </summary>
    /// <param name="cmd"></param>
    /// <param name="oParam"></param>
    private void getOutputParameter(OracleCallableStatement cmd, OutParameter outParam) throws SQLException{
        
        // obtener valor del parametro
        Object outputParam = null;
            
        switch (outParam.getTipoDat()) {
            case OracleTypes.CHAR: case OracleTypes.VARCHAR:
                outputParam = cmd.getString(outParam.getNomParam());
                outParam.setValParam((outputParam == null) ? "" : outputParam);
                break;
            case OracleTypes.NUMBER: 
                outputParam = cmd.getInt(outParam.getNomParam());
                outParam.setValParam((outputParam == null) ? 0 : outputParam);
                break;
            case OracleTypes.DATE:
                outputParam = cmd.getDate(outParam.getNomParam());
                outParam.setValParam((outputParam == null) ? "" : outputParam);
                break;
            case OracleTypes.CURSOR:
                outputParam = cmd.getObject(outParam.getNomParam());
                outParam.setValParam(outputParam);
                break;
        }
    }    
    
}
