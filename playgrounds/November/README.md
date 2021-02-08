Welcome to the November playground!

[The Playground link](https://github.com/DevOpsPlayground/Hands-on-with-Jenkins-Terraform-and-AWS)

For this playground, we will be building an automated CI/CD pipeline that deploys a scalable React web application to AWS. Here's an overview of what we'll cover:

* Write a Jenkins DSL script. This allows us to define our pipeline configuration as code (Pipeline as Code).
* Trigger a build of this script which will create a new, empty pipeline that is configured with all the settings we need.
* Write *another* script for the newly created pipeline which will define the various stages our application needs to go through before being deployed to AWS. These include:
    - Building the application.
    - Testing it.
    - Deploying it to an AWS autoscaling group using terraform (Infrastructure as Code).

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| InstanceRole | The Role of the instance to take | `number` | `null` | no |
| PlaygroundName | The playground name to tag all resouces with | `string` | `"nov"` | no |
| deploy_count | Change this for the number of users of the playground | `number` | `1` | no |
| instance_count | The amount of versions of the infrastructer to make | `number` | `1` | no |
| instance_type | instance type to be used for instances | `string` | `"t2.medium"` | no |
| instances | number of instances per dns record | `number` | `1` | no |
| policyLocation | The location of the policys | `string` | `"./../../policies"` | no |
| region | The aws region to deploy to | `string` | `"eu-west-2"` | no |
| scriptLocation | The location of the userData folder | `string` | `"./../../modules/instance/scripts"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| TFstateBucket | The TF state bucket name |
| artifactBucket | The artifact bucket name |
| jenkins_ips | The ip of the jenkins instances |

