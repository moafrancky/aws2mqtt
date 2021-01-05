#!/bin/bash
MQTT_HOST=${MQTT_HOST:-localhost}
MQTT_ID=${MQTT_ID:-awscli2mqtt}
MQTT_TOPIC=${MQTT_TOPIC:-aws}
MQTT_OPTIONS=${MQTT_OPTIONS:-"-r"}
MQTT_USER=${MQTT_USER:-user}
MQTT_PASS=${MQTT_PASS:-pass}

awscliversion="$(aws --version | awk '{print $1}' | awk -F / '{print $2}')"
monthtodatecostresult="$(aws ce get-cost-and-usage --time-period Start=$(date +'%Y-%m-01'),End=$(date +'%Y-%m-01' -d next-month) --granularity MONTHLY --metrics BlendedCost)"
monthtodatecostamount="$(echo ${monthtodatecostresult} | jq -r '.ResultsByTime[0].Total.BlendedCost.Amount')"
monthtodatecostunit="$(echo ${monthtodatecostresult} | jq -r '.ResultsByTime[0].Total.BlendedCost.Unit')"

echo "$(date -Iseconds) aws-cli version ${awscliversion}"
echo "$(date -Iseconds) month-to-date amount ${monthtodatecostamount}"
echo "$(date -Iseconds) month-to-date unit ${monthtodatecostunit}"


echo "$(date -Iseconds) sending results to ${MQTT_HOST} as clientID ${MQTT_ID} with options ${MQTT_OPTIONS} using user ${MQTT_USER}"
/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/awscli/version -m "${awscliversion}"

/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/costexplorer/monthtodate/amount -m "${monthtodatecostamount}"
/usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS} -t ${MQTT_TOPIC}/costexplorer/monthtodate/unit -m "${monthtodatecostunit}"
