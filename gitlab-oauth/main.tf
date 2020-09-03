resource "null_resource" "configure_oauth" {

  provisioner "local-exec" {
    command = "${path.module}/configure-oauth.sh"
    environment = {
      GITLAB_URL   = var.gitlab_url
      TOKEN        = var.token
      NAME         = var.application_name
      REDIRECT_URI = var.application_redirect_uri
      SCOPES       = var.scopes
    }
  }

}
