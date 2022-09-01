variable "dns_domain" {
  type        = string
  description = "DNS domain name for the cluster"
}

variable "namespace" {
  type = string
}

variable "name" {
  type    = string
  default = "gitlab"
}

variable "install" {
  type    = bool
  default = true
}

variable "is_test" {
  type    = bool
  default = true
}

variable "dependencies" {
  type    = list(string)
  default = []
}

variable "chart_version" {
  default = "6.3.2"
}
