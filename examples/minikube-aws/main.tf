provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  load_config_file       = false
  host                   = module.cluster.kubernetes_config["host"]
  cluster_ca_certificate = module.cluster.kubernetes_config["cluster_ca_certificate"]
  client_certificate     = module.cluster.kubernetes_config["client_certificate"]
  client_key             = module.cluster.kubernetes_config["client_key"]
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = module.cluster.kubernetes_config["host"]
    cluster_ca_certificate = module.cluster.kubernetes_config["cluster_ca_certificate"]
    client_certificate     = module.cluster.kubernetes_config["client_certificate"]
    client_key             = module.cluster.kubernetes_config["client_key"]
  }
}

locals {
  env_name        = "testdemo-${random_string.suffix.result}"
  full_dns_domain = "${local.env_name}.${var.dns_domain}"
  kubeconfig_file = "/tmp/kubeconfig-${local.env_name}"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

module "cluster" {
  #   source             = "../../../terraform-aws-minikube"
  source             = "cloudowski/minikube/aws"
  version            = "0.2.1"
  env_name           = local.env_name
  subnet_id          = element(data.aws_subnet_ids.default.ids[*], 1)
  vpc_id             = data.aws_vpc.default.id
  instance_type      = var.instance_type
  instance_disk_size = "25"
}

resource "null_resource" "save_kubeconfig" {
  provisioner "local-exec" {
    command = "echo \"${module.cluster.kubeconfig}\" > ${local.kubeconfig_file}"
  }
}

