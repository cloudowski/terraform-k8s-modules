locals {
  ns = "demo-rocketchat"
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

module "rocketchat" {
  source         = "../../rocketchat/"
  dns_domain     = "${random_string.prefix.result}.${var.dns_domain}"
  admin_username = "testadmin"
  admin_email    = "tomasz@cloudowski.com"
  namespace      = kubernetes_namespace.this.metadata[0].name
  admin_password = random_string.password.result
}

