*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_table definition.

  PUBLIC SECTION.
    DATA name  TYPE tabname READ-ONLY.

    METHODS constructor
      IMPORTING
        i_name   TYPE tabname
        i_source TYPE tabname
      RAISING
        cx_abap_not_a_table.
    METHODS
      compare
        RETURNING
          value(r_output) TYPE string_table.
    METHODS
      copy
       RAISING
          cx_root .

  PROTECTED SECTION.

  PRIVATE SECTION.


    DATA source TYPE tabname.

    CLASS-METHODS is_table
      IMPORTING
        i_name TYPE tabname
      RAISING
        cx_abap_not_a_table.


endclass.

class lcl_table implementation.

  method constructor.

     is_table( i_name ).
     name = i_name.

     is_table( i_source ).
     source = i_source.

  endmethod.

  METHOD compare.

    DATA(components)   = CAST cl_abap_structdescr(
                              cl_abap_typedescr=>describe_by_name( name )
                         )->components.

    DATA(components_t) = CAST cl_abap_structdescr(
                             cl_abap_typedescr=>describe_by_name( source )
                          )->components.

    SORT components      BY name DESCENDING.
    SORT components_t    BY name DESCENDING.

    LOOP AT components_t ASSIGNING FIELD-SYMBOL(<compt>).

      ASSIGN components[ name = <compt>-name ] TO FIELD-SYMBOL(<comp>).
      IF sy-subrc <> 0.
        APPEND |Column { <compt>-name WIDTH = 30 }: No column of that name!|
           TO r_output.
      ELSEIF <comp>-type_kind <> <compt>-type_kind.
        APPEND |Column { <comp>-name WIDTH = 30 }: Wrong basic type ( { <comp>-type_kind } instead of { <compt>-type_kind } )|
            TO r_output.

      ELSEIF <comp>-length <> <compt>-length.
        APPEND |Column { <compt>-name WIDTH = 30 }: Wrong length ( { <comp>-length } instead of { <compt>-length } )|
            TO r_output.

      ELSEIF <comp>-decimals <> <compt>-decimals.
        APPEND |Column { <compt>-name WIDTH = 30 }: Wrong number of decimals!|
           TO r_output.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD copy.

    DATA r_source TYPE REF TO data.
    DATA r_target TYPE REF TO data.

    CREATE DATA r_source TYPE TABLE OF (source).
    CREATE DATA r_target TYPE TABLE OF (name).

    ASSIGN  r_source->* TO FIELD-SYMBOL(<source>).
    ASSIGN  r_target->* TO FIELD-SYMBOL(<target>).

    SELECT
      FROM (source)
    FIELDS *
      INTO TABLE @<source>.

    <target> = CORRESPONDING #( <source> ).

    MODIFY (name) FROM TABLE @<target>.

  ENDMETHOD.


  METHOD is_table.

* XCO alternative
*DATA(lo_name_filter) = xco_cp_abap_repository=>object_name->get_filter( xco_cp_abap_sql=>constraint->equal( i_name ) ).
*
*    DATA(lt_objects) = xco_cp_abap_repository=>objects->tabl->database_tables->where( VALUE #(
*      ( lo_name_filter )
*    ) )->in( xco_cp_abap=>repository )->get( ).
*
*    IF lt_objects IS INITIAL.
*      raise exception new cx_abap_not_a_table( value = conv #( i_name ) ).
*    ENDIF.

* Alternative

    cl_abap_typedescr=>describe_by_name(
      EXPORTING
        p_name         = i_name
      RECEIVING
        p_descr_ref    = DATA(type)
      EXCEPTIONS
        type_not_found = 1
    ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_abap_not_a_table( value = CONV #( i_name ) ).
    ENDIF.

    IF type->kind <> type->kind_struct.
      RAISE EXCEPTION NEW cx_abap_not_a_table( value = CONV #( i_name ) ).
    ENDIF.

    IF type->is_ddic_type( ) <> cl_abap_typedescr=>true.
      RAISE EXCEPTION NEW cx_abap_not_a_table( value = CONV #( i_name ) ).
    ENDIF.

  ENDMETHOD.

endclass.
