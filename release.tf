locals {
  overwrite_file_path  = "${var.helm_values_root}/values.yaml"
  iam_role_arn         = coalesce(module.iam_role.role_arn, var.iam_role_arn)
  iam_role_external_id = coalesce(module.iam_role.external_id, var.iam_role_external_id, "-")
}

resource "helm_release" "external_dns" {
  name       = var.name
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = var.k8s_namespace
  version    = var.helm_release_version

  values = [
    templatefile("${path.module}/defaults.yaml", {
      domains             = var.domains
      replicas            = var.replicas
      aws_region          = var.aws_region
      psp_enabled         = var.psp_enabled
      update_policy       = var.update_records_policy
      iam_role_arn        = local.iam_role_arn
      iam_external_id     = local.iam_role_external_id
      set_assume_config   = var.apply_assume_role_config
      set_kiam_annotation = var.configure_kiam
      hosted_zone_ids     = data.aws_route53_zone.targets.*.zone_id
      owner_id            = join("/", [var.cluster_fqdn, var.k8s_namespace])
    }),
    fileexists(local.overwrite_file_path) ? file(local.overwrite_file_path) : "",
  ]
}

resource "kubernetes_pod_disruption_budget" "allow_unavailable" {
  count = var.replicas == 1 ? 1 : 0

  metadata {
    name      = var.name
    namespace = var.k8s_namespace
  }

  spec {
    max_unavailable = 1

    selector {
      match_labels = {
        app     = "external-dns"
        release = var.name
      }
    }
  }
}
