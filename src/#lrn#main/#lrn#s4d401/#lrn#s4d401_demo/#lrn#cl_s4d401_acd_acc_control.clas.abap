CLASS /lrn/cl_s4d401_acd_acc_control DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_ACD_ACC_CONTROL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Note: CDS access control  /LRN/S4D401_ACD_AIRPORT
*       for CDS view entity /LRN/S4D401_ACD_Airport
*       ensures that you read only airports for which
*       the user is authorized
*
*  Set a breakpoint at statement DELETE to confirm
*  that no airports have to be removed from the
*  selection result later

    SELECT
       FROM /lrn/s4d401_acd_airport
     FIELDS airportid, name, country
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
