resource "helm_release" "harbor" {
  count            = var.install ? 1 : 0
  name             = "harbor"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://helm.goharbor.io/"
  chart            = "harbor"
  version          = "1.2.1"
  wait             = false

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

  depends_on = [var.dependencies]
}

resource "null_resource" "harbor-post-script" {
  count      = var.install ? 1 : 0
  depends_on = [helm_release.harbor]

  provisioner "local-exec" {
    command = <<EOT
      sleep 30
      kubectl -n ${var.namespace} get deploy -oyaml harbor-harbor-portal |sed -e 's/8080/80/'|kubectl apply -f- -n ${var.namespace}
      kubectl -n ${var.namespace} get svc -oyaml harbor-harbor-portal |sed -e 's/8080/80/'|kubectl apply -f- -n ${var.namespace}
    EOT
  }

}
