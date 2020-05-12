#!/usr/bin/env bash

sleep 20

curl -m 5 -I -k -H "Content-Type: application/json" -X POST \
    --url "https://root:${ROOT_PASSWORD}@git.${DNSDOMAIN}/api/v1/orgs" \
    -d '{"username": "labs"}' \
    -w '%{http_code}' -o /tmp/out -s > /tmp/http_code

echo "OUT=$(cat /tmp/out)"
echo "HTTP CODE=$(cat /tmp/code)"
grep -q ^200 /tmp/http_code || exit 1


curl -m 5 -I -k -H "Content-Type: application/json" -X POST \
    --url "https://root:${ROOT_PASSWORD}@git.${DNSDOMAIN}/api/v1/org/labs/repos" \
    -d '{"name": "student", "auto_init": false, "private": false}' 
    -w '%{http_code}' -o /tmp/out -s > /tmp/http_code

echo "OUT=$(cat /tmp/out)"
echo "HTTP CODE=$(cat /tmp/code)"
grep -q ^200 /tmp/http_code || exit 1
