<?php

class App_Controller
{

    private $_params;
    private $_smarty;
    private $_jscript;

    public function __construct ( $params = array () ) {
        $this->_smarty = $GLOBALS[ 'smarty' ];
        $this->_params = $_POST + $_GET + $params;
    }

    public function render ( $template, $layout = 'layout.tpl' ) {
        $this->_smarty->assign ( '_BASE_URL', BASE_URL );

        if ( $this->_jscript ) {
            $this->_smarty->assign ( '_jscript', $this->_jscript );
        }

        if ( $this->validateAjax () ) {
            $this->_smarty->display ( $template );
        } else {
            $content = $this->getSmarty ()->fetch ( $template );
            $this->_smarty->assign ( '_content', $content );
            $this->_smarty->display ( $layout );
        }
    }

    public function validateAjax () {
        if ( !empty ( $_SERVER[ 'HTTP_X_REQUESTED_WITH' ] ) && strtolower ( $_SERVER[ 'HTTP_X_REQUESTED_WITH' ] ) == 'xmlhttprequest' ) {
            return true;
        } else {
            return false;
        }
    }

    public function validAccess () {
        if ( key_exists ( 'userLogin', $_SESSION ) ) {
            if ( $_SESSION[ 'userLogin' ] != null && $_SESSION[ 'userLogin' ] != '' ) {
                return true;
            }
        }
        return false;
    }

    public function addJscript ( $script ) {
        $this->_jscript .= $script;
    }

    public function getSmarty () {
        return $this->_smarty;
    }

    public function getParam ( $param, $default = null ) {
        if ( array_key_exists ( $param, $this->_params ) )
            return $this->_params[ $param ];
        else if ( $default )
            return $default;
        else
            return null;
    }

    public function getParams () {
        return $this->_params;
    }

    function __call ( $name, $arguments ) {
        echo 'Su intento de hack ha sido registrado!';
    }

}
