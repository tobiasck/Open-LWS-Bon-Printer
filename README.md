# Open-LWS-Bon-Printer
Bei diesem Projekt handelt es sich um eine Anwenung welche für das Open Lehrwerkstatt Event der Swarz IT entwickelt wurde. Die Idee/Aufgabe besteht darin einen Kassenzettel-Drucker Zitate ausdrucken zu lassen. Als Print Event sollten externe Sensoren verwendet werden (z.B. Annäherungssensor, normaler Taster/Schalter, etc.).

### OpenLWS.sh
Es wurde sich für einen Raspberry Pi entschieden, welcher via USB-Kabel mit dem Bon-Drucker verbunden wird. Der Raspberry Pi kann dann mit Hilfe von wget und einer API (https://api.zitat-service.de/v1/quote) ein Zitat aus dem Internet laden. Anschließend kann das Zitat über einen Seriellen Print mit echo -e an den Seriellen Port des Drucker versendet werden.

### OpenLWS.py
Um diesen Print mit Sensoren zu triggern, wurde ein Python Script geschrieben, welches Sensordaten ausliest und das Shell Skript OpneLWS.sh dementsprechen ausführt.

## Installieren der Bon-Drucker Software auf einem Raspberry PI
1. Download des Repositorys
    ```
    wget https://github.com/JonasSchmalzhaf/Open-LWS-Bon-Printer.git
    ```
    oder
    ```
    git clone https://github.com/JonasSchmalzhaf/Open-LWS-Bon-Printer.git
    ```

2. Rechte für install.sh vergeben
    ```
    sudo chmod 775 install.sh
    ```

3. Ausführen von install.sh
    ```
    ./install.sh
    ```

## Erläuterungen für evtl. Anpassungen
Die [Bixolon Command Page](https://www.bixolon.com/_upload/manual/Manual_Command_Thermal_POS_Printer_ENG_V1.00[9].pdf) beinhaltet verschiedene Command zur allgemeinen Steuerung und Konfiguration des Druckers, wie z.B. Schrifftgröße, Auswahl der Code Tables, Text Ausrichtung, etc. Diesen Funktionen werden Hex-Werte zugeordnet um sie aus zu führen.

Die [Bixolon Code Page](https://www.bixolon.com/_upload/manual/Manual_Code_Page_Thermal_Label_ENG_V1.03[4].pdf) beinhaltet verschiedene Code Tabelen. Diese Code Tabellen ordnen verschiedenen Zeischen Hex-Werte zu.

Hex-Werte lassen sich unter Linux und in Shell Scripts folgendermaßen an den Drucker senden:
  ```
  echo -e "\x0A\x0F" > /dev/usb/lp0
  ```

Dabei ist wichtig das für **/dev/usb/lp0** der richtige USB Port gewählt wird, über welchen der Drucker erreichbar ist.
Mit **echo -e** können jedoch auch "normale" Strings versendet werden. Dabei ist zu beachten das sonder Zeichen (ä, ö, ü, ß) vom Drucker nicht richtig gedurckt werden. Also muss für diese Zeichen der entsprechende Code aus der Code Page eingefügt werden.

Außerdem ist beim Drucken zu beachten, dass der Drucker maximal 24 Zeichen breit drucken kann (bei doppelter Schrifftgröße). Nach diesen 24 Zeichen bricht der Drucker die Zeile automatisch um.

Das Layouts des Kassenzettels ist im **OpenLWS.sh** Skript anzupassen (siehe auch Code Kommentare).
