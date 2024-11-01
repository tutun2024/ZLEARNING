@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for /LRN/S4D400_R_CONNECTION'
define root view entity /LRN/S4D400_C_CONNECTION
  provider contract transactional_query
  as projection on /LRN/S4D400_R_CONNECTION
  {
    key UUID,
        @Consumption.valueHelpDefinition:
            [{ entity: { name:    '/LRN/S4D400_I_CarrierVH',
                         element: 'CarrierID'
                       }
            }]
        CarrierID,
        ConnectionID,
        AirportFromID,
        CityFrom,
        CountryFrom,
        AirportToID,
        CityTo,
        CountryTo,
        LocalLastChangedAt

  }
