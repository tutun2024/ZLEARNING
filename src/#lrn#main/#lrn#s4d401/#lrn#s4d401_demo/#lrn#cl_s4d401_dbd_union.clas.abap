CLASS /lrn/cl_s4d401_dbd_union DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /LRN/CL_S4D401_DBD_UNION IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT FROM /DMO/I_Carrier
         FIELDS 'Airline' AS type,
                AirlineID AS Id,
                Name
         WHERE CurrencyCode = 'GBP'

  UNION ALL

  SELECT FROM /DMO/I_Airport
         FIELDS 'Airport' AS type,
                AirportID AS Id,
                Name
         WHERE City = 'London'

   ORDER BY Name DESCENDING
    INTO TABLE @DATA(names).

    out->write(  data = names
                 name = `ID and Name of Airlines and Airports:` ).

  ENDMETHOD.
ENDCLASS.
