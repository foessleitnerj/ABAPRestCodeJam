# Übung 5 - ABAP RESTful Programming Model - Managed
Beim unmanaged Scenario haben wir noch relativ viel selber implementieren müssen. Nun schauen wir uns eine managed Implemetierung an, bei der wir deutlich weniger selber implementieren müssen. Dieses Scenario eignet sich primär für neu zu erstellende RAP Objekte.
Am Ende des Beipsiels wollenw wir ähnlich der Übung 3 eine kleine Anwendung haben mit der wir Aufträge erfassen und ändern können. Auch in diesem Beipsiel verwenden wir die Fiori Elements um ein schnelles Userinterface zu haben.
## Übung 5.1 - Business Object View für Order anlegen
1. Lege eine ganz gewöhnliche Data Definition (CDS) **ZCDX_I_ORDERS_M_XX** (Orders View) für die Datenbanktabelle **ZCDX_ORDER_00** an. Als Datenbankview sollte der Name **ZCDXIORDERSMXX** verwendet werden.
  - .I. steht für Interface View
  - .M. steht für Managed
  - Naming Conventions: https://help.sap.com/viewer/923180ddb98240829d935862025004d6/Cloud/en-US/8b8f9d8f3cb948b2841d6045a255e503.html 
2. Bei der Order handelt es sich um die ROOT Entität. Daher müssen wir das Keyword **ROOT** nach dem DEFINE einfügen
3. Bitte den Alias **Order** angeben
4. Bei der Order gibt es auch ein Währungsfeld. Wir wollen hier später eine F4 Hilfe einbinden, daher müssen wir hier im CDS View eine Association zu dem vorhandenen CDS View I_CURRENCY anlegen. Zur Erinnerung, Associations werden **vor** den geschwungenen Klammern ergänzt
```
  association [0..1] to I_Currency       as _Currency  
                     on $projection.Currency_Code    = _Currency.Currency
```
5. Bitte alle Felder der Datenbank und die Association auf die Währung einfügen. Einfach die CodeCompletion nach der geschwungenen Klammer starten.
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
@AbapCatalog.sqlViewName: 'ZCDXIORDERSM00'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Orders View'
define root view ZCDX_I_ORDERS_M_00 as select from zcdx_order_00 
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
Wie ihr sicher bemerkt habt, unterscheidet sich dieser Teil nicht vom unmanaged Scenario. Wir haben lediglich im Namen das Suffix "M" eingefügt, der Rest ist 1:1 gleich.
## Übung 5.2 Business Object Behavior Definition und Implementierung anlegen
1. Im Kontextmenü des erstellten CDS Views eine neue **Behavior Definition** anlegen
2. Im Wizard den Implementation Typ auf **managed** belassen bzw. ggf. ändern
3. Wie ihr seht wurde die pseristent table bereits aus der CDS View Definition übernommen
4. Außerhalb von SAP wollen wir aber "schnöne" Namen verwenden, daher bitte einen alias **Order** angeben.
5. **lock master** bitte aktivieren. Damit übernimmt das Framework die notwendigen Sperren. 
6. etag master verwenden wir hier in dem Demo nicht. Damit könnten wir automatisch z.B. den letzen Änderer füllen
7. Wenn ihr alles richtig gemacht habt, sollte die Behavior Definition wie folgt aussehen
```
managed; // implementation in class zbp_cdx_i_orders_m_00 unique;

define behavior for ZCDX_I_ORDERS_M_00 alias Order
persistent table ZCDX_ORDER_00
lock master
//authorization master ( instance )
//etag master

{
  create;
  update;
  delete;
}
```
## Übung 5.3 Anlegen des Projection Views
Nun müssen wir noch einen Projection View anlegen. Der liegt "über" dem angelegten CDS View und dient dazu, die Daten nochmals zu filtern. Es könnten mehrere Projection Views zu einem CDS View existieren.
1. Anlegen des CDS View ZCDX_C_ORDERS_M_XX Orders Projection View.
   - Als Template im Wizard **Define Projection View** verwenden
   - data_source_name durch ZCDX_I_ORDERS_M_XX ersetzten
