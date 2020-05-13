locals {
  clusterissuers = templatefile("${path.module}/clusterissuers-route53.yaml.tmpl", {
    aws_region           = var.route53_region
    aws_access_key       = aws_iam_access_key.cert_manager.id
    aws_creds_secret     = "cert-manager-awskey"
    aws_creds_secret_key = "secret-access-key"
    }
  )

}

terraform {
  required_providers {
    helm = ">= 1.2.1"
  }
}

resource "helm_release" "cert-manager" {
  count = var.install ? 1 : 0

  name             = "cert-manager"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.chart_version

  depends_on = [null_resource.cert-manager-pre-script, var.dependencies]
}

resource "null_resource" "cert-manager-post-script" {
  count      = var.install ? 1 : 0
  depends_on = [helm_release.cert-manager]

  provisioner "local-exec" {
    command = "kubectl -n ${var.namespace} apply -f- <<'EOF'\n${local.clusterissuers}\nEOF"
  }
}

resource "null_resource" "cert-manager-pre-script" {
  count = var.install ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/${var.chart_version}/cert-manager.crds.yaml"
  }

  depends_on = [var.dependencies]
}

resource "kubernetes_secret" "cert_manager_awscreds" {
  metadata {
    name      = "cert-manager-awskey"
    namespace = var.namespace
  }

  data = {
    "secret-access-key" = aws_iam_access_key.cert_manager.secret
  }

  depends_on = [var.dependencies]
}
