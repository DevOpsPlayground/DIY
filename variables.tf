
variable "region" {
  default     = "eu-west-2"
  description = "The aws region to deploy to"
}
variable "instance_count" {
  default     = 1
  description = "The amount of versions of the infrastructer to make "
}
variable "PlaygroundName" {
  default     = "nov"
  description = "The playground name to tag all resouces with"
}
variable "WorkstationPassword" {
  default     = "playground"
  description = "The password of the workstation ssh"
}
variable "use" {
  description = "purpose of the instances being created"
  default = "jenkins" 
}