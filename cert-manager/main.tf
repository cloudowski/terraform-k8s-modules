terraform {
  required_version = "~> 0.13.4"
  required_providers {
    helm = ">= 1.2.1"
  }
}

locals {
  issuers_template   = "clusterissuers-${var.solver}.yaml.tmpl"
  aws_iam_access_key = var.solver == "route53" ? aws_iam_access_key.cert_manager[0].id : ""
  clusterissuers = templatefile("${path.module}/${local.issuers_template}", {
    acme_email           = var.acme_email
    aws_region           = var.aws_region
    aws_access_key       = local.aws_iam_access_key
    aws_creds_secret     = "cert-manager-awskey"
    aws_creds_secret_key = "secret-access-key"
    aws_creds_secret_key = "secret-access-key"
    }
  )

}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.chart_version
  # chart = "/tmp/cert-manager/deploy/charts/cert-manager/"

  depends_on = [null_resource.cert-manager-pre-script]
}

resource "null_resource" "cert-manager-post-script" {
  depends_on = [helm_release.cert-manager]

  provisioner "local-exec" {
    command = "kubectl -n ${var.namespace} apply -f- <<'EOF'\n${local.clusterissuers}\nEOF"
    environment = {
      KUBECONFIG = var.kubeconfig
    }
  }
}

resource "null_resource" "cert-manager-pre-script" {
  provisioner "local-exec" {
    command = "kubectl apply --validate=false -f  https://github.com/cert-manager/cert-manager/releases/download/${var.chart_version}/cert-manager.crds.yaml"
    environment = {
      KUBECONFIG = var.kubeconfig
    }
  }
}

resource "kubernetes_secret" "cert_manager_awscreds" {
  count = var.solver == "route53" ? 1 : 0
  metadata {
    name      = "cert-manager-awskey"
    namespace = var.namespace
  }

  data = {
    "secret-access-key" = aws_iam_access_key.cert_manager[0].secret
  }

}
