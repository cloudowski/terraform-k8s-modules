terraform {
  required_providers {
    helm = ">= 1.2.1"
  }
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "helm_release" "external-dns" {
  name       = "external-dns-${random_string.suffix.result}"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.chart_version

  set {
    type  = "string"
    name  = "provider"
    value = "aws"
  }
  set {
    type  = "string"
    name  = "aws.zoneType"
    value = "public"
  }
  set {
    type  = "string"
    name  = "domainFilters[0]"
    value = var.dns_domain
  }

  set {
    type  = "string"
    name  = "aws.credentials.secretName"
    value = "extdns-awscreds-${random_string.suffix.result}"
  }

  depends_on = [kubernetes_secret.extdns_awscreds]

}


resource "kubernetes_secret" "extdns_awscreds" {
  metadata {
    name      = "extdns-awscreds-${random_string.suffix.result}"
    namespace = "kube-system"
  }

  data = {
    "credentials" = <<EOF
[default]
aws_access_key_id = ${aws_iam_access_key.extdns.id}
aws_secret_access_key = ${aws_iam_access_key.extdns.secret}
EOF
  }

  depends_on = [var.dependencies]
}

resource "aws_iam_user" "extdns" {
  name = "external-dns-${random_string.suffix.result}"
}

resource "aws_iam_access_key" "extdns" {
  user = aws_iam_user.extdns.name
}

resource "aws_iam_user_policy" "extdns" {
  name = "external-dns-${random_string.suffix.result}"
  user = aws_iam_user.extdns.name

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
        "route53:ListHostedZones",
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
