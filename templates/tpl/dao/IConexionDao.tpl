package #{$_package_dao}#.iface;

/**
 *
 * @author Miguel Rodrigo Pazo Sánchez (http://miguelpazo.com/)
 */
public interface IConexionDao {
    void ConexionOpen();
    void ConexionClose();
    void AddTransaction();
    void SaveChanges();
    void CancelChanges();
}
