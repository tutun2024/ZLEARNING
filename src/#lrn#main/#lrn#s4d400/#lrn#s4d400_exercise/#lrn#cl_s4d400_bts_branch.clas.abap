CLASS /lrn/cl_s4d400_bts_branch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D400_BTS_BRANCH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Declarations
**************************

    DATA number1 TYPE i.
    DATA number2 TYPE i.

    DATA result  TYPE p LENGTH 8 DECIMALS 2.

    DATA op      TYPE c LENGTH 1.

    DATA output TYPE string.

* Input Values
**************************

    number1 = 123.
    number2 = 0.
    op      = '/'.

* Calculation
**************************

* a) calculation based on op
*    CASE op.
*      WHEN '+'.
*        result = number1 + number2.
*      WHEN '-'.
*        result = number1 - number2.
*      WHEN '*'.
*        result = number1 * number2.
*      WHEN '/'.
*        result = number1 / number2.
*    ENDCASE.
*
*    DATA(output) = |{ number1 } { op } { number2 } = { result }|.

* b) handle invalid operator
*    CASE op.
*      WHEN '+'.
*        result = number1 + number2.
*      WHEN '-'.
*        result = number1 - number2.
*      WHEN '*'.
*        result = number1 * number2.
*      WHEN '/'.
*        result = number1 / number2.
*      WHEN OTHERS.
*        output = |'{ op }' is not a valid operator!|.
*    ENDCASE.
*
*    IF output IS INITIAL.  "no error so far
*      output = |{ number1 } { op } { number2 } = { result }|.
*    ENDIF.

* c) handle division by zero

    CASE op.
      WHEN '+'.
        result = number1 + number2.
      WHEN '-'.
        result = number1 - number2.
      WHEN '*'.
        result = number1 * number2.
      WHEN '/'.

        TRY.
            result = number1 / number2.
          CATCH cx_sy_zerodivide.
            output = |Division by zero is not defined|.
        ENDTRY.

      WHEN OTHERS.

        output = |'{ op }' is not a valid operator!|.

    ENDCASE.

    IF output IS INITIAL.  "no error so far

      output = |{ number1 } { op } { number2 } = { result }|.

    ENDIF.

* Output
**************************

    out->write( output ).

  ENDMETHOD.
ENDCLASS.
