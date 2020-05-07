FUNCTION zcdx_order_save.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
  LOOP AT mt_update_buffer ASSIGNING FIELD-SYMBOL(<update_buffer>).

    DATA field TYPE i.
    DATA sql_set TYPE string.
    DATA r_buffer_x TYPE REF TO cl_abap_structdescr.

    READ TABLE mt_update_buffer_x ASSIGNING FIELD-SYMBOL(<update_buffer_x>) WITH KEY order_nr = <update_buffer>-order_nr.
    IF sy-subrc <> 0.
      continue. "TODO - Errorhandling
    ENDIF.

    r_buffer_x ?= cl_abap_structdescr=>describe_by_data( <update_buffer_x> ).

    DATA(components) = r_buffer_x->get_included_view( ).

    LOOP AT components ASSIGNING FIELD-SYMBOL(<component>)
       WHERE name <> 'ORDER_NR'.
      ASSIGN COMPONENT <component>-name OF STRUCTURE <update_buffer_x> TO FIELD-SYMBOL(<datax>).

      IF <datax> = abap_true.
        IF sql_Set IS NOT INITIAL.
          sql_set = sql_set && `, `.
        ENDIF.
        sql_set = sql_set && |{ <component>-name } = @<update_buffer>-{ <component>-name }|.
      ENDIF.

    ENDLOOP.

    IF sql_set IS NOT INITIAL.

      UPDATE zcdx_order_00 SET (sql_set) WHERE order_nr = @<update_buffer>-order_nr.
      IF sy-subrc <> 0.
        "TODO - Errorhandling
      ENDIF.

    ENDIF.

  ENDLOOP.

    DELETE zcdx_order_00 FROM TABLE @( CORRESPONDING #( mt_delete_buffer ) ).
    IF sy-subrc <> 0.
      "TODO - Errorhandling
    ENDIF.

  clear: mt_update_buffer,
         mt_update_buffer_X,
         mt_delete_buffer,
         mt_create_buffer.

ENDFUNCTION.
