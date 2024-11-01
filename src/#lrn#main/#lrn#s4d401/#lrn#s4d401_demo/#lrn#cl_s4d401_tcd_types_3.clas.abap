CLASS /lrn/cl_s4d401_tcd_types_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_TCD_TYPES_3 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA var_date   TYPE d.
    DATA var_int    TYPE i.
    DATA var_string TYPE string.
    DATA var_n      TYPE n LENGTH 4.

    var_date = cl_abap_context_info=>get_system_date( ).
    var_int = var_date.

    out->write( |Date to Integer:  { var_date } -> { var_int }| ).

    var_string = `R2D2`.
    var_n = var_string.

    out->write( |String to type N: { var_string } -> {  var_n }| ).

  ENDMETHOD.
ENDCLASS.
