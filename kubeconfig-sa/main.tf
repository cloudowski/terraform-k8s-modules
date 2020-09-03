data "external" "kubeconfig" {
  program = ["bash", "${path.module}/scripts/get-kubeconfig.sh"]

  query = {
    SERVICE_ACCOUNT_NAME = var.serviceaccount
    NAMESPACE            = var.namespace
  }
}
