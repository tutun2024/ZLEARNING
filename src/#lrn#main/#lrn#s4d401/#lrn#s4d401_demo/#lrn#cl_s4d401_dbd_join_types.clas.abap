CLASS /lrn/cl_s4d401_dbd_join_types DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_JOIN_TYPES IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT FROM /dmo/Agency AS a
                INNER JOIN /dmo/customer AS c
*           LEFT OUTER JOIN /dmo/customer AS c
*          RIGHT OUTER JOIN /dmo/customer AS c
             ON a~city         = c~city

         FIELDS agency_id,
                name AS Agency_name,
                a~city AS agency_city,
                c~city AS customer_city,
                customer_id,
                last_name AS customer_name

          WHERE ( c~customer_id < '000010' OR c~customer_id IS NULL )
            AND ( a~agency_id   < '070010' OR a~agency_id   IS NULL )

           INTO TABLE @DATA(result_inner).

**********************************************************************
out->write( `---------------------------------------------------------` ).

    out->write(
      EXPORTING
        data   = result_inner
        name   = 'Inner Join'
    ).

    SELECT FROM /dmo/Agency AS a
           LEFT OUTER JOIN /dmo/customer AS c
*          RIGHT OUTER JOIN /dmo/customer AS c
             ON a~city         = c~city

         FIELDS agency_id,
                name AS Agency_name,
                a~city AS agency_city,
                c~city AS customer_city,
                customer_id,
                last_name AS customer_name

          WHERE ( c~customer_id < '000010' OR c~customer_id IS NULL )
            AND ( a~agency_id   < '070010' OR a~agency_id   IS NULL )

           INTO TABLE @DATA(result_left).

**********************************************************************
out->write( `---------------------------------------------------------` ).

    out->write(
      EXPORTING
        data   = result_left
        name   = 'Left Outer Join'
    ).

    SELECT FROM /dmo/Agency AS a
          RIGHT OUTER JOIN /dmo/customer AS c
             ON a~city         = c~city

         FIELDS agency_id,
                name AS Agency_name,
                a~city AS agency_city,
                c~city AS customer_city,
                customer_id,
                last_name AS customer_name

          WHERE ( c~customer_id < '000010' OR c~customer_id IS NULL )
            AND ( a~agency_id   < '070010' OR a~agency_id   IS NULL )

           INTO TABLE @DATA(result_right).


    out->write(
      EXPORTING
        data   = result_right
        name   = 'Right Outer Join'
    ).


  ENDMETHOD.
ENDCLASS.
