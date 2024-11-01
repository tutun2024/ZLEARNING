CLASS /lrn/cl_s4d401_csd_formatting DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_CSD_FORMATTING IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA(name) = `John Dow`.
    DATA(time) = cl_abap_context_info=>get_system_time(  ).

    out->write( |Raw:            `{ name }`| ).

    out->write( |CASE = UPPER:   `{ name CASE = UPPER }`| ).

    out->write( |WIDTH = 40:     `{ name  WIDTH = 40  }`| ).

    out->write( |ALIGN = RIGHT:  `{ name  WIDTH = 40 ALIGN = RIGHT   }` | ).

    out->write( |ALIGN = CENTER: `{ name  WIDTH = 40 ALIGN = CENTER }` | ).

    out->write( |PAD = '-':      `{ name  WIDTH = 40 ALIGN = CENTER PAD = '-' }` | ).

    out->write( |Time, raw:      `{ time }`| ).

    out->write( |TIME = USER:    `{ time TIME = USER }`| ).

  ENDMETHOD.
ENDCLASS.
