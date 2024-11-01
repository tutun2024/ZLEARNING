CLASS /lrn/cl_s4d401_atd_unit2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_ATD_UNIT2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*constants c_carrier_id type /dmo/carrier_id value 'LH'.
    CONSTANTS c_carrier_id TYPE /dmo/carrier_id VALUE 'XX'.

    TRY.
        DATA(carrier) = new lcl_carrier( c_carrier_id ).

        out->write( | Carrier { carrier->get_name(  ) } has currency {  carrier->get_currency(  ) }| ).

      CATCH cx_abap_invalid_value.
        out->write( | Carrier {  c_carrier_id } does not exist | ).
    ENDTRY.


  ENDMETHOD.
ENDCLASS.
