variable "dns_domain" {
  type        = string
  description = "DNS domain name for the cluster"
}

variable "namespace" {
  type = string
}

variable "name" {
  type    = string
  default = "harbor"
}

variable "install" {
  type    = bool
  default = true
}

variable "is_test" {
  type    = bool
  default = true
}

variable "wait_for_helm" {
  type    = bool
  default = true
}

variable "dependencies" {
  type    = list(string)
  default = []
}

variable "admin_password" {
  type = string
}
