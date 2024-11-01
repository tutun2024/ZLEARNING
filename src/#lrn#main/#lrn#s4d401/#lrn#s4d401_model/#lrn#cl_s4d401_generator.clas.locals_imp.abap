*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

**"* use this source file for the definition and implementation of
**"* local helper classes, interface definitions and type
**"* declarations
*

CLASS lcl_generator DEFINITION ABSTRACT.

  PUBLIC SECTION.

    TYPES tt_log TYPE STANDARD TABLE OF string
                 WITH NON-UNIQUE DEFAULT KEY.

    CLASS-DATA log TYPE tt_log READ-ONLY.

    METHODS
      constructor
        IMPORTING
          i_table_name TYPE tabname
          ir_data      TYPE REF TO data
        RAISING
          cx_abap_not_a_table.

    METHODS generate ABSTRACT.

    CLASS-METHODS
      save.


  PROTECTED SECTION.
    CONSTANTS random_min TYPE i VALUE 0.
    CONSTANTS random_max TYPE i VALUE 1000000.

    CLASS-DATA instances TYPE TABLE OF REF TO lcl_generator.
    DATA random TYPE REF TO cl_abap_random_int.

  PRIVATE SECTION.




    DATA table_name  TYPE tabname.
    DATA r_data      TYPE REF TO data.

    METHODS table_exists
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS is_empty_db
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS delete_db.

    METHODS insert_db.


ENDCLASS.

CLASS lcl_generator IMPLEMENTATION.

  METHOD constructor.

    table_name = i_table_name.

    IF table_exists( ) <> abap_true.
      RAISE EXCEPTION TYPE cx_abap_not_a_table
        EXPORTING
          value = CONV #( table_name ).
    ENDIF.

    r_data = ir_data.
    APPEND me TO instances.

    DATA(seed) = CONV i( cl_abap_context_info=>get_system_date(   ) ).
    me->random = cl_abap_random_int=>create( seed = seed
                                              min = me->random_min
                                              max = me->random_max ).

  ENDMETHOD.

  METHOD save.

    LOOP AT instances INTO DATA(instance).

      IF instance->is_empty_db( ) <> abap_false.
        instance->delete_db(  ).
      ENDIF.

      instance->insert_db(  ).

    ENDLOOP.

    COMMIT WORK.

  ENDMETHOD.

  METHOD table_exists.
    cl_abap_typedescr=>describe_by_name(
       EXPORTING
         p_name = table_name
      EXCEPTIONS
        type_not_found = 1
    ).
    IF sy-subrc = 0.
      result = abap_true.
    ELSE.
      result = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD is_empty_db.

    CLEAR result.

    SELECT SINGLE
      FROM (table_name)
    FIELDS @abap_true
     INTO @result.

  ENDMETHOD.

  METHOD delete_db.
    DELETE FROM (table_name).
    APPEND |Deleted content from table { table_name }| TO log.
  ENDMETHOD.

  METHOD insert_db.

    DATA r_itab TYPE REF TO data.

    CREATE DATA r_itab TYPE TABLE OF (table_name).

    r_itab->* = CORRESPONDING #( r_data->* ).

    INSERT (table_name) FROM TABLE @r_itab->*.

    APPEND |Filled table { table_name } with { lines( r_itab->* ) } rows | TO log.

  ENDMETHOD.


ENDCLASS.

