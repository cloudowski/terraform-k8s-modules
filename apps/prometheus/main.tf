resource "helm_release" "prometheus" {
  count            = var.install ? 1 : 0
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://kubernetes-charts.storage.googleapis.com"
  chart            = "prometheus-operator"
  version          = var.chart_version
  wait             = true

  values = var.is_test ? [file("${path.module}/values.yaml"), file("${path.module}/values-test.yaml")] : [file("${path.module}/values.yaml")]

  set {
    type  = "string"
    name  = "grafana.adminPassword"
    value = var.admin_password
  }

  set {
    type  = "string"
    name  = "grafana.ingress.hosts[0]"
    value = "grafana.${var.dns_domain}"
  }

  set {
    type  = "string"
    name  = "grafana.ingress.tls[0].hosts[0]"
    value = "grafana.${var.dns_domain}"
  }

  set {
    type  = "string"
    name  = "prometheus.ingress.tls[0].hosts[0]"
    value = "prometheus.${var.dns_domain}"
  }

  set {
    type  = "string"
    name  = "prometheus.ingress.hosts[0]"
    value = "prometheus.${var.dns_domain}"
  }

  set {
    type  = "string"
    name  = "alermanager.externalUrl"
    value = "https://am.${var.dns_domain}"
  }

  set {
    type  = "string"
    name  = "alermanager.ingress.tls[0].hosts[0]"
    value = "am.${var.dns_domain}"
  }

  set {
    type  = "string"
    name  = "alermanager.ingress.hosts[0]"
    value = "am.${var.dns_domain}"
  }

  depends_on = [var.dependencies]
}

resource "helm_release" "prometheus-adapter" {
  count            = var.install ? 1 : 0
  name             = "${var.name}-adapter"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://kubernetes-charts.storage.googleapis.com"
  chart            = "prometheus-adapter"
  wait             = true

  set {
    type  = "string"
    name  = "prometheus.url"
    value = "http://prometheus-prometheus-oper-prometheus.${var.namespace}.svc.cluster.local"
  }
}
