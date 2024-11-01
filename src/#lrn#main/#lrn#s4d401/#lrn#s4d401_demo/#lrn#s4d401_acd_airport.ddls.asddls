@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Demo: CDS view with access control'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /LRN/S4D401_ACD_Airport
  as select from /lrn/airport
  {
    key airport_id as AirportId,
        name       as Name,
        city       as City,
        country    as Country,
        timzone    as Timzone
  }
