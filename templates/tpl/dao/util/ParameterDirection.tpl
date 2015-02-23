package #{$_package_dao}#.common.util;

/**
 *
 * @author Miguel Rodrigo Pazo Sánchez (http://miguelpazo.com/)
 */
public enum ParameterDirection {
    // Resumen:
    //     Se trata de un parámetro de entrada.
    // = 1
    Input,
    //
    // Resumen:
    //     Se trata de un parámetro de salida.
    // = 2
    Output,
    //
    // Resumen:
    //     El parámetro puede ser de entrada o de salida.
    // = 3
    InputOutput,
    //
    // Resumen:
    //     El parámetro representa un valor devuelto de una operación como un procedimiento
    //     almacenado, una función integrada o una función definida por el usuario.
    // = 6
    ReturnValue, 
    
}
