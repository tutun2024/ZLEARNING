CLASS /lrn/cl_setup_s4d401 DEFINITION
  PUBLIC
  INHERITING FROM /lrn/cl_setup_root
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS run REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS /LRN/CL_SETUP_S4D401 IMPLEMENTATION.


  METHOD run.

* general setup tasks:
    super->run( ).

* additional setup tasks:
    adjust_authorizations( ).
    generate_s4d401_data( ).

  ENDMETHOD.
ENDCLASS.
