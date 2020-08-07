output "iam_role_arn" {
  value = local.iam_role_arn
}

output "iam_role_external_id" {
  value = var.iam_role_external_id == "-" ? "" : local.iam_role_external_id
}
