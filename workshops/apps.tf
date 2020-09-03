locals {
  dns_domain = "${var.env_name}.${var.dns_domain}"
  app_deps   = [null_resource.namespaces.id]
}

# deleting namespaces often stucks in "Terminating"
# so let's not keep track of it in terraform state
resource "null_resource" "namespaces" {
  provisioner "local-exec" {
    command = <<EOT
      sleep 10
      kubectl get ns ${var.app_namespace} &> /dev/null || kubectl create ns ${var.app_namespace}
      kubectl get ns cert-manager &> /dev/null ||kubectl create ns cert-manager
    EOT
  }

  # TODO: fix this somehow - without this hardcode there are some leftovers that could create some fees (e.g. volumes)
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      kubectl get ns labs &> /dev/null && kubectl --wait=false delete ns labs
      kubectl get ns cert-manager &> /dev/null && kubectl --wait=false delete ns cert-manager
    EOT
  }
}


# kubectl delete pvc -n labs --all

module "cert-manager" {
  source     = "../cert-manager/"
  dns_domain = local.dns_domain
  namespace  = "cert-manager"
  # chart_version  = "v0.14.0"
  route53_region = var.aws_region
  install        = contains(var.install_apps, "cert-manager")
  dependencies   = local.app_deps
}

module "gitea" {
  source         = "../gitea/"
  dns_domain     = local.dns_domain
  namespace      = var.app_namespace
  admin_password = var.app_admin_password
  install        = contains(var.install_apps, "gitea")
  is_test        = var.is_test
  dependencies   = local.app_deps
}

module "gitlab" {
  source       = "../gitlab/"
  dns_domain   = local.dns_domain
  namespace    = var.app_namespace
  install      = contains(var.install_apps, "gitlab")
  is_test      = var.is_test
  dependencies = local.app_deps
}

module "harbor" {
  source         = "../harbor/"
  dns_domain     = local.dns_domain
  namespace      = var.app_namespace
  admin_password = var.app_admin_password
  install        = contains(var.install_apps, "harbor")
  is_test        = var.is_test
  dependencies   = local.app_deps
}

module "jenkins" {
  source         = "../jenkins/"
  dns_domain     = local.dns_domain
  namespace      = var.app_namespace
  admin_password = var.app_admin_password
  install        = contains(var.install_apps, "jenkins")
  is_test        = var.is_test
  dependencies   = local.app_deps
}

module "prometheus" {
  source         = "../prometheus/"
  dns_domain     = local.dns_domain
  namespace      = "prometheus"
  admin_password = var.app_admin_password
  install        = contains(var.install_apps, "prometheus")
  is_test        = var.is_test
  dependencies   = local.app_deps
}

module "rocketchat" {
  source       = "../rocketchat/"
  dns_domain   = local.dns_domain
  namespace    = var.app_namespace
  admin_pass   = var.app_admin_password
  install      = contains(var.install_apps, "rocketchat")
  is_test      = var.is_test
  dependencies = local.app_deps
}
