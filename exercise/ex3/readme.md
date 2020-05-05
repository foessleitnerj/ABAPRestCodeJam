# Übung 3 - ABAP RESTful Programming Model - Unmanaged
So, jetzt geht es aber wirklich los. Wir werden ein kleines unmanaged Szenrio umsetzen. Bei den unmanaged Szenarien haben wir die Kontrolle über die CRUD Operationen und können z.B. BAPIs oder Fubas von früher wiederverwenden. Wie cool ist das denn?
Damit es nicht ganz so aufwendig wird, sind für die nachfolgende Übung bereits folgende Objekte vorhanden:
- Datenbanken: xyz

## Übung 3.1 - Business Object View für Order anlegen
Was wir seit langem sagen tritt nun ein. Wir fangen mit der Modellierung ganz unten bei den CDS Views an.
1. Lege eine ganz gewöhnliche Data Definition (CDS) Z_I_ORDERS_U_XX (Orders View) für die Datenbanktabelle ZCDX_ORDER_00 an. Als Datenbankview sollte der Name ZIORDERSUXX verwendet werden.
  - .I. steht für ... 
  - .U. steht für unmanaged
2. Bei der Order handelt es sich um die ROOT Entität. Daher müssen wir das Keyword **ROOT** nach dem DEFINE einfügen
3. Bitte den Alias **Order** angeben
4. Bei der Order gibt es auch ein Währungsfeld. Wir wollen hier später eine F4 Hilfe einbinden, daher müssen wir hier im CDS View eine Association zu dem vorhandenen CDS View I_CURRENCY anlegen. Zur Erinnerung, Associations werden vor den geschwungenen Klammern ergänzt
```
  association [0..1] to I_Currency       as _Currency  
                     on $projection.CurrencyCode    = _Currency.Currency
```
5. Bitte alle Felder der Datenbank einfügen. Bitte "Alias" für jedes Feld verwenden. Immer großer Anfangsbuchstabe und keine Unterstriche. Schlußendlich sollten die Felder in etwa so aussehen:
```
x
```
