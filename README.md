# oikosLink
Sistema di rilevamento containerizzato per l'acquisizione ed esposizione di dati ambientali. L'acquisizione è progettata per interagire con applicazioni che rappresentino il rapporto tra comportamenti domestici o comunque su piccola scala e l'ambiente circostante (e vice versa). Basato su NodeRed ed MQTT.

# Come impostare su un nuovo PC

Installare la repo localmente. Adattare in base al sistema operativo (il seguente codice è testato su MacOS). 

### Requisiti
- Docker

## Avviare il container

    $ docker build -t oikos .
    $ docker run -it -p 1880:1880 oikos

Su browser, andare all'indirizzo: http://localhost:1880

# Risorse
- Docker e NodeRed: https://nodered.org/docs/getting-started/docker