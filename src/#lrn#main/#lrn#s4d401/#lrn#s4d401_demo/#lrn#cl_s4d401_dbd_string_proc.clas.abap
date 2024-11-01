CLASS /lrn/cl_s4d401_dbd_string_proc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_STRING_PROC IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT FROM /dmo/customer
         FIELDS customer_id,

                street && ',' && ' ' && postal_code && ' ' && city   AS address_expr,

                concat( street,
                        concat_with_space(  ',',
                                             concat_with_space( postal_code,
                                                                upper(  city ),
                                                                1
                                                              ),
                                            1
                                         )
                     ) AS address_func

          WHERE country_code = 'ES'
           INTO TABLE @DATA(result_concat).

    out->write(
      EXPORTING
        data   = result_concat
        name   = 'Concatenation'
    ).

**********************************************************************
out->write(  `-------------------------------------------------------------------------` ).
    SELECT FROM /dmo/carrier
         FIELDS carrier_id,
                name,
                upper( name )   AS name_upper,
                lower( name )   AS name_lower,
                initcap( name ) AS name_initcap

          WHERE carrier_id = 'SR'
           INTO TABLE @DATA(result_transform).

    out->write(
      EXPORTING
        data   = result_transform
        name   = 'Uppercase/Lowercase'
    ).

**********************************************************************
out->write(  `-------------------------------------------------------------------------` ).

  SELECT FROM /dmo/flight
       FIELDS flight_date,
              cast( flight_date as char( 8 ) )  as flight_date_raw,

              left(      flight_date, 4    ) AS year,
              right(     flight_date, 2    ) AS day,
              substring( flight_date, 5, 2 ) AS month

        WHERE carrier_id = 'LH'
          AND connection_id = '0400'
         INTO TABLE @DATA(result_substring).

    out->write(
      EXPORTING
        data   = result_substring
        name   = 'Substring extraction'
    ).
  ENDMETHOD.
ENDCLASS.
