data "aws_caller_identity" "current" {}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# aws user for vault root
resource "aws_iam_user" "vault_root" {
  name = "vault-root-${random_string.suffix.result}"
}

resource "aws_iam_access_key" "vault_root" {
  user = aws_iam_user.vault_root.name
}

resource "aws_iam_user_policy" "vault_root" {
  name = "vault-root-${random_string.suffix.result}"
  user = aws_iam_user.vault_root.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:AttachUserPolicy",
        "iam:CreateAccessKey",
        "iam:CreateUser",
        "iam:DeleteAccessKey",
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DetachUserPolicy",
        "iam:ListAccessKeys",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListUserPolicies",
        "iam:PutUserPolicy",
        "iam:RemoveUserFromGroup"
      ],
      "Resource": ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/vault-*"]
    }
  ]
}
EOF
}

# backend config

resource "vault_aws_secret_backend" "aws" {
  access_key = aws_iam_access_key.vault_root.id
  secret_key = aws_iam_access_key.vault_root.secret
  region     = var.region
}

# assumed_role config

resource "aws_iam_role" "eks_user" {
  for_each = toset(var.user_list)
  name     = each.key

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${aws_iam_user.vault_root.arn}"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_user_policy" "vault_eks" {
  for_each = toset(var.user_list)
  name     = "vault-root-${each.key}"
  user     = aws_iam_user.vault_root.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "${aws_iam_role.eks_user[each.key].arn}"
  }
}
EOF

}

resource "vault_aws_secret_backend_role" "eks_user" {
  for_each        = toset(var.user_list)
  backend         = vault_aws_secret_backend.aws.path
  name            = each.key
  credential_type = "assumed_role"

  role_arns = [
    aws_iam_role.eks_user[each.key].arn
  ]
}

resource "aws_iam_policy" "eks_basic" {
  name        = "eks-basic"
  description = "EKS basic user policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "eks:DescribeCluster"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_user" {
  for_each   = toset(var.user_list)
  role       = aws_iam_role.eks_user[each.key].name
  policy_arn = aws_iam_policy.eks_basic.arn
}
