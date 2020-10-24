locals {
  ns = "demo-gitlab"
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

module "harbor" {
  source     = "../../gitlab/"
  dns_domain = "${random_string.prefix.result}.${var.dns_domain}"
  namespace  = kubernetes_namespace.this.metadata[0].name
}

