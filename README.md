# oikosLink
Sistema containerizzato per l'acquisizione ed esposizione di dati ambientali. 

L'acquisizione è progettata per interagire con applicazioni che rappresentino il rapporto tra comportamenti domestici o comunque su piccola scala e l'ambiente circostante (e vice versa). Basato su NodeRed ed MQTT.

# Come impostare su un nuovo Host

Installare la repo localmente. Adattare in base al sistema operativo (il seguente codice è testato su MacOS). 

### Requisiti
- Docker Desktop

## Avviare i container

    $ docker-compose up -d

Questo comando avvia i seguenti container:

- Node-RED: http://localhost:1880
- InfluxDB: http://localhost:8086
- Mosquitto: http://localhost:1883

# Dispositivi Shelly

## Collegamento alla rete

Per impostare un nuovo dispositivo, effettuare i seguenti passaggi: 
- Tenere premuto il tasto di reset dello Shelly 
- Da un PC, collegarsi alla rete WiFi generata dal dispositivo
- Andare all'indirizzo 192.168.33.1 dove si possono modificare le impostazioni dello Shelly; attivare servizi Cloud (https://control.shelly.cloud ).
- Configurare il collegamento dello Shelly alla rete WiFi da utilizzare per l'applicazione. Una volta collegato, il nuovo IP del dispositivo si può trovare collegandosi dall'app alla stessa rete WiFi, aggiungendo il dispositivo, e andando su Informazioni Dispositivo.
- Per testare il collegamento e ottenere le informazioni di configurazione, puoi usare Postman per effettuare una richiesta GET http://`<IP dispositivo>`/settings/shellies/shellyem-C45BBEE1FE81/emeter/0/energy

## MQTT

Per abilitare MQTT, sarà necessario disabilitare servizi Cloud dalle impostazioni del dispositivo. 

Per la configurazione, inserire l'indirizzo IP del PC che contiene il broker, con porta 1883 (formato sarà `192.168.x.x:1883`), sulla rete Wi-Fi. Si consiglia di impostare un IP statico del dispositivo.

Per aggiungere credenziali utenti (sub o pub), aggiungere la coppia <nome utente>:<password> al file mosquitto/config/passwd. Dopodiché, eseguire il seguente comando per crittografare il file: 

    $ mosquitto_passwd -U mosquitto/config/passwd 

Infine, ricaricare il container. 

La frequenza di acquisizione di default è di 30 secondi. Per modificare, usare GET `<IP dispositivo>`/settings/?mqtt_update_period=`<tempo in secondi>`.

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

# Gestione dati tramite Node-RED

Per gestire il flusso dati, puoi programmare direttamente il flow di Node-RED andando a http://localhost:1880. 

Da lì è possibile impostare alcuni nodi essenziali:
- il subscription node che si collega al broker Mosquitto tramite il server istituito da Docker. Il server avrà un indirizzo corrispondente al container che gestisce MQTT (es. `172.18.0.2` con porta `1883`). L'autenticazione avviene tramite credenziali mqtt impostati nel file `passwd`. 
- il nodo che invia dati a InfluxDB, il cui server avrà il seguente formato: `172.18.0.3:8086`, con access token generato tramite l'interfaccia web InfluxDB. 
- rateLimit: il nodo che stabilisce la frequenza di invio al server di un'applicazione esterna (es. ogni 10s) tramite HTTP POST

Su Windows, in particolare, sarà necessario controllare le configurazioni di rete: Che il firewall non blocchi l'app Docker e che siano impostate regole del firewall per le porte 1883, 9001 per la rete in uso. 

## InfluxDB

Se nuovo, il database sarà da configurare con un bucket dedicato per i dati di interesse, es. `power_data`. Dall'interfaccia web è possibile generare query e visualizzazioni. Si consiglia di impostare un tempo di ritenuta di 7gg. 

# Risorse
- Docker e NodeRed: https://nodered.org/docs/getting-started/docker
- Docker e Mosquitto: https://medium.com/@tomer.klein/docker-compose-and-mosquitto-mqtt-simplifying-broker-deployment-7aaf469c07ee
- Testing Mosquitto: https://github.com/sukesh-ak/setup-mosquitto-with-docker