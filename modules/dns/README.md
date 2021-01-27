#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance_ips | List of IP's of the instances being used  the DNS hosted zone | `list(string)` | n/a | yes |
| instances | number of instances to create records for | `number` | n/a | yes |
| record_name | the name of the dns record to create | `string` | n/a | yes |
| record_ttl | defauly time to live for domain records | `number` | `300` | no |
| record_type | The dns record type to be used | `string` | `"A"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| name | name of dns record created |
| zone_id | n/a |

