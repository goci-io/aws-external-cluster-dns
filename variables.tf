variable "name" {
  type        = string
  default     = "external-dns"
  description = "Name of the external-dns helm release and deployment"
}

variable "stage" {
  default     = ""
  description = "The stage the instance will run in"
}

variable "namespace" {
  default     = ""
  description = "Company or organization prefix"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "cluster_fqdn" {
  type        = string
  description = "The full qualified domain name for the cluster root domain (basically the ingress root dns name)"
}

variable "aws_region" {
  description = "The region external-dns is available in"
}

variable "domains" {
  type        = list(string)
  description = "A list of domains external-dns deployment can handle for you"
}

variable "helm_release_version" {
  type        = string
  default     = "2.21.1"
  description = "The version of the helm chart to use"
}

variable "helm_values_root" {
  type        = string
  default     = "."
  description = "Path to the directory containing values.yaml for helm to overwrite any defaults"
}

variable "iam_role_trust_relations" {
  type        = list(object({ type = string, identifiers = list(string) }))
  description = "The IAM trust relations for the role created for external-dns"
  default     = [{
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
  }]
}

variable "update_records_policy" {
  type        = string
  default     = "sync"
  description = "Policy how records are set. Sync or upsert-only for example"
}

variable "is_private_zone" {
  type        = bool
  default     = false
  description = "Type of the hosted zones specified in domains"
}
