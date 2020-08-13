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
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "region" {
  type        = string
  description = "Custom region name"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "k8s_namespace" {
  type        = string
  default     = "kube-system"
  description = "The kubernetes namespace to deploy the helm release into"
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

variable "create_iam_role" {
  type        = bool
  default     = true
  description = "Creates a new dedicated IAM Role for External-DNS"
}

variable "iam_attach_policy" {
  type        = bool
  default     = false
  description = "When using an existing Role ARN we can attach the required Policy to grant External DNS Permissions"
}

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "An existing IAM Role Arn to use instead of creating a new one"
}

variable "iam_role_external_id" {
  type        = string
  default     = ""
  description = "The External ID to be used when assuming the specified iam_role_arn"
}

variable "iam_role_trusted_services" {
  type        = list(string)
  description = "The IAM Services Trust Relations for the newly created External-DNS Role"
  default     = []
}

variable "iam_role_trusted_arns" {
  type        = list(string)
  description = "Trusted ARNs for the newly created External-DNS Role"
  default     = []
}

variable "iam_role_create_external_id" {
  type        = bool
  default     = false
  description = "When set to True creates a random UUID as External ID for the IAM Trust Relation Policy"
}

variable "apply_assume_role_config" {
  type        = bool
  default     = true
  description = "Configures the AWS provider for external dns to assume an IAM role. In case you use KIAM use configure_kiam instead."
}

variable "configure_kiam" {
  type        = bool
  default     = false
  description = "If set to true applies the KIAM IAM role annotation on the Pod Template"
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

variable "replicas" {
  type        = number
  default     = 1
  description = "Amount of Replicas for External-DNS. When set to 1 we also create a PodDisruptionBudget"
}

variable "psp_enabled" {
  type        = bool
  default     = false
  description = "When enabled creates a new PodSecurityPolicy and ClusterRole for External DNS. Its recommended to avoid creating a PSP per App."
}
