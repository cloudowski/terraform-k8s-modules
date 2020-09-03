# Terraform modules for Kubernetes

This repository contains code that I use for my Kubernetes training and
workshops.

## Modules

* [addons/](addons/) - basic components for k8s clusters (e.g. nginx-ingress)
* [cert-manager/](cert-manager/) - cert-manager with Route53 integration
* [dns-aws/](dns-aws/) - External DNS with AWS integration
* [gitea/](gitea/) - Gitea git server
* [gitlab/](gitlab/) - GitLab
* [gitlab-oauth/](gitlab-oauth/) - GitLab OAuth configuration for various apps using it as as a service provider
* [gitlab-token/](gitlab-token/) - Retrieve personal token from GitLab
* [gitlab-users/](gitlab-users/) - Configure GitLab users
* [harbor/](harbor/) - [Harbor](https://goharbor.io/) container registry with awesome features
* [jenkins/](jenkins/) - Jenkins configured and managed from code
* [kubeconfig-sa/](kubeconfig-sa/) - Create kubeconfig using existing serviceaccount
* [prometheus/](prometheus/) - Configure prometheus with grafana using prometheus-operator
* [rocketchat/](rocketchat/) - [RocketChat](https://rocket.chat/)
* [vault/](vault/) - [Vault](https://www.vaultproject.io/) running in a container
* [vault-eks/](vault-eks/) - Vault configuration prepared for EKS authentication
* [workshops/](workshops/) - Meta module used to build a complete workshop environment comprising of the previous modules
