CLASS /lrn/cl_s4d401_dbd_case DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_CASE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    SELECT FROM /dmo/customer
        FIELDS customer_id,
               title,
               CASE title
                 WHEN 'Mr.'  THEN 'Mister'
                 WHEN 'Mrs.' THEN 'Misses'
                 ELSE             ' '
              END AS title_long

        WHERE country_code = 'AT'
         INTO TABLE @DATA(result_simple).

    out->write(
      EXPORTING
        data   = result_simple
        name   = 'Simple Case Distinction'
    ).

**********************************************************************
 out->write(  `-----------------------------------------------` ).

    SELECT FROM /dmo/flight
         FIELDS flight_date,
                seats_max,
                seats_occupied,
                CASE
                  WHEN seats_occupied < seats_max THEN 'Seats Avaliable'
                  WHEN seats_occupied = seats_max THEN 'Fully Booked'
                  WHEN seats_occupied > seats_max THEN 'Overbooked!'
                  ELSE                                 'This is impossible'
                END AS booking_state

          WHERE carrier_id    = 'LH'
            AND connection_id = '0400'
           INTO TABLE @DATA(result_complex).

    out->write(
      EXPORTING
        data   = result_complex
        name   = 'Complex Case Distinction'
    ).

  ENDMETHOD.
ENDCLASS.
