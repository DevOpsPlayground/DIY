## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| InstanceRole | The Role of the instance to take | `string` | `""` | no |
| PlaygroundName | The name of the playground for tagging | `string` | n/a | yes |
| amiName | The name of the ami to run on the instance | `string` | `"amzn2-ami-hvm*"` | no |
| amiOwner | The Owner of the ami to run on the instance | `string` | `"amazon"` | no |
| associate\_public\_ip\_address | Should aws give the instance a public ip | `bool` | `true` | no |
| instance\_count | The amount of instances to create | `number` | `1` | no |
| instance\_type | The type of instance | `string` | `"t2.micro"` | no |
| purpose | A tag to give each resource | `string` | `"Playground"` | no |
| security\_group\_ids | An array of security groups for the instance | `list(string)` | n/a | yes |
| subnet\_id | The id of the subnet | `string` | n/a | yes |
| user\_data | Custom user data to run on first start | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| public\_ips | n/a |

