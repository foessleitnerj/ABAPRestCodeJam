function zcdx_partner_delete.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_PARTNER_ID) TYPE  ZCDX_PARTNER_ID
*"----------------------------------------------------------------------
  delete from zcdx_partner_00 where partner = @i_partner_id.

ENDFUNCTION.
