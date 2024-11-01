*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


**********************************************************************
*dummy class implementing if_oo_adt_classrun_out
*  Use to call if_oo_adt_classrun~main interactively
*
* Stores output in attribute protocol
**********************************************************************

CLASS lcl_out DEFINITION.

  PUBLIC SECTION.
    INTERFACES  if_oo_adt_classrun_out .

    DATA log TYPE TABLE OF string.

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS handle_elem
      IMPORTING
        data TYPE simple.

    METHODS handle_structure
      IMPORTING
        data TYPE any.

    METHODS handle_table
      IMPORTING
        data TYPE ANY TABLE.

ENDCLASS.

CLASS lcl_out IMPLEMENTATION.

  METHOD if_oo_adt_classrun_out~get.
*  Delegate to method WRITE( )
    me->if_oo_adt_classrun_out~write(
        EXPORTING
          data   = data
          name   = name
      ).
  ENDMETHOD.

  METHOD if_oo_adt_classrun_out~write.

* Store Name
    IF name IS SUPPLIED.
      handle_elem( name ).
    ENDIF.
* Store Data
    CASE cl_abap_typedescr=>describe_by_data( data )->kind.
      WHEN cl_abap_typedescr=>kind_elem.
        handle_elem( data ).
      WHEN cl_abap_typedescr=>kind_struct.
        handle_structure( data ).
      WHEN cl_abap_typedescr=>kind_table.
        handle_table( data ).
    ENDCASE.

    output = me.

  ENDMETHOD.

  METHOD handle_elem.
    APPEND |{ data }| TO me->log.
  ENDMETHOD.

  METHOD handle_structure.
    DATA row TYPE string.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE data TO FIELD-SYMBOL(<comp>).
      IF sy-subrc = 0.
        row = row && ` ` && |{ <comp> }|.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

    APPEND row TO me->log.

  ENDMETHOD.

  METHOD handle_table.

    LOOP AT data ASSIGNING FIELD-SYMBOL(<row>).

      CASE cl_abap_typedescr=>describe_by_data( <row> )->kind.
        WHEN cl_abap_typedescr=>kind_elem.
          handle_elem( data = <row> ).
        WHEN cl_abap_typedescr=>kind_struct.
          handle_structure(  <row> ).
      ENDCASE.

    ENDLOOP.
  ENDMETHOD.


ENDCLASS.
