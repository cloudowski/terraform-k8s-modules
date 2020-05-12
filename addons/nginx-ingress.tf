resource "helm_release" "nginx-ingress" {
  count      = contains(var.install_addons, "nginx-ingress") ? 1 : 0
  name       = "nginx-ingress"
  namespace  = "kube-system"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "nginx-ingress"
  #   version    = "1.6.0"

  set_string {
    name  = "controller.publishService.enabled"
    value = "true"
  }
  # depends_on = [var.k8s_endpoint]
}
