CLASS /lrn/cl_s4d400_bod_eml_read DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D400_BOD_EML_READ IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA input_keys TYPE TABLE FOR READ IMPORT /dmo/i_agencytp .
    DATA result_tab TYPE TABLE FOR READ RESULT /dmo/i_agencytp .

    input_keys = VALUE #( ( agencyid = '070050' )  ).

    READ ENTITIES OF /dmo/i_agencytp
        ENTITY /dmo/agency
           ALL FIELDS
          WITH input_keys
        RESULT result_tab.

    out->write(  result_tab  ).

  ENDMETHOD.
ENDCLASS.