CLASS lcl_generator_carrier DEFINITION INHERITING FROM lcl_generator.

  PUBLIC SECTION.

    CONSTANTS c_tabname TYPE tabname VALUE '/LRN/CARRIER'.

    METHODS constructor
      RAISING cx_abap_not_a_table.

    METHODS generate REDEFINITION.

    DATA carriers TYPE TABLE OF /lrn/carrier READ-ONLY.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_generator_carrier IMPLEMENTATION.

  METHOD constructor.

    super->constructor(  i_table_name = c_tabname
                         ir_data = REF #( me->carriers ) ).

  ENDMETHOD.

  METHOD generate.

    SELECT FROM /dmo/carrier
           FIELDS *
           INTO TABLE @me->carriers.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_generator_connection DEFINITION INHERITING FROM lcl_generator.

  PUBLIC SECTION.

    CONSTANTS c_tabname TYPE tabname VALUE '/LRN/CONNECTION'.

    METHODS constructor
      RAISING cx_abap_not_a_table.

    METHODS generate REDEFINITION.

    DATA connections TYPE TABLE OF /lrn/connection READ-ONLY.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_generator_connection IMPLEMENTATION.

  METHOD constructor.

    super->constructor(  i_table_name = c_tabname
                         ir_data = REF #( me->connections ) ).

  ENDMETHOD.

  METHOD generate.

    SELECT FROM /dmo/connection
           FIELDS *
           INTO TABLE @me->connections.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_generator_airport DEFINITION INHERITING FROM lcl_generator.

  PUBLIC SECTION.

    CONSTANTS c_tabname TYPE tabname VALUE '/LRN/AIRPORT'.

    METHODS constructor
      RAISING cx_abap_not_a_table.

    METHODS generate REDEFINITION.

    DATA airports TYPE TABLE OF /lrn/airport READ-ONLY.

    CLASS-METHODS class_constructor.

  PRIVATE SECTION.

    TYPES: BEGIN OF st_airp_tzone,
             airp  TYPE /dmo/airport_id,
             tzone TYPE timezone,
           END OF st_airp_tzone.


    CLASS-DATA airp_tzone TYPE HASHED TABLE OF st_airp_tzone
       WITH UNIQUE KEY airp.

    CLASS-METHODS fill_airp_tzone.

ENDCLASS.

CLASS lcl_generator_airport IMPLEMENTATION.

  METHOD class_constructor.
    fill_airp_tzone(  ).
  ENDMETHOD.

  METHOD constructor.

    super->constructor(  i_table_name = c_tabname
                         ir_data = REF #( me->airports ) ).

  ENDMETHOD.

  METHOD generate.

    SELECT FROM /dmo/airport
           FIELDS *
           INTO TABLE @DATA(airports).

* Add timezone

    me->airports =
       VALUE #( FOR <row> IN airports
                ( VALUE #(
                           BASE <row>
                           timzone = airp_tzone[ airp = <row>-airport_id ]-tzone
                         )
                )
               ).

  ENDMETHOD.

  METHOD fill_airp_tzone.

    airp_tzone = VALUE #(
  ( airp = 'ACA' tzone = 'UTC-6'  )
  ( airp = 'ACE' tzone = 'UTC'    )
  ( airp = 'AIY' tzone = 'UTC-5'  )
  ( airp = 'ASP' tzone = 'UTC+9'  )
  ( airp = 'BKK' tzone = 'UTC+7'  )
  ( airp = 'BNA' tzone = 'UTC-5'  )
  ( airp = 'BOS' tzone = 'UTC-5'  )
  ( airp = 'CDG' tzone = 'UTC+1'  )
  ( airp = 'DEN' tzone = 'UTC-7'  )
  ( airp = 'ELP' tzone = 'UTC-7'  )
  ( airp = 'EWR' tzone = 'UTC-5'  )
  ( airp = 'FCO' tzone = 'UTC+1'  )
  ( airp = 'FRA' tzone = 'UTC+1'  )
  ( airp = 'GCJ' tzone = 'UTC+2'  )
  ( airp = 'GIG' tzone = 'UTC-3'  )
  ( airp = 'HAM' tzone = 'UTC+1'  )
  ( airp = 'HAV' tzone = 'UTC-5'  )
  ( airp = 'HIJ' tzone = 'UTC+9'  )
  ( airp = 'HKG' tzone = 'UTC+8'  )
  ( airp = 'HOU' tzone = 'UTC-6'  )
  ( airp = 'HRE' tzone = 'UTC+2'  )
  ( airp = 'ITM' tzone = 'UTC+9'  )
  ( airp = 'JFK' tzone = 'UTC-5'  )
  ( airp = 'JKT' tzone = 'UTC+7'  )
  ( airp = 'KIX' tzone = 'UTC+9'  )
  ( airp = 'KUL' tzone = 'UTC+8'  )
  ( airp = 'LAS' tzone = 'UTC-8'  )
  ( airp = 'LAX' tzone = 'UTC-8'  )
  ( airp = 'LCY' tzone = 'UTC'    )
  ( airp = 'LGW' tzone = 'UTC'    )
  ( airp = 'LHR' tzone = 'UTC'    )
  ( airp = 'MAD' tzone = 'UTC+1'  )
  ( airp = 'MCI' tzone = 'UTC-6'  )
  ( airp = 'MIA' tzone = 'UTC-5'  )
  ( airp = 'MUC' tzone = 'UTC+1'  )
  ( airp = 'NRT' tzone = 'UTC+9'  )
  ( airp = 'ORY' tzone = 'UTC+1'  )
  ( airp = 'PID' tzone = 'UTC-5'  )
  ( airp = 'RTM' tzone = 'UTC+1'  )
  ( airp = 'SEL' tzone = 'UTC+9'  )
  ( airp = 'SFO' tzone = 'UTC-8'  )
  ( airp = 'SIN' tzone = 'UTC+8'  )
  ( airp = 'STO' tzone = 'UTC+1'  )
  ( airp = 'SVO' tzone = 'UTC+3'  )
  ( airp = 'SXF' tzone = 'UTC+1'  )
  ( airp = 'THF' tzone = 'UTC+1'  )
  ( airp = 'TXL' tzone = 'UTC+1'  )
  ( airp = 'TYO' tzone = 'UTC+9'  )
  ( airp = 'VCE' tzone = 'UTC+1'  )
  ( airp = 'VIE' tzone = 'UTC+1'  )
  ( airp = 'VKO' tzone = 'UTC+3'  )
  ( airp = 'YEG' tzone = 'UTC-7'  )
  ( airp = 'YOW' tzone = 'UTC-5'  )
  ( airp = 'ZRH' tzone = 'UTC+1'  )
                       ).

  ENDMETHOD.

