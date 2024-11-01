CLASS /lrn/cl_s4d401_csd_functions_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_CSD_FUNCTIONS_1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA text TYPE string      VALUE `  SAP BTP, ABAP environment  `.

    out->write( |Input String              = { text }<end>|  ).


* Description Function (returns integer value)
**********************************************************************

    DATA result_int TYPE i.

    result_int = numofchar(  text ) .

    out->write( |NUMOFCHAR                 = { result_int }  | ).


    result_int = find(  val = text sub = 'env' ).

    out->write( |FIND  'env'               = { result_int }  | ).

* Processing Function (returns string value)
**********************************************************************

    DATA result_string TYPE string.

    result_string = replace(  val = text sub = 'env' with = 'Env' ).

    out->write( |REPLACE 'env' with 'Env'  = { result_string }  | ).

* Predicate Function ( serves as a logical expression )
**********************************************************************

    IF contains(  val = text  sub = 'env' ).

      out->write( |CONTAINS 'env'            is true | ).

    ELSE.

      out->write( |CONTAINS 'env'            is false | ).

    ENDIF.

    " use function XSDBOOL(  ) to convert predicate function
    " to values 'X' (for true) and ' ' (for false)

    DATA result_char1 TYPE abap_bool.   "TYPE c LENGTH 1.
    result_char1 = xsdbool(  contains(  val = text sub = 'env' ) ).

    out->write( |XSDBOOL( CONTAINS 'env' ) = { result_char1 }| ).


  ENDMETHOD.
ENDCLASS.
