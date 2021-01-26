
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
  default     = "nov"
  description = "The playground name to tag all resouces with"
}
variable "WorkstationPassword" {
  type        = string
  default     = "playground"
  description = "The password of the workstation ssh"
}
variable "scriptLocation" {
  type        = string
  default     = "./modules/instance/scripts"
  description = "The location of the userData folder"
}
variable "policyLocation" {
  type       = string
  default    = "./policies"
  descrition = "The location of the policys"
}