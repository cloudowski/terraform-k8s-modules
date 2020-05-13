locals {
  gitea_url = "git.${var.dns_domain}"
  configure_script = templatefile("${path.module}/configure.sh.tmpl", {
    domain         = "git.${var.dns_domain}"
    admin_user     = var.admin_user
    admin_password = var.admin_password
    }
  )
  configure_script_secret_name = "gitea-post-script"
}

terraform {
  required_providers {
    helm = ">= 1.2.1"
  }
}

resource "helm_release" "gitea" {
  count            = var.install ? 1 : 0
  name             = "gitea"
  namespace        = var.namespace
  create_namespace = true
  chart            = "gitea"
  repository       = "https://charts.k8s.land"
  wait             = false

  set {
    type  = "string"
    name  = "service.http.externalHost"
    value = local.gitea_url
  }
  set {
    type  = "string"
    name  = "ingress.hostname"
    value = local.gitea_url
  }
  set {
    type  = "string"
    name  = "ingress.tls[0].hosts[0]"
    value = local.gitea_url
  }

  set_sensitive {
    type  = "string"
    name  = "mariadb.rootUser.password"
    value = var.admin_password
  }

  values = var.is_test ? [file("${path.module}/values.yaml"), file("${path.module}/values-test.yaml")] : [file("${path.module}/values.yaml")]

  depends_on = [var.dependencies]
}

resource "null_resource" "post-script-create-user" {
  count      = var.install ? 1 : 0
  depends_on = [helm_release.gitea]

  provisioner "local-exec" {
    command = "${path.module}/create-user.sh"
    environment = {
      DNSDOMAIN      = var.dns_domain
      ADMIN_USER     = var.admin_user
      ADMIN_PASSWORD = var.admin_password
      NAMESPACE      = var.namespace
    }
  }

}

resource "kubernetes_secret" "gitea_post_script" {
  count = var.install ? 1 : 0
  metadata {
    name      = "gitea-post-script"
    namespace = var.namespace
  }

  data = {
    "configure.sh" = local.configure_script
  }

  depends_on = [helm_release.gitea]
}

resource "kubernetes_job" "configure_gitea" {
  count = var.install ? 1 : 0
  metadata {
    name      = local.configure_script_secret_name
    namespace = var.namespace
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "alpine"
          image   = "alpine"
          command = ["sh"]
          args    = ["-c", "apk add jq curl bash; sh -c /scripts/configure.sh"]
          volume_mount {
            mount_path = "/scripts"
            name       = "gitea-post-script"
          }
        }
        volume {
          name = "gitea-post-script"
          secret {
            secret_name  = local.configure_script_secret_name
            default_mode = "0755"
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 4
  }

  depends_on = [helm_release.gitea]
}
