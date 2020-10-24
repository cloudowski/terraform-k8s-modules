locals {
  configure_script = templatefile("${path.module}/configure-chat.sh.tmpl", {
    url              = "https://chat.${var.dns_domain}"
    jenkins_password = var.jenkins_password
    admin_username   = var.admin_username
    admin_pass       = var.admin_password
    }
  )
  configure_script_secret_name = "rocketchat-post-script"
  admin_pass_secret_name       = "rocketchat-admin-pass"
}

terraform {
  required_providers {
    helm = ">= 1.2.1"
  }
}


resource "helm_release" "rocketchat" {
  count            = var.install ? 1 : 0
  name             = var.name
  create_namespace = true
  namespace        = var.namespace
  chart            = "rocketchat"
  repository       = "https://rocketchat.github.io/helm-charts"
  version          = "3.0.1"


  set {
    type  = "string"
    name  = "host"
    value = "chat.${var.dns_domain}"
  }
  set {
    type  = "string"
    name  = "ingress.tls[0].hosts[0]"
    value = "chat.${var.dns_domain}"
  }
  set {
    type  = "string"
    name  = "extraEnv"
    value = <<EOF
- name: ADMIN_USERNAME
  valueFrom:
    secretKeyRef:
      name: ${local.admin_pass_secret_name}
      key: ADMIN_USERNAME
- name: ADMIN_PASS
  valueFrom:
    secretKeyRef:
      name: ${local.admin_pass_secret_name}
      key: ADMIN_PASS
- name: ADMIN_EMAIL
  valueFrom:
    secretKeyRef:
      name: ${local.admin_pass_secret_name}
      key: ADMIN_EMAIL
EOF
  }

  values = var.is_test ? [file("${path.module}/values.yaml"), file("${path.module}/values-test.yaml")] : [file("${path.module}/values.yaml")]

  depends_on = [var.dependencies]
}

resource "kubernetes_secret" "rocketchat_admin_pass" {
  count = var.install ? 1 : 0
  metadata {
    name      = local.admin_pass_secret_name
    namespace = var.namespace
  }

  data = {
    "ADMIN_PASS"     = var.admin_password
    "ADMIN_USERNAME" = var.admin_username
    "ADMIN_EMAIL"    = var.admin_email
  }

  depends_on = [var.dependencies]
}

resource "kubernetes_secret" "rocketchat_post_script" {
  count = var.install ? 1 : 0
  metadata {
    name      = local.configure_script_secret_name
    namespace = var.namespace
  }

  data = {
    "configure-chat.sh" = local.configure_script
  }

  depends_on = [var.dependencies]
}

resource "kubernetes_job" "configure-rocketchat" {
  count = var.install ? 1 : 0
  metadata {
    name      = "configure-rocketchat"
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
          args    = ["-c", "apk add jq httpie bash; sh -c /scripts/configure-chat.sh"]
          volume_mount {
            mount_path = "/scripts"
            name       = "rocketchat-post-script"
          }
        }
        volume {
          name = "rocketchat-post-script"
          secret {
            secret_name  = local.configure_script_secret_name
            default_mode = "0755"
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 10
  }

  depends_on = [var.dependencies]
}
