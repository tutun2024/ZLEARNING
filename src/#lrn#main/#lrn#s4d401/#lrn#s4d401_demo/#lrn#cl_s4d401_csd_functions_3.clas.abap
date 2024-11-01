CLASS /lrn/cl_s4d401_csd_functions_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_CSD_FUNCTIONS_3 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

     DATA result TYPE i.

    DATA text    TYPE string VALUE `  ABAP  `.
    DATA substring TYPE string VALUE `AB`.
    DATA offset    TYPE i      VALUE 1.

* Call different description functions
******************************************************************************

    out->write( |Input string: '{ text }'| ).
    out->write( `----------------------------------` ).

    result = strlen( text ).
    out->write( |Strlen:              { result }| ).

    result = numofchar(  text ).
    out->write( |Numofchar:           { result }| ).

     result = count(             val = text sub = substring off = offset ).
    out->write( |Count { substring }:            { result }| ).

    result = find(             val = text sub = substring off = offset ).
    out->write( |Find { substring }:             { result }| ).

    result = count_any_of(     val = text sub = substring off = offset ).
    out->write( |Count_any_of { substring }:     { result }| ).

    result = find_any_of(      val = text sub = substring off = offset ).
    out->write( |Find_any_of { substring }:      { result }| ).

    result = count_any_not_of( val = text sub = substring off = offset ).
    out->write( |Count_any_not_of { substring }: { result }| ).

    result = find_any_not_of(  val = text sub = substring off = offset ).
    out->write( |Find_any_not_of { substring }:  { result }| ).

  ENDMETHOD.
ENDCLASS.
