resource "helm_release" "metrics-server" {
  count      = contains(var.install_addons, "metrics-server") ? 1 : 0
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  version    = "5.8.0"
  depends_on = [var.dependencies]
}
