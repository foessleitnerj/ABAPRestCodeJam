CLASS lhc_ZCDX_I_ORDERS_U_00 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zcdx_i_orders_u_00.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zcdx_i_orders_u_00.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zcdx_i_orders_u_00.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcdx_i_orders_u_00 RESULT result.

ENDCLASS.

CLASS lhc_ZCDX_I_ORDERS_U_00 IMPLEMENTATION.

  METHOD create.
     data ls_order type zcdx_order_00.

     loop at entities ASSIGNING field-symbol(<entity>).

        ls_order = CORRESPONDING #( <entity>  ).

        call function 'ZCDX_ORDER_CREATE'
             exporting i_order_data = ls_order
             importing e_order_out = ls_order.

        INSERT VALUE #( %cid = <entity>-%cid
                        order_nr = ls_order-order_nr )
                       INTO TABLE mapped-zcdx_i_orders_u_00.

     endloop.

  ENDMETHOD.

  METHOD delete.

     loop at keys ASSIGNING field-symbol(<key>).
       call function 'ZCDX_ORDER_DELETE'
          exporting i_order_nr = <key>-order_nr.
     endloop.

  ENDMETHOD.

  METHOD update.
    DATA l_order TYPE zcdx_if_order_00.
    DATA l_order_x TYPE zcdx_if_order_x_00.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<order_update>).
      CLEAR: l_order,
             l_order_x.

      l_order = CORRESPONDING #( <order_update> ). "mapping from entity

      l_order_x-order_nr = <order_update>-order_nr.
      l_order_x-currency_code = xsdbool( <order_update>-%control-currency_code = if_abap_behv=>mk-on ).
      l_order_x-order_date = xsdbool( <order_update>-%control-order_Date = if_abap_behv=>mk-on ).
      l_order_x-customer = xsdbool( <order_update>-%control-customer = if_abap_behv=>mk-on ).

      CALL FUNCTION 'ZCDX_ORDER_UPDATE'
        EXPORTING
          i_order_data   = l_order
          i_order_data_x = l_order_x.

      INSERT VALUE #( %cid = <order_update>-%cid_ref
                      order_nr = <order_update>-order_nr )
                     INTO TABLE mapped-zcdx_i_orders_u_00.

    ENDLOOP.

  ENDMETHOD.

  METHOD read.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT *
      FROM zcdx_order_00
      FOR ALL ENTRIES IN @keys
      WHERE order_nr = @keys-order_nr
      INTO CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCDX_I_ORDERS_U_00 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lsc_ZCDX_I_ORDERS_U_00 IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.
    CALL FUNCTION 'ZCDX_ORDER_SAVE'.
  ENDMETHOD.

ENDCLASS.
