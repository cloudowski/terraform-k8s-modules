resource "helm_release" "nginx-ingress" {
  count      = contains(var.install_addons, "nginx-ingress") ? 1 : 0
  name       = "nginx-ingress"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.18"

  set {
    type  = "string"
    name  = "controller.publishService.enabled"
    value = "true"
  }
  set {
    type  = "string"
    name  = "controller.ingressClassResource.default"
    value = "true"
  }
  depends_on = [var.dependencies]
}
