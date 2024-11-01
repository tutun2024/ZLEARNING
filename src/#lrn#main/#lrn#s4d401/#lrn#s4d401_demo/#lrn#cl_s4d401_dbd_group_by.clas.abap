CLASS /lrn/cl_s4d401_dbd_group_by DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_GROUP_BY IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT FROM /dmo/connection
     FIELDS
            MAX( distance ) AS max_dist,
            MIN( distance ) AS min_dist,
            SUM( distance ) AS sum_dist,
            COUNT( * ) AS count
       INTO TABLE @DATA(result_all).

    out->write(
      EXPORTING
        data   = result_all
        name   = 'Aggregate all Connections'
    ).

*************************************************************
    out->write( `---------------------------------------------------` ).

    SELECT FROM /dmo/connection
     FIELDS
            carrier_id,

            MAX( distance ) AS max_dist,
            MIN( distance ) AS min_dist,
            SUM( distance ) AS sum_dist,
            COUNT( * ) AS count
   GROUP BY carrier_id
       INTO TABLE @DATA(result_group).

    out->write(
      EXPORTING
        data   = result_group
        name   = 'Aggregation per carrier'
    ).

  ENDMETHOD.
ENDCLASS.
