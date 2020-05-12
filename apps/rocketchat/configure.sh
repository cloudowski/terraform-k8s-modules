#!/usr/bin/env bash

kubectl delete secret configure-chat
kubectl create secret generic configure-chat --from-file=configure-chat.sh
kubectl delete -f configure-chat-job.yaml
kubectl apply -f configure-chat-job.yaml

