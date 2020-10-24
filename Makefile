
MINIKUBE_KUBECONFIG=$(shell cd ./examples/minikube-aws;terraform output kubeconfig_file)

create-minikube-aws:
	export AWS_PROFILE=cloudowski; \
	cd ./examples/minikube-aws; \
	terraform apply -auto-approve

destroy-minikube-aws:
	export AWS_PROFILE=cloudowski; \
	cd ./examples/minikube-aws; \
	terraform destroy -auto-approve

test-cert-manager:
	cd ./cert-manager/; \
	KUBECONFIG=$(MINIKUBE_KUBECONFIG) make test

test-jenkins:
	cd ./jenkins/test; \
	KUBECONFIG=$(MINIKUBE_KUBECONFIG) go test