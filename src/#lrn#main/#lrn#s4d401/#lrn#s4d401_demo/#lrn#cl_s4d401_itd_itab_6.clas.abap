CLASS /lrn/cl_s4d401_itd_itab_6 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_ITD_ITAB_6 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
* Run this class using the ABAP Profiler to measure relative access times for standard, sorted, and hashed tables

    DATA(flights) = NEW lcl_flights(  ).

    flights->access_standard(  ).
    flights->access_sorted(  ).
    flights->access_hashed( ).

    out->write( `Done`  ).

  ENDMETHOD.
ENDCLASS.
