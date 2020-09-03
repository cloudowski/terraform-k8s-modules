kubectl apply -f casc/

JENKINS_HOST=jenkins.app.labs.k8sworkshops.com

helm install jenkins  stable/jenkins -f jenkins-values.yaml \
    --set master.ingress.hostName=$JENKINS_HOST \
    --set master.ingress.tls[0].hosts[0]=$JENKINS_HOST \
    --version 1.6.0


# add deployer

kubectl create sa deployer 
kubectl create rolebinding jenkins-deployer-edit --clusterrole=edit --serviceaccount=jenkins:deployer 
kubectl create clusterrolebinding jenkins-deployer-admin --clusterrole=cluster-admin --serviceaccount=jenkins:deployer

#kubectl create secret generic jenkins-docker-creds  --from-file=.dockerconfigjson=/Users/tomasz/.docker/config.json.plain  --type=kubernetes.io/dockerconfigjson -n jenkins

echo http://$JENKINS_HOST

