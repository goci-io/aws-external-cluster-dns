module "iam_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace  = var.namespace
  stage      = var.stage
  delimiter  = var.delimiter
  tags       = var.tags
  attributes = concat(var.attributes, list(var.region))
  name       = var.name
}

locals {
  iam_role_name = var.iam_role_name_override == "" ? module.iam_label.id : var.iam_role_name_override
}

data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = var.iam_role_trust_relations

      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }
}

resource "aws_iam_role" "external_dns" {
  name               = local.iam_role_name_override
  tags               = module.iam_label.tags
  description        = "Grants permissions to external-dns to change records in the hosted zones on your behalf"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

data "aws_iam_policy_document" "hosted_zone_access" {
  statement {
    sid    = "GrantModifyAccessToDomains"
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = formatlist(
      "arn:aws:route53:::hostedzone/%s",
      data.aws_route53_zone.targets.*.zone_id
    )
  }

  statement {
    sid       = "GrantListAccessToDomains"
    resources = ["*"]
    effect    = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]
  }
}

resource "aws_iam_role_policy" "hosted_zone_access" {
  policy = data.aws_iam_policy_document.hosted_zone_access.json
  role   = aws_iam_role.external_dns.name
}

