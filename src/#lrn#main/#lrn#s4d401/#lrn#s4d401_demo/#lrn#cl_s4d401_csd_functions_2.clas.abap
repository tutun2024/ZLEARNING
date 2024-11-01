CLASS /lrn/cl_s4d401_csd_functions_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_CSD_FUNCTIONS_2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA text   TYPE string VALUE `  Let's talk about ABAP  `.
    DATA result TYPE i.

    out->write(  |Input string: { text } | ).

    out->write( `------------------------` ).

    result = find( val = text sub = 'A' ).
    out->write(  |Find 'A' (standard):                 { result } | ).

    result = find( val = text sub = 'A' case = abap_false ).
    out->write(  |Find 'A' (case = abap_false):        { result } | ).

    result = find( val = text sub = 'A' case = abap_false occ =  -1 ).
    out->write(  |Find 'A' (occ = -1):                 { result } | ).

    result = find( val = text sub = 'A' case = abap_false occ =  -2 ).
    out->write(  |Find 'A' (occ = -2):                 { result } | ).

    result = find( val = text sub = 'A' case = abap_false occ =   2 ).
    out->write(  |Find 'A' (occ =  2):                 { result } | ).

    result = find( val = text sub = 'A' case = abap_false occ = 2 off = 10 ).
    out->write(  |Find 'A' (occ = 2 off = 10):         { result } | ).

    result = find( val = text sub = 'A' case = abap_false occ = 2 off = 10 len = 4 ).
    out->write(  |Find 'A' (occ = 2 off = 10 len = 4): { result } | ).


  ENDMETHOD.
ENDCLASS.
