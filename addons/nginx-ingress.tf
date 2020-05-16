resource "helm_release" "nginx-ingress" {
  count      = contains(var.install_addons, "nginx-ingress") ? 1 : 0
  name       = "nginx-ingress"
  namespace  = "kube-system"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "nginx-ingress"
  version    = "1.37.0"

  set {
    type  = "string"
    name  = "controller.publishService.enabled"
    value = "true"
  }
  depends_on = [var.dependencies]
}
