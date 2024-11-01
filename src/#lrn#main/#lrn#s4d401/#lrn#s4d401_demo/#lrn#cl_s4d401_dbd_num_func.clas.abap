CLASS /lrn/cl_s4d401_dbd_num_func DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_NUM_FUNC IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    SELECT FROM /dmo/flight
         FIELDS seats_max,
                seats_occupied,

                (   CAST( seats_occupied AS FLTP )
                  * CAST( 100 AS FLTP )
                ) / CAST(  seats_max AS FLTP )                  AS percentage_fltp,

                div( seats_occupied * 100 , seats_max )         AS percentage_int,

                division(  seats_occupied * 100, seats_max, 2 ) AS percentage_dec

          WHERE carrier_id    = 'LH'
           INTO TABLE @DATA(result).

    out->write(
      EXPORTING
        data   = result
        name   = 'RESULT'
    ).

  ENDMETHOD.
ENDCLASS.
