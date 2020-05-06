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
9. Die Klasse wird angelegt und der Reiter "Locale Types" wird eingeblendet und sollte wie nachfolgend aussehen.
![BehaviorImplementation](images/exc_3_2.png?raw=true "Behavior Implementation")
10. BITTE NICHT FRAGEN WIESO die Methoden als locale Klasse/Methoden abgebildet wurden. Auch Thomas Jung und Rich Heilman fanden keine Erklärung. Außer, dass es technische Notwendigkeiten gibt.
11. Nachfolgenden Code in die Implementierung von CREATE einfügen. Die anzulegenden Orders sind im Methodenparameter ENTITIES enthalten.
    - Es können natürlich auch Messages aus dem FUBA Call zurückgeliefert und dem Framework übergeben werden. Falls dies jemanden interessiert, einfach die Implementierung in der Klasse ZCDX_PARTNER_API_00 ansehen.
``` 
     data ls_order type zcdx_order_XX.

     loop at entities ASSIGNING field-symbol(<entity>).

        ls_order = CORRESPONDING #( <entity>  ).
        call function 'ZCDX_ORDER_CREATE'
             exporting i_order_data = ls_order.

     endloop.
 ```     
12. Die DELETE Implementierung bitte wie folgt einfügen. In dem Fall werden nur die KEYs der zu löschenden Orders in die DELETE Methode geliefert. 
``` 
     data ls_order type zcdx_order_XX.

     loop at keys ASSIGNING field-symbol(<key>).
       call function 'ZCDX_ORDER_DELETE'
          exporting i_order_nr = <key>-order_nr.
     endloop.
```      
13. Und nun noch die UPDATE Implementierung. Wie man sofort erkennt, übergibt uns das Framework auch die geänderten Felder. Ähnlich wie DATAX. Sehr nett, danke SAP.
``` 
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

      call function 'ZCDX_ORDER_UPDATE'
        EXPORTING
          i_order_data   = l_order
          i_order_data_x = l_order_x.

    ENDLOOP.
``` 
14. Wie man sieht, gibt es auch die leeren Methoden SAVE und CLEANUP. Wenn man es ganz sauber implementiert, würde das CREATE, UPDATE oder DELETE die Änderungen in einen Memory schreiben und erst in der SAVE Methode würden die Änderungen auf die Datenbank geschrieben. CLEANUP ist dann zum initialisieren des Buffers gedacht.
15. Nicht vergessen die Klasse zu aktivieren!
## Übung 3.3. Anlegen des Projection Views 
Nun müssen wir noch einen Projection View anlegen. Der liegt "über" dem angelegten CDS View und dient dazu, die Daten nochmals zu filtern. Es könnten mehrere Projection Views zu einem CDS View existieren.
1. Anlegen des CDS View ZCDX_C_ORDERS_U_XX Orders Projection View.
   - Als Template "Define Projection View" verwenden
   - data_source_name durch ZCDX_I_ORDERS_U_XX ersetzten
2. Bitte wieder ROOT nach DEFINE ergänzen
3. Nachfolgende Annotations vor DEFINE ergänzen. Wir wollen METADATA Extension erlauben und das Objekt suchbar machen
``` 
@Metadata.allowExtensions: true
@Search.searchable: true
``` 
4. Bitte alle Felder ergänzen. Sollte dann wie folgt aussehen.
 ``` 
 key order_nr,
 order_date,
 customer,
 currency_code,

 _Currency  
 ``` 
 5. Nun ergänzen wir ein paar Annotations. Coding wie nachfolgend anpassen.
    - Infos für die Valuehilfe der Währung
    - Suchbare Felder
    - MTE erlauben
 ``` 
@EndUserText.label: 'Orders Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZCDX_C_ORDERS_U_00 as projection on ZCDX_I_ORDERS_U_00 {
 
 @Search.defaultSearchElement: true
 key order_nr,
 
 @Search.defaultSearchElement: true
 order_date,
 
 @Search.defaultSearchElement: true
 customer,
      
 @Consumption.valueHelpDefinition: [ { entity: { name:    'I_Currency', 
                                                 element: 'Currency' } } ]
 currency_code,

 _Currency   

}
 ``` 
6. Aktivieren nicht vergessen!
## Übung 3.4. Metadata Extensions anlegen
Wir verwenden die Metadaten Extensions um die UI spezifischen Annotations vom Rest des Datenmodells zu separieren. Damit erreichen wir kleinere Einheiten. -> Clean Code
1. Beim Kontext Menü des Projection Views ZCDX_C_ORDERS_U_XX die neue Metadata Extension ZCDX_E_ORDERS_U_XX anlegen.
2. Hier definieren wir jetzt genauer, wie das Userinterface aussehen soll. Bitte einfach das nachfolgende Coding kopieren.
   - Zu Beginn wird mit headerInfo der Kopfbereich definiert
   - Bei den Feldern wird jeweils festgelegt, wo und wie die Felder angezeigt werden sollen
 ``` 
@Metadata.layer: #CORE

@UI: { headerInfo: { typeName: 'Order', 
                     typeNamePlural: 'Orders', 
                     title: { type: #STANDARD, 
                              value: 'order_nr' } } }

annotate view ZCDX_C_ORDERS_U_00
    with                              
{

  @UI: { lineItem:       [ { position: 10, 
                             importance: #HIGH } ], 
         identification: [ { position: 10 } ], 
         selectionField: [ { position: 10 } ] }
order_nr;

  @UI: { lineItem:       [ { position: 20, 
                             importance: #MEDIUM } ], 
         identification: [ { position: 20 } ], 
         selectionField: [ { position: 20 } ] }
order_date;

  @UI: { lineItem:       [ { position: 30, 
                             importance: #HIGH } ], 
         identification: [ { position: 30 } ] }
customer;

  @UI: { identification: [ { position: 40 } ]}
currency_code;
    
}
``` 
3. Aktivieren nicht vergessen!
## Übung 3.5. Behavior Definition Projection anlegen
Die Idee ist ja, dass mein ein großes Business Objekt hat und mehrere Behavior Definitionen hat. Hier könnte z.B. festgelegt werden, dass für eine Projection das DELETE erlaubt ist, für eine andere aber nicht. Etc.
1. Im Kontextmenü von ZCDX_C_ORDERS_XX eine neue Behavior Definition anlegen. Beim Implementierungstyp müsste eigentlich "Projection" stehen. Wenn nicht passt was nicht.
2. Im generierten Coden ändern machen wir zwei kleine Änderungen:
   - orders als alias angeben
   - delete mit // auskommentieren
```    
    projection;
    
    define behavior for ZCDX_C_ORDERS_U_00 alias order
    {
      use create;
      use update;
      // use delete;
    }
``` 
### Übung 3.6. Anlegen der Service Definition und Service Binding
Jetzt haben wir es fast geschafft. Wir brauchen nur noch die Service Definition
1. Im Kontextmenü von ZCDX_C_ORDERS_XX eine neue Service Definition ZCDX_SD_ORDERS_XX anlegen. Wir machen nur eine kleine Ergänzung beim Alias, sonsten passt der generierte Code. Bitte beachtet, dass der Alias hier Orders (mit s) ist, da Order ein reservierter Name ist?!
``` 
@EndUserText.label: 'Service Definition for Orders'
define service ZCDX_SD_ORDERS_00 {
  expose ZCDX_C_ORDERS_U_00 as Orders;
}
``` 
