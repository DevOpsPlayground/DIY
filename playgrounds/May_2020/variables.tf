
variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "The aws region to deploy to"
}
variable "instance_count" {
  type        = number
  default     = 1
  description = "The amount of versions of the infrastructer to make "
}
variable "PlaygroundName" {
  type        = string
  default     = "may"
  description = "The playground name to tag all resouces with"
}
variable "instances" {
  type        = number
  default     = 1
  description = "number of instances per dns record"
}
variable "rds_db_name" {
  type        = string
  default     = "maypanda"
  description = "RDS database name"
}
# variable "domain_name" {
#   type        = string
#   default     = "devopsplayground.org"
#   description = "Your own registered domain name if using dns module"
# }

// PLEASE TAKE CARE WHEN EDITING THIS DUE TO COSTS. 

variable "deploy_count" {
  type        = number
  description = "Change this for the number of users of the playground"
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

variable "username" {
  type        = string
  default     = "playground"
  description = "The default username for the rds instance."
}
