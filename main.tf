terraform {
  required_version = ">= 0.12.1"

  required_providers {
    null = "~> 2.1"
    helm = "~> 1.1"
  }
}

provider "aws" {
  version = "~> 2.50"

  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}

data "aws_route53_zone" "targets" {
  count        = length(var.domains)
  name         = format("%s.", element(var.domains, count.index))
  private_zone = var.is_private_zone
}
