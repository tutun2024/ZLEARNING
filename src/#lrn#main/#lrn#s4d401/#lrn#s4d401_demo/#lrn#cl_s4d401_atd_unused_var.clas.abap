CLASS /lrn/cl_s4d401_atd_unused_var DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_ATD_UNUSED_VAR IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA carrier_list    TYPE TABLE OF /dmo/carrier.
    DATA connection_list TYPE TABLE OF /dmo/connection.

    SELECT FROM /dmo/connection
      FIELDS *
      INTO TABLE @DATA(connections).

    connection_list = connection_list.

    out->write( connection_list ).

  ENDMETHOD.
ENDCLASS.
