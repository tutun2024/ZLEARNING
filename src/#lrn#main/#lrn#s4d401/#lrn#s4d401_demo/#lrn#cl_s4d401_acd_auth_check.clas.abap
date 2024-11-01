CLASS /lrn/cl_s4d401_acd_auth_check DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
protected section.
private section.
ENDCLASS.



CLASS /LRN/CL_S4D401_ACD_AUTH_CHECK IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    " Note: Training users have no authorization
    "       for Countries with a code
    "       that starts with the letter Z
    "
    AUTHORITY-CHECK OBJECT '/DMO/TRVL'
                    ID '/DMO/CNTRY' FIELD  'US'
                    ID 'ACTVT' FIELD '03'.

    IF sy-subrc = 0.
      out->write( |Display authorization for country 'US'| ).
    ELSE.
      out->write( |No display authorization for country 'US'| ).
    ENDIF.

**********************************************************************
    out->write( `-----------------------------------------------------------` ).

    AUTHORITY-CHECK OBJECT '/DMO/TRVL'
                    ID '/DMO/CNTRY' FIELD  'ZW'
                    ID 'ACTVT' FIELD '03'.

    IF sy-subrc = 0.
      out->write( |Display authorization for country 'ZW'| ).
    ELSE.
      out->write( |No display authorization for country 'ZW'| ).
    ENDIF.

**********************************************************************
    out->write( `-----------------------------------------------------------` ).

    SELECT FROM /lrn/airport
      FIELDS airport_id, name, country
      INTO TABLE @DATA(airports).

    out->write( |Total number of airports:         { lines( airports ) }| ).

    LOOP AT airports ASSIGNING FIELD-SYMBOL(<airp>).

      AUTHORITY-CHECK OBJECT '/DMO/TRVL'
                      ID '/DMO/CNTRY' FIELD  <airp>-country
                      ID 'ACTVT' FIELD '03'.

      IF sy-subrc <> 0.
        DELETE airports INDEX sy-tabix.
      ENDIF.

    ENDLOOP.

    out->write( |Airports after authority check:   { lines( airports ) }| ).

    SORT airports BY country.

    out->write( airports ).
  ENDMETHOD.
ENDCLASS.
