resource "helm_release" "harbor" {
  count            = var.install ? 1 : 0
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://helm.goharbor.io/"
  chart            = "harbor"
  version          = "1.5.0"
  wait             = var.wait_for_helm

  values = var.is_test ? [file("${path.module}/values.yaml"), file("${path.module}/values-test.yaml")] : [file("${path.module}/values.yaml")]

  set {
    type  = "string"
    name  = "expose.ingress.hosts.core"
    value = "registry.${var.dns_domain}"
  }

  set {
    type  = "string"
    name  = "externalURL"
    value = "https://registry.${var.dns_domain}"
  }

  set {
    type  = "string"
    name  = "expose.ingress.hosts.notary"
    value = "notary.${var.dns_domain}"
  }

  set {
    type  = "string"
    name  = "harborAdminPassword"
    value = var.admin_password
  }

  depends_on = [var.dependencies]
}
