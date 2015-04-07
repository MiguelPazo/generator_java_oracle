package #{$_package_dao}#.common.util;

import java.sql.Date;
import oracle.jdbc.OracleResultSet;

/**
 *
 * @author Miguel Rodrigo Pazo Sánchez (http://miguelpazo.com/)
 */
public class OutParameter {
    private String nomParam;
    private int tipoDat;
    private Object valParam;
 
    public OutParameter(){        
    }

    public OutParameter(String pNomParam, int pTipoDat, Object pValParam) {
        nomParam = pNomParam;
        tipoDat = pTipoDat;
        valParam = pValParam;
    }
    
    public String getNomParam() {
        return nomParam;
    }

    public void setNomParam(String nomParam) {
        this.nomParam = nomParam;
    }

    public Object getValParam() {
        return valParam;
    }

    public void setValParam(Object valParam) {
        this.valParam = valParam;
    }

    public int getTipoDat() {
        return tipoDat;
    }

    public void setTipoDat(int tipoDat) {
        this.tipoDat = tipoDat;
    }
    
    public int getParameterInt(){
        return (Integer) valParam;
    }
    
    public String getParameterString(){
        return valParam.toString();
    }
    
    public Date getParameterDate(){
        return (Date) valParam;
    }
    
    public OracleResultSet getParameterResultSet(){
        return (OracleResultSet) valParam;
    }
}
