function zcdx_partner_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_PARTNER_DATA) TYPE  ZCDX_PARTNER_00
*"  EXPORTING
*"     REFERENCE(ET_MESSAGES) TYPE  /DMO/T_MESSAGE
*"----------------------------------------------------------------------
    if i_partner_data-country is initial.
      INSERT
            VALUE #( msgty = 'E'
                     msgid = '00'
                     msgno = '000'   )
            into table et_messages.
      return.
    endif.

    data l_partner type zcdx_partner_00.

    l_partner = CORRESPONDING #( i_partner_data ).

    select max( partner ) from ZCDX_PARTNER_00 into @data(max_partner).
    l_partner-partner = max_partner + 1.

    insert ZCDX_PARTNER_00 from @l_partner.

ENDFUNCTION.
