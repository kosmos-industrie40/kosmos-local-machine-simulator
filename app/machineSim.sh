#!/bin/sh

# Simulates machine telemetry

trap exit TERM
export MY_FQDN=`hostname -f`
. common/request_cert.sh

# Payload to get out this BC-Data:
# {
#   "customerId": "datarella",
#   "prodMinutes": 0,
#   "prodPieces": 0,
#   "toolChanges": 0,
#   "travelDistance": 0,
#   "directionChange": 0,
#   "materialType": "aluminum"
# }

# Hint: BCC does mapping from mqtt payload "column" and "data" to field name and field value using BCC_CONFIG

# send_mqtt: Sends MQTT Message to $TOPIC
# Usage: send_mqtt <prodMinutes> <prodPieces> <toolChanges> <travelDistance> <directionChange> <materialType>
send_mqtt() {
    PAYLOAD=$(echo $PAYLOAD | jq ".data = [[\"$1\"],[\"$2\"],[\"$3\"],[\"$4\"],[\"$5\"],[\"$6\"]] | .timestamp = \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"")
    echo "====> Sending data"
    mosquitto_pub -h $MQTT_BROKER_FQDN -t "$TOPIC" -m "$PAYLOAD" --cafile /app/ca.pem --cert /app/cert.pem --key /app/key.pem -p 8883
}

endlos_senden() {
    while :; do
        send_mqtt 1 2 3 4 5 aluminum
        sleep 30 & wait ${!}
    done
}

# Entweder:

# endlos_senden

# oder 

send_mqtt 1 2 3 4 5 aluminum
sleep 30
send_mqtt 1 2 3 4 5 aluminum
sleep 30
send_mqtt 1 2 3 4 5 aluminum
sleep 30
send_mqtt 1 2 3 4 5 aluminum