ENDCLASS.


CLASS lcl_generator_passflight DEFINITION INHERITING FROM lcl_generator.

  PUBLIC SECTION.

    CONSTANTS c_tabname TYPE tabname VALUE '/LRN/PASSFLIGHT'.

    METHODS constructor
      RAISING cx_abap_not_a_table.

    METHODS generate REDEFINITION.

    DATA flights TYPE TABLE OF /lrn/passflight READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_generator_passflight IMPLEMENTATION.

  METHOD constructor.

    super->constructor( i_table_name = c_tabname
                        ir_data = REF #( flights ) ).

  ENDMETHOD.

  METHOD generate.

* Get available plane types
    SELECT FROM /dmo/flight
          FIELDS DISTINCT plane_type_id, seats_max
            INTO TABLE @DATA(planes).

* Get existing flight data
    SELECT FROM /dmo/flight
         FIELDS *
         INTO TABLE @DATA(flights_raw).

* remove duplicates
    SORT flights_raw BY carrier_id
                        connection_id
                        flight_date.
    DELETE ADJACENT DUPLICATES FROM flights_raw COMPARING carrier_id connection_id.

* Replicate flights on different dates .

    LOOP AT flights_raw INTO DATA(flight).

      me->flights = VALUE #(
          BASE me->flights
          FOR i = -4000 THEN i + 2 UNTIL i > 6000
          (  VALUE #( BASE flight
                      flight_date   = flight-flight_date + i ) ) ).

    ENDLOOP.

