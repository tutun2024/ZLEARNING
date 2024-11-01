CLASS /lrn/cl_s4d401_ood_factory DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
protected section.
private section.
ENDCLASS.



CLASS /LRN/CL_S4D401_OOD_FACTORY IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    " Debug the method to show that the class always returns the same object
    " for the same combination of airline and flight number

    DATA(conn1) = lcl_connection=>get_connection( i_carrier_id    = 'LH'
                                                  i_connection_id = '0400' ).

    DATA(conn2) = lcl_connection=>get_connection( i_carrier_id    = 'LH'
                                                  i_connection_id = '0400' ).

    IF conn1 = conn2.
      out->write( `Factory pattern works fine` ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
