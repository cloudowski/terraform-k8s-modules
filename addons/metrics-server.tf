resource "helm_release" "metrics-server" {
  count      = contains(var.install_addons, "metrics-server") ? 1 : 0
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "metrics-server"
  version    = "2.11.1"
  # depends_on = [var.k8s_endpoint]
}
