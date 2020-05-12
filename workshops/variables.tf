
variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "app_admin_password" {
  type        = string
  description = "Password for admin account to be set for applications that are configured automatically"
}

variable "is_test" {
  type = bool
}

variable "dns_domain" {
  type        = string
  description = "DNS domain name for the deployed applications"
}

variable "env_name" {
  type        = string
  description = "Name of the environment"
}

variable "install_apps" {
  type = list(string)
}

variable "install_addons" {
  type = list(string)
}

variable "app_namespace" {
  type        = string
  default     = "labs"
  description = "Namespace for workshops components"
}
