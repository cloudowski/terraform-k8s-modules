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
  type = bool
}

variable "is_test" {
  type    = bool
  default = true
}

variable "dependencies" {
  type    = list(string)
  default = []
}

variable "admin_password" {
  type    = string
  default = "mirabelka"
}
