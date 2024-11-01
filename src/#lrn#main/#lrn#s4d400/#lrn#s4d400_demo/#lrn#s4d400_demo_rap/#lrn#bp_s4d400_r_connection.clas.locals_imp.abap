CLASS LCL_HANDLER DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Connection
        RESULT result,
      GetCities FOR DETERMINE ON SAVE
            IMPORTING keys FOR Connection~GetCities.

          METHODS CheckCarrierID FOR VALIDATE ON SAVE
            IMPORTING keys FOR Connection~CheckCarrierID.

          METHODS CheckOriginDestination FOR VALIDATE ON SAVE
            IMPORTING keys FOR Connection~CheckOriginDestination.

          METHODS CheckSemanticKey FOR VALIDATE ON SAVE
            IMPORTING keys FOR Connection~CheckSemanticKey.
ENDCLASS.

CLASS LCL_HANDLER IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
 METHOD CheckSemanticKey.


    READ ENTITIES OF /LRN/S4D400_r_connection IN LOCAL MODE
           ENTITY Connection
           FIELDS ( CarrierID ConnectionID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(connections).

    LOOP AT connections INTO DATA(connection).

      SELECT FROM /LRN/S4D400aconn
           FIELDS uuid
            WHERE carrier_id    = @connection-CarrierID
              AND connection_id = @connection-ConnectionID
              AND uuid          <> @connection-uuid
      UNION
      SELECT FROM /LRN/S4D400dconn
           FIELDS uuid
            WHERE carrierid     = @connection-CarrierID
              AND connectionid  = @connection-ConnectionID
              AND uuid          <> @connection-uuid

       INTO TABLE @DATA(check_result).

      IF check_result IS NOT INITIAL.

        DATA(message) = me->new_message(
                          id       = '/LRN/S4D400'
                          number   = '001'
                          severity = ms-error
                          v1       = connection-CarrierID
                          v2       = connection-ConnectionID
                        ).

        DATA reported_record LIKE LINE OF reported-connection.

        reported_record-%tky = connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-CarrierID    = if_abap_behv=>mk-on.
        reported_record-%element-ConnectionID = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.

        DATA failed_record LIKE LINE OF failed-connection.

        failed_record-%tky = connection-%tky.
        APPEND failed_record TO failed-connection.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD CheckCarrierID.

    READ ENTITIES OF /LRN/S4D400_r_connection IN LOCAL MODE
           ENTITY Connection
           FIELDS (  CarrierID )
             WITH CORRESPONDING #(  keys )
           RESULT DATA(connections).


    LOOP AT connections INTO DATA(connection).

      SELECT SINGLE
        FROM /DMO/I_Carrier
      FIELDS @abap_true
       WHERE airlineid = @connection-CarrierID
       INTO @DATA(exists).

      IF exists = abap_false.

        DATA(message) = me->new_message(
                          id       = '/LRN/S4D400'
                          number   = '002'
                          severity =  ms-error
                          v1       = connection-CarrierID
                        ) .


        DATA reported_record LIKE LINE OF reported-connection.

        reported_record-%tky = connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-carrierid = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.

        DATA failed_record LIKE LINE OF failed-connection.

        failed_record-%tky = connection-%tky.
        APPEND failed_Record TO failed-connection.


      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD CheckOriginDestination.

    READ ENTITIES OF /LRN/S4D400_r_Connection IN LOCAL MODE
           ENTITY Connection
           FIELDS ( AirportFromID AirportToID )
             WITH CORRESPONDING #(  keys )
           RESULT DATA(connections).

    LOOP AT connections INTO DATA(connection).
      IF connection-AirportFromID = connection-AirportToID.

        DATA(message) = me->new_message(
                          id       = '/LRN/S4D400'
                         number   = '003'
                          severity = ms-error
                       ).

        DATA reported_record LIKE LINE OF reported-connection.

        reported_record-%tky =  connection-%tky.
        reported_record-%msg = message.
        reported_record-%element-AirportFromID = if_abap_behv=>mk-on.
        reported_record-%element-AirportToID   = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-connection.

        DATA failed_record LIKE LINE OF failed-connection.

        failed_record-%tky = connection-%tky.
        APPEND failed_record TO failed-connection.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD GetCities.

    READ ENTITIES OF /LRN/S4D400_r_connection IN LOCAL MODE
           ENTITY Connection
           FIELDS ( AirportFromID AirportToID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(connections).

    LOOP AT connections INTO DATA(connection).

      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS city, CountryCode
       WHERE AirportID = @connection-AirportFromID
        INTO ( @connection-CityFrom, @connection-CountryTo ).

      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS city, CountryCode
       WHERE AirportID = @connection-AirportToID
        INTO ( @connection-CityTo, @connection-CountryTo ).

      MODIFY connections FROM connection.

    ENDLOOP.

    DATA connections_upd TYPE TABLE FOR UPDATE /LRN/S4D400_r_connection.

    connections_upd = CORRESPONDING #( connections ).

    MODIFY ENTITIES OF /LRN/S4D400_r_connection IN LOCAL MODE
             ENTITY Connection
             UPDATE
             FIELDS ( CityFrom CountryFrom CityTo CountryTo )
               WITH connections_upd
           REPORTED DATA(reported_records).

    reported-connection = CORRESPONDING #( reported_records-connection ).

  ENDMETHOD.

ENDCLASS.
