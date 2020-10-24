locals {
  ns = "demo-jenkins"
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = local.ns
  }
}

resource "random_string" "prefix" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "password" {
  length  = 10
  special = false
  upper   = true
}

module "jenkins" {
  source         = "../../jenkins/"
  dns_domain     = "${random_string.prefix.result}.${var.dns_domain}"
  namespace      = kubernetes_namespace.this.metadata[0].name
  admin_password = random_string.password.result
  kubeconfig     = var.kubeconfig
}

