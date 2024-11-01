CLASS /lrn/cl_s4d400_std_stru_types DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D400_STD_STRU_TYPES IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Example 1 : Motivation for Structured Variables
**********************************************************************

    DATA connection_full TYPE /dmo/i_connection.

    SELECT SINGLE
     FROM /dmo/i_connection
   FIELDS airlineid, connectionid, departureairport, destinationairport,
          departuretime, arrivaltime, distance, distanceunit
    WHERE airlineid    = 'LH'
      AND connectionid = '0400'
     INTO @connection_full.

    out->write(  `--------------------------------------` ).
    out->write(  `Example 1: CDS View as Structured Type` ).
    out->write( connection_full ).

* Example 2: Global Structured Type
**********************************************************************

    DATA message TYPE symsg.

    out->write(  `---------------------------------` ).
    out->write(  `Example 2: Global Structured Type` ).
    out->write( message ).

* Example 3 : Local Structured Type
**********************************************************************

    TYPES: BEGIN OF st_connection,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_connection.

    DATA connection TYPE st_connection.

    SELECT SINGLE
      FROM /dmo/i_connection
    FIELDS departureairport, destinationairport, \_airline-name
     WHERE airlineid = 'LH'
       AND connectionid = '0400'
      INTO @connection.

    out->write(  `---------------------------------------` ).
    out->write(  `Example 3: Global Local Structured Type` ).
    out->write( connection ).

* Example 4 : Nested Structured Type
**********************************************************************

    TYPES: BEGIN OF st_nested,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             message         TYPE symsg,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_nested.

    DATA connection_nested TYPE st_nested.

    out->write(  `---------------------------------` ).
    out->write(  `Example 4: Nested Structured Type` ).
    out->write( connection_nested ).


  ENDMETHOD.
ENDCLASS.
