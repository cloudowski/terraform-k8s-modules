#!/usr/bin/env bash

# NAMESPACE=default

TIMEOUT=120
t=0

VAULT_POD=$(kubectl get pod -lapp.kubernetes.io/name=vault --no-headers -n ${NAMESPACE}|awk '{print $1}')
while [ -z "$VAULT_POD" ];do
    sleep 5
    t=$((t+5))
    [ $t -ge $TIMEOUT ] && break
    VAULT_POD=$(kubectl get pod -lapp.kubernetes.io/name=vault --no-headers -n ${NAMESPACE}|awk '{print $1}')
done
[ -z "$VAULT_POD" ] && exit 1


while ! kubectl exec -n ${NAMESPACE} -i $VAULT_POD -- vault operator init > $INIT_OUTPUT_FILE;do
    sleep 5
    t=$((t+5))
    [ $t -ge $TIMEOUT ] && exit 1
done

echo "Vault initialization has completed successfuly"

exit 0
