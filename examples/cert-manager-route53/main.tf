provider "aws" {
  region = var.aws_region
}

locals {
  ns = "cert-manager"
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

module "cert-manager" {
  source     = "../../cert-manager/"
  dns_domain = var.dns_domain
  namespace  = kubernetes_namespace.cert-manager.metadata[0].name
  acme_email = var.acme_email
  kubeconfig = var.kubeconfig
}

