*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_flights DEFINITION.
  PUBLIC SECTION.

    METHODS constructor.
    METHODS access_standard.
    METHODS access_sorted.
    METHODS access_hashed.

  PRIVATE SECTION.

    DATA standard_table TYPE STANDARD TABLE OF /lrn/passflight
                        WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
    DATA sorted_table   TYPE SORTED TABLE OF /lrn/passflight
                        WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
    DATA hashed_table   TYPE HASHED TABLE OF /lrn/passflight
                        WITH UNIQUE KEY carrier_id connection_id flight_date.

    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.
    DATA flight_date   TYPE /dmo/flight_date.

    METHODS set_line_to_read.

ENDCLASS.

CLASS lcl_flights IMPLEMENTATION.

  METHOD constructor.

    SELECT
      FROM /lrn/passflight
    FIELDS *
      INTO TABLE @standard_table.

    SELECT
      FROM /lrn/passflight
    FIELDS *
      INTO TABLE @sorted_table.

    SELECT
      FROM /lrn/passflight
    FIELDS *
      INTO TABLE @hashed_table.

    set_line_to_read(  ).

  ENDMETHOD.

  METHOD access_standard.

    DATA(result) = standard_table[ carrier_id    = me->carrier_id
                                   connection_id = me->connection_id
                                   flight_date   = me->flight_date
                                 ].
  ENDMETHOD.

  METHOD access_sorted.

    DATA(result) = sorted_table[ carrier_id = me->carrier_id
                                 connection_id = me->connection_id
                                 flight_date = me->flight_date
                               ].
  ENDMETHOD.

  METHOD access_hashed.

    DATA(result) = hashed_table[ carrier_id = me->carrier_id
                                 connection_id = me->connection_id
                                 flight_date = me->flight_date
                               ].
  ENDMETHOD.

  METHOD set_line_to_read.

   DATA(index) = lines( standard_table ) * 65 / 100.
   DATA(line) = standard_table[ index ].

   me->carrier_id = line-carrier_id.
   me->connection_id = line-connection_id.
   me->flight_date = line-flight_date.

  ENDMETHOD.

ENDCLASS.
