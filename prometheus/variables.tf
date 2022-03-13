variable "dns_domain" {
  type        = string
  description = "DNS domain name for the cluster"
}

variable "namespace" {
  type = string
}

variable "name" {
  type    = string
  default = "prometheus"
}

variable "install" {
  type    = bool
  default = true
}

variable "chart_version" {
  type    = string
  default = "33.2.1"
}

variable "is_test" {
  type    = bool
  default = true
}

variable "admin_password" {
  type = string
}

variable "dependencies" {
  type    = list(string)
  default = []
}

variable "grafana_custom_config" {
  type    = string
  default = ""
}
