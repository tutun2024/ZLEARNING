*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING i_carrier_id TYPE /dmo/carrier_id
      RAISING   cx_abap_invalid_value.

    METHODS get_name          RETURNING VALUE(r_result) TYPE /dmo/carrier_name.

    METHODS get_currency      RETURNING VALUE(r_result) TYPE /dmo/currency_code.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA carrier_data TYPE /dmo/carrier.

ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.

  METHOD constructor.

    SELECT SINGLE *
      FROM /dmo/carrier
      WHERE carrier_id = @i_carrier_id
      INTO @me->carrier_data.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

  ENDMETHOD.

  METHOD get_currency     .
*    r_result = me->carrier_data-currency_code.
  ENDMETHOD.

  METHOD get_name.
*    r_result = me->carrier_data-name.
  ENDMETHOD.

ENDCLASS.
