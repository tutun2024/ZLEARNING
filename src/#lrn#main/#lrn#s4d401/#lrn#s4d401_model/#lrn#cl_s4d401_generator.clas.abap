CLASS /lrn/cl_s4d401_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_GENERATOR IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.

        NEW lcl_generator_carrier( )->generate(  ).
        NEW lcl_generator_connection( )->generate(  ).
        NEW lcl_generator_airport( )->generate(  ).
        NEW lcl_generator_passflight( )->generate( ).
        NEW lcl_generator_cargoflight( )->generate( ).

        lcl_generator=>save(   ).

        out->write( name = `Log of S4D401 data generator`
                    data = lcl_generator=>log ).

      CATCH cx_abap_not_a_table INTO DATA(not_a_table).
        out->write(  not_a_table->get_text(  ) ).

    ENDTRY.


  ENDMETHOD.
ENDCLASS.
