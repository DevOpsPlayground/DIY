This is the november playground

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| InstanceRole | The Role of the instance to take | `number` | `null` | no |
| PlaygroundName | The playground name to tag all resouces with | `string` | `"nov"` | no |
| WorkstationPassword | The password of the workstation ssh | `string` | `"playground"` | no |
| deploy_count | Change this for the number of users of the playground | `number` | `2` | no |
| instance_count | The amount of versions of the infrastructer to make | `number` | `1` | no |
| instance_type | instance type to be used for instances | `string` | `"t2.medium"` | no |
| instances | number of instances per dns record | `number` | `1` | no |
| policyLocation | The location of the policys | `string` | `"./../../policies"` | no |
| region | The aws region to deploy to | `string` | `"eu-west-2"` | no |
| scriptLocation | The location of the userData folder | `string` | `"./../../modules/instance/scripts"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| TFstateBucket | The TF state bucket name |
| WorkstationPassword | The password of the workstation |
| artifactBucket | The artifact bucket name |
| dns_jenkins | n/a |
| dns_workstation | n/a |
| jenkins_ips | The ip of the jenkins instances |
| workstation_ips | The ip of the workstation instances |

