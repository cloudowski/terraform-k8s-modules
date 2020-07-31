resource "null_resource" "create_user" {
  for_each = toset(var.users)

  provisioner "local-exec" {
    command = "${path.module}/create-user.sh"
    environment = {
      GITLAB_URL = var.gitlab_url
      NAME       = each.key
      PASSWORD   = "P@ssw0rd"
      TOKEN      = var.token
    }
  }

}
