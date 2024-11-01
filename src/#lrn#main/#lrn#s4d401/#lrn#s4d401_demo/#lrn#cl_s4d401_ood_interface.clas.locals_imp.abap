*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

INTERFACE lif_partner.
  TYPES:
    BEGIN OF ts_attribute,
      name  TYPE string,
      value TYPE string,
    END OF ts_attribute.

  TYPES tt_attributes TYPE SORTED TABLE OF ts_attribute WITH UNIQUE KEY name.

  METHODS get_partner_attributes
    RETURNING VALUE(rt_attributes) TYPE tt_attributes.
ENDINTERFACE.


CLASS lcl_travel_agency DEFINITION.
  PUBLIC SECTION.
    TYPES tt_partners TYPE STANDARD TABLE OF REF TO lif_partner WITH EMPTY KEY.

    METHODS add_partner
      IMPORTING io_partner TYPE REF TO lif_partner.

    METHODS
      get_partners
        RETURNING VALUE(rt_partners) TYPE tt_partners.

  PRIVATE SECTION.
    DATA partners TYPE TABLE OF REF TO lif_partner.

ENDCLASS.


CLASS lcl_travel_agency IMPLEMENTATION.
  METHOD add_partner.
    APPEND io_partner TO partners.
  ENDMETHOD.

  METHOD get_partners.
    rt_partners = partners.
  ENDMETHOD.
ENDCLASS.


CLASS lcl_airline DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_partner.

    TYPES:
      BEGIN OF ts_detail,
        name  TYPE string,
        value TYPE string,
      END OF ts_detail.

    TYPES tt_details TYPE SORTED TABLE OF ts_detail WITH UNIQUE KEY name.

    METHODS constructor
      IMPORTING i_name           TYPE string
                i_city           TYPE string
                i_contact_person TYPE string.

    METHODS get_details
      RETURNING VALUE(rt_details) TYPE tt_details.

  PRIVATE SECTION.
    DATA name           TYPE string.
    DATA city           TYPE string.
    DATA contact_person TYPE string.

ENDCLASS.


CLASS lcl_car_rental DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_partner.

    TYPES:
      BEGIN OF ts_info,
        name  TYPE c LENGTH 20,
        value TYPE c LENGTH 20,
      END OF ts_info.

    TYPES tt_info TYPE SORTED TABLE OF ts_info WITH UNIQUE KEY name.

    METHODS constructor
      IMPORTING i_name           TYPE string
                i_contact_person TYPE string
                i_has_hgv        TYPE abap_bool.

    METHODS get_information
      RETURNING VALUE(rt_details) TYPE tt_info.

  PRIVATE SECTION.
    DATA name           TYPE string.
    DATA contact_person TYPE string.
    DATA has_hgv        TYPE abap_bool.

ENDCLASS.


CLASS lcl_airline IMPLEMENTATION.
  METHOD get_details.
  ENDMETHOD.

  METHOD lif_partner~get_partner_attributes.
    rt_attributes = VALUE #( ( name = 'NAME'           value = name           )
                             ( name = 'CONTACT PERSON' value = contact_person )
                             ( name = 'CITY'           value = city           ) ).
  ENDMETHOD.

  METHOD constructor.
    name           = i_name.
    city           = i_city.
    contact_person = i_contact_person.
  ENDMETHOD.
ENDCLASS.


CLASS lcl_car_rental IMPLEMENTATION.
  METHOD get_information.

  ENDMETHOD.

  METHOD lif_partner~get_partner_attributes.
    rt_attributes = VALUE #( ( name = 'NAME'           value = name  )
                             ( name = 'CONTACT PERSON' value = contact_person )
                             ( name = 'HAS HGV'        value = has_hgv ) ).
  ENDMETHOD.

  METHOD constructor.
    name           = i_name.
    contact_person = i_contact_person.
    has_hgv        = i_has_hgv.
  ENDMETHOD.
ENDCLASS.
