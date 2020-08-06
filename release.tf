resource "helm_release" "external_dns" {
  name       = var.name
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = var.k8s_namespace
  version    = var.helm_release_version

  values = [
    templatefile("${path.module}/defaults.yaml", {
      domains             = var.domains
      aws_region          = var.aws_region
      update_policy       = var.update_records_policy
      iam_role_arn        = coalesce(module.iam_role.role_arn, var.iam_role_arn)
      iam_external_id     = coalesce(module.iam_role.external_id, var.iam_role_external_id, "-")
      set_assume_config   = var.apply_assume_role_config
      set_kiam_annotation = var.configure_kiam
      hosted_zone_ids     = data.aws_route53_zone.targets.*.zone_id
      owner_id            = join("/", [var.cluster_fqdn, var.k8s_namespace])
    }),
    file("${var.helm_values_root}/values.yaml"),
  ]
}
