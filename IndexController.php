<?php

require 'config/config.php';
require 'controller.php';

class Index_Controller extends Controller
{

    /**
     *
     * @var Zend_Db_Adapter_Abstract
     */
    public $_db;
    protected $_template = 'index.tpl';
    public $_paths = array (
        'scripts' => 'generated/scripts/',
        'domain' => 'generated/model/',
        'dao_factory' => 'generated/dao/',
        'dao_util' => 'generated/dao/',
        'dao_impl' => 'generated/dao/',
        'dao_interface' => 'generated/dao/',
        'service_factory' => 'generated/service/',
        'service_impl' => 'generated/service/',
        'service_interface' => 'generated/service/'
    );

    public function __construct () {
        $this->_db = $GLOBALS[ 'db' ];
    }

    public function indexAction () {
        $this->getSmarty ()->assign ( "_package_conexion", CONEXION );
        $this->getSmarty ()->assign ( "_package_domain", DOMAIN );
        $this->getSmarty ()->assign ( "_package_dao", PACKAGE_DAO );
        $this->getSmarty ()->assign ( "_package_service", PACKAGE_SERVICE );

        $this->createFirtDirectories ();
        $sql_t = "SELECT OBJECT_NAME TABLES FROM ALL_OBJECTS WHERE OBJECT_TYPE = 'TABLE' AND OWNER = '" . DB_USER . "'";
        $result = $this->_db->fetchAll ( $sql_t );
        $sequences = array ();
        $classFactory = array ();
        $compactScriptPackages = "";
        $compactScript = "";

        foreach ( $result as $item ) {
            $fields = array ();
            $table = $item[ 'TABLES' ];

            $sql_d = "SELECT COLUMN_NAME Field, DATA_TYPE Type, CHARACTER_SET_NAME Collation, Null,
                    (SELECT 
                    DECODE(CONSTRAINT_TYPE,'P','PRI','') AS PRIMARIA FROM ALL_CONS_COLUMNS ACS
                    INNER JOIN ALL_CONSTRAINTS ACO ON ACS.CONSTRAINT_NAME = ACO.CONSTRAINT_NAME
                    WHERE ACS.OWNER = '" . DB_USER . "' AND ACS.TABLE_NAME = '" . $table . "' AND ACO.CONSTRAINT_TYPE='P' AND ROWNUM = 1
                    AND  ACS.COLUMN_NAME=U.COLUMN_NAME) KEY 
                    FROM USER_TAB_COLUMNS  U WHERE TABLE_NAME='" . $table . "'  ORDER BY KEY, FIELD";
            $result = $this->_db->fetchAll ( $sql_d );
            $primary = null;
            $contentDate = false;
            $sequences[] = $table;

            foreach ( $result as $key => $value ) {
                $field = array ();
                $nameFieldTemp = str_replace ( ' ', '', ucwords ( str_replace ( '_', ' ', strtolower ( substr ( $value[ "FIELD" ], 2 ) ) ) ) );
                $nameField = strtolower ( substr ( $nameFieldTemp, 0, 1 ) ) . substr ( $nameFieldTemp, 1 );

                if ( !$primary ) {
                    $primary = true;
                    $this->getSmarty ()->assign ( "_primary", $value[ "FIELD" ] );
                }

                $field [ "attribute" ] = $nameField;
                $field [ "field" ] = $value[ "FIELD" ];
                $field [ "input_field" ] = substr ( $value[ "FIELD" ], 2 );
                $field [ "type" ] = $value[ "TYPE" ];

                $typePhp = null;
                $typeOracle = null;
                $typeAudit = false;

                switch ( $value[ "TYPE" ] ) {
                    case 'DATE':
                        $typePhp = 'DateTime';
                        $contentDate = true;
                        $typeOracle = 'DATE';
                        break;
                    default:
                        if ( count ( explode ( 'CHAR', $value[ "TYPE" ] ) ) >= 2 ) {
                            $typePhp = 'String';
                            $typeOracle = 'CHAR';
                        } else {
                            $typePhp = 'Numeric';
                            $typeOracle = 'NUMBER';
                        }
                        break;
                }

                if ( substr ( $field [ "field" ], 0, 3 ) == "AUD" ) {
                    $typeAudit = true;
                }

                $field [ "typeAttribute" ] = $typePhp;
                $field [ "oracleType" ] = $typeOracle;
                $field [ "typeAudit" ] = $typeAudit;

                $fields[] = $field;
            }

            $this->createDomain ( $table, $fields, $contentDate );
            $compactScriptPackages .= $this->createPackages ( $table, $fields );

            $this->createDaoServiceIfaceImp ( $this->getClassFormatName ( $table ), $table, $fields );

            $classFactory[] = $this->getClassFormatName ( $table );
        }

        $compactScript .= $this->createSequenceScript ( $sequences ) . $compactScriptPackages;

        $this->createCompactScript ( $compactScript );
        $this->createDaoServiceFactory ( $classFactory );
        $this->createDaoUtil ();

        $this->render ();
    }

