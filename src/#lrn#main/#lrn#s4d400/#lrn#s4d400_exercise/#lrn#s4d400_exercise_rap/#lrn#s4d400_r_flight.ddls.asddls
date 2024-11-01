@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED #'
define root view entity /LRN/S4D400_R_FLIGHT
  as select from /lrn/s4d400aflgt as Flight
{
  key carrier_id as CarrierID,
  key connection_id as ConnectionID,
  key flight_date as FlightDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  price as Price,
  currency_code as CurrencyCode,
  plane_type_id as PlaneTypeID,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
  
}
