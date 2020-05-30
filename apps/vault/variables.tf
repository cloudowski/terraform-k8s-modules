variable "dns_domain" {
  type        = string
  description = "DNS domain name for the cluster"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace where to install vault"
}

variable "install" {
  type        = bool
  description = "To install or not - that is up to you"
  default     = true
}

variable "is_test" {
  type        = bool
  description = "For testing environments the staging letsencrypt api will be used for ingress"
  default     = true
}

variable "vault_init_output_file" {
  type        = string
  description = "Filename where to store 'vault operator init' command output"
}

variable "vault_version" {
  type        = string
  description = "Version of the helm chart to use"
  default     = "0.5.0"
}

variable "dependencies" {
  type        = list(string)
  default     = []
  description = "List of dependant resources - wait for them before starting the provisioning processs"
}

