*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_plane DEFINITION.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ts_attributes,
        name  TYPE string,
        value TYPE string,
      END OF ts_attributes.

*          declare table - do not allow the same attribute name
*                          to be used more than once
    TYPES tt_attributes TYPE SORTED TABLE OF ts_attributes
                        WITH UNIQUE KEY name.

    METHODS constructor
       IMPORTING
       i_manufacturer TYPE string
                                  i_type         TYPE string.

    METHODS get_attributes
    RETURNING
    VALUE(rt_attributes) TYPE tt_attributes.

  PROTECTED SECTION.

    DATA manufacturer TYPE string.
    DATA type TYPE string.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_plane IMPLEMENTATION.

  METHOD constructor.
    manufacturer = i_manufacturer.
    type = i_type.
  ENDMETHOD.

  METHOD get_attributes.
    rt_attributes = VALUE #( ( name = 'MANUFACTURER' value = manufacturer )
                             ( name = 'TYPE'         value = type )
                    ) .
  ENDMETHOD.

ENDCLASS.

CLASS lcl_cargo_plane DEFINITION INHERITING FROM lcl_plane.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
      i_manufacturer TYPE string
                                  i_type         TYPE string
                                  i_cargo        TYPE i.
    METHODS get_attributes REDEFINITION.

  PRIVATE SECTION.

    DATA cargo TYPE i.

ENDCLASS.

CLASS lcl_cargo_plane IMPLEMENTATION.
  METHOD constructor.

    super->constructor(
              i_manufacturer = i_manufacturer
              i_type = i_type
                      ).

    cargo = i_cargo.

  ENDMETHOD.

  METHOD get_attributes.

* * Option 1: redefinition uses protected attributes of superclass

    rt_attributes = VALUE #(
                       ( name = 'MANUFACTURER' value = manufacturer )
                       ( name = 'TYPE'         value = type         )
                       ( name = 'CARGO'        value = cargo        )
                    ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_passenger_plane DEFINITION INHERITING FROM lcl_plane.
  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        i_manufacturer TYPE string
        i_type         TYPE string
        i_seats        TYPE i.

    METHODS get_attributes REDEFINITION.

  PRIVATE SECTION.

    DATA seats TYPE i.

ENDCLASS.

CLASS lcl_passenger_plane IMPLEMENTATION.

  METHOD constructor.

    super->constructor(
             i_manufacturer = i_manufacturer
             i_type         = i_type
           ).

        seats = i_seats.
  ENDMETHOD.

  METHOD get_attributes.

* Option 2: Redefinition uses call of superclass implementation
    rt_attributes = super->get_attributes( ).

    rt_attributes = VALUE #(  BASE rt_attributes
                             ( name = 'SEATS' value = seats )
                           ).
  ENDMETHOD.

ENDCLASS.
