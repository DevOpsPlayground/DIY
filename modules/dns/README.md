# DPG - dns module

This requires a hosted zone so for the average use will not be used.

example jenkins DNS module

``` HCL
  depends_on   = [module.jenkins]
  instances    = 1
  instance_ips = module.jenkins.public_ip
  record_name  = "happy-panda"
```

This will create a DNS record for an instances ip with the prefix of happy-panda

i.e happy-panda.devopsplayground.org

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
| zone_id | The id of the zone the record is in |

