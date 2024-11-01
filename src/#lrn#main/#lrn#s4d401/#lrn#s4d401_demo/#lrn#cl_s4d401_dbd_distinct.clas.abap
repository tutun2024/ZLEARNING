CLASS /lrn/cl_s4d401_dbd_distinct DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_DISTINCT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT FROM /dmo/connection
   FIELDS airport_from_id,
          distance_unit
    WHERE carrier_id = 'LH'
 ORDER BY airport_from_id
     INTO TABLE @DATA(result_raw).

    out->write(
      EXPORTING
        data   = result_raw
        name   = 'Without Distinct'
    ).

*******************************************************
    out->write( `----------------------------------------------------------` ).

    SELECT FROM /dmo/connection
   FIELDS DISTINCT
          airport_from_id,
          distance_unit
    WHERE carrier_id = 'LH'
 ORDER BY airport_from_id
     INTO TABLE @DATA(result_dist).

    out->write(
      EXPORTING
        data   = result_dist
        name   = 'With Distinct'
    ).


  ENDMETHOD.
ENDCLASS.
