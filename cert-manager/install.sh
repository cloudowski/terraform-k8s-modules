kubectl apply --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v0.14.0/cert-manager.crds.yaml

helm repo add jetstack https://charts.jetstack.io
helm repo update 

# fix some bug
kubectl create ns cert-manager
helm install cert-manager --version v0.14.0 -n cert-manager jetstack/cert-manager

sleep 60

kubectl apply -f clusterissuers.yaml -f issuers.yaml
