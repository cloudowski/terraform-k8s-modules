variable "dns_domain" {
  type        = string
  description = "DNS domain name for the cluster"
}

variable "namespace" {
  type = string
}

variable "name" {
  type    = string
  default = "jenkins"
}

variable "install" {
  type    = bool
  default = true
}

variable "is_test" {
  type    = bool
  default = true
}

variable "admin_password" {
  type = string
}

variable "kubeconfig" {
  type        = string
  description = "KUBECONFIG env variable value used by kubectl in scripts."
  default     = "~/.kube/config"
}
