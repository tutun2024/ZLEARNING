CLASS /lrn/cx_s4d401_no_connection DEFINITION PUBLIC INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    INTERFACES if_t100_message.
    METHODS constructor
      IMPORTING
        textid        LIKE if_t100_message=>t100key OPTIONAL
        previous      LIKE previous                 OPTIONAL
        carrier_id    TYPE /dmo/carrier_id          OPTIONAL
        connection_id TYPE /dmo/connection_id       OPTIONAL.
    CONSTANTS:
      BEGIN OF /lrn/cx_s4d401_no_connection,
        msgid TYPE symsgid      VALUE '/LRN/S4D401_EXD_DEMO',
        msgno TYPE symsgno      VALUE '001',
        attr1 TYPE scx_attrname VALUE 'CARRIER_ID',
        attr2 TYPE scx_attrname VALUE 'CONNECTION_ID',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF /lrn/cx_s4d401_no_connection.
    DATA carrier_id    TYPE /dmo/carrier_id    READ-ONLY.
    DATA connection_id TYPE /dmo/connection_id READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS /LRN/CX_S4D401_NO_CONNECTION IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( previous = previous ).

    me->carrier_id    = carrier_id.
    me->connection_id = connection_id.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = /lrn/cx_s4d401_no_connection.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
