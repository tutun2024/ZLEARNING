CLASS /lrn/cl_s4d401_atd_profiling1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_ATD_PROFILING1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


    DATA(flights) = lcl_data=>get_flights( ).

    SORT flights BY flight_date DESCENDING.

    out->write(  name = `List of all Flights`
                 data = flights ).

  ENDMETHOD.
ENDCLASS.
