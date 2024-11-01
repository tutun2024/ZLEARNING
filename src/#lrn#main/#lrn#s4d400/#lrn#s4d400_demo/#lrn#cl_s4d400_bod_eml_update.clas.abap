CLASS /lrn/cl_s4d400_bod_eml_update DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D400_BOD_EML_UPDATE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*
    DATA update_tab TYPE TABLE FOR UPDATE /dmo/i_agencytp .

    update_tab = VALUE #( ( agencyid = '070050'  name = 'MODIFIED ENTITY' ) ).

    MODIFY ENTITIES OF /dmo/i_agencytp
    ENTITY /dmo/agency
    UPDATE
    FIELDS ( name )
      WITH update_tab.

    COMMIT ENTITIES.
    out->write(  'Done' ).


  ENDMETHOD.
ENDCLASS.
