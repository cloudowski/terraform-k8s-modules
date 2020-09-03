helm install chat stable/rocketchat --version 2.0.2 -f values.yaml

sleep 10 

#kubectl delete ing chat-rocketchat
#kubectl apply -f fixed-ingress.yaml

./configure.sh
