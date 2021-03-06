resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "aws_iam_user" "cert_manager" {
  count = var.solver == "route53" ? 1 : 0
  name  = "cert-manager-${random_string.suffix.result}"
}

resource "aws_iam_access_key" "cert_manager" {
  count = var.solver == "route53" ? 1 : 0
  user  = aws_iam_user.cert_manager[0].name
}

resource "aws_iam_user_policy" "cert_manager" {
  count = var.solver == "route53" ? 1 : 0
  name  = "cert-manager-${random_string.suffix.result}"
  user  = aws_iam_user.cert_manager[0].name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:GetChange",
        "route53:ListHostedZones",
        "route53:ListHostedZonesByName",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

