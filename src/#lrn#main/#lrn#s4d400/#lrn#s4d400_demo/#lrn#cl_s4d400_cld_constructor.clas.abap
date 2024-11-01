CLASS /lrn/cl_s4d400_cld_constructor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D400_CLD_CONSTRUCTOR IMPLEMENTATION.


   METHOD if_oo_adt_classrun~main.

    DATA connection  TYPE REF TO lcl_connection.

    DATA connections TYPE TABLE OF REF TO lcl_connection.

* constructor for class lcl_connection
* consistency checks inside constructor
* no forgetting or repeating for same instance
**********************************************************************

    TRY.
        connection = NEW #( carrier_id    = 'LH'
                            connection_id = '0400' ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Creating instance failed` ).
    ENDTRY.


* If constructor raises exception:
* Result of NEW #( ) is the NULL reference
**********************************************************************

    TRY.
        connection = NEW #( carrier_id    = '  '
                            connection_id = '0000' ).

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Creating instance failed` ).
    ENDTRY.


      ENDMETHOD.
ENDCLASS.
