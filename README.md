## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| InstanceRole | The Role of the instance to take | `bool` | `false` | no |
| PlaygroundName | The playground name to tag all resouces with | `string` | `"nov-"` | no |
| WorkstationPassword | The password of the workstation ssh | `string` | `"playground"` | no |

| deploy\_count | Change this for the number of users of the playground | `number` | `2` | no |
| instance\_count | The amount of versions of the infrastructer to make | `number` | `0` | no |
| instances | number of instances per dns record | `any` | n/a | yes |
| region | The aws region to deploy to | `string` | `"eu-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| WorkstationPassword | n/a |
| jenkins\_ips | n/a |
| workstation\_ips | n/a |

