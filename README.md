# Terraform modules for Kubernetes 

This repository contains code that I use for my Kubernetes training and
workshops.

## Modules

* [addons/](addons/) - basic components for k8s clusters (e.g. nginx-ingress)
* [dns-aws/](dns-aws/) - External DNS with AWS integration
* [apps/cert-manager/](apps/cert-manager/) - cert-manager with Route53 integration
* [apps/gitea/](apps/gitea/) - Gitea git server
* [apps/harbor/](apps/harbor/) - [Harbor](https://goharbor.io/) container registry with awesome features
* [apps/jenkins/](apps/jenkins/) - Jenkins configured and managed from code
* [apps/rocketchat/](apps/rocketchat/) - [RocketChat](https://rocket.chat/)
* [apps/vault/](apps/vault/) - [Vault](https://www.vaultproject.io/) running in a container
* [apps/vault-eks/](apps/vault-eks/) - Vault configuration prepared for EKS authentication
* [workshops/](workshops/) - Meta module used to build a workshop environment comprising of the previous modules
