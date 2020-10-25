terraform {
  required_version = "~> 0.13.4"
  required_providers {
    helm = ">= 1.2.1"
  }
}

locals {
  full_dns_domain = "${random_string.dns_prefix.result}.${var.dns_domain}"
  admin_password  = var.admin_password != "" ? var.admin_password : random_string.password.result
}

provider "aws" {
  region = var.aws_region
}

resource "kubernetes_namespace" "labs" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "random_string" "dns_prefix" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "password" {
  length  = 10
  special = false
  upper   = true
}

module "dns-aws" {
  source     = "../../dns-aws/"
  dns_domain = var.dns_domain
}

module "cert-manager" {
  source     = "../../cert-manager/"
  dns_domain = var.dns_domain
  namespace  = kubernetes_namespace.cert-manager.metadata[0].name
  acme_email = "tomasz+acme@cloudowski.com"
  kubeconfig = var.kubeconfig
}

module "rocketchat" {
  source         = "../../rocketchat/"
  dns_domain     = local.full_dns_domain
  admin_username = "testadmin"
  admin_email    = "tomasz@cloudowski.com"
  namespace      = kubernetes_namespace.labs.metadata[0].name
  admin_password = local.admin_password
  is_test        = var.is_test
  depends_on     = [module.cert-manager]
}

module "jenkins" {
  source         = "../../jenkins/"
  dns_domain     = local.full_dns_domain
  namespace      = kubernetes_namespace.labs.metadata[0].name
  admin_password = local.admin_password
  kubeconfig     = var.kubeconfig
  is_test        = var.is_test
  depends_on     = [module.cert-manager]
}

module "harbor" {
  source         = "../../harbor/"
  dns_domain     = local.full_dns_domain
  namespace      = kubernetes_namespace.labs.metadata[0].name
  admin_password = local.admin_password
  is_test        = var.is_test
  depends_on     = [module.cert-manager]
}

module "gitlab" {
  source     = "../../gitlab/"
  dns_domain = local.full_dns_domain
  namespace  = kubernetes_namespace.labs.metadata[0].name
  is_test    = var.is_test
  depends_on = [module.cert-manager]
}

