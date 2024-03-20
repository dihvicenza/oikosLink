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

# TO DO

- Implementare Secrets al posto di variabili d'ambiente
- Aggiornare tutte le password (crittografare pw mosquitto: $ docker exec mosquitto mosquitto_passwd -U /etc/mosquitto/passwd)

# Risorse
- Docker e NodeRed: https://nodered.org/docs/getting-started/docker
- Docker e Mosquitto: https://medium.com/@tomer.klein/docker-compose-and-mosquitto-mqtt-simplifying-broker-deployment-7aaf469c07ee
- Testing Mosquitto: https://github.com/sukesh-ak/setup-mosquitto-with-docker