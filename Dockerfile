FROM alpine:3.12

RUN addgroup mqtt &&\
    adduser -D -G mqtt mqtt &&\
    apk add --no-cache mosquitto-clients curl jq

WORKDIR /app

COPY ./app /app
COPY ./common /app/common

RUN chmod +x /app/machineSim.sh &&\
    chown -R mqtt:mqtt /app
   
USER mqtt
    
ENTRYPOINT [ "/app/machineSim.sh" ]