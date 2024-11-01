CLASS /lrn/cl_s4d401_dbd_arithmetic DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_ARITHMETIC IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    SELECT FROM /dmo/flight
         FIELDS seats_max,
                seats_occupied,

                seats_max - seats_occupied           AS seats_avaliable,

                (   CAST( seats_occupied AS FLTP )
                  * CAST( 100 AS FLTP )
                ) / CAST(  seats_max AS FLTP )       AS percentage_fltp

           WHERE carrier_id = 'LH'
            INTO TABLE @DATA(result).

    out->write(
      EXPORTING
        data   = result
        name   = 'RESULT'
    ).

  ENDMETHOD.
ENDCLASS.
