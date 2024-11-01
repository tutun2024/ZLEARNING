CLASS /lrn/cl_s4d401_ood_interface DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
protected section.
private section.
ENDCLASS.



CLASS /LRN/CL_S4D401_OOD_INTERFACE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA car_rental TYPE REF TO lcl_car_rental.
    DATA airline    TYPE REF TO lcl_airline.
    DATA agency     TYPE REF TO lcl_travel_agency.

    agency = NEW #( ).

    car_rental = NEW #( i_name           = 'ABAP Autos'
                        i_contact_person = 'Mr Jones'
                        i_has_hgv        = abap_true ).

    agency->add_partner( car_rental ).

    airline = NEW #( i_name           = 'Fly Happy'
                     i_contact_person = 'Ms Meyer'
                     i_city           = 'Frankfurt' ).

    agency->add_partner( airline ).

    LOOP AT agency->get_partners( ) INTO DATA(partner).
      out->write( partner->get_partner_attributes( ) ).
      out->write( `----------------------------------------------------` ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
