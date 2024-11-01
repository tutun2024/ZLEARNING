*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


"! Interface containing global constants
"! for authorization checks
INTERFACE lif_constants.

  "!Constant for authorization activity create
  CONSTANTS auth_create  TYPE activ_auth VALUE '01' .
  "!Constant for authorization activity change
  CONSTANTS auth_change  TYPE activ_auth VALUE '02'.
  "!Constant for authorization activity display
  CONSTANTS auth_display TYPE activ_auth VALUE '03'.
  "!Constant for authorization activity delete
  CONSTANTS auth_delete  TYPE activ_auth VALUE '06'.

ENDINTERFACE.

CLASS lcl_flight_model DEFINITION.
  PUBLIC SECTION.

    TYPES tt_airports TYPE STANDARD TABLE OF /lrn/airport
                      WITH NON-UNIQUE KEY airport_id.

    "! Airport data by country
    "! Empty result if user has no authorization
    "! @parameter i_country | Country Code
    "! @parameter rt_airports | List of Airports
    CLASS-METHODS get_airports
      IMPORTING
                i_country          TYPE land1
      RETURNING VALUE(rt_airports) TYPE tt_airports.

    "! <strong>Static</strong> method for authority check
    "! @parameter i_country  | Country Code
    "! @parameter i_activity | Activity <br/>
    "!                         Use constants from interface { @link ..lif_constants }
    "! @parameter r_result | <ul><li>abap_true  ('X'): authorized</li>
    "!                           <li>abap_false (' '): not authorized</li></ul>
    CLASS-METHODS
      check_auth_country
        IMPORTING
          i_country       TYPE land1
          i_activity      TYPE activ_auth
        RETURNING
          VALUE(r_result) TYPE abap_bool.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_flight_model IMPLEMENTATION.

  METHOD check_auth_country.

    AUTHORITY-CHECK
         OBJECT '/DMO/TRVL'
             ID '/DMO/CNTRY' FIELD i_country
             ID 'ACTVT'      FIELD i_activity.

    IF sy-subrc = 0.
      r_result = abap_true.
    ELSE.
      r_result = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD get_airports.

    IF check_auth_country(
                 i_country  = i_country
                 i_activity = lif_constants=>auth_display
        ) = 0.

      SELECT
        FROM /lrn/airport
      FIELDS *
       WHERE country = @i_country
        INTO TABLE @rt_airports.
    ENDIF.

  ENDMETHOD.


ENDCLASS.
