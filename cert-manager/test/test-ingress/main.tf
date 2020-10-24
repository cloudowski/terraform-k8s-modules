variable "kubeconfig" {}
variable "dns_domain" {}

output "secret_name" { value = "cert-manager-test-${random_string.suffix.result}" }

locals {
  ingress = templatefile("${path.module}/ingress.yaml.tmpl", {
    name        = "cert-manager-test"
    secret_name = "cert-manager-test-${random_string.suffix.result}"
    host        = "cert-manager-test.${random_string.suffix.result}.${var.dns_domain}"
    }
  )
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "null_resource" "test-ingress" {
  provisioner "local-exec" {
    command = "kubectl apply -f- <<'EOF'\n${local.ingress}\nEOF"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete ing cert-manager-test"
  }
}
