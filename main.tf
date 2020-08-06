terraform {
  required_version = ">= 0.12.1"

  required_providers {
    null = "~> 2.1"
    helm = "~> 1.1"
    aws  = "~> 2.50"
  }
}

data "aws_route53_zone" "targets" {
  count        = length(var.domains)
  name         = format("%s.", replace(var.domains[count.index], "/^\\./", ""))
  private_zone = var.is_private_zone
}
