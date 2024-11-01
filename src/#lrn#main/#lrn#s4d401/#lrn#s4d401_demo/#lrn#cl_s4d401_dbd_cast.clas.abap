CLASS /lrn/cl_s4d401_dbd_cast DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_CAST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT SINGLE FROM /dmo/carrier
         FIELDS '19891109'                           AS char_8,
                CAST( '19891109' AS CHAR( 4 ) )      AS char_4,
                CAST( '19891109' AS NUMC( 8  ) )     AS numc_8,

                CAST( '19891109' AS INT4 )          AS integer,
                CAST( '19891109' AS DEC( 10, 2 ) )  AS dec_10_2,
                CAST( '19891109' AS FLTP )          AS fltp,

                CAST( '19891109' AS DATS )          AS date
          WHERE carrier_id = 'AA'
           INTO @DATA(result).

    out->write(
      EXPORTING
        data   = result
        name   = `Cast '19891109' to different types`
    ).

  ENDMETHOD.
ENDCLASS.
