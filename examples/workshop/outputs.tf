# output "password" {
#   value = random_string.password.result
# }
output "dns_domain" {
  value = local.full_dns_domain
}
