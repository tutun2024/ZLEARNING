CLASS /lrn/cl_s4d401_exd_handling DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
protected section.
private section.
ENDCLASS.



CLASS /LRN/CL_S4D401_EXD_HANDLING IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Debug this code to demonstrate the exception handling

    DATA number1 TYPE i.
    DATA number2 TYPE p LENGTH 2 DECIMALS 1.
    DATA result  TYPE i.

* Example 1:
**********************************************************************
    number1 =  2000000000.
    number2 = '0.5'.

    TRY.

        result = number1 / number2.

      CATCH cx_sy_arithmetic_overflow.
        out->write( 'Arithmetic Overflow' ).
      CATCH cx_sy_zerodivide.
        out->write( 'Division by zero' ).
    ENDTRY.


* Example 2: Different input
**********************************************************************
    out->write( `------------------------------------------------------` ).

    number1 =  2000000000.
    number2 = 0.
    TRY.

        result = number1 / number2.

      CATCH cx_sy_arithmetic_overflow.
        out->write( 'Arithmetic overflow' ).
      CATCH cx_sy_zerodivide.
        out->write( 'Division by zero' ).
    ENDTRY.

* Example 3: One CATCH block for both exceptions
**********************************************************************
    out->write( `------------------------------------------------------` ).

    TRY.
        result = number1 / number2.

      CATCH cx_sy_arithmetic_overflow cx_sy_zerodivide.
        out->write( 'Arithmetic overflow or division by zero' ).
    ENDTRY.

* Example 4: One CATCH block with common superclass
**********************************************************************
    out->write( `------------------------------------------------------` ).

    TRY.
        result = number1 / number2.
      CATCH cx_sy_arithmetic_error.
        out->write( 'Caught both exceptions using their common superclass' ).
    ENDTRY.

* Example 5: One CATCH block with superclass CX_ROOT
**********************************************************************
    out->write( `------------------------------------------------------` ).

    TRY.
        result = number1 / number2.
      CATCH cx_root.
        out->write( 'Caught any exception using CX_ROOT' ).
    ENDTRY.

* Example 6: Access to exception object
**********************************************************************
    out->write( `------------------------------------------------------` ).

    TRY.
        result = number1 / number2.

      CATCH cx_root INTO DATA(exception).
        out->write( 'Used INTO to intercept the exception object' ).
        out->write( 'The get_text( ) method returns the following error text: ' ).
        out->write( exception->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
