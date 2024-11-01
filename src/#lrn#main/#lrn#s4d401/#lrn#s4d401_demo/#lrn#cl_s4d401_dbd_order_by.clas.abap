CLASS /lrn/cl_s4d401_dbd_order_by DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_ORDER_BY IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT FROM /dmo/flight
         FIELDS carrier_id,
                connection_id,
                flight_date,
                seats_max - seats_occupied AS seats
          WHERE carrier_id     = 'AA'
            AND plane_type_id  = 'A320-200'
           INTO TABLE @DATA(result1).

    out->write(
        data   = result1
        name   = 'Unordered'
    ).

********************************************************
    out->write( `--------------------------------------------`  ).
    SELECT FROM /dmo/flight
         FIELDS carrier_id,
                connection_id,
                flight_date,
                seats_max - seats_occupied AS seats
          WHERE carrier_id     = 'AA'
            AND plane_type_id  = 'A320-200'
        ORDER BY connection_id DESCENDING
           INTO TABLE @DATA(result2).

    out->write(
        data   = result2
        name   = 'Order by CONNECTION_ID (desc)'
              ).

********************************************************
    out->write( `--------------------------------------------`  ).
    SELECT FROM /dmo/flight
         FIELDS carrier_id,
                connection_id,
                flight_date,
                seats_max - seats_occupied AS seats
          WHERE carrier_id     = 'AA'
            AND plane_type_id  = 'A320-200'
        ORDER BY connection_id DESCENDING,
                 seats_max - seats_occupied ASCENDING
           INTO TABLE @DATA(result3).

    out->write(
        data   = result3
        name   = 'Order by CONNECTION_ID (desc), SEATS (asc)'
              ).

  ENDMETHOD.
ENDCLASS.
