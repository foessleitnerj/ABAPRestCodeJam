@EndUserText.label: 'Partner Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZCDX_C_PARTNER_U_00 as projection on ZCDX_I_PARTNER_U_00 
{
    key partner,
    
    @Search.defaultSearchElement: true
    name,
    
    @Consumption.valueHelpDefinition: [{entity: { name:    'I_Country',
                                                  element: 'Country' } }]    
    country    
}
