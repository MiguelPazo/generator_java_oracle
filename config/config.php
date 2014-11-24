<?php

session_start ();
date_default_timezone_set ( 'America/Lima' );

header ( 'Content-Type: text/html; charset=utf-8' );
putenv ( 'NLS_LANG=american_america.UTF8' );

defined ( 'BASE_URL' ) || define ( 'BASE_URL', '' );
defined ( 'CONEXION' ) || define ( 'CONEXION', 'pe.gob.onpe.sea.conn' );
defined ( 'DOMAIN' ) || define ( 'DOMAIN', 'pe.gob.onpe.sea.usb.domain' );
defined ( 'PACKAGE_DAO' ) || define ( 'PACKAGE_DAO', 'pe.gob.onpe.sea.usb.dao' );
defined ( 'PACKAGE_SERVICE' ) || define ( 'PACKAGE_SERVICE', 'pe.gob.onpe.sea.usb.service' );
defined ( 'DOCUMENT_ROOT' ) || define ( 'DOCUMENT_ROOT', realpath ( dirname ( __FILE__ ) . '/../' ) . '/' );

define ( 'DB_SERVER', '(DESCRIPTION=
    (ADDRESS=
      (PROTOCOL=TCP)
      (HOST=192.168.48.52)
      (PORT=1521)               
    )
    (CONNECT_DATA=
      (SERVER=dedicated)
      (SERVICE_NAME=dc3r4t1b)
    )
  )' );
define ( 'DB_USER', 'SEA' );
define ( 'DB_PASS', 'SEA' );

set_include_path ( implode ( PATH_SEPARATOR, array (
    realpath ( DOCUMENT_ROOT . '/libs' ),
    realpath ( DOCUMENT_ROOT . '/model' ),
    get_include_path (),
) ) );

# Carga las librerias base
require 'smarty/libs/Smarty.class.php';
require 'Zend/Db.php';
require 'Zend/Debug.php';
require 'App/Utilities.php';

$db = Zend_Db::factory ( 'pdo_oci', array (
            'dbname' => DB_SERVER,
            'username' => DB_USER,
            'password' => DB_PASS
        ) );

$utilities = new App_Utilities();

$smarty = new Smarty();
$smarty->template_dir = DOCUMENT_ROOT . 'templates/tpl';
$smarty->compile_dir = DOCUMENT_ROOT . 'templates/compile';
$smarty->cache_dir = DOCUMENT_ROOT . 'templates/cache';
$smarty->config_dir = DOCUMENT_ROOT . 'templates/config';
$smarty->caching = false; /* Cambiar a 'true' de ser necesario */
$smarty->compile_check = true;
$smarty->debugging = false;
