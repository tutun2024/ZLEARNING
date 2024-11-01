CLASS /lrn/cl_s4d401_tcd_types_4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_TCD_TYPES_4 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* The inline declaration derives its type from the operands on the
* right-hand side of the expression. Thus, in both cases, it is type I
* and the result of 5 divided by 10 is rounded up to 1


  data(result1) = 5 * 10.
  out->write(  |5 * 10 = { result1 }| ).

  data(result2) = 5 / 10.
  out->write(  |5 / 10 = { result2 }| ).


  ENDMETHOD.
ENDCLASS.
