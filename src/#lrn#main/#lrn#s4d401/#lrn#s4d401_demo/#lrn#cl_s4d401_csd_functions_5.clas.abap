CLASS /lrn/cl_s4d401_csd_functions_5 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_CSD_FUNCTIONS_5 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

   DATA text TYPE string      VALUE ` SAP BTP,   ABAP Environment  `.

    out->write( |Input string:          '{ text }'| ).
    out->write( `------------------------------------------------------------------` ).

* Check if a string contains a certain substring
**********************************************************************
    out->write( |CONTAINS 'ABC':                          { xsdbool( contains( val = text sub   = 'ABAP' ) ) } | ).
    out->write( |CONTAINS 'ABC', off = 20:                { xsdbool( contains( val = text sub   = 'ABAP' off = 20 ) ) } | ).
    out->write( |CONTAINS 'ABC', start ='ABAP', off = 12: { xsdbool( contains( val = text start = 'ABAP' off = 12 ) ) } | ).

* Check if a string contains any characters from a list of characters
**********************************************************************
    out->write( |CONTAINS_ANY_OF 'ABC':                   { xsdbool( contains_any_of( val = text sub   = 'ABC' ) ) } | ).
    out->write( |CONTAINS_ANY_OF 'XYZ':                   { xsdbool( contains_any_of( val = text sub   = 'XYZ' ) ) } | ).

* Check if a string contains any characters outside of a list of characters
*****************************************************************************
    out->write( |CONTAINS_ANY_NOT_OF 'ABC':               { xsdbool( contains_any_not_of( val = text sub   = 'ABC' ) ) } | ).
    out->write( |CONTAINS_ANY_NOT_OF 'XYZ':               { xsdbool( contains_any_not_of( val = text sub   = 'XYZ' ) ) } | ).

  ENDMETHOD.
ENDCLASS.
