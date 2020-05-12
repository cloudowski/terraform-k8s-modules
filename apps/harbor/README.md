# Harbor registry

```

DNSDOMAIN="app.labs.k8sworkshops.com"
export HARBOR_HOST=registry.${DNSDOMAIN}

helm repo add harbor https://helm.goharbor.io

helm install --name harbor harbor/harbor --values harbor-values.yaml \
    --set expose.ingress.hosts.core=$HARBOR_HOST \
    --set expose.ingress.hosts.notary=notary.${DNSDOMAIN} \
    --set externalURL=https://$HARBOR_HOST




echo "User/login: admin/Harbor12345 @ https://${HARBOR_HOST}"
```

## Fix for cert-manager - FIXED by upstream

kubectl edit deploy harbor-harbor-core

Change 

   - name: ca-download
        secret:
          defaultMode: 420
          items:
          - key: ca.crt <-- to tls.crt
            path: ca.crt 

## Fix ports

* fix svc portal - 8080 to 80

kubectl edit svc harbor-harbor-portal

* fix deploy portal - 8080 to 80

kubectl edit deploy harbor-harbor-portal


## Import cert

Import harbor CA as trusted CA to Docker

```
curl -k https://$HARBOR_HOST/api/systeminfo/getcert | minikube ssh "sudo mkdir -p /etc/docker/certs.d/$HARBOR_HOST && sudo tee /etc/docker/certs.d/$HARBOR_HOST/ca.crt"
```

## Test

```
eval $(minikube docker-env)

docker login $HARBOR_HOST -uadmin -pHarbor12345
docker tag drone/drone:1.2 $HARBOR_HOST/library/drone
docker push $HARBOR_HOST/library/drone
```
