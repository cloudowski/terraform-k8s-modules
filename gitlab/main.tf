locals {
  gitlab_url = "https://gitlab.${var.dns_domain}"
}

resource "helm_release" "gitlab" {
  count            = var.install ? 1 : 0
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://charts.gitlab.io/"
  chart            = "gitlab"
  version          = "5.8.2"
  wait             = true
  timeout          = 600

  values = var.is_test ? [file("${path.module}/values.yaml"), file("${path.module}/values-test.yaml")] : [file("${path.module}/values.yaml")]

  set {
    type  = "string"
    name  = "global.hosts.domain"
    value = var.dns_domain
  }

  depends_on = [var.dependencies]
}

# module "users" {
#   source     = "./modules/users"
#   token      = data.external.token.result.token
#   gitlab_url = local.gitlab_url
#   users = [
#     "demo5",
#   ]
# }

