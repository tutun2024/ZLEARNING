CLASS /lrn/cl_setup_s4d430 DEFINITION
  PUBLIC
  INHERITING FROM /lrn/cl_setup_root
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS run REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS /LRN/CL_SETUP_S4D430 IMPLEMENTATION.


  METHOD run.

* general setup tasks:
    super->run( ).

* additional setup tasks:
    adjust_authorizations( ).
    generate_s4d430_data( ).

  ENDMETHOD.
ENDCLASS.
