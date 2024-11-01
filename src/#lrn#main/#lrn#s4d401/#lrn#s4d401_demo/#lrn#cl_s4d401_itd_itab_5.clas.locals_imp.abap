*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_demo DEFINITION.
  PUBLIC SECTION.

    METHODS use_work_area.
    METHODS use_field_symbol.

  PRIVATE SECTION.

    TYPES tt_flights TYPE STANDARD TABLE OF /lrn/passflight
                     WITH NON-UNIQUE KEY carrier_id connection_id flight_date.

    METHODS loop_field_symbol
      CHANGING
        c_flights TYPE tt_flights.
    METHODS loop_work_area
      CHANGING
        c_flights TYPE tt_flights.

ENDCLASS.

CLASS lcl_demo IMPLEMENTATION.

  METHOD use_field_symbol.

    DATA flights TYPE tt_flights.

    SELECT
      FROM /lrn/passflight
    FIELDS *
      INTO TABLE @flights.

    loop_field_symbol( CHANGING c_flights = flights ).

  ENDMETHOD.

  METHOD use_work_area.

    DATA flights TYPE tt_flights.

    SELECT
      FROM /lrn/passflight
    FIELDS *
      INTO TABLE @flights.

    loop_work_area( CHANGING c_flights = flights  ).
  ENDMETHOD.

  METHOD loop_field_symbol.

    LOOP AT c_flights ASSIGNING FIELD-SYMBOL(<flight>).
      <flight>-seats_occupied = <flight>-seats_occupied + 1.
    ENDLOOP.

  ENDMETHOD.

  METHOD loop_work_area.
    LOOP AT c_flights INTO DATA(flight).
      flight-seats_occupied = flight-seats_occupied + 1.
      MODIFY c_flights FROM flight.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
