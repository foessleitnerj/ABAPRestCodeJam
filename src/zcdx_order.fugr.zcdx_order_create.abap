function zcdx_order_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_ORDER_DATA) TYPE  ZCDX_ORDER_00
*"  EXPORTING
*"     REFERENCE(E_ORDER_OUT) TYPE  ZCDX_ORDER_00
*"     REFERENCE(ET_MESSAGES) TYPE  /DMO/T_MESSAGE
*"----------------------------------------------------------------------
    data l_order type zcdx_order_00.

    l_order = CORRESPONDING #( i_order_data ).

    select max( order_nr ) from ZCDX_order_00 into @data(max_order_nr).
    l_order-order_nr = max_order_nr + 1.

    insert ZCDX_order_00 from @l_order.

    e_order_out = l_order.

ENDFUNCTION.
