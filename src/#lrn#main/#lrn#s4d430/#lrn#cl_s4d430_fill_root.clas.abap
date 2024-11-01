CLASS /lrn/cl_s4d430_fill_root DEFINITION
  PUBLIC
  ABSTRACT.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ENUM t_version,
        employee_table_only,
        with_relationships,
        with_extensions,
      END OF ENUM t_version.

    METHODS constructor
      IMPORTING
        i_version       TYPE t_version
        i_employ_table  TYPE tabname
        i_depment_table TYPE tabname OPTIONAL
      RAISING
        cx_abap_not_a_table.

  PROTECTED SECTION.

    METHODS
      run
        IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

  PRIVATE SECTION.

    DATA tables TYPE TABLE OF REF TO object.

    DATA log TYPE string_table.

ENDCLASS.



CLASS /LRN/CL_S4D430_FILL_ROOT IMPLEMENTATION.


  METHOD constructor.

    APPEND NEW lcl_table( i_name = i_employ_table
                          i_source =  SWITCH #( i_version
                                           WHEN employee_table_only      THEN '/LRN/EMPLOY'
                                           WHEN with_relationships    THEN '/LRN/EMPLOY_REL'
                                           WHEN with_extensions THEN '/LRN/EMPLOY_EXT')
                         )
        TO tables.

    IF i_version = with_relationships.
      APPEND NEW lcl_table( i_name = i_employ_table
                            i_source = '/LRN/DEPMENT_REL'
                           )
          TO tables.
    ENDIF.
  ENDMETHOD.


  METHOD run.

    LOOP AT tables INTO DATA(object).

      DATA(table) = CAST lcl_table( object ).

      APPEND LINES OF table->compare( )
          TO log.

      IF log IS NOT INITIAL.

        out->write( data = log
                    name = |Errors in Table { table->name } | ).

      ELSE.
        TRY.
            table->copy( ).
            out->write( |Filled table { table->name }| ).
          CATCH cx_root INTO DATA(excp).
            out->write( |Error during data copy: { excp->get_text( ) } | ).
        ENDTRY.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
