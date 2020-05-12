variable "dns_domain" {
  type        = string
  description = "DNS domain name for the cluster"
}

variable "route53_region" {
  type = string
}

variable "namespace" {
  type = string
}

variable "chart_version" {
  type        = string
  description = "Version of the helm chart to install"
}

variable "install" {
  type = bool
}
