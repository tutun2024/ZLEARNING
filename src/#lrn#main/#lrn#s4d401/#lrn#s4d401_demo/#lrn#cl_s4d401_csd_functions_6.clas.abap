CLASS /lrn/cl_s4d401_csd_functions_6 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_CSD_FUNCTIONS_6 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    DATA text TYPE string      VALUE `1989-11-09`.
    DATA text TYPE string      VALUE `For example, 1989-11-09 is a date in ISO-Format`.
*`   DATA text TYPE string      VALUE `For example, 09.11.21989 is not in ISO-Format`.

    DATA regex TYPE string VALUE '[0-9]{4}(-[0-9]{2}){2}'.

    out->write( |Text to be processed    = `{ text  }` | ).
    out->write( |Regular Expression      = `{ regex }` | ).
    out->write(  `--------------------------------------------------` ).

    IF NOT contains(   val = text pcre = regex   ).
      out->write( `Did not find any matching substring` ).
    ELSE.

      DATA(number) = count(  val = text pcre = regex ).

      out->write( |Number of findings      = { number } | ).

      DATA(offset) = find(  val = text pcre = regex occ = 1 ).

      out->write( |Offset of 1st finding   = { offset } | ).

      DATA(date_text) = match(  val = text pcre = regex occ = 1 ).

      out->write( |1st finding (extracted) = `{ date_text }` | ).

      IF matches(  val = text pcre = regex  ).
        out->write( `This is a complete match` ).
      ELSE.
        out->write( `Not a complete match` ).
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
