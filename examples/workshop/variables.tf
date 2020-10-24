variable "aws_region" {
  default = "us-east-1"
}
variable "dns_domain" {
  default = "k8sworkshops.com"
}
variable "namespace" {
  default = "demoworkshop"
}
variable "kubeconfig" {}
variable "is_test" {
  default = true
}
