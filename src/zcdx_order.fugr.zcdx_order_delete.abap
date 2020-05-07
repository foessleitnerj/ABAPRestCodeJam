function zcdx_order_delete.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_ORDER_NR) TYPE  ZCDX_ORDER_NR_00
*"----------------------------------------------------------------------
  data order_buffer type zcdx_if_order_00.

  order_buffer-order_nr = i_order_nr.

  if not line_exists( mt_delete_buffer[ order_nr = i_order_nr ] ).
     insert order_buffer into table mt_delete_buffer.
  endif.

  if line_exists( mt_update_buffer[ order_nr = i_order_nr ] ).
     delete mt_update_buffer where order_nr = i_order_nr.
  endif.

ENDFUNCTION.
