@EndUserText.label: 'Products Projection View'
@AccessControl.authorizationCheck: #CHECK

@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZCDX_C_PRODUCTS_M_00 as projection on ZCDX_I_PRODUCTS_M_00 {
  
    key product_id,
    product_description,
    created_by,
    created_at,
    last_changed_by,
    last_changed_at
}
