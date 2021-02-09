variable "name" {
  type        = string
  description = "The name of the table"
}
variable "hashKey" {
  default     = "number"
  description = "The primary key of the table"

}
variable "attributes" {
  description = "list of attributes to add to the table."
  default = [
    {
      name = "number",
      type = "S",
    }
  ]
  type = list(object({ name = string, type = string }))
}

variable "billingMode" {
  description = "The default mode of billing DDB table"
  default     = "PAY_PER_REQUEST"

}

variable "PlaygroundName" {
}

