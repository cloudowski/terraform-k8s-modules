output "kubeconfig" {
  value = base64decode(data.external.kubeconfig.result.kubeconfig_base64)
}
