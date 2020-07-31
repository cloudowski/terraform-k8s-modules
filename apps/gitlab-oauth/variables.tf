variable "application_name" {
  type = string
}

variable "application_redirect_uri" {
  type = string
}

variable "scopes" {
  type    = string
  default = "email profile openid"
}

variable "token" {
  type = string
}

variable "gitlab_url" {
  type = string
}
