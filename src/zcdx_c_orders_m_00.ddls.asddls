@EndUserText.label: 'Order Projection View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZCDX_C_ORDERS_M_00 as projection on ZCDX_I_ORDERS_M_00 {

   key order_nr      as OrderNumber,
       order_date    as OrderDate,
       
       @Search.defaultSearchElement: true
       customer      as Customer,
       currency_code as CurrencyCode,

       _Currency 
}
