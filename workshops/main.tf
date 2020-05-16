# resource "random_string" "suffix" {
#   length  = 8
#   special = false
#   upper   = false
# }

module "addons" {
  source         = "../addons/"
  dependencies   = local.app_deps
  install_addons = var.install_addons
}

module "dns" {
  source       = "../dns-aws"
  dns_domain   = var.dns_domain
  dependencies = local.app_deps
}
