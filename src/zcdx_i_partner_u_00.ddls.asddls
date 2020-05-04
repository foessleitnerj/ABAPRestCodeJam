@AbapCatalog.sqlViewName: 'ZCDXIPARTNERU00'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Partner View'
define root view ZCDX_I_PARTNER_U_00 as select from zcdx_partner_00 
{
   key partner,
   name,
   country                   
}
