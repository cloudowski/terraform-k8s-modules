#!/usr/bin/env bash
set -e
set -x

exec 2> /tmp/dbg.log
# exec &> /tmp/dbg.log

eval "$(jq -r '@sh "SERVICE_ACCOUNT_NAME=\(.SERVICE_ACCOUNT_NAME) NAMESPACE=\(.NAMESPACE)"')"

CONTEXT=$(kubectl config current-context)

NEW_CONTEXT=default
KUBECONFIG_FILE="kubeconfig"


kubectl get serviceaccount ${SERVICE_ACCOUNT_NAME} \
  --context ${CONTEXT} \
  --namespace ${NAMESPACE} &> /dev/null \
  || { echo '{"kubeconfig_base64": ""}'; exit 0; }
SECRET_NAME=$(kubectl get serviceaccount ${SERVICE_ACCOUNT_NAME} \
  --context ${CONTEXT} \
  --namespace ${NAMESPACE} \
  -o jsonpath='{.secrets[0].name}')
TOKEN_DATA=$(kubectl get secret ${SECRET_NAME} \
  --context ${CONTEXT} \
  --namespace ${NAMESPACE} \
  -o jsonpath='{.data.token}')

TOKEN=$(echo ${TOKEN_DATA} | base64 -d)

kubectl config view --raw > ${KUBECONFIG_FILE}.full.tmp
{
kubectl --kubeconfig ${KUBECONFIG_FILE}.full.tmp config use-context ${CONTEXT}
kubectl --kubeconfig ${KUBECONFIG_FILE}.full.tmp config view --flatten --minify > ${KUBECONFIG_FILE}.tmp
kubectl config --kubeconfig ${KUBECONFIG_FILE}.tmp rename-context ${CONTEXT} ${NEW_CONTEXT}
kubectl config --kubeconfig ${KUBECONFIG_FILE}.tmp set-credentials ${CONTEXT}-${NAMESPACE}-token-user --token ${TOKEN}
kubectl config --kubeconfig ${KUBECONFIG_FILE}.tmp set-context ${NEW_CONTEXT} --user ${CONTEXT}-${NAMESPACE}-token-user
kubectl config --kubeconfig ${KUBECONFIG_FILE}.tmp set-context ${NEW_CONTEXT} --namespace ${NAMESPACE}
kubectl config --kubeconfig ${KUBECONFIG_FILE}.tmp view --flatten --minify > ${KUBECONFIG_FILE}
} > /dev/null

rm ${KUBECONFIG_FILE}.full.tmp
rm ${KUBECONFIG_FILE}.tmp
echo "{\"kubeconfig_base64\": \"$(base64 < ${KUBECONFIG_FILE})\"}"

rm ${KUBECONFIG_FILE}
