# DPG - rolePolicy module

example

``` HCL
module "Jenkins_role" {
  count          = 1
  source         = "./../../modules/rolePolicy"
  PlaygroundName = var.PlaygroundName
  role_policy    = file("${var.policyLocation}/assume_role.json")
  aws_iam_policy = { autoscale = file("${var.policyLocation}/jenkins_autoscale.json"), ec2 = file("${var.policyLocation}/jenkins_ec2.json"), elb = file("${var.policyLocation}/jenkins_elb.json"), iam = file("${var.policyLocation}/jenkins_iam.json"), s3 = file("${var.policyLocation}/jenkins_s3.json") }
}
```

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| PlaygroundName | The name of the playground for tagging | `string` | n/a | yes |
| aws_iam_policy | The Policy to attach to the file | `map(string)` | n/a | yes |
| role_policy | The role policy file | `string` | n/a | yes |
| purpose | A tag to give each resource | `string` | `"Playground"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| role | The name of the created role |

