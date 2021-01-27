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