    public function createDaoUtil () {
        $iConexion = $this->getSmarty ()->fetch ( 'dao/IConexionDao.tpl' );
        $impConexion = $this->getSmarty ()->fetch ( 'dao/ConexionDao.tpl' );

        $dbUtil = $this->getSmarty ()->fetch ( 'dao/util/DBUtil.tpl' );
        $outParameter = $this->getSmarty ()->fetch ( 'dao/util/OutParameter.tpl' );
        $parameterDirection = $this->getSmarty ()->fetch ( 'dao/util/ParameterDirection.tpl' );
        $parameterOracle = $this->getSmarty ()->fetch ( 'dao/util/ParameterOracle.tpl' );

        if ( file_put_contents ( $this->_paths[ 'dao_interface' ] . "IConexionDao.java", $iConexion ) )
            echo "Conexion Interface: IConexionDao.java => Correcto <br/>";
        else
            echo "Conexion Interface: IConexionDao.java => Error <br/>";

        if ( file_put_contents ( $this->_paths[ 'dao_impl' ] . "ConexionDao.java", $impConexion ) )
            echo "Conexion Implement: ConexionDao.java => Correcto <br/>";
        else
            echo "Conexion Implement: ConexionDao.java => Error <br/>";

        if ( file_put_contents ( $this->_paths[ 'dao_util' ] . "DBUtil.java", $dbUtil ) )
            echo "Dao util: DBUtil.java => Correcto <br/>";
        else
            echo "Dao util: DBUtil.java => Error <br/>";

        if ( file_put_contents ( $this->_paths[ 'dao_util' ] . "OutParameter.java", $outParameter ) )
            echo "Dao util: OutParameter.java => Correcto <br/>";
        else
            echo "Dao util: OutParameter.java => Error <br/>";

        if ( file_put_contents ( $this->_paths[ 'dao_util' ] . "ParameterDirection.java", $parameterDirection ) )
            echo "Dao util: ParameterDirection.java => Correcto <br/>";
        else
            echo "Dao util: ParameterDirection.java => Error <br/>";

        if ( file_put_contents ( $this->_paths[ 'dao_util' ] . "ParameterOracle.java", $parameterOracle ) )
            echo "Dao util: ParameterOracle.java => Correcto <br/>";
        else
            echo "Dao util: ParameterOracle.java => Error <br/>";
    }

    public function createDaoServiceIfaceImp ( $class, $table, $fields ) {
        $iInsert = "";
        $iOthers = "";

        foreach ( $fields as $key => $value ) {
            $iOthers .= "?,";
        }

        $iOthers = substr ( $iOthers, 0, -1 );
        $iInsert = substr ( $iOthers, 0, -2 );

        $this->getSmarty ()->assign ( "_class", $class );
        $this->getSmarty ()->assign ( "_table", $table );
        $this->getSmarty ()->assign ( "_iOthers", $iOthers );
        $this->getSmarty ()->assign ( "_iInsert", $iInsert );
        $this->getSmarty ()->assign ( "_flieds", $fields );

        $outputDaoIface = $this->getSmarty ()->fetch ( 'DaoIface.tpl' );
        $outputDaoImpl = $this->getSmarty ()->fetch ( 'DaoImpl.tpl' );
        $outputServiceIface = $this->getSmarty ()->fetch ( 'ServiceIface.tpl' );
        $outputServiceImpl = $this->getSmarty ()->fetch ( 'ServiceImpl.tpl' );

        if ( file_put_contents ( $this->_paths[ 'dao_interface' ] . "I{$class}Dao.java", $outputDaoIface ) )
            echo "Interface: I{$class}Dao.java => Correcto <br/>";
        else
            echo "Interface: I{$class}Dao.java => Error <br/>";

        if ( file_put_contents ( $this->_paths[ 'dao_impl' ] . "{$class}Dao.java", $outputDaoImpl ) )
            echo "Implement: {$class}Dao.java => Correcto <br/>";
        else
            echo "Implement: {$class}Dao.java => Error <br/>";

        if ( file_put_contents ( $this->_paths[ 'service_interface' ] . "I{$class}Service.java", $outputServiceIface ) )
            echo "Interface: I{$class}Service.java => Correcto <br/>";
        else
            echo "Interface: I{$class}Service.java => Error <br/>";

        if ( file_put_contents ( $this->_paths[ 'service_impl' ] . "{$class}Service.java", $outputServiceImpl ) )
            echo "Implement: {$class}Service.java => Correcto <br/>";
        else
            echo "Implement: {$class}Service.java => Error <br/>";
    }

    public function createDaoServiceFactory ( $class ) {
        $this->getSmarty ()->assign ( "_class", $class );

        $outputService = $this->getSmarty ()->fetch ( 'ServiceFactory.tpl' );
        $outputDao = $this->getSmarty ()->fetch ( 'DaoFactory.tpl' );

        if ( file_put_contents ( $this->_paths[ 'service_factory' ] . "FactoryService.java", $outputService ) )
            echo "Service Factory => Correcto <br/>";
        else
            echo "Service Factory => Error <br/>";

        if ( file_put_contents ( $this->_paths[ 'dao_factory' ] . "FactoryDao.java", $outputDao ) )
            echo "Dao Factory => Correcto <br/>";
        else
            echo "Dao Factory => Error <br/>";
    }

