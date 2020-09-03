variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region to configure vault secret engine with"
}

variable "user_list" {
  type        = list(string)
  description = "List of names for vault aws secret backend configuration. Used to create necessary AWS resources."
  default     = []
}
