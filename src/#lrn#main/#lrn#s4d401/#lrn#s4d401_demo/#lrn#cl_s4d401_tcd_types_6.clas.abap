CLASS /lrn/cl_s4d401_tcd_types_6 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_TCD_TYPES_6 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA var_date TYPE d.
    DATA var_pack TYPE p LENGTH 3 DECIMALS 2.
    DATA var_string TYPE string.
    DATA var_char TYPE c LENGTH 3.

    var_pack = 1 / 8.

    out->write(  |Standard conversion: 1/8 -> { var_pack } | ).
    TRY.
        var_pack = EXACT #(  1 / 8 ).
      CATCH cx_sy_conversion_error.
        out->write(  |Result is rounded. EXACT triggers an exception| ).
    ENDTRY.

    out->write(  `------------------------------------` ).

    var_char = 'ABCDE'.

    out->write(  |Standard conversion: ABCDE -> { var_char } | ).

    TRY.
        var_char = EXACT #( 'ABCDE' ).
      CATCH cx_sy_conversion_error.
        out->write( 'Result is truncated. EXACT triggers an exception' ).
    ENDTRY.

    out->write(  `------------------------------------` ).

    var_date = 'ABCDEFGH'.

    out->write(  |Standard conversion: ABCDEFGH -> { var_date } | ).

    TRY.
        var_date = EXACT #(  'ABCDEFGH' ).

      CATCH cx_sy_conversion_error.
        out->write(  |Invalid date. EXACT triggers an exception| ).
    ENDTRY.

    out->write(  `------------------------------------` ).

    var_date = '20221232'.
    out->write(  |Standard conversion: 20221232 -> { var_date } | ).

    TRY.
        var_date = EXACT #( '20221232' ).
      CATCH cx_sy_conversion_error.
        out->write(  |Invalid date. EXACT triggers an exception| ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
