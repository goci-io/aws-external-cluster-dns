terraform {
  required_version = ">= 0.12.1"

  required_providers {
    null = "~> 2.1"
    helm = "~> 1.1"
    aws  = "~> 2.50"
  }
}

locals {
  domains = compact(var.domains)
}

data "aws_route53_zone" "targets" {
  count        = length(local.domains)
  name         = format("%s.", trim(local.domains[count.index], "."))
  private_zone = var.is_private_zone
}
