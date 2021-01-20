variable "cidr_block" {
  default     = "10.0.0.0/16"
  description = "Internal CIDR Block for the VPC"
}

variable "public_subnets" {
  default     = 2
  description = "Number of Public subnets in the VPC. By default this number is 2, and should always be higher or equal to 2, so a load balancer and other resources could be created without AWS complaining"
}

variable "private_subnets" {
  default     = 0
  description = "Number of Private subnets in the VPC. By default this number is 0. If you create private subnets, you perhaps want to put autoscaling groups and/or loadbalancers into it, so mind that you'll probably need more than 1."
}

variable "PlaygroundName" {
  description = "The name of the playground for tagging"
}