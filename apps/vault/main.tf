locals {
  vault_url      = "vault.${var.dns_domain}"
  vault_helm_src = "${path.module}/src/"
}

resource "helm_release" "vault" {
  count     = var.install ? 1 : 0
  name      = "vault"
  namespace = var.namespace
  # create_namespace = true
  chart = "${local.vault_helm_src}/vault-helm/"
  # repository       = "https://charts.k8s.land"
  wait = true

  set {
    name  = "server.ingress.hosts[0].host"
    value = local.vault_url
  }
  set {
    name  = "server.ingress.tls[0].hosts[0]"
    value = local.vault_url
  }

  values = var.is_test ? [file("${path.module}/values.yaml"), file("${path.module}/values-test.yaml")] : [file("${path.module}/values.yaml")]

  depends_on = [var.dependencies, null_resource.get_repo]
}

resource "null_resource" "get_repo" {
  count = var.install ? 1 : 0

  provisioner "local-exec" {
    command = <<EOF
    if git -C vault-helm rev-parse &> /dev/null;then
      cd ./vault-helm
      git fetch --tags
    else
      git clone https://github.com/hashicorp/vault-helm
      cd ./vault-helm
    fi
    git checkout ${var.helm_version}
    EOF

    working_dir = local.vault_helm_src
  }
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
