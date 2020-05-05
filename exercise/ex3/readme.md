# Übung 3 - ABAP RESTful Programming Model - Unmanaged
So, jetzt geht es aber wirklich los. Wir werden ein kleines unmanaged Szenrio umsetzen. Bei den unmanaged Szenarien haben wir die Kontrolle über die CRUD Operationen und können z.B. BAPIs oder Fubas von früher wiederverwenden. Wie cool ist das denn?
Damit es nicht ganz so aufwendig wird, sind für die nachfolgende Übung bereits folgende Objekte vorhanden:
- Datenbanken: xyz

## Übung 3.1 - Business Object Views anlegen
Was wir seit langem sagen tritt nun ein. Wir fangen mit der Modellierung ganz unten bei den CDS Views an.
1. Lege eine ganz gewöhnliche Data Definition (CDS) Z_I_ORDERS_U_XX (Orders View) für die Datenbanktabelle ZCDX_ORDER_00 an. Als Datenbankview sollte der Name ZIORDERSUXX verwendet werden.
   - ._I_. steht für ... 
   - ._U_. steht für unmanaged

