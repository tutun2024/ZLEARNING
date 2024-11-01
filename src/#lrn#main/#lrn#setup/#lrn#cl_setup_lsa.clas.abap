CLASS /lrn/cl_setup_lsa DEFINITION
  PUBLIC
  INHERITING FROM /lrn/cl_setup_root
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS run REDEFINITION.

  PROTECTED SECTION.

    METHODS adjust_authorizations REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_SETUP_LSA IMPLEMENTATION.


  METHOD adjust_authorizations.
    " For LSA landscapes we do not assign a new business role to existing users
    " Instead, we add a business catalog to the existing role LSC_BR_DEVELOPER

    DATA role_name TYPE zcl_s4d_auth_utility=>t_role_name     VALUE 'LSC_BR_DEVELOPER'.

    DATA(catalogs) = VALUE zcl_s4d_auth_utility=>tt_catalogs(
                         ( '/LRN/FLIGHT_MODEL_BC' )
                         ( 'ZS4D430_MODEL_BC'    )
                      ).

    zcl_s4d_auth_utility=>update_existing_role(
      EXPORTING
        i_role_name = role_name
        i_catalogs  = catalogs
      Changing
        log       = log
    ).
  ENDMETHOD.


  METHOD run.

* general setup tasks:
    super->run( ).

* additional setup tasks:
    adjust_authorizations( ).

    generate_s4d401_data( ).
    generate_s4d430_data( ).

  ENDMETHOD.
ENDCLASS.
