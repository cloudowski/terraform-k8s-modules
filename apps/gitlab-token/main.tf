data "external" "token" {
  program = ["bash", "${path.module}/scripts/get-token.sh"]
  # program = ["${path.module}/scripts/get-token.sh"]

  query = {
    gitlab_host     = var.gitlab_url
    gitlab_user     = "root"
    gitlab_password = var.gitlab_root_password
  }
}
