resource "helm_release" "metrics-server" {
  count      = contains(var.install_addons, "metrics-server") ? 1 : 0
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "metrics-server"
  version    = "2.11.1"
  depends_on = [var.dependencies]
}
