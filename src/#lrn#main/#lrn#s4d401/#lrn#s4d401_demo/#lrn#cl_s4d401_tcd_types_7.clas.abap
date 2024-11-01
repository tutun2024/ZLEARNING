CLASS /lrn/cl_s4d401_tcd_types_7 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

     INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_TCD_TYPES_7 IMPLEMENTATION.


 METHOD if_oo_adt_classrun~main.

    DATA timestamp1 TYPE utclong.
    DATA timestamp2 TYPE utclong.
    DATA difference TYPE decfloat34.
    DATA date_user TYPE d.
    DATA time_user TYPE t.

    timestamp1 = utclong_current(  ).
    out->write(  |Current UTC time: {  timestamp1 }| ).

    out->write(  `------------------------------------` ).

    timestamp2 = utclong_add( val = timestamp1 days = 7 ).
    out->write( |Added 7 days to current UTC time: { timestamp2 }| ).

    out->write(  `------------------------------------` ).

    difference = utclong_diff( high = timestamp2 low = timestamp1  ).
    out->write( |Difference between timestamps in seconds: { difference }| ).
    out->write( |Difference between timestamps in days:    { difference / 3600 / 24 }| ).

    out->write(  `------------------------------------` ).

    CONVERT UTCLONG utclong_current(  )
    INTO DATE date_user
         TIME time_user
    TIME ZONE cl_abap_context_info=>get_user_time_zone(  ).

    out->write( |UTC timestamp split into date (type D) and time (type T )| ).
    out->write( |based on user's time zone .| ).
    out->write( |Date: { date_user date = user  }, Time: { time_user time = user }| ).


  ENDMETHOD.
ENDCLASS.
