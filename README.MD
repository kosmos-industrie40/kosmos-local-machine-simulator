# Lokale KOSMoS Komponente "Machine Simulator"

Mit diesem Repository wird beispielhaft dargestellt wie eine lokale KOSMoS Maschine Telemetriedaten über MQTT versenden kann.  
  
Das Beispiel baut auf Alpine Linux und nutzt `jq`, `curl` und `mosquitto-clients` und hat eine Imagegröße von 8.26MB.
  
[Changelog](./doc/CHANGELOG.MD)  
[Todo Liste](./doc/TODO.MD)  
  

## Voraussetzungen zur Installation/Nutzung

* Linux (getestet unter Ubuntu 18.04.4 LTS und Arch rolling)
* Docker (`apt install docker-ce` bzw. `pacman -S docker`)
* Die [lokale KOSMoS MQTT-Broker](https://github.com/kosmos-industrie40/kosmos-local-mqtt-broker) Komponente

  
## Konfiguration

Der Container ist stateless und wird über Umgebungsvariablen beim Start konfiguriert.

### Allgemeine Konfigurations Variablen

TODO: Verweis auf die Doku in welcher VAULT_TOKEN, MY_PKI_URI und MQTT_BROKER_FQDN erklärt wird.

### MQTT-Payload

[Detailiertere Beschreibung MQTT-Payload](https://github.com/kosmos-industrie40/kosmos-local-blockchain-connector/blob/master/doc/BCC_PAYLOAD.MD) 
  
  
## Automatische Installation und Start aller Services

Der Start der Komponenten erfolgt über ein Start-Script,
welches als Referenz für die Komponenten verwendet werden kann.

https://github.com/kosmos-industrie40/kosmos-local-startup

  
## Manueller Start der Komponente

Hinweise: 
* domainname (${KOSMOS_LOCAL_MQTT_CLIENT_ROLE_FQDN}): Domain Name (DN) / Rolle wie konfiguriert in der Vault PKI
* hostname (${MACHINE_NAME}): Hostname der Maschine
* Umgebungsvariablen
    * PAYLOAD: Die zu versendende Payload wird im Beispiel aus der Datei `MS_BCC_PAYLOAD.json` geholt
    * TOPIC: Auf dieses MQTT-Topic wird die Payload gesendet

> Host- und Domainname ergeben den FQDN bzw. CN auf welchen das Zertifikat ausgestellt werden soll

```
# Bauen und Taggen der Komponente
docker-compose build

# Ausführen der Komponente
docker run \
    -d \
    --net kosmos-local \
    --domainname=${KOSMOS_LOCAL_MQTT_CLIENT_ROLE_FQDN} \
    --hostname=${MACHINE_NAME}
    --name machine-simulator \
    -e PAYLOAD="$(cat MS_BCC_PAYLOAD.json)" \
    -e TOPIC='kosmos/machine-data/9d82699b-373a-4b2a-8925-f7bfacb618a4/Sensor/tbd/Update' \
    -e VAULT_TOKEN=${VAULT_TOKEN} \
    -e MY_PKI_URI=https://${KOSMOS_LOCAL_MQTT_CA_FQDN}:8201/v1/${KOSMOS_LOCAL_MQTT_PKI_PATH}/issue/${KOSMOS_LOCAL_MQTT_CLIENT_ROLE_PATH} \
    -e MQTT_BROKER_FQDN=${KOSMOS_LOCAL_MQTT_BROKER_HOSTNAME}.${KOSMOS_LOCAL_MQTT_BROKER_ROLE_FQDN} \
    harbor.kosmos.idcp.inovex.io/ondics/machine-simulator:rc2
```

## Funktionsweise

Der Maschinen Simulator läuft in einem Docker-Container und Sendet im 30 Sekunden Tackt insgesamt 4 Nachrichten.  
Als MQTT Schnittstelle wird das tool `mosquitto_pub` aus den Alpine Packetquellen verwendet.
Der Aufruf erfolgt über ein shell-Script.

> Es sind ebenfalls alle voraussetungen gegeben Nachrichten zu abonieren/empfangen, dies ist jedoch noch nicht implemtiert.

## Bauen des Containers und Push 

    $ docker login harbor.kosmos.idcp.inovex.io/ondics
    $ docker-compose build
    $ docker-compose push
  
## Credits

Dieses Repo wurde erstellt im Rahmen des BMBF Forschungsprojektes KOSMoS gefördert durch das https://www.bmbf.de/

Verwendete Software und Technologien:

* Eclipse Foundation: mosquitto
* alpine Linux: https://alpinelinux.org/
* Docker & Compose: https://www.docker.com

## Author

Andreas Clausnizer, Ondics GmbH
