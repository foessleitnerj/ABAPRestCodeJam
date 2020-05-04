@AbapCatalog.sqlViewName: 'ZCDXIPRODUCTSM00'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Products View'
define root view ZCDX_I_PRODUCTS_M_00 as select from zcdx_products_00 {

    key product_id,
    product_description,
    created_by,
    created_at,
    last_changed_by,
    last_changed_at
}
