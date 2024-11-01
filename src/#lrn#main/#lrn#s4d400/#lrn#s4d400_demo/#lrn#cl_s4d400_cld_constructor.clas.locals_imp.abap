*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_connection DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.

* Attributes

    DATA carrier_id    TYPE /dmo/carrier_id    READ-ONLY.
    DATA connection_id TYPE /dmo/connection_id READ-ONLY.



    METHODS get_attributes
      EXPORTING
        e_carrier_id    TYPE /dmo/carrier_id
        e_connection_id TYPE /dmo/connection_id.

    METHODS set_attributes_me
      IMPORTING
        carrier_id    TYPE /dmo/carrier_id
        connection_id TYPE /dmo/connection_id.

    METHODS constructor
      IMPORTING
        carrier_id    TYPE /dmo/carrier_id
        connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.

* Functional Method

    METHODS get_output
      RETURNING VALUE(r_output) TYPE string_table.


*  PROTECTED SECTION.

  PRIVATE SECTION.

    CLASS-DATA conn_counter TYPE i.
* Methods
    METHODS set_attributes
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id  DEFAULT 'LH'
        i_Connection_id TYPE /dmo/connection_id.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.

  METHOD class_constructor.

  ENDMETHOD.

  METHOD constructor.

    IF carrier_id IS INITIAL OR connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    me->carrier_id = carrier_id.
    me->connection_id = connection_id.

    conn_counter = conn_counter + 1.

  ENDMETHOD.

  METHOD set_attributes.
    carrier_id    = i_carrier_id.
    connection_id = i_connection_id.
  ENDMETHOD.

  METHOD get_attributes.
    e_carrier_id    = carrier_id.
    e_connection_id = connection_id.
  ENDMETHOD.

  METHOD set_attributes_me.
    me->carrier_id    = carrier_id.
    me->connection_id = connection_id.
  ENDMETHOD.


  METHOD get_output.

    APPEND |------------------------------| TO r_output.
    APPEND |Carrier:     { carrier_id    }| TO r_output.
    APPEND |Connection:  { connection_id }| TO r_output.

  ENDMETHOD.

ENDCLASS.
