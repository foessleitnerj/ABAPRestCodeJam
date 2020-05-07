FUNCTION zcdx_order_update.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_ORDER_DATA) TYPE  ZCDX_IF_ORDER_00
*"     VALUE(I_ORDER_DATA_X) TYPE  ZCDX_IF_ORDER_X_00
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  /DMO/T_MESSAGE
*"----------------------------------------------------------------------
  IF i_order_data-order_nr IS INITIAL.
    RETURN. "add message
  ENDIF.

  "some other checks
  READ TABLE mt_update_buffer
     WITH KEY order_nr = i_order_data-order_nr
     ASSIGNING FIELD-SYMBOL(<order_buffer>).
  IF sy-subrc <> 0.
    INSERT i_order_data INTO TABLE mt_update_buffer.
    INSERT i_order_data_x INTO TABLE mt_update_buffer_x.
  ELSE.
    <order_buffer> = i_order_data.
    READ TABLE mt_update_buffer_x
       WITH KEY order_nr = i_order_data-order_nr
       ASSIGNING FIELD-SYMBOL(<order_buffer_x>).
    IF sy-subrc = 0.
      <order_buffer_x> = i_order_data_x.
    ENDIF.
  ENDIF.

ENDFUNCTION.
