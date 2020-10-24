output "namespace" {
  value = local.ns
}

output "password" {
  value = random_string.password.result
}
