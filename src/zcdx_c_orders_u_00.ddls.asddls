@EndUserText.label: 'Orders Projection View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZCDX_C_ORDERS_U_00 as projection on ZCDX_I_ORDERS_U_00 {
 
 @Search.defaultSearchElement: true
 key order_nr,
 
 @Search.defaultSearchElement: true
 order_date,
 
 @Search.defaultSearchElement: true
 customer,
      
 @Consumption.valueHelpDefinition: [ { entity: { name:    'I_Currency', 
                                                 element: 'Currency' } } ]
 currency_code,

 _Currency   

}
