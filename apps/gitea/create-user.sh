#!/usr/bin/env bash


TIMEOUT=180
t=0
# Fix permissions on /data
GITEA_POD=$(kubectl get pod -lapp=gitea-gitea --no-headers -n ${NAMESPACE}|awk '{print $1}')
while [ -z "$GITEA_POD" ];do
    sleep 5
    t=$((t+5))
    [ $t -ge $TIMEOUT ] && break
    GITEA_POD=$(kubectl get pod -lapp=gitea-gitea --no-headers -n ${NAMESPACE}|awk '{print $1}')
done
[ -z "$GITEA_POD" ] && exit 1


while ! kubectl exec -n ${NAMESPACE} -i $GITEA_POD -c gitea -- su git -c "/app/gitea/gitea admin create-user --username ${ADMIN_USER} --password ${ADMIN_PASSWORD} --email root@example.com --admin";do
    sleep 5
    t=$((t+5))
    [ $t -ge $TIMEOUT ] && exit 1
done

exit 0
