# variable "k8s_endpoint" {
#   type = string
# }

variable "install_addons" {
  type    = list(string)
  default = []
}
