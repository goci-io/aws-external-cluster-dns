module "iam_role" {
  source           = "git::https://github.com/goci-io/aws-iam-assumable-role.git?ref=tags/0.1.1"
  enabled          = var.create_iam_role
  namespace        = var.namespace
  stage            = var.stage
  attributes       = concat(var.attributes, list(var.region))
  name             = var.name
  with_external_id = var.iam_role_create_external_id
  trusted_iam_arns = var.iam_role_trusted_arns
  trusted_services = var.iam_role_trusted_services
  policy_statements = [
    {
      effect  = "Allow"
      actions = ["route53:ChangeResourceRecordSets", "route53:ListResourceRecordSets"]
      resources = formatlist(
        "arn:aws:route53:::hostedzone/%s",
        data.aws_route53_zone.targets.*.zone_id
      )
    },
    {
      resources = ["*"]
      effect    = "Allow"
      actions   = ["route53:ListHostedZones"]
    }
  ]
}

resource "aws_iam_role_policy" "zone_access" {
  count = var.iam_attach_policy ? 1 : 0
  name  = module.iam_role.role_id
  role  = module.iam_role.role_id
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ],
        "Effect": "Allow",
        "Resource": ${formatlist(
  "arn:aws:route53:::hostedzone/%s",
  data.aws_route53_zone.targets.*.zone_id
)}
      }
    ]
  }
EOF
}
