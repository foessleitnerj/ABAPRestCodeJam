# Übung 2 - HTTP Service "Küss die Hande, schöne Frau"
Zuerst machen wir eine kleine Aufwärmübung. Und zwar machen wir eine Hello World HTTP Klasse, cool oder? 
## Übung 2.1
Am Ende dieser Übung hast Du eine **HTTP Service** und eine **HTTP Handler Klasse** erstellt.
1. Erstelle das neue HTTP Service **Z_CDX_HELLO_WORLD_XXX** mit Beschreibung **Hello World HTTP**
   - Rechte Maus im bei Paket Z_CDX_XXX -> New -> Other ABAP Repository Object
   - Connectivity -> HTTP Service
   - Der Name der Handlerklasse wird vorgeschlagen. Lasse ihn wie er ist

   ![HTTPService](images/exc_1_2.png?raw=true "HTTP Service")
2. Navigiere zu der generierten HTTP Handlerklasse Z_CDX_HELLO_WORLD_XXX
   - Wie Du siehst, wurde das Interface **IF_HTTP_SERVICE_EXTENSION** bereits ergänzt
   - Ebenso ist bereits eine leere Implementierung der Method **HANDLE_REQUEST** vorhanden
3. Ergänze folgenden Code in der Methode
```
response->set_text( |Küss die Hand, schöne Frau - Ihre Augen sind so blau - Tirili, tirilo, tirila| ).
```
4. Zurück zum HTTP Service und auf die URL klicken
   ![HTTPService](images/exc_2_2.png?raw=true "HTTP Service")
5. Jetzt sollte eigentlich der Browser aufgehen

![HTTPService](images/exc_2_3.png?raw=true "HTTP Service")

## Übung 2.2. Optinal für die Schnellen und Streber
Jetzt machen wir etwas mehr Logik in der HTTP Klasse. Wir werden einen URL Parameter verwenden
1. Dem HTTP Call soll der Parameter **command** mitgegeben werden können
   - Wenn **eav** übergeben wird, soll der Text aus Übung 2.1 übergeben werden
   - Wenn **user** übergeben wird, soll der aktuelle User ausgegeben werden
   - In allen anderen Fällen soll ein HTTP 400 Error zurückgeliefert werden
2. Versuche die Lösung selber zu finden oder ... kopier nachfolgendes Coding in the Methode
```
    DATA(lt_params) = request->get_form_fields(  ).
    READ TABLE lt_params REFERENCE INTO DATA(lr_params) WITH KEY name = 'command'.
    IF sy-subrc <> 0.
      response->set_status( i_code = 400
                            i_reason = 'Bad request').
      RETURN.
    ENDIF.

    CASE lr_params->value.
      WHEN `eav`.
        response->set_text( |Küss die Hand, schöne Frau - Ihre Augen sind so blau - Tirili, tirilo, tirila| ).
      WHEN `user`.
        response->set_text( |{ sy-uname }| ).
      WHEN OTHERS.
        response->set_status( i_code = 400
                              i_reason = 'Bad request').
    ENDCASE.
```
3. Ein neuer Test mit der gleichen URL (ohne den command zusatz) müsste zu einem HTTP 400 Error führen
4. Einfach bei der URL ein &command=eav oder &command=user anhängen und schon sollte es funktioniere
![HTTPService](images/exc_2_4.png?raw=true "HTTP Service")
# Zusammenfassung
Gratuliere, jetzt hast Du ein HTTP Service und eine HTTP Implementierung angelegt. Awesome!
