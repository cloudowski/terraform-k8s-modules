variable "dns_domain" {
  type        = string
  description = "DNS domain name for the cluster"
}

variable "route53_region" {
  type    = string
  default = "eu-west-1"
}

variable "acme_email" {
  type    = string
  default = "tomasz@cloudowski.com"
}

variable "solver" {
  description = "Which solver to use - route53 or ingress"
  default     = "route53"

  # requires experimental feature
  # validation {
  #   condition     = var.solver == "route53" || var.solver == "ingress"
  #   error_message = "The solver must be 'route53' or 'ingress'"
  # }
}

variable "namespace" {
  type    = string
  default = "cert-manager"
}

variable "chart_version" {
  type        = string
  description = "Version of the helm chart to install"
  default     = "v0.15.0"
}

variable "install" {
  type = bool
}

variable "dependencies" {
  type    = list(string)
  default = []
}
