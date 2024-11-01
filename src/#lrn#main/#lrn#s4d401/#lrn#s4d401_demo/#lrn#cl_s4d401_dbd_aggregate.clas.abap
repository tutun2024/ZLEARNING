CLASS /lrn/cl_s4d401_dbd_aggregate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_AGGREGATE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    SELECT FROM /dmo/connection
         FIELDS carrier_id,
                connection_id,
                airport_from_id,
                distance
          WHERE carrier_id = 'LH'
           INTO TABLE @DATA(result_raw).


    out->write(
      EXPORTING
        data   = result_raw
        name   = 'Raw Data'
    ).


*********************************************************************
out->write( `----------------------------------------------------` ).
    SELECT FROM /dmo/connection
         FIELDS MAX( distance ) AS max_dist,
                MIN( distance ) AS min_dist,
                SUM( distance ) AS sum_dist,
                AVG( distance as FLTP ) AS avg_dist,
                COUNT( * ) AS count,
                COUNT( DISTINCT airport_from_id ) AS count_dist_airpfrom

          WHERE carrier_id = 'LH'
           INTO TABLE @DATA(result_aggregate).

    out->write(
      EXPORTING
        data   = result_aggregate
        name   = 'Aggregated Result'
    ).

  ENDMETHOD.
ENDCLASS.