2. Bitte wieder ROOT nach DEFINE ergänzen
3. Wir wollen später wieder Metadaten Extensions anlegen. Daher die notwendige Annotaiton im Header angeben
```
@Metadata.allowExtensions: true
```
4. Damit wir unsere Aufträge später im UI suchen können, ist hier - ebenfalls im Header - noch eine weitere Annotation notwendig
```
@Search.searchable: true  
```
5. Auch hier machen wir wieder besser lesbare Feldnamen:
   - OrderNumber, OrderDate, Cusomter und CurrencyCode
6. Und jetzt ergänzen wir noch etwas für die Suche. In Fiori Elements Anwendungen gibt es auch ein allgemeines Suchfeld. Mit folgender Annotation definieren wir, dass bei solchen Suchen u.a. das Feld Customer verwendet werden soll. Die Annotation ist exakt vor dem Feld anzugeben
```
@Search.defaultSearchElement: true
customer      as Customer,
```
7. Für unser einfaches Demo reicht es jetzt einmal, bitte aktivieren nicht vergessen. Euer View sollte wie folgt aussehen.
```
@EndUserText.label: 'Order Projection View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZCDX_C_ORDERS_M_00 as projection on ZCDX_I_ORDERS_M_00 {

   key order_nr      as OrderNumber,
       order_date    as OrderDate,
       
       @Search.defaultSearchElement: true
       customer      as Customer,
       currency_code as CurrencyCode,

       _Currency 
}
```
## Übung 3.4. Metadata Extensions anlegen
Jetzt machen wir unsere Metadaten Extensions um UI Infos für die Fiori Anwendung anzugeben. Man könnte die Annotations natürlich auch bereits in den CDS Views direkt angeben, aber durch die Extensions hat man eine saubere Trennung der UI spezifischen Annotations.
1. Beim Kontext Menü des Projection Views ZCDX_C_ORDERS_M_XX die neue Metadata Extension ZCDX_E_ORDERS_M_XX anlegen.
2. Im Wizard **Annotate View** auswählen
3. Bei der Header Annotation @Metadata.layer bitte 
4. Hier definieren wir jetzt genauer, wie das Userinterface in der Fiori Anwendung aussehen soll. Bitte einfach das nachfolgende Coding kopieren.
   - Zu Beginn wird mit headerInfo der Kopfbereich definiert
   - Bei den Feldern wird jeweils festgelegt, wo und wie die Felder angezeigt werden sollen
```
@Metadata.layer: #CORE
annotate view ZCDX_C_ORDERS_M_00
    with 
{
  @UI.facet: [ { id:            'OrderNumber',
                 purpose:       #STANDARD,
                 type:          #IDENTIFICATION_REFERENCE,
                 label:         'Order',
                 position:      10 }]

  @UI: { lineItem:       [ { position: 10, 
                             importance: #HIGH } ], 
         identification: [ { position: 10 } ], 
         selectionField: [ { position: 10 } ] }
  OrderNumber;

  @UI: { lineItem:       [ { position: 20, 
                             importance: #MEDIUM } ], 
         identification: [ { position: 20 } ], 
         selectionField: [ { position: 20 } ] }
  OrderDate;

  @UI: { lineItem:       [ { position: 30, 
                             importance: #HIGH } ], 
         identification: [ { position: 30 } ] }
  Customer;

  @UI: { identification: [ { position: 40 } ]}
  CurrencyCode;
    
}  
```
## Übung 3.5. Behavior Definition Projection anlegen
Die Idee ist ja, dass mein ein großes Business Objekt hat und mehrere Behavior Definitionen hat. Hier könnte z.B. festgelegt werden, dass für eine Projection das DELETE erlaubt ist, für eine andere aber nicht. Etc.
1. Im Kontextmenü von ZCDX_C_ORDERS_M_XX eine neue Behavior Definition anlegen. Beim Implementierungstyp müsste eigentlich "Projection" stehen. Wenn nicht passt was nicht.
2. Im generierten Coden ändern machen wir zwei kleine Änderungen:
   - orders als alias angeben
   - delete mit // auskommentieren
   - Aktiviren nicht vergessen
