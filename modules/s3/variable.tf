variable "reason" {
  default     = "Playground"
  description = "The reason for the bucket so it can be found"
}
variable "PlaygroundName" {
  type        = string
  description = "The name of the playground for tagging"
}
variable "purpose" {
  type        = string
  default     = "Playground"
  description = "A tag to give each resource"
}
variable "acl" {
  type        = string
  default     = "public-read"
  description = "Sets the access Contol list for the bucket"
}