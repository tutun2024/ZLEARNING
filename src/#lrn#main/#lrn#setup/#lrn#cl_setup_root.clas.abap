CLASS /lrn/cl_setup_root DEFINITION
  PUBLIC
  ABSTRACT .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    INTERFACES /lrn/if_setup.

    ALIASES courseid FOR /lrn/if_setup~courseid.
    ALIASES log FOR /lrn/if_setup~protocol.
    ALIASES run FOR /lrn/if_setup~run.

    METHODS constructor.

    CLASS-METHODS class_constructor.

*      Factory (for later use)
*    CLASS-METHODS create
*      IMPORTING
*        i_courseid      TYPE /lrn/courseid
*      RETURNING
*        VALUE(r_result) TYPE REF TO /lrn/if_setup
*      RAISING
*        lcx_no_authorization.
*  METHOD create.
*    DATA(class) = courses[  courseid = i_courseid ].
*    CREATE OBJECT r_result TYPE (class)
*      EXPORTING
*         i_courseid = i_courseid.
*  ENDMETHOD.

  PROTECTED SECTION.

* building blocks for course setup
    METHODS generate_data.
    METHODS get_exchange_rates.
    METHODS generate_s4d401_data.
    METHODS adjust_authorizations.
    METHODS generate_s4d430_data.

  PRIVATE SECTION.

    TYPES: BEGIN OF st_course,
             courseid  TYPE /lrn/courseid,
             classname TYPE c LENGTH 30,
           END OF st_course.

    TYPES tt_courses TYPE STANDARD TABLE OF st_course
                     WITH NON-UNIQUE KEY courseid.

    TYPES tt_users TYPE STANDARD TABLE OF syuname
                     WITH NON-UNIQUE DEFAULT KEY.

    CLASS-DATA courses TYPE tt_courses.

    CLASS-DATA users TYPE zcl_s4d_auth_utility=>tt_users.


ENDCLASS.



CLASS /LRN/CL_SETUP_ROOT IMPLEMENTATION.


  METHOD /lrn/if_setup~run.

    generate_data( ).
    get_exchange_rates( ).

  ENDMETHOD.


  METHOD class_constructor.

    TYPES n2 TYPE n LENGTH 2.

    courses = VALUE #( ( courseid = 'S4D400' classname = '/LRN/CL_SETUP_S4D400' )
                       ( courseid = 'S4D401' classname = '/LRN/CL_SETUP_S4D401' )
                       ( courseid = 'S4D430' classname = '/LRN/CL_SETUP_S4D430' )
                       ( courseid = 'S4Dnnn' classname = '/LRN/CL_SETUP_LSA'    )
                     ).

    SELECT
      FROM i_businessuserbasic
    FIELDS userid
     WHERE firstname LIKE 'TRAIN-%'
        OR userid = @sy-uname
      INTO TABLE @users.
    "Only empty if current user has insufficient authorizations to read user data
  ENDMETHOD.


  METHOD constructor.

* set course ID
    TRY.
        DATA(my_name) = cl_abap_typedescr=>describe_by_object_ref(  me )->get_relative_name(  ).
        courseid      = courses[ classname = my_name ]-courseid.

      CATCH cx_sy_itab_line_not_found.
      courseID = 'Unknown'.
    ENDTRY.

        APPEND |Perform setup for { courseid }.|
            TO me->log.

  ENDMETHOD.


  METHOD generate_data.

    SELECT FROM /dmo/i_carrier
      FIELDS COUNT(*)
      INTO @DATA(carrier_count).

    IF carrier_count IS NOT INITIAL.
      APPEND `Flight model data already exist` TO log.
    ELSE.
      "Call Console app with redirected console output
      DATA(out_local) = NEW lcl_out( ).
      DATA(generator) = NEW /dmo/cl_flight_data_generator( ).

      generator->if_oo_adt_classrun~main( out = out_local ).

      "Cleanup protocol
      DELETE out_local->log WHERE table_line CP `*-->*`.

      " Store protocol
      APPEND LINES OF out_local->log TO me->log.

    ENDIF.

  ENDMETHOD.


  METHOD adjust_authorizations.

    CONSTANTS c_template TYPE zcl_s4d_auth_utility=>t_template  VALUE '/LRN/ABAP_LEARNER_BR'.
    DATA      new_role   TYPE zcl_s4d_auth_utility=>t_role_name VALUE 'ZZ_ABAP_LEARNER'.

    zcl_s4d_auth_utility=>create_and_assign_role(
      EXPORTING
        i_role_name = new_role
        i_template  = c_template
        i_users     = users
      CHANGING
        c_log       = log
    ).

  ENDMETHOD.


  METHOD get_exchange_rates.

    " Call Console app with redirected console output
    DATA(out_local) = NEW lcl_out( ).
    DATA(importer) = NEW zcl_ecb_exchange_rates_xml( ).

    importer->if_oo_adt_classrun~main( out = out_local ).

    " Cleanup protocol
    DELETE out_local->log WHERE    table_line CP `RATE_TYPE*`
                                OR table_line CP ` M *`
                                OR table_line CP `*Entry already exists;*`
                                OR table_line CP `*No entries have been written*`.

    " Store protocol
    IF out_local->log IS NOT INITIAL.
      APPEND LINES OF out_local->log TO me->log.
    ELSE.
      APPEND `Import of exchange rates finished successfully` TO me->log.
    ENDIF.

  ENDMETHOD.


  METHOD generate_s4d430_data.

    SELECT FROM /lrn/c_employee_ann
      FIELDS COUNT(*)
      INTO @DATA(employee_count).

    IF employee_count IS NOT INITIAL.
      APPEND `Course specific data already generated` TO log.
    ELSE.

      " Call Console app with redirected console output
      DATA(out_local) = NEW lcl_out( ).
      DATA(generator) = NEW /lrn/cl_s4d430_generator( ).
      generator->if_oo_adt_classrun~main( out = out_local ).

      " Store protocol
      APPEND LINES OF out_local->log TO me->log.

    ENDIF.

  ENDMETHOD.


  METHOD generate_s4d401_data.

    SELECT FROM /lrn/i_carrier
      FIELDS COUNT(*)
      INTO @DATA(carrier_count).

    IF carrier_count IS NOT INITIAL.
      APPEND `Learning specific data already generated` TO log.
    ELSE.

      " Call Console app with redirected console output
      DATA(out_local) = NEW lcl_out( ).
      DATA(generator) = NEW /lrn/cl_s4d401_generator( ).
      generator->if_oo_adt_classrun~main( out = out_local ).

      " Store protocol
      APPEND LINES OF out_local->log TO me->log.

    ENDIF.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    TRY.
        run( ).

        APPEND |Finished setup for { courseid }.|
               TO me->log.

      CATCH /lrn/cx_no_authorization.

        APPEND `You are not authorized to execute this course setup.`
               TO me->log.

        APPEND |Setup for {  courseid } failed!!!!|
               TO me->log.

    ENDTRY.

    out->write( me->log ).

  ENDMETHOD.
ENDCLASS.
