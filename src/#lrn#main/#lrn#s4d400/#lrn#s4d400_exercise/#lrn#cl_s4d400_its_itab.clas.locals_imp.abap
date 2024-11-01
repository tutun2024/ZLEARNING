*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_connection DEFINITION.

  PUBLIC SECTION.

    CLASS-DATA conn_counter TYPE i.
    CLASS-METHODS class_constructor.

    METHODS constructor
      IMPORTING
        i_connection_id TYPE /dmo/connection_id
        i_carrier_id    TYPE /dmo/carrier_id
      RAISING
        cx_ABAP_INVALID_VALUE .

    METHODS get_output
      RETURNING
        VALUE(r_output) TYPE string_table.

  PROTECTED SECTION.

  PRIVATE SECTION.


    TYPES:
      BEGIN OF st_details,
        DepartureAirport   TYPE /dmo/airport_from_id,
        DestinationAirport TYPE /dmo/airport_to_id,
        AirlineName        TYPE /dmo/carrier_name,
      END OF st_details.

    TYPES:
      BEGIN OF st_airport,
        AirportId TYPE /dmo/airport_id,
        Name      TYPE /dmo/airport_name,
      END OF st_airport.

    TYPES tt_airports TYPE STANDARD TABLE OF st_airport
                           WITH NON-UNIQUE DEFAULT KEY.

    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.

*    DATA airport_from_id TYPE /dmo/airport_from_id.
*    DATA airport_to_id   TYPE /dmo/airport_to_id.
*
*    DATA carrier_name    TYPE /dmo/carrier_name.

    DATA details TYPE st_details.

    CLASS-DATA airports TYPE tt_airports.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.

  METHOD class_constructor.

    SELECT FROM /DMO/I_Airport
         FIELDS AirportID, Name
       INTO TABLE @airports.

  ENDMETHOD.

  METHOD constructor.

    " ensure non-initial input
    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    " check existence and read additional data
    SELECT SINGLE
      FROM /DMO/I_Connection
    FIELDS DepartureAirport, DestinationAirport, \_Airline-Name AS AirlineName
     WHERE AirlineID    = @i_carrier_id
       AND ConnectionID = @i_connection_id
*      INTO ( @airport_from_id, @airport_to_id, @carrier_name  ).
      INTO CORRESPONDING FIELDS OF @details.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    me->connection_id = i_connection_id.
    me->carrier_id    = i_carrier_id.

    conn_counter = conn_counter + 1.

  ENDMETHOD.

  METHOD get_output.

    " Read airport names from internal table airports
    DATA(departure)   = airports[ airportID = details-departureairport   ].
    DATA(destination) = airports[ airportID = details-destinationairport ].

    APPEND |--------------------------------|                    TO r_output.
    APPEND |Carrier:     { carrier_id } { details-airlinename }| TO r_output.
    APPEND |Connection:  { connection_id   }|                    TO r_output.
    "APPEND |Departure:   { details-departureairport     }|       TO r_output.
    "APPEND |Destination: { details-destinationairport   }|       TO r_output.
    APPEND |Departure:   { details-departureairport   } { departure-name   }| TO r_output.
    APPEND |Destination: { details-destinationairport } { destination-name }| TO r_output.

* Optional: Chained expressions without helper variables departure and destination
*    APPEND |Departure:   { details-departureairport   } { airports[ airportid = details-departureairport   ]-name }| TO r_output.
*    APPEND |Destination: { details-destinationairport } { airports[ airportid = details-destinationairport ]-name }| TO r_output.

  ENDMETHOD.

ENDCLASS.
