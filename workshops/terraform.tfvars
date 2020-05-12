aws_region     = "eu-west-1"
aws_profile    = "cloudowski"
dns_domain     = "k8sworkshops.com"
env_name       = "demo"
is_test        = true
install_addons = ["nginx-ingress"]
install_apps = [
  "cert-manager",
  "gitea",
  "harbor",
  "jenkins",
  "rocketchat",
]
