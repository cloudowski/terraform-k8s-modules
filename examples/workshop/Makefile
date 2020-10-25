
MINIKUBE_KUBECONFIG=$(shell cd ../minikube-aws;terraform output kubeconfig_file)
AWS_PROFILE=cloudowski

kubeconfig:
	@echo export KUBECONFIG=$(MINIKUBE_KUBECONFIG)

plan:
	AWS_PROFILE=$(AWS_PROFILE) \
	KUBECONFIG=$(MINIKUBE_KUBECONFIG) \
	TF_VAR_kubeconfig=$(MINIKUBE_KUBECONFIG) \
		terraform plan

apply:
	AWS_PROFILE=$(AWS_PROFILE) \
	KUBECONFIG=$(MINIKUBE_KUBECONFIG) \
	TF_VAR_kubeconfig=$(MINIKUBE_KUBECONFIG) \
		terraform apply -auto-approve

destroy:
	AWS_PROFILE=$(AWS_PROFILE) \
	KUBECONFIG=$(MINIKUBE_KUBECONFIG) \
	TF_VAR_kubeconfig=$(MINIKUBE_KUBECONFIG) \
		terraform destroy -auto-approve