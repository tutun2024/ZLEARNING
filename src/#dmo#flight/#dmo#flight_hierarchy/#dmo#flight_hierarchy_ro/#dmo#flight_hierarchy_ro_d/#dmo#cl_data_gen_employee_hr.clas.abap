CLASS /dmo/cl_data_gen_employee_hr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES /dmo/if_data_generation_badi .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /DMO/CL_DATA_GEN_EMPLOYEE_HR IMPLEMENTATION.


  METHOD /dmo/if_data_generation_badi~data_generation.
    NEW lcl_employee_generator( )->create( out ).
  ENDMETHOD.
ENDCLASS.
