## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| InstanceRole | The Role of the instance to take | `string` | `""` | no |
| PlaygroundName | The name of the playground for tagging | `any` | n/a | yes |
| ami | The ami to run on the instance | `string` | `"false"` | no |
| amiName | n/a | `string` | `"amzn2-ami-hvm*"` | no |
| amiOwner | n/a | `string` | `"amazon"` | no |
| instance\_count | The amount of instances to create | `number` | `1` | no |
| instance\_type | The type of instance | `string` | `"t2.micro"` | no |
| profile | n/a | `any` | n/a | yes |
| security\_group\_ids | An array of security groups for the instance | `any` | n/a | yes |
| subnet\_id | The id of the subnet | `any` | n/a | yes |
| user\_data | Custom user data to run on first start | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| public\_ips | n/a |

