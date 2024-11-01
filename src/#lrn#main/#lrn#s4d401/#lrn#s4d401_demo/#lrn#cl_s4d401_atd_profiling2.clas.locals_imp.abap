*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_data DEFINITION .

  PUBLIC SECTION.

    TYPES tt_connections TYPE STANDARD TABLE OF /dmo/connection
                     WITH NON-UNIQUE KEY carrier_id connection_id .



    CLASS-METHODS get_connections
      RETURNING VALUE(r_result) TYPE tt_connections.

    CLASS-METHODS get_airport_city
      IMPORTING i_airport_id    TYPE /dmo/airport_id
      RETURNING VALUE(r_result) TYPE /dmo/city.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_data IMPLEMENTATION.


  METHOD get_connections.

    SELECT *
      FROM /dmo/connection
      INTO TABLE @r_result.

  ENDMETHOD.

  METHOD get_airport_city.

    SELECT SINGLE FROM /dmo/airport
       FIELDS city
       WHERE airport_id = @i_airport_id
       INTO @r_result.
  ENDMETHOD.

ENDCLASS.
