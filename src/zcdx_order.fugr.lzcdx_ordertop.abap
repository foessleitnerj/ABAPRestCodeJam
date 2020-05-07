FUNCTION-POOL ZCDX_ORDER.                   "MESSAGE-ID ..

* INCLUDE LZCDX_ORDERD...                    " Local class definition

    DATA: mt_create_buffer TYPE zcdx_if_t_order_00,
          mt_update_buffer TYPE zcdx_if_t_order_00,
          mt_update_buffer_x type zcdx_if_t_order_x_00,
          mt_delete_buffer TYPE zcdx_if_t_order_00.
