# DPG - s3 module

This module creates an S3 bucket to store our Terraform state file as well and build artifact to launch our application.

```hcl
module "tfStateBucket" {
  source         = "./../../modules/s3"
  PlaygroundName = var.PlaygroundName
  reason         = "tfstate"
}
module "artifactBucket" {
  source         = "./../../modules/s3"
  PlaygroundName = var.PlaygroundName
  reason         = "artifact"
}
```

This will create 2 buckets one called playgroundtfstate and another called playgroundartifact. Both the buckets have a random string of numbers after them to make sure they are always unique.

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| PlaygroundName | The name of the playground for tagging | `string` | n/a | yes |
| acl | Sets the access Contol list for the bucket | `string` | `"public-read"` | no |
| purpose | A tag to give each resource | `string` | `"Playground"` | no |
| reason | The reason for the bucket so it can be found | `string` | `"Playground"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| name | The name of the created bucket |

