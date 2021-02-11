variable "role_policy" {
  type        = string
  description = "The role policy file"
}
variable "aws_iam_policy" {
  type        = map(string)
  description = "The Policy to attach to the file"
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