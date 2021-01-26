## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| PlaygroundName | The name of the playground for tagging | `string` | n/a | yes |
| acl | Sets the access Contol list for the bucket | `string` | `"public-read"` | no |
| purpose | A tag to give each resource | `string` | `"Playground"` | no |
| reason | The reason for the bucket so it can be found | `string` | `"Playground"` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | The name of the created bucket |

