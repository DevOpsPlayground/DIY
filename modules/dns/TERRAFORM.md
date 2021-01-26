## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance\_ips | List of IP's of the instances being used  the DNS hosted zone | `any` | n/a | yes |
| instances | number of instances to create records for | `any` | n/a | yes |
| record\_name | the name of the dns record to create | `any` | n/a | yes |
| record\_ttl | defauly time to live for domain records | `number` | `300` | no |
| record\_type | The dns record type to be used | `string` | `"A"` | no |

## Outputs

No output.

