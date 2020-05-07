FUNCTION zcdx_order_read.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_ORDER_NR) TYPE  ZCDX_ORDER_NR_00
*"  EXPORTING
*"     REFERENCE(E_ORDER) TYPE  ZCDX_IF_ORDER_00
*"----------------------------------------------------------------------
  SELECT SINGLE *
     FROM zcdx_order_00
     WHERE order_nr = @i_order_nr
     INTO CORRESPONDING FIELDS OF @e_order.

ENDFUNCTION.
