CLASS /lrn/cl_s4d401_atd_perf_atc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_ATD_PERF_ATC IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TYPES:
      BEGIN OF ts_customer,
        customer_id TYPE /dmo/customer_id,
        first_name  TYPE /dmo/first_name,
        last_name   TYPE /dmo/last_name,
      END OF ts_customer.


    DATA customers TYPE TABLE OF ts_customer.

    SELECT *
      FROM /dmo/customer
      INTO TABLE @DATA(customers_all).

    LOOP AT customers_all INTO DATA(customer)
      WHERE country_code = 'DE'.

      APPEND CORRESPONDING #( customer )
          TO customers.

    ENDLOOP.

    out->write( customers ).

  ENDMETHOD.
ENDCLASS.
