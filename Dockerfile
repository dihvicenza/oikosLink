FROM nodered/node-red:latest

RUN chmod 0700 /mosquitto/config/passwd
RUN chown root /mosquitto/config/passwd