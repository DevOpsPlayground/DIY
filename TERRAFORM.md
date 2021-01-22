## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| PlaygroundName | The playground name to tag all resouces with | `string` | `"nov"` | no |
| WorkstationPassword | The password of the workstation ssh | `string` | `"playground"` | no |
| instance\_count | The amount of versions of the infrastructer to make | `number` | `1` | no |
| region | The aws region to deploy to | `string` | `"eu-west-2"` | no |
| use | purpose of the instances being created | `string` | `"jenkins"` | no |

## Outputs

| Name | Description |
|------|-------------|
| WorkstationPassword | n/a |
| jenkins\_ips | n/a |
| workstation\_ips | n/a |

