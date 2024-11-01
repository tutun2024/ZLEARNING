@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Carrier View'

define view entity /LRN/I_Carrier
  as select from /lrn/carrier as Airline


  {
    key Airline.carrier_id    as AirlineID,
        Airline.name          as Name,

        Airline.currency_code as CurrencyCode,

        last_changed_at       as LastChangedAt,
        local_created_at      as LocalCreatedAt,
        local_created_by      as LocalCreatedBy,
        local_last_changed_at as LocalLastChangedAt,
        local_last_changed_by as LocalLastChangedBy

  }
