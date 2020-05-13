terraform {
  required_version = ">= 0.12.0"
}

# provider "google" {
#   version = "~> 3.12"
#   project = var.project
#   region  = var.gcp_region
# }

provider "aws" {
  version = ">= 2.28.1"
  region  = var.aws_region
  profile = var.aws_profile
}

# provider "digitalocean" {
# }

provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

provider "kubernetes" {
  # it doesn't work - let's be consistent and use kubeconfig for all k8s resources (kubectl commands and native resources)
  # host = data.google_container_cluster.this.endpoint
  # cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth.0.cluster_ca_certificate)
  # client_key             = base64decode(data.google_container_cluster.this.master_auth.0.client_key)
  # client_certificate     = base64decode(data.google_container_cluster.this.master_auth.0.client_certificate)
  load_config_file = true
  version          = "~> 1.11"
}

# provider "helm" {
#   debug   = false
#   version = "<= 1.1"
# }
