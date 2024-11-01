CLASS /lrn/cl_s4d401_ood_inheritance DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
protected section.
private section.
ENDCLASS.



CLASS /LRN/CL_S4D401_OOD_INHERITANCE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA passenger TYPE REF TO lcl_passenger_plane.
    DATA plane     TYPE REF TO lcl_plane.
    DATA planes    TYPE TABLE OF REF TO lcl_plane.

    " Up-cast assignment and generic access
    " ---------------------------------------------------------------------
    passenger = NEW #( i_manufacturer = 'BOEING'
                       i_type         = '737-800'
                       i_seats        = 130 ).

    out->write( 'Output using passenger plane object reference' ).
    out->write( passenger->get_attributes( ) ).
    out->write( `----------------------------------------------------` ).

    plane = passenger.     " Up-Cast assignment

    out->write( 'Output using superclass object reference' ).
    out->write( plane->get_attributes( ) ).
    out->write( `----------------------------------------------------` ).

    APPEND plane TO planes.
    CLEAR plane.

    " Implicit up-cast in assignment of NEW expression
    " ---------------------------------------------------------------------
    plane = NEW lcl_cargo_plane( i_manufacturer = 'AIRBUS'
                                 i_type         = 'A340'
                                 i_cargo        = 60000 ).

    out->write( 'Output using superclass object reference' ).
    out->write( plane->get_attributes( ) ).
    out->write( `----------------------------------------------------` ).

    APPEND plane TO planes.
    CLEAR plane.

    " output without knowing the dynamic type (subclass)
    " ---------------------------------------------------------------------
    out->write( 'Output for both planes without knowing the dynamic type' ).
    LOOP AT planes INTO plane.
      out->write( plane->get_attributes( ) ).
      out->write( `----------------------------------------------------` ).
    ENDLOOP.

    CLEAR plane.

    " Analyzing the dynamic type and down-cast
    " ---------------------------------------------------------------------
    LOOP AT planes INTO plane.

      IF plane IS INSTANCE OF lcl_passenger_plane.
        passenger = CAST #( plane ).                  " down-cast
      ENDIF.

      IF plane IS INSTANCE OF lcl_cargo_plane.
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(cargo) = CAST lcl_cargo_plane( plane ).  " down-cast
      ENDIF.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
