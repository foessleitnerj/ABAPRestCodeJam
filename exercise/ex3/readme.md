# Übung 3 - ABAP RESTful Programming Model - Unmanaged
So, jetzt geht es aber wirklich los. Wir werden ein kleines unmanaged Szenrio umsetzen. Bei den unmanaged Szenarien haben wir die Kontrolle über die CRUD Operationen und können z.B. BAPIs oder Fubas von früher wiederverwenden. Wie cool ist das denn?
Damit es nicht ganz so aufwendig wird, sind für die nachfolgende Übung bereits folgende Objekte vorhanden:
- Datenbanken: xyz

## Übung 3.1 - Business Object View für Order anlegen
Was wir seit langem sagen tritt nun ein. Wir fangen mit der Modellierung ganz unten bei den CDS Views an.
1. Lege eine ganz gewöhnliche Data Definition (CDS) ZCDX_I_ORDERS_U_XX (Orders View) für die Datenbanktabelle ZCDX_ORDER_00 an. Als Datenbankview sollte der Name ZCDXIORDERSUXX verwendet werden.
  - .I. steht für ... 
  - .U. steht für unmanaged
2. Bei der Order handelt es sich um die ROOT Entität. Daher müssen wir das Keyword **ROOT** nach dem DEFINE einfügen
3. Bitte den Alias **Order** angeben
4. Bei der Order gibt es auch ein Währungsfeld. Wir wollen hier später eine F4 Hilfe einbinden, daher müssen wir hier im CDS View eine Association zu dem vorhandenen CDS View I_CURRENCY anlegen. Zur Erinnerung, Associations werden vor den geschwungenen Klammern ergänzt
```
  association [0..1] to I_Currency       as _Currency  
                     on $projection.CurrencyCode    = _Currency.Currency
```
5. Bitte alle Felder der Datenbank ud die Association auf die Währung einfügen. Einfach die CodeCompletion nach der geschwungenen Klammer starten.
```
    key order_nr, 
    order_date,
    customer,
    currency_code,
    
    _Currency
```
6. Da wir hier eine Währung verwenden, kommt nun eine erste Annotation ins Spiel. Bitte folgende Annotation genau vor der Währung ergänzen. Aktivieren nicht vergessen.
```
@Semantics.currencyCode: true
```
7. Wenn ihr alles richtig gemacht habt, sollte der CDS View wie folgt aussehen.
```
@AbapCatalog.sqlViewName: 'ZCDXIORDERSU00'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Orders View'
define root view ZCDX_I_ORDERS_U_00 as select from zcdx_order_00 
  association [0..1] to I_Currency       as _Currency  
                     on $projection.currency_code    = _Currency.Currency
{
     
    key order_nr, 
    order_date,
    customer,
    @Semantics.currencyCode: true
    currency_code,
    
    _Currency

}
```
## Übung 3.2 Business Object Behavior Definition und Implementierung anlegen
1. Im Kontextmenü des erstellten CDS Views eine neue **Behavior Definition** anlegen
2. Im Wizard den Implementation Typ auf **unmanaged** ändern
3. Nun solltet ihr folgenden Editor sehen
![BehaviorDefinition](images/exc_3_1.png?raw=true "Behavior Definition")
4. Wie ihr seht wurde bereits ein Klassenname vorgeschlagen. Das lassen wir auch mal so.
5. An dieser Stelle wollen wir erstmals das Verhalten von Feldern anpassen. 
   - order_nr soll read-only werden. Die API vergibt später die Nummer
   - customer und currency sollen Mussfelder werden.
6. Die Angaben sind nach der geschwungenen Klammer und vor dem CREATE zu machen
```   
  field ( read only ) order_nr;
  field ( mandatory ) customer, currency_code;
```
7. Die komplette Behavior Definition sollte nun wie folgt aussehen
``` 
unmanaged implementation in class zbp_cdx_i_orders_u_00 unique;

define behavior for ZCDX_I_ORDERS_U_00 //alias <alias_name>
//late numbering
//lock master
//etag master <field_name>
{

  field ( read only ) order_nr;
  field ( mandatory ) customer, currency_code;

  create;
  update;
  delete;
}
``` 
8. Jetzt brauchen wir noch die Behavior Implementation. Im Kontextmenü der Behavior Definition eine **Behavior Implementation** anlegen. Als Klassennamen ZBP_CDX_I_ORDERS_U_XX verwenden. Das ist der gleiche wie er vorher in der Behavior Definition vorgeschlagen wurde.
