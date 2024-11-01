CLASS /lrn/cl_s4d401_tcd_types_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_TCD_TYPES_1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA var_string TYPE string.
    DATA var_int TYPE i.
    DATA var_date TYPE d.

    var_string = `12345`.
    var_int = var_string.

    out->write(  |String value:  { var_string }| ).
    out->write(  |Integer Value: {  var_int   }| ).

    var_string = `20230101`.
    var_date = var_string.

    out->write(  |String value: { var_string }| ).
    out->write(  |Date Value: {  var_date date = user }| ).

  ENDMETHOD.
ENDCLASS.
