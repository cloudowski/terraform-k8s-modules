output "role_arns" {
  value = { for u in aws_iam_role.eks_user : u.name => u.arn }
}
