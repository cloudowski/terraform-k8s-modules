terraform {
  required_providers {
    helm = ">= 1.2.1"
  }
}

resource "helm_release" "jenkins" {
  count            = var.install ? 1 : 0
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "3.2.4"

  values = var.is_test ? [file("${path.module}/values.yaml"), file("${path.module}/values-test.yaml")] : [file("${path.module}/values.yaml")]

  set {
    type  = "string"
    name  = "controller.ingress.hostName"
    value = "jenkins.${var.dns_domain}"
  }

  set {
    type  = "string"
    name  = "controller.adminPassword"
    value = var.admin_password
  }

  set {
    type  = "string"
    name  = "controller.ingress.tls[0].hosts[0]"
    value = "jenkins.${var.dns_domain}"
  }
}

resource "null_resource" "jenkins-post-script" {
  count      = var.install ? 1 : 0
  depends_on = [helm_release.jenkins]

  provisioner "local-exec" {
    command = <<EOT
      kubectl -n ${var.namespace} apply  -f ${path.module}/casc/
    EOT
    environment = {
      KUBECONFIG = var.kubeconfig
    }
  }
}

resource "kubernetes_service_account" "deployer" {
  count = var.install ? 1 : 0
  metadata {
    name      = "deployer"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding" "jenkins-deployer-admin" {
  count = var.install ? 1 : 0
  metadata {
    name = "jenkins-deployer-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "deployer"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding" "jenkins-edit" {
  count = var.install ? 1 : 0
  metadata {
    name = "jenkins-edit"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = var.namespace
  }
}
