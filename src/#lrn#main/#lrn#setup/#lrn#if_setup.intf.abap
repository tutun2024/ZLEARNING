INTERFACE /lrn/if_setup
  PUBLIC .

  TYPES
     tt_protocol TYPE TABLE OF string.

  DATA courseid TYPE /lrn/courseid.

  DATA protocol TYPE tt_protocol.

  METHODS run
    RAISING /lrn/cx_no_authorization.
  .

ENDINTERFACE.
