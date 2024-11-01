CLASS /lrn/cl_s4d401_csd_translation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_CSD_TRANSLATION IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Note: The class comes with translations
*       to the following languages:
*           - Chinese
*           - French
*           - German
*           - Japanese
*           - Korean
*           - Portuguese
*           - Russian
*           - Spanish
*
* Log on with one of those languages and execute the app

    out->write(  'Hello World!'(001) ).
    out->write( text-hau             ).

  ENDMETHOD.
ENDCLASS.