    public function createCompactScript ( $compactScript ) {
        if ( file_put_contents ( $this->_paths[ 'scripts' ] . "SCRIPT.SQL", $compactScript ) )
            echo "Compact script => Correcto <br/>";
        else
            echo "Compact script => Error <br/>";
    }

    public function createSequenceScript ( $sequences ) {
        $this->getSmarty ()->assign ( "_fields", $sequences );

        $output = $this->getSmarty ()->fetch ( 'Script.tpl' );

        if ( file_put_contents ( $this->_paths[ 'scripts' ] . "SEQUENCES.SQL", $output ) )
            echo "Sequence script => Correcto <br/>";
        else
            echo "Sequence script => Error <br/>";

        return $output;
    }

    public function createPackages ( $table, $fields ) {
        $this->getSmarty ()->assign ( "_count_fields", count ( $fields ) );
        $this->getSmarty ()->assign ( "_fields", $fields );
        $this->getSmarty ()->assign ( "_table", $table );

        $output = $this->getSmarty ()->fetch ( 'Packages.tpl' );

        if ( file_put_contents ( $this->_paths[ 'scripts' ] . "PKG_$table.pck", $output ) )
            echo "Package: $table => Correcto <br/>";
        else
            echo "Package: $table => Error <br/>";

        return $output;
    }

    public function createDomain ( $table, $fields ) {
        $className = $this->getClassFormatName ( $table );
        $containDate = false;

        foreach ( $fields as $key => $value ) {
            if ( $value[ 'typeAttribute' ] == 'DateTime' ) {
                $containDate = true;
            }
        }

        $this->getSmarty ()->assign ( "_fields", $fields );
        $this->getSmarty ()->assign ( "_table", $table );
        $this->getSmarty ()->assign ( "_className", $className );
        $this->getSmarty ()->assign ( "_containDate", $containDate );

        $output = $this->getSmarty ()->fetch ( 'Domain.tpl' );

        if ( file_put_contents ( $this->_paths[ 'domain' ] . "$className.java", $output ) )
            echo "Domain: $className.java => Correcto <br/>";
        else
            echo "Domain: $className.java => Error <br/>";
    }

    public function createFirtDirectories () {
        $this->_paths[ 'domain' ] = $this->_paths[ 'domain' ] . 'src/' . str_replace ( '.', '/', DOMAIN ) . '/';

        $this->_paths[ 'dao_factory' ] = $this->_paths[ 'dao_factory' ] . 'src/' . str_replace ( '.', '/', PACKAGE_DAO ) . '/';
        $this->_paths[ 'dao_util' ] = $this->_paths[ 'dao_factory' ] . '/common/util/';
        $this->_paths[ 'dao_interface' ] = $this->_paths[ 'dao_factory' ] . '/iface/';
        $this->_paths[ 'dao_impl' ] = $this->_paths[ 'dao_factory' ] . '/impl/';

        $this->_paths[ 'service_factory' ] = $this->_paths[ 'service_factory' ] . 'src/' . str_replace ( '.', '/', PACKAGE_SERVICE ) . '/';
        $this->_paths[ 'service_interface' ] = $this->_paths[ 'service_factory' ] . '/iface/';
        $this->_paths[ 'service_impl' ] = $this->_paths[ 'service_factory' ] . '/impl/';

        if ( !is_dir ( $this->_paths[ 'scripts' ] ) )
            mkdir ( $this->_paths[ 'scripts' ], 777, true );

        if ( !is_dir ( $this->_paths[ 'domain' ] ) )
            mkdir ( $this->_paths[ 'domain' ], 777, true );

        if ( !is_dir ( $this->_paths[ 'dao_factory' ] ) )
            mkdir ( $this->_paths[ 'dao_factory' ], 777, true );

        if ( !is_dir ( $this->_paths[ 'dao_util' ] ) )
            mkdir ( $this->_paths[ 'dao_util' ], 777, true );

        if ( !is_dir ( $this->_paths[ 'dao_interface' ] ) )
            mkdir ( $this->_paths[ 'dao_interface' ], 777, true );

        if ( !is_dir ( $this->_paths[ 'dao_impl' ] ) )
            mkdir ( $this->_paths[ 'dao_impl' ], 777, true );

        if ( !is_dir ( $this->_paths[ 'service_factory' ] ) )
            mkdir ( $this->_paths[ 'service_factory' ], 777, true );

        if ( !is_dir ( $this->_paths[ 'service_interface' ] ) )
            mkdir ( $this->_paths[ 'service_interface' ], 777, true );

        if ( !is_dir ( $this->_paths[ 'service_impl' ] ) )
            mkdir ( $this->_paths[ 'service_impl' ], 777, true );
    }

    public function getClassFormatName ( $table ) {
        return str_replace ( ' ', '', ucwords ( str_replace ( '_', ' ', strtolower ( str_replace ( 'TAB_', '', $table ) ) ) ) );
    }

}

/* Lectura de Cabecera */
$controller = new Index_Controller();
$controller->_db = $db;
$controller->run ();
