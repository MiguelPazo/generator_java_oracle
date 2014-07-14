package #{$_package_dao}#.iface;

/**
 *
 * @author Miguel Pazo
 */
public interface IConexionDao {
    void ConexionOpen();
    void ConexionClose();
    void AddTransaction();
    void SaveChanges();
    void CancelChanges();
}
