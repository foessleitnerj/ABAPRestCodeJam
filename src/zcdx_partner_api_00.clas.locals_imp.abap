CLASS lhc_partner DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE partner.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE partner.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE partner.

    METHODS read FOR READ
      IMPORTING keys FOR READ partner RESULT result.

ENDCLASS.

CLASS lhc_partner IMPLEMENTATION.

  METHOD create.
      data ls_partner type zcdx_partner_00.
      DATA lt_messages type /DMO/T_MESSAGE.
      data message type ref to CL_ABAP_BEHV.

      loop at entities ASSIGNING field-symbol(<entity>).

         ls_partner = corresponding #( <entity> ).

         call function 'ZCDX_PARTNER_CREATE'
            exporting i_partner_data = ls_partner
            IMPORTING et_messages = lt_messages.

         IF lt_messages IS not INITIAL.
           loop at lt_messages ASSIGNING field-symbol(<message>).
              append value #( %cid = <entity>-%cid
                              partner = <entity>-partner ) to failed-partner.


              create object message.

              data(message_obj) = message->new_message(
                EXPORTING
                  id       = <message>-msgid
                  number   = <message>-msgno
                  severity = conv #( <message>-msgty ) ).

              append value #( %cid = <entity>-%cid
                              %msg      = message_obj
                              %key-partner = <entity>-partner
                              partner = <entity>-partner
                            ) to reported-partner.
           endloop.

         endif.

      endloop.

  ENDMETHOD.

  METHOD delete.
     data ls_partner type zdbpartner.

     loop at keys ASSIGNING field-symbol(<key>).
       call function 'ZCDX_PARTNER_DELETE'
          exporting i_partner_ID = <key>-Partner.
     endloop.

  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCDX_I_PARTNER_U_00 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lsc_ZCDX_I_PARTNER_U_00 IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

ENDCLASS.
