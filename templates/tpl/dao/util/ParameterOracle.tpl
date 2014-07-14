package #{$_package_dao}#.common.util;

/**
 *
 * @author Miguel Pazo
 */
public class ParameterOracle {
    //Atributos
    private String nomParam;
    private Object valParam;
    private int typeDat;
    private ParameterDirection direction;
    
    public ParameterOracle() {        
    }
    
    public ParameterOracle(String pNomParam, Object pValParam, 
                      int pTipoDat, ParameterDirection pDireccion){
        nomParam = pNomParam;
        valParam = pValParam;
        typeDat = pTipoDat;
        direction = pDireccion;
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
        return typeDat;
    }

    public void setTipoDat(int typeDat) {
        this.typeDat = typeDat;
    }

    public ParameterDirection getDireccion() {
        return direction;
    }

    public void setDireccion(ParameterDirection direction) {
        this.direction = direction;
    }
 
}
