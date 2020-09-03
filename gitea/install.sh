export DNSDOMAIN="app.labs.k8sworkshops.com"

# Kubernetes
helm install -f values.yaml -f values-test.yaml gitea \
    --set service.http.externalHost=git.${DNSDOMAIN} \
    k8s-land/gitea

