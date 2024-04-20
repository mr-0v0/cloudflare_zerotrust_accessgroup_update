#!/usr/bin/env bash

API_TOKEN=API_TOKEN
POLICY_NAME=POLICY_NAME
$URL=https://api.cloudflare.com/client/v4/zones/<id>access/groups/<id>

# Get Latest External IP Address

HOST1_IP=`dig +short @1.1.1.1 host1.dyndns.org | tail -1`"/32"
HOST2_IP=`dig +short @1.1.1.1 host2.dyndns.org`"/32"

# Get Last External IP Address

HOST1_LAST_IP=`cat host1_ip.txt`
HOST1_LAST_IP=`cat host2_ip.txt`

# Update Access Group

if [ "$HOST1_IP" == "$HOST1_LAST_IP" ] && [ "$HOST2_IP" == "$HOST1_LAST_IP" ]
then
     exit 0
else
     curl --request PUT \
     --url $URL \
     --header 'Content-Type: application/json' \
     -H "Authorization: Bearer $API_TOKEN" \
     --data '{
          "include": [
               {
                    "ip": {
                         "ip": "'"$HOST1_IP"'"
                    }
               },
               {
                    "ip": {
                         "ip": "'"$HOST2_IP"'"
                    }
               }
          ],
          "exclude": [],
          "require": [],
          "name": "'"$POLICY_NAME"'"
     }'

     echo $HOST1_IP > host1_ip.txt
     echo $HOST2_IP > host2_ip.txt
fi
