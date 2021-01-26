This is the november playground

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| PlaygroundName | The playground name to tag all resouces with | `string` | `"nov"` | no |
| WorkstationPassword | The password of the workstation ssh | `string` | `"playground"` | no |
| instance_count | The amount of versions of the infrastructer to make | `number` | `1` | no |
| policyLocation | The location of the policys | `string` | `"./policies"` | no |
| region | The aws region to deploy to | `string` | `"eu-west-2"` | no |
| scriptLocation | The location of the userData folder | `string` | `"./modules/instance/scripts"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| TFstateBucket | n/a |
| WorkstationPassword | The password of the workstation |
| artifactBucket | n/a |
| jenkins_ips | The ip of the jenkins instances |
| workstation_ips | The ip of the workstation instances |

