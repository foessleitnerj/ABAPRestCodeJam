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
