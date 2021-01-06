# aws2mqtt

Alpine-based docker to push AWS month-to-date costs to a MQTT Server.

## Environment Variables

    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    AWS_DEFAULT_REGION

    CRON (Default '0 6,18 * * *' -> run twice a day )
    MQTT_HOST (Default 'localhost')
    MQTT_ID (Default 'aws2mqtt')
    MQTT_TOPIC (Default 'aws')
    MQTT_OPTIONS (Default '-r')
    MQTT_USER (Default 'user')
    MQTT_PASS (Default 'pass')

## Examples

#### docker-compose.yml

```
version: "3"

services:

  aws2mqtt:
    image: moafrancky/aws2mqtt:latest
    container_name: aws2mqtt
    environment:
      - MQTT_HOST=192.168.100.100
      - AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxxx
      - AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      - AWS_DEFAULT_REGION=eu-west-1      
    restart: unless-stopped
```

#### docker 

```
docker run -d --env-file ./env.list moafrancky/aws2mqtt:latest
```

with env.list

```
AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxxx
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AWS_DEFAULT_REGION=eu-west-1
MQTT_HOST=192.168.100.100
MQTT_ID=aws2mqtt
MQTT_TOPIC=aws
MQTT_OPTIONS=-r
MQTT_USER=user
MQTT_PASS=changeme
CRON=0 6,18 * * *
```

## Pricing Reminder

This docker uses AWS CLI and 'aws ce get-cost-and-usage' API. 

[AWS Cost Management Pricing](https://aws.amazon.com/aws-cost-management/pricing/)
"The AWS Cost Explorer API lets you directly access the interactive, ad-hoc query engine that powers AWS Cost Explorer. 
***Each request will incur a cost of $0.01.***" 

## AWS Policy

To have access to get-cost-and-usage API, you will need this policy

```
{

    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ce:GetCostAndUsage",
            "Resource": "*"
        }
    ]
}
```