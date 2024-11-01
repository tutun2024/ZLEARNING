CLASS /lrn/cl_s4d401_atd_pragmas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_ATD_PRAGMAS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    " ATC finding not suppressed
    DATA unused1 TYPE string.

    " ATC finding suppressed using Pseudo-Comment
    DATA unused2 TYPE string.                               "#EC NEEDED

    " ATC finding suppressed using Pragma
    DATA unused3 TYPE string                           ##needed.

    out->write(  `Done` ).
  ENDMETHOD.
ENDCLASS.
