variable "dns_domain" {
  type        = string
  description = "DNS domain name handled by cert-manager."
}

variable "aws_region" {
  default     = "us-east-1"
  type        = string
  description = "AWS region where cluster is installed."
}

variable "acme_email" {
  type        = string
  default     = ""
  description = "Email address used for registration in ACME service."
}

variable "solver" {
  description = "Which solver to use - route53 or ingress."
  default     = "route53"

  validation {
    condition     = var.solver == "route53" || var.solver == "ingress"
    error_message = "The solver must be 'route53' or 'ingress'."
  }
}

variable "namespace" {
  type        = string
  default     = "cert-manager"
  description = "Namespace for cert-manager."
}

variable "chart_version" {
  type        = string
  description = "Version of the helm chart to install"
  default     = "v1.7.1"
}

variable "kubeconfig" {
  type        = string
  description = "KUBECONFIG env variable value used by kubectl in scripts."
  default     = "~/.kube/config"
}

