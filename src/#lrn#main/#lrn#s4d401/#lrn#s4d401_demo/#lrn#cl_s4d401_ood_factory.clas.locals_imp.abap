*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_connection DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING i_carrier_id      TYPE /dmo/carrier_id
                i_connection_id   TYPE /dmo/connection_id
                i_airport_from_id TYPE /dmo/airport_from_id
                i_airport_to_id   TYPE /dmo/airport_to_id.

    CLASS-METHODS get_connection
      IMPORTING i_carrier_id    TYPE /dmo/carrier_id
                i_connection_id TYPE /dmo/connection_id

      RETURNING VALUE(r_result) TYPE REF TO lcl_connection.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ts_instance,
        carrier_id    TYPE /dmo/carrier_id,
        connection_id TYPE /dmo/connection_id,
        object        TYPE REF TO lcl_connection,
      END OF ts_instance.
    TYPES tt_instances TYPE HASHED TABLE OF ts_instance
                       WITH UNIQUE KEY carrier_id connection_id.

    DATA carrier_id      TYPE /dmo/carrier_id.
    DATA connection_id   TYPE /dmo/connection_id.
    DATA airport_from_id TYPE /dmo/airport_from_id.
    DATA airport_to_id   TYPE /dmo/airport_to_id.

    CLASS-DATA connections TYPE tt_instances.

ENDCLASS.


CLASS lcl_connection IMPLEMENTATION.
  METHOD constructor.
    carrier_id      = i_carrier_id.
    connection_id   = i_connection_id.
    airport_from_id = i_airport_from_id.
    airport_to_id   = i_airport_to_id.
  ENDMETHOD.

  METHOD get_connection.
    DATA airport_from_id TYPE /dmo/airport_from_id.
    DATA airport_to_id   TYPE /dmo/airport_to_id.

    " try to retrieve instance from attrbute connections
    TRY.
        r_result = connections[ carrier_id    = i_carrier_id
                                connection_id = i_connection_id ]-object.
      CATCH cx_sy_itab_line_not_found.
        " if not, retrieve data from DB ...
        SELECT SINGLE FROM /dmo/connection
          FIELDS airport_from_id, airport_to_id
          WHERE carrier_id    = @i_carrier_id
            AND connection_id = @i_connection_id
          INTO ( @airport_from_id, @airport_to_id ).

        " ... and create the new instance ...
        r_result = NEW #( i_carrier_id      = i_carrier_id
                          i_connection_id   = i_connection_id
                          i_airport_from_id = airport_from_id
                          i_airport_to_id   = airport_to_id ).
        " then store the new instance in attribute connection
        DATA(new_connection) = VALUE ts_instance( carrier_id    = i_carrier_id
                                                  connection_id = i_connection_id
                                                  object        = r_result ).

        INSERT new_connection INTO TABLE connections.

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
