# aws-external-cluster-dns

#### Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)

![terraform](https://github.com/goci-io/aws-external-cluster-dns/workflows/terraform/badge.svg?branch=master)

This module provides [`external-dns`](https://github.com/helm/charts/tree/master/stable/external-dns) as preconfigured helm release. 
Based on kubernetes Ingress objects Route53 records are created in their corresponding Route 53 Hosted Zone.

You can use [aws-route53-zone](https://github.com/goci-io/aws-route53-zone) module to create a Hosted Zone on AWS Route53.

### Usage

```hcl
module "external_dns" {
  source       = "git::https://github.com/goci-io/aws-external-cluster-dns.git?ref=tags/<latest-version>"
  namespace    = "goci"
  stage        = "corp"
  region       = "eu1"
  aws_region   = "eu-central-1"
  cluster_fqdn = "corp.eu1.goci.io"
  domains      = ["services.corp.eu1.goci.io"]
}
```

### IAM Role

To create an IAM Role or use an existing Role for External DNS you can specify the following variables:

- `create_iam_role` Creates a dedicated IAM Role
- `iam_role_trusted_arns` Trusted IAM ARNs
- `iam_role_trusted_services` Trusted AWS Services
- `iam_role_create_external_id` Allows sts:Assume only with External ID set

Using an existing Role:

- `iam_role_arn` ARN of existing IAM Role
- `iam_attach_policy` Attaches required Permissions to the Role
- `iam_role_external_id` External ID required to assume specified iam_role_arn

### Migrate DNS records

In case you already have an existing Record you want external-dns to manage you will need allow external-dns to own the record.
By adding a `txt.` prefixed record you grant external-dns permission to change these records on your behalf.

1. Deploy your application  
2. Add a new `TXT` record to your hosted zone  
2.1. Prefix the record with `txt.`   
(eg: `my-service.domain.com` -> `txt.my-service.domain.com`)  
3. Wait for external-dns to update the record (takes up to 2minutes)

Owner-Validation Record value:  
```txt
"heritage=external-dns,external-dns/owner=<cluster_fqdn>/<k8s_namespace>"
```


external-dns will update the existing record to point to our traffic load balancer dns.

**Suggestion:** You can add multiple hosts to an ingress or service. 
When migrating a record (specifically production records), create another host/domain for your deployment which can be tested before switching the record (validate that the service is reachable, then add the `txt` record for the "production" hosted zone).
