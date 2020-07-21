CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validateCustomer FOR VALIDATION Order~validateCustomer
      IMPORTING keys FOR Order.

    METHODS validateDates FOR VALIDATION Order~validateDates
      IMPORTING keys FOR Order.

    methods get_features for features
       importing keys request requested_features for Order result result.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD validateCustomer.

* read entities
     read entity zcdx_i_orders_m_00\\Order fields ( Customer ) with
        value #( for <root_key> in keys (  %key = <root_key> ) )
        result data(lt_orders).

     loop at lt_orders ASSIGNING field-symbol(<order>).
        if <order>-customer > 100.
           append value #( order_nr = <order>-order_nr ) to failed.
           append value #( order_nr = <order>-order_nr
                           %msg = new_message(  id = 'ZCDX_MESSAGES'
                                                number = '001'
                                                severity = if_abap_behv_message=>severity-error )
                           %element-order_nr = if_abap_behv=>mk-on ) to reported.
        endif.
     endloop.

  ENDMETHOD.

  METHOD validateDates.
       read entity zcdx_i_orders_m_00\\Order fields ( order_date ) with
        value #( for <root_key> in keys (  %key = <root_key> ) )
        result data(lt_orders).

     loop at lt_orders ASSIGNING field-symbol(<order>).
        if <order>-order_date > cl_abap_context_info=>get_system_date( ).
           append value #( %key = <order>-%key
                           order_nr = <order>-order_nr ) to failed.
           append value #( %key = <order>-%key
                           %msg = new_message(  id = 'ZCDX_MESSAGES'
                                                number = '002'
                                                severity = if_abap_behv_message=>severity-error )
                           %element-order_date = if_abap_behv=>mk-on ) to reported.
        endif.
     endloop.

  ENDMETHOD.

  METHOD get_features.

     data l_result like line of result.

     read entity zcdx_i_orders_m_00 fields ( customer currency_code )
        with value #( for keyval in keys ( %key = keyval-%key ) )
        result data(lt_orders).

     loop at lt_orders ASSIGNING field-symbol(<order>).
        if <order>-customer is not initial.
           l_result-order_nr = <order>-order_nr.
           l_result-%key = <order>-%key.
           l_result-%field-currency_code = if_abap_behv=>fc-f-mandatory.
           append l_result to result.
        else.
           l_result-order_nr = <order>-order_nr.
           l_result-%key = <order>-%key.
           l_result-%field-currency_code = if_abap_behv=>fc-f-read_only.
           append l_result to result.
        endif.
     endloop.

  ENDMETHOD.

ENDCLASS.
