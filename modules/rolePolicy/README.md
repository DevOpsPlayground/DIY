# DPG - rolePolicy module

This creates the iam role.

example

``` HCL
  PlaygroundName = var.PlaygroundName
  role_policy    = assume_role.json")
  aws_iam_policy = { autoscale = file("jenkins_autoscale.json"), ec2 = file("jenkins_ec2.json")}

```

This will create a role that has the "jenkins_autoscale" and "jenkins_ec2") policys attached

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

