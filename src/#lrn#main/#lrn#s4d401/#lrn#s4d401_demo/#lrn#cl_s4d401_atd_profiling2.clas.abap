CLASS /lrn/cl_s4d401_atd_profiling2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_ATD_PROFILING2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA(connections) = lcl_data=>get_connections(
     ).
    SORT connections BY carrier_id connection_id  ASCENDING.

    LOOP AT connections INTO DATA(connection).

      DATA(city_from) = lcl_data=>get_airport_city( connection-airport_from_id ).
      DATA(city_to)   = lcl_data=>get_airport_city( connection-airport_to_id   ).

      DATA(text) = |Flight { connection-carrier_id } { connection-connection_id } | &&
                     |from { city_from } to { city_to } |.

      out->write(  `----------------------------------------------------------------` ).
      out->write( text ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
