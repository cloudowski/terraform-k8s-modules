variable "dns_domain" {
  type        = string
  description = "DNS domain name to use"
}

variable "dependencies" {
  type    = list(string)
  default = []
}

variable "namespace" {
  default = "kube-system"
}

variable "chart_version" {
  default = "6.8.1"
}
