resource "helm_release" "harbor" {
  count      = var.install ? 1 : 0
  name       = "harbor"
  namespace  = var.namespace
  repository = data.helm_repository.harbor.metadata.0.name
  chart      = "harbor"
  version    = "1.2.1"
  wait       = false

  values = var.is_test ? [file("${path.module}/values.yaml"), file("${path.module}/values-test.yaml")] : [file("${path.module}/values.yaml")]

  set_string {
    name  = "expose.ingress.hosts.core"
    value = "registry.${var.dns_domain}"
  }

  set_string {
    name  = "externalURL"
    value = "https://registry.${var.dns_domain}"
  }

  set_string {
    name  = "expose.ingress.hosts.notary"
    value = "notary.${var.dns_domain}"
  }
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
