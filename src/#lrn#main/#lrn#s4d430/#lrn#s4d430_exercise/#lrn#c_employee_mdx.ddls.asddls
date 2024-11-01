@AbapCatalog: {
    dataMaintenance: #RESTRICTED,
    viewEnhancementCategory: [#PROJECTION_LIST],
    extensibility.dataSources: [ 'Employee' ],
    extensibility.elementSuffix: 'Zem'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee (Consumption)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory:   #M,
    dataClass:      #MASTER
}
@Metadata.allowExtensions: true
define view entity /LRN/C_Employee_Mdx
  with parameters
    p_target_curr : /dmo/currency_code,

    @Environment.systemField: #SYSTEM_DATE
    p_date        : abap.dats
  as select from /LRN/R_Employee_Ext as Employee
  {
    key EmployeeId,
        FirstName,
        LastName,

        DepartmentId,

        _Department.Description   as DepartmentDescription,
        //      _Department._Assistant.LastName             as AssistantName,

        concat_with_space( _Department._Assistant.FirstName,
                           _Department._Assistant.LastName,
                           1 )    as AssistantName,


        case EmployeeId
          when _Department.HeadId      then 'H'
          when _Department.AssistantId then 'A'
          else ' '
        end                       as EmployeeRole,


        @Semantics.amount.currencyCode: 'CurrencyCode'
        currency_conversion( amount             => AnnualSalary,
                             source_currency    => CurrencyCode,
                             target_currency    => $projection.CurrencyCode,
                             exchange_rate_date => $parameters.p_date
                           )      as AnnualSalaryConverted,


        @Semantics.amount.currencyCode: 'CurrencyCode'
        cast( $projection.AnnualSalaryConverted as abap.fltp )
        / 12.0                    as MonthlySalaryConverted,

        // CurrencyCode,
        // cast( 'USD' as /dmo/currency_code ) as CurrencyCodeUSD,
        $parameters.p_target_curr as CurrencyCode,

        division( dats_days_between( EntryDate,
                                     $parameters.p_date ),
                  365,
                  1 )             as CompanyAffiliation,

        /* Associations */
        _Department

  }
