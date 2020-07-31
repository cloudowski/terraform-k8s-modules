locals {
  vault_url      = "vault.${var.dns_domain}"
  vault_helm_src = "${path.module}/src/"
}

resource "helm_release" "vault" {
  count            = var.install ? 1 : 0
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  chart            = "vault"
  repository       = "https://helm.releases.hashicorp.com/"
  version          = var.vault_version
  wait             = true

  set {
    name  = "server.ingress.hosts[0].host"
    value = local.vault_url
  }
  set {
    name  = "server.ingress.tls[0].hosts[0]"
    value = local.vault_url
  }

  values = var.is_test ? [file("${path.module}/values.yaml"), file("${path.module}/values-test.yaml")] : [file("${path.module}/values.yaml")]

  depends_on = [var.dependencies]
}

resource "null_resource" "post-script-vault-init" {
  count      = var.install ? 1 : 0
  depends_on = [helm_release.vault]

  provisioner "local-exec" {
    command = "${path.module}/vault-init.sh"
    environment = {
      NAMESPACE        = var.namespace
      INIT_OUTPUT_FILE = var.vault_init_output_file
    }
  }

}
