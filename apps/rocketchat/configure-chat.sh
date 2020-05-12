#!/usr/bin/env bash

set -x

HEADERS=$(http --verify=no --ignore-stdin -pb https://chat.app.labs.k8sworkshops.com/api/v1/login "user=cloudowski" "password=mirabelka" | jq -r '"X-Auth-Token:" + .data.authToken + " X-User-Id:" + .data.me._id')

[ "$HEADERS"x = "x" ] && { echo "Failed to get auth token.." &>2;exit 1; }

http --verify=no --ignore-stdin -pb https://chat.app.labs.k8sworkshops.com/api/v1/channels.create "name=cicd" $HEADERS
http --verify=no --ignore-stdin -pb https://chat.app.labs.k8sworkshops.com/api/v1/users.create $HEADERS \
    name=jenkins \
    username=jenkins \
    password=J3nk1ns \
    verified:=true \
    joinDefaultChannels:=false \
    email=jenkins@example.com

