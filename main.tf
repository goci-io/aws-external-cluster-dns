terraform {
  required_version = ">= 0.12.1"

  required_providers {
    null = "~> 2.1"
    helm = "~> 1.1"
    aws  = "~> 2.50"
  }
}

locals {
  domains = toset(compact(var.domains))
}

data "aws_route53_zone" "targets" {
  for_each     = local.domains
  name         = format("%s.", trim(each.value, "."))
  private_zone = var.is_private_zone
}