3. Projection sollte wie folgt aussehen:
```    
projection;

define behavior for ZCDX_C_ORDERS_M_00 alias orders
{
  use create;
  use update;
//  use delete;
}
```   
### Übung 3.6. Anlegen der Service Definition und Service Binding
Jetzt haben wir es fast geschafft. Wir brauchen nur noch die Service Definition
1. Im Kontextmenü von ZCDX_C_ORDERS_M_XX eine neue Service Definition ZCDX_SD_ORDERS_M_XX anlegen. Wir machen nur eine kleine Ergänzung beim Alias, sonsten passt der generierte Code. Bitte beachtet, dass der Alias hier Orders (mit s) ist, da Order ein reservierter Name ist?!
2. Sieht euer Code wie folgt aus?
```  
@EndUserText.label: 'Service Definition for Order'
define service ZCDX_SD_ORDERS_M_00 {
  expose ZCDX_C_ORDERS_M_00 as Orders;
}
```  
3. Nun legen wir im Kontextmenü der Definition das neue Service ZCDX_UI_C_ORDERS_M_XX an.
   - Der Binding Typ soll ODATA V2 - UI sein (ist so vorausgewählt)
4. Rechts kann mit "Activate" das Service aktiviert werden. Dauert ein paar Sekunden
5. Dann das Objekt "Orders" auswählen und "Preview" drücken ... und beten! Wenn es beim ersten mal nicht startet, etwas später nochmals probieren.
6. Es sollte nun eine ziemlich fertige Anwendung starten. Spiel etwas herum damit. Ihr könnt neue Einträge anlegen oder ändern, die Daten werden auf die DB fortgeschrieben - durch das Framework.
### Übung 3.7. Validierungen hinzufügen
Interessant wird es ja, wenn wir nun gewisse Erweiterungen vornehmen. Wie z.B. eine eigene Validierung.
1. Zuerst müssen wir in der Behavior Definition ZCDX_I_ORDERS_M_XX ganz oben die Klasse ergänzen. Dort werden wir dann später unsere Implementierungen vornehmen.
```
managed implementation in class zbp_cdx_i_orders_m_00 unique;
```
2. In der Behavior Definition ZCDX_I_ORDERS_M_XX ergänzen wir folgende Erweiterung, gleich nach dem delete;
``` 
  validation validateCustomer on save { field customer; }
  validation validateDates    on save { field order_date; }
```  
3. Und jetzt generieren wir die Klasse indem wir uns auf den Klassennamen im Editor stellen und mit dem QuickFix die Klasse erstellen. Nach der Anlage verzweigt der Editor nach "Local Types". Wie man sieht, sind die beiden Methoden für die Validierung bereits vorhanden:
``` 
CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validateCustomer FOR VALIDATION Order~validateCustomer
      IMPORTING keys FOR Order.

    METHODS validateDates FOR VALIDATION Order~validateDates
      IMPORTING keys FOR Order.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD validateCustomer.
  ENDMETHOD.

  METHOD validateDates.
  ENDMETHOD.

ENDCLASS.
``` 
4. Jetzt kommen ein paar neue Statements. Bitte einfach das Coding der Methode übernehmen. Es geht hier darum, dass wir aus dem Memory die geänderten Daten ermitteln und prüfen. Wenn die Partnernummer größer als 100 ist, dann soll eine Fehlermeldung erfolgen.
``` 
  METHOD validateCustomer.

* read entities
     read entity zcdx_i_orders_m_00\\Order fields ( Customer ) with
        value #( for <root_key> in keys (  %key = <root_key> ) )
        result data(lt_orders).

     loop at lt_orders ASSIGNING field-symbol(<order>).
        if <order>-customer > 99.
           append value #( order_nr = <order>-order_nr ) to failed.
           append value #( order_nr = <order>-order_nr
                           %msg = new_message(  id = 'ZCDX_MESSAGES'
                                                number = '001'
                                                severity = if_abap_behv_message=>severity-error )
                           %element-order_nr = if_abap_behv=>mk-on ) to reported.
        endif.
     endloop.

  ENDMETHOD.
``` 
5. Nun sollte bei Anlagen oder Änderungen nur Partnernummern erlaubt sein, welche kleiner als 100 sind.
6. Jetzt versucht es beim Datum valudateDates selber. Ein Datum soll immer kleiner oder gleich dem Tagesdatum sein. Bei einem Datum in der Zukunft soll eine Fehlermeldung ZCDX_MESSAGES/002 ausgegeben werden. - Und los!
.
.
.
.
.

