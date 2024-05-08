# oikosLink
Sistema containerizzato per l'acquisizione ed esposizione di dati ambientali. 

L'acquisizione è progettata per interagire con applicazioni che rappresentino il rapporto tra comportamenti domestici o comunque su piccola scala e l'ambiente circostante (e vice versa). Basato su NodeRed ed MQTT.

# Come impostare su un nuovo PC

Installare la repo localmente. Adattare in base al sistema operativo (il seguente codice è testato su MacOS). 

### Requisiti
- Docker

## Avviare il container

    $ docker-compose up -d

Su browser, andare all'indirizzo: http://localhost:1880

# Dispositivi Shelly

Andare su https://control.shelly.cloud 

## Commandi di linea

Scarica info (output json):

    $ curl -X POST https://$SHELLY_SERVER_URI/device/status -d "id=$SHELLY_DEVICE&auth_key=$SHELLY_AUTH_KEY"

Accensione lampadina: 

    $ curl -X POST https://$SHELLY_SERVER_URI/device/relay/control -d "channel=0&turn=on&id=$SHELLY_DEVICE&auth_key=$SHELLY_AUTH_KEY"

Effettua il reboot:

    $ curl -X POST -d '{"id":1, "method":"Shelly.Reboot"}' http://${SHELLY_DEVICE}/rpc

### MQTT

Stabilisci connessione a un broker (pubblico).

    $ curl -X POST -d '{"id":1, "method":"Mqtt.SetConfig", "params":{"config":{"enable":true, "server":"broker.hivemq.com:1883"}}}' http://${SHELLY_DEVICE_IP}/rpc

Controlla status connessione.

    $ curl -X POST -d '{"id":1, "method":"Mqtt.GetStatus"}' http://${SHELLY_DEVICE_IP}/rpc

Per aggiungere credenziali utenti (sub o pub), aggiungere la coppia <nome utente>:<password> al file mosquitto/config/passwd. Dopodiché, eseguire il seguente comando per crittografare il file: 

    $ docker exec mqtt mosquitto_passwd -U /mosquitto/config/passwd

Configurazione frequenza di campionamento:Per dispositivi shelly, il default è 30 secondi. Per modificare, usare GET 192.168.10.200/settings/?mqtt_update_period=60.

Topic a disposizione:

- shellies/shelly1/relay/0
- shellies/shelly1/emeter/0/power
- shellies/shelly1/emeter/0/reactive_power
- shellies/shelly1/emeter/0/pf
- shellies/shelly1/emeter/0/voltage
- shellies/shelly1/emeter/0/total 
- shellies/shelly1/emeter/0/total_returned
- shellies/shelly1/emeter/1/power 
- shellies/shelly1/emeter/1/reactive_power
- shellies/shelly1/emeter/1/pf 
- shellies/shelly1/emeter/1/voltage 
- shellies/shelly1/emeter/1/total 
- shellies/shelly1/emeter/1/total_returned

# Risorse
- Docker e NodeRed: https://nodered.org/docs/getting-started/docker
- Docker e Mosquitto: https://medium.com/@tomer.klein/docker-compose-and-mosquitto-mqtt-simplifying-broker-deployment-7aaf469c07ee
- Testing Mosquitto: https://github.com/sukesh-ak/setup-mosquitto-with-docker