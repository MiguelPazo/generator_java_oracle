<?php

class App_Utilities
{

    /**
     *
     * @param  String $stringDateTime String DateTime with format DD/MM/YYYY H:i:s
     */
    public function stringToDateTime ( $stringDateTime ) {
        if ( $stringDateTime ) {
            $dateTime = new DateTime();

            $parseDateTime = explode ( ' ', $stringDateTime );

            $parseDate = explode ( '/', $parseDateTime[ 0 ] );
            $dateTime->setDate ( substr ( $parseDate[ 2 ], 0, 4 ), $parseDate[ 1 ], $parseDate[ 0 ] );

            if ( array_key_exists ( 1, $parseDateTime ) ) {
                $parseTime = explode ( ':', $parseDateTime[ 1 ] );
                $dateTime->setTime ( $parseTime[ 0 ], $parseTime[ 1 ], $parseTime[ 2 ] );
            }

            return $dateTime;
        } else {
            return null;
        }
    }

}