* adjust plane type, maimum and occupied seats:   (up to 20 overbooked )

    LOOP AT me->flights ASSIGNING FIELD-SYMBOL(<row>).
      DATA(plane) = planes[ ( me->random->get_next( ) MOD lines( planes ) ) + 1 ] .
      <row>-plane_type_id = plane-plane_type_id.
      <row>-seats_max = plane-seats_max.
      <row>-seats_occupied = me->random->get_next( ) MOD ( <row>-seats_max + 20 ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_generator_cargoflight DEFINITION INHERITING FROM lcl_generator.

  PUBLIC SECTION.

    CONSTANTS c_tabname TYPE tabname VALUE '/LRN/CARGOFLIGHT'.

    METHODS constructor
      RAISING cx_abap_not_a_table.

    METHODS generate REDEFINITION.

    DATA flights TYPE TABLE OF /lrn/cargoflight READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_generator_cargoflight IMPLEMENTATION.

  METHOD constructor.

    super->constructor( i_table_name = c_tabname
                        ir_data = REF #( flights ) ).

  ENDMETHOD.

  METHOD generate.
    TYPES: BEGIN OF st_plane,
             plane_type_id TYPE /dmo/plane_type_id,
             maximum_load  TYPE /lrn/plane_maximum_load,
             load_unit     TYPE /lrn/plane_weight_unit,
           END OF st_plane.

    DATA planes      TYPE TABLE OF st_plane.
    DATA flights_raw LIKE me->flights.

    planes =
 VALUE #( load_unit = 'KG'
          (  plane_type_id = 'A310-200F' maximum_load = 70000  )
          (  plane_type_id = 'A310-200ST' maximum_load = 120000  )
          (  plane_type_id = '737-200SF' maximum_load = 70000  ) ).

    flights_raw =
    VALUE #(
        ( carrier_id = 'SQ' connection_id = '0501' airport_from_id = 'SFO' airport_to_id = 'SIN' departure_time = '015300' arrival_time = '153000'  )
        ( carrier_id = 'SQ' connection_id = '0502' airport_from_id = 'SIN' airport_to_id = 'SFO' departure_time = '073000' arrival_time = '011500'  )
        ( carrier_id = 'SQ' connection_id = '0711' airport_from_id = 'NRT' airport_to_id = 'SIN' departure_time = '115500' arrival_time = '175000'  )
        ( carrier_id = 'SQ' connection_id = '0712' airport_from_id = 'SIN' airport_to_id = 'NRT' departure_time = '025300' arrival_time = '105400'  )
        ( carrier_id = 'UA' connection_id = '0158' airport_from_id = 'SFO' airport_to_id = 'FRA' departure_time = '124500' arrival_time = '085500'  )
        ( carrier_id = 'UA' connection_id = '0159' airport_from_id = 'FRA' airport_to_id = 'SFO' departure_time = '085500' arrival_time = '113000'  )
        ( carrier_id = 'UA' connection_id = '3537' airport_from_id = 'EWR' airport_to_id = 'MIA' departure_time = '205600' arrival_time = '234700'  )
        ( carrier_id = 'AA' connection_id = '3322' airport_from_id = 'MIA' airport_to_id = 'EWR' departure_time = '102700' arrival_time = '132900'  )
        ( carrier_id = 'AA' connection_id = '7017' airport_from_id = 'MIA' airport_to_id = 'HAV' departure_time = '082900' arrival_time = '091300'  )
        ( carrier_id = 'AA' connection_id = '7678' airport_from_id = 'HAV' airport_to_id = 'MIA' departure_time = '083500' arrival_time = '125000'  )
        ( carrier_id = 'AA' connection_id = '6015' airport_from_id = 'JFK' airport_to_id = 'SFO' departure_time = '103300' arrival_time = '132400'  )
        ( carrier_id = 'AA' connection_id = '6018' airport_from_id = 'SFO' airport_to_id = 'JFK' departure_time = '055000' arrival_time = '141600'  )
        ( carrier_id = 'LH' connection_id = '9400' airport_from_id = 'FRA' airport_to_id = 'JFK' departure_time = '093000' arrival_time = '105400'  )
        ( carrier_id = 'LH' connection_id = '9401' airport_from_id = 'JFK' airport_to_id = 'FRA' departure_time = '221000' arrival_time = '112500'  )
        ( carrier_id = 'LH' connection_id = '9402' airport_from_id = 'FRA' airport_to_id = 'EWR' departure_time = '094000' arrival_time = '114500'  )
        ( carrier_id = 'LH' connection_id = '9403' airport_from_id = 'EWR' airport_to_id = 'FRA' departure_time = '161900' arrival_time = '054000'  )
        ( carrier_id = 'JL' connection_id = '7407' airport_from_id = 'NRT' airport_to_id = 'FRA' departure_time = '161300' arrival_time = '184600'  )
        ( carrier_id = 'JL' connection_id = '7408' airport_from_id = 'FRA' airport_to_id = 'NRT' departure_time = '213500' arrival_time = '165000'  )
        ( carrier_id = 'AZ' connection_id = '3788' airport_from_id = 'VCE' airport_to_id = 'NRT' departure_time = '151500' arrival_time = '120300'  )
        ( carrier_id = 'AZ' connection_id = '3789' airport_from_id = 'NRT' airport_to_id = 'VCE' departure_time = '134600' arrival_time = '195100'  ) ).


* Duplicate with varying flight date

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT flights_raw INTO DATA(flight).

      me->flights = VALUE #( BASE me->flights
                             FOR i = -100 THEN i + 13 UNTIL i > 1000
                             (  VALUE #( BASE flight
                                         flight_date = today + i ) ) ).

    ENDLOOP.

    " Update planetype and cargo weight

    LOOP AT me->flights ASSIGNING FIELD-SYMBOL(<row>).

      DATA(plane) = planes[ sy-tabix MOD lines( planes ) + 1 ].
      <row>-plane_type_id = plane-plane_type_id.
      <row>-maximum_load  = plane-maximum_load.
      <row>-actual_load   = me->random->get_next( )
                           MOD ( <row>-maximum_load ).
      <row>-load_unit = 'KG'.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
