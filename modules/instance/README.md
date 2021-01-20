## Requirements

No requirements.

## Providers

The following providers are used by this module:

- aws

## Required Inputs

The following input variables are required:

### PlaygroundName

Description: The name of the playground for tagging

Type: `any`

### security\_group\_ids

Description: An array of security groups for the instance

Type: `any`

### subnet\_id

Description: The id of the subnet

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### InstanceRole

Description: The Role of the instance to take

Type: `string`

Default: `""`

### ami

Description: The ami to run on the instance

Type: `string`

Default: `"false"`

### instance\_count

Description: The amount of instances to create

Type: `number`

Default: `1`

### instance\_type

Description: The type of instance

Type: `string`

Default: `"t2.micro"`

### user\_data

Description: Custom user data to run on first start

Type: `string`

Default: `""`

## Outputs

The following outputs are exported:

### public\_ips

Description: n/a

