CLASS zcl_s4d_auth_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES t_role_name TYPE if_iam_business_role=>ty_id.
    TYPES  t_template TYPE if_iam_business_role=>ty_brt_id.
    TYPES tt_users TYPE STANDARD TABLE OF syuname
                    WITH EMPTY KEY.
    TYPES t_catalog_id TYPE if_iam_business_role=>ty_bu_catalog_id.
    TYPES tt_catalogs TYPE STANDARD TABLE OF t_catalog_id
                       WITH EMPTY KEY.
    TYPES tt_log TYPE string_table.


    DATA log TYPE string_table READ-ONLY.

    CLASS-METHODS
      create_and_assign_role
        IMPORTING
          i_role_name TYPE t_role_name
          i_template  TYPE t_template
          i_users     TYPE tt_users
        CHANGING
          c_log       TYPE tt_log.

    CLASS-METHODS
      update_existing_role
        IMPORTING
          i_role_name TYPE t_role_name
          i_catalogs  TYPE tt_catalogs
        CHANGING
          log         TYPE tt_log.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_S4D_AUTH_UTILITY IMPLEMENTATION.


  METHOD create_and_assign_role.

* Get factory instance
    DATA(br_factory) = cl_iam_business_role_factory=>create_instance( ).

* Check if business role already exists
    br_factory->query_business_roles(
      EXPORTING
        ir_brole_id = VALUE #( ( sign = 'I'
                                 option = 'EQ'
                                 low = i_role_name )
                             )
      IMPORTING
        et_result   = DATA(result) ).

    IF result IS INITIAL.
* Create new business role from template
      br_factory->create_brole_from_template(
        EXPORTING
          iv_id            = i_role_name
          iv_template_id   = i_template
        IMPORTING
          eo_business_role = DATA(brole)
          et_return        = DATA(return) ).

      IF return IS NOT INITIAL.
        APPEND |Error creating role { i_role_name } .| TO c_log.
      ELSE.
        APPEND |Created business role { i_role_name }.| TO c_log.
        " Set Business Role: Read = unrestricted, Write = Unrestricted, F4 = unrestricted
        brole->set_access_restriction(
      EXPORTING
        iv_write  = if_iam_business_role=>co_access_restriction_code-unrestricted
        iv_read   = if_iam_business_role=>co_access_restriction_code-unrestricted
        iv_f4     = if_iam_business_role=>co_access_restriction_code-unrestricted
      IMPORTING
        et_return = return ).
      ENDIF.

    ELSE.
      APPEND |Business Role { i_role_name } alread exists| TO c_log.
* Read existing business role
* not yet possible - wait for hotfix
*
*      br_factory->get_business_role(
*        EXPORTING
*          iv_uuid          = result[ 1 ]-uuid
*        IMPORTING
*          eo_business_role = brole
*          et_return        = return
*      ).
*      IF return IS NOT INITIAL.
*        APPEND |Error retrieving business role { new_role }| TO log.
*      ENDIF.

    ENDIF.

* Assign users to business role
    IF brole IS BOUND.
      LOOP AT i_users INTO DATA(user).
        DATA(counter) = sy-tabix.
        brole->add_user(
          EXPORTING
            iv_user_id = user
          IMPORTING
            et_return  = return ).

        IF return IS NOT INITIAL.
          APPEND |Error assigning role { i_role_name } to user {  user }.| TO c_log.
          EXIT.
        ENDIF.
*
      ENDLOOP.

      APPEND |Assigned role { i_role_name } to { counter } users.| TO c_log.

      brole->save(
        IMPORTING
          et_return = return ).
      IF return IS NOT INITIAL.
        APPEND |Error saving role { i_role_name }.| TO c_log.
      ELSE.
        APPEND |Saved role { i_role_name }.| TO c_log.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD update_existing_role.

    " Get factory instance
    DATA(br_factory) = cl_iam_business_role_factory=>create_instance( ).

    " Read the business role
    br_factory->query_business_roles(
      EXPORTING
        ir_brole_id = VALUE #( ( sign   = 'I'
                                 option = 'EQ'
                                 low    = i_role_name ) )
      IMPORTING
        et_result   = DATA(result) ).

    IF result IS INITIAL.
      APPEND |Error: Business role { i_role_name } not found| TO log.
      RETURN.
    ENDIF.

    br_factory->get_business_role(
      EXPORTING
        iv_uuid          = result[ 1 ]-uuid
      IMPORTING
        eo_business_role = DATA(brole)
        et_return        = DATA(return)
    ).
    IF return IS NOT INITIAL.
      APPEND |Error retrieving business role { i_role_name }| TO log.
      RETURN.
    ENDIF.

    LOOP AT i_catalogs INTO DATA(catalog).

      brole->add_business_catalog(
        EXPORTING
           iv_bu_catalog_id = catalog
        IMPORTING
           et_return        = return
        ).

      IF return IS NOT INITIAL.
        APPEND return[ 1 ]-message TO log.
      ELSE.
        APPEND |Added catalog { catalog } to business role { i_role_name }| TO log.
      ENDIF.

    ENDLOOP.
    brole->save(
      IMPORTING
        et_return = return ).
    IF return IS NOT INITIAL.
      APPEND |Error saving role { i_role_name }.| TO log.
    ELSE.
      APPEND |Saved role { i_role_name }.| TO log.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
