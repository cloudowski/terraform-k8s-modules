data "external" "token" {
  program = ["bash", "${path.module}/scripts/get-token.sh"]

  query = {
    gitlab_host     = var.gitlab_url
    gitlab_user     = var.gitlab_user
    gitlab_password = var.gitlab_password
  }
}
