#!/usr/bin/env bash

DNSDOMAIN="app.labs.k8sworkshops.com"
export HARBOR_HOST=registry.${DNSDOMAIN}

helm repo add harbor https://helm.goharbor.io
helm repo update 

helm install harbor harbor/harbor --values harbor-values.yaml \
    --set expose.ingress.hosts.core=$HARBOR_HOST \
    --set expose.ingress.hosts.notary=notary.${DNSDOMAIN} \
    --set externalURL=https://$HARBOR_HOST



echo "Waiting for deployment object to be created"

sleep 40

# fix svc portal - 8080 to 80

kubectl get deploy -oyaml harbor-harbor-portal |sed -e 's/8080/80/'|kubectl apply -f-
kubectl get svc -oyaml harbor-harbor-portal |sed -e 's/8080/80/'|kubectl apply -f-

