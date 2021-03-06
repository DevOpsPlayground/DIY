
variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "The aws region to deploy to"
}
variable "instance_count" {
  type        = number
  default     = 1
  description = "The number of instances to create for each user"
}
variable "PlaygroundName" {
  type        = string
  default     = "oct-2020"
  description = "The playground name to tag all resouces with"
}
# variable "domain_name" {
#   type        = string
#   description = "Your own registered domain name if using dns module"
# }
variable "WorkstationPassword" {
  type        = string
  default     = "playground"
  description = "The password of the workstation ssh"
}

// PLEASE TAKE CARE WHEN EDITING THIS DUE TO COSTS. 

variable "deploy_count" {
  type        = number
  description = "Number of versions of the infrastructure to create - change this for the number of users in the playground"
  default     = 1
}
variable "InstanceRole" {
  type        = number
  default     = null
  description = "The Role of the instance to take"
}
variable "instance_type" {
  type        = string
  description = "instance type to be used for instances"
  default     = "t2.medium"
}
variable "scriptLocation" {
  type        = string
  default     = "./../../modules/instance/scripts"
  description = "The location of the userData folder"
}
variable "policyLocation" {
  type        = string
  default     = "./../../policies"
  description = "The location of the policys"
}
