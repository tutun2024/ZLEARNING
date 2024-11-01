*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_connection DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RAISING
        /lrn/cx_s4d401_no_connection.

  PRIVATE SECTION.
    DATA carrier_id      TYPE /dmo/carrier_id.
    DATA connection_id   TYPE /dmo/connection_id.
    DATA airport_from_id TYPE /dmo/airport_from_id.
    DATA airport_to_id   TYPE /dmo/airport_to_id.
ENDCLASS.


CLASS lcl_connection IMPLEMENTATION.
  METHOD constructor.
    DATA airport_from_id TYPE /dmo/airport_from_id.
    DATA airport_to_id   TYPE /dmo/airport_to_id.

    SELECT SINGLE FROM /dmo/connection
      FIELDS airport_from_id, airport_to_id
      WHERE carrier_id    = @i_carrier_id
        AND connection_id = @i_connection_id
      INTO ( @airport_from_id, @airport_to_id ).

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /lrn/cx_s4d401_no_connection
        EXPORTING
          carrier_id    = i_carrier_id
          connection_id = i_connection_id.
    ELSE.
      carrier_id = i_carrier_id.
      connection_id = i_connection_id.
      me->airport_from_id = airport_from_id.
      me->airport_to_id   = airport_to_id.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
