
data "helm_repository" "bitnami" {
  name = "bitnami"
  url  = "https://charts.bitnami.com/bitnami"
}

resource "helm_release" "external_dns" {
  name       = var.name
  chart      = "external-dns"
  repository = data.helm_repository.bitnami.metadata.0.name
  namespace  = var.k8s_namespace
  version    = var.helm_release_version

  values = [
    templatefile("${path.module}/defaults.yaml", {
      hosted_zone_ids = data.aws_route53_zone.targets.*.zone_id
      domains         = var.domains
      aws_region      = var.aws_region
      iam_role_arn    = aws_iam_role.external_dns.arn
      update_policy   = var.update_records_policy
      owner_id        = join("/", [var.cluster_fqdn, var.k8s_namespace])
    }),
    file("${var.helm_values_root}/values.yaml"),
  ]
}
