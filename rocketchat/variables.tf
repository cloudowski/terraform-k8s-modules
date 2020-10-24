variable "dns_domain" {
  type        = string
  description = "Prefix for DNS domain name"
}

variable "namespace" {
  type = string
}

variable "name" {
  type    = string
  default = "rocketchat"
}

variable "admin_username" {
  type = string
  # default = "cloudowski"
}

variable "admin_email" {
  type = string
  # default = "tomasz@cloudowski.com"
}

variable "admin_password" {
  type = string
}

variable "jenkins_password" {
  type    = string
  default = "J3nk1ns"
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
