resource "helm_release" "nginx-ingress" {
  count      = contains(var.install_addons, "nginx-ingress") ? 1 : 0
  name       = "nginx-ingress"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "3.24.0"

  set {
    type  = "string"
    name  = "controller.publishService.enabled"
    value = "true"
  }
  depends_on = [var.dependencies]
}
