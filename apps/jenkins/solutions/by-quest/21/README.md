# Running docker-pets in multiple environments

## Locally on minikube

First create two separate environments - let's use namespaces for that purpose

```shell
kubectl create ns pets-test
kubectl create ns pets-prod
```

Now before applying you need to adjust a couple of kubernetes objects. 

* Edit `pets-ingress.yaml` in both `environments/test/` and `environments/test/` and change `192.168.99.100` to your minikune IP address.

It's time to deploy it - use the following command to deploy to **pets-test** environment

```shell
kubectl -n pets-test apply -R -f environments/test
```

and similarily for prod

```shell
kubectl -n pets-prod apply -R -f environments/prod
```

## In the cloud (on remote Kubernetes cluster)

Create a new `cloud` environments as a copy of `test`

```shell
cp -a environments/test environments/cloud
```

Now adjust kubernetes manifests
* Edit `pets-ingress.yaml` and change `host:` entries to `admin-pets-YOURNAMESPACE.app.labs.k8sworkshops.com` and `pets-USER.app.labs.k8sworkshops.com` accordingly
* Edit `pets-configmap.yaml` and change `consul.pets-test.svc.cluster.local` to `consul.YOURNAMESPACE.svc.cluster.local`

**Change context** to the cloud kubernetes cluster and apply your manifests

```shell
kubectl apply -R -f environments/cloud
```